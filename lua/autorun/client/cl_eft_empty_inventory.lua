-- ZCity EFT inventory: server state, neutral panels, restrained orange accents.
if SERVER then return end
ZCityEFTEmptyInventory = ZCityEFTEmptyInventory or {}
local UI = ZCityEFTEmptyInventory
if IsValid(UI.Frame) then UI.Frame:Remove() end
local C = {text=Color(229,231,233), muted=Color(145,150,155), accent=Color(231,139,62),
    line=Color(83,88,92,180), panel=Color(42,46,50,235), cell=Color(34,38,41,220)}
local chatting = false
local function rect(color,x,y,w,h)
    surface.SetDrawColor(color) surface.DrawRect(x,y,w,h)
end
local function close()
    if IsValid(UI.Frame) then UI.Frame:Remove() end
    UI.Frame=nil UI.LastSignature=nil UI.Loot=nil
end
local function canOpen()
    local ply=LocalPlayer()
    return IsValid(ply) and ply:Alive() and not ply:InVehicle() and not chatting
        and not gui.IsGameUIVisible() and not gui.IsConsoleVisible()
        and not IsValid(vgui.GetKeyboardFocus()) and not vgui.CursorVisible()
end
local function db(id) return EFT and EFT.ItemDatabase and EFT.ItemDatabase[id] end
local function armorData(placement,id)
    return hg and hg.armor and hg.armor[placement] and hg.armor[placement][id]
end
local function itemName(id)
    local name=language.GetPhrase(id or "")
    local stored=scripted_ents.GetStored("ent_armor_"..(id or ""))
    return stored and stored.t and stored.t.PrintName or name
end
local function send(name,...)
    net.Start(name)
    for _, value in ipairs({...}) do net.WriteString(tostring(value)) end
    net.SendToServer()
    UI.NextSync=CurTime()+0.2
end
local function icon(parent,path,x,y,w,h,skin)
    if not isstring(path) or path=="" or not util.IsValidModel(path) then return end
    local image=vgui.Create("SpawnIcon",parent)
    image:SetPos(x,y) image:SetSize(w,h) image:SetModel(path,skin or 0)
    image:SetMouseInputEnabled(false) image:SetTooltip(false)
end
local function equipmentSlot(data)
    if data.type=="rig" or data.type=="backpack" then return data.type end
    if data.type=="armor" then return data.armorSlot end
end
local function itemMenu(it,data,origin)
    local menu=DermaMenu()
    if origin=="container" then
        if it.examined==false then
            menu:AddOption("Изучить",function() send("EFT_ExamineItem",it.uniqueID) end)
            menu:Open() return
        end
        menu:AddOption("Забрать",function() send("EFT_TransferItem",it.uniqueID,"to_player") end)
    end
    if it.examined ~= false and (data.type=="rig" or data.type=="backpack" or data.armorSlot) then
        menu:AddOption("Надеть",function() send("EFT_EquipItem",it.uniqueID,data.armorSlot or data.type) end)
    end
    if it.examined ~= false and data.type=="food" then
        menu:AddOption("Использовать",function() send("EFT_ConsumeItem",it.uniqueID) end)
    end
    if origin~="container" then
        if UI.Loot then menu:AddOption("Положить в ящик",function() send("EFT_TransferItem",it.uniqueID,"to_container") end) end
        menu:AddOption("Выбросить",function() send("EFT_DropItem",it.uniqueID) end)
    end
    menu:Open()
end
function UI.Refresh()
    if not IsValid(UI.Frame) or not UI.State then return end
    local state=UI.State
    local signature=util.TableToJSON({state=state,loot=UI.Loot})
    if signature==UI.LastSignature then return end
    -- Never destroy the item being dragged while a state update is in flight.
    if dragndrop.IsDragging() then return end
    UI.LastSignature=signature
    local px=UI.PX
    local equip,armor=state.equip or {},state.armor or {}
    for _, child in ipairs(UI.Gear:GetChildren()) do child:Remove() end
    local slots={{"vest","БРОНЯ","torso"},{"helmet","ШЛЕМ","head"},
        {"headphones","ГАРНИТУРА","ears"},{"mask","МАСКА","face"},
        {"rig","РАЗГРУЗКА"},{"backpack","РЮКЗАК"}}
    local row=0
    for _, info in ipairs(slots) do
        local slot,label,placement=unpack(info)
        local id=equip[slot]
        local data=id and db(id)
        local aid=placement and armor[placement]
        local ad=aid and armorData(placement,aid)
        do
            local name=data and data.name or (aid and itemName(aid))
            local path=data and data.model or (ad and (ad[2] or ad.model))
            local card=vgui.Create("DButton",UI.Gear)
            card:SetText("")
            card:SetPos(0,px(row*91)) card:SetSize(px(242),px(81))
            card:Receiver("ZCityEFTItem",function(_,panels,dropped)
                local source=panels[1]
                if not dropped or not IsValid(source) or not source.Item then return end
                local data=db(source.Item.id)
                if data and equipmentSlot(data)==slot then
                    send("EFT_EquipItem",source.Item.uniqueID,slot)
                else surface.PlaySound("buttons/button10.wav") end
            end)
            card.DoRightClick=function()
                if not id and not aid then return end
                local menu=DermaMenu()
                if id then menu:AddOption("Снять в инвентарь",function() send("EFT_UnequipItem",slot) end)
                elseif aid and ad and not ad.nodrop then
                    menu:AddOption("Снять и выбросить",function() send("hg_drop_equipment",aid) end)
                end
                menu:Open()
            end
            card.Paint=function(self,w,h)
                rect(self:IsHovered() and Color(57,61,65,240) or C.panel,0,0,w,h)
                rect(name and C.accent or C.line,0,0,px(2),h)
                draw.SimpleText(label,"EFTSmall",px(82),px(14),C.muted)
                draw.SimpleText(name and "НАДЕТО" or "НЕ НАДЕТО","EFTSmall",px(82),px(50),name and C.accent or C.muted)
            end
            icon(card,path,px(6),px(6),px(68),px(68),aid and LocalPlayer():GetNWInt("ArmorSkins"..aid,0))
            local caption=vgui.Create("DLabel",card)
            caption:SetPos(px(82),px(29)) caption:SetSize(px(153),px(21))
            caption:SetMouseInputEnabled(false)
            caption:SetFont("EFTLabel") caption:SetTextColor(C.text) caption:SetText(name or "—")
            if name then card:SetTooltip(name) end
            row=row+1
        end
    end
    local scroll=UI.Storage
    local oldScroll=scroll:GetVBar():GetScroll()
    scroll:Clear()
    local lootScroll=IsValid(UI.LootStorage) and UI.LootStorage:GetVBar():GetScroll() or 0
    if IsValid(UI.LootStorage) then UI.LootStorage:Clear() end
    for _, section in ipairs({{"personal","КАРМАНЫ"},{"rig","РАЗГРУЗКА"},{"backpack","РЮКЗАК"},{"container","СОДЕРЖИМОЕ"}}) do
        local key,title=unpack(section)
        local grid=key=="container" and UI.Loot or (state.grids and state.grids[key])
        if grid and (key=="personal" or key=="container" or equip[key]) then
            local cols,rows=math.Clamp(tonumber(grid.w) or 1,1,16),math.Clamp(tonumber(grid.h) or 1,1,16)
            local cell=math.floor(math.min(px(54),px(key=="container" and 300 or 475)/cols))
            local sectionPanel=vgui.Create("DPanel",key=="container" and UI.LootStorage or scroll)
            sectionPanel:Dock(TOP) sectionPanel:DockMargin(0,0,0,px(25))
            sectionPanel:SetTall(px(35)+rows*cell)
            sectionPanel.Paint=function(_,w,h)
                draw.SimpleText(title,"EFTLabel",0,0,C.text)
                local data=db(equip[key])
                draw.SimpleText(data and data.name or (cols.." × "..rows),"EFTSmall",0,px(19),C.muted)
            end
            local cells=vgui.Create("DPanel",sectionPanel)
            cells:SetPos(0,px(35)) cells:SetSize(cols*cell,rows*cell)
            cells.Paint=function(_,w,h)
                rect(C.cell,0,0,w,h)
                surface.SetDrawColor(C.line)
                for x=0,cols do surface.DrawLine(math.min(x*cell,w-1),0,math.min(x*cell,w-1),h) end
                for y=0,rows do surface.DrawLine(0,math.min(y*cell,h-1),w,math.min(y*cell,h-1)) end
            end
            cells:Receiver("ZCityEFTItem",function(_,panels,dropped,_,x,y)
                local source=panels[1]
                if not dropped or not IsValid(source) or not source.Item then return end
                if key=="container" and source.Origin~="container" then
                    send("EFT_TransferItem",source.Item.uniqueID,"to_container") return
                elseif key~="container" and source.Origin=="container" then
                    send("EFT_TransferItem",source.Item.uniqueID,"to_player") return
                elseif key=="container" then return end
                local gx,gy=math.floor(x/cell)+1,math.floor(y/cell)+1
                if gx<1 or gy<1 or gx>cols or gy>rows then return end
                net.Start("EFT_MoveItem") net.WriteString(tostring(source.Item.uniqueID))
                net.WriteUInt(gx,8) net.WriteUInt(gy,8) net.WriteString(key) net.SendToServer()
                UI.NextSync=CurTime()+0.2
            end)
            for _,it in ipairs(grid.items or {}) do
                local data=db(it.id)
                if data then
                    local iw=it.rotated and data.h or data.w
                    local ih=it.rotated and data.w or data.h
                    iw,ih=math.max(1,iw or it.w or 1),math.max(1,ih or it.h or 1)
                    local ix,iy=(it.x or 1)-1,(it.y or 1)-1
                    if ix>=0 and iy>=0 and ix+iw<=cols and iy+ih<=rows then
                        local item=vgui.Create("DButton",cells)
                        item:SetPos(ix*cell+2,iy*cell+2) item:SetSize(iw*cell-4,ih*cell-4)
                        item:SetText("") item.Item=it item.Origin=key item:Droppable("ZCityEFTItem")
                        item:SetTooltip((it.examined==false and "Неизученный предмет" or data.name).."\nПКМ — действия • Перетащи в свободную ячейку")
                        item.Paint=function(self,w,h)
                            rect(self:IsHovered() and Color(80,74,64) or Color(59,63,66),0,0,w,h)
                            rect(C.accent,0,h-2,w,2)
                            if it.examined==false then draw.SimpleText("?","EFTTitle",w/2,h/2,C.muted,TEXT_ALIGN_CENTER,TEXT_ALIGN_CENTER) end
                        end
                        if it.examined~=false then icon(item,data.model,2,2,math.min(iw*cell-8,ih*cell-8),math.min(iw*cell-8,ih*cell-8)) end
                        item.PaintOver=function(_,w,h)
                            if (it.count or 1)>1 then draw.SimpleText(tostring(it.count),"EFTSmall",w-4,h-4,C.text,TEXT_ALIGN_RIGHT,TEXT_ALIGN_BOTTOM) end
                        end
                        item.DoRightClick=function() itemMenu(it,data,key) end
                        item.DoDoubleClick=function()
                            if it.examined==false and key=="container" then send("EFT_ExamineItem",it.uniqueID) return end
                            local slot=equipmentSlot(data)
                            if slot then send("EFT_EquipItem",it.uniqueID,slot)
                            elseif key=="container" then send("EFT_TransferItem",it.uniqueID,"to_player") end
                        end
                        item.DoClick=function()
                            if key=="container" and input.IsKeyDown(KEY_LSHIFT) then send("EFT_TransferItem",it.uniqueID,"to_player") end
                        end
                    end
                end
            end
        end
    end
    scroll:GetVBar():SetScroll(oldScroll)
    if IsValid(UI.LootStorage) then UI.LootStorage:GetVBar():SetScroll(lootScroll) end
end
function UI.Open(force)
    if IsValid(UI.Frame) then if not force then close() end return end
    if not force and not canOpen() then return end
    if not IsValid(LocalPlayer()) or not LocalPlayer():Alive() then return end
    local width=UI.Loot and 1530 or 1190
    local scale=math.min(ScrW()/(width+60),ScrH()/820,1.5)
    local function px(v) return math.floor(v*scale) end
    UI.PX=px
    for name,size in pairs({EFTTitle=26,EFTLabel=15,EFTSmall=12}) do
        surface.CreateFont(name,{font="Roboto",size=math.max(10,px(size)),weight=name=="EFTTitle" and 600 or 400,extended=true})
    end
    UI.State={equip={},armor={},grids={}} UI.LastSignature=nil UI.MissingModels={}
    local f=vgui.Create("DFrame") UI.Frame=f
    f:SetSize(px(width),px(750)) f:Center() f:SetTitle("") f:ShowCloseButton(false)
    f:SetDraggable(false) f:SetSizable(false) f:SetBackgroundBlur(false) f:SetPaintShadow(false) f:MakePopup()
    f.Paint=function(_,w,h)
        rect(Color(28,32,36,232),0,0,w,h)
        rect(Color(48,52,56,240),0,0,w,px(87))
        rect(C.accent,px(26),px(30),px(3),px(28))
        draw.SimpleText("ИНВЕНТАРЬ","EFTTitle",px(42),px(25),C.text)
        draw.SimpleText(LocalPlayer():Nick(),"EFTSmall",px(43),px(59),C.muted)
        rect(C.line,px(355),px(112),1,px(575))
        rect(C.line,px(630),px(112),1,px(575))
        draw.SimpleText("ПЕРСОНАЖ","EFTSmall",px(27),px(106),C.muted)
        draw.SimpleText("ЭКИПИРОВКА","EFTSmall",px(374),px(106),C.muted)
        draw.SimpleText("СНАРЯЖЕНИЕ","EFTSmall",px(654),px(106),C.muted)
        if width>1190 then
            rect(C.line,px(1180),px(112),1,px(575))
            draw.SimpleText(UI.Loot and (UI.Loot.name or "ЯЩИК") or "ЯЩИК НЕДОСТУПЕН","EFTSmall",px(1203),px(106),C.accent)
        end
        rect(C.line,px(25),h-px(44),w-px(50),1)
        local missing=next(UI.MissingModels or {}) ~= nil
        draw.SimpleText(missing and "Часть моделей отсутствует — проверь контент брони" or "ПКМ — действия с предметом  /  Перетаскивание — перемещение", "EFTSmall",px(27),h-px(28),missing and C.accent or C.muted)
        draw.SimpleText("I / ESC  ЗАКРЫТЬ","EFTSmall",w-px(26),h-px(28),C.muted,TEXT_ALIGN_RIGHT)
    end
    f.OnRemove=function(self)
        if UI.Frame==self then UI.Frame=nil end
        if UI.Loot and not UI.Rebuilding then
            net.Start("EFT_CloseLoot") net.SendToServer() UI.Loot=nil
        end
    end
    f.OnKeyCodePressed=function(_,key) if key==KEY_ESCAPE then close() end end
    local exit=vgui.Create("DButton",f)
    exit:SetPos(px(width-55),px(25)) exit:SetSize(px(30),px(30)) exit:SetText("×") exit:SetFont("EFTTitle") exit:SetTextColor(C.muted)
    exit.Paint=function(self,w,h) if self:IsHovered() then rect(C.panel,0,0,w,h) end end
    exit.DoClick=close
    UI.Gear=vgui.Create("DPanel",f) UI.Gear:SetPos(px(374),px(132)) UI.Gear:SetSize(px(242),px(554)) UI.Gear.Paint=function() end
    UI.Storage=vgui.Create("DScrollPanel",f) UI.Storage:SetPos(px(654),px(132)) UI.Storage:SetSize(px(510),px(554))
    local bar=UI.Storage:GetVBar()
    bar.Paint=function() end bar.btnUp.Paint=function() end bar.btnDown.Paint=function() end
    bar.btnGrip.Paint=function(_,w,h) rect(C.line,w/2-2,0,3,h) end
    UI.LootStorage=nil
    if UI.Loot then
        UI.LootStorage=vgui.Create("DScrollPanel",f)
        UI.LootStorage:SetPos(px(1203),px(132)) UI.LootStorage:SetSize(px(305),px(554))
    end
    if UI.BuildCharacter then UI.BuildCharacter(f,px) end
    UI.Refresh() UI.NextSync=0
end
function UI.ReceiveLoot(loot)
    if not IsValid(loot.entity) then return end
    if IsValid(UI.Frame) and not IsValid(UI.LootStorage) then
        UI.Rebuilding=true UI.Frame:Remove() UI.Rebuilding=false
    end
    UI.Loot=loot
    if not IsValid(UI.Frame) then UI.Open(true) end
    UI.LastSignature=nil UI.NextSync=0
    UI.Refresh()
end
concommand.Add("eft_inventory",function() UI.Open() end)
hook.Add("StartChat","ZCityEFTEmptyChat",function() chatting=true end)
hook.Add("FinishChat","ZCityEFTEmptyChat",function() chatting=false end)
hook.Add("OnScreenSizeChanged","ZCityEFTEmptyResize",close)
hook.Add("ShutDown","ZCityEFTEmptyClose",close)
local wasDown=input.IsKeyDown(KEY_I)
hook.Add("Think","ZCityEFTEmptyKey",function()
    local down=input.IsKeyDown(KEY_I)
    local pressed=down and not wasDown wasDown=down
    local ply=LocalPlayer()
    if IsValid(UI.Frame) then
        if not IsValid(ply) or not ply:Alive() or ply:InVehicle() or gui.IsGameUIVisible() or input.IsKeyDown(KEY_ESCAPE) then close() return end
        if CurTime()>=(UI.NextSync or 0) then
            UI.NextSync=CurTime()+0.75
            net.Start("ZCityEFT_EquipmentRequest") net.SendToServer()
        end
        UI.Refresh()
        if pressed and not gui.IsConsoleVisible() and not chatting then close() end
    elseif pressed and canOpen() then UI.Open() end
end)
