--[[
    EFT Patch: Гарантированная регистрация кастомных типов патронов
    ------------------------------------------------------------
    Кладите этот файл в lua/autorun/server/ (или в свою addon-структуру,
    главное чтобы он грузился ПОСЛЕ основного файла с EFT.ItemDatabase).

    Суть проблемы: ply:GiveAmmo(count, ammoName) в GMod молча ничего
    не делает, если ammoName не зарегистрирован движком как валидный
    тип патрона (game.GetAmmoID(ammoName) вернёт -1). Слэш в ключах
    таблицы ("ent_ammo_12/70gauge") тут ни при чём — строковые ключи
    Lua-таблиц принимают любые символы без экранирования.

    Реальная причина: "5.45x39mm", "5.56x45mm", "9x19mmParabellum" —
    не встроенные типы патронов HL2/GMod (в отличие от "Buckshot",
    который всегда зарегистрирован). Они существуют только если их
    зарегистрировал твой оружейный аддон (ArcCW/TFA и т.п.), причём
    СТРОГО с таким же написанием и до того, как игрок попытается
    получить патроны через этот скрипт.

    Это решение:
    1. После полной загрузки сервера (когда все аддоны, включая
       оружейные базы, уже отработали game.AddAmmoType) проверяет
       каждый ammoName из EFT.ItemDatabase.
    2. Если тип патрона так и не зарегистрирован — регистрирует его
       сам как аварийный fallback, чтобы GiveAmmo/RemoveAmmo/
       GetAmmoCount ГАРАНТИРОВАННО работали, независимо от порядка
       загрузки аддонов.
    3. Добавляет консольную команду eft_checkammo для диагностики —
       чтобы сразу видеть, какие типы патронов реально не совпадают.
--]]

if not SERVER then return end

local function EnsureAmmoTypeExists(ammoName)
    if not ammoName or ammoName == "" then return end
    if game.GetAmmoID(ammoName) ~= -1 then return end -- уже зарегистрирован кем-то другим (ArcCW/TFA/etc)

    game.AddAmmoType({
        name = ammoName,
        dmgtype = DMG_BULLET,
        tracer = TRACER_LINE,
        plydmg = 15,
        npcdmg = 15,
        maxsplash = 4,
        minsplash = 2,
        force = 3,
    })

    print(("[EFT] Тип патрона '%s' не был зарегистрирован — зарегистрирован автоматически (fallback)."):format(ammoName))
end

-- Ждём InitPostEntity + небольшую задержку, чтобы оружейные аддоны
-- успели зарегистрировать свои типы ПЕРВЫМИ — тогда мы просто это
-- обнаружим и ничего не тронем. Если не успели/не зарегистрировали —
-- подстрахуем сами.
hook.Add("InitPostEntity", "EFT_EnsureAmmoTypesExist", function()
    timer.Simple(1, function()
        if not EFT or not EFT.ItemDatabase then return end
        for id, data in pairs(EFT.ItemDatabase) do
            if data.type == "ammo" and data.ammoName then
                EnsureAmmoTypeExists(data.ammoName)
            end
        end
    end)
end)

-- Диагностика: показывает точное состояние каждого типа патрона на сервере
concommand.Add("eft_checkammo", function(ply)
    local function reply(msg)
        if IsValid(ply) then ply:ChatPrint(msg) else print(msg) end
    end

    if not EFT or not EFT.ItemDatabase then
        reply("[EFT] EFT.ItemDatabase не найдена — файл лутинг-системы не загружен.")
        return
    end

    for id, data in pairs(EFT.ItemDatabase) do
        if data.type == "ammo" and data.ammoName then
            local ammoID = game.GetAmmoID(data.ammoName)
            reply(("[EFT] %s -> ammoName='%s' -> ID=%d (%s)")
                :format(id, data.ammoName, ammoID, ammoID == -1 and "НЕ ЗАРЕГИСТРИРОВАН" or "OK"))
        end
    end
end)
