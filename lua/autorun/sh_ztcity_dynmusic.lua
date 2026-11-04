--[[
    ZT-City — пакет динамической музыки для hg.DynaMusic

    КАК ДОБАВИТЬ СВОИ ТРЕКИ:
    1. Положи mp3 в:
         garrysmod/sound/zc_dyna_music/ztcity/
       (или в свой addon: addons/ТВОЙ_АДДОН/sound/zc_dyna_music/ztcity/)

    2. Имена файлов ниже — примеры. Замени на свои:
         ambient_01.mp3  — спокойный слой (уровень адреналина 0)
         combat_01.mp3   — бой (уровень 1+)
         intense_01.mp3  — жёсткий бой (уровень 3–4)

    3. Формат AddMusic(tbl, adrLevel, path, volume, repeats):
         adrLevel  — с какого «уровня напряжения» играет (0 = спокойно, 1+ = бой)
         path      — путь ОТНОСИТЕЛЬНО папки sound/ (без "sound/")
         volume    — множитель громкости (0.1–1)
         repeats   — сколько раз крутить слой, nil = бесконечно

    4. Можно добавить несколько sequence ("01", "02"...) — при старте раунда
       выбирается случайная.
]]

hg = hg or {}
hg.DynaMusic = hg.DynaMusic or {}
local DMusic = hg.DynaMusic

-- Ждём, пока загрузится базовый dynmusic (sh_packs.lua)
local function RegisterZTCityPack()
    if not DMusic.AddPack or not DMusic.MusicMeta then return false end

    local musMeta = DMusic.MusicMeta

    DMusic:AddPack("ztcity")

    -- ========== SEQUENCE 01 ==========
    do
        local Music = musMeta:CreateTbl()
        -- Спокойствие
        musMeta:AddMusic(Music, 0, "zc_dyna_music/ztcity/ambient_01.mp3", 0.2)
        -- Бой
        musMeta:AddMusic(Music, 1, "zc_dyna_music/ztcity/combat_01.mp3", 0.85)
        -- Интенсив
        musMeta:AddMusic(Music, 3, "zc_dyna_music/ztcity/intense_01.mp3", 1.0)
        DMusic:AddSequence("ztcity", "01", Music)
    end

    -- ========== SEQUENCE 02 (вторая «плита» — раунд может выбрать её) ==========
    do
        local Music = musMeta:CreateTbl()
        musMeta:AddMusic(Music, 0, "zc_dyna_music/ztcity/ambient_02.mp3", 0.2)
        musMeta:AddMusic(Music, 1, "zc_dyna_music/ztcity/combat_02.mp3", 0.85)
        musMeta:AddMusic(Music, 3, "zc_dyna_music/ztcity/intense_02.mp3", 1.0)
        DMusic:AddSequence("ztcity", "02", Music)
    end

    -- Добавь ещё sequence по тому же шаблону (03, 04...).

    print("[ZT-City] DynaMusic pack 'ztcity' registered.")
    return true
end

-- Регистрация после загрузки Homigrad / dynmusic
if RegisterZTCityPack() then
    -- ok
else
    hook.Add("HomigradRun", "ZTCity_RegisterMusic", function()
        RegisterZTCityPack()
    end)
    timer.Simple(2, function()
        RegisterZTCityPack()
    end)
end
