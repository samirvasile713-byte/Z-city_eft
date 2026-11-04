--[[
══════════════════════════════════════════════════════════════════════════════
  ZT-CITY  —  открытый мир для EFT-лута на Z-City
  • Без спавна ящиков Z-City (LootSpawn = false)
  • Свободный респавн с задержкой и spawn-protection
  • Поздний вход, случайные точки, сохранение пропов карты
══════════════════════════════════════════════════════════════════════════════
]]

local MODE = MODE

MODE.name           = "ztcity"
MODE.PrintName      = "ZT-City"
MODE.LootSpawn      = false
MODE.LootOnTime     = false
MODE.GuiltDisabled  = true          -- без кармы «вины» за убийства в открытом мире
MODE.randomSpawns   = true
MODE.ForBigMaps     = true
MODE.Chance         = 0             -- только через F6
MODE.ROUND_TIME     = 0             -- 0 = бесконечный раунд
MODE.EndLogicType   = 0
MODE.OverrideSpawn  = true          -- сами решаем, когда спавнить

-- ─── ConVars (можно менять в серверной консоли без правки файла) ───────────
local cv_respawn = CreateConVar("ztcity_respawn_time", "12",
    { FCVAR_ARCHIVE, FCVAR_NOTIFY, FCVAR_REPLICATED },
    "Секунд до респавна в ZT-City (0 = мгновенно)", 0, 120)

local cv_protect = CreateConVar("ztcity_spawn_protect", "6",
    { FCVAR_ARCHIVE, FCVAR_NOTIFY, FCVAR_REPLICATED },
    "Секунд защиты после респавна (god + полупрозрачность)", 0, 30)

local cv_spawn_dist = CreateConVar("ztcity_spawn_min_enemy", "800",
    { FCVAR_ARCHIVE, FCVAR_NOTIFY },
    "Мин. дистанция от живых врагов при выборе точки спавна", 0, 5000)

local cv_start_band = CreateConVar("ztcity_start_bandage", "1",
    { FCVAR_ARCHIVE, FCVAR_NOTIFY },
    "Выдавать бинт при спавне (1/0)", 0, 1)

util.AddNetworkString("ztcity_start")
util.AddNetworkString("ztcity_end")
util.AddNetworkString("ztcity_respawn_info")
util.AddNetworkString("ztcity_notify")

-- ─── helpers ───────────────────────────────────────────────────────────────
local function IsZTCity()
    local rnd = CurrentRound and CurrentRound()
    return rnd and rnd.name == "ztcity"
end

local function Notify(ply, text, col)
    if not IsValid(ply) then return end
    net.Start("ztcity_notify")
        net.WriteString(text or "")
        net.WriteUInt(col and col.r or 210, 8)
        net.WriteUInt(col and col.g or 170, 8)
        net.WriteUInt(col and col.b or 80, 8)
    net.Send(ply)
end

local function BroadcastNotify(text, col)
    net.Start("ztcity_notify")
        net.WriteString(text or "")
        net.WriteUInt(col and col.r or 210, 8)
        net.WriteUInt(col and col.g or 170, 8)
        net.WriteUInt(col and col.b or 80, 8)
    net.Broadcast()
end

-- Сбор точек спавна карты + запасные
local SpawnCache = {}

local function RebuildSpawnCache()
    SpawnCache = {}
    for _, ent in ipairs(ents.FindByClass("info_player_start")) do
        if IsValid(ent) then SpawnCache[#SpawnCache + 1] = { pos = ent:GetPos(), ang = ent:GetAngles() } end
    end
    for _, ent in ipairs(ents.FindByClass("info_player_deathmatch")) do
        if IsValid(ent) then SpawnCache[#SpawnCache + 1] = { pos = ent:GetPos(), ang = ent:GetAngles() } end
    end
    for _, ent in ipairs(ents.FindByClass("info_player_terrorist")) do
        if IsValid(ent) then SpawnCache[#SpawnCache + 1] = { pos = ent:GetPos(), ang = ent:GetAngles() } end
    end
    for _, ent in ipairs(ents.FindByClass("info_player_counterterrorist")) do
        if IsValid(ent) then SpawnCache[#SpawnCache + 1] = { pos = ent:GetPos(), ang = ent:GetAngles() } end
    end
    -- fallback: около живых игроков / origin
    if #SpawnCache == 0 then
        for _, ply in player.Iterator() do
            if IsValid(ply) and ply:Alive() then
                SpawnCache[#SpawnCache + 1] = { pos = ply:GetPos() + Vector(math.random(-200, 200), math.random(-200, 200), 16), ang = Angle(0, math.random(0, 360), 0) }
            end
        end
    end
    if #SpawnCache == 0 then
        SpawnCache[1] = { pos = Vector(0, 0, 64), ang = Angle(0, 0, 0) }
    end
end

local function PickSpawnAwayFromEnemies(ply)
    if #SpawnCache == 0 then RebuildSpawnCache() end
    local minDist = cv_spawn_dist:GetFloat()
    local minDistSqr = minDist * minDist
    local candidates = {}

    for _, spot in ipairs(SpawnCache) do
        local ok = true
        for _, other in player.Iterator() do
            if other ~= ply and IsValid(other) and other:Alive() then
                if other:GetPos():DistToSqr(spot.pos) < minDistSqr then
                    ok = false
                    break
                end
            end
        end
        if ok then candidates[#candidates + 1] = spot end
    end

    if #candidates == 0 then candidates = SpawnCache end
    return candidates[math.random(#candidates)]
end

local function ApplySpawnProtection(ply, seconds)
    if not IsValid(ply) or seconds <= 0 then return end
    ply.ZTCity_ProtectUntil = CurTime() + seconds
    ply:SetNWFloat("ZTCity_ProtectUntil", ply.ZTCity_ProtectUntil)
    ply:GodEnable()
    ply:SetRenderMode(RENDERMODE_TRANSALPHA)
    ply:SetColor(Color(255, 255, 255, 120))

    local sid = ply:SteamID64() or ply:EntIndex()
    timer.Create("ZTCity_Protect_" .. sid, seconds, 1, function()
        if not IsValid(ply) then return end
        ply.ZTCity_ProtectUntil = nil
        ply:SetNWFloat("ZTCity_ProtectUntil", 0)
        ply:GodDisable()
        ply:SetRenderMode(RENDERMODE_NORMAL)
        ply:SetColor(Color(255, 255, 255, 255))
        Notify(ply, "Защита спавна снята", Color(180, 160, 100))
    end)
end

local function GiveStarterKit(ply)
    if not IsValid(ply) then return end
    ply:SetSuppressPickupNotices(true)
    ply.noSound = true

    if not ply:HasWeapon("weapon_hands_sh") then
        ply:Give("weapon_hands_sh")
    end

    if cv_start_band:GetBool() and weapons.Get("weapon_bandage_sh") and not ply:HasWeapon("weapon_bandage_sh") then
        ply:Give("weapon_bandage_sh")
    end

    ply:SelectWeapon("weapon_hands_sh")

    timer.Simple(0.15, function()
        if IsValid(ply) then ply.noSound = false end
    end)
    ply:SetSuppressPickupNotices(false)
end

local function DoRespawn(ply)
    if not IsValid(ply) or not IsZTCity() then return end
    if ply:Team() == TEAM_SPECTATOR then return end
    if ply:Alive() then return end

    ply.ZTCity_RespawnAt = nil
    ply:SetNWFloat("ZTCity_RespawnAt", 0)

    local spot = PickSpawnAwayFromEnemies(ply)

    ply:Spawn()
    if ApplyAppearance then ApplyAppearance(ply) end
    if ply.SetupTeam then ply:SetupTeam(0) end

    if spot then
        ply:SetPos(spot.pos + Vector(0, 0, 8))
        ply:SetEyeAngles(spot.ang or Angle(0, 0, 0))
    end

    GiveStarterKit(ply)
    zb.GiveRole(ply, "Оператор", Color(200, 160, 70))

    ApplySpawnProtection(ply, cv_protect:GetFloat())

    net.Start("ztcity_respawn_info")
        net.WriteFloat(0)
        net.WriteBool(true) -- just respawned
    net.Send(ply)

    Notify(ply, "Ты вернулся в ZT-City", Color(120, 200, 120))
    ply:EmitSound("items/suitchargeok1.wav", 50, 110)
end

local function QueueRespawn(ply)
    if not IsValid(ply) or not IsZTCity() then return end
    if ply:Team() == TEAM_SPECTATOR then return end

    local delay = math.max(0, cv_respawn:GetFloat())
    local when = CurTime() + delay
    ply.ZTCity_RespawnAt = when
    ply:SetNWFloat("ZTCity_RespawnAt", when)

    net.Start("ztcity_respawn_info")
        net.WriteFloat(when)
        net.WriteBool(false)
    net.Send(ply)

    local sid = ply:SteamID64() or ply:EntIndex()
    timer.Create("ZTCity_Respawn_" .. sid, delay, 1, function()
        if IsValid(ply) then DoRespawn(ply) end
    end)
end

-- ─── MODE API ──────────────────────────────────────────────────────────────
function MODE:CanLaunch()
    return true
end

function MODE:Intermission()
    -- Мягкий cleanup: не сносим статику карты жёстко (EFT-контейнеры = пропы карты)
    -- game.CleanUpMap() часто убивает всё — для ZT-City делаем только игроков
    for _, ply in player.Iterator() do
        if ply:Team() == TEAM_SPECTATOR then continue end
        if ApplyAppearance then ApplyAppearance(ply) end
        if ply.SetupTeam then ply:SetupTeam(0) end
    end

    RebuildSpawnCache()

    net.Start("ztcity_start")
        net.WriteFloat(cv_respawn:GetFloat())
        net.WriteFloat(cv_protect:GetFloat())
    net.Broadcast()
end

function MODE:RoundStart()
    RebuildSpawnCache()

    for _, ply in player.Iterator() do
        if ply:Team() == TEAM_SPECTATOR then continue end
        if not ply:Alive() then
            DoRespawn(ply)
        else
            GiveStarterKit(ply)
            zb.GiveRole(ply, "Оператор", Color(200, 160, 70))
            ApplySpawnProtection(ply, cv_protect:GetFloat())
        end
        ply.ZTCity_Kills = 0
        ply.ZTCity_Deaths = 0
        ply:SetNWInt("ZTCity_Kills", 0)
        ply:SetNWInt("ZTCity_Deaths", 0)
    end

    BroadcastNotify("ZT-City: открытый мир · респавн включён · ящики Z-City не спавнятся", Color(210, 170, 80))
    hook.Run("EFT_RaidStarted", "ztcity")
end

function MODE:GiveWeapons() end
function MODE:GiveEquipment() end

function MODE:RoundThink()
    -- Подстраховка: если таймер респавна прошёл, а игрок ещё мёртв
    for _, ply in player.Iterator() do
        if not IsValid(ply) or ply:Alive() then continue end
        if ply:Team() == TEAM_SPECTATOR then continue end
        local at = ply.ZTCity_RespawnAt
        if at and CurTime() >= at then
            DoRespawn(ply)
        end
    end
end

function MODE:ShouldRoundEnd()
    return false -- открытый мир, раунд не кончается от смертей
end

function MODE:CheckAlivePlayers()
    local t = {}
    for _, ply in player.Iterator() do
        if ply:Alive() and not (ply.organism and ply.organism.incapacitated) then
            t[#t + 1] = ply
        end
    end
    return t
end

function MODE:PlayerDeath(ply, inflictor, attacker)
    if not IsZTCity() then return end
    if not IsValid(ply) then return end

    ply.ZTCity_Deaths = (ply.ZTCity_Deaths or 0) + 1
    ply:SetNWInt("ZTCity_Deaths", ply.ZTCity_Deaths)

    if IsValid(attacker) and attacker:IsPlayer() and attacker ~= ply then
        attacker.ZTCity_Kills = (attacker.ZTCity_Kills or 0) + 1
        attacker:SetNWInt("ZTCity_Kills", attacker.ZTCity_Kills)
    end

    -- Снять защиту если была
    local sid = ply:SteamID64() or ply:EntIndex()
    timer.Remove("ZTCity_Protect_" .. sid)
    ply.ZTCity_ProtectUntil = nil
    ply:SetNWFloat("ZTCity_ProtectUntil", 0)

    QueueRespawn(ply)
end

-- Блокируем мгновенный «думающий» респавн движка, пока наш таймер не истечёт
function MODE:PlayerDeathThink(ply)
    if not IsZTCity() then return end
    if not IsValid(ply) then return end
    local at = ply.ZTCity_RespawnAt
    if at and CurTime() < at then
        return false -- не даём ядру зареспавнить раньше
    end
end

function MODE:CanSpawn(ply)
    if not IsZTCity() then return end
    -- Разрешаем спавн всегда в этом режиме (поздний вход, респавн)
    return true
end

function MODE:PlayerSpawn(ply)
    if not IsZTCity() then return end
    if not IsValid(ply) or ply:Team() == TEAM_SPECTATOR then return end

    -- Поздний вход во время раунда
    if zb.ROUND_STATE == 1 then
        timer.Simple(0, function()
            if not IsValid(ply) or not ply:Alive() then return end
            GiveStarterKit(ply)
            zb.GiveRole(ply, "Оператор", Color(200, 160, 70))
            if not ply.ZTCity_ProtectUntil or ply.ZTCity_ProtectUntil < CurTime() then
                ApplySpawnProtection(ply, cv_protect:GetFloat())
            end
        end)
    end
end

function MODE:EndRound()
    for _, ply in player.Iterator() do
        local sid = ply:SteamID64() or ply:EntIndex()
        timer.Remove("ZTCity_Respawn_" .. sid)
        timer.Remove("ZTCity_Protect_" .. sid)
        if IsValid(ply) then
            ply.ZTCity_RespawnAt = nil
            ply:SetNWFloat("ZTCity_RespawnAt", 0)
            ply:SetNWFloat("ZTCity_ProtectUntil", 0)
            if ply:Alive() then
                ply:GodDisable()
                ply:SetRenderMode(RENDERMODE_NORMAL)
                ply:SetColor(Color(255, 255, 255, 255))
            end
        end
    end

    hook.Run("EFT_RaidEnded", "ztcity")

    timer.Simple(0.5, function()
        net.Start("ztcity_end")
        net.Broadcast()
    end)
end

-- Защита: урон по защищённому игроку
hook.Add("EntityTakeDamage", "ZTCity_SpawnProtect", function(ent, dmg)
    if not IsZTCity() then return end
    if not IsValid(ent) or not ent:IsPlayer() then return end
    local until_t = ent.ZTCity_ProtectUntil
    if until_t and CurTime() < until_t then
        dmg:SetDamage(0)
        return true
    end
end)

-- На всякий случай глушим спавн box-лута Z-City
hook.Add("Boxes Think", "ZTCity_NoBoxSpawn", function()
    if IsZTCity() then return false end
end)

-- Админ-команды
concommand.Add("ztcity_force_respawn", function(ply)
    if IsValid(ply) and not ply:IsAdmin() then return end
    if not IsZTCity() then return end
    if IsValid(ply) and not ply:Alive() then
        DoRespawn(ply)
    end
end)

concommand.Add("ztcity_rebuild_spawns", function(ply)
    if IsValid(ply) and not ply:IsAdmin() then return end
    RebuildSpawnCache()
    local msg = "[ZT-City] Точек спавна: " .. #SpawnCache
    if IsValid(ply) then ply:ChatPrint(msg) else print(msg) end
end)

print("[ZT-City] Server OK · respawn · spawn-protect · no box spawn")
