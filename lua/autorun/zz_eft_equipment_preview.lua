-- Read-only, server-authoritative equipment snapshot for the replacement inventory.
if SERVER then
    AddCSLuaFile()
    util.AddNetworkString("ZCityEFT_EquipmentRequest")
    util.AddNetworkString("ZCityEFT_EquipmentState")
    local nextRequest = setmetatable({}, {__mode = "k"})
    net.Receive("ZCityEFT_EquipmentRequest", function(_, ply)
        if not IsValid(ply) or not ply:Alive() then return end
        if (nextRequest[ply] or 0) > CurTime() then return end
        nextRequest[ply] = CurTime() + 0.4
        local source = EFT and EFT.PlayerEquipment and EFT.PlayerEquipment[ply] or {}
        local equip = {}
        for _, slot in ipairs({"rig", "backpack", "vest", "helmet", "mask", "headphones"}) do
            local id = source[slot]
            if isstring(id) and id ~= "" then equip[slot] = id end
        end
        net.Start("ZCityEFT_EquipmentState")
        local armor = ply.armors or (ply.GetNetVar and ply:GetNetVar("Armor", {})) or {}
        local state = {equip=equip, armor=armor, grids={}}
        local function grid(key, items, w, h)
            local list = {}
            for _, it in ipairs(items or {}) do
                if #list >= 256 then break end
                list[#list+1] = {id=it.id, uniqueID=it.uniqueID, x=it.x, y=it.y,
                    w=it.w, h=it.h, rotated=it.rotated, count=it.count, examined=it.examined}
            end
            state.grids[key] = {items=list, w=w, h=h}
        end
        local cfg = EFT and EFT.Config or {}
        grid("personal", EFT and EFT.VirtualInventory and EFT.VirtualInventory[ply], cfg.PersonalGridBaseW or 2, cfg.PersonalGridBaseH or 5)
        for _, slot in ipairs({"rig", "backpack"}) do
            local db = EFT and EFT.ItemDatabase and EFT.ItemDatabase[equip[slot]]
            local storage = EFT and (slot == "rig" and EFT.RigContents or EFT.BackpackContents)
            if db and db.gridSize then
                grid(slot, storage and storage[source[slot .. "UID"]], db.gridSize.w, db.gridSize.h)
            end
        end
        state.loot = false
        local container = EFT and EFT.ActiveLooters and EFT.ActiveLooters[ply]
        if IsValid(container) and EFT.CanAccessInventoryContainer and EFT.CanAccessInventoryContainer(ply, container) then
            local size = EFT.ContainerGridSize[container] or {w=8,h=8}
            state.loot = {entity=container, items=EFT.ContainerStorage[container] or {}, w=size.w, h=size.h, name=container.CorpseOwner or "ЯЩИК"}
        elseif EFT and EFT.ActiveLooters then EFT.ActiveLooters[ply] = nil end
        net.WriteTable(state)
        net.Send(ply)
    end)
    return
end

ZCityEFTEmptyInventory = ZCityEFTEmptyInventory or {}
local UI = ZCityEFTEmptyInventory
local function database(id)
    return EFT and EFT.ItemDatabase and EFT.ItemDatabase[id] or nil
end
net.Receive("ZCityEFT_EquipmentState", function()
    local state = net.ReadTable() or {}
    if not IsValid(UI.Frame) then return end
    UI.State = state
    if UI.Loot then
        if state.loot == false then
            UI.Loot = nil
            if IsValid(UI.LootStorage) then UI.LootStorage:Clear() end
        elseif istable(state.loot) then UI.Loot = state.loot end
    end
    if UI.Refresh then UI.Refresh() end
end)

-- Look up the same attachment transforms as ZCity's worn armor renderer.
local function armorDescriptor(path)
    for _, group in pairs(hg and hg.armor or {}) do
        for _, data in pairs(group) do
            if istable(data) and data.model == path then return data end
        end
    end
end

function UI.BuildCharacter(frame, px)
    local view = vgui.Create("DModelPanel", frame)
    view:SetPos(px(22), px(130))
    view:SetSize(px(320), px(510))
    view:SetFOV(34)
    view:SetCamPos(Vector(115, 0, 40))
    view:SetLookAt(Vector(0, 0, 36))
    view:SetAmbientLight(Color(170, 170, 170))
    view:SetDirectionalLight(BOX_FRONT, Color(255, 235, 215))
    view:SetModel(LocalPlayer():GetModel())
    view:SetMouseInputEnabled(false)
    local yaw, nextAppearance, signature = 18, 0, ""
    local attachments = {}
    local function cleanup()
        for _, entry in ipairs(attachments) do
            if IsValid(entry.entity) then entry.entity:Remove() end
        end
        attachments = {}
    end
    local function addAttachment(id, path, data, slot)
        if not isstring(path) or path == "" then return end
        if not util.IsValidModel(path) then
            UI.MissingModels = UI.MissingModels or {}
            UI.MissingModels[path] = true
            return
        end
        local model = ClientsideModel(path, RENDERGROUP_OPAQUE)
        if not IsValid(model) then return end
        model:SetNoDraw(true)
        local desc = data or armorDescriptor(path)
        -- Bone-merge only models with an actual matching skeleton. Static props
        -- must use ZCity's bone-local offsets even if nobonemerge is absent.
        local boneName = desc and desc.bone or "ValveBiped.Bip01_Spine2"
        local merge = not (desc and desc.nobonemerge)
            and model:LookupBone(boneName) ~= nil
            and view.Entity:LookupBone(boneName) ~= nil
        if merge then
            model:SetParent(view.Entity)
            model:AddEffects(EF_BONEMERGE)
        end
        attachments[#attachments + 1] = {entity=model, data=desc, slot=slot, merge=merge, id=id}
    end
    view.LayoutEntity = function(self, ent)
        local ply = LocalPlayer()
        if not IsValid(ply) then return end
        if CurTime() >= nextAppearance then
            nextAppearance = CurTime() + 0.5
            if ent:GetModel() ~= ply:GetModel() then
                cleanup()
                signature = ""
                self:SetModel(ply:GetModel())
                ent = self.Entity
            end
            if not IsValid(ent) then return end
            ent:SetSkin(ply:GetSkin())
            ent:SetColor(ply:GetColor())
            ent:SetMaterial(ply:GetMaterial())
            ent.GetPlayerColor = function() return IsValid(ply) and ply:GetPlayerColor() or Vector(1, 1, 1) end
            for _, bg in ipairs(ply:GetBodyGroups()) do ent:SetBodygroup(bg.id, ply:GetBodygroup(bg.id)) end
            for i = 0, #ply:GetMaterials() - 1 do ent:SetSubMaterial(i, ply:GetSubMaterial(i)) end
            local seq = ent:LookupSequence("idle_all_01")
            if seq < 0 then seq = ent:LookupSequence("idle_unarmed") end
            if seq < 0 then seq = ent:SelectWeightedSequence(ACT_IDLE) end
            if seq >= 0 then ent:ResetSequence(seq) end
            local equip = UI.State and UI.State.equip or {}
            local armor = UI.State and UI.State.armor or (ply.GetNetVar and ply:GetNetVar("Armor", {}) or {})
            local current = util.TableToJSON({equip, armor}) .. ply:GetModel()
            if current ~= signature then
                cleanup()
                signature = current
                UI.MissingModels = {}
                local used = {}
                for slot, id in pairs(equip) do
                    local db = database(id)
                    if db and db.model then
                        addAttachment(id, db.model, nil, slot)
                        used[db.model] = true
                    end
                end
                for placement, id in pairs(armor) do
                    local desc = hg and hg.armor and hg.armor[placement] and hg.armor[placement][id]
                    if desc and not used[desc.model] then
                        addAttachment(id, desc.model, desc, placement)
                    end
                end
            end
        end
        ent:SetAngles(Angle(0, yaw, 0))
        ent:SetCycle(0)
        ent:InvalidateBoneCache()
        ent:SetupBones()
    end
    view.PostDrawModel = function(self, ent)
        local ply = LocalPlayer()
        local female = string.find(string.lower(ent:GetModel() or ""), "female", 1, true) ~= nil
        for _, entry in ipairs(attachments) do
            local model, d = entry.entity, entry.data
            if IsValid(model) then
                model:SetModelScale(d and ((female and d.femscale) or d.scale) or 1, 0)
                if d and IsValid(ply) then
                    model:SetSkin(ply:GetNWInt("ArmorSkins" .. entry.id, 0))
                    local material = istable(d.material) and d.material[1] or d.material or ""
                    model:SetSubMaterial(0, ply:GetNWString("ArmorMaterials" .. entry.id, material))
                end
                local visible = true
                if not entry.merge then
                    local bone = ent:LookupBone(d and d.bone or "ValveBiped.Bip01_Spine2")
                    local matrix = bone and ent:GetBoneMatrix(bone)
                    if matrix then
                        local pos, ang = matrix:GetTranslation(), matrix:GetAngles()
                        if female and d and d.femPos then
                            pos = pos + ang:Forward()*d.femPos[1] + ang:Up()*d.femPos[2] + ang:Right()*d.femPos[3]
                        end
                        local offset = d and d[3] or (entry.slot == "backpack" and Vector(0, -7, 0) or Vector(0, 5, 0))
                        local rotation = d and d[4] or Angle(0, 0, 0)
                        local origin, angles = LocalToWorld(offset, rotation, pos, ang)
                        model:SetPos(origin)
                        model:SetAngles(angles)
                    else visible = false end
                end
                if visible then model:InvalidateBoneCache() model:SetupBones() model:DrawModel() end
            end
        end
    end
    -- Preserve DModelPanel's own entity cleanup as well as our attached models.
    local baseRemove = view.OnRemove
    view.OnRemove = function(self)
        cleanup()
        if baseRemove then baseRemove(self) end
    end
    for _, direction in ipairs({-1, 1}) do
        local button = vgui.Create("DButton", frame)
        button:SetPos(px(direction == -1 and 108 or 204), px(660))
        button:SetSize(px(55), px(27))
        button:SetText(direction == -1 and "◀" or "▶")
        button:SetTextColor(Color(255, 152, 54))
        button.Paint = function(_, w, h)
            surface.SetDrawColor(55, 58, 61, 220) surface.DrawRect(0, 0, w, h)
            surface.SetDrawColor(100, 103, 106, 160) surface.DrawOutlinedRect(0, 0, w, h)
        end
        button.DoClick = function() yaw = yaw + direction * 45 end
    end
end
