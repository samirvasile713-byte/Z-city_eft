MODE.name = "ztcity"

local MODE = MODE

local RespawnAt = 0
local JustRespawned = false
local JustRespawnedUntil = 0
local CfgRespawn = 12
local CfgProtect = 6

local COL_GOLD   = Color(210, 170, 80)
local COL_DIM    = Color(160, 155, 140)
local COL_GREEN  = Color(120, 200, 130)
local COL_RED    = Color(220, 90, 80)
local COL_WHITE  = Color(240, 235, 220)

net.Receive("ztcity_start", function()
    CfgRespawn = net.ReadFloat()
    CfgProtect = net.ReadFloat()
    RespawnAt = 0
    JustRespawned = false

    zb.RemoveFade()

    if hg and hg.DynaMusic then
        if hg.DynaMusic.Pack and hg.DynaMusic.Pack["ztcity"] then
            hg.DynaMusic:Start("ztcity")
        else
            hg.DynaMusic:Start("mirrors_edge")
        end
    end

    surface.PlaySound("buttons/button14.wav")
end)

net.Receive("ztcity_end", function()
    RespawnAt = 0
    if hg and hg.DynaMusic then hg.DynaMusic:Stop() end
    surface.PlaySound("ambient/alarms/warningbell1.wav")
end)

net.Receive("ztcity_respawn_info", function()
    RespawnAt = net.ReadFloat()
    local just = net.ReadBool()
    if just then
        JustRespawned = true
        JustRespawnedUntil = CurTime() + 2.5
        RespawnAt = 0
        surface.PlaySound("items/suitchargeok1.wav")
    end
end)

net.Receive("ztcity_notify", function()
    local text = net.ReadString()
    local r, g, b = net.ReadUInt(8), net.ReadUInt(8), net.ReadUInt(8)
    chat.AddText(Color(r, g, b), "[ZT-City] ", COL_WHITE, text)
end)

function MODE:RenderScreenspaceEffects()
    if not zb.ROUND_START or zb.ROUND_START + 5.5 < CurTime() then return end
    local fade = math.Clamp(zb.ROUND_START + 5.5 - CurTime(), 0, 1)
    surface.SetDrawColor(8, 8, 7, 255 * fade)
    surface.DrawRect(-1, -1, ScrW() + 1, ScrH() + 1)
end

local function DrawCenterText(text, font, y, col)
    draw.SimpleTextOutlined(text, font, ScrW() * 0.5, y, col,
        TEXT_ALIGN_CENTER, TEXT_ALIGN_CENTER, 1, Color(0, 0, 0, 180))
end

local function AliveCount()
    local n = 0
    for _, p in player.Iterator() do
        if p:Alive() and p:Team() ~= TEAM_SPECTATOR then n = n + 1 end
    end
    return n
end

function MODE:HUDPaint()
    local ply = LocalPlayer()
    if not IsValid(ply) then return end
    if not zb.ROUND_START then return end

    local sw, sh = ScrW(), ScrH()
    local now = CurTime()

    if zb.ROUND_START + 7.5 > now then
        zb.RemoveFade()
        local fade = math.Clamp(zb.ROUND_START + 7 - now, 0, 1)
        local a = 255 * fade

        DrawCenterText("ZT-CITY", "ZB_HomicideMediumLarge", sh * 0.14, Color(210, 170, 80, a))
        DrawCenterText("ОТКРЫТЫЙ МИР", "ZB_HomicideMedium", sh * 0.22, Color(180, 160, 110, a))
        DrawCenterText("Ты — оператор", "ZB_HomicideMediumLarge", sh * 0.48, Color(230, 220, 200, a))

        local tips = {
            "Лут в контейнерах · ящики Z-City не спавнятся",
            string.format("Респавн через %.0f сек · защита %.0f сек", CfgRespawn, CfgProtect),
            "F — обыск / взаимодействие · I — инвентарь (EFT)",
        }
        for i, t in ipairs(tips) do
            DrawCenterText(t, "ZB_HomicideMedium", sh * 0.78 + (i - 1) * 22, Color(170, 160, 140, a))
        end
        return
    end

    local kills  = ply:GetNWInt("ZTCity_Kills", 0)
    local deaths = ply:GetNWInt("ZTCity_Deaths", 0)
    local alive  = AliveCount()

    local top = string.format("ZT-CITY  ·  %d в живых  ·  K %d / D %d", alive, kills, deaths)
    draw.SimpleTextOutlined(top, "DermaDefault", sw * 0.5, 10, COL_GOLD,
        TEXT_ALIGN_CENTER, TEXT_ALIGN_TOP, 1, Color(0, 0, 0, 160))

    local prot = ply:GetNWFloat("ZTCity_ProtectUntil", 0)
    if ply:Alive() and prot > now then
        local left = math.ceil(prot - now)
        draw.SimpleTextOutlined("ЗАЩИТА СПАВНА  " .. left .. "с", "DermaDefaultBold",
            sw * 0.5, 28, COL_GREEN, TEXT_ALIGN_CENTER, TEXT_ALIGN_TOP, 1, Color(0, 0, 0, 180))
    end

    if JustRespawned and now < JustRespawnedUntil then
        local f = math.Clamp((JustRespawnedUntil - now) / 2.5, 0, 1)
        DrawCenterText("ВОЗВРАЩЕНИЕ", "ZB_HomicideMediumLarge", sh * 0.4, Color(120, 200, 130, 255 * f))
    elseif JustRespawned and now >= JustRespawnedUntil then
        JustRespawned = false
    end

    if not ply:Alive() and ply:Team() ~= TEAM_SPECTATOR then
        surface.SetDrawColor(0, 0, 0, 120)
        surface.DrawRect(0, 0, sw, sh)

        DrawCenterText("ТЫ ПОГИБ", "ZB_HomicideMediumLarge", sh * 0.38, COL_RED)

        local at = RespawnAt
        if at <= 0 then
            at = ply:GetNWFloat("ZTCity_RespawnAt", 0)
        end

        if at > now then
            local left = math.max(0, at - now)
            local barW, barH = 220, 8
            local bx, by = sw * 0.5 - barW * 0.5, sh * 0.48
            local frac = 1 - (left / math.max(CfgRespawn, 0.1))

            draw.RoundedBox(3, bx, by, barW, barH, Color(30, 28, 24, 220))
            draw.RoundedBox(3, bx, by, barW * math.Clamp(frac, 0, 1), barH, COL_GOLD)

            DrawCenterText(string.format("Респавн через %.1f с", left), "ZB_HomicideMedium", sh * 0.52, COL_WHITE)
        else
            DrawCenterText("Респавн…", "ZB_HomicideMedium", sh * 0.48, COL_GREEN)
        end

        DrawCenterText("Инвентарь EFT сохраняется на сервере (если включено в аддоне)", "Default", sh * 0.62, COL_DIM)
    end
end

function MODE:RoundStart()
    RespawnAt = 0
    JustRespawned = false
end

print("[ZT-City] Client OK · respawn HUD · protect · intro")
