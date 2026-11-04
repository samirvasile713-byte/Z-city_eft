include("shared.lua")

-- ==========================================
-- EFT ЦВЕТОВАЯ ПАЛИТРА И ШРИФТЫ
-- ==========================================
local clr_bg          = Color(12, 13, 14, 250)
local clr_header      = Color(18, 19, 20, 255)
local clr_card        = Color(24, 26, 28, 240)
local clr_orange      = Color(210, 105, 30, 255)
local clr_text        = Color(220, 220, 220, 255)
local clr_text_muted  = Color(120, 125, 130, 255)
local clr_green       = Color(100, 180, 100, 255)
local clr_red         = Color(180, 60, 60, 255)

surface.CreateFont("EFT_TraderTitle", { font = "TargetID", size = 28, weight = 800, antialias = true })
surface.CreateFont("EFT_TraderSubtitle", { font = "TargetID", size = 16, weight = 400, antialias = true })
surface.CreateFont("EFT_ItemTitle", { font = "TargetID", size = 18, weight = 600, antialias = true })
surface.CreateFont("EFT_ItemPrice", { font = "TargetID", size = 22, weight = 800, antialias = true })
surface.CreateFont("EFT_Small", { font = "Tahoma", size = 13, weight = 600, antialias = true })

-- Плавное изменение цвета (Lerp)
local function LerpColor(t, from, to)
    return Color(
        Lerp(t, from.r, to.r), Lerp(t, from.g, to.g),
        Lerp(t, from.b, to.b), Lerp(t, from.a, to.a)
    )
end

function ENT:Draw()
    self:DrawModel()
end

local function AttachModelIcon(parent, model, size, offset)
    if not model then return nil end
    local icon = vgui.Create("SpawnIcon", parent)
    icon:SetSize(size, size)
    icon:SetPos(offset, offset)
    icon:SetModel(model)
    icon:SetMouseInputEnabled(false)
    return icon
end

net.Receive("EFT_OpenFenceMenu", function()
    local fenceEnt = net.ReadEntity()
    local plyInvCounts = net.ReadTable()
    if not IsValid(fenceEnt) then return end

    if IsValid(EFT_FenceFrame) then EFT_FenceFrame:Remove() end

    -- Главное окно
    local frame = vgui.Create("DFrame")
    EFT_FenceFrame = frame
    frame:SetSize(900, 650)
    frame:Center()
    frame:SetTitle("")
    frame:MakePopup()
    frame:ShowCloseButton(false)
    frame.StartTime = SysTime()

    frame.Paint = function(self, w, h)
        Derma_DrawBackgroundBlur(self, self.m_fCreateTime)
        
        -- Анимация появления
        local alphaMulti = math.Clamp((SysTime() - self.StartTime) * 3, 0, 1)
        
        -- Фон
        draw.RoundedBox(0, 0, 0, w, h, Color(clr_bg.r, clr_bg.g, clr_bg.b, clr_bg.a * alphaMulti))
        
        -- Хедер
        draw.RoundedBox(0, 0, 0, w, 80, clr_header)
        draw.RoundedBox(0, 0, 80, w, 2, clr_orange) -- Тарковская оранжевая линия

        -- Инфо торговца
        draw.SimpleText("ОДЕССА КАББЕДЖ", "EFT_TraderTitle", 95, 20, clr_text)
        draw.SimpleText("ТОРГОВЕЦ СОПРОТИВЛЕНИЯ // ЛОЯЛЬНОСТЬ: МАКСИМУМ", "EFT_TraderSubtitle", 95, 48, clr_text_muted)

        -- Баланс игрока
        draw.SimpleText("БАЛАНС РУБЛЕЙ", "EFT_TraderSubtitle", w - 20, 22, clr_text_muted, TEXT_ALIGN_RIGHT)
        draw.SimpleText(string.Comma(LocalPlayer():GetNWInt("EFT_Money", 0)) .. " ₽", "EFT_TraderTitle", w - 20, 42, clr_green, TEXT_ALIGN_RIGHT)
    end

    -- Аватарка торговца
    local avatarBG = vgui.Create("DPanel", frame)
    avatarBG:SetPos(20, 10)
    avatarBG:SetSize(60, 60)
    avatarBG.Paint = function(self, w, h)
        draw.RoundedBox(4, 0, 0, w, h, Color(30, 32, 35))
        surface.SetDrawColor(clr_text_muted)
        surface.DrawOutlinedRect(0, 0, w, h)
    end
    AttachModelIcon(avatarBG, "models/odessa.mdl", 56, 2)

    -- Кнопка закрытия
    local closeBtn = vgui.Create("DButton", frame)
    closeBtn:SetSize(40, 40)
    closeBtn:SetPos(frame:GetWide() - 40, 0)
    closeBtn:SetText("✕")
    closeBtn:SetFont("EFT_TraderTitle")
    closeBtn:SetTextColor(clr_text_muted)
    closeBtn.Paint = function(self, w, h)
        if self:IsHovered() then 
            draw.RoundedBox(0, 0, 0, w, h, clr_red)
            self:SetTextColor(color_white)
        else
            self:SetTextColor(clr_text_muted)
        end
    end
    closeBtn.DoClick = function() 
        surface.PlaySound("ui/buttonclick.wav")
        frame:Close() 
    end

    -- Зона вкладок
    local activeTab = "BUY"
    local tabArea = vgui.Create("DPanel", frame)
    tabArea:SetPos(20, 100)
    tabArea:SetSize(860, 45)
    tabArea.Paint = function(self, w, h)
        draw.RoundedBox(0, 0, h-1, w, 1, Color(50, 52, 55)) -- Линия под табами
    end

    local scrollContent = vgui.Create("DScrollPanel", frame)
    scrollContent:SetPos(20, 160)
    scrollContent:SetSize(860, 470)
    
    -- Стилизация скроллбара
    local sbar = scrollContent:GetVBar()
    sbar:SetWide(6)
    sbar.Paint = function() end
    sbar.btnUp.Paint = function() end
    sbar.btnDown.Paint = function() end
    sbar.btnGrip.Paint = function(self, w, h) draw.RoundedBox(3, 0, 0, w, h, clr_orange) end

    local layoutContent = vgui.Create("DIconLayout", scrollContent)
    layoutContent:Dock(FILL)
    layoutContent:SetSpaceX(15)
    layoutContent:SetSpaceY(15)

    -- Генерация красивой карточки товара
    local function CreateEFTCard(itemID, itemData, priceText, countText, btnText, btnColorHover, onAction)
        local rarity = EFT.Rarity[itemData.rarity] or EFT.Rarity.common
        local card = layoutContent:Add("DPanel")
        card:SetSize(422, 100) -- В 2 колонки
        
        card.CurrentColor = clr_card
        card.Paint = function(self, w, h)
            -- Плавный ховер фона
            local targetColor = self:IsHovered() and Color(35, 38, 42, 250) or clr_card
            self.CurrentColor = LerpColor(FrameTime() * 10, self.CurrentColor, targetColor)
            
            draw.RoundedBox(0, 0, 0, w, h, self.CurrentColor)
            surface.SetDrawColor(45, 48, 52)
            surface.DrawOutlinedRect(0, 0, w, h)
            
            -- Полоска редкости слева
            draw.RoundedBox(0, 0, 0, 4, h, rarity.color)

            -- Тексты
            draw.SimpleText(itemData.name, "EFT_ItemTitle", 100, 12, clr_text)
            draw.SimpleText(rarity.label, "EFT_Small", 100, 32, rarity.color)
            
            if countText then
                draw.SimpleText(countText, "EFT_Small", 100, 50, clr_text_muted)
            end
            
            draw.SimpleText(priceText, "EFT_ItemPrice", 100, 68, activeTab == "BUY" and clr_orange or clr_green)
        end

        -- Бэкграунд под иконку
        local iconBg = vgui.Create("DPanel", card)
        iconBg:SetPos(10, 10)
        iconBg:SetSize(80, 80)
        iconBg.Paint = function(self, w, h)
            draw.RoundedBox(0, 0, 0, w, h, Color(15, 15, 15, 200))
            surface.SetDrawColor(30, 30, 30)
            surface.DrawOutlinedRect(0, 0, w, h)
        end
        AttachModelIcon(iconBg, itemData.model, 70, 5)

        -- Кнопка действия (появляется при наведении)
        local actionBtn = vgui.Create("DButton", card)
        actionBtn:SetSize(110, 36)
        actionBtn:SetPos(300, 54)
        actionBtn:SetText(btnText)
        actionBtn:SetFont("EFT_ItemTitle")
        actionBtn.CurrentColor = Color(20, 20, 20, 0) -- Прозрачная по умолчанию
        
        actionBtn.Paint = function(self, w, h)
            local isCardHovered = card:IsHovered() or self:IsHovered()
            local isBtnHovered = self:IsHovered()
            
            -- Логика: Кнопка видна, когда мышь на карточке. Ярче, когда мышь на самой кнопке.
            local targetBg = Color(0,0,0,0)
            local targetText = Color(255,255,255,0)

            if isBtnHovered then
                targetBg = btnColorHover
                targetText = color_white
            elseif isCardHovered then
                targetBg = Color(40, 40, 40, 255)
                targetText = clr_text
            end

            self.CurrentColor = LerpColor(FrameTime() * 12, self.CurrentColor, targetBg)
            
            draw.RoundedBox(0, 0, 0, w, h, self.CurrentColor)
            if isCardHovered then
                surface.SetDrawColor(btnColorHover)
                surface.DrawOutlinedRect(0, 0, w, h)
            end
            
            self:SetTextColor(LerpColor(FrameTime() * 12, self:GetTextColor() or Color(0,0,0,0), targetText))
        end
        
        actionBtn.DoClick = function()
            surface.PlaySound("ui/buttonclickrelease.wav")
            onAction()
        end
    end

    local function RenderBuyList()
        layoutContent:Clear()
        for class, info in pairs(fenceEnt.BuyPrices or {}) do
            local itemData = EFT.ItemDatabase[class]
            if not itemData then continue end
            
            CreateEFTCard(class, itemData, info.price .. " ₽", nil, "КУПИТЬ", clr_orange, function()
                net.Start("EFT_BuyFenceItem")
                    net.WriteEntity(fenceEnt)
                    net.WriteString(class)
                net.SendToServer()
                timer.Simple(0.2, function() if IsValid(frame) then RenderBuyList() end end)
            end)
        end
    end

    local function RenderSellList()
        layoutContent:Clear()
        local hasItems = false

        for class, count in pairs(plyInvCounts) do
            local itemData = EFT.ItemDatabase[class]
            if not itemData or not itemData.price or count <= 0 then continue end
            
            hasItems = true
            local sellPrice = math.floor(itemData.price * 0.7)
            
            CreateEFTCard(class, itemData, "+" .. sellPrice .. " ₽", "В наличии: " .. count .. " шт.", "ПРОДАТЬ", clr_green, function()
                net.Start("EFT_SellFenceItem")
                    net.WriteEntity(fenceEnt)
                    net.WriteString(class)
                net.SendToServer()
                
                plyInvCounts[class] = plyInvCounts[class] - 1
                if plyInvCounts[class] <= 0 then plyInvCounts[class] = nil end
                timer.Simple(0.1, function() if IsValid(frame) then RenderSellList() end end)
            end)
        end

        if not hasItems then
            local emptyLbl = layoutContent:Add("DLabel")
            emptyLbl:SetSize(860, 100)
            emptyLbl:SetText("В твоем рюкзаке нет ничего ценного для продажи торговцу.")
            emptyLbl:SetFont("EFT_TraderTitle")
            emptyLbl:SetTextColor(Color(80, 80, 80))
            emptyLbl:SetContentAlignment(5)
        end
    end

    -- Кнопки табов
    local function CreateTabButton(x, text, tabID)
        local btn = vgui.Create("DButton", tabArea)
        btn:SetSize(200, 45)
        btn:SetPos(x, 0)
        btn:SetText(text)
        btn:SetFont("EFT_ItemTitle")
        
        btn.Paint = function(self, w, h)
            if activeTab == tabID then
                self:SetTextColor(color_white)
                draw.RoundedBox(0, 0, h-3, w, 3, clr_orange) -- Активный таб
                draw.RoundedBox(0, 0, 0, w, h, Color(255, 255, 255, 5))
            else
                self:SetTextColor(clr_text_muted)
                if self:IsHovered() then
                    draw.RoundedBox(0, 0, 0, w, h, Color(255, 255, 255, 2))
                end
            end
        end
        
        btn.DoClick = function()
            if activeTab == tabID then return end
            surface.PlaySound("ui/button_click.wav")
            activeTab = tabID
            if tabID == "BUY" then RenderBuyList() else RenderSellList() end
        end
    end

    CreateTabButton(0, "ТОВАРЫ", "BUY")
    CreateTabButton(210, "ПРОДАТЬ ХАБАР", "SELL")

    RenderBuyList()
end)