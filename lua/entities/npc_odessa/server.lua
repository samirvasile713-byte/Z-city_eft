AddCSLuaFile("cl_init.lua")
AddCSLuaFile("shared.lua")
include("shared.lua")

util.AddNetworkString("EFT_OpenFenceMenu")
util.AddNetworkString("EFT_BuyFenceItem")
util.AddNetworkString("EFT_SellFenceItem")

local VoicelinesUse = {
    "vo/npc/male01/hi01.wav",
    "vo/npc/male01/hi02.wav",
    "vo/npc/male01/gotone01.wav"
}

function ENT:Initialize()
    self:SetModel(self.Model) -- Используем модель из shared.lua
    
    -- Настройки base_ai для идеальной анимации
    self:SetHullType(HULL_HUMAN)
    self:SetHullSizeNormal()
    self:SetNPCState(NPC_STATE_SCRIPT)
    self:SetSolid(SOLID_BBOX)
    self:CapabilitiesAdd(CAP_ANIMATEDFACE + CAP_TURN_HEAD)
    self:SetUseType(SIMPLE_USE)
    self:DropToFloor()
    self:SetMaxYawSpeed(90)

    -- Ставим стандартную Idle анимацию (Одесса будет стоять расслабленно)
    local seq = self:LookupSequence("idle_subtle")
    if seq == -1 then seq = self:LookupSequence("idle_all_01") end
    self:ResetSequence(seq)
end

function ENT:Think()
    -- Поворот головы к ближайшему игроку
    local nearestPly = nil
    local minDist = 40000 -- 200 * 200

    for _, ply in ipairs(player.GetAll()) do
        if ply:Alive() then
            local dist = ply:GetPos():DistToSqr(self:GetPos())
            if dist < minDist then
                minDist = dist
                nearestPly = ply
            end
        end
    end

    if IsValid(nearestPly) then
        self:SetTarget(nearestPly)
        self:UpdateTurnActivity()
    else
        self:ClearTarget()
    end
    
    self:NextThink(CurTime() + 0.1)
    return true
end

function ENT:AcceptInput(name, activator, caller)
    if name == "Use" and IsValid(activator) and activator:IsPlayer() then
        if (self.NextUseTime or 0) > CurTime() then return end
        self.NextUseTime = CurTime() + 1

        self:EmitSound(table.Random(VoicelinesUse), 65)

        -- Собираем данные инвентаря игрока для меню продажи
        local invCounts = {}
        if EFT and EFT.VirtualInventory then
            local function countItems(list)
                for _, it in ipairs(list or {}) do
                    invCounts[it.id] = (invCounts[it.id] or 0) + (it.count or 1)
                end
            end
            countItems(EFT.VirtualInventory[activator])
            countItems(EFT.VirtualRigInventory[activator])
        end

        net.Start("EFT_OpenFenceMenu")
            net.WriteEntity(self)
            net.WriteTable(invCounts)
        net.Send(activator)
    end
end

-- Обработка покупки
net.Receive("EFT_BuyFenceItem", function(len, ply)
    if not IsValid(ply) or not ply:Alive() then return end
    local ent = net.ReadEntity()
    local itemID = net.ReadString()

    if not IsValid(ent) or ply:GetPos():DistToSqr(ent:GetPos()) > 40000 then return end
    if not EFT or not EFT.ItemDatabase[itemID] then return end

    local price = ent.BuyPrices[itemID].price
    local plyMoney = ply:GetNWInt("EFT_Money", 0)

    if plyMoney >= price then
        local itemData = EFT.ItemDatabase[itemID]
        local success = false

        if itemData.type == "weapon" then
            if not ply:HasWeapon(itemID) then
                ply:Give(itemID)
                success = true
            else
                ply:ChatPrint("[Одесса] У тебя уже есть такое оружие.")
                return
            end
        elseif itemData.type == "ammo" and itemData.ammoName then
            ply:GiveAmmo(itemData.maxStack or 30, itemData.ammoName)
            success = true
        else
            local gridW, gridH = EFT.Config.PersonalGridBaseW, EFT.Config.PersonalGridBaseH
            if EFT.PlayerEquipment and EFT.PlayerEquipment[ply] and EFT.PlayerEquipment[ply].backpack then
                local bp = EFT.ItemDatabase[EFT.PlayerEquipment[ply].backpack]
                if bp and bp.gridSize then
                    gridW = bp.gridSize.w
                    gridH = bp.gridSize.h
                end
            end
            
            EFT.VirtualInventory[ply] = EFT.VirtualInventory[ply] or {}
            local extra = { examined = true, count = itemData.maxStack, hp = itemData.maxHP, uses = itemData.maxUses }
            local inserted = EFT.Grid.TryInsert(EFT.VirtualInventory[ply], itemID, itemData, gridW, gridH, extra)
            
            if inserted then
                success = true
            else
                ply:ChatPrint("[Одесса] Нет места в рюкзаке!")
            end
        end

        if success then
            ply:SetNWInt("EFT_Money", plyMoney - price)
            ply:EmitSound("items/ammo_pickup.wav", 60)
            ply:ChatPrint("[Одесса] Покупка успешна: " .. itemData.name)
        end
    else
        ply:EmitSound("buttons/button10.wav", 60)
        ply:ChatPrint("[Одесса] Не хватает рублей!")
    end
end)

-- Обработка продажи
net.Receive("EFT_SellFenceItem", function(len, ply)
    if not IsValid(ply) or not ply:Alive() then return end
    local ent = net.ReadEntity()
    local itemID = net.ReadString()

    if not EFT or not EFT.ItemDatabase[itemID] then return end
    local itemData = EFT.ItemDatabase[itemID]
    if not itemData.price then return end 

    local sellPrice = math.floor(itemData.price * 0.7)
    local removed = false

    EFT.VirtualInventory[ply] = EFT.VirtualInventory[ply] or {}
    for i, it in ipairs(EFT.VirtualInventory[ply]) do
        if it.id == itemID then
            table.remove(EFT.VirtualInventory[ply], i)
            removed = true
            break
        end
    end

    if not removed then
        EFT.VirtualRigInventory[ply] = EFT.VirtualRigInventory[ply] or {}
        for i, it in ipairs(EFT.VirtualRigInventory[ply]) do
            if it.id == itemID then
                table.remove(EFT.VirtualRigInventory[ply], i)
                removed = true
                break
            end
        end
    end

    if removed then
        local currentMoney = ply:GetNWInt("EFT_Money", 0)
        ply:SetNWInt("EFT_Money", currentMoney + sellPrice)
        ply:EmitSound("physics/metal/weapon_drop" .. math.random(1, 3) .. ".wav", 60)
        ply:ChatPrint("[Одесса] Продано за " .. sellPrice .. "₽")
    else
        ply:ChatPrint("[Одесса] Предмет не найден!")
    end
end)