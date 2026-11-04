AddCSLuaFile()

ENT.Type           = "ai"
ENT.Base           = "base_ai"
ENT.PrintName      = "Скупщик (Одесса)"
ENT.Author         = "EFT Loot System"
ENT.Category       = "EFT Loot System"
ENT.Spawnable      = true
ENT.AdminSpawnable = true
ENT.AutomaticFrameAdvance = true -- ВАЖНО: Чинит анимации и предотвращает Т-позы
ENT.Model          = "models/odessa.mdl" -- ВАЖНО: Фиксит спавн Аликс вместо Одессы

-- Полная интеграция с твоей EFT.ItemDatabase!
ENT.BuyPrices = {
    ["weapon_medkit_ifak"]        = { price = 4500 },
    ["weapon_glock17"]            = { price = 12000 },
    ["ent_ammo_9x19mmparabellum"] = { price = 1500 },
    ["weapon_bandage_sh"]         = { price = 500 },
    ["gear_backpack_sling"]       = { price = 2500 },
    ["mat_scrap_metal"]           = { price = 800 },
    ["mat_duct_tape"]             = { price = 400 }
}