--[[
    Z-City Addon: Escape From Tarkov Looting & Inventory System (ULTIMATE COMPATIBLE)
    v8 — Модели Таркова (PM Pack), Разгрузки, Стакание, Респавн Лута, Быстрый Лутинг, Обыск и Верстак
--]]

AddCSLuaFile()

EFT = EFT or {}

-- ==========================================
-- КОНФИГУРАЦИЯ
-- ==========================================
EFT.Config = {
    CellSize = 46,
    ExamineSpeed = 0.34,  -- ~3 сек на полоску осмотра одного предмета

    SearchSpeed = 0.5,            -- Скорость обыска контейнеров (множитель прогресса в секунду)
    CraftSpeed = 0.3,             -- Скорость крафта на верстаке (множитель прогресса в секунду)
    LootDistance = 160,
    -- Авто-обыск: предметы открываются сами (без клика игрока)
    AutoRevealMin = 3.0,
    AutoRevealMax = 3.0,
    NetCooldown = 0.1,

    CorpseGridWidth = 8,
    CorpseGridHeight = 8,

    -- Личный инвентарь
    PersonalGridBaseW = 0,  -- карманы отключены; слоты только в одежде/рюкзаке/разгрузке
    PersonalGridBaseH = 0,

    BaseCarryCapacity = 15,        -- кг
    OverloadDamage = 3,            -- урон за тик перегруза
    OverloadInterval = 10,         -- секунд между тиками
    BackpackWeightDiscount = 0.6,  -- скидка веса в рюкзаке

    -- Респавн лута в контейнерах
    LootRespawnTime = 900,         -- Респавн каждые 15 минут (900 сек).
    LootRespawnRandomOffset = 120, -- Рандомное отклонение +- 2 минуты (120 сек)

    LimbMaxHealth = { head = 35, thorax = 85, stomach = 70, leftarm = 60, rightarm = 60, leftleg = 65, rightleg = 65 },
    LimbOrder = { "head", "thorax", "stomach", "leftarm", "rightarm", "leftleg", "rightleg" },
    LimbLabels = {
        head = "ГОЛОВА", thorax = "ГРУДЬ", stomach = "ЖИВОТ",
        leftarm = "ЛЕВАЯ РУКА", rightarm = "ПРАВАЯ РУКА",
        leftleg = "ЛЕВАЯ НОГА", rightleg = "ПРАВАЯ НОГА",
    },
}

-- ==========================================
-- РЕДКОСТЬ ПРЕДМЕТОВ
-- ==========================================
EFT.Rarity = {
    common    = { label = "Обычный",     color = Color(165, 165, 165), weight = 100 },
    uncommon  = { label = "Необычный",   color = Color(95, 200, 100),  weight = 55  },
    rare      = { label = "Редкий",      color = Color(70, 150, 235),  weight = 22  },
    epic      = { label = "Эпический",   color = Color(180, 95, 230),  weight = 8   },
    legendary = { label = "Легендарный", color = Color(235, 180, 40),  weight = 2   },
}

EFT.CategoryOrder = { "all", "weapon", "ammo", "armor", "backpack", "rig", "attachment", "utility", "food", "valuable", "medicine", "part", "tool" }
EFT.CategoryLabels = {
    all = "Всё", weapon = "Оружие", ammo = "Патроны", armor = "Броня", backpack = "Рюкзаки", rig = "Разгрузки",
    attachment = "Обвесы", utility = "Снаряжение", food = "Еда", valuable = "Материалы / Хлам", medicine = "Медицина",
    part = "Детали", tool = "Инструменты",
}

-- ==========================================
-- БАЗА ДАННЫХ ПРЕДМЕТОВ (ТАРКОВ ПАК)
-- ==========================================
EFT.ItemDatabase = {
    -- --- Оружие ---
    ["weapon_ak74"] = {
        name = "АК-74Н", w = 2, h = 4, rarity = "epic", weight = 3.6, canStore = false, hands = 2,
        desc = "Автомат Калашникова калибра 5.45x39мм. Легендарная надежность.",
        model = "models/weapons/tfa_ins2/akpack/w_ak74.mdl",
        type = "weapon", buyPrice = 55000, ammoType = "5.45x39mm", sound = "weapons/ak47/ak47_draw.wav",
    },
    ["weapon_m4a1"] = {
        name = "M16A4", w = 2, h = 4, rarity = "epic", weight = 3.4, canStore = false, hands = 2,
        desc = "Штурмовая винтовка калибра 5.56x45мм на платформе AR.",
        model = "models/weapons/arccw/c_ud_m16.mdl",
        type = "weapon", buyPrice = 58000, ammoType = "5.56x45mm", sound = "weapons/m4a1/m4a1_deploy.wav",
    },
	["weapon_toz106"] = {
        name = "Toz-106", w = 2, h = 4, rarity = "epic", weight = 3.5, canStore = false, hands = 2,
        desc = "дробовик 12 калибра, с продольно-скользящим затвором.",
        model = "models/weapons/arc9/darsu_eft/c_toz106.mdl",
        type = "weapon", buyPrice = 28000, ammoType = "Buckshot", sound = "weapons/m3/m3_pump.wav",
    },
    ["weapon_xm1014"] = {
        name = "Benelli XM1014", w = 2, h = 4, rarity = "epic", weight = 3.5, canStore = false, hands = 2,
        desc = "Полуавтоматический дробовик 12 калибра.",
        model = "models/weapons/arccw/c_ud_m1014.mdl",
        type = "weapon", buyPrice = 40000, ammoType = "Buckshot", sound = "weapons/m3/m3_pump.wav",
    },
    ["weapon_mp5"] = {
        name = "MP5 Navy", w = 2, h = 3, rarity = "epic", weight = 2.9, canStore = false, hands = 2,
        desc = "Компактный пистолет-пулемет калибра 9x19мм.",
        model = "models/weapons/w_smg_mp5.mdl",
        type = "weapon", buyPrice = 42000, ammoType = "9x19mmParabellum", sound = "weapons/mp5/mp5_deploy.wav",
    },
    ["weapon_glock17"] = {
        name = "Glock P80", w = 1, h = 2, rarity = "rare", weight = 0.9, canStore = true, hands = 1,
        desc = "Полимерный пистолет калибра 9x19мм. Компактный.",
        model = "models/weapons/tfa_ins2/w_glock_p80.mdl",
        type = "weapon", buyPrice = 15000, ammoType = "9x19mmParabellum", sound = "universal/uni_pistol_draw_02.wav	",
    },
    ["weapon_akmwreked"] = { -- ЗАГЛУШКА: модель заглушка (АК), нет отдельной уникальной модели под "самосбор"
        name = "Самодельный Автомат", w = 2, h = 4, rarity = "epic", weight = 3.8, canStore = false, hands = 2,
        desc = "Винтовка, собранная вручную на верстаке из ствола, корпуса, цевья и приклада. Каждая — уникальна.",
        model = "models/weapons/zcity/w_akm_bw.mdl",
        type = "weapon", ammoType = "7.62x39 mm", sound = "universal/uni_pistol_draw_03.wav",
    },
	 ["weapon_pm9"] = { -- пистолет PM9 — одна рука
        name = "PM 9", w = 1, h = 2, rarity = "rare", weight = 0.9, canStore = true, hands = 1,
        desc = "Самодельный пистолет калибра 9x19мм. Компактный, занимает одну руку.",
        model = "models/weapons/pm9v2.mdl",
        type = "weapon", ammoType = "9x19 mm Parabellum", sound = "weapons/universal/uni_pistol_draw_01.wav",
    },

    -- --- Холодное оружие ---
    ["weapon_bat"] = {
        name = "Деревянная бита", w = 1, h = 3, rarity = "common", weight = 1.3, canStore = true, hands = 1, isMelee = true,
        desc = "Тяжелая деревянная бита. Дешевое оружие. Занимает одну руку.",
        model = "models/weapons/tfa_nmrih/w_me_bat_wood.mdl", type = "weapon", buyPrice = 800,
    },
    ["weapon_buck200knife"] = {
        name = "Нож Buck 200", w = 1, h = 1, rarity = "common", weight = 0.4, canStore = true, hands = 1, isMelee = true,
        desc = "Охотничий нож с фиксированным лезвием из высокопрочной стали. Занимает одну руку.",
        model = "models/zcity/weapons/custom_knife/buck.mdl", type = "weapon", buyPrice = 2000,
    },

    -- --- Патроны (Стакаемые) ---
	["ent_ammo_5.45x39mm"] = {
        name = "Патроны 5.45x39мм ФМЖ", w = 1, h = 1, rarity = "uncommon", weight = 0.012, maxStack = 60,
        desc = "Промежуточный патрон для автоматов семейства АК.",
        model = "models/zcity/ammo/ammo_545x39_fmj.mdl",
        type = "ammo", ammoName = "5.45x39 mm", sound = "weapons/smg1/switch_single.wav",
    },
    
	["ent_ammo_7.62x39mm"] = {
        name = "Патроны 7.62x39mm", w = 1, h = 1, rarity = "common", weight = 0.012, maxStack = 60,
        desc = " советский промежуточный боеприпас с диаметром пули 7,92 мм и длиной гильзы 39 мм АКМ.",
        model = "models/zcity/ammo/ammo_545x39_fmj.mdl",
        type = "ammo", ammoName = "7.62x39 mm", sound = "weapons/smg1/switch_single.wav",
    },
    ["ent_ammo_5.56x45mm"] = {
        name = "Патроны 5.56x45мм ", w = 1, h = 1, rarity = "uncommon", weight = 0.013, maxStack = 60,
        desc = "Бронебойный патрон НАТО для карабинов.",
        model = "models/zcity/ammo/ammo_556x45_ap.mdl",
        type = "ammo", ammoName = "5.56x45 mm", sound = "weapons/smg1/switch_single.wav",
    },
    ["ent_ammo_12/70gauge"] = {
        name = "Патроны 12/70 Дробь", w = 1, h = 1, rarity = "common", weight = 0.045, maxStack = 20,
        desc = "Дробовые патроны 12 калибра для ружей.",
        model = "models/zcity/ammo/ammo_12x70_buck.mdl",
        type = "ammo", ammoName = "12/70 gauge", sound = "weapons/smg1/switch_single.wav",
    },
    ["ent_ammo_9x19mmparabellum"] = {
        name = "Патроны 9x19мм Parabellum", w = 1, h = 1, rarity = "common", weight = 0.010, maxStack = 50,
        desc = "Стандартный пистолетный патрон.",
        model = "models/items/boxsrounds.mdl",
        type = "ammo", ammoName = "9x19 mm Parabellum", sound = "weapons/smg1/switch_single.wav",
    },
    ["ent_ammo_5.7x28mm"] = {
        name = "Патроны 5.7x28mm", w = 1, h = 1, rarity = "common", weight = 0.010, maxStack = 50,
        desc = "Патроны для пушек P90.",
        model = "models/items/boxsrounds.mdl",
        type = "ammo", ammoName = "5.7x28 mm", sound = "weapons/smg1/switch_single.wav",
    },
    -- --- РЮКЗАКИ (ТАРКОВ ПАК) ---
    ["gear_backpack_sling"] = {
        name = "Слинг Molle Sling Bag", w = 2, h = 2, rarity = "common", weight = 0.8, capacity = 4,
        gridSize = { w = 4, h = 4 },
        desc = "Крошечная тактическая сумка через плечо. Сетка: 4x4.",
        model = "models/player/backpack_sling/sling.mdl", type = "backpack",
    },
    ["gear_backpack_tbag"] = {
        name = "Сумка T Bag", w = 2, h = 2, rarity = "common", weight = 0.9, capacity = 4,
        gridSize = { w = 4, h = 4 },
        desc = "Минималистичный рюкзак для самого необходимого. Сетка: 4x4.",
        model = "models/player/backpack_tactical/tactical.mdl", type = "backpack",
    },
    ["gear_backpack_vkbo"] = {
        name = "Армейский ранец ВКБО", w = 2, h = 2, rarity = "uncommon", weight = 1.1, capacity = 6,
        gridSize = { w = 5, h = 5 },
        desc = "Уставной рюкзак армии РФ. Сетка: 5x5.",
        model = "models/player/backpack_vkbo/vkbo.mdl", type = "backpack",
    },
    ["gear_backpack_duffle"] = {
        name = "Спортивная сумка Duffle", w = 3, h = 2, rarity = "uncommon", weight = 1.3, capacity = 8,
        gridSize = { w = 5, h = 5 },
        desc = "Вместительная спортивная сумка с удобными отсеками. Сетка: 5x5.",
        model = "models/player/backpack_sportbag/sportbag.mdl", type = "backpack",
    },
    ["gear_backpack_scav"] = {
        name = "Рюкзак Дикого (Scav)", w = 2, h = 3, rarity = "uncommon", weight = 1.4, capacity = 10,
        gridSize = { w = 5, h = 6 },
        desc = "Потрепанный, но надежный гражданский рюкзак. Сетка: 5x6.",
        model = "models/player/backpack_baselardwild/scavbp.mdl", type = "backpack",
    },
    ["gear_backpack_trizip"] = {
        name = "Рюкзак Trizip", w = 2, h = 3, rarity = "rare", weight = 2.1, capacity = 14,
        gridSize = { w = 6, h = 8 },
        desc = "Профессиональный экспедиционный рюкзак. Сетка: 6x8.",
        model = "models/player/backpack_trizip/trizip.mdl", type = "backpack",
    },
        ["gear_backpack_paratus"] = {
        name = "Рюкзак Paratus 3-Day", w = 3, h = 3, rarity = "epic", weight = 2.8, capacity = 18,
        gridSize = { w = 7, h = 8 },
        desc = "Трехдневный тактический рюкзак высшего класса качества. Сетка: 7x8.",
        model = "models/player/backpack_paratus_3_day/paratus.mdl", type = "backpack",
    },
    ["gear_backpack_pilgrim"] = {
        name = "Туристический рюкзак Pilgrim", w = 3, h = 4, rarity = "epic", weight = 3.2, capacity = 22,
        gridSize = { w = 8, h = 8 },
        desc = "Огромный туристический рюкзак яркого окраса. Сетка: 8x8.",
        model = "models/player/backpack_pilgrim/pilgrim.mdl", type = "backpack",
    },
    ["gear_backpack_blackjack"] = {
        name = "Военный гигант Blackjack", w = 3, h = 4, rarity = "legendary", weight = 4.1, capacity = 28,
        gridSize = { w = 8, h = 10 },
        desc = "Легендарный армейский рюкзак максимальной вместимости. Сетка: 8x10.",
        model = "models/player/backpack_blackjack/blackjack.mdl", type = "backpack",
    },

    -- --- БРОНЕЖИЛЕТЫ, ШЛЕМЫ, МАСКИ И НАУШНИКИ (НОВЫЙ GEAR-ПАК) ---
    -- Модели этих предметов не прописаны вручную — они автоматически подтягиваются
    -- с одноимённых серверных сущностей (см. EFT.ResolveGearModels ниже), поэтому
    -- поле model здесь не задаётся напрямую.
    ["ent_armor_vest1"] = {
        name = "Бронежилет Vest 1", w = 2, h = 2, rarity = "common", weight = 2.2,
        armorSlot = "vest", armorValue = 20,
        desc = "Лёгкий бронежилет начального уровня защиты.",
        type = "armor",
    },
    ["ent_armor_vest2"] = {
        name = "Бронежилет Vest 2", w = 2, h = 2, rarity = "common", weight = 2.8,
        armorSlot = "vest", armorValue = 30,
        desc = "Бронежилет среднего класса защиты.",
        type = "armor",
    },
    ["ent_armor_vest3"] = {
        name = "Бронежилет Vest 3", w = 3, h = 2, rarity = "uncommon", weight = 3.6,
        armorSlot = "vest", armorValue = 40,
        desc = "Усиленный бронежилет с керамическими вставками.",
        type = "armor",
    },
    ["ent_armor_vest4"] = {
        name = "Бронежилет Vest 4", w = 3, h = 3, rarity = "uncommon", weight = 4.5,
        armorSlot = "vest", armorValue = 50,
        desc = "Тяжёлый штурмовой бронежилет.",
        type = "armor",
    },
    ["ent_armor_vest5"] = {
        name = "Бронежилет Vest 5", w = 3, h = 3, rarity = "rare", weight = 5.4,
        armorSlot = "vest", armorValue = 60,
        desc = "Бронежилет повышенного класса защиты.",
        type = "armor",
    },
    ["ent_armor_vest7"] = {
        name = "Бронежилет Vest 7", w = 3, h = 3, rarity = "epic", weight = 7.0,
        armorSlot = "vest", armorValue = 75,
        desc = "Элитный бронежилет с максимальной защитой корпуса.",
        type = "armor",
    },
    ["ent_armor_vest8"] = {
        name = "Бронежилет Vest 8", w = 3, h = 4, rarity = "legendary", weight = 9.5,
        armorSlot = "vest", armorValue = 90,
        desc = "Легендарный тяжёлый бронежилет высшего класса защиты.",
        type = "armor",
    },

    ["ent_armor_helmet1"] = {
        name = "Шлем Helmet 1", w = 2, h = 2, rarity = "common", weight = 1.1,
        armorSlot = "helmet", armorValue = 15,
        desc = "Простой защитный шлем.",
        type = "armor",
    },
    ["ent_armor_helmet3"] = {
        name = "Шлем Helmet 3", w = 2, h = 2, rarity = "uncommon", weight = 1.4,
        armorSlot = "helmet", armorValue = 25,
        desc = "Тактический шлем среднего класса защиты.",
        type = "armor",
    },
    ["ent_armor_helmet5"] = {
        name = "Шлем Helmet 5", w = 2, h = 2, rarity = "rare", weight = 1.7,
        armorSlot = "helmet", armorValue = 35,
        desc = "Композитный баллистический шлем.",
        type = "armor",
    },
    ["ent_armor_helmet6"] = {
        name = "Шлем Helmet 6", w = 2, h = 2, rarity = "epic", weight = 2.0,
        armorSlot = "helmet", armorValue = 45,
        desc = "Тяжёлый штурмовой шлем повышенной защиты.",
        type = "armor",
    },
    ["ent_armor_helmet7"] = {
        name = "Шлем Helmet 7", w = 2, h = 2, rarity = "legendary", weight = 2.3,
        armorSlot = "helmet", armorValue = 55,
        desc = "Элитный шлем с максимальным классом защиты.",
        type = "armor",
    },

    ["ent_armor_mask1"] = {
        name = "Маска Mask 1", w = 1, h = 1, rarity = "common", weight = 0.3,
        armorSlot = "mask", armorValue = 5,
        desc = "Тактическая маска для лица с небольшой защитой.",
        type = "armor",
    },
    ["ent_armor_mask2"] = {
        name = "Маска Mask 2", w = 1, h = 1, rarity = "uncommon", weight = 0.4,
        armorSlot = "mask", armorValue = 10,
        desc = "Усиленная защитная маска.",
        type = "armor",
    },
    ["ent_armor_mask3"] = {
        name = "Маска Mask 3", w = 1, h = 1, rarity = "rare", weight = 0.5,
        armorSlot = "mask", armorValue = 15,
        desc = "Балаклава с бронированной вставкой.",
        type = "armor",
    },

    ["ent_armor_headphones1"] = {
        name = "Тактические наушники", w = 1, h = 1, rarity = "uncommon", weight = 0.3,
        armorSlot = "headphones", armorValue = 0,
        desc = "Активные наушники для улучшения слуха. Защиты не дают.",
        type = "armor",
    },

       -- --- Разгрузки (Rig) ---
    ["gear_rig_scav"] = {
        name = "Жилет Дикого", w = 2, h = 2, rarity = "common", weight = 1.2,
        gridSize = { w = 3, h = 3 },
        desc = "Простая тканевая разгрузка. Предоставляет сетку 3x3.",
        model = "models/combataegis/body/ballisticvest.mdl", type = "rig",
    },
    ["gear_rig_wartech"] = {
        name = "Разгрузка Wartech", w = 3, h = 2, rarity = "rare", weight = 2.4,
        gridSize = { w = 4, h = 4 },
        desc = "Многофункциональная разгрузочная система. Сетка: 4x4.",
        model = "models/ney/tarkov/gear/6b45_02.mdl", type = "rig",
    },

    -- --- Медицина ---
    ["weapon_painkillers"] = {
        name = "Обезболивающее", w = 1, h = 1, rarity = "uncommon", weight = 0.1, healAmount = 20, price = 90,
        maxUses = 4, isPainkiller = true, painkillerDuration = 45,
        desc = "Снимает боль. Использований: 4.",
        model = "models/bloocobalt/l4d/items/w_eq_pills.mdl", type = "medicine",
    },
    ["weapon_bandage_sh"] = {
        name = "Бинт", w = 1, h = 1, rarity = "common", weight = 0.2, healAmount = 15, price = 40,
        maxUses = 2, desc = "Останавливает кровотечение. Использований: 2.",
        model = "models/bandages.mdl", type = "medicine",
    },
    ["weapon_medkit_ifak"] = {
        name = "Аптечка IFAK", w = 1, h = 1, rarity = "rare", weight = 0.5, price = 320,
        maxHP = 300, desc = "Индивидуальная аптечка. Запас здоровья: 300 HP.",
        model = "models/weapons/sweps/eft/afak/w_meds_afak.mdl", type = "medicine", healAmount = 50,
    },

    -- --- Еда ---
    ["weapon_bigconsumable"] = {
        name = "Набор фастфуда", w = 2, h = 2, rarity = "uncommon", weight = 0.6, price = 150,
        desc = "Большая порция еды навынос. Хватает на 3 перекуса.", maxUses = 3,
        model = "models/foodnhouseholditems/mcdburgerbox.mdl", type = "food",
    },
    ["food_milk"] = {
        name = "Молоко", w = 1, h = 1, rarity = "common", weight = 1.0, price = 45, maxUses = 1,
        desc = "Пакет молока.", model = "models/foodnhouseholditems/milk.mdl", type = "food",
    },
    ["food_water_bottle"] = {
        name = "Бутылка воды", w = 1, h = 1, rarity = "common", weight = 0.5, price = 20, maxUses = 2,
        desc = "Бутылка питьевой воды на 2 глотка.", model = "models/props/cs_office/water_bottle.mdl", type = "food",
    },

    -- --- Ресурсы и хлам для крафта ---
    ["mat_scrap_metal"] = {
        name = "Металлолом", w = 1, h = 1, rarity = "common", weight = 0.8, price = 50,
        desc = "Куски старого железа. Основной материал для крафта оружия и патронов на верстаке.",
        model = "models/props_junk/garbage_metalcan001a.mdl", type = "valuable",
    },
    ["mat_wood_plank"] = {
        name = "Деревянная доска", w = 1, h = 2, rarity = "common", weight = 1.5, price = 40,
        desc = "Прочная сосновая доска. Необходима для прикладов оружия или ящиков.",
        model = "models/props_debris/wood_board04a.mdl", type = "valuable",
    },
    ["mat_electronics"] = {
        name = "Микросхемы", w = 1, h = 1, rarity = "rare", weight = 0.2, price = 180,
        desc = "Остатки печатных плат и электронных компонентов. Важный ресурс для высокотехнологичной сборки.",
        model = "models/ney/tarkov/barter/item_barter_electr_components_lod0_0.mdl", type = "valuable",
    },
    ["mat_gunpowder"] = {
        name = "Оружейный порох", w = 1, h = 1, rarity = "uncommon", weight = 0.3, price = 120,
        desc = "Банка бездымного пороха. Используется для крафта патронов.",
        model = "models/eft/misk/garb_cannedempty_4.mdl", type = "valuable_ammo",
    },
    ["mat_fabric"] = {
        name = "Прочная ткань", w = 1, h = 1, rarity = "common", weight = 0.4, price = 30,
        desc = "Кусок прочного нейлона. Идеально подходит для крафта рюкзаков, разгрузок или перевязочных бинтов.",
        model = "models/ney/tarkov/barter/item_barter_other_cloth_cordura_lod0_0.mdl", type = "valuable",
    },
    ["mat_duct_tape"] = {
        name = "Клейкая лента", w = 1, h = 1, rarity = "common", weight = 0.15, price = 20,
        desc = "Рулон армированного скотча. Мелкий, но незаменимый расходник для любой починки.",
        model = "models/props_junk/metal_paintcan001a.mdl", type = "valuable",
    },
    ["mat_rubber"] = {
        name = "Резиновый шланг", w = 1, h = 1, rarity = "uncommon", weight = 0.5, price = 60,
        desc = "Кусок толстой резины. Пригождается там, где нужна амортизация или герметичность.",
        model = "models/ney/tarkov/barter/building_hose_lod0_0.mdl", type = "valuable",
    },
    ["mat_glass_shards"] = {
        name = "Осколки стекла", w = 1, h = 1, rarity = "common", weight = 0.2, price = 12,
        desc = "Горсть битого стекла. Почти хлам, но иногда идёт в дело.",
        model = "models/props_junk/garbage_glassbottle003a.mdl", type = "valuable",
    },
    ["mat_plastic"] = {
        name = "Пластиковые детали", w = 1, h = 1, rarity = "common", weight = 0.3, price = 25,
        desc = "Обломки бытового пластика. Годятся на мелкие корпусные детали.",
        model = "models/props_junk/garbage_plasticbottle003a_6pack.mdl", type = "valuable",
    },

    -- --- Детали оружия для сборки на верстаке (тип "part" — отдельная категория лута) ---
    ["part_barrel"] = {
        name = "Ствол (дуло)", w = 1, h = 2, rarity = "rare", weight = 0.9, price = 220,
        desc = "Оружейный ствол. Основа точности любой сборки — без него оружие не соберёшь.",
        model = "models/ney/tarkov/quest/item_quest_chemcontainer_lod0_0.mdl", type = "part",
    },
    ["part_receiver"] = {
        name = "Рукоять и корпус", w = 1, h = 2, rarity = "rare", weight = 1.1, price = 260,
        desc = "Ствольная коробка и рукоять. Несущий элемент, вокруг которого собирается всё остальное.",
        model = "models/weapons/w_rifle_ak47.mdl", type = "part",
    },
    ["part_handguard"] = {
        name = "Цевье", w = 2, h = 1, rarity = "rare", weight = 0.4, price = 150,
        desc = "Цевье для удержания оружия за переднюю часть. Без него ствол голый и неудобный.",
        model = "models/props_c17/TrapPropeller_Lever.mdl", type = "part",
    },
    ["part_stock"] = {
        name = "Приклад", w = 1, h = 2, rarity = "rare", weight = 0.7, price = 190,
        desc = "Приклад для упора в плечо. Завершающая деталь полноценной сборки.",
        model = "models/props_c17/pulleywheels_small01.mdl", type = "part",
    },

    -- --- Обвесы (прицелы, коллиматоры) ---
    ["ent_att_holo4"] = {
        name = "Прицел Walther MRS", w = 1, h = 1, rarity = "rare", weight = 0.35, price = 9500,
        desc = "Голографический прицел с широким полем зрения. Быстрое прицеливание на короткой и средней дистанции.",
        model = "models/weapons/arc9/darsu_eft/mods/scope_all_walther_mrs.mdl", type = "attachment",
    },
    ["ent_att_holo5"] = {
        name = "Прицел ЕКП-7", w = 1, h = 1, rarity = "rare", weight = 0.3, price = 8800,
        desc = "Отечественный коллиматорный прицел закрытого типа. Надежен и неприхотлив.",
        model = "models/weapons/arc9/darsu_eft/mods/scope_all_ekb_okp7.mdl", type = "attachment",
    },
    ["ent_att_optic4"] = {
        name = "Прицел ПСО-1М2", w = 1, h = 2, rarity = "epic", weight = 0.6, price = 14500,
        desc = "Оптический прицел кратностью 4x с дальномерной сеткой. Классика для точной стрельбы на дистанции.",
        model = "models/weapons/arc9_eft_shared/atts/optic/dovetail/pso1m2.mdl", type = "attachment",
    },

    -- --- Глушители и дульные насадки ---
    ["ent_att_supressor4"] = {
        name = "Глушитель 9mm", w = 1, h = 2, rarity = "uncommon", weight = 0.4, price = 6200,
        desc = "Компактный глушитель под 9x19мм. Заметно снижает звук выстрела и скрывает вспышку.",
        model = "models/cw2/attachments/9mmsuppressor.mdl", type = "attachment",
    },
    ["ent_att_supressor1"] = {
        name = "Глушитель АК", w = 1, h = 2, rarity = "uncommon", weight = 0.55, price = 7000,
        desc = "Штатный глушитель для автоматов калашникова. Проверенное временем решение.",
        model = "models/weapons/upgrades/a_suppressor_ak.mdl", type = "attachment",
    },
    ["ent_att_supressor6"] = {
        name = "Самодельный глушитель из бутылки", w = 1, h = 2, rarity = "common", weight = 0.3, price = 900,
        desc = "Кустарная банка из пластиковой бутылки и наполнителя. Хватает на пару выстрелов, потом раскисает — зато почти бесплатно.",
        model = "models/atts/homemadesuppressor/plastic_bottle_1.mdl", type = "attachment",
    },

    -- --- Кустарный придуманный обвес ---
    ["ent_att_flashlight_tape"] = {
        name = "Фонарь на изоленте", w = 1, h = 1, rarity = "common", weight = 0.2, price = 1200,
        desc = "Обычный ручной фонарик, примотанный изолентой к цевью. Светит хуже штатного крепления, но зато свой, родной.",
        model = "models/props_c17/streetlight002_lamp.mdl", type = "attachment",
    },


    -- --- Инструменты (бесконечные, не расходуются при крафте) ---
    ["tool_sewing_basic"] = {
        name = "Простой швейный набор", w = 2, h = 1, rarity = "uncommon", weight = 0.8, price = 2500,
        desc = "Набор иголок и ниток для шитья лёгких рюкзаков. Не расходуется при крафте.",
        model = "models/eftpropspack/item_container_smallitems.mdl", type = "tool", isTool = true,
    },
    ["tool_sewing_advanced"] = {
        name = "Продвинутый набор для шитья", w = 2, h = 2, rarity = "rare", weight = 1.2, price = 8000,
        desc = "Профессиональный швейный набор для крупных рюкзаков. Не расходуется при крафте.",
        model = "models/eftpropspack/item_container_injectorcase.mdl", type = "tool", isTool = true,
    },
    ["tool_work_light"] = {
        name = "Инструменты для лёгкой работы", w = 2, h = 1, rarity = "uncommon", weight = 1.5, price = 4500,
        desc = "Отвёртки, напильники, тиски — для пистолетов, ножей и мелкой сборки. Не расходуется.",
        model = "models/eftpropspack/item_container_gamma_tue.mdl", type = "tool", isTool = true,
    },
    ["tool_work_heavy"] = {
        name = "Инструменты для тяжёлой работы", w = 2, h = 2, rarity = "rare", weight = 3.0, price = 12000,
        desc = "Тяжёлый набор для сборки автоматов и винтовок. Не расходуется при крафте.",
        model = "models/eftpropspack/plano_pistol_case.mdl", type = "tool", isTool = true,
    },
    ["tool_ammo_kit"] = {
        name = "Набор для изготовления боеприпасов", w = 2, h = 2, rarity = "rare", weight = 2.0, price = 9000,
        desc = "Пресс, гильзы-формы и весы для снаряжения патронов. Не расходуется при крафте.",
        model = "models/eftpropspack/item_container_ammo.mdl", type = "tool", isTool = true,
    },
    ["tool_lockpick"] = {
        name = "Отмычка", w = 1, h = 1, rarity = "uncommon", weight = 0.10, price = 500,
        desc = "Слесарный набор для вскрытия сейфов. 30% шанс сломаться при попытке. При поломке сейф не открывается.",
        model = "models/eftpropspack/item_container_keybar.mdl", type = "tool", isTool = true, isLockpick = true,
    },

    ["valuable_can"] = {
        name = "Пустая банка", w = 1, h = 1, rarity = "common", weight = 0.05, price = 15,
        desc = "Мятая жестяная банка.", model = "models/props_junk/popcan01a.mdl", type = "valuable",
    },
    ["valuable_bottle"] = {
        name = "Стеклянная бутылка", w = 1, h = 1, rarity = "common", weight = 0.2, price = 25,
        desc = "Пустая стеклянная бутылка.", model = "models/props_junk/garbage_glassbottle001a.mdl", type = "valuable",
    },
    ["valuable_gascan"] = {
        name = "Канистра с топливом", w = 2, h = 2, rarity = "legendary", weight = 20, price = 10000,
        desc = "Полная канистра бензина.", model = "models/props_junk/gascan001a.mdl", type = "valuable",
    },
}


-- ==========================================
-- СЛОТЫ РУК ДЛЯ ОРУЖИЯ
-- Холодное / пистолеты = 1 рука; автоматы, винтовки, дробовики, ПП = 2 руки
-- ==========================================
function EFT.GetWeaponHands(itemID, db)
    db = db or (itemID and EFT.ItemDatabase[itemID]) or nil
    if not db or db.type ~= "weapon" then return 0 end
    if db.hands then return math.Clamp(tonumber(db.hands) or 1, 1, 2) end
    if db.isMelee then return 1 end
    local w, h = db.w or 1, db.h or 1
    if w <= 1 and h <= 2 then return 1 end
    if w <= 1 and h <= 3 and db.isMelee then return 1 end
    return 2
end

--- Возвращает раскладку оружия в руках игрока:
--- leftID, rightID, twoHanded (bool)
--- twoHanded=true: один двуручный ствол занимает ОБЕ руки (leftID==rightID)
function EFT.ResolveHandWeapons(ply)
    if not IsValid(ply) then return "", "", false end
    local active = ply:GetActiveWeapon()
    local activeClass = IsValid(active) and active:GetClass() or ""

    local oneHand = {}
    local twoHand = {}
    for _, wep in ipairs(ply:GetWeapons() or {}) do
        if not IsValid(wep) then continue end
        local class = wep:GetClass()
        if class == "weapon_fists" or class == "weapon_physgun" or class == "gmod_tool" or class == "weapon_physcannon" then
            continue
        end
        local db = EFT.ItemDatabase[class]
        local hands = EFT.GetWeaponHands(class, db)
        if hands <= 0 then
            if string.find(class, "knife", 1, true) or string.find(class, "bat", 1, true)
                or string.find(class, "pistol", 1, true) or string.find(class, "glock", 1, true)
                or string.find(class, "pm9", 1, true) then
                hands = 1
            else
                hands = 2
            end
        end
        if hands >= 2 then
            twoHand[#twoHand + 1] = class
        else
            oneHand[#oneHand + 1] = class
        end
    end

    local twoClass = nil
    for _, c in ipairs(twoHand) do
        if c == activeClass then twoClass = c break end
    end
    if not twoClass and #twoHand > 0 then twoClass = twoHand[1] end

    if twoClass then
        return twoClass, twoClass, true
    end

    local left, right = "", ""
    local ordered = {}
    for _, c in ipairs(oneHand) do
        if c == activeClass then table.insert(ordered, 1, c)
        else ordered[#ordered + 1] = c end
    end
    if ordered[1] then right = ordered[1] end
    if ordered[2] then left = ordered[2] end
    return left, right, false
end

EFT.ItemsByType = {}
for id, data in pairs(EFT.ItemDatabase) do
    EFT.ItemsByType[data.type] = EFT.ItemsByType[data.type] or {}
    table.insert(EFT.ItemsByType[data.type], id)
end

-- ==========================================
-- РЕЦЕПТЫ КРАФТА ДЛЯ ВЕРСТАКА
-- ==========================================
EFT.Recipes = {	
   {
        name = "Сделать разбитое стекло",
        category = "valuable",
        resultID = "mat_glass_shards",
        resultCount = 2,
        ingredients = {
	   { id = "valuable_bottle", count = 1 },

          }
       },
 {
        name = "Сделать цевье",
        category = "part",
        resultID = "part_handguard",
        resultCount = 1,
        ingredients = {	   
            { id = "mat_wood_plank", count = 2 },
           { id = "mat_scrap_metal", count = 4 },
        
	}
     },
    
   {
        name = "Сделать дуло",
        category = "part",
        resultID = "part_barrel",
        resultCount = 1,
        ingredients = {	   
            { id = "valuable_can", count = 2 },
           { id = "mat_scrap_metal", count = 5 },
        
	}
     },
   {
        name = "Сделать приклад",
        category = "part",
        resultID = "part_stock",
        resultCount = 1,
        ingredients = {	   
            { id = "mat_wood_plank", count = 3 },
            { id = "mat_scrap_metal", count = 2 },
	    { id = "mat_duct_tape", count = 2 },
        }
    },
{
        name = "Сборка: Тоз-106",
        category = "weapon",
        resultID = "weapon_toz106",
        resultCount = 1,
        ingredients = {
	    { id = "part_barrel", count = 1 },
            { id = "mat_scrap_metal", count = 9 },
            { id = "part_receiver", count = 1 },
            { id = "mat_duct_tape", count = 2 },
			{ id = "part_handguard", count = 1 },
			{ id = "part_stock", count = 1 },
	   } 
    },	
{
        name = "Сборка: PM 9",
        category = "weapon",
        resultID = "weapon_pm9",
        resultCount = 1,
        ingredients = {
	    { id = "part_barrel", count = 1 },
            { id = "mat_scrap_metal", count = 9 },
            { id = "part_receiver", count = 1 },
            { id = "mat_duct_tape", count = 2 },
        }
    },
     {
        name = "Сборка: Самодельная винтовка из деталей",
        category = "weapon",
        resultID = "weapon_akmwreked",
        resultCount = 1,
        ingredients = {
            { id = "part_barrel", count = 1 },
            { id = "part_receiver", count = 1 },
            { id = "part_handguard", count = 1 },
            { id = "part_stock", count = 1 },
            { id = "mat_scrap_metal", count = 10 },
            { id = "mat_duct_tape", count = 3 },
        }
    },
     {
        name = "Обвес: Самодельный глушитель из бутылки",
        category = "attachment",
        resultID = "ent_att_supressor6",
        resultCount = 1,
        ingredients = {
            { id = "valuable_bottle", count = 1 },
            { id = "mat_duct_tape", count = 2 },
            { id = "mat_rubber", count = 1 },
        }
    },
    {
        name = "Обвес: Глушитель 9mm",
        category = "attachment",
        resultID = "ent_att_supressor4",
        resultCount = 1,
        ingredients = {
            { id = "mat_scrap_metal", count = 6 },
            { id = "mat_rubber", count = 2 },
            { id = "mat_duct_tape", count = 1 },
        }
    },
    {
        name = "Обвес: Глушитель АК",
        category = "attachment",
        resultID = "ent_att_supressor1",
        resultCount = 1,
        ingredients = {
            { id = "mat_scrap_metal", count = 8 },
            { id = "mat_rubber", count = 2 },
            { id = "mat_duct_tape", count = 2 },
        }
    },
    {
        name = "Обвес: Фонарь на изоленте",
        category = "attachment",
        resultID = "ent_att_flashlight_tape",
        resultCount = 1,
        ingredients = {
            { id = "mat_electronics", count = 2 },
            { id = "mat_duct_tape", count = 1 },
            { id = "mat_plastic", count = 1 },
        }
    },
    {
        name = "Обвес: Прицел ЕКП-7",
        category = "attachment",
        resultID = "ent_att_holo5",
        resultCount = 1,
        ingredients = {
            { id = "mat_electronics", count = 4 },
            { id = "mat_scrap_metal", count = 3 },
            { id = "mat_plastic", count = 2 },
        }
    },
     {
        name = "Снаряжение: Жилет Дикого",
        category = "rig",
        resultID = "gear_rig_scav",
        resultCount = 1,
        ingredients = {
            { id = "mat_fabric", count = 6 },
            { id = "mat_scrap_metal", count = 2 },
            { id = "mat_plastic", count = 2 },
        }
    },
    {
        name = "Снаряжение: Легкий рюкзак",
        category = "backpack",
        resultID = "gear_backpack_tbag",
        resultCount = 1,
        ingredients = {
            { id = "mat_fabric", count = 8 },
            { id = "mat_duct_tape", count = 2 },
        }
    },
    {
        name = "Медицина: Аптечка IFAK",
        category = "medicine",
        resultID = "weapon_medkit_ifak",
        resultCount = 1,
        ingredients = {
            { id = "mat_fabric", count = 3 },
            { id = "weapon_bandage_sh", count = 2 },
            { id = "weapon_painkillers", count = 1 },
            { id = "mat_plastic", count = 1 },
        }
    },
    {
        name = "Патроны: 9x19мм Parabellum",
        category = "ammo",
        resultID = "ent_ammo_9x19mmparabellum",
        resultCount = 50, -- пачка
        ingredients = {
            { id = "mat_scrap_metal", count = 3 },
            { id = "mat_gunpowder", count = 2 },
        }
    },
 {
        name = "Патроны: 7.62x39мм",
        category = "ammo",
        resultID = "ent_ammo_7.62x39mm",
        resultCount = 60,
        ingredients = {
            { id = "mat_scrap_metal", count = 3 },
            { id = "mat_gunpowder", count = 2 },
        }
     },    
{
        name = "Патроны: 5.45x39мм",
        category = "ammo",
        resultID = "ent_ammo_5.45x39mm",
        resultCount = 60,
        ingredients = {
            { id = "mat_scrap_metal", count = 4 },
            { id = "mat_gunpowder", count = 2 },
        }
    }
}



-- ==========================================
-- ТРЕБОВАНИЯ К ИНСТРУМЕНТАМ ДЛЯ КРАФТА
-- Инструменты бесконечны: проверяются наличие, но НЕ списываются.
-- ==========================================
EFT.ToolNames = {
    tool_sewing_basic    = "Простой швейный набор",
    tool_sewing_advanced = "Продвинутый набор для шитья",
    tool_work_light      = "Инструменты для лёгкой работы",
    tool_work_heavy      = "Инструменты для тяжёлой работы",
    tool_ammo_kit        = "Набор для изготовления боеприпасов",
    tool_lockpick        = "Отмычка",
}

-- Какие рецепты (по resultID / category) требуют какой инструмент
EFT.RecipeToolByResult = {
    -- Лёгкий рюкзак
    ["gear_backpack_tbag"] = "tool_sewing_basic",
    ["gear_backpack_sling"] = "tool_sewing_basic",
    -- Продвинутые рюкзаки
    ["gear_backpack_vkbo"] = "tool_sewing_advanced",
    ["gear_backpack_duffle"] = "tool_sewing_advanced",
    ["gear_backpack_scav"] = "tool_sewing_advanced",
    ["gear_backpack_trizip"] = "tool_sewing_advanced",
    ["gear_backpack_paratus"] = "tool_sewing_advanced",
    ["gear_backpack_pilgrim"] = "tool_sewing_advanced",
    ["gear_backpack_blackjack"] = "tool_sewing_advanced",
    -- Пистолеты и холодное
    ["weapon_pm9"] = "tool_work_light",
    ["weapon_glock17"] = "tool_work_light",
    ["weapon_bat"] = "tool_work_light",
    ["weapon_buck200knife"] = "tool_work_light",
    -- Автоматы / винтовки / дробовики
    ["weapon_toz106"] = "tool_work_heavy",
    ["weapon_akmwreked"] = "tool_work_heavy",
    ["weapon_ak74"] = "tool_work_heavy",
    ["weapon_m4a1"] = "tool_work_heavy",
    ["weapon_xm1014"] = "tool_work_heavy",
    ["weapon_mp5"] = "tool_work_heavy",
    -- Патроны
    ["ent_ammo_9x19mmparabellum"] = "tool_ammo_kit",
    ["ent_ammo_5.45x39mm"] = "tool_ammo_kit",
    ["ent_ammo_7.62x39mm"] = "tool_ammo_kit",
    ["ent_ammo_5.56x45mm"] = "tool_ammo_kit",
    ["ent_ammo_12/70gauge"] = "tool_ammo_kit",
    ["ent_ammo_5.7x28mm"] = "tool_ammo_kit",
    -- Обвесы / детали — лёгкие инструменты
    ["ent_att_supressor6"] = "tool_work_light",
    ["ent_att_supressor4"] = "tool_work_light",
    ["ent_att_supressor1"] = "tool_work_light",
    ["ent_att_flashlight_tape"] = "tool_work_light",
    ["ent_att_holo5"] = "tool_work_light",
    ["ent_att_holo4"] = "tool_work_light",
    ["ent_att_optic4"] = "tool_work_light",
    ["ent_att_laser3"] = "tool_work_light",
    ["part_barrel"] = "tool_work_light",
    ["part_receiver"] = "tool_work_light",
    ["part_handguard"] = "tool_work_light",
    ["part_stock"] = "tool_work_light",
    -- Разгрузка / медицина из ткани — простой пошив
    ["gear_rig_scav"] = "tool_sewing_basic",
    ["gear_rig_wartech"] = "tool_sewing_advanced",
    ["weapon_medkit_ifak"] = "tool_sewing_basic",
    ["weapon_medkit_car"] = "tool_sewing_basic",
    ["weapon_bandage_sh"] = "tool_sewing_basic",
    ["weapon_splint"] = "tool_sewing_basic",
}

function EFT.GetRecipeRequiredTool(recipe)
    if not recipe then return nil end
    if recipe.requiredTool then return recipe.requiredTool end
    if recipe.resultID and EFT.RecipeToolByResult[recipe.resultID] then
        return EFT.RecipeToolByResult[recipe.resultID]
    end
    -- fallback by category
    local cat = recipe.category
    if cat == "ammo" then return "tool_ammo_kit" end
    if cat == "backpack" then
        local id = recipe.resultID or ""
        if id == "gear_backpack_tbag" or id == "gear_backpack_sling" then
            return "tool_sewing_basic"
        end
        return "tool_sewing_advanced"
    end
    if cat == "weapon" then
        local id = recipe.resultID or ""
        if id == "weapon_pm9" or id == "weapon_glock17" or id == "weapon_bat" or id == "weapon_buck200knife" then
            return "tool_work_light"
        end
        return "tool_work_heavy"
    end
    if cat == "attachment" or cat == "part" then return "tool_work_light" end
    if cat == "rig" or cat == "medicine" then return "tool_sewing_basic" end
    return nil
end

-- Проставить requiredTool всем рецептам (после загрузки EXTRA_RECIPES тоже)
local function EFT_ApplyRecipeTools()
    if not EFT.Recipes then return end
    for _, r in ipairs(EFT.Recipes) do
        if not r.requiredTool then
            r.requiredTool = EFT.GetRecipeRequiredTool(r)
        end
    end
end
EFT_ApplyRecipeTools()
timer.Simple(0, EFT_ApplyRecipeTools)
timer.Simple(2, EFT_ApplyRecipeTools)


-- ==========================================
-- ПУЛЫ ЛУТА
-- ==========================================
EFT.LootPools = {
    weapon_case = { types = { weapon = 0.35, ammo = 0.73, part = 0.5 }, countMin = 1, countMax = 3, maxWeapons = 1, valuable_ammo = 0.7 },
    gear_only = { types = { armor = 1.0, backpack = 0.6, rig = 0.6 }, countMin = 1, countMax = 3 },
    junk_only = {
        types = { valuable = 1.0 }, countMin = 3, countMax = 6, bonusChance = 0.15,
        bonusTypes = { weapon = 0.2, medicine = 0.4, food = 0.4, ammo = 0.3 },
    },
    -- Пустой пул: только квестовый предмет (подставляется отдельно)
    quest_only = {
        types = {}, countMin = 0, countMax = 0,
    },
    food_only = { types = { food = 1.0 }, countMin = 2, countMax = 5 },
    corpse_bonus = { types = { food = 0.5, valuable = 0.5, ammo = 0.4, medicine = 0.3 }, countMin = 1, countMax = 3 },
    
    -- Новые специализированные пулы
    medical_pack = {
        types = { medicine = 1.0, food = 0.3 },
        countMin = 2, maxWeapons = 0, countMax = 5
    },
    -- Военные ящики: раньше давали лут слишком щедро (2-4 предмета, до 2 оружий) —
    -- теперь заметно реже и максимум 1 оружие, зато добавлены детали для крафта
    military_pack = {
        types = { weapon = 0.35, ammo = 0.7, armor = 0.5, rig = 0.3, part = 0.45, valuable_ammo = 0.7 },
        countMin = 1, countMax = 3,
        maxWeapons = 1
    },
    trash_pack = {
        types = { valuable = 1.0, food = 0.4 },
        countMin = 3, countMax = 6
    },
    -- Сейф: только редкий/эпический лут
    safe_rare = {
        types = { weapon = 0.4, ammo = 0.5, armor = 0.55, attachment = 0.45, part = 0.4, medicine = 0.35, valuable = 0.3 },
        countMin = 2, countMax = 4,
        maxWeapons = 1,
        rarityFilter = { rare = true, epic = true, legendary = true },
    },
    -- Кейс с отмычками: только отмычки
    lockpick_only = {
        types = { tool = 1.0 },
        countMin = 1, countMax = 3,
        forcedItemID = "tool_lockpick",
    },
    -- Контейнеры с инструментами для крафта (без отмычек)
    tools_only = {
        types = { tool = 1.0 },
        countMin = 1, countMax = 3,
        excludeItemIDs = { tool_lockpick = true },
        allowedItemIDs = {
            tool_sewing_basic = true,
            tool_sewing_advanced = true,
            tool_work_light = true,
            tool_work_heavy = true,
            tool_ammo_kit = true,
        },
    },
}

-- ==========================================
-- КОНТЕЙНЕРЫ (С НОВЫМИ МОДЕЛЯМИ!)
-- ==========================================
EFT.ContainerDefs = {
    ["models/eft/misk/weapon_box.mdl"]              = { pool = "weapon_case", w = 4, h = 3 },
    ["models/kali/props/cases/hard_case_a.mdl"]     = { pool = "weapon_case", w = 3, h = 3 },
    ["models/kali/props/cases/hard_case_b.mdl"]     = { pool = "weapon_case", w = 4, h = 2 },
    ["models/eft/misk/cupboard_2.mdl"]              = { pool = "gear_only", w = 4, h = 4 },
    ["models/eft/misk/cupboard_3.mdl"]              = { pool = "gear_only", w = 4, h = 4 },
    ["models/eft/misk/nightstand.mdl"]              = { pool = "gear_only", w = 2, h = 2 },
    ["models/eft/misk/woodbox_medium.mdl"]          = { pool = "junk_only", w = 4, h = 4 },
    ["models/eft/misk/woodbox_small.mdl"]           = { pool = "junk_only", w = 3, h = 3 },
    ["models/eft/misk/cardboard_box_2.mdl"]         = { pool = "junk_only", w = 3, h = 2 },
    ["models/eft/misk/microwave_1.mdl"]             = { pool = "food_only", w = 2, h = 2 },
    ["models/eft/misk/r_minsk15m.mdl"]              = { pool = "food_only", w = 4, h = 4 },
    ["models/props_junk/trashdumpster01a.mdl"]      = { pool = "junk_only", w = 4, h = 4 },

    -- --- 1) Медицинские контейнеры (4x5) ---
    ["models/eftpropspack/container_lab_04.mdl"]     = { pool = "medical_pack", w = 5, h = 4 },
    ["models/eftpropspack/container_lab_set_07.mdl"] = { pool = "medical_pack", w = 5, h = 4 },

    -- --- 2) Военные ящики (3x8/8x3) ---
    ["models/eftpropspack/container_safe_close.mdl"]          = { pool = "safe_rare", w = 4, h = 5, locked = true, requiresLockpick = true },
    ["models/eftpropspack/item_container_keys_case.mdl"] = { pool = "lockpick_only", w = 4, h = 3 },
    ["models/eftpropspack/item_container_secured_theta.mdl"] = { pool = "tools_only", w = 4, h = 3 },
    ["models/eftpropspack/pistol_case.mdl"] = { pool = "tools_only", w = 4, h = 3 },
    ["models/eftpropspack/scontainer_airdrop_box_gun.mdl"]    = { pool = "military_pack", w = 8, h = 3 },
    ["models/eftpropspack/item_container_weapon_thicc.mdl"]   = { pool = "military_pack", w = 8, h = 3 },
    ["models/kali/props/cases/hard case a.mdl"]               = { pool = "military_pack", w = 8, h = 5 },

    -- --- 3) Мусорные контейнеры (4x5) ---
    ["models/eft/trash/bag_garbage.mdl"]             = { pool = "trash_pack", w = 5, h = 4 },
    ["models/eft/trash/bag_garbage_small_1.mdl"]     = { pool = "trash_pack", w = 5, h = 4 },

    -- --- 4) Квестовые контейнеры Одессы (лутабельны всегда; квест-предмет подкидывается отдельно) ---
    ["models/eftpropspack/item_container_magbox.mdl"] = { pool = "quest_only", w = 2, h = 2, questItem = "quest_odessa_package" },
    ["models/eftpropspack/item_container_money.mdl"]  = { pool = "quest_only", w = 2, h = 2, questItem = "quest_military_document" },
}

local function GetContainerDef(ent)
    if not IsValid(ent) then return nil end
    local mdl = string.lower(string.gsub(ent:GetModel() or "", "\\", "/"))
    if mdl == "" then return nil end
    local def = EFT.ContainerDefs[mdl]
    if def then return def end
    -- fallback: match by filename (models/.../item_container_magbox.mdl)
    local base = string.match(mdl, "([^/]+%.mdl)$")
    if base then
        for path, d in pairs(EFT.ContainerDefs) do
            if string.match(path, base .. "$") then return d end
        end
        if EFT.QuestContainerDefs then
            for path, qd in pairs(EFT.QuestContainerDefs) do
                if string.match(string.lower(path), base .. "$") then
                    return {
                        pool = "quest_only",
                        w = qd.w or 2, h = qd.h or 2,
                        questItem = qd.questItem,
                    }
                end
            end
        end
    end
    -- last resort: substring keywords for quest boxes
    if string.find(mdl, "item_container_magbox", 1, true) then
        return { pool = "quest_only", w = 2, h = 2, questItem = "quest_odessa_package" }
    end
    if string.find(mdl, "item_container_money", 1, true) then
        return { pool = "quest_only", w = 2, h = 2, questItem = "quest_military_document" }
    end
    return nil
end

-- ==========================================
-- НОВЫЙ GEAR-ПАК: ent_armor_* — берём модель у одноимённой сущности
-- ==========================================
EFT.GearEntityIDs = {
    "ent_armor_vest1", "ent_armor_vest2", "ent_armor_vest3", "ent_armor_vest4",
    "ent_armor_vest5", "ent_armor_vest7", "ent_armor_vest8",
    "ent_armor_helmet1", "ent_armor_helmet3", "ent_armor_helmet5", "ent_armor_helmet6", "ent_armor_helmet7",
    "ent_armor_mask1", "ent_armor_mask2", "ent_armor_mask3",
    "ent_armor_headphones1",
}

local function EFT_ResolveClassModel(classname)
    local stored = scripted_ents.GetStored(classname)
    if stored and stored.t and stored.t.Model and stored.t.Model ~= "" then
        return stored.t.Model
    end

    local ok, ent = pcall(ents.Create, classname)
    if ok and IsValid(ent) then
        local mdl = ent:GetModel()
        ent:Remove()
        if mdl and mdl ~= "" then return mdl end
    end
    return nil
end

function EFT.RefreshGearModels()
    for _, id in ipairs(EFT.GearEntityIDs) do
        local d = EFT.ItemDatabase[id]
        if d and (not d.model or d.model == "") then
            local mdl = EFT_ResolveClassModel(id)
            if mdl then d.model = mdl end
        end
    end
end

EFT.RefreshGearModels()
hook.Add("InitPostEntity", "EFT_LootSystem_RefreshGearModels", EFT.RefreshGearModels)

-- ==========================================
-- ПРОДАВЕЦ ОРУЖИЯ (СПАВНИТСЯ ИЗ МЕНЮ СПАВНА КАК npc_weapon_dealer)
-- ==========================================
do
    local ENT = {}
    ENT.Type = "anim"
    ENT.Base = "base_gmodentity"
    ENT.PrintName = "Продавец оружия (EFT)"
    ENT.Category = "EFT — Торговцы"
    ENT.Spawnable = true
    ENT.AdminOnly = true
    ENT.Model = "models/Barney.mdl"
    ENT.AutomaticFrameAdvance = true

    function ENT:Initialize()
        self:SetModel("models/Barney.mdl")
        self:SetSolid(SOLID_BBOX)
        self:SetCollisionBounds(Vector(-16, -16, 0), Vector(16, 16, 72))
        self:SetMoveType(MOVETYPE_NONE)
        self:SetUseType(SIMPLE_USE)
        self:SetSequence(0)
        self:ResetSequenceInfo()
        self:SetCycle(0)
        self:SetPlaybackRate(1)

        -- Idle-поза как у NPC (не A-pose)
        local idleSeq = self:LookupSequence("idle_subtle")
        if idleSeq < 0 then idleSeq = self:LookupSequence("Idle1") end
        if idleSeq < 0 then idleSeq = self:LookupSequence("idle") end
        if idleSeq < 0 then idleSeq = self:LookupSequence("LineIdle01") end
        if idleSeq < 0 then idleSeq = 0 end
        self:ResetSequence(idleSeq)
        self:SetCycle(0)
        self:SetPlaybackRate(1)
        self.EFT_IdleSeq = idleSeq

        if SERVER then
            self:SetHealth(500)
            self:DrawShadow(true)
        end
    end

    function ENT:Think()
        -- Держим idle-анимацию в цикле, чтобы модель не зависала в A-pose
        if self.EFT_IdleSeq and self.EFT_IdleSeq >= 0 then
            if self:GetSequence() ~= self.EFT_IdleSeq then
                self:ResetSequence(self.EFT_IdleSeq)
            end
            self:SetPlaybackRate(1)
            if self:IsSequenceFinished() then
                self:ResetSequence(self.EFT_IdleSeq)
                self:SetCycle(0)
            end
        end
        self:NextThink(CurTime())
        return true
    end

    -- Собственное взаимодействие идёт через диалог (EFT_RequestBarneyDialog),
    -- поэтому стандартный +use (E) отключаем, чтобы не конфликтовать с базой.
    function ENT:UseOverride(activator, caller) end

    scripted_ents.Register(ENT, "npc_weapon_dealer")

    -- Починить позу уже заспавненных торговцев (после обновления аддона)
    local function EFT_FixWeaponDealerPose(ent)
        if not IsValid(ent) or ent:GetClass() ~= "npc_weapon_dealer" then return end
        ent.AutomaticFrameAdvance = true
        local idleSeq = ent:LookupSequence("idle_subtle")
        if idleSeq < 0 then idleSeq = ent:LookupSequence("Idle1") end
        if idleSeq < 0 then idleSeq = ent:LookupSequence("idle") end
        if idleSeq < 0 then idleSeq = ent:LookupSequence("LineIdle01") end
        if idleSeq < 0 then idleSeq = 0 end
        ent:ResetSequence(idleSeq)
        ent:SetCycle(0)
        ent:SetPlaybackRate(1)
        ent.EFT_IdleSeq = idleSeq
        if not ent.EFT_ThinkPatched then
            ent.EFT_ThinkPatched = true
            ent.Think = function(self)
                if self.EFT_IdleSeq and self.EFT_IdleSeq >= 0 then
                    if self:GetSequence() ~= self.EFT_IdleSeq then
                        self:ResetSequence(self.EFT_IdleSeq)
                    end
                    self:SetPlaybackRate(1)
                    if self:IsSequenceFinished() then
                        self:ResetSequence(self.EFT_IdleSeq)
                        self:SetCycle(0)
                    end
                end
                self:NextThink(CurTime())
                return true
            end
        end
        ent:NextThink(CurTime())
    end

    hook.Add("InitPostEntity", "EFT_FixWeaponDealerPose", function()
        timer.Simple(1, function()
            for _, ent in ipairs(ents.FindByClass("npc_weapon_dealer")) do
                EFT_FixWeaponDealerPose(ent)
            end
        end)
    end)

    hook.Add("OnEntityCreated", "EFT_FixWeaponDealerPoseCreated", function(ent)
        timer.Simple(0, function()
            if IsValid(ent) and ent:GetClass() == "npc_weapon_dealer" then
                EFT_FixWeaponDealerPose(ent)
            end
        end)
    end)

    concommand.Add("eft_fix_barney_pose", function()
        for _, ent in ipairs(ents.FindByClass("npc_weapon_dealer")) do
            EFT_FixWeaponDealerPose(ent)
        end
        print("[EFT] Поза Барни исправлена.")
    end)
end

-- ==========================================
-- СЕТКА ИНВЕНТАРЯ И ВСПОМОГАТЕЛЬНЫЕ ФУНКЦИИ СЕТКИ
-- ==========================================
EFT.Grid = {}

function EFT.Grid.New(gridW, gridH)
    local grid = {}
    for y = 1, gridH do
        grid[y] = {}
        for x = 1, gridW do grid[y][x] = false end
    end
    return grid
end

function EFT.Grid.BuildFromItems(items, gridW, gridH, excludeUniqueID)
    local grid = EFT.Grid.New(gridW, gridH)
    for _, item in ipairs(items) do
        if item.uniqueID ~= excludeUniqueID then
            EFT.Grid.Occupy(grid, item.x, item.y, item.w, item.h)
        end
    end
    return grid
end

function EFT.Grid.Occupy(grid, x, y, w, h)
    for cy = y, y + h - 1 do
        for cx = x, x + w - 1 do
            if grid[cy] then grid[cy][cx] = true end
        end
    end
end

function EFT.Grid.FindFreeSpace(grid, w, h, gridW, gridH)
    for y = 1, gridH - h + 1 do
        for x = 1, gridW - w + 1 do
            local fits = true
            for cy = y, y + h - 1 do
                for cx = x, x + w - 1 do
                    if not grid[cy] or grid[cy][cx] then fits = false break end
                end
                if not fits then break end
            end
            if fits then return x, y end
        end
    end
    return nil, nil
end

function EFT.Grid.TryInsert(items, itemID, itemData, gridW, gridH, extraFields)
    local grid = EFT.Grid.BuildFromItems(items, gridW, gridH)
    local rx, ry = EFT.Grid.FindFreeSpace(grid, itemData.w, itemData.h, gridW, gridH)
    if not rx then return nil end

    local countVal = extraFields and extraFields.count or (itemData.maxStack or 1)
    local hpVal = extraFields and extraFields.hp or itemData.maxHP
    local usesVal = extraFields and extraFields.uses or itemData.maxUses

    local entry = {
        uniqueID = tostring(util.CRC(tostring(itemID) .. tostring(SysTime()) .. tostring(math.random(1, 999999)))),
        id = itemID, x = rx, y = ry, w = itemData.w, h = itemData.h,
        examined = false, rotated = false,
        count = countVal, hp = hpVal, uses = usesVal
    }
    if extraFields then
        for k, v in pairs(extraFields) do entry[k] = v end
        if entry.uniqueID ~= nil then entry.uniqueID = tostring(entry.uniqueID) end
    end

    table.insert(items, entry)
    return entry
end

function EFT.Grid.CanPlaceAt(items, x, y, w, h, gridW, gridH, excludeUniqueID)
    if x < 1 or y < 1 or x + w - 1 > gridW or y + h - 1 > gridH then return false end
    local grid = EFT.Grid.BuildFromItems(items, gridW, gridH, excludeUniqueID)
    for cy = y, y + h - 1 do
        for cx = x, x + w - 1 do
            if not grid[cy] or grid[cy][cx] then return false end
        end
    end
    return true
end

function EFT.Grid.Regrid(items, newW, newH)
    local fresh = {}
    for _, it in ipairs(items) do
        local grid = EFT.Grid.BuildFromItems(fresh, newW, newH)
        local rx, ry = EFT.Grid.FindFreeSpace(grid, it.w, it.h, newW, newH)
        if not rx then return nil end
        local entry = table.Copy(it)
        entry.x, entry.y = rx, ry
        table.insert(fresh, entry)
    end
    return fresh
end

function EFT.WeightedPick(candidates)
    local total = 0
    for _, c in ipairs(candidates) do total = total + c.weight end
    if total <= 0 then return nil end
    local roll = math.random() * total
    local acc = 0
    for _, c in ipairs(candidates) do
        acc = acc + c.weight
        if roll <= acc then return c end
    end
    return candidates[#candidates]
end

function EFT.BuildLootCandidates(poolKey)
    local pool = EFT.LootPools[poolKey] or EFT.LootPools.junk_only
    local list = {}
    for id, data in pairs(EFT.ItemDatabase) do
        local factor = pool.types[data.type]
        if factor then
            local rarityWeight = (EFT.Rarity[data.rarity] and EFT.Rarity[data.rarity].weight) or 10
            table.insert(list, { id = id, data = data, weight = rarityWeight * factor })
        end
    end
    return list, pool
end

local function ItemGetsBackpackDiscount(itemData)
    return itemData.type == "attachment" or itemData.type == "utility"
        or itemData.type == "food" or itemData.type == "valuable" or itemData.type == "medicine"
end

-- ==========================================
-- СЕТЕВЫЕ ИДЕНТИФИКАТОРЫ
-- ==========================================
if SERVER then
    util.AddNetworkString("EFT_OpenLoot")
    util.AddNetworkString("EFT_ExamineItem")
    util.AddNetworkString("EFT_TransferItem")
    util.AddNetworkString("EFT_CloseLoot")
    util.AddNetworkString("EFT_RequestInventory")
    util.AddNetworkString("EFT_OpenInventory")
    util.AddNetworkString("EFT_EquipItem")
    util.AddNetworkString("EFT_UnequipItem")
    util.AddNetworkString("EFT_MoveItem")
    util.AddNetworkString("EFT_RotateItem")
    util.AddNetworkString("EFT_DropItem")
    util.AddNetworkString("EFT_OpenShop")
    util.AddNetworkString("EFT_SellItem")
    util.AddNetworkString("EFT_OpenWeaponShop")
    util.AddNetworkString("EFT_BuyWeapon")
    util.AddNetworkString("EFT_RequestMedicine")
    util.AddNetworkString("EFT_OpenMedicine")
    util.AddNetworkString("EFT_ApplyMedicine")
    util.AddNetworkString("EFT_ConsumeItem")
    
    -- Новые сетевые сообщения Верстака
    util.AddNetworkString("EFT_StartSearchContainer")
    util.AddNetworkString("EFT_SearchContainerComplete")
    util.AddNetworkString("EFT_OpenWorkbench")
    util.AddNetworkString("EFT_CraftItem")

    -- Взаимодействие/лутинг по клавише F
    util.AddNetworkString("EFT_RequestLootF")
end

-- ==========================================
-- СЕРВЕРНАЯ ЧАСТЬ
-- ==========================================
if SERVER then
    local ContainerStorage = {}
    local ContainerGridSize = {}
    local ContainerLastLootTime = {}  -- Время последнего разграбления для респавна лута
    local ActiveLooters = {}
    -- GLOBAL EXPORT (for unified systems)
    EFT.ContainerStorage = ContainerStorage
    EFT.ContainerGridSize = ContainerGridSize
    EFT.ContainerLastLootTime = ContainerLastLootTime
    EFT.ActiveLooters = ActiveLooters
    local NetCooldowns = {}
    local UseKeyWasDown = {} -- состояние клавиши E по игрокам для Think-опроса (см. ниже, почему не KeyPress)

    EFT.VirtualInventory = {}    -- Личные карманы (всегда доступны, базовая сетка)
    EFT.BackpackContents = {}    -- [uniqueID рюкзака] = { items... } — своё хранилище на каждый физический рюкзак
    EFT.RigContents = {}         -- [uniqueID разгрузки] = { items... } — своё хранилище на каждую физическую разгрузку
    EFT.PlayerEquipment = {}     -- backpack=, backpackUID=, vest=, helmet=, rig=, rigUID=
    EFT.PlayerLimbHealth = {}

    -- Хранилища рюкзаков/разгрузок общие (не завязаны на игрока), т.к. предмет может
    -- лежать в контейнере, у другого игрока и т.д. Ключ — uniqueID конкретного предмета.
    local function GetBackpackStorage(uniqueID)
        if not uniqueID then return {} end
        EFT.BackpackContents[uniqueID] = EFT.BackpackContents[uniqueID] or {}
        return EFT.BackpackContents[uniqueID]
    end

    local function GetRigStorage(uniqueID)
        if not uniqueID then return {} end
        EFT.RigContents[uniqueID] = EFT.RigContents[uniqueID] or {}
        return EFT.RigContents[uniqueID]
    end

    -- ==========================================
    -- КАСТОМНАЯ МОДЕЛЬ СКУПЩИКА ХЛАМА (ОДЕССА)
    -- ==========================================
    local ODESSA_MODEL = "models/odessa.mdl"

    local function ApplyOdessaModel(ent)
        if not IsValid(ent) or ent:GetClass() ~= "npc_odessa" then return end
        if ent:GetModel() ~= ODESSA_MODEL then
            ent:SetModel(ODESSA_MODEL)
        end
    end

    hook.Add("OnEntityCreated", "EFT_LootSystem_OdessaModel", function(ent)
        timer.Simple(0, function() ApplyOdessaModel(ent) end)
    end)

    hook.Add("InitPostEntity", "EFT_LootSystem_OdessaModelExisting", function()
        timer.Simple(1, function()
            for _, ent in ipairs(ents.FindByClass("npc_odessa")) do
                ApplyOdessaModel(ent)
            end
        end)
    end)

    concommand.Add("eft_fix_odessa_model", function()
        for _, ent in ipairs(ents.FindByClass("npc_odessa")) do
            ApplyOdessaModel(ent)
        end
    end)

    local function IsVirtualType(itemType)
        return itemType ~= "weapon" and itemType ~= "ammo"
    end

    -- Личные карманы игрока (маленькая базовая сетка, всегда при себе, не зависит от рюкзака)
    local function GetVirtualInv(ply)
        EFT.VirtualInventory[ply] = EFT.VirtualInventory[ply] or {}
        return EFT.VirtualInventory[ply]
    end

    local function GetEquipment(ply)
        EFT.PlayerEquipment[ply] = EFT.PlayerEquipment[ply] or {
            backpack = nil, backpackUID = nil,
            vest = nil, helmet = nil,
            rig = nil, rigUID = nil,
            mask = nil, headphones = nil,
        }
        return EFT.PlayerEquipment[ply]
    end

    -- Содержимое НАДЕТОГО рюкзака — привязано к uniqueID конкретного физического рюкзака,
    -- поэтому у каждого рюкзака своё хранилище, и оно не перемешивается при смене рюкзаков.
    local function GetVirtualBackpackInv(ply)
        local equip = GetEquipment(ply)
        if not equip.backpack or not equip.backpackUID then return {} end
        return GetBackpackStorage(equip.backpackUID)
    end

    -- Содержимое НАДЕТОЙ разгрузки — привязано к uniqueID конкретной физической разгрузки.
    local function GetVirtualRigInv(ply)
        local equip = GetEquipment(ply)
        if not equip.rig or not equip.rigUID then return {} end
        return GetRigStorage(equip.rigUID)
    end

    local function GetLimbHealth(ply)
        EFT.PlayerLimbHealth[ply] = EFT.PlayerLimbHealth[ply] or table.Copy(EFT.Config.LimbMaxHealth)
        return EFT.PlayerLimbHealth[ply]
    end

    local function IsRateLimited(ply)
        local now = SysTime()
        local last = NetCooldowns[ply] or 0
        if now - last < EFT.Config.NetCooldown then return true end
        NetCooldowns[ply] = now
        return false
    end

    -- Личные карманы теперь ВСЕГДА фиксированного размера — не подменяются рюкзаком.
    local function GetPersonalGridSize(ply)
        return { w = EFT.Config.PersonalGridBaseW, h = EFT.Config.PersonalGridBaseH }
    end

    -- Отдельная сетка рюкзака (своё окошко, как у разгрузки)
    local function GetBackpackGridSize(ply)
        local equip = GetEquipment(ply)
        if equip.backpack then
            local d = EFT.ItemDatabase[equip.backpack]
            if d and d.gridSize then return d.gridSize end
        end
        return { w = 0, h = 0 }
    end

    local function GetRigGridSize(ply)
        local equip = GetEquipment(ply)
        if equip.rig then
            local d = EFT.ItemDatabase[equip.rig]
            if d and d.gridSize then return d.gridSize end
        end
        return { w = 0, h = 0 }
    end

    -- Умный подбор со стаканием для патронов (ammo)
    local function AddAmmoToInventoryStack(ply, itemID, count)
        local itemData = EFT.ItemDatabase[itemID]
        if not itemData or itemData.type ~= "ammo" then return count end
        local maxStack = itemData.maxStack or 30

        local function tryStackInList(list)
            for _, item in ipairs(list) do
                if item.id == itemID and item.count < maxStack then
                    local room = maxStack - item.count
                    local toAdd = math.min(room, count)
                    item.count = item.count + toAdd
                    count = count - toAdd
                    if count <= 0 then return 0 end
                end
            end
            return count
        end

        count = tryStackInList(GetVirtualInv(ply))
        if count <= 0 then return 0 end

        if GetEquipment(ply).rig then
            count = tryStackInList(GetVirtualRigInv(ply))
            if count <= 0 then return 0 end
        end

        if GetEquipment(ply).backpack then
            count = tryStackInList(GetVirtualBackpackInv(ply))
        end

        return count
    end

    -- Вспомогательная функция для добавления предметов
    local function AddToPersonalInventory(ply, itemID, itemData, extra)
        -- Сначала проверим стакание для патронов
        if itemData.type == "ammo" then
            local left = AddAmmoToInventoryStack(ply, itemID, extra and extra.count or (itemData.maxStack or 1))
            if left <= 0 then return true end
            if not extra then extra = {} end
            extra.count = left
        end

        -- Одежда (всегда на персонаже): штаны 2x2 → кофта 2x3
        if EFT.GetPantsInv and EFT.GetPantsGridSize then
            local pg = EFT.GetPantsGridSize()
            if pg and pg.w > 0 then
                local added = EFT.Grid.TryInsert(EFT.GetPantsInv(ply), itemID, itemData, pg.w, pg.h, extra)
                if added then return true end
            end
        end
        if EFT.GetShirtInv and EFT.GetShirtGridSize then
            local sg = EFT.GetShirtGridSize()
            if sg and sg.w > 0 then
                local added = EFT.Grid.TryInsert(EFT.GetShirtInv(ply), itemID, itemData, sg.w, sg.h, extra)
                if added then return true end
            end
        end

        -- Сетка разгрузки
        local rigGrid = GetRigGridSize(ply)
        if rigGrid.w > 0 then
            local added = EFT.Grid.TryInsert(GetVirtualRigInv(ply), itemID, itemData, rigGrid.w, rigGrid.h, extra)
            if added then return true end
        end

        -- Сетка рюкзака (своя, привязанная к конкретному физическому рюкзаку)
        local backpackGrid = GetBackpackGridSize(ply)
        if backpackGrid.w > 0 then
            local added = EFT.Grid.TryInsert(GetVirtualBackpackInv(ply), itemID, itemData, backpackGrid.w, backpackGrid.h, extra)
            if added then return true end
        end

        -- Личные карманы (последний вариант)
        local personalGrid = GetPersonalGridSize(ply)
        local added = EFT.Grid.TryInsert(GetVirtualInv(ply), itemID, itemData, personalGrid.w, personalGrid.h, extra)
        if added then return true end

        return false
    end

    local function FindPersonalItemByUniqueID(ply, uniqueID)
        uniqueID = tostring(uniqueID or "")
        if uniqueID == "" then return nil, nil, nil end
        local function match(it)
            return it and tostring(it.uniqueID or "") == uniqueID
        end
        for idx, it in ipairs(GetVirtualInv(ply)) do
            if match(it) then return idx, it, "personal" end
        end
        for idx, it in ipairs(GetVirtualRigInv(ply)) do
            if match(it) then return idx, it, "rig" end
        end
        for idx, it in ipairs(GetVirtualBackpackInv(ply)) do
            if match(it) then return idx, it, "backpack" end
        end
        if EFT.GetPantsInv then
            for idx, it in ipairs(EFT.GetPantsInv(ply) or {}) do
                if match(it) then return idx, it, "pants" end
            end
        end
        if EFT.GetShirtInv then
            for idx, it in ipairs(EFT.GetShirtInv(ply) or {}) do
                if match(it) then return idx, it, "shirt" end
            end
        end
        if EFT.Improvements and EFT.Improvements.GetSecure then
            for idx, it in ipairs(EFT.Improvements.GetSecure(ply) or {}) do
                if match(it) then return idx, it, "secure" end
            end
        end
        if EFT.Improvements and EFT.Improvements.GetStash then
            for idx, it in ipairs(EFT.Improvements.GetStash(ply) or {}) do
                if match(it) then return idx, it, "stash" end
            end
        end
        return nil, nil, nil
    end

    local function GetInvAndSize(ply, invType)
        if invType == "rig" then return GetVirtualRigInv(ply), GetRigGridSize(ply) end
        if invType == "backpack" then return GetVirtualBackpackInv(ply), GetBackpackGridSize(ply) end
        if invType == "pants" and EFT.GetPantsInv and EFT.GetPantsGridSize then
            local g = EFT.GetPantsGridSize()
            return EFT.GetPantsInv(ply), { w = g.w or 2, h = g.h or 2 }
        end
        if invType == "shirt" and EFT.GetShirtInv and EFT.GetShirtGridSize then
            local g = EFT.GetShirtGridSize()
            return EFT.GetShirtInv(ply), { w = g.w or 2, h = g.h or 3 }
        end
        if invType == "secure" and EFT.Improvements and EFT.Improvements.GetSecure then
            return EFT.Improvements.GetSecure(ply), { w = 2, h = 2 }
        end
        if invType == "stash" and EFT.Improvements and EFT.Improvements.GetStash then
            return EFT.Improvements.GetStash(ply), { w = 10, h = 10 }
        end
        return GetVirtualInv(ply), GetPersonalGridSize(ply)
    end

    local function RecomputeArmor(ply)
        if not IsValid(ply) then return end
        local equip = GetEquipment(ply)
        local total = 0
        if equip.vest then
            local d = EFT.ItemDatabase[equip.vest]
            if d and d.armorValue then total = total + d.armorValue end
        end
        if equip.helmet then
            local d = EFT.ItemDatabase[equip.helmet]
            if d and d.armorValue then total = total + d.armorValue end
        end
        if equip.mask then
            local d = EFT.ItemDatabase[equip.mask]
            if d and d.armorValue then total = total + d.armorValue end
        end
        if equip.headphones then
            local d = EFT.ItemDatabase[equip.headphones]
            if d and d.armorValue then total = total + d.armorValue end
        end
        ply:SetArmor(total)
    end

    local function GetCarryCapacity(ply)
        local equip = GetEquipment(ply)
        local cap = EFT.Config.BaseCarryCapacity
        if equip.backpack then
            local d = EFT.ItemDatabase[equip.backpack]
            if d and d.capacity then cap = cap + d.capacity end
        end
        return cap
    end

    local function ComputeCarriedWeight(ply)
        if not IsValid(ply) then return 0 end
        local weight = 0
        local equip = GetEquipment(ply)
        local hasBackpack = equip.backpack ~= nil

        for _, wep in ipairs(ply:GetWeapons()) do
            local d = EFT.ItemDatabase[wep:GetClass()]
            if d then weight = weight + (d.weight or 0) end
        end

        -- Вес предметов в инвентаре с учетом скидки рюкзака
        local function addInvWeight(list)
            for _, it in ipairs(list) do
                local d = EFT.ItemDatabase[it.id]
                if d then
                    local singleW = d.weight or 0
                    local itemW = singleW
                    if d.type == "ammo" and it.count then
                        itemW = singleW * it.count
                    end
                    if hasBackpack and ItemGetsBackpackDiscount(d) then
                        itemW = itemW * (1 - EFT.Config.BackpackWeightDiscount)
                    end
                    weight = weight + itemW
                end
            end
        end

        addInvWeight(GetVirtualInv(ply))
        addInvWeight(GetVirtualRigInv(ply))
        addInvWeight(GetVirtualBackpackInv(ply))

        for _, slot in ipairs({ "backpack", "vest", "helmet", "rig", "mask", "headphones" }) do
            local itemID = equip[slot]
            if itemID then
                local d = EFT.ItemDatabase[itemID]
                if d then weight = weight + (d.weight or 0) end
            end
        end

        return weight
    end

    -- ==========================================
    -- НАДЕВАНИЕ ЭКИПИРОВКИ НА ПЕРСОНАЖА (ВИЗУАЛ)
    -- ==========================================
    local WornGear = {}

    local function ClearWornGear(ply)
        local t = WornGear[ply]
        if not t then return end
        for _, ent in pairs(t) do
            if IsValid(ent) then ent:Remove() end
        end
        WornGear[ply] = nil
    end

    local function RefreshWornGear(ply)
        if not IsValid(ply) then return end
        ClearWornGear(ply)
        local equip = GetEquipment(ply)
        local worn = {}

        for _, slot in ipairs({ "backpack", "rig", "vest", "helmet", "mask", "headphones" }) do
            local itemID = equip[slot]
            if itemID then
                local d = EFT.ItemDatabase[itemID]
                if d and d.model and d.model ~= "" then
                    local wearable = ents.Create("prop_dynamic")
                    if IsValid(wearable) then
                        wearable:SetModel(d.model)
                        wearable:SetPos(ply:GetPos())
                        wearable:SetAngles(ply:GetAngles())
                        wearable:Spawn()
                        wearable:SetParent(ply)
                        wearable:SetMoveType(MOVETYPE_NONE)
                        wearable:SetSolid(SOLID_NONE)
                        wearable:SetCollisionGroup(COLLISION_GROUP_WEAPON)
                        wearable:AddEffects(EF_BONEMERGE)
                        wearable:AddEffects(EF_BONEMERGE_FASTCULL)
                        wearable:SetOwner(ply)
                        worn[slot] = wearable
                    end
                end
            end
        end

        WornGear[ply] = worn
    end

    -- Получение общего списка предметов игрока для окна Одессы/Обыска
    local function GetPlayerInventoryCounts(ply)
        local inv = {}
        if not IsValid(ply) or not ply:Alive() then return inv end

        for _, wep in ipairs(ply:GetWeapons()) do
            local class = wep:GetClass()
            if EFT.ItemDatabase[class] then inv[class] = (inv[class] or 0) + 1 end
        end

        local function scanList(list)
            for _, it in ipairs(list) do
                inv[it.id] = (inv[it.id] or 0) + (it.count or 1)
            end
        end

        scanList(GetVirtualInv(ply))
        scanList(GetVirtualRigInv(ply))
        scanList(GetVirtualBackpackInv(ply))
        if EFT.GetPantsInv then scanList(EFT.GetPantsInv(ply)) end
        if EFT.GetShirtInv then scanList(EFT.GetShirtInv(ply)) end

        return inv
    end

    local function GenerateLoot(poolKey, gridW, gridH)
        local candidates, pool = EFT.BuildLootCandidates(poolKey)
        local items = {}

        -- Принудительный предмет (например, только отмычки)
        if pool.forcedItemID then
            local fid = pool.forcedItemID
            local fdata = EFT.ItemDatabase[fid]
            if fdata then
                local count = math.random(pool.countMin or 1, pool.countMax or 1)
                for i = 1, count do
                    EFT.Grid.TryInsert(items, fid, fdata, gridW, gridH, { examined = false, count = 1 })
                end
            end
            return items
        end

        if #candidates == 0 then return {} end

        -- Фильтр по списку ID (инструменты / исключения)
        if pool.allowedItemIDs or pool.excludeItemIDs then
            local filtered = {}
            for _, c in ipairs(candidates) do
                if pool.excludeItemIDs and pool.excludeItemIDs[c.id] then continue end
                if pool.allowedItemIDs and not pool.allowedItemIDs[c.id] then continue end
                table.insert(filtered, c)
            end
            candidates = filtered
        end

        if #candidates == 0 then return {} end

        -- Фильтр редкости (сейф: rare/epic/legendary)
        if pool.rarityFilter then
            local filtered = {}
            for _, c in ipairs(candidates) do
                if pool.rarityFilter[c.data.rarity] then
                    table.insert(filtered, c)
                end
            end
            if #filtered > 0 then candidates = filtered end
        end

        local nonWeaponCandidates = {}
        for _, c in ipairs(candidates) do
            if c.data.type ~= "weapon" then table.insert(nonWeaponCandidates, c) end
        end

        local count = math.random(pool.countMin, pool.countMax)
        local weaponCount = 0

        for i = 1, count do
            local pickFrom = candidates
            if pool.maxWeapons and weaponCount >= pool.maxWeapons then
                pickFrom = nonWeaponCandidates
            end
            if #pickFrom > 0 then
                local pick = EFT.WeightedPick(pickFrom)
                if pick then
                    if pick.data.type == "weapon" then weaponCount = weaponCount + 1 end
                    local extra = {}
                    if pick.data.maxStack then
                        extra.count = math.random(math.ceil(pick.data.maxStack * 0.2), pick.data.maxStack)
                    end
                    if pick.data.maxHP then
                        extra.hp = math.random(math.ceil(pick.data.maxHP * 0.4), pick.data.maxHP)
                    end
                    if pick.data.maxUses then
                        extra.uses = math.random(1, pick.data.maxUses)
                    end
                    EFT.Grid.TryInsert(items, pick.id, pick.data, gridW, gridH, extra)
                end
            end
        end

        return items
    end

    -- Логика динамического респавна лута
    local function GetEntityLoot(ent)
        if not IsValid(ent) then return {} end

        local now = CurTime()
        local lastLoot = ContainerLastLootTime[ent] or 0
        local respawnInterval = EFT.Config.LootRespawnTime + math.random(-EFT.Config.LootRespawnRandomOffset, EFT.Config.LootRespawnRandomOffset)

        -- Если контейнер пуст или никогда не обыскивался, или прошло время респавна
        if not ContainerStorage[ent] or (lastLoot > 0 and (now - lastLoot) > respawnInterval) then
            local def = GetContainerDef(ent)
            local isCorpse = ent:GetClass() == "prop_ragdoll" and ent.IsPlayerCorpse

            if def then
                ContainerGridSize[ent] = { w = def.w, h = def.h }
                if def.pool == "quest_only" or def.questItem then
                    local qid = def.questItem
                    local db = qid and EFT.ItemDatabase[qid]
                    if db then
                        ContainerStorage[ent] = {
                            {
                                uniqueID = tostring(util.CRC(qid .. tostring(ent:EntIndex()) .. tostring(now))),
                                id = qid, x = 1, y = 1,
                                w = db.w or 2, h = db.h or 2,
                                examined = true, fir = true, count = 1,
                            }
                        }
                    else
                        ContainerStorage[ent] = {}
                    end
                else
                    ContainerStorage[ent] = GenerateLoot(def.pool, def.w, def.h)
                end
                -- После респавна сейф снова закрыт
                if def.locked or def.requiresLockpick then
                    ent.EFT_Unlocked = nil
                end
                ContainerLastLootTime[ent] = now
            elseif isCorpse and not ContainerStorage[ent] then
                ContainerGridSize[ent] = { w = EFT.Config.CorpseGridWidth, h = EFT.Config.CorpseGridHeight }
                ContainerStorage[ent] = GenerateLoot("corpse_bonus", EFT.Config.CorpseGridWidth, EFT.Config.CorpseGridHeight)
                ContainerLastLootTime[ent] = now
            end
        end

        return ContainerStorage[ent] or {}
    end

    local function GetGridSize(ent)
        return ContainerGridSize[ent] or { w = EFT.Config.CorpseGridWidth, h = EFT.Config.CorpseGridHeight }
    end

    local function SyncLootState(ply, ent)
        if not IsValid(ply) or not IsValid(ent) then return end
        local size = GetGridSize(ent)
        local personal = (EFT.VirtualInventory and EFT.VirtualInventory[ply]) or {}
        local equip = (EFT.PlayerEquipment and EFT.PlayerEquipment[ply]) or {}
        local pW = EFT.Config.PersonalGridBaseW or 2
        local pH = EFT.Config.PersonalGridBaseH or 5
        local rigItems, bpItems = {}, {}
        local rW, rH, bW, bH = 0, 0, 0, 0
        if equip.rigUID and EFT.RigContents and EFT.RigContents[equip.rigUID] then
            rigItems = EFT.RigContents[equip.rigUID]
            local rd = EFT.ItemDatabase[equip.rig]
            if rd and rd.gridSize then rW, rH = rd.gridSize.w, rd.gridSize.h end
        end
        if equip.backpackUID and EFT.BackpackContents and EFT.BackpackContents[equip.backpackUID] then
            bpItems = EFT.BackpackContents[equip.backpackUID]
            local bd = EFT.ItemDatabase[equip.backpack]
            if bd and bd.gridSize then bW, bH = bd.gridSize.w, bd.gridSize.h end
        end
        net.Start("EFT_OpenLoot")
            net.WriteEntity(ent)
            net.WriteTable(ContainerStorage[ent] or {})
            net.WriteTable(GetPlayerInventoryCounts(ply))
            net.WriteString(ent.CorpseOwner or ent:GetNWString("EFT_ForeignOwner", "") or "")
            net.WriteUInt(size.w, 8)
            net.WriteUInt(size.h, 8)
            net.WriteTable(personal)
            net.WriteUInt(pW, 8) net.WriteUInt(pH, 8)
            net.WriteTable(rigItems)
            net.WriteUInt(rW, 8) net.WriteUInt(rH, 8)
            net.WriteTable(bpItems)
            net.WriteUInt(bW, 8) net.WriteUInt(bH, 8)
        net.Send(ply)
    end

    local function SyncPersonalInventory(ply)
        if not IsValid(ply) then return end
        local equip = GetEquipment(ply)
        local personalSize = GetPersonalGridSize(ply)
        local rigSize = GetRigGridSize(ply)
        local backpackSize = GetBackpackGridSize(ply)
        net.Start("EFT_OpenInventory")
            net.WriteTable(GetVirtualInv(ply))
            net.WriteTable(GetVirtualRigInv(ply))
            net.WriteTable(GetVirtualBackpackInv(ply))
            net.WriteString(equip.backpack or "")
            net.WriteString(equip.vest or "")
            net.WriteString(equip.helmet or "")
            net.WriteString(equip.rig or "")
            net.WriteString(equip.mask or "")
            net.WriteString(equip.headphones or "")
            net.WriteInt(ply:GetNWInt("EFT_Money", 0), 32)
            net.WriteFloat(ComputeCarriedWeight(ply))
            net.WriteFloat(GetCarryCapacity(ply))
            net.WriteUInt(personalSize.w, 8)
            net.WriteUInt(personalSize.h, 8)
            net.WriteUInt(rigSize.w, 8)
            net.WriteUInt(rigSize.h, 8)
            net.WriteUInt(backpackSize.w, 8)
            net.WriteUInt(backpackSize.h, 8)
        net.Send(ply)
    end

    local function CanLootTarget(ply, ent)
        if not IsValid(ply) or not IsValid(ent) then return false end
        if ent == ply then return false end
        if ent:GetClass() == "prop_ragdoll" and ent:GetNWEntity("RagdollOwner") == ply then return false end
        if not ply:Alive() then return false end
        local nearest = ent:NearestPoint(ply:EyePos())
        if ply:EyePos():DistToSqr(nearest) > (EFT.Config.LootDistance or 160)^2 then return false end
        local tr = util.TraceLine({start=ply:EyePos(), endpos=nearest, filter=ply, mask=MASK_SOLID})
        return not tr.Hit or tr.Entity == ent
    end

    EFT.CanAccessInventoryContainer = CanLootTarget

    local function IsLootable(ent)
        if not IsValid(ent) then return false end
        if ent:GetClass() == "prop_ragdoll" then return true end
        return GetContainerDef(ent) ~= nil
    end

    local function OpenLootMenu(ply, ent)
        if not CanLootTarget(ply, ent) then return end
        local loot = GetEntityLoot(ent)
        local size = GetGridSize(ent)
        ActiveLooters[ply] = ent

        -- Personal grid for Tarkov-style left pane
        local personal = (EFT.VirtualInventory and EFT.VirtualInventory[ply]) or {}
        local equip = (EFT.PlayerEquipment and EFT.PlayerEquipment[ply]) or {}
        local pW = EFT.Config.PersonalGridBaseW or 2
        local pH = EFT.Config.PersonalGridBaseH or 5
        local rigItems, bpItems = {}, {}
        local rW, rH, bW, bH = 0, 0, 0, 0
        if equip.rigUID and EFT.RigContents and EFT.RigContents[equip.rigUID] then
            rigItems = EFT.RigContents[equip.rigUID]
            local rd = EFT.ItemDatabase[equip.rig]
            if rd and rd.gridSize then rW, rH = rd.gridSize.w, rd.gridSize.h end
        end
        if equip.backpackUID and EFT.BackpackContents and EFT.BackpackContents[equip.backpackUID] then
            bpItems = EFT.BackpackContents[equip.backpackUID]
            local bd = EFT.ItemDatabase[equip.backpack]
            if bd and bd.gridSize then bW, bH = bd.gridSize.w, bd.gridSize.h end
        end

        net.Start("EFT_OpenLoot")
            net.WriteEntity(ent)
            net.WriteTable(loot)
            net.WriteTable(GetPlayerInventoryCounts(ply))
            net.WriteString(ent.CorpseOwner or ent:GetNWString("EFT_ForeignOwner", "") or "")
            net.WriteUInt(size.w, 8)
            net.WriteUInt(size.h, 8)
            -- Tarkov dual-pane extras
            net.WriteTable(personal)
            net.WriteUInt(pW, 8) net.WriteUInt(pH, 8)
            net.WriteTable(rigItems)
            net.WriteUInt(rW, 8) net.WriteUInt(rH, 8)
            net.WriteTable(bpItems)
            net.WriteUInt(bW, 8) net.WriteUInt(bH, 8)
        net.Send(ply)

        -- Звук открытия ткани или дерева/металла в зависимости от контейнера
        local model = string.lower(ent:GetModel() or "")
        if string.find(model, "wood") then
            ent:EmitSound("physics/wood/wood_box_open1.wav", 70, 100)
        elseif string.find(model, "case") or string.find(model, "microwave") or string.find(model, "refrigerator") or string.find(model, "container") then
            ent:EmitSound("physics/metal/metal_box_break2.wav", 65, 110)
        else
            ent:EmitSound("physics/cardboard/cardboard_box_impact_soft1.wav", 65, 100)
        end
    end

    local function OpenShopMenu(ply, ent)
        if not IsValid(ply) then return end
        local items = {}
        for itemID, count in pairs(GetPlayerInventoryCounts(ply)) do
            local d = EFT.ItemDatabase[itemID]
            if d and d.price and d.price > 0 and d.type ~= "quest" and count > 0 then
                items[itemID] = count
            end
        end
        net.Start("EFT_OpenShop")
            net.WriteTable(items)
            net.WriteInt(ply:GetNWInt("EFT_Money", 0), 32)
        net.Send(ply)
    end

    -- Продавец оружия — витрина всех предметов с полем buyPrice
    local function OpenWeaponShopMenu(ply, ent)
        if not IsValid(ply) then return end
        local items = {}
        for itemID, d in pairs(EFT.ItemDatabase) do
            if d.type == "weapon" and d.buyPrice then items[itemID] = true end
        end
        net.Start("EFT_OpenWeaponShop")
            net.WriteTable(items)
            net.WriteInt(ply:GetNWInt("EFT_Money", 0), 32)
        net.Send(ply)
    end

    -- Обработка клавиши E + ПКМ для обыска, NPC и крафта.
    --
    -- ВАЖНО: раньше это было на hook.Add("KeyPress", ...). Если NPC не открывался,
    -- скорее всего дело в том, что hook.Call("KeyPress", ...) в GMod останавливается
    -- на первом хуке, который вернул НЕ nil — а у Z-City (или другого аддона) наверняка
    -- уже есть свой обработчик "E" для чего-то ещё, зарегистрированный РАНЬШЕ нашего,
    -- и наш код мог просто никогда не выполняться. Прямой опрос ply:KeyDown(IN_USE)
    -- в Think НЕ зависит от других хуков вообще — работает гарантированно.
    -- Верстак открывается по F (см. EFT_RequestLootF), не по E.
    -- Хук UseKeyPoll оставлен пустым-совместимым на случай других E-интеракций.
    hook.Add("Think", "EFT_LootSystem_UseKeyPoll", function()
        for _, ply in ipairs(player.GetAll()) do
            if not IsValid(ply) or not ply:Alive() then continue end
            local down = ply:KeyDown(IN_USE)
            local wasDown = UseKeyWasDown[ply] or false
            UseKeyWasDown[ply] = down
            -- верстак и лут — только через F
        end
    end)

    -- Запрос на лутинг/взаимодействие по клавише F (клиент сам определяет цель под
    -- прицелом, сервер лишь проверяет валидность перед запуском обыска/торговли).
    local function IsWorkbenchEnt(ent)
        if not IsValid(ent) then return false end
        local mdl = string.lower(string.gsub(ent:GetModel() or "", "\\", "/"))
        return mdl == "models/eftpropspack/reserv_repair_station_workbench.mdl"
            or string.find(mdl, "reserv_repair_station_workbench", 1, true) ~= nil
            or string.find(mdl, "workbench", 1, true) ~= nil
    end

    net.Receive("EFT_RequestLootF", function(len, ply)
        if not IsValid(ply) or not ply:Alive() then return end
        local ent = net.ReadEntity()
        if not IsValid(ent) then return end
        if ply:GetPos():DistToSqr(ent:GetPos()) > (EFT.Config.LootDistance * EFT.Config.LootDistance) then return end

        -- Верстак — открытие по F
        if IsWorkbenchEnt(ent) then
            local matItems = {}
            for id, count in pairs(GetPlayerInventoryCounts(ply)) do
                local d = EFT.ItemDatabase[id]
                if d and count > 0 then matItems[id] = count end
            end
            net.Start("EFT_OpenWorkbench")
                net.WriteTable(matItems)
            net.Send(ply)
            ent:EmitSound("ambient/machines/thumper_startup1.wav", 60, 110)
            return
        end

        -- Одесса: магазин ТОЛЬКО через диалог (EFT_RequestOdessaDialog), не напрямую по F
        if ent:GetClass() == "npc_odessa" then
            return
        end

        -- Продавец оружия: торговля ТОЛЬКО через диалог (EFT_RequestBarneyDialog)
        if ent:GetClass() == "npc_weapon_dealer" then
            return
        end

        if not CanLootTarget(ply, ent) then return end
        if not IsLootable(ent) then return end

        net.Start("EFT_StartSearchContainer")
            net.WriteEntity(ent)
        net.Send(ply)
    end)

    -- Диагностика: посмотреть точный класс/модель того, во что целится игрок —
    -- полезно, если что-то из вышеперечисленного всё ещё не реагирует на E.
    concommand.Add("eft_checktarget", function(ply)
        if not IsValid(ply) then return end
        local tr = ply:GetEyeTrace()
        if IsValid(tr.Entity) then
            ply:ChatPrint("[EFT] Класс: " .. tr.Entity:GetClass() .. " | Модель: " .. tostring(tr.Entity:GetModel()))
        else
            ply:ChatPrint("[EFT] Ничего не найдено под прицелом.")
        end
    end)

    -- Аварийный способ открыть магазин Одессы напрямую, если NPC всё равно не реагирует
    concommand.Add("eft_forceshop", function(ply)
        if not IsValid(ply) then return end
        OpenShopMenu(ply, ply)
    end)

    -- Снять одну отмычку из инвентаря игрока (возвращает true если сняли)
    local function ConsumeOneLockpick(ply)
        local lists = {
            GetVirtualInv(ply),
            GetVirtualRigInv(ply),
            GetVirtualBackpackInv(ply),
        }
        if EFT.GetPantsInv then table.insert(lists, EFT.GetPantsInv(ply)) end
        if EFT.GetShirtInv then table.insert(lists, EFT.GetShirtInv(ply)) end
        for _, list in ipairs(lists) do
            if not list then continue end
            for i, it in ipairs(list) do
                if it.id == "tool_lockpick" then
                    table.remove(list, i)
                    return true
                end
            end
        end
        return false
    end

    local function PlayerHasLockpick(ply)
        local counts = GetPlayerInventoryCounts(ply)
        return (counts["tool_lockpick"] or 0) >= 1
    end

    -- Сетевой ответ на успешное завершение обыска
    net.Receive("EFT_SearchContainerComplete", function(len, ply)
        if not IsValid(ply) or not ply:Alive() then return end
        local ent = net.ReadEntity()
        if not IsValid(ent) or ply:GetPos():DistToSqr(ent:GetPos()) > (EFT.Config.LootDistance * EFT.Config.LootDistance) then return end
        if not IsLootable(ent) then return end

        local def = GetContainerDef(ent)
        -- Запертый сейф: нужна отмычка; 30% шанс сломаться — сейф НЕ открывается
        if def and (def.locked or def.requiresLockpick) and not ent.EFT_Unlocked then
            if not PlayerHasLockpick(ply) then
                ply:ChatPrint("[EFT] Сейф заперт. Нужна отмычка.")
                ply:EmitSound("doors/default_locked.wav", 60, 100)
                return
            end
            -- Пытаемся вскрыть
            if not ConsumeOneLockpick(ply) then
                ply:ChatPrint("[EFT] Сейф заперт. Нужна отмычка.")
                return
            end
            local broke = math.random() < 0.30
            if broke then
                ply:ChatPrint("[EFT] Отмычка сломалась! Сейф не открылся. Нужна новая отмычка.")
                ply:EmitSound("physics/metal/metal_box_break1.wav", 70, 110)
                -- сейф остаётся закрытым
                return
            end
            ent.EFT_Unlocked = true
            ply:ChatPrint("[EFT] Сейф открыт отмычкой.")
            ply:EmitSound("doors/door1_move.wav", 65, 120)
        end

        OpenLootMenu(ply, ent)
    end)

    hook.Add("PlayerUse", "EFT_LootSystem_BlockZCityUse", function(ply, ent)
        if IsValid(ply) and IsValid(ent) then
            if ply:KeyDown(IN_ATTACK2) and IsLootable(ent) then return false end
        end
    end)

    hook.Add("PlayerSpawn", "EFT_LootSystem_LimbReset", function(ply)
        EFT.PlayerLimbHealth[ply] = table.Copy(EFT.Config.LimbMaxHealth)
        timer.Simple(0, function() RefreshWornGear(ply) end)
    end)

    local HitgroupToLimb = {
        [HITGROUP_HEAD] = "head", [HITGROUP_CHEST] = "thorax", [HITGROUP_STOMACH] = "stomach",
        [HITGROUP_LEFTARM] = "leftarm", [HITGROUP_RIGHTARM] = "rightarm",
        [HITGROUP_LEFTLEG] = "leftleg", [HITGROUP_RIGHTLEG] = "rightleg",
    }

    hook.Add("ScalePlayerDamage", "EFT_LootSystem_LimbTracking", function(ply, hitgroup, dmginfo)
        local limb = HitgroupToLimb[hitgroup]
        if not limb then return end
        local pool = GetLimbHealth(ply)
        pool[limb] = math.max(0, pool[limb] - dmginfo:GetDamage())
    end)

    -- Создание трупа игрока с его лутом
    hook.Add("DoPlayerDeath", "EFT_LootSystem_CorpseSpawner", function(ply, attacker, dmg)
        timer.Simple(0.1, function()
            if not IsValid(ply) then return end

            local corpse = ply:GetRagdollEntity()
            if not IsValid(corpse) then
                corpse = ents.Create("prop_ragdoll")
                corpse:SetModel(ply:GetModel())
                corpse:SetPos(ply:GetPos())
                corpse:SetAngles(ply:GetAngles())
                corpse:Spawn()
            end

            corpse.IsPlayerCorpse = true
            corpse.CorpseOwner = ply:Nick()
            corpse:SetNWEntity("RagdollOwner", ply)

            local gridW, gridH = EFT.Config.CorpseGridWidth, EFT.Config.CorpseGridHeight
            local corpseLoot = {}

            for _, wep in ipairs(ply:GetWeapons()) do
                local class = wep:GetClass()
                local itemData = EFT.ItemDatabase[class]
                if itemData then
                    EFT.Grid.TryInsert(corpseLoot, class, itemData, gridW, gridH, { examined = true })
                end
            end

            local function copyToCorpse(list)
                for _, it in ipairs(list) do
                    local itemData = EFT.ItemDatabase[it.id]
                    if itemData then
                        EFT.Grid.TryInsert(corpseLoot, it.id, itemData, gridW, gridH, {
                            examined = true, count = it.count, hp = it.hp, uses = it.uses
                        })
                    end
                end
            end

            copyToCorpse(GetVirtualInv(ply))
            copyToCorpse(GetVirtualRigInv(ply))
            copyToCorpse(GetVirtualBackpackInv(ply))

            EFT.VirtualInventory[ply] = {}

            local equip = GetEquipment(ply)
            for _, slot in ipairs({ "backpack", "vest", "helmet", "rig", "mask", "headphones" }) do
                local itemID = equip[slot]
                if itemID then
                    local itemData = EFT.ItemDatabase[itemID]
                    if itemData then
                        EFT.Grid.TryInsert(corpseLoot, itemID, itemData, gridW, gridH, { examined = true })
                    end
                end
            end

            -- Освобождаем персональные хранилища рюкзака/разгрузки (их содержимое уже на трупе)
            if equip.backpackUID then EFT.BackpackContents[equip.backpackUID] = nil end
            if equip.rigUID then EFT.RigContents[equip.rigUID] = nil end

            EFT.PlayerEquipment[ply] = {
                backpack = nil, backpackUID = nil,
                vest = nil, helmet = nil,
                rig = nil, rigUID = nil,
                mask = nil, headphones = nil,
            }
            ClearWornGear(ply)

            local bonusCandidates, bonusPool = EFT.BuildLootCandidates("corpse_bonus")
            if #bonusCandidates > 0 then
                local bonusCount = math.random(bonusPool.countMin, bonusPool.countMax)
                for i = 1, bonusCount do
                    local pick = EFT.WeightedPick(bonusCandidates)
                    if pick then EFT.Grid.TryInsert(corpseLoot, pick.id, pick.data, gridW, gridH) end
                end
            end

            ContainerStorage[corpse] = corpseLoot
            ContainerGridSize[corpse] = { w = gridW, h = gridH }
            ContainerLastLootTime[corpse] = CurTime()
            ply:StripWeapons()
        end)
    end)

    net.Receive("EFT_ExamineItem", function(len, ply)
        if not IsValid(ply) or IsRateLimited(ply) then return end
        local ent = ActiveLooters[ply]
        local uniqueID = net.ReadString()
        if not CanLootTarget(ply, ent) or not ContainerStorage[ent] then return end

        for _, item in ipairs(ContainerStorage[ent]) do
            if item.uniqueID == uniqueID then
                item.examined = true
                SyncLootState(ply, ent)
                ply:EmitSound("ambient/machines/keyboard2_clicks.wav", 55, 110)
                return
            end
        end
    end)

    -- Перемещение / Перекладывание предметов
    net.Receive("EFT_TransferItem", function(len, ply)
        if not IsValid(ply) or not ply:Alive() or IsRateLimited(ply) then return end

        local ent = ActiveLooters[ply]
        local uniqueID = net.ReadString()
        local direction = net.ReadString()
        if not CanLootTarget(ply, ent) then ActiveLooters[ply] = nil return end

        local size = GetGridSize(ent)
        local containerLoot = ContainerStorage[ent] or {}

        if direction == "to_player" then
            local targetItem, targetIdx = nil, nil
            for idx, item in ipairs(containerLoot) do
                if item.uniqueID == uniqueID then targetItem, targetIdx = item, idx break end
            end

            if targetItem and targetItem.examined then
                local dbItem = EFT.ItemDatabase[targetItem.id]
                if dbItem then
                    local success = false

                    if dbItem.type == "weapon" then
                        ply:Give(targetItem.id)
                        success = true
                    elseif dbItem.type == "ammo" and dbItem.ammoName then
                        ply:GiveAmmo(targetItem.count or 1, dbItem.ammoName)
                        success = true
                    else
                        success = AddToPersonalInventory(ply, targetItem.id, dbItem, {
                            uniqueID = targetItem.uniqueID, count = targetItem.count, hp = targetItem.hp, uses = targetItem.uses, examined = true
                        })
                        if not success then ply:ChatPrint("[EFT] Нет свободного места в инвентаре/разгрузке!") end
                    end

                    if success then
                        table.remove(containerLoot, targetIdx)
                        ply:EmitSound(dbItem.sound or "weapons/smg1/switch_single.wav", 65, 100)
                    end
                end
            end
        elseif direction == "to_container" then
            local _, owned = FindPersonalItemByUniqueID(ply, uniqueID)
            local itemID = owned and owned.id or uniqueID
            local dbItem = EFT.ItemDatabase[itemID]

            if dbItem then
                local hasItem = false
                local extra = { examined = false } -- Tarkov: deposited items become unknown again

                if dbItem.type == "weapon" and ply:HasWeapon(itemID) then
                    if dbItem.canStore == false then
                        ply:ChatPrint("[EFT] Это оружие слишком крупное, чтобы убрать в контейнер!")
                    else
                        hasItem = true
                    end
                elseif dbItem.type == "ammo" and dbItem.ammoName then
                    local ammoLeft = ply:GetAmmoCount(dbItem.ammoName)
                    if ammoLeft > 0 then
                        hasItem = true
                        extra.count = math.min(ammoLeft, dbItem.maxStack or 30)
                    end
                elseif IsVirtualType(dbItem.type) then
                    local idx, item, invType = FindPersonalItemByUniqueID(ply, itemID)
                    if item then
                        hasItem = true
                        extra.count = item.count
                        extra.hp = item.hp
                        extra.uses = item.uses
                        extra.uniqueID = item.uniqueID
                    else
                        -- fallback по ID предмета (ищем во всех трёх инвентарях)
                        for _, invType2 in ipairs({ "personal", "rig", "backpack" }) do
                            local list2 = select(1, GetInvAndSize(ply, invType2))
                            for i2, it in ipairs(list2) do
                                if it.id == itemID then
                                    hasItem = true
                                    extra.count = it.count
                                    extra.hp = it.hp
                                    extra.uses = it.uses
                                    extra.uniqueID = it.uniqueID
                                    break
                                end
                            end
                            if hasItem then break end
                        end
                    end
                end

                if hasItem then
                    local inserted = EFT.Grid.TryInsert(containerLoot, itemID, dbItem, size.w, size.h, extra)
                    if inserted then
                        if dbItem.type == "weapon" then
                            ply:StripWeapon(itemID)
                        elseif dbItem.type == "ammo" and dbItem.ammoName then
                            ply:RemoveAmmo(extra.count, dbItem.ammoName)
                        elseif IsVirtualType(dbItem.type) then
                            local idx, item, invType = FindPersonalItemByUniqueID(ply, extra.uniqueID or uniqueID)
                            if item then
                                local list = select(1, GetInvAndSize(ply, invType))
                                table.remove(list, idx)
                            else
                                -- Поиск по ID (на случай стакающихся предметов без совпавшего uniqueID)
                                for _, invType2 in ipairs({ "personal", "rig", "backpack" }) do
                                    local list2 = select(1, GetInvAndSize(ply, invType2))
                                    for i2, it in ipairs(list2) do
                                        if it.id == itemID then table.remove(list2, i2) break end
                                    end
                                end
                            end
                            -- Рюкзак/разгрузка уходят в контейнер плоским предметом — освобождаем их личное хранилище
                            -- Storage follows the original UID into the container; do not erase it.
                        end
                        ply:EmitSound("physics/cardboard/cardboard_box_impact_soft2.wav", 65, 90)
                    else
                        ply:ChatPrint("[EFT] Нет свободного места в контейнере!")
                    end
                else
                    ply:ChatPrint("[EFT] У вас больше нет этого предмета!")
                end
            end
        end

        ContainerStorage[ent] = containerLoot
        SyncLootState(ply, ent)
    end)

    net.Receive("EFT_CloseLoot", function(len, ply)
        ActiveLooters[ply] = nil
    end)

    net.Receive("EFT_RequestInventory", function(len, ply)
        if not IsValid(ply) or IsRateLimited(ply) then return end
        SyncPersonalInventory(ply)
    end)

    -- Экипирование брони, рюкзака, разгрузки
    -- Убирает снятый рюкзак/разгрузку в другое место (никогда — в его же собственное хранилище,
    -- иначе предмет "вложится сам в себя"). excludeInvType = "backpack" или "rig" — какую сетку
    -- не трогать, потому что это сетка САМОГО снимаемого предмета.
    local function StowGearExcludingOwnGrid(ply, prevID, prevUID, excludeInvType, prevData)
        if not prevID then return true end
        local prevD = EFT.ItemDatabase[prevID]
        if not prevD then return true end
        local extra = table.Copy(prevData or {})
        extra.uniqueID = prevUID or extra.uniqueID
        extra.examined = true

        if excludeInvType ~= "rig" then
            local rigGrid = GetRigGridSize(ply)
            if rigGrid.w > 0 and EFT.Grid.TryInsert(GetVirtualRigInv(ply), prevID, prevD, rigGrid.w, rigGrid.h, extra) then
                return true
            end
        end
        if excludeInvType ~= "backpack" then
            local bpGrid = GetBackpackGridSize(ply)
            if bpGrid.w > 0 and EFT.Grid.TryInsert(GetVirtualBackpackInv(ply), prevID, prevD, bpGrid.w, bpGrid.h, extra) then
                return true
            end
        end
        local personalGrid = GetPersonalGridSize(ply)
        return EFT.Grid.TryInsert(GetVirtualInv(ply), prevID, prevD, personalGrid.w, personalGrid.h, extra) and true or false
    end

    -- Пытается найти предмет либо в личных инвентарях игрока, либо в открытом сейчас контейнере/шкафу/трупе.
    -- Возвращает item, removeFunc (вызов удаляет предмет из места, где он был найден), dbItem
    local slots = {backpack=true, rig=true, vest=true, helmet=true, mask=true, headphones=true}
    local nativeSlots = {vest="torso", helmet="head", mask="face", headphones="ears"}
    local function FindEquippableItem(ply, uid)
        local idx, item, kind = FindPersonalItemByUniqueID(ply, uid)
        if item then return item, select(1, GetInvAndSize(ply, kind)), idx, false end
        local ent = ActiveLooters[ply]
        if not CanLootTarget(ply, ent) then return end
        for i, value in ipairs(ContainerStorage[ent] or {}) do
            if value.uniqueID == uid then return value, ContainerStorage[ent], i, ent end
        end
    end
    local function SaveEquipment(ply)
        SyncPersonalInventory(ply)
        RefreshWornGear(ply)
        RecomputeArmor(ply)
        if EFT.Improvements and EFT.Improvements.SavePlayer then EFT.Improvements.SavePlayer(ply) end
    end
    local function EquipFromInventory(ply, uid, slot)
        if not IsValid(ply) or not ply:Alive() or not slots[slot] then return false end
        local item, source, index, container = FindEquippableItem(ply, uid)
        if not item then return false end
        if item.examined == false then ply:ChatPrint("[EFT] Сначала изучите предмет.") return false end
        local data = EFT.ItemDatabase[item.id]
        if not data then return false end
        local target = data.type == "armor" and data.armorSlot or data.type
        if target ~= slot then ply:ChatPrint("[EFT] Предмет не подходит к этому слоту.") return false end
        local native = nativeSlots[slot]
        if native and ply.armors and ply.armors[native] then
            ply:ChatPrint("[EFT] Сначала снимите надетую броню ZCity из этого слота.") return false
        end
        local equip = GetEquipment(ply)
        -- Remove source first: the freed cells can hold the previous gear.
        -- Restore the exact record on failure; no new UID and no lost contents.
        table.remove(source, index)
        if not StowGearExcludingOwnGrid(ply, equip[slot], equip[slot.."UID"], slot, equip[slot.."Data"]) then
            table.insert(source, index, item)
            ply:ChatPrint("[EFT] Нет места для снятой вещи. Освободите карманы.")
            return false
        end
        equip[slot], equip[slot.."UID"] = item.id, item.uniqueID
        equip[slot.."Data"] = table.Copy(item)
        if slot == "rig" then GetRigStorage(item.uniqueID) end
        if slot == "backpack" then GetBackpackStorage(item.uniqueID) end
        ply:EmitSound("npc/combine_soldier/gear1.wav", 65, 100)
        if IsValid(container) then SyncLootState(ply, container) end
        SaveEquipment(ply)
        return true
    end
    local function UnequipToInventory(ply, slot)
        if not IsValid(ply) or not ply:Alive() or not slots[slot] then return false end
        local equip = GetEquipment(ply)
        if not equip[slot] then return false end
        if not StowGearExcludingOwnGrid(ply, equip[slot], equip[slot.."UID"], slot, equip[slot.."Data"]) then
            ply:ChatPrint("[EFT] Нет места, чтобы снять вещь.") return false
        end
        equip[slot], equip[slot.."UID"], equip[slot.."Data"] = nil, nil, nil
        SaveEquipment(ply)
        return true
    end
    net.Receive("EFT_EquipItem", function(_, ply)
        if not IsValid(ply) or IsRateLimited(ply) then return end
        EquipFromInventory(ply, net.ReadString(), net.ReadString())
    end)
    net.Receive("EFT_UnequipItem", function(_, ply)
        if not IsValid(ply) or IsRateLimited(ply) then return end
        UnequipToInventory(ply, net.ReadString())
    end)

net.Receive("EFT_MoveItem", function(len, ply)
    if not IsValid(ply) or IsRateLimited(ply) then return end

    local uniqueID = tostring(net.ReadString() or "")
    local newX = net.ReadUInt(8)
    local newY = net.ReadUInt(8)
    local targetInv = net.ReadString() -- "personal", "rig" или "backpack"

    local idx, item, currentInvType = FindPersonalItemByUniqueID(ply, uniqueID)
    if not item then return end

    local dbItem = EFT.ItemDatabase[item.id]
    if not dbItem then return end

    -- === ЗАЩИТА ОТ РЕКУРСИИ === (рюкзак/разгрузка никогда не может лежать в своей же сетке,
    -- и рюкзак с разгрузкой не могут быть вложены друг в друга — надеваются только через слот)
    if targetInv == "backpack" and dbItem.type == "backpack" then
        ply:ChatPrint("[EFT] Нельзя положить рюкзак внутрь рюкзака!")
        SyncPersonalInventory(ply)
        return
    end

    if targetInv == "rig" and dbItem.type == "rig" then
        ply:ChatPrint("[EFT] Нельзя положить разгрузку внутрь разгрузки!")
        SyncPersonalInventory(ply)
        return
    end

    local sourceList = select(1, GetInvAndSize(ply, currentInvType))
    local targetList, targetGridSize = GetInvAndSize(ply, targetInv)

    local w = item.rotated and dbItem.h or dbItem.w
    local h = item.rotated and dbItem.w or dbItem.h

    -- Временное извлечение предмета для проверки перекрытий
    table.remove(sourceList, idx)

    if EFT.Grid.CanFit(targetList, item.id, dbItem, targetGridSize.w, targetGridSize.h, newX, newY, w, h, item.uniqueID) then
        item.x = newX
        item.y = newY
        table.insert(targetList, item)
        ply:EmitSound("physics/cardboard/cardboard_box_impact_soft2.wav", 55, 105)
    else
        table.insert(sourceList, item)
        ply:ChatPrint("[EFT] Недостаточно места или клетка занята!")
    end

    if EFT.Improvements and EFT.Improvements.SyncAll then
        EFT.Improvements.SyncAll(ply)
    else
        SyncPersonalInventory(ply)
    end
end)

    net.Receive("EFT_RotateItem", function(len, ply)
        if not IsValid(ply) or IsRateLimited(ply) then return end
        local uniqueID = net.ReadString()

        local idx, item, invType = FindPersonalItemByUniqueID(ply, uniqueID)
        if not item then return end

        local newW, newH = item.h, item.w
        local list, size = GetInvAndSize(ply, invType)

        if EFT.Grid.CanPlaceAt(list, item.x, item.y, newW, newH, size.w, size.h, uniqueID) then
            item.w, item.h = newW, newH
            item.rotated = not item.rotated
            ply:EmitSound("ambient/machines/keyboard3_clicks.wav", 45, 110)
        else
            ply:ChatPrint("[EFT] Не хватает места для поворота предмета!")
        end
        SyncPersonalInventory(ply)
    end)

    net.Receive("EFT_DropItem", function(len, ply)
        if not IsValid(ply) or not ply:Alive() or IsRateLimited(ply) then return end
        local uniqueID = tostring(net.ReadString() or "")
        if uniqueID == "" then return end

        local idx, item, invType = FindPersonalItemByUniqueID(ply, uniqueID)
        if not item then
            ply:ChatPrint("[EFT] Предмет не найден в инвентаре.")
            return
        end
        local dbItem = EFT.ItemDatabase[item.id]
        if not dbItem then return end

        local list = select(1, GetInvAndSize(ply, invType))
        if not list or not idx then return end
        table.remove(list, idx)

        -- Preserve backpack/rig inner storage on the drop entity
        local innerStorage = nil
        local uidKey = tostring(item.uniqueID or uniqueID)
        if dbItem.type == "backpack" and uidKey ~= "" and EFT.BackpackContents then
            innerStorage = EFT.BackpackContents[uidKey] or EFT.BackpackContents[item.uniqueID]
            EFT.BackpackContents[uidKey] = nil
            if item.uniqueID then EFT.BackpackContents[item.uniqueID] = nil end
        end
        if dbItem.type == "rig" and uidKey ~= "" and EFT.RigContents then
            innerStorage = EFT.RigContents[uidKey] or EFT.RigContents[item.uniqueID]
            EFT.RigContents[uidKey] = nil
            if item.uniqueID then EFT.RigContents[item.uniqueID] = nil end
        end

        -- Spawn pickable eft_dropped_item
        local dropEnt = ents.Create("eft_dropped_item")
        if not IsValid(dropEnt) then
            dropEnt = ents.Create("prop_physics")
        end
        if IsValid(dropEnt) then
            -- Set network vars BEFORE Spawn so Initialize sees ItemID
            if dropEnt.SetItemID then
                dropEnt:SetItemID(tostring(item.id or ""))
                dropEnt:SetItemUID(uidKey)
                dropEnt:SetItemCount(tonumber(item.count) or 0)
                dropEnt:SetItemHP(tonumber(item.hp) or 0)
                dropEnt:SetItemUses(tonumber(item.uses) or 0)
                dropEnt:SetItemFIR(item.fir and true or false)
                dropEnt:SetItemInsured(item.insured and true or false)
            else
                dropEnt.EFT_ItemID = tostring(item.id or "")
                dropEnt.EFT_ItemUID = uidKey
                dropEnt.EFT_ItemCount = tonumber(item.count) or 0
                dropEnt.EFT_ItemHP = tonumber(item.hp) or 0
                dropEnt.EFT_ItemUses = tonumber(item.uses) or 0
                dropEnt.EFT_ItemFIR = item.fir and true or false
                dropEnt.EFT_ItemInsured = item.insured and true or false
            end
            dropEnt.EFTInnerStorage = innerStorage
            dropEnt:SetPos(ply:GetPos() + ply:GetForward() * 40 + Vector(0, 0, 30))
            dropEnt:SetAngles(Angle(0, ply:EyeAngles().y, 0))
            dropEnt:Spawn()
            dropEnt:Activate()
            local mdl = (dbItem.model and dbItem.model ~= "") and string.Trim(tostring(dbItem.model)) or "models/props_junk/cardboard_box004a.mdl"
            if dropEnt.SetModel then
                local ok = pcall(function() dropEnt:SetModel(mdl) end)
                if not ok then pcall(function() dropEnt:SetModel("models/props_junk/cardboard_box004a.mdl") end) end
                if dropEnt.PhysicsInit then
                    pcall(function()
                        dropEnt:PhysicsInit(SOLID_VPHYSICS)
                        dropEnt:SetMoveType(MOVETYPE_VPHYSICS)
                        dropEnt:SetSolid(SOLID_VPHYSICS)
                    end)
                end
            end
            local phys = dropEnt:GetPhysicsObject()
            if IsValid(phys) then
                phys:Wake()
                phys:SetVelocity(ply:GetForward() * 120 + Vector(0, 0, 60))
            end
        else
            ply:ChatPrint("[EFT] Не удалось создать дроп предмета.")
        end

        ply:EmitSound("physics/cardboard/cardboard_box_impact_soft2.wav", 60, 85)
        if EFT.Improvements and EFT.Improvements.SyncAll then
            EFT.Improvements.SyncAll(ply)
        else
            SyncPersonalInventory(ply)
        end
    end)

    -- Потребление еды / напитков
    net.Receive("EFT_ConsumeItem", function(len, ply)
        if not IsValid(ply) or IsRateLimited(ply) then return end
        local uniqueID = net.ReadString()

        local idx, item, invType = FindPersonalItemByUniqueID(ply, uniqueID)
        if not item then return end
        local dbItem = EFT.ItemDatabase[item.id]
        if not dbItem or dbItem.type ~= "food" then return end

        local maxUses = dbItem.maxUses or 1
        item.uses = item.uses or maxUses
        item.uses = item.uses - 1

        ply:EmitSound("npc/barnacle/barnacle_crunch3.wav", 65, 100)

        local pool = GetLimbHealth(ply)
        pool["stomach"] = math.min(EFT.Config.LimbMaxHealth["stomach"], pool["stomach"] + 15)

        -- Tarkov vitals restore
        EFT.PlayerVitals = EFT.PlayerVitals or {}
        EFT.PlayerVitals[ply] = EFT.PlayerVitals[ply] or { energy = 80, hydration = 85 }
        local vit = EFT.PlayerVitals[ply]
        local maxE = (EFT.Config.Vitals and EFT.Config.Vitals.MaxEnergy) or 100
        local maxH = (EFT.Config.Vitals and EFT.Config.Vitals.MaxHydration) or 100
        vit.energy = math.min(maxE, (vit.energy or 0) + (dbItem.energy or 25))
        vit.hydration = math.min(maxH, (vit.hydration or 0) + (dbItem.hydration or (dbItem.name and string.find(string.lower(dbItem.name), "вод") and 40 or 15)))
        net.Start("EFT_SyncVitals")
            net.WriteFloat(vit.energy)
            net.WriteFloat(vit.hydration)
        net.Send(ply)

        if item.uses <= 0 then
            local list = select(1, GetInvAndSize(ply, invType))
            table.remove(list, idx)
            ply:ChatPrint("[EFT] Съедено: " .. dbItem.name)
        else
            ply:ChatPrint("[EFT] Вы употребили: " .. dbItem.name .. ". Осталось глотков/порций: " .. item.uses)
        end

        if EFT.Improvements and EFT.Improvements.SyncAll then
            EFT.Improvements.SyncAll(ply)
        else
            SyncPersonalInventory(ply)
        end
    end)

    -- Продажа Одессе (любой предмет с price, кроме квестовых)
    net.Receive("EFT_SellItem", function(len, ply)
        if not IsValid(ply) or IsRateLimited(ply) then return end
        local itemID = net.ReadString()
        local dbItem = EFT.ItemDatabase[itemID]
        if not dbItem or not dbItem.price or dbItem.price <= 0 then return end
        -- Квестовые предметы нельзя продавать
        if dbItem.type == "quest" then
            ply:ChatPrint("[Одесса] Такое не беру — это не на продажу.")
            return
        end

        -- Ищем во всех инвентарях (карманы, разгрузка, рюкзак, штаны, кофта)
        local list, idx, item = nil, nil, nil
        local candidates = {
            GetVirtualInv(ply),
            GetVirtualRigInv(ply),
            GetVirtualBackpackInv(ply),
        }
        if EFT.GetPantsInv then table.insert(candidates, EFT.GetPantsInv(ply)) end
        if EFT.GetShirtInv then table.insert(candidates, EFT.GetShirtInv(ply)) end

        for _, invList in ipairs(candidates) do
            if not invList then continue end
            for i, it in ipairs(invList) do
                if it.id == itemID then
                    list, idx, item = invList, i, it
                    break
                end
            end
            if item then break end
        end

        if not item or not list then
            ply:ChatPrint("[Одесса] У тебя этого нет.")
            return
        end

        -- Стак: продаём 1 шт., уменьшаем count; иначе убираем слот
        local soldCount = 1
        if item.count and item.count > 1 then
            item.count = item.count - 1
            soldCount = 1
        else
            table.remove(list, idx)
        end

        local unit = dbItem.price
        local sellPrice = unit + math.random(0, math.max(0, math.floor(unit * 0.25)))
        ply:SetNWInt("EFT_Money", ply:GetNWInt("EFT_Money", 0) + sellPrice)
        ply:ChatPrint("[Одесса] Продано: " .. dbItem.name .. " за " .. sellPrice .. "₽")
        ply:EmitSound("items/ammo_pickup.wav", 55, 110)

        -- Обновить витрину (только то, что реально можно продать)
        local items = {}
        for id, count in pairs(GetPlayerInventoryCounts(ply)) do
            local d = EFT.ItemDatabase[id]
            if d and d.price and d.price > 0 and d.type ~= "quest" and count > 0 then
                items[id] = count
            end
        end
        net.Start("EFT_OpenShop")
            net.WriteTable(items)
            net.WriteInt(ply:GetNWInt("EFT_Money", 0), 32)
        net.Send(ply)
    end)

    -- Покупка оружия у продавца (npc_weapon_dealer)
    net.Receive("EFT_BuyWeapon", function(len, ply)
        if not IsValid(ply) or IsRateLimited(ply) then return end
        local itemID = net.ReadString()
        local dbItem = EFT.ItemDatabase[itemID]
        if not dbItem or dbItem.type ~= "weapon" or not dbItem.buyPrice then return end

        local money = ply:GetNWInt("EFT_Money", 0)
        if money < dbItem.buyPrice then
            ply:ChatPrint("[Торговец] Недостаточно денег: " .. dbItem.name .. " стоит " .. dbItem.buyPrice .. "₽")
            return
        end

        ply:SetNWInt("EFT_Money", money - dbItem.buyPrice)
        ply:Give(itemID)
        ply:ChatPrint("[Торговец] Куплено: " .. dbItem.name .. " за " .. dbItem.buyPrice .. "₽")

        net.Start("EFT_OpenWeaponShop")
            local items = {}
            for id, d in pairs(EFT.ItemDatabase) do
                if d.type == "weapon" and d.buyPrice then items[id] = true end
            end
            net.WriteTable(items)
            net.WriteInt(ply:GetNWInt("EFT_Money", 0), 32)
        net.Send(ply)
    end)
    net.Receive("EFT_RequestMedicine", function(len, ply)
        if not IsValid(ply) or IsRateLimited(ply) then return end
        local medItems = {}

        local function countMeds(list)
            for _, it in ipairs(list) do
                local d = EFT.ItemDatabase[it.id]
                if d and d.type == "medicine" then
                    medItems[it.id] = (medItems[it.id] or 0) + 1
                end
            end
        end

        countMeds(GetVirtualInv(ply))
        countMeds(GetVirtualRigInv(ply))
        countMeds(GetVirtualBackpackInv(ply))

        net.Start("EFT_OpenMedicine")
            net.WriteTable(GetLimbHealth(ply))
            net.WriteTable(medItems)
        net.Send(ply)
    end)

    net.Receive("EFT_ApplyMedicine", function(len, ply)
        if not IsValid(ply) or IsRateLimited(ply) then return end
        local itemID = net.ReadString()
        local limb = net.ReadString()

        local dbItem = EFT.ItemDatabase[itemID]
        if not dbItem or dbItem.type ~= "medicine" then return end
        if not EFT.Config.LimbMaxHealth[limb] then return end

        local idx, item, invType = nil, nil, nil
        for i, it in ipairs(GetVirtualInv(ply)) do
            if it.id == itemID then idx = i; item = it; invType = "personal" break end
        end
        if not item then
            for i, it in ipairs(GetVirtualRigInv(ply)) do
                if it.id == itemID then idx = i; item = it; invType = "rig" break end
            end
        end
        if not item then
            for i, it in ipairs(GetVirtualBackpackInv(ply)) do
                if it.id == itemID then idx = i; item = it; invType = "backpack" break end
            end
        end

        if not item then return end

        local usedUp = false
        if item.uses then
            item.uses = item.uses - 1
            if item.uses <= 0 then usedUp = true end
        elseif item.hp then
            local room = EFT.Config.LimbMaxHealth[limb] - GetLimbHealth(ply)[limb]
            local toHeal = math.min(room, dbItem.healAmount or 30)
            local cost = math.min(item.hp, toHeal)
            item.hp = item.hp - cost
            if item.hp <= 0 then usedUp = true end
        else
            usedUp = true
        end

        if usedUp then
            local list = select(1, GetInvAndSize(ply, invType))
            table.remove(list, idx)
        end

        local pool = GetLimbHealth(ply)
        pool[limb] = math.min(EFT.Config.LimbMaxHealth[limb], pool[limb] + (dbItem.healAmount or 30))

        ply:EmitSound("weapons/famas/famas_forearm.wav", 65, 120)

        local medItems = {}
        local function rebuildMeds(list)
            for _, it in ipairs(list) do
                local d = EFT.ItemDatabase[it.id]
                if d and d.type == "medicine" then medItems[it.id] = (medItems[it.id] or 0) + 1 end
            end
        end
        rebuildMeds(GetVirtualInv(ply))
        rebuildMeds(GetVirtualRigInv(ply))
        rebuildMeds(GetVirtualBackpackInv(ply))

        net.Start("EFT_OpenMedicine")
            net.WriteTable(pool)
            net.WriteTable(medItems)
        net.Send(ply)
    end)

    -- Сетевой обработчик КРАФТА на верстаке
    net.Receive("EFT_CraftItem", function(len, ply)
        if not IsValid(ply) or not ply:Alive() or IsRateLimited(ply) then return end
        local recipeIndex = net.ReadUInt(8)
        local recipe = EFT.Recipes[recipeIndex]
        if not recipe then return end

        local counts = GetPlayerInventoryCounts(ply)

        -- 0. Инструмент обязателен, но НЕ расходуется
        local reqTool = recipe.requiredTool or (EFT.GetRecipeRequiredTool and EFT.GetRecipeRequiredTool(recipe))
        if reqTool then
            if (counts[reqTool] or 0) < 1 then
                local tname = (EFT.ToolNames and EFT.ToolNames[reqTool]) or (EFT.ItemDatabase[reqTool] and EFT.ItemDatabase[reqTool].name) or reqTool
                ply:ChatPrint("[Верстак] Нужен инструмент: " .. tname .. " (держите при себе, не расходуется).")
                return
            end
        end

        -- 1. Сначала проверяем наличие всех необходимых ресурсов у игрока
        local hasAll = true
        for _, ing in ipairs(recipe.ingredients) do
            if (counts[ing.id] or 0) < ing.count then
                hasAll = false
                break
            end
        end

        if not hasAll then
            ply:ChatPrint("[Верстак] У вас недостаточно ресурсов для этого чертежа!")
            return
        end

        -- 2. Забираем ресурсы из инвентаря/разгрузки игрока (инструменты не трогаем)
        for _, ing in ipairs(recipe.ingredients) do
            local dbCheck = EFT.ItemDatabase[ing.id]
            if dbCheck and dbCheck.isTool then continue end -- инструменты бесконечны
            local needed = ing.count
            -- Забираем патроны
            local dbIng = EFT.ItemDatabase[ing.id]
            if dbIng and dbIng.type == "ammo" and dbIng.ammoName then
                ply:RemoveAmmo(needed, dbIng.ammoName)
                needed = 0
            end

            -- Забираем виртуальные ресурсы из рюкзака
            if needed > 0 then
                local personalInv = GetVirtualInv(ply)
                for i = #personalInv, 1, -1 do
                    local it = personalInv[i]
                    if it.id == ing.id then
                        table.remove(personalInv, i)
                        needed = needed - 1
                        if needed <= 0 then break end
                    end
                end
            end

            -- Если еще нужно забрать, забираем из разгрузки
            if needed > 0 then
                local rigInv = GetVirtualRigInv(ply)
                for i = #rigInv, 1, -1 do
                    local it = rigInv[i]
                    if it.id == ing.id then
                        table.remove(rigInv, i)
                        needed = needed - 1
                        if needed <= 0 then break end
                    end
                end
            end

            -- Если еще нужно забрать, забираем из рюкзака
            if needed > 0 then
                local bpInv = GetVirtualBackpackInv(ply)
                for i = #bpInv, 1, -1 do
                    local it = bpInv[i]
                    if it.id == ing.id then
                        table.remove(bpInv, i)
                        needed = needed - 1
                        if needed <= 0 then break end
                    end
                end
            end
        end

        -- 3. Выдаем собранный предмет игроку
        local resultData = EFT.ItemDatabase[recipe.resultID]
        if resultData then
            if resultData.type == "weapon" then
                ply:Give(recipe.resultID)
            elseif resultData.type == "ammo" and resultData.ammoName then
                ply:GiveAmmo(recipe.resultCount or 30, resultData.ammoName)
            else
                local success = AddToPersonalInventory(ply, recipe.resultID, resultData, {
                    examined = true,
                    count = resultData.maxStack,
                    hp = resultData.maxHP,
                    uses = resultData.maxUses
                })
                if not success then
                    -- Если нет места, выбрасываем созданный предмет на верстак
                    local drop = ents.Create("prop_physics")
                    if IsValid(drop) then
                        local mdl = string.Trim(tostring(resultData.model or "")); local ok = pcall(function() drop:SetModel(mdl) end); if not ok then pcall(function() drop:SetModel("models/props_junk/cardboard_box004a.mdl") end) end
                        drop:SetPos(ply:GetPos() + ply:GetForward() * 45 + Vector(0,0,15))
                        drop:Spawn()
                    end
                    ply:ChatPrint("[Верстак] Инвентарь переполнен! Собранный предмет упал на пол.")
                end
            end
        end

        ply:EmitSound("ambient/materials/metal_groan.wav", 65, 120)
        
        -- Синхронизируем обновленные ресурсы
        local matItems = {}
        for id, count in pairs(GetPlayerInventoryCounts(ply)) do
            local d = EFT.ItemDatabase[id]
            if d and count > 0 then matItems[id] = count end
        end
        net.Start("EFT_OpenWorkbench")
            net.WriteTable(matItems)
        net.Send(ply)
    end)

    timer.Create("EFT_OverloadTick", EFT.Config.OverloadInterval, 0, function()
        for _, ply in ipairs(player.GetAll()) do
            if IsValid(ply) and ply:Alive() then
                if ComputeCarriedWeight(ply) > GetCarryCapacity(ply) then
                    ply:TakeDamage(EFT.Config.OverloadDamage, ply, ply)
                end
            end
        end
    end)

    hook.Add("PlayerDisconnected", "EFT_LootSystem_Cleanup", function(ply)
        ActiveLooters[ply] = nil
        NetCooldowns[ply] = nil
        EFT.VirtualInventory[ply] = nil
        local equip = EFT.PlayerEquipment[ply]
        if equip then
            if equip.backpackUID then EFT.BackpackContents[equip.backpackUID] = nil end
            if equip.rigUID then EFT.RigContents[equip.rigUID] = nil end
        end
        EFT.PlayerEquipment[ply] = nil
        EFT.PlayerLimbHealth[ply] = nil
        ClearWornGear(ply)
    end)

    -- ==========================================
    -- СТАРТОВАЯ ЭКИПИРОВКА ПРИ СПАВНЕ
    -- ==========================================
    -- Выдаёт лёгкий рюкзак и Glock при первом спавне за сессию (не при каждом респавне подряд,
    -- чтобы не дублировать снаряжение, если игрок уже что-то нашёл и снова умер/заспавнился).
    local EFT_HasSpawnedBefore = {}

    -- No unsolicited starter backpack, weapons or items. Existing saves are preserved.

    hook.Add("PlayerDisconnected", "EFT_LootSystem_StarterGearCleanup", function(ply)
        EFT_HasSpawnedBefore[ply] = nil
    end)
end

-- ==========================================
-- КЛИЕНТСКАЯ ЧАСТЬ
-- ==========================================
if CLIENT then
    local activeTooltip = nil
    local activeContainerEnt = nil
    local activeCorpseOwner = ""
    local lootFrame, inventoryFrame, shopFrame, medicineFrame, workbenchFrame = nil, nil, nil, nil, nil
    local hoveredGridItem = nil
    local hoveredGridType = "personal"
    local containerSearchedList = {}

    local COLOR_ACCENT = Color(220, 110, 30)
    local COLOR_PANEL_BG = Color(22, 18, 14)
    local COLOR_TEXT = Color(245, 240, 230)
    local COLOR_TEXT_DIM = Color(160, 130, 90)
    local COLOR_GOOD = Color(100, 180, 90)
    local COLOR_WARN = Color(235, 180, 40)
    local COLOR_BAD = Color(200, 70, 55)

    -- ==========================================
    -- ВЗАИМОДЕЙСТВИЕ / ЛУТИНГ ПО КЛАВИШЕ F
    -- ==========================================
    local wasFKeyDown = false
    local fPromptEnt = nil
    local fPromptKind = nil -- "loot" | "workbench" | "drop"

    local function IsWorkbenchModel(ent)
        if not IsValid(ent) then return false end
        local mdl = string.lower(string.gsub(ent:GetModel() or "", "\\", "/"))
        return mdl == "models/eftpropspack/reserv_repair_station_workbench.mdl"
            or string.find(mdl, "reserv_repair_station_workbench", 1, true) ~= nil
            or string.find(mdl, "workbench", 1, true) ~= nil
    end

    local function IsClientLootable(ent)
        if not IsValid(ent) then return false end
        -- npc_odessa и npc_weapon_dealer обрабатываются отдельными хуками диалога
        if ent:GetClass() == "npc_odessa" or ent:GetClass() == "npc_weapon_dealer" then return false end
        if ent:GetClass() == "prop_ragdoll" then return true end
        if ent:GetClass() == "eft_dropped_item" then return true end
        if IsWorkbenchModel(ent) then return true end
        return GetContainerDef(ent) ~= nil
    end

    local function GetPromptKind(ent)
        if not IsValid(ent) then return nil end
        if IsWorkbenchModel(ent) then return "workbench" end
        if ent:GetClass() == "eft_dropped_item" then return "drop" end
        if ent:GetClass() == "prop_ragdoll" or GetContainerDef(ent) then return "loot" end
        return "use"
    end

    -- Чёрный квадрат с буквой F (общий стиль подсказки)
    local function DrawFKeyPrompt(cx, cy)
        local size = 28
        local x = cx - size / 2
        local y = cy - size / 2
        -- тень
        draw.RoundedBox(4, x + 1, y + 1, size, size, Color(0, 0, 0, 160))
        -- чёрный квадрат
        draw.RoundedBox(4, x, y, size, size, Color(12, 12, 12, 230))
        -- тонкая рамка
        surface.SetDrawColor(200, 200, 200, 180)
        surface.DrawOutlinedRect(x, y, size, size, 1)
        -- буква F
        draw.SimpleText("F", "DermaDefaultBold", cx, cy, Color(240, 240, 240), TEXT_ALIGN_CENTER, TEXT_ALIGN_CENTER)
    end

    hook.Add("Think", "EFT_LootSystem_FKeybind", function()
        local ply = LocalPlayer()
        if not IsValid(ply) or not ply:Alive() or vgui.CursorVisible() then
            fPromptEnt = nil
            fPromptKind = nil
            wasFKeyDown = input.IsKeyDown(KEY_F)
            return
        end

        local tr = ply:GetEyeTrace()
        local ent = tr.Entity
        local distSqr = (EFT.Config.LootDistance or 160) * (EFT.Config.LootDistance or 160)

        fPromptEnt = nil
        fPromptKind = nil
        if IsValid(ent) and IsClientLootable(ent)
            and ply:GetPos():DistToSqr(ent:GetPos()) <= distSqr then
            fPromptEnt = ent
            fPromptKind = GetPromptKind(ent)
        end

        local down = input.IsKeyDown(KEY_F)
        if down and not wasFKeyDown and IsValid(fPromptEnt) then
            -- дропы обрабатываются отдельным net (EFT_PickupDrop), но можно и через RequestLootF — оставим совместимость
            if fPromptEnt:GetClass() == "eft_dropped_item" then
                net.Start("EFT_PickupDrop")
                    net.WriteEntity(fPromptEnt)
                net.SendToServer()
            else
                net.Start("EFT_RequestLootF")
                    net.WriteEntity(fPromptEnt)
                net.SendToServer()
            end
        end
        wasFKeyDown = down
    end)

    hook.Add("HUDPaint", "EFT_LootSystem_FHint", function()
        if not IsValid(fPromptEnt) then return end
        local scrW, scrH = ScrW(), ScrH()
        -- небольшой чёрный квадрат с F чуть ниже прицела
        DrawFKeyPrompt(scrW / 2, scrH / 2 + 42)
    end)

    -- Вспомогательная функция определения заголовка для текущей цели
    local function GetTargetTitle()
        if activeCorpseOwner and activeCorpseOwner ~= "" then return "ТРУП: " .. string.upper(activeCorpseOwner) end
        if IsValid(activeContainerEnt) and activeContainerEnt:GetClass() == "prop_ragdoll" then return "ТРУП ВЫЖИВШЕГО" end
        return "СОДЕРЖИМОЕ ОБЪЕКТА"
    end

    local function GetRarityInfo(itemData) return EFT.Rarity[itemData.rarity] or EFT.Rarity.common end

    local function RemoveItemTooltip()
        if IsValid(activeTooltip) then activeTooltip:Remove(); activeTooltip = nil end
    end

    local function CreateItemTooltip(itemData, x, y, extra)
        RemoveItemTooltip()
        local rarity = GetRarityInfo(itemData)

        local tooltip = vgui.Create("DPanel")
        tooltip:SetSize(280, 200)
        tooltip:SetPos(x + 20, y + 20)
        tooltip:SetDrawOnTop(true)

        tooltip.Paint = function(self, w, h)
            draw.RoundedBox(4, 0, 0, w, h, Color(12, 14, 15, 248))
            surface.SetDrawColor(rarity.color)
            surface.DrawOutlinedRect(0, 0, w, h)

            draw.SimpleText(itemData.name, "DermaDefaultBold", 15, 12, COLOR_TEXT)
            draw.SimpleText(rarity.label, "DermaDefault", 15, 30, rarity.color)

            surface.SetDrawColor(45, 45, 45, 255)
            surface.DrawLine(15, 48, w - 15, 48)

            local descText = itemData.desc
            if extra then
                if extra.count then descText = descText .. "\nВ стаке: " .. extra.count .. " шт." end
                if extra.hp then descText = descText .. "\nЗапас: " .. extra.hp .. " HP" end
                if extra.uses then descText = descText .. "\nПрименений: " .. extra.uses end
            end

            local lines = string.Explode("\n", descText)
            local curY = 56
            for _, line in ipairs(lines) do
                local words = string.Explode(" ", line)
                local currentLine = ""
                for _, word in ipairs(words) do
                    local candidate = (currentLine == "") and word or (currentLine .. " " .. word)
                    if surface.GetTextSize(candidate) > (w - 30) then
                        draw.SimpleText(currentLine, "DermaDefault", 15, curY, COLOR_TEXT_DIM)
                        currentLine = word; curY = curY + 14
                    else
                        currentLine = candidate
                    end
                end
                draw.SimpleText(currentLine, "DermaDefault", 15, curY, COLOR_TEXT_DIM)
                curY = curY + 14
            end

            draw.SimpleText("ВЕС: " .. string.format("%.2f", itemData.weight or 0) .. " кг", "DermaDefault", 15, h - 38, Color(150, 150, 150))
            draw.SimpleText("РАЗМЕР: " .. itemData.w .. "x" .. itemData.h, "DermaDefaultBold", 15, h - 22, Color(120, 120, 120))
            draw.SimpleText(EFT.CategoryLabels[itemData.type] or "", "DermaDefault", w - 15, h - 22, Color(120, 120, 120), TEXT_ALIGN_RIGHT)
        end
        activeTooltip = tooltip
    end

    local function AttachModelIcon(parent, model, size, offset)
        if not model or model == "" then return nil end
        model = string.Trim(tostring(model))
        if model == "" then return nil end
        local icon = vgui.Create("SpawnIcon", parent)
        icon:SetSize(size, size)
        icon:SetPos(offset or 0, offset or 0)
        -- pcall: битая/отсутствующая модель не роняет UI крафта/инвентаря
        local ok = pcall(function() icon:SetModel(model) end)
        if not ok then
            pcall(function() icon:SetModel("models/props_junk/cardboard_box004a.mdl") end)
        end
        icon:SetMouseInputEnabled(false)
        return icon
    end

    -- Отрисовка текста количества/прочности на иконке предмета
    local function DrawItemMetaOverlay(w, h, item, itemData)
        if not itemData then return end
        if itemData.maxStack and item.count then
            draw.SimpleText(item.count, "DermaDefaultBold", w - 4, h - 14, COLOR_TEXT, TEXT_ALIGN_RIGHT)
        elseif itemData.maxHP and item.hp then
            draw.SimpleText(item.hp .. " HP", "DermaDefaultBold", w - 4, h - 14, COLOR_GOOD, TEXT_ALIGN_RIGHT)
        elseif itemData.maxUses and item.uses then
            draw.SimpleText(item.uses .. "x", "DermaDefaultBold", w - 4, h - 14, COLOR_WARN, TEXT_ALIGN_RIGHT)
        end
    end

    -- ПКМ Контекстное меню
    local function OpenItemContextMenu(item, itemData, gridType)
        local menu = DermaMenu()
        menu:SetDrawOnTop(true)

        if itemData.type == "food" then
            menu:AddOption("Съесть/Выпить", function()
                net.Start("EFT_ConsumeItem")
                    net.WriteString(item.uniqueID)
                net.SendToServer()
            end):SetIcon("icon16/cup.png")
        elseif itemData.type == "medicine" then
            menu:AddOption("Использовать", function()
                net.Start("EFT_RequestMedicine")
                net.SendToServer()
            end):SetIcon("icon16/heart.png")
        end

        if itemData.type == "backpack" or itemData.type == "rig" or (itemData.type == "armor" and itemData.armorSlot) then
            menu:AddOption("Экипировать", function()
                local slot = itemData.type == "armor" and itemData.armorSlot or itemData.type
                net.Start("EFT_EquipItem")
                    net.WriteString(item.uniqueID)
                    net.WriteString(slot)
                net.SendToServer()
            end):SetIcon("icon16/user_suit.png")
        end

        if IsValid(shopFrame) and (itemData.type == "food" or itemData.type == "valuable") then
            menu:AddOption("Продать", function()
                net.Start("EFT_SellItem")
                    net.WriteString(item.id)
                net.SendToServer()
            end):SetIcon("icon16/money.png")
        end

        menu:AddOption("Выбросить", function()
            net.Start("EFT_DropItem")
                net.WriteString(tostring(item.uniqueID or ""))
            net.SendToServer()
        end):SetIcon("icon16/delete.png")

        menu:Open()
    end

    -- Обычная строка быстрого переноса лута в левой панели UI
    local function CreatePlayerItemRow(parent, itemID, itemData, count)
        local rarity = GetRarityInfo(itemData)
        local row = parent:Add("DPanel")
        row:Dock(TOP); row:SetHeight(70); row:DockMargin(0, 0, 5, 8)

        row.Paint = function(self, w, h)
            local hovered = self:IsHovered() or (IsValid(self.btn) and self.btn:IsHovered())
            draw.RoundedBox(4, 0, 0, w, h, COLOR_PANEL_BG)
            draw.RoundedBox(0, 0, 0, 3, h, rarity.color)
            surface.SetDrawColor(hovered and COLOR_ACCENT or Color(50, 50, 50))
            surface.DrawOutlinedRect(0, 0, w, h)

            draw.SimpleText(itemData.name, "DermaDefaultBold", 80, 12, COLOR_TEXT)
            local infoText = "В наличии: " .. count .. "  •  " .. string.format("%.2f", (itemData.weight or 0) * count) .. " кг"
            draw.SimpleText(infoText, "DermaDefault", 80, 32, COLOR_TEXT_DIM)
            draw.SimpleText(rarity.label, "DermaDefault", 80, 50, rarity.color)
        end

        AttachModelIcon(row, itemData.model, 60, 5)
        local btn = vgui.Create("DButton", row)
        btn:Dock(FILL); btn:SetText(""); btn.Paint = function() end
        row.btn = btn
        btn.DoClick = function()
            RemoveItemTooltip()
            net.Start("EFT_TransferItem")
                net.WriteString(itemID)
                net.WriteString("to_container")
            net.SendToServer()
        end
        return row
    end

    local function CreateContainerItemButton(parent, item, itemData, cellSize)
        local rarity = GetRarityInfo(itemData)
        local ix, iy = (item.x - 1) * cellSize + 2, (item.y - 1) * cellSize + 2
        local iw, ih = item.w * cellSize - 4, item.h * cellSize - 4

        local btn = vgui.Create("DButton", parent)
        btn:SetPos(ix, iy); btn:SetSize(iw, ih); btn:SetText("")

        local isExamining, examineProgress = false, 0
        if item.examined then AttachModelIcon(btn, itemData.model, math.min(iw, ih) - 6, 3) end

        btn.Paint = function(self, w, h)
            if not item.examined then
                draw.RoundedBox(4, 0, 0, w, h, Color(30, 31, 32, 250))
                surface.SetDrawColor(48, 50, 52)
                surface.DrawOutlinedRect(0, 0, w, h)
                draw.SimpleText("?", "DermaLarge", w / 2, h / 2, Color(100, 100, 100), TEXT_ALIGN_CENTER, TEXT_ALIGN_CENTER)

                if isExamining then
                    examineProgress = math.Clamp(examineProgress + FrameTime() * EFT.Config.ExamineSpeed, 0, 1)
                    draw.RoundedBox(0, 0, h - 8, w, 8, Color(15, 15, 15, 220))
                    draw.RoundedBox(0, 0, h - 8, w * examineProgress, 8, COLOR_ACCENT)
                    if examineProgress >= 1 then
                        isExamining = false
                        item.examined = true
                        net.Start("EFT_ExamineItem")
                            net.WriteString(item.uniqueID)
                        net.SendToServer()
                    end
                end
            else
                local hovered = self:IsHovered()
                if hovered then
                    draw.RoundedBox(2, 1, 1, w - 2, h - 2, Color(rarity.color.r, rarity.color.g, rarity.color.b, 45))
                end
                surface.SetDrawColor(rarity.color.r, rarity.color.g, rarity.color.b, hovered and 255 or 130)
                surface.DrawOutlinedRect(0, 0, w, h)
                surface.DrawOutlinedRect(1, 1, w - 2, h - 2)
                DrawItemMetaOverlay(w, h, item, itemData)
            end
        end

        btn.OnCursorEntered = function()
            if item.examined then
                local mx, my = gui.MousePos()
                CreateItemTooltip(itemData, mx, my, { count = item.count, hp = item.hp, uses = item.uses })
            end
        end
        btn.OnCursorMoved = function()
            if item.examined and IsValid(activeTooltip) then
                local mx, my = gui.MousePos()
                activeTooltip:SetPos(mx + 20, my + 20)
            end
        end
        btn.OnCursorExited = RemoveItemTooltip

        btn.OnMousePressed = function(self, key)
            if not item.examined then
                if key == MOUSE_LEFT or key == MOUSE_RIGHT then
                    isExamining = true; examineProgress = 0
                    surface.PlaySound("buttons/lightswitch2.wav")
                end
            elseif key == MOUSE_LEFT then
                -- Shift + LMB быстрый трансфер
                if input.IsKeyDown(KEY_LSHIFT) then
                    RemoveItemTooltip()
                    net.Start("EFT_TransferItem")
                        net.WriteString(item.uniqueID)
                        net.WriteString("to_player")
                    net.SendToServer()
                end
            end
        end
        btn.OnMouseReleased = function() isExamining = false; examineProgress = 0 end
        return btn
    end

    -- Интерактивные ячейки персональной сетки (Перетаскивание, Подсветка сетки, Drop, ПКМ)
    local function CreatePersonalGridItemButton(parent, item, itemData, cellSize, gridType)
        local rarity = GetRarityInfo(itemData)
        local ix, iy = (item.x - 1) * cellSize + 2, (item.y - 1) * cellSize + 2
        local iw, ih = item.w * cellSize - 4, item.h * cellSize - 4

        local btn = vgui.Create("DButton", parent)
        btn:SetPos(ix, iy); btn:SetSize(iw, ih); btn:SetText("")
        AttachModelIcon(btn, itemData.model, math.min(iw, ih) - 6, 3)

        btn.Paint = function(self, w, h)
            local hovered = self:IsHovered()
            draw.RoundedBox(4, 0, 0, w, h, Color(30, 31, 32, 250))
            if hovered then
                draw.RoundedBox(2, 1, 1, w - 2, h - 2, Color(rarity.color.r, rarity.color.g, rarity.color.b, 45))
            end
            surface.SetDrawColor(rarity.color.r, rarity.color.g, rarity.color.b, hovered and 255 or 150)
            surface.DrawOutlinedRect(0, 0, w, h)
            if item.rotated then
                draw.SimpleText("R", "DermaDefaultBold", w - 6, 3, Color(255, 255, 255, 160), TEXT_ALIGN_RIGHT)
            end
            DrawItemMetaOverlay(w, h, item, itemData)
        end

        btn.OnCursorEntered = function()
            local mx, my = gui.MousePos()
            CreateItemTooltip(itemData, mx, my, { count = item.count, hp = item.hp, uses = item.uses })
            hoveredGridItem = item.uniqueID
            hoveredGridType = gridType
        end
        btn.OnCursorMoved = function()
            if IsValid(activeTooltip) then
                local mx, my = gui.MousePos()
                activeTooltip:SetPos(mx + 20, my + 20)
            end
        end
        btn.OnCursorExited = function()
            RemoveItemTooltip()
            if hoveredGridItem == item.uniqueID then hoveredGridItem = nil end
        end

        btn.OnMousePressed = function(self, key)
            if key == MOUSE_RIGHT then
                OpenItemContextMenu(item, itemData, gridType)
                return
            end

            if key ~= MOUSE_LEFT then return end

            -- Быстрый выброс по Ctrl + LMB
            if input.IsKeyDown(KEY_LCONTROL) then
                net.Start("EFT_DropItem")
                    net.WriteString(tostring(item.uniqueID or ""))
                net.SendToServer()
                return
            end

            local mx, my = gui.MousePos()
            self.dragStartX, self.dragStartY = mx, my
            self.origX, self.origY = self:GetPos()
            self.wasDragged = false
            self:MouseCapture(true)
        end

        btn.Think = function(self)
            if not self.dragStartX or not input.IsMouseDown(MOUSE_LEFT) then return end
            local mx, my = gui.MousePos()
            local dist = math.sqrt((mx - self.dragStartX) ^ 2 + (my - self.dragStartY) ^ 2)
            if dist > 6 then
                self.wasDragged = true
                RemoveItemTooltip()

                -- Определяем, над какой сеткой сейчас курсор (может отличаться от родной)
                local dragParent = parent
                if IsValid(inventoryFrame) then
                    for _, child in ipairs(inventoryFrame:GetChildren()) do
                        if child.previewFit ~= nil then
                            local ocx, ocy = child:LocalToScreen(0, 0)
                            local ocw, och = child:GetSize()
                            if mx >= ocx and mx <= ocx + ocw and my >= ocy and my <= ocy + och then
                                dragParent = child
                                break
                            end
                        end
                    end
                end

                local lx, ly = dragParent:ScreenToLocal(mx, my)

                -- Магнитим к ближайшей клетке сетки (округление, а не floor — предмет
                -- "прилипает" к клетке под курсором вместо плавного пиксельного следования)
                local targetX = math.floor((lx - iw / 2) / cellSize + 0.5) + 1
                local targetY = math.floor((ly - ih / 2) / cellSize + 0.5) + 1

                local maxW = math.floor(dragParent:GetWide() / cellSize)
                local maxH = math.floor(dragParent:GetTall() / cellSize)

                local fits = targetX >= 1 and targetY >= 1 and (targetX + item.w - 1) <= maxW and (targetY + item.h - 1) <= maxH

                -- Клэмпим отображаемую позицию, чтобы иконка не вылезала за пределы сетки
                local clampedX = math.Clamp(targetX, 1, math.max(1, maxW - item.w + 1))
                local clampedY = math.Clamp(targetY, 1, math.max(1, maxH - item.h + 1))

                if dragParent == parent then
                    self:SetPos((clampedX - 1) * cellSize + 2, (clampedY - 1) * cellSize + 2)
                else
                    -- Над чужой сеткой — просто следуем за курсором (у неё другой родитель/координаты)
                    local plx, ply = parent:ScreenToLocal(mx, my)
                    self:SetPos(plx - iw / 2, ply - ih / 2)
                end
                self:MoveToFront()

                -- Подсветка Drag Preview — сбрасываем у всех сеток, включаем только у активной
                if IsValid(inventoryFrame) then
                    for _, child in ipairs(inventoryFrame:GetChildren()) do
                        if child.previewFit ~= nil and child ~= dragParent then
                            child.previewW = nil
                        end
                    end
                end
                dragParent.previewFit = fits
                dragParent.previewX = targetX
                dragParent.previewY = targetY
                dragParent.previewW = item.w
                dragParent.previewH = item.h

                self.snapGrid = dragParent
                self.snapTargetX = targetX
                self.snapTargetY = targetY
            end
        end

        btn.OnMouseReleased = function(self, key)
            if key ~= MOUSE_LEFT then return end
            self:MouseCapture(false)

            if IsValid(inventoryFrame) then
                for _, child in ipairs(inventoryFrame:GetChildren()) do
                    if child.previewFit ~= nil then child.previewW = nil end
                end
            end

            if self.wasDragged then
                local mx, my = gui.MousePos()
                local gx, gy = parent:LocalToScreen(0, 0)
                local gw, gh = parent:GetSize()

                local targetGrid = self.snapGrid

                if IsValid(targetGrid) and targetGrid ~= parent then
                    net.Start("EFT_MoveItem")
                        net.WriteString(item.uniqueID)
                        net.WriteUInt(math.Clamp(self.snapTargetX or 1, 1, 255), 8)
                        net.WriteUInt(math.Clamp(self.snapTargetY or 1, 1, 255), 8)
                        net.WriteString(targetGrid.gridType)
                    net.SendToServer()
                elseif mx < gx or mx > gx + gw or my < gy or my > gy + gh then
                    -- Выброс за пределы инвентаря
                    net.Start("EFT_DropItem")
                        net.WriteString(tostring(item.uniqueID or ""))
                    net.SendToServer()
                else
                    -- Перемещение внутри той же сетки — используем ту же ячейку,
                    -- к которой предмет уже примагничен визуально
                    net.Start("EFT_MoveItem")
                        net.WriteString(item.uniqueID)
                        net.WriteUInt(math.Clamp(self.snapTargetX or 1, 1, 255), 8)
                        net.WriteUInt(math.Clamp(self.snapTargetY or 1, 1, 255), 8)
                        net.WriteString(gridType)
                    net.SendToServer()
                end
            end

            self.dragStartX = nil
            self.wasDragged = false
            self.snapGrid = nil
        end

        return btn
    end

    local function MakeCloseButton(frame)
        local closeBtn = vgui.Create("DButton", frame)
        closeBtn:SetSize(50, 50)
        closeBtn:SetPos(frame:GetWide() - 50, 0)
        closeBtn:SetText("✕"); closeBtn:SetFont("DermaLarge")
        closeBtn.Paint = function(self, w, h)
            if self:IsHovered() then
                draw.RoundedBox(0, 0, 0, w, h, Color(180, 40, 40, 250))
                self:SetTextColor(COLOR_TEXT)
            else
                self:SetTextColor(Color(150, 150, 150))
            end
        end
        return closeBtn
    end

    -- Отрисовка сетки с поддержкой Drag Preview
    local function PaintGridWithPreview(panel, w, h, gridW, gridH, cellSize)
        -- Обычные ячейки
        for x = 0, gridW - 1 do
            for y = 0, gridH - 1 do
                draw.RoundedBox(0, x * cellSize, y * cellSize, cellSize - 1, cellSize - 1, Color(22, 24, 25, 255))
                surface.SetDrawColor(36, 38, 40, 255)
                surface.DrawOutlinedRect(x * cellSize, y * cellSize, cellSize, cellSize)
            end
        end

        -- Подсветка Drag Preview
        if panel.previewW and panel.previewX then
            local color = panel.previewFit and Color(0, 200, 50, 60) or Color(220, 50, 50, 60)
            draw.RoundedBox(0, (panel.previewX - 1) * cellSize, (panel.previewY - 1) * cellSize, panel.previewW * cellSize, panel.previewH * cellSize, color)
        end
    end

    -- ==========================================
    -- АНИМАЦИЯ И ШКАЛА ОБЫСКА КОНТЕЙНЕРА
    -- ==========================================
    net.Receive("EFT_StartSearchContainer", function()
        local ent = net.ReadEntity()
        if not IsValid(ent) then return end

        if IsValid(lootFrame) then lootFrame:Close() end

        -- Если контейнер уже обыскивался в этой сессии, открываем мгновенно
        if containerSearchedList[ent] then
            net.Start("EFT_SearchContainerComplete")
                net.WriteEntity(ent)
            net.SendToServer()
            return
        end

        local soundLoop = CreateSound(ent, "npc/combine_soldier/gear1.wav")
        soundLoop:Play()

        local searchFrame = vgui.Create("DFrame")
        searchFrame:SetSize(350, 100)
        searchFrame:Center()
        searchFrame:SetTitle("")
        searchFrame:ShowCloseButton(false)
        searchFrame:MakePopup()

        local progress = 0
        searchFrame.Paint = function(self, w, h)
            draw.RoundedBox(8, 0, 0, w, h, Color(12, 13, 15, 252))
            surface.SetDrawColor(201, 148, 58, 200)
            surface.DrawOutlinedRect(0, 0, w, h)
            surface.DrawOutlinedRect(1, 1, w - 2, h - 2)

            draw.SimpleText("ОСМОТР...", "DermaDefaultBold", w/2, 22, Color(235, 180, 40), TEXT_ALIGN_CENTER)
            draw.SimpleText("Не отходите от контейнера", "Default", w/2, 40, Color(160, 130, 90), TEXT_ALIGN_CENTER)

            draw.RoundedBox(4, 24, 58, w - 48, 14, Color(24, 26, 28))
            draw.RoundedBox(4, 24, 58, (w - 48) * progress, 14, Color(201, 148, 58))
            draw.SimpleText(math.floor(progress * 100) .. "%", "DermaDefaultBold", w/2, 65, color_white, TEXT_ALIGN_CENTER, TEXT_ALIGN_CENTER)
        end

        searchFrame.Think = function(self)
            -- Достаточно нажать F один раз: прогресс идёт сам, пока рядом с контейнером
            if not IsValid(ent) or LocalPlayer():GetPos():DistToSqr(ent:GetPos()) > (EFT.Config.LootDistance * EFT.Config.LootDistance) then
                soundLoop:Stop()
                self:Close()
                return
            end

            progress = progress + FrameTime() * (EFT.Config.SearchSpeed or 0.5)
            if progress >= 1 then
                soundLoop:Stop()
                surface.PlaySound("weapons/famas/famas_forearm.wav")
                containerSearchedList[ent] = true
                self:Close()
                net.Start("EFT_SearchContainerComplete")
                    net.WriteEntity(ent)
                net.SendToServer()
            end
        end
    end)

    -- Меню обыска содержимого контейнера
    -- ==========================================
    -- TARKOV-STYLE LOOT UI  (inventory LEFT · container RIGHT)
    -- ==========================================
    local function OpenEFTDualLootMenu(containerLoot, playerInv, gridW, gridH, personalItems, pW, pH, rigItems, rW, rH, bpItems, bW, bH)
        if IsValid(lootFrame) then lootFrame:Close() end
        personalItems = personalItems or {}
        pW, pH = pW or (EFT.Config.PersonalGridBaseW or 2), pH or (EFT.Config.PersonalGridBaseH or 5)
        rigItems, rW, rH = rigItems or {}, rW or 0, rH or 0
        bpItems, bW, bH = bpItems or {}, bW or 0, bH or 0

        local cell = math.min(EFT.Config.CellSize or 42, 44)
        local TC = {
            bg = Color(12, 12, 11, 250),
            panel = Color(22, 18, 14, 255),
            panelSoft = Color(28, 22, 16, 255),
            cell = Color(32, 26, 18, 255),
            cellLine = Color(80, 50, 20, 180),
            header = Color(10, 9, 8, 255),
            accent = Color(220, 110, 30),
            accentDim = Color(220, 110, 30, 40),
            text = Color(245, 240, 230),
            dim = Color(160, 130, 90),
            good = Color(100, 180, 90),
            bad = Color(200, 70, 55),
            unknown = Color(40, 32, 24),
            glow = Color(220, 110, 30, 25),
        }

        -- Compute left pane width from personal + rig + backpack grids
        local leftGridsW = pW * cell
        if bW > 0 then leftGridsW = leftGridsW + 10 + bW * cell end
        if rW > 0 then leftGridsW = leftGridsW + 10 + rW * cell end
        leftGridsW = math.max(leftGridsW, 180)

        local rightW = gridW * cell
        local rightH = gridH * cell
        local leftH = math.max(pH * cell, (bH > 0 and bH * cell or 0), (rH > 0 and rH * cell or 0), 200)

        local pad = 14
        local headerH = 52
        local frameW = math.Clamp(pad + leftGridsW + 24 + rightW + pad + 20, 720, ScrW() - 40)
        local frameH = math.Clamp(headerH + 28 + math.max(leftH, rightH) + 50, 420, ScrH() - 40)

        local frame = vgui.Create("DFrame")
        frame:SetSize(frameW, frameH)
        frame:Center()
        frame:SetTitle("")
        frame:MakePopup()
        frame:ShowCloseButton(false)
        lootFrame = frame
        frame.OnRemove = function()
            if RemoveItemTooltip then RemoveItemTooltip() end
            if lootFrame == frame then lootFrame = nil end
        end

        frame.Paint = function(self, w, h)
            -- soft outer shadow
            for i = 6, 1, -1 do
                surface.SetDrawColor(0, 0, 0, 8 * i)
                surface.DrawOutlinedRect(-i, -i, w + i * 2, h + i * 2)
            end
            draw.RoundedBox(6, 0, 0, w, h, TC.bg)
            -- header bar with gradient feel
            draw.RoundedBoxEx(6, 0, 0, w, headerH, TC.header, true, true, false, false)
            surface.SetDrawColor(TC.accent)
            surface.DrawRect(0, headerH - 2, w, 2)

            draw.SimpleText("ВАШ ИНВЕНТАРЬ", "DermaDefaultBold", pad + leftGridsW / 2, 16, TC.dim, TEXT_ALIGN_CENTER)
            local title = (GetTargetTitle and GetTargetTitle()) or "КОНТЕЙНЕР"
            draw.SimpleText(title, "DermaDefaultBold", pad + leftGridsW + 24 + rightW / 2, 16, TC.accent, TEXT_ALIGN_CENTER)

            -- subtle vertical divider
            surface.SetDrawColor(40, 42, 46, 200)
            surface.DrawRect(pad + leftGridsW + 10, headerH + 8, 1, h - headerH - 20)
        end

        -- Close button (soft)
        local close = vgui.Create("DButton", frame)
        close:SetSize(36, 36)
        close:SetPos(frameW - 42, 8)
        close:SetText("")
        close.Paint = function(s, w, h)
            local hv = s:IsHovered()
            draw.RoundedBox(4, 0, 0, w, h, hv and Color(160, 50, 50) or Color(28, 30, 34))
            draw.SimpleText("✕", "DermaDefaultBold", w / 2, h / 2, TC.text, TEXT_ALIGN_CENTER, TEXT_ALIGN_CENTER)
        end
        close.DoClick = function()
            if RemoveItemTooltip then RemoveItemTooltip() end
            net.Start("EFT_CloseLoot") net.SendToServer()
            frame:Close()
        end

        -- Helper: soft grid background
        local function PaintSoftGrid(self, w, h, gw, gh)
            draw.RoundedBox(4, 0, 0, w, h, TC.panel)
            for x = 0, gw - 1 do
                for y = 0, gh - 1 do
                    local cx, cy = x * cell, y * cell
                    draw.RoundedBox(2, cx + 1, cy + 1, cell - 3, cell - 3, TC.cell)
                    surface.SetDrawColor(TC.cellLine)
                    surface.DrawOutlinedRect(cx + 1, cy + 1, cell - 3, cell - 3)
                end
            end
            if self.previewW and self.previewX then
                local col = self.previewFit and Color(60, 160, 80, 55) or Color(180, 50, 50, 55)
                draw.RoundedBox(2, (self.previewX - 1) * cell + 1, (self.previewY - 1) * cell + 1,
                    self.previewW * cell - 2, self.previewH * cell - 2, col)
            end
        end

        -- Container item button — авто-открытие без клика игрока
        local function SoftContainerItem(parent, item, itemData)
            local rarity = (GetRarityInfo and GetRarityInfo(itemData)) or { color = Color(160, 160, 160) }
            local ix = (item.x - 1) * cell + 2
            local iy = (item.y - 1) * cell + 2
            local iw = item.w * cell - 5
            local ih = item.h * cell - 5
            local btn = vgui.Create("DButton", parent)
            btn:SetPos(ix, iy) btn:SetSize(iw, ih) btn:SetText("")
            btn._eftItem = item
            btn._eftData = itemData
            local isExamining, examineProgress = false, 0
            if item.examined and AttachModelIcon then
                AttachModelIcon(btn, itemData.model, math.min(iw, ih) - 8, 4)
            end

            function btn:IsExamining()
                return isExamining and not item.examined
            end

            -- Запуск осмотра с полоской (~3 сек)
            function btn:StartAutoExamine()
                if item.examined or isExamining then return end
                isExamining = true
                examineProgress = 0
                surface.PlaySound("buttons/button15.wav")
            end

            btn.Paint = function(self, w, h)
                if not item.examined then
                    draw.RoundedBox(3, 0, 0, w, h, TC.unknown)
                    surface.SetDrawColor(70, 72, 78)
                    surface.DrawOutlinedRect(0, 0, w, h)
                    draw.SimpleText("?", "DermaLarge", w / 2, h / 2 - 2, Color(90, 92, 98), TEXT_ALIGN_CENTER, TEXT_ALIGN_CENTER)
                    if isExamining then
                        local spd = EFT.Config.ExamineSpeed or 0.34
                        examineProgress = math.Clamp(examineProgress + FrameTime() * spd, 0, 1)
                        draw.RoundedBox(0, 2, h - 6, w - 4, 4, Color(20, 20, 22))
                        draw.RoundedBox(0, 2, h - 6, (w - 4) * examineProgress, 4, TC.accent)
                        if examineProgress >= 1 then
                            isExamining = false
                            item.examined = true
                            net.Start("EFT_ExamineItem") net.WriteString(item.uniqueID) net.SendToServer()
                            if AttachModelIcon then AttachModelIcon(btn, itemData.model, math.min(iw, ih) - 8, 4) end
                            surface.PlaySound("buttons/button14.wav")
                        end
                    end
                else
                    local hv = self:IsHovered()
                    draw.RoundedBox(3, 0, 0, w, h, Color(24, 26, 29, 240))
                    if hv then
                        draw.RoundedBox(3, 1, 1, w - 2, h - 2, Color(rarity.color.r, rarity.color.g, rarity.color.b, 35))
                    end
                    surface.SetDrawColor(rarity.color.r, rarity.color.g, rarity.color.b, hv and 255 or 140)
                    surface.DrawOutlinedRect(0, 0, w, h)
                    if hv then surface.DrawOutlinedRect(1, 1, w - 2, h - 2) end
                    if DrawItemMetaOverlay then DrawItemMetaOverlay(w, h, item, itemData) end
                end
            end
            btn.DoClick = function()
                -- Пока не открыт — нельзя взять; открытие идёт автоматически
                if not item.examined then
                    surface.PlaySound("buttons/button10.wav")
                    return
                end
                net.Start("EFT_TransferItem")
                    net.WriteString(item.uniqueID)
                    net.WriteString("to_player")
                net.SendToServer()
            end
            btn.OnCursorEntered = function()
                if item.examined and CreateItemTooltip then
                    local mx, my = gui.MousePos()
                    CreateItemTooltip(itemData, mx, my, { count = item.count, hp = item.hp, uses = item.uses })
                end
            end
            btn.OnCursorExited = function()
                if RemoveItemTooltip then RemoveItemTooltip() end
            end
            return btn
        end

        -- Personal grid item (take to container on click)
        local function SoftPersonalItem(parent, item, itemData)
            local rarity = (GetRarityInfo and GetRarityInfo(itemData)) or { color = Color(160, 160, 160) }
            local ix = (item.x - 1) * cell + 2
            local iy = (item.y - 1) * cell + 2
            local iw = item.w * cell - 5
            local ih = item.h * cell - 5
            local btn = vgui.Create("DButton", parent)
            btn:SetPos(ix, iy) btn:SetSize(iw, ih) btn:SetText("")
            if AttachModelIcon then AttachModelIcon(btn, itemData.model, math.min(iw, ih) - 8, 4) end
            btn.Paint = function(self, w, h)
                local hv = self:IsHovered()
                draw.RoundedBox(3, 0, 0, w, h, Color(24, 26, 29, 240))
                if hv then
                    draw.RoundedBox(3, 1, 1, w - 2, h - 2, Color(rarity.color.r, rarity.color.g, rarity.color.b, 40))
                end
                surface.SetDrawColor(rarity.color.r, rarity.color.g, rarity.color.b, hv and 255 or 130)
                surface.DrawOutlinedRect(0, 0, w, h)
                if DrawItemMetaOverlay then DrawItemMetaOverlay(w, h, item, itemData) end
            end
            btn.DoClick = function()
                -- put into container by item id (main transfer expects id for to_container)
                net.Start("EFT_TransferItem")
                    net.WriteString(item.id)
                    net.WriteString("to_container")
                net.SendToServer()
            end
            btn.OnCursorEntered = function()
                if CreateItemTooltip then
                    local mx, my = gui.MousePos()
                    CreateItemTooltip(itemData, mx, my, { count = item.count, hp = item.hp, uses = item.uses })
                end
            end
            btn.OnCursorExited = function()
                if RemoveItemTooltip then RemoveItemTooltip() end
            end
            return btn
        end

        local contentY = headerH + 18
        local lx = pad

        -- LEFT: label + grids
        local function AddLeftGrid(items, gw, gh, title)
            if not gw or gw < 1 then return end
            local lbl = vgui.Create("DLabel", frame)
            lbl:SetPos(lx, contentY - 14)
            lbl:SetSize(gw * cell, 12)
            lbl:SetText(title)
            lbl:SetFont("Default")
            lbl:SetTextColor(TC.dim)

            local panel = vgui.Create("DPanel", frame)
            panel:SetPos(lx, contentY)
            panel:SetSize(gw * cell, math.min(gh * cell, frameH - contentY - 36))
            panel.Paint = function(self, w, h) PaintSoftGrid(self, w, h, gw, gh) end
            for _, it in ipairs(items or {}) do
                local db = EFT.ItemDatabase[it.id]
                if db then SoftPersonalItem(panel, it, db) end
            end
            lx = lx + gw * cell + 10
        end

        -- pockets removed
        -- AddLeftGrid(personalItems, pW, pH, "КАРМАНЫ")
        if bW > 0 then AddLeftGrid(bpItems, bW, bH, "РЮКЗАК") end
        if rW > 0 then AddLeftGrid(rigItems, rW, rH, "РАЗГРУЗКА") end

        -- RIGHT: container
        local rx = pad + leftGridsW + 24
        local rightLbl = vgui.Create("DLabel", frame)
        rightLbl:SetPos(rx, contentY - 14)
        rightLbl:SetSize(rightW, 12)
        rightLbl:SetText("СОДЕРЖИМОЕ")
        rightLbl:SetFont("Default")
        rightLbl:SetTextColor(TC.accent)

        local rightPanel = vgui.Create("DPanel", frame)
        rightPanel:SetPos(rx, contentY)
        rightPanel:SetSize(rightW, math.min(rightH, frameH - contentY - 36))
        rightPanel.Paint = function(self, w, h) PaintSoftGrid(self, w, h, gridW, gridH) end

        -- Авто-обыск: предметы сами открываются по очереди (без участия игрока)
        local phase = "done"
        local phaseUntil = 0
        local itemBtns = {}
        local pending = 0

        for _, it in ipairs(containerLoot or {}) do
            local db = EFT.ItemDatabase[it.id]
            if db then
                local b = SoftContainerItem(rightPanel, it, db)
                table.insert(itemBtns, b)
                if not it.examined then
                    phase = "reveal"
                    pending = pending + 1
                end
            end
        end

        if phase == "reveal" then
            -- перемешать порядок раскрытия
            for i = #itemBtns, 2, -1 do
                local j = math.random(i)
                itemBtns[i], itemBtns[j] = itemBtns[j], itemBtns[i]
            end
            phaseUntil = CurTime() + 0.35
        end

        rightPanel.Think = function(self)
            if phase ~= "reveal" then return end
            if not IsValid(frame) then return end

            -- Ждём, пока текущий предмет дорисует полоску (~3 сек)
            for _, b in ipairs(itemBtns) do
                if IsValid(b) and b.IsExamining and b:IsExamining() then
                    return
                end
            end

            if CurTime() < phaseUntil then return end

            local nextBtn = nil
            for _, b in ipairs(itemBtns) do
                if IsValid(b) and b._eftItem and not b._eftItem.examined then
                    nextBtn = b
                    break
                end
            end

            if not nextBtn then
                phase = "done"
                if IsValid(hint) then
                    hint:SetText("Осмотр завершён  ·  ЛКМ справа — взять  ·  ЛКМ слева — положить")
                end
                return
            end

            if nextBtn.StartAutoExamine then
                nextBtn:StartAutoExamine()
            end
            -- следующий старт только после завершения текущего + крошечная пауза
            phaseUntil = CurTime() + 0.05
        end

        -- Hint bar
        local hint = vgui.Create("DLabel", frame)
        hint:SetPos(pad, frameH - 28)
        hint:SetSize(frameW - pad * 2, 18)
        if phase == "reveal" then
            hint:SetText(string.format("Авто-обыск: %d предметов открываются сами...", pending))
        else
            hint:SetText("ЛКМ справа — взять  ·  ЛКМ слева — положить в контейнер")
        end
        hint:SetTextColor(Color(80, 82, 88))
        hint:SetContentAlignment(4)
    end

    -- ==========================================
    -- ОКНО ИНВЕНТАРЯ И РАЗГРУЗКИ
    -- ==========================================
    local function CreateEquipSlot(parent, x, label, itemID, slotName)
        local slot = vgui.Create("DPanel", parent)
        slot:SetPos(x, 0); slot:SetSize(90, 85)

        local itemData = itemID ~= "" and EFT.ItemDatabase[itemID] or nil
        local rarity = itemData and GetRarityInfo(itemData) or nil

        slot.Paint = function(self, w, h)
            draw.RoundedBox(4, 0, 0, w, h, COLOR_PANEL_BG)
            surface.SetDrawColor(rarity and rarity.color or Color(50, 50, 50))
            surface.DrawOutlinedRect(0, 0, w, h)
            draw.SimpleText(label, "DermaDefault", w / 2, 4, COLOR_TEXT_DIM, TEXT_ALIGN_CENTER)
            if not itemData then
                draw.SimpleText("Пусто", "DermaDefault", w / 2, h / 2, Color(80, 80, 80), TEXT_ALIGN_CENTER)
            end
        end

        if itemData then
            AttachModelIcon(slot, itemData.model, 36, (90 - 36) / 2)
            local nameLbl = vgui.Create("DLabel", slot)
            nameLbl:SetText(itemData.name); nameLbl:SetFont("DermaDefault"); nameLbl:SetTextColor(COLOR_TEXT)
            nameLbl:SetContentAlignment(5); nameLbl:SetPos(0, 50); nameLbl:SetSize(90, 14)

            local unequipBtn = vgui.Create("DButton", slot)
            unequipBtn:SetText("Снять"); unequipBtn:SetPos(10, 66); unequipBtn:SetSize(70, 14)
            unequipBtn.Paint = function(self, w, h)
                draw.RoundedBox(2, 0, 0, w, h, self:IsHovered() and COLOR_ACCENT or Color(40, 42, 44))
            end
            unequipBtn:SetTextColor(COLOR_TEXT)
            unequipBtn.DoClick = function()
                net.Start("EFT_UnequipItem")
                    net.WriteString(slotName)
                net.SendToServer()
            end
        end
        return slot
    end

    local function OpenPersonalInventory(...)
        if ZCityEFTEmptyInventory then ZCityEFTEmptyInventory.Open(true) end
    end

    local function OpenShopFrame(items, money)
        if IsValid(shopFrame) then shopFrame:Close() end
        local frame = vgui.Create("DFrame")
        frame:SetSize(500, 580); frame:SetTitle(""); frame:Center(); frame:MakePopup(); frame:ShowCloseButton(false)
        frame.Paint = function(self, w, h)
            Derma_DrawBackgroundBlur(self, self.m_fCreateTime)
            -- тёмный фон + оранжевая обводка как у остальных EFT-GUI
            draw.RoundedBox(0, 0, 0, w, h, Color(12, 12, 11, 250))
            surface.SetDrawColor(220, 110, 30)
            surface.DrawOutlinedRect(0, 0, w, h, 2)
            draw.RoundedBox(0, 0, 0, w, 50, Color(10, 11, 12, 255))
            surface.SetDrawColor(220, 110, 30)
            surface.DrawRect(0, 48, w, 2)
            draw.SimpleText("ОДЕССА — ПРОДАЖА", "DermaDefaultBold", 20, 16, Color(235, 180, 40))

            local moneyW = 110
            local moneyX = w - 50 - 10 - moneyW
            local moneyY = 10
            draw.RoundedBox(4, moneyX, moneyY, moneyW, 30, Color(28, 22, 14, 255))
            surface.SetDrawColor(220, 110, 30)
            surface.DrawOutlinedRect(moneyX, moneyY, moneyW, 30)
            draw.SimpleText(money .. "₽", "DermaDefaultBold", moneyX + moneyW / 2, moneyY + 15, Color(235, 180, 40), TEXT_ALIGN_CENTER, TEXT_ALIGN_CENTER)
        end
        frame.OnRemove = function() RemoveItemTooltip() end
        shopFrame = frame
        MakeCloseButton(frame).DoClick = function() frame:Close() end

        local scroll = vgui.Create("DScrollPanel", frame)
        scroll:SetPos(16, 60); scroll:SetSize(468, 500)
        local sbar = scroll:GetVBar()
        if IsValid(sbar) then
            sbar.Paint = function(s, w, h) draw.RoundedBox(0, 0, 0, w, h, Color(20, 18, 14)) end
            sbar.btnGrip.Paint = function(s, w, h) draw.RoundedBox(2, 2, 0, w-4, h, Color(220, 110, 30, 200)) end
            sbar.btnUp.Paint = function() end
            sbar.btnDown.Paint = function() end
        end

        local hasItems = false
        for itemID, count in pairs(items) do
            local itemData = EFT.ItemDatabase[itemID]
            if not itemData or not itemData.price then continue end
            hasItems = true
            local rarity = GetRarityInfo(itemData)

            local row = scroll:Add("DPanel")
            row:Dock(TOP); row:SetHeight(74); row:DockMargin(0, 0, 6, 8)
            row.Paint = function(self, w, h)
                local hv = self:IsHovered()
                draw.RoundedBox(4, 0, 0, w, h, hv and Color(32, 26, 18) or Color(22, 20, 16))
                draw.RoundedBox(0, 0, 0, 4, h, rarity.color)
                surface.SetDrawColor(220, 110, 30, hv and 220 or 100)
                surface.DrawOutlinedRect(0, 0, w, h)
                draw.SimpleText(itemData.name, "DermaDefaultBold", 80, 10, Color(245, 240, 230))
                draw.SimpleText("x" .. count, "DermaDefault", 80, 30, Color(160, 150, 130))
                draw.SimpleText("Цена: от " .. itemData.price .. "₽ за шт.", "DermaDefault", 80, 48, Color(235, 180, 40))
            end
            AttachModelIcon(row, itemData.model, 60, 5)

            local sellBtn = vgui.Create("DButton", row)
            sellBtn:SetText("Продать"); sellBtn:SetSize(96, 28)
            sellBtn.Paint = function(self, w, h)
                local hv = self:IsHovered()
                draw.RoundedBox(3, 0, 0, w, h, hv and Color(220, 110, 30) or Color(48, 32, 16))
                surface.SetDrawColor(220, 110, 30)
                surface.DrawOutlinedRect(0, 0, w, h)
            end
            sellBtn:SetTextColor(Color(245, 240, 230))
            sellBtn.DoClick = function()
                net.Start("EFT_SellItem")
                    net.WriteString(itemID)
                net.SendToServer()
            end

            row.PerformLayout = function(self, w, h)
                sellBtn:SetPos(w - 12 - sellBtn:GetWide(), (h - sellBtn:GetTall()) / 2)
            end
        end

        if not hasItems then
            local emptyLabel = scroll:Add("DLabel")
            emptyLabel:SetText("Нечего продать — принесите предметы с ценой")
            emptyLabel:SetFont("DermaDefaultBold"); emptyLabel:SetTextColor(Color(180, 140, 80))
            emptyLabel:SizeToContents(); emptyLabel:Dock(TOP); emptyLabel:DockMargin(60, 180, 0, 0)
        end
    end

    -- Окно продавца оружия
    local function OpenWeaponShopFrame(items, money)
        if IsValid(shopFrame) then shopFrame:Close() end
        local frame = vgui.Create("DFrame")
        frame:SetSize(480, 560); frame:SetTitle(""); frame:Center(); frame:MakePopup(); frame:ShowCloseButton(false)
        frame.Paint = function(self, w, h)
            Derma_DrawBackgroundBlur(self, self.m_fCreateTime)
            draw.RoundedBox(0, 0, 0, w, h, Color(15, 17, 18, 245))
            draw.RoundedBox(0, 0, 0, w, 50, Color(10, 11, 12, 255))
            draw.RoundedBox(0, 0, 48, w, 2, Color(220, 110, 30, 255))
            draw.SimpleText("ТОРГОВЕЦ ОРУЖИЕМ", "DermaDefaultBold", 20, 16, COLOR_TEXT)

            local moneyW = 100
            local moneyX = w - 50 - 10 - moneyW
            local moneyY = 10
            draw.RoundedBox(4, moneyX, moneyY, moneyW, 30, Color(30, 32, 34, 255))
            surface.SetDrawColor(220, 110, 30, 120)
            surface.DrawOutlinedRect(moneyX, moneyY, moneyW, 30)
            draw.SimpleText(money .. "₽", "DermaDefaultBold", moneyX + moneyW / 2, moneyY + 15, COLOR_WARN, TEXT_ALIGN_CENTER, TEXT_ALIGN_CENTER)
        end
        frame.OnRemove = function() RemoveItemTooltip() end
        shopFrame = frame
        MakeCloseButton(frame).DoClick = function() frame:Close() end

        local scroll = vgui.Create("DScrollPanel", frame)
        scroll:SetPos(20, 60); scroll:SetSize(440, 480)

        local hasItems = false
        for itemID in pairs(items) do
            local itemData = EFT.ItemDatabase[itemID]
            if not itemData or not itemData.buyPrice then continue end
            hasItems = true
            local rarity = GetRarityInfo(itemData)

            local row = scroll:Add("DPanel")
            row:Dock(TOP); row:SetHeight(70); row:DockMargin(0, 0, 5, 8)
            row.Paint = function(self, w, h)
                draw.RoundedBox(4, 0, 0, w, h, COLOR_PANEL_BG)
                draw.RoundedBox(0, 0, 0, 3, h, rarity.color)
                surface.SetDrawColor(50, 50, 50)
                surface.DrawOutlinedRect(0, 0, w, h)
                draw.SimpleText(itemData.name, "DermaDefaultBold", 80, 10, COLOR_TEXT)
                draw.SimpleText(itemData.ammoType or "", "DermaDefault", 80, 30, COLOR_TEXT_DIM)
                draw.SimpleText("Цена: " .. itemData.buyPrice .. "₽", "DermaDefault", 80, 48, COLOR_WARN)
            end
            AttachModelIcon(row, itemData.model, 60, 5)

            local buyBtn = vgui.Create("DButton", row)
            buyBtn:SetText("Купить"); buyBtn:SetSize(90, 26)
            buyBtn.Paint = function(self, w, h)
                draw.RoundedBox(3, 0, 0, w, h, self:IsHovered() and COLOR_ACCENT or Color(40, 42, 44))
                surface.SetDrawColor(80, 80, 80)
                surface.DrawOutlinedRect(0, 0, w, h)
            end
            buyBtn:SetTextColor(COLOR_TEXT)
            buyBtn.DoClick = function()
                net.Start("EFT_BuyWeapon")
                    net.WriteString(itemID)
                net.SendToServer()
            end

            row.PerformLayout = function(self, w, h)
                buyBtn:SetPos(w - 10 - buyBtn:GetWide(), (h - buyBtn:GetTall()) / 2)
            end
        end

        if not hasItems then
            local emptyLabel = scroll:Add("DLabel")
            emptyLabel:SetText("Товара нет в наличии")
            emptyLabel:SetFont("DermaDefaultBold"); emptyLabel:SetTextColor(Color(100, 100, 100))
            emptyLabel:SizeToContents(); emptyLabel:Dock(TOP); emptyLabel:DockMargin(90, 200, 0, 0)
        end
    end
    local function OpenMedicineFrame(limbHealth, medItems)
        if IsValid(medicineFrame) then medicineFrame:Close() end

        local frame = vgui.Create("DFrame")
        frame:SetSize(460, 560); frame:SetTitle(""); frame:MakePopup(); frame:ShowCloseButton(false)

        -- Пристыковываем окно медицины к окну инвентаря (если оно открыто рядом),
        -- чтобы оба окна образовывали единый блок в левом верхнем углу экрана.
        if IsValid(inventoryFrame) then
            frame:SetPos(inventoryFrame:GetX() + inventoryFrame:GetWide() + 10, inventoryFrame:GetY())
        else
            frame:SetPos(20, 20)
        end

        frame.Paint = function(self, w, h)
            Derma_DrawBackgroundBlur(self, self.m_fCreateTime)
            draw.RoundedBox(0, 0, 0, w, h, Color(15, 17, 18, 245))
            draw.RoundedBox(0, 0, 0, w, 50, Color(10, 11, 12, 255))
            draw.RoundedBox(0, 0, 48, w, 2, Color(220, 110, 30, 255))
            draw.SimpleText("СОСТОЯНИЕ ЗДОРОВЬЯ", "DermaDefaultBold", 20, 16, COLOR_TEXT)
        end
        frame.OnRemove = function() RemoveItemTooltip() end
        medicineFrame = frame
        MakeCloseButton(frame).DoClick = function() frame:Close() end

        local selectedMedItem = nil
        local hint = vgui.Create("DLabel", frame)
        hint:SetText("Выберите препарат внизу, затем нажмите на зону тела, чтобы применить.")
        hint:SetFont("DermaDefault"); hint:SetTextColor(COLOR_TEXT_DIM)
        hint:SetPos(20, 60); hint:SetSize(420, 16)

        local function LimbBar(x, y, w, limbKey)
            local cur = limbHealth[limbKey] or 0
            local max = EFT.Config.LimbMaxHealth[limbKey] or 1
            local ratio = math.Clamp(cur / max, 0, 1)

            local panel = vgui.Create("DButton", frame)
            panel:SetPos(x, y); panel:SetSize(w, 40); panel:SetText("")
            panel.Paint = function(self, pw, ph)
                local barColor = COLOR_GOOD
                if ratio < 0.3 then barColor = COLOR_BAD elseif ratio < 0.6 then barColor = COLOR_WARN end

                draw.RoundedBox(2, 0, 0, pw, 14, COLOR_PANEL_BG)
                draw.SimpleText(EFT.Config.LimbLabels[limbKey], "DermaDefault", 2, 0, COLOR_TEXT_DIM)

                draw.RoundedBox(2, 0, 16, pw, 16, Color(28, 30, 32))
                draw.RoundedBox(2, 0, 16, pw * ratio, 16, barColor)
                draw.SimpleText(math.floor(cur) .. "/" .. max, "DermaDefaultBold", pw / 2, 24, COLOR_TEXT, TEXT_ALIGN_CENTER, TEXT_ALIGN_CENTER)

                if selectedMedItem and self:IsHovered() then
                    surface.SetDrawColor(COLOR_ACCENT)
                    surface.DrawOutlinedRect(0, 14, pw, 18)
                end
            end
            panel.DoClick = function()
                if not selectedMedItem then return end
                net.Start("EFT_ApplyMedicine")
                    net.WriteString(selectedMedItem)
                    net.WriteString(limbKey)
                net.SendToServer()
            end
        end

        LimbBar(160, 90, 140, "head")
        LimbBar(160, 140, 140, "thorax")
        LimbBar(20, 190, 130, "rightarm")
        LimbBar(160, 190, 140, "stomach")
        LimbBar(310, 190, 130, "leftarm")
        LimbBar(60, 250, 150, "rightleg")
        LimbBar(250, 250, 150, "leftleg")

        local medLabel = vgui.Create("DLabel", frame)
        medLabel:SetText("ПРЕПАРАТЫ"); medLabel:SetFont("DermaDefaultBold"); medLabel:SetTextColor(COLOR_TEXT_DIM)
        medLabel:SetPos(20, 310); medLabel:SetSize(200, 20)

        local medScroll = vgui.Create("DScrollPanel", frame)
        medScroll:SetPos(20, 335); medScroll:SetSize(420, 200)

        local hasMed = false
        for itemID, count in pairs(medItems) do
            local itemData = EFT.ItemDatabase[itemID]
            if not itemData then continue end
            hasMed = true

            local row = medScroll:Add("DButton")
            row:SetText(""); row:Dock(TOP); row:SetHeight(60); row:DockMargin(0, 0, 5, 8)
            row.Paint = function(self, w, h)
                local selected = selectedMedItem == itemID
                draw.RoundedBox(4, 0, 0, w, h, selected and Color(60, 40, 20) or COLOR_PANEL_BG)
                surface.SetDrawColor(selected and COLOR_ACCENT or Color(50, 50, 50))
                surface.DrawOutlinedRect(0, 0, w, h)
                draw.SimpleText(itemData.name .. " (x" .. count .. ")", "DermaDefaultBold", 70, 10, COLOR_TEXT)
                draw.SimpleText("Применение: +" .. (itemData.healAmount or 30), "DermaDefault", 70, 32, COLOR_GOOD)
            end
            AttachModelIcon(row, itemData.model, 50, 5)
            row.DoClick = function() selectedMedItem = itemID end
        end

        if not hasMed then
            local emptyLabel = medScroll:Add("DLabel")
            emptyLabel:SetText("Нет медицинских препаратов")
            emptyLabel:SetFont("DermaDefaultBold"); emptyLabel:SetTextColor(Color(100, 100, 100))
            emptyLabel:SizeToContents(); emptyLabel:Dock(TOP); emptyLabel:DockMargin(100, 40, 0, 0)
        end
    end

    -- ==========================================
    -- УЛЬТРА-СОВРЕМЕННЫЙ ИНТЕРФЕЙС ВЕРСТАКА (КРАФТ)
    -- ==========================================
    local function OpenWorkbenchFrame(playerMaterials)
        if IsValid(workbenchFrame) then workbenchFrame:Close() end

        local frame = vgui.Create("DFrame")
        frame:SetSize(820, 580)
        frame:Center()
        frame:MakePopup()
        frame:SetTitle("")
        frame:ShowCloseButton(false)
        workbenchFrame = frame

        local selectedRecipe = nil
        local selectedRecipeIndex = nil
        local craftProgress = 0
        local isCrafting = false
        local toolSound = nil

        frame.Paint = function(self, w, h)
            Derma_DrawBackgroundBlur(self, self.m_fCreateTime)
            -- Фоновая панель
            draw.RoundedBox(0, 0, 0, w, h, Color(15, 17, 18, 245))
            draw.RoundedBox(0, 0, 0, w, 50, Color(10, 11, 12, 255))
            draw.RoundedBox(0, 0, 48, w, 2, COLOR_ACCENT)

            draw.SimpleText("ВЕРСТАК ОБОРУДОВАНИЯ", "DermaDefaultBold", 20, 16, COLOR_TEXT)
            draw.SimpleText("Модуль сборки снаряжения v2.4", "DermaDefault", 200, 18, COLOR_TEXT_DIM)

            -- Тонкая рамка разделения
            surface.SetDrawColor(32, 34, 36)
            surface.DrawLine(320, 50, 320, h)
        end

        MakeCloseButton(frame).DoClick = function()
            if toolSound then toolSound:Stop() end
            frame:Close()
        end

        -- Левая колонка: Категории и Рецепты
        local listScroll = vgui.Create("DScrollPanel", frame)
        listScroll:SetPos(15, 60)
        listScroll:SetSize(290, 500)

        -- Правая детальная панель рецепта
        local detailPanel = vgui.Create("DPanel", frame)
        detailPanel:SetPos(335, 60)
        detailPanel:SetSize(470, 500)
        detailPanel.Paint = function(self, w, h)
            if not selectedRecipe then
                draw.SimpleText("Выберите рецепт слева, чтобы начать крафт", "DermaDefaultBold", w/2, h/2, COLOR_TEXT_DIM, TEXT_ALIGN_CENTER)
                return
            end

            local resultItem = EFT.ItemDatabase[selectedRecipe.resultID]
            if not resultItem then return end

            -- Рисуем название выбранного рецепта
            draw.SimpleText(selectedRecipe.name, "DermaDefaultBold", 10, 10, COLOR_TEXT)
            draw.SimpleText("Категория: " .. (EFT.CategoryLabels[selectedRecipe.category] or selectedRecipe.category), "DermaDefault", 10, 28, COLOR_TEXT_DIM)
            
            -- Отрисовываем горизонтальный разделитель
            surface.SetDrawColor(48, 50, 52)
            surface.DrawLine(10, 48, w - 10, 48)

            -- Характеристики собираемого предмета
            draw.SimpleText("Вес готового изделия: " .. resultItem.weight .. " кг", "DermaDefault", 10, 160, COLOR_TEXT_DIM)
            draw.SimpleText("Размер готовой сетки: " .. resultItem.w .. "x" .. resultItem.h, "DermaDefaultBold", 10, 176, COLOR_TEXT_DIM)

            -- Заголовок компонентов
            draw.SimpleText("НЕОБХОДИМЫЕ РЕСУРСЫ ДЛЯ СБОРКИ:", "DermaDefaultBold", 10, 205, COLOR_ACCENT)
        end

        local recipeButtons = {}

        local function UpdateDetailView()
            detailPanel:Clear()
            if not selectedRecipe then return end

            local resultItem = EFT.ItemDatabase[selectedRecipe.resultID]
            if not resultItem then return end

            -- Иконка результата
            local iconPanel = vgui.Create("DPanel", detailPanel)
            iconPanel:SetPos(10, 60)
            iconPanel:SetSize(90, 85)
            iconPanel.Paint = function(self, w, h)
                draw.RoundedBox(4, 0, 0, w, h, COLOR_PANEL_BG)
                surface.SetDrawColor(COLOR_ACCENT)
                surface.DrawOutlinedRect(0, 0, w, h)
            end
            AttachModelIcon(iconPanel, resultItem.model, 65, 12)

            -- Описание результата
            local descLabel = vgui.Create("DLabel", detailPanel)
            descLabel:SetPos(115, 60)
            descLabel:SetSize(340, 85)
            descLabel:SetText(resultItem.desc)
            descLabel:SetFont("DermaDefault")
            descLabel:SetTextColor(COLOR_TEXT_DIM)
            descLabel:SetWrap(true)
            descLabel:SetContentAlignment(7)

            -- Скролл панель для ингредиентов
            local ingScroll = vgui.Create("DScrollPanel", detailPanel)
            ingScroll:SetPos(10, 230)
            ingScroll:SetSize(450, 180)

            local craftable = true
            local missingTool = false

            -- Требуемый инструмент (не расходуется)
            local reqTool = selectedRecipe.requiredTool
            if not reqTool and EFT.GetRecipeRequiredTool then
                reqTool = EFT.GetRecipeRequiredTool(selectedRecipe)
            end
            if reqTool then
                local toolData = EFT.ItemDatabase[reqTool]
                local haveTool = (playerMaterials[reqTool] or 0) >= 1
                if not haveTool then
                    craftable = false
                    missingTool = true
                end
                local toolRow = ingScroll:Add("DPanel")
                toolRow:Dock(TOP)
                toolRow:SetHeight(42)
                toolRow:DockMargin(0, 0, 5, 5)
                toolRow.Paint = function(self, w, h)
                    draw.RoundedBox(4, 0, 0, w, h, Color(28, 26, 18, 255))
                    surface.SetDrawColor(haveTool and Color(100, 180, 90) or Color(200, 80, 70))
                    surface.DrawOutlinedRect(0, 0, w, h)
                    local tname = (toolData and toolData.name) or reqTool
                    draw.SimpleText("🔧 " .. tname, "DermaDefaultBold", 45, 6, COLOR_TEXT)
                    draw.SimpleText(haveTool and "ЕСТЬ (не расходуется)" or "НЕТ В ИНВЕНТАРЕ", "DermaDefault", 45, 22, haveTool and COLOR_GOOD or COLOR_BAD)
                    draw.SimpleText(haveTool and "1 / 1" or "0 / 1", "DermaDefaultBold", w - 15, 13, haveTool and COLOR_GOOD or COLOR_BAD, TEXT_ALIGN_RIGHT)
                end
                if toolData then AttachModelIcon(toolRow, toolData.model, 32, 5) end
            end

            -- Рендерим ингредиенты в списке
            for _, ing in ipairs(selectedRecipe.ingredients) do
                local ingData = EFT.ItemDatabase[ing.id]
                if ingData then
                    local currentAmount = playerMaterials[ing.id] or 0
                    local neededAmount = ing.count
                    local color = (currentAmount >= neededAmount) and COLOR_GOOD or COLOR_BAD
                    if currentAmount < neededAmount then craftable = false end

                    local ingRow = ingScroll:Add("DPanel")
                    ingRow:Dock(TOP)
                    ingRow:SetHeight(42)
                    ingRow:DockMargin(0, 0, 5, 5)
                    ingRow.Paint = function(self, w, h)
                        draw.RoundedBox(4, 0, 0, w, h, Color(22, 24, 25, 255))
                        surface.SetDrawColor(38, 40, 42)
                        surface.DrawOutlinedRect(0, 0, w, h)

                        draw.SimpleText(ingData.name, "DermaDefaultBold", 45, 13, COLOR_TEXT)
                        draw.SimpleText(currentAmount .. " / " .. neededAmount, "DermaDefaultBold", w - 15, 13, color, TEXT_ALIGN_RIGHT)
                    end
                    AttachModelIcon(ingRow, ingData.model, 32, 5)
                end
            end

            -- Шкала Прогресса крафта
            local progressBar = vgui.Create("DPanel", detailPanel)
            progressBar:SetPos(10, 420)
            progressBar:SetSize(450, 24)
            progressBar.Paint = function(self, w, h)
                if not isCrafting then return end
                draw.RoundedBox(3, 0, 0, w, h, Color(28, 30, 32))
                draw.RoundedBox(3, 0, 0, w * craftProgress, h, COLOR_ACCENT)
                draw.SimpleText("Идет сборка изделия... " .. math.floor(craftProgress * 100) .. "%", "DermaDefaultBold", w/2, h/2, COLOR_TEXT, TEXT_ALIGN_CENTER, TEXT_ALIGN_CENTER)
            end

            -- Кнопка Крафта
            local craftBtn = vgui.Create("DButton", detailPanel)
            craftBtn:SetPos(10, 455)
            craftBtn:SetSize(450, 35)
            craftBtn:SetText("")
            craftBtn.Paint = function(self, w, h)
                local hover = self:IsHovered()
                local btnColor = craftable and (hover and Color(240, 130, 40) or COLOR_ACCENT) or Color(36, 38, 40)
                draw.RoundedBox(4, 0, 0, w, h, btnColor)
                
                local text
                if isCrafting then
                    text = "СБОРКА..."
                elseif craftable then
                    text = "НАЧАТЬ СБОРКУ"
                elseif missingTool then
                    text = "НЕТ ИНСТРУМЕНТА"
                else
                    text = "НЕДОСТАТОЧНО РЕСУРСОВ"
                end
                local textColor = craftable and Color(20,20,20) or COLOR_TEXT_DIM
                draw.SimpleText(text, "DermaDefaultBold", w/2, h/2, textColor, TEXT_ALIGN_CENTER, TEXT_ALIGN_CENTER)
            end

            craftBtn.Think = function(self)
                if not isCrafting then return end
                craftProgress = craftProgress + FrameTime() * EFT.Config.CraftSpeed
                if craftProgress >= 1 then
                    isCrafting = false
                    craftProgress = 0
                    if toolSound then toolSound:Stop() end
                    net.Start("EFT_CraftItem")
                        net.WriteUInt(selectedRecipeIndex, 8)
                    net.SendToServer()
                end
            end

            craftBtn.DoClick = function()
                if not craftable or isCrafting then return end
                isCrafting = true
                craftProgress = 0
                
                -- Рандомные звуки работы инструментов
                local tools = { "ambient/machines/giggle.wav", "ambient/machines/drill_loop1.wav" }
                toolSound = CreateSound(LocalPlayer(), table.Random(tools))
                toolSound:PlayEx(0.6, 100)
            end
        end

        -- Заполняем рецептами левую колонку
        for idx, recipe in ipairs(EFT.Recipes) do
            local btn = listScroll:Add("DButton")
            btn:SetText("")
            btn:Dock(TOP)
            btn:SetHeight(50)
            btn:DockMargin(0, 0, 5, 6)

            local itemData = EFT.ItemDatabase[recipe.resultID]

            btn.Paint = function(self, w, h)
                local hover = self:IsHovered()
                local active = selectedRecipe == recipe
                local bg = active and Color(60, 40, 20) or (hover and Color(32, 34, 36) or COLOR_PANEL_BG)

                draw.RoundedBox(4, 0, 0, w, h, bg)
                surface.SetDrawColor(active and COLOR_ACCENT or Color(48, 50, 52))
                surface.DrawOutlinedRect(0, 0, w, h)

                draw.SimpleText(recipe.name, "DermaDefaultBold", 55, 10, COLOR_TEXT)
                local sub = "Категория: " .. (EFT.CategoryLabels[recipe.category] or recipe.category)
                draw.SimpleText(sub, "DermaDefault", 55, 28, COLOR_TEXT_DIM)
            end

            if itemData then
                AttachModelIcon(btn, itemData.model, 42, 5)
            end

            btn.DoClick = function()
                if isCrafting then return end
                selectedRecipe = recipe
                selectedRecipeIndex = idx
                UpdateDetailView()
            end

            table.insert(recipeButtons, btn)
        end
    end

    net.Receive("EFT_OpenWorkbench", function()
        local playerMaterials = net.ReadTable()
        OpenWorkbenchFrame(playerMaterials)
    end)

    net.Receive("EFT_OpenLoot", function()
        activeContainerEnt = net.ReadEntity()
        local containerLoot = net.ReadTable() or {}
        local playerInv = net.ReadTable() or {}
        activeCorpseOwner = net.ReadString() or ""
        local gridW, gridH = net.ReadUInt(8), net.ReadUInt(8)
        local personalItems = net.ReadTable() or {}
        local pW, pH = net.ReadUInt(8), net.ReadUInt(8)
        local rigItems = net.ReadTable() or {}
        local rW, rH = net.ReadUInt(8), net.ReadUInt(8)
        local bpItems = net.ReadTable() or {}
        local bW, bH = net.ReadUInt(8), net.ReadUInt(8)
        for _, it in ipairs(containerLoot) do
            if it.examined == nil then it.examined = false end
        end
        if ZCityEFTEmptyInventory and ZCityEFTEmptyInventory.ReceiveLoot then
            ZCityEFTEmptyInventory.ReceiveLoot({entity=activeContainerEnt, items=containerLoot, w=gridW, h=gridH,
                name=activeCorpseOwner ~= "" and activeCorpseOwner or "ЯЩИК"})
        end
    end)

    net.Receive("EFT_OpenInventory", function()
        -- swallow old inventory open (reads all fields so buffer is clean)
        net.ReadTable(); net.ReadTable(); net.ReadTable()
        net.ReadString(); net.ReadString(); net.ReadString(); net.ReadString(); net.ReadString(); net.ReadString()
        net.ReadInt(32); net.ReadFloat(); net.ReadFloat()
        net.ReadUInt(8); net.ReadUInt(8); net.ReadUInt(8); net.ReadUInt(8); net.ReadUInt(8); net.ReadUInt(8)
        -- do NOT open old UI — user uses Desk (I key)
        if IsValid(inventoryFrame) then inventoryFrame:Close() end
    end)

    net.Receive("EFT_OpenShop", function()
        local items = net.ReadTable()
        local money = net.ReadInt(32)
        OpenShopFrame(items, money)
    end)

    net.Receive("EFT_OpenWeaponShop", function()
        local items = net.ReadTable()
        local money = net.ReadInt(32)
        OpenWeaponShopFrame(items, money)
    end)

    net.Receive("EFT_OpenMedicine", function()
        net.ReadTable(); net.ReadTable()
        if IsValid(medicineFrame) then medicineFrame:Close() end
        -- medicine is inside Desk
    end)

    -- Клавиши UI (KEY_I, KEY_H, KEY_R, KEY_DELETE)
    local wasIKeyDown = false
-- DISABLED: old inventory+medicine double-open. Desk handles I key.
hook.Add("Think", "EFT_LootSystem_InventoryKeybind", function()
    -- intentionally empty — prevents double inventory with EFT_Complete_I
end)

    -- DISABLED old H medicine (Desk has combined medicine)
    local wasHKeyDown = false
    hook.Add("Think", "EFT_LootSystem_MedicineKeybind", function() end)

    local wasRKeyDown = false
    hook.Add("Think", "EFT_LootSystem_RotateKeybind", function()
        local down = input.IsKeyDown(KEY_R)
        if down and not wasRKeyDown and hoveredGridItem then
            net.Start("EFT_RotateItem")
                net.WriteString(hoveredGridItem)
            net.SendToServer()
        end
        wasRKeyDown = down
    end)

    local wasDeleteKeyDown = false
    hook.Add("Think", "EFT_LootSystem_DeleteKeybind", function()
        local down = input.IsKeyDown(KEY_DELETE)
        if down and not wasDeleteKeyDown and hoveredGridItem then
            net.Start("EFT_DropItem")
                net.WriteString(tostring(hoveredGridItem))
            net.SendToServer()
            timer.Simple(0.2, function()
                net.Start("EFT_RequestExtended") net.SendToServer()
            end)
        end
        wasDeleteKeyDown = down
    end)
end


--################################################################################
--#  EFT COMPLETE UNIFIED LAYER  (all systems in one file)
--#  Persistence · Secure · Stash · Insurance · Raid · Attachments · NPC Loot · UI
--################################################################################

EFT.Improvements = EFT.Improvements or { version = "12.0-complete" }

EFT.Config.SecureContainer = EFT.Config.SecureContainer or { Enabled = true, GridW = 2, GridH = 2, MaxWeight = 3.0 }
EFT.Config.Stash = EFT.Config.Stash or { Enabled = true, GridW = 10, GridH = 14 }
EFT.Config.Insurance = EFT.Config.Insurance or { Enabled = true, FeePercent = 0.15, MinFee = 50, ReturnMinutes = 20 }
EFT.Config.Persistence = EFT.Config.Persistence or { Enabled = true, SaveInterval = 45, Folder = "eft_saves" }
EFT.Config.WeightSlowdown = EFT.Config.WeightSlowdown or { Enabled = true, SoftStart = 0.70, MaxPenalty = 0.45 }
EFT.Config.QuickMed = EFT.Config.QuickMed or { Enabled = true, Key = KEY_Q }
EFT.Config.Locker = EFT.Config.Locker or {
    Model = "models/props_wasteland/controlroom_storagecloset001a.mdl", SearchTime = 1.2, UseDistance = 100, NoiseRadius = 500,
}
EFT.Config.Raid = EFT.Config.Raid or {
    GateWaitMin = 8, GateWaitMax = 12, ExtractWaitMin = 10, ExtractWaitMax = 15, UseDistance = 140, DogtagMoney = 150,
}
EFT.Config.TarkovLoot = EFT.Config.TarkovLoot or {
    NPCLootEnabled = true, NPCWeaponChance = 0.55, NPCArmorChance = 0.35, NPCExtraMin = 2, NPCExtraMax = 6,
}
EFT.Config.SearchSpeed = EFT.Config.SearchSpeed or 0.45

-- Ensure attachments in DB
EFT.ItemDatabase = EFT.ItemDatabase or {}
local function EnsureAtt(id, def)
    if not EFT.ItemDatabase[id] then EFT.ItemDatabase[id] = def
    else EFT.ItemDatabase[id].type = EFT.ItemDatabase[id].type or "attachment" end
end
EnsureAtt("ent_att_supressor6", { name="Самодельный глушитель", w=1,h=2,rarity="common",weight=0.3,price=900,desc="",model="models/atts/homemadesuppressor/plastic_bottle_1.mdl",type="attachment" })
EnsureAtt("ent_att_supressor4", { name="Глушитель 9mm", w=1,h=2,rarity="uncommon",weight=0.4,price=6200,desc="",model="models/cw2/attachments/9mmsuppressor.mdl",type="attachment" })
EnsureAtt("ent_att_supressor1", { name="Глушитель АК", w=1,h=2,rarity="uncommon",weight=0.55,price=7000,desc="",model="models/weapons/upgrades/a_suppressor_ak.mdl",type="attachment" })
EnsureAtt("ent_att_holo5", { name="Прицел ЕКП-7", w=1,h=1,rarity="rare",weight=0.3,price=8800,desc="",model="models/weapons/arc9/darsu_eft/mods/scope_all_ekb_okp7.mdl",type="attachment" })
EnsureAtt("ent_att_laser3", { name="ЛЦУ", w=1,h=1,rarity="uncommon",weight=0.15,price=4500,desc="",model="models/weapons/w_eq_laser_slim.mdl",type="attachment" })

EFT.Recipes = EFT.Recipes or {}
do
    local has = false
    for _, r in ipairs(EFT.Recipes) do if r.resultID == "ent_att_laser3" then has = true break end end
    if not has then
        table.insert(EFT.Recipes, {
            name = "Обвес: ЛЦУ", category = "attachment", resultID = "ent_att_laser3", resultCount = 1,
            ingredients = { {id="mat_electronics",count=3},{id="mat_scrap_metal",count=2},{id="mat_plastic",count=1} },
        })
    end
end

if not EFT.Grid.CanFit then
    function EFT.Grid.CanFit(items, itemID, itemData, gridW, gridH, x, y, w, h, excludeUniqueID)
        return EFT.Grid.CanPlaceAt(items, x, y, w or itemData.w, h or itemData.h, gridW, gridH, excludeUniqueID)
    end
end

local function Sid(ply)
    if not IsValid(ply) then return nil end
    return ply:IsBot() and ("BOT_" .. ply:EntIndex()) or (ply:SteamID64() or tostring(ply:UniqueID()))
end

-- ============================================================================
-- DROP ENTITY
-- ============================================================================
do
    local ENT = {}
    ENT.Type, ENT.Base = "anim", "base_gmodentity"
    ENT.PrintName, ENT.Spawnable, ENT.Category = "EFT Dropped Item", false, "EFT"
    function ENT:SetupDataTables()
        self:NetworkVar("String", 0, "ItemID")
        self:NetworkVar("String", 1, "ItemUID")
        self:NetworkVar("Int", 0, "ItemCount")
        self:NetworkVar("Int", 1, "ItemHP")
        self:NetworkVar("Int", 2, "ItemUses")
        self:NetworkVar("Bool", 0, "ItemFIR")
        self:NetworkVar("Bool", 1, "ItemInsured")
    end
    function ENT:Initialize()
        local id = (self.GetItemID and self:GetItemID()) or self.EFT_ItemID or ""
        local db = EFT.ItemDatabase[id]
        local mdl = (db and db.model and db.model ~= "" and db.model) or "models/props_junk/cardboard_box001a.mdl"
        pcall(function() self:SetModel(mdl) end)
        self:PhysicsInit(SOLID_VPHYSICS)
        self:SetMoveType(MOVETYPE_VPHYSICS)
        self:SetSolid(SOLID_VPHYSICS)
        self:SetUseType(SIMPLE_USE)
        self:SetCollisionGroup(COLLISION_GROUP_WEAPON)
        local phys = self:GetPhysicsObject()
        if IsValid(phys) then phys:Wake() phys:SetMass(math.max(1, (db and db.weight or 1) * 5)) end
        if SERVER then timer.Simple(600, function() if IsValid(self) then self:Remove() end end) end
    end
    function ENT:Use(act, caller)
        if not SERVER then return end
        local ply = IsValid(caller) and caller or act
        if not IsValid(ply) or not ply:IsPlayer() or not ply:Alive() then return end
        if ply:GetPos():DistToSqr(self:GetPos()) > 20000 then return end
        local id = (self.GetItemID and self:GetItemID()) or self.EFT_ItemID or ""
        id = tostring(id or "")
        local db = EFT.ItemDatabase[id]
        if not db or id == "" then self:Remove() return end
        local uid = (self.GetItemUID and self:GetItemUID()) or self.EFT_ItemUID or ""
        uid = tostring(uid or "")
        local cnt = (self.GetItemCount and self:GetItemCount()) or self.EFT_ItemCount or 0
        local hp = (self.GetItemHP and self:GetItemHP()) or self.EFT_ItemHP or 0
        local uses = (self.GetItemUses and self:GetItemUses()) or self.EFT_ItemUses or 0
        local fir = (self.GetItemFIR and self:GetItemFIR()) or self.EFT_ItemFIR or false
        local insured = (self.GetItemInsured and self:GetItemInsured()) or self.EFT_ItemInsured or false
        local extra = {
            uniqueID = (uid ~= "" and uid) or tostring(util.CRC(id .. tostring(CurTime()) .. tostring(math.random(1,99999)))),
            count = (tonumber(cnt) and tonumber(cnt) > 0) and tonumber(cnt) or nil,
            hp = (tonumber(hp) and tonumber(hp) > 0) and tonumber(hp) or nil,
            uses = (tonumber(uses) and tonumber(uses) > 0) and tonumber(uses) or nil,
            examined = true,
            fir = fir and true or false,
            insured = insured and true or false,
        }
        -- Оружие: если уже есть — кладём в инвентарь; иначе Give
        if db.type == "weapon" then
            if not ply:HasWeapon(id) then
                ply:Give(id)
                self:Remove()
                ply:EmitSound(db.sound or "items/ammo_pickup.wav", 65, 100)
                if EFT.Improvements and EFT.Improvements.SyncAll then EFT.Improvements.SyncAll(ply) end
                return
            end
            -- уже есть в руках — пытаемся положить в инвентарь ниже
        elseif db.type == "ammo" and db.ammoName then
            -- всегда даём патроны в HL2 ammo + дублируем в EFT-инвентарь если возможно
            local giveCount = extra.count or 1
            ply:GiveAmmo(giveCount, db.ammoName, false)
            -- также пробуем положить в сетку (стакание)
            if EFT.Improvements and EFT.Improvements.TryAddItem then
                EFT.Improvements.TryAddItem(ply, id, db, extra)
            end
            self:Remove()
            ply:EmitSound("items/ammo_pickup.wav", 65, 100)
            if EFT.Improvements and EFT.Improvements.SyncAll then EFT.Improvements.SyncAll(ply) end
            return
        end
        local ok = false
        if EFT.Improvements and EFT.Improvements.TryAddItem then
            ok = EFT.Improvements.TryAddItem(ply, id, db, extra) and true or false
        end
        if not ok and EFT.Grid and EFT.Grid.TryInsert then
            -- Pants → Shirt → Rig → Backpack → Personal (если сетка > 0)
            local function tryList(list, gw, gh)
                if ok or not list or not gw or gw <= 0 or not gh or gh <= 0 then return end
                if EFT.Grid.TryInsert(list, id, db, gw, gh, extra) then ok = true end
            end
            if EFT.GetPantsInv and EFT.GetPantsGridSize then
                local g = EFT.GetPantsGridSize()
                tryList(EFT.GetPantsInv(ply), g and g.w, g and g.h)
            end
            if not ok and EFT.GetShirtInv and EFT.GetShirtGridSize then
                local g = EFT.GetShirtGridSize()
                tryList(EFT.GetShirtInv(ply), g and g.w, g and g.h)
            end
            local equip = (EFT.PlayerEquipment and EFT.PlayerEquipment[ply]) or {}
            if not ok and equip.rigUID and EFT.RigContents and equip.rig then
                local d = EFT.ItemDatabase[equip.rig]
                if d and d.gridSize then
                    EFT.RigContents[equip.rigUID] = EFT.RigContents[equip.rigUID] or {}
                    tryList(EFT.RigContents[equip.rigUID], d.gridSize.w, d.gridSize.h)
                end
            end
            if not ok and equip.backpackUID and EFT.BackpackContents and equip.backpack then
                local d = EFT.ItemDatabase[equip.backpack]
                if d and d.gridSize then
                    EFT.BackpackContents[equip.backpackUID] = EFT.BackpackContents[equip.backpackUID] or {}
                    tryList(EFT.BackpackContents[equip.backpackUID], d.gridSize.w, d.gridSize.h)
                end
            end
            local pw = tonumber(EFT.Config.PersonalGridBaseW) or 0
            local ph = tonumber(EFT.Config.PersonalGridBaseH) or 0
            if not ok and pw > 0 and ph > 0 then
                EFT.VirtualInventory = EFT.VirtualInventory or {}
                EFT.VirtualInventory[ply] = EFT.VirtualInventory[ply] or {}
                tryList(EFT.VirtualInventory[ply], pw, ph)
            end
        end
        if ok then
            if self.EFTInnerStorage and extra.uniqueID then
                if db.type == "backpack" then
                    EFT.BackpackContents = EFT.BackpackContents or {}
                    EFT.BackpackContents[extra.uniqueID] = self.EFTInnerStorage
                elseif db.type == "rig" then
                    EFT.RigContents = EFT.RigContents or {}
                    EFT.RigContents[extra.uniqueID] = self.EFTInnerStorage
                end
            end
            self:Remove()
            ply:EmitSound("items/itempickup.wav", 65, 100)
            if EFT.Improvements and EFT.Improvements.SyncAll then EFT.Improvements.SyncAll(ply) end
        else
            ply:ChatPrint("[EFT] Нет места в инвентаре!")
        end
    end
    if CLIENT then
        function ENT:Draw()
            self:DrawModel()
            local ply = LocalPlayer()
            if not IsValid(ply) or ply:GetPos():DistToSqr(self:GetPos()) > 40000 then return end
            local db = EFT.ItemDatabase[self:GetItemID()]
            local pos = self:GetPos() + Vector(0, 0, 14)
            local ang = (ply:EyePos() - pos):Angle()
            ang:RotateAroundAxis(ang:Up(), -90) ang:RotateAroundAxis(ang:Forward(), 90)
            cam.Start3D2D(pos, ang, 0.07)
                draw.SimpleTextOutlined(db and db.name or "?", "DermaDefaultBold", 0, 0, color_white, TEXT_ALIGN_CENTER, TEXT_ALIGN_CENTER, 1, Color(0,0,0,220))
                draw.SimpleTextOutlined("[E] ПОДНЯТЬ", "DermaDefault", 0, 14, Color(200,230,255), TEXT_ALIGN_CENTER, TEXT_ALIGN_CENTER, 1, Color(0,0,0,200))
            cam.End3D2D()
        end
    end
    scripted_ents.Register(ENT, "eft_dropped_item")
end

-- ============================================================================
-- STASH LOCKER
-- ============================================================================
do
    local ENT = {}
    ENT.Type, ENT.Base = "anim", "base_gmodentity"
    ENT.PrintName, ENT.Author, ENT.Category = "EFT Stash Locker", "EFT", "EFT — Торговцы"
    ENT.Spawnable, ENT.AdminOnly = true, true
    ENT.Model = EFT.Config.Locker.Model
    function ENT:Initialize()
        self:SetModel(EFT.Config.Locker.Model)
        self:PhysicsInit(SOLID_VPHYSICS)
        self:SetMoveType(MOVETYPE_VPHYSICS)
        self:SetSolid(SOLID_VPHYSICS)
        self:SetUseType(SIMPLE_USE)
        local phys = self:GetPhysicsObject()
        if IsValid(phys) then phys:EnableMotion(false) phys:Wake() end
        if SERVER then self:SetHealth(2000) end
    end
    if CLIENT then
        function ENT:Draw()
            self:DrawModel()
            local ply = LocalPlayer()
            if not IsValid(ply) or ply:GetPos():DistToSqr(self:GetPos()) > 62500 then return end
            local pos = self:GetPos() + Vector(0, 0, 55)
            local ang = (ply:EyePos() - pos):Angle()
            ang:RotateAroundAxis(ang:Up(), -90) ang:RotateAroundAxis(ang:Forward(), 90)
            cam.Start3D2D(pos, ang, 0.1)
                draw.SimpleTextOutlined("ЛИЧНЫЙ СКЛАД", "DermaDefaultBold", 0, 0, Color(160,120,255), TEXT_ALIGN_CENTER, TEXT_ALIGN_CENTER, 1, Color(0,0,0,220))
                draw.SimpleTextOutlined("[F] Открыть stash", "DermaDefault", 0, 16, Color(220,220,220), TEXT_ALIGN_CENTER, TEXT_ALIGN_CENTER, 1, Color(0,0,0,200))
            cam.End3D2D()
        end
    end
    scripted_ents.Register(ENT, "eft_stash_locker")
end

-- ============================================================================
-- RAID ENTITIES
-- ============================================================================
local function MakeRaidEnt(class, printName, model, opts)
    opts = opts or {}
    local ENT = {}
    ENT.Type, ENT.Base = "anim", "base_gmodentity"
    ENT.PrintName, ENT.Author, ENT.Category = printName, "EFT", "EFT — Raid"
    ENT.Spawnable, ENT.AdminOnly = opts.spawnable ~= false, true
    ENT.Model = model
    function ENT:Initialize()
        self:SetModel(self.Model)
        if opts.invisible then
            self:SetNoDraw(true) self:DrawShadow(false)
            self:SetSolid(SOLID_NONE) self:SetMoveType(MOVETYPE_NONE)
            self:SetCollisionGroup(COLLISION_GROUP_IN_VEHICLE)
        else
            self:PhysicsInit(SOLID_VPHYSICS)
            self:SetMoveType(MOVETYPE_VPHYSICS)
            self:SetSolid(SOLID_VPHYSICS)
            self:SetUseType(SIMPLE_USE)
            local phys = self:GetPhysicsObject()
            if IsValid(phys) then phys:EnableMotion(false) phys:Wake() end
        end
        if SERVER then self:SetHealth(99999) end
    end
    if CLIENT and not opts.invisible then
        function ENT:Draw()
            self:DrawModel()
            local ply = LocalPlayer()
            if not IsValid(ply) or ply:GetPos():DistToSqr(self:GetPos()) > 160000 then return end
            local pos = self:GetPos() + Vector(0, 0, opts.labelZ or 48)
            local ang = (ply:EyePos() - pos):Angle()
            ang:RotateAroundAxis(ang:Up(), -90) ang:RotateAroundAxis(ang:Forward(), 90)
            cam.Start3D2D(pos, ang, 0.1)
                draw.SimpleTextOutlined(opts.label or printName, "DermaDefaultBold", 0, 0, opts.color or color_white, TEXT_ALIGN_CENTER, TEXT_ALIGN_CENTER, 1, Color(0,0,0,220))
                if opts.sub then draw.SimpleTextOutlined(opts.sub, "DermaDefault", 0, 16, Color(220,220,220), TEXT_ALIGN_CENTER, TEXT_ALIGN_CENTER, 1, Color(0,0,0,200)) end
            cam.End3D2D()
        end
    end
    if CLIENT and opts.invisible then function ENT:Draw() end end
    scripted_ents.Register(ENT, class)
end
MakeRaidEnt("eft_raid_gate", "EFT Raid Gate", "models/props_combine/breenconsole.mdl", {
    label="ВХОД В РЕЙД", sub="[E] Удерживать", color=Color(255,180,60), labelZ=50
})
MakeRaidEnt("eft_raid_entry", "EFT Raid Entry", "models/editor/playerstart.mdl", { invisible=true })
MakeRaidEnt("eft_raid_extract", "EFT Raid Extract", "models/props_trainstation/trainstation_clock001.mdl", {
    label="ЭКСТРАКТ", sub="[E] Удерживать — домой", color=Color(80,200,120), labelZ=55
})
MakeRaidEnt("eft_raid_return", "EFT Raid Return", "models/props_combine/combine_interface001.mdl", {
    label="ТОЧКА ВОЗВРАТА", sub="Сюда телепортирует экстракт", color=Color(100,180,255), labelZ=48
})

-- Dogtag
do
    local ENT = {}
    ENT.Type, ENT.Base = "anim", "base_gmodentity"
    ENT.PrintName, ENT.Category, ENT.Spawnable = "EFT Dogtag", "EFT — Raid", false
    ENT.Model = "models/props_lab/clipboard.mdl"
    function ENT:SetupDataTables()
        self:NetworkVar("String", 0, "VictimName")
        self:NetworkVar("String", 1, "KillerName")
        self:NetworkVar("Float", 0, "DeathTime")
    end
    function ENT:Initialize()
        self:SetModel(self.Model)
        self:PhysicsInit(SOLID_VPHYSICS)
        self:SetMoveType(MOVETYPE_VPHYSICS)
        self:SetSolid(SOLID_VPHYSICS)
        self:SetUseType(SIMPLE_USE)
        self:SetCollisionGroup(COLLISION_GROUP_WEAPON)
        local phys = self:GetPhysicsObject()
        if IsValid(phys) then phys:Wake() phys:SetMass(1) end
        if SERVER then timer.Simple(900, function() if IsValid(self) then self:Remove() end end) end
    end
    function ENT:Use(act, caller)
        if not SERVER then return end
        local ply = IsValid(caller) and caller or act
        if not IsValid(ply) or not ply:IsPlayer() or not ply:Alive() then return end
        if ply:GetPos():DistToSqr(self:GetPos()) > 14400 then return end
        local money = EFT.Config.Raid.DogtagMoney or 150
        ply:SetNWInt("EFT_Money", ply:GetNWInt("EFT_Money", 0) + money)
        ply:ChatPrint(string.format("[EFT] Догтег: %s | +%d₽", self:GetVictimName() ~= "" and self:GetVictimName() or "?", money))
        if EFT.Raid and EFT.Raid.Stats and EFT.Raid.Stats[ply] then
            EFT.Raid.Stats[ply].dogtags = (EFT.Raid.Stats[ply].dogtags or 0) + 1
        end
        self:EmitSound("physics/metal/chain_impact_soft2.wav", 60, 120)
        self:Remove()
    end
    if CLIENT then
        function ENT:Draw()
            self:DrawModel()
            local ply = LocalPlayer()
            if not IsValid(ply) or ply:GetPos():DistToSqr(self:GetPos()) > 40000 then return end
            local pos = self:GetPos() + Vector(0,0,12)
            local ang = (ply:EyePos() - pos):Angle()
            ang:RotateAroundAxis(ang:Up(), -90) ang:RotateAroundAxis(ang:Forward(), 90)
            cam.Start3D2D(pos, ang, 0.06)
                draw.SimpleTextOutlined("ДОГТЕГ", "DermaDefaultBold", 0, 0, Color(220,180,80), TEXT_ALIGN_CENTER, TEXT_ALIGN_CENTER, 1, Color(0,0,0,220))
                draw.SimpleTextOutlined(self:GetVictimName() or "?", "DermaDefault", 0, 12, color_white, TEXT_ALIGN_CENTER, TEXT_ALIGN_CENTER, 1, Color(0,0,0,200))
            cam.End3D2D()
        end
    end
    scripted_ents.Register(ENT, "eft_dogtag")
end

print("[EFT-COMPLETE] Entities registered.")


-- ============================================================================
-- SERVER UNIFIED
-- ============================================================================
if SERVER then
    EFT.SecureContents = EFT.SecureContents or {}
    EFT.StashContents = EFT.StashContents or {}
    EFT.InsuranceQueue = EFT.InsuranceQueue or {}
    EFT.MedHotbar = EFT.MedHotbar or {}
    EFT.AppliedAttachments = EFT.AppliedAttachments or {}
    EFT.Raid = EFT.Raid or {}
    EFT.Raid.InRaid = EFT.Raid.InRaid or {}
    EFT.Raid.Stats = EFT.Raid.Stats or {}
    EFT.Raid.Hold = EFT.Raid.Hold or {}

    util.AddNetworkString("EFT_SyncExtended")
    util.AddNetworkString("EFT_RequestExtended")
    util.AddNetworkString("EFT_MoveInvExt")
    util.AddNetworkString("EFT_RequestStash")
    util.AddNetworkString("EFT_InsureItem")
    util.AddNetworkString("EFT_ClaimInsurance")
    util.AddNetworkString("EFT_SortGrid")
    util.AddNetworkString("EFT_ApplyMedLimb")
    util.AddNetworkString("EFT_SetMedHotbar")
    util.AddNetworkString("EFT_UseMedHotbar")
    util.AddNetworkString("EFT_QuickMed")
    util.AddNetworkString("EFT_ApplyAttachment")
    util.AddNetworkString("EFT_ReturnAttachment")
    util.AddNetworkString("EFT_Raid_HoldStart")
    util.AddNetworkString("EFT_Raid_HoldCancel")
    util.AddNetworkString("EFT_Raid_HoldProgress")
    util.AddNetworkString("EFT_Raid_ExtractDone")
    util.AddNetworkString("EFT_Raid_EnteredRaid")
    util.AddNetworkString("EFT_Raid_Stats")
    util.AddNetworkString("EFT_LockerNoise")

    function EFT.Improvements.GetEquip(ply)
        EFT.PlayerEquipment = EFT.PlayerEquipment or {}
        EFT.PlayerEquipment[ply] = EFT.PlayerEquipment[ply] or {
            backpack=nil, backpackUID=nil, vest=nil, helmet=nil, rig=nil, rigUID=nil, mask=nil, headphones=nil,
        }
        return EFT.PlayerEquipment[ply]
    end
    function EFT.Improvements.GetPersonal(ply)
        EFT.VirtualInventory = EFT.VirtualInventory or {}
        EFT.VirtualInventory[ply] = EFT.VirtualInventory[ply] or {}
        return EFT.VirtualInventory[ply]
    end
    function EFT.Improvements.GetSecure(ply)
        local id = Sid(ply) if not id then return {} end
        EFT.SecureContents[id] = EFT.SecureContents[id] or {}
        return EFT.SecureContents[id]
    end
    function EFT.Improvements.GetStash(ply)
        local id = Sid(ply) if not id then return {} end
        EFT.StashContents[id] = EFT.StashContents[id] or {}
        return EFT.StashContents[id]
    end

    function EFT.Improvements.TryAddItem(ply, itemID, db, extra)
        extra = extra or {}
        local equip = EFT.Improvements.GetEquip(ply)
        if EFT.GetClothing then EFT.GetClothing(ply) end

        if db.type == "ammo" then
            local left, maxStack = extra.count or (db.maxStack or 1), db.maxStack or 30
            local function stackIn(list)
                if not list then return left end
                for _, it in ipairs(list) do
                    if it.id == itemID and (it.count or 0) < maxStack then
                        local add = math.min(maxStack - it.count, left)
                        it.count = it.count + add left = left - add
                        if left <= 0 then return 0 end
                    end
                end
                return left
            end
            if EFT.GetPantsInv then left = stackIn(EFT.GetPantsInv(ply)) end
            if left > 0 and EFT.GetShirtInv then left = stackIn(EFT.GetShirtInv(ply)) end
            left = stackIn(EFT.Improvements.GetPersonal(ply))
            if left > 0 and equip.rigUID and EFT.RigContents then left = stackIn(EFT.RigContents[equip.rigUID]) end
            if left > 0 and equip.backpackUID and EFT.BackpackContents then left = stackIn(EFT.BackpackContents[equip.backpackUID]) end
            if left <= 0 then return true end
            extra.count = left
        end

        -- Pants 2x2 → Shirt 2x3 → Rig → Backpack → Personal
        if EFT.GetPantsInv and EFT.GetPantsGridSize then
            local pg = EFT.GetPantsGridSize()
            if pg and pg.w > 0 and EFT.Grid.TryInsert(EFT.GetPantsInv(ply), itemID, db, pg.w, pg.h, extra) then return true end
        end
        if EFT.GetShirtInv and EFT.GetShirtGridSize then
            local sg = EFT.GetShirtGridSize()
            if sg and sg.w > 0 and EFT.Grid.TryInsert(EFT.GetShirtInv(ply), itemID, db, sg.w, sg.h, extra) then return true end
        end
        if equip.rig and equip.rigUID and EFT.RigContents then
            EFT.RigContents[equip.rigUID] = EFT.RigContents[equip.rigUID] or {}
            local d = EFT.ItemDatabase[equip.rig]
            if d and d.gridSize and EFT.Grid.TryInsert(EFT.RigContents[equip.rigUID], itemID, db, d.gridSize.w, d.gridSize.h, extra) then return true end
        end
        if equip.backpack and equip.backpackUID and EFT.BackpackContents then
            EFT.BackpackContents[equip.backpackUID] = EFT.BackpackContents[equip.backpackUID] or {}
            local d = EFT.ItemDatabase[equip.backpack]
            if d and d.gridSize and EFT.Grid.TryInsert(EFT.BackpackContents[equip.backpackUID], itemID, db, d.gridSize.w, d.gridSize.h, extra) then return true end
        end
        local pw = tonumber(EFT.Config.PersonalGridBaseW) or 0
        local ph = tonumber(EFT.Config.PersonalGridBaseH) or 0
        if pw <= 0 or ph <= 0 then
            return false
        end
        return EFT.Grid.TryInsert(EFT.Improvements.GetPersonal(ply), itemID, db, pw, ph, extra) ~= nil
    end

    local function ComputeWeight(ply)
        local equip = EFT.Improvements.GetEquip(ply)
        local weight, cap = 0, EFT.Config.BaseCarryCapacity or 15
        if equip.backpack and EFT.ItemDatabase[equip.backpack] and EFT.ItemDatabase[equip.backpack].capacity then
            cap = cap + EFT.ItemDatabase[equip.backpack].capacity
        end
        local function add(list)
            if not list then return end
            for _, it in ipairs(list) do
                local d = EFT.ItemDatabase[it.id]
                if d then weight = weight + (d.weight or 0) * (it.count or 1) end
            end
        end
        add(EFT.Improvements.GetPersonal(ply))
        if EFT.GetPantsInv then add(EFT.GetPantsInv(ply)) end
        if EFT.GetShirtInv then add(EFT.GetShirtInv(ply)) end
        if equip.rigUID and EFT.RigContents then add(EFT.RigContents[equip.rigUID]) end
        if equip.backpackUID and EFT.BackpackContents then add(EFT.BackpackContents[equip.backpackUID]) end
        for _, s in ipairs({"backpack","vest","helmet","rig","mask","headphones"}) do
            if equip[s] and EFT.ItemDatabase[equip[s]] then weight = weight + (EFT.ItemDatabase[equip[s]].weight or 0) end
        end
        if EFT.GetClothing then
            local cl = EFT.GetClothing(ply)
            if cl and cl.pants and EFT.ItemDatabase[cl.pants] then weight = weight + (EFT.ItemDatabase[cl.pants].weight or 0) end
            if cl and cl.shirt and EFT.ItemDatabase[cl.shirt] then weight = weight + (EFT.ItemDatabase[cl.shirt].weight or 0) end
        end
        if ply.EFT_PerkCarryBonus then cap = cap + ply.EFT_PerkCarryBonus end
        return weight, cap
    end

    local function InventoryValue(ply)
        local total = 0
        local function scan(list)
            if not list then return end
            for _, it in ipairs(list) do
                local d = EFT.ItemDatabase[it.id]
                if d then total = total + ((d.buyPrice or d.price) or 0) * (it.count or 1) end
            end
        end
        local equip = EFT.Improvements.GetEquip(ply)
        scan(EFT.Improvements.GetPersonal(ply))
        if equip.rigUID and EFT.RigContents then scan(EFT.RigContents[equip.rigUID]) end
        if equip.backpackUID and EFT.BackpackContents then scan(EFT.BackpackContents[equip.backpackUID]) end
        scan(EFT.Improvements.GetSecure(ply))
        return total
    end

    local function EnsureDirs()
        if not file.IsDir(EFT.Config.Persistence.Folder, "DATA") then file.CreateDir(EFT.Config.Persistence.Folder) end
    end
    local function SavePath(sid) return EFT.Config.Persistence.Folder .. "/" .. sid .. ".json" end

    function EFT.Improvements.SavePlayer(ply)
        if not EFT.Config.Persistence.Enabled or not IsValid(ply) or ply:IsBot() then return end
        local sid = Sid(ply) if not sid then return end
        EnsureDirs()
        local equip = EFT.Improvements.GetEquip(ply)
        local data = {
            version = 12, money = ply:GetNWInt("EFT_Money", 0),
            personal = EFT.Improvements.GetPersonal(ply),
            equipment = {
                backpack=equip.backpack, backpackUID=equip.backpackUID, vest=equip.vest, helmet=equip.helmet,
                rig=equip.rig, rigUID=equip.rigUID, mask=equip.mask, headphones=equip.headphones,
            },
            secure = EFT.Improvements.GetSecure(ply),
            stash = EFT.Improvements.GetStash(ply),
            insurance = EFT.InsuranceQueue[sid] or {},
            limbs = EFT.PlayerLimbHealth[ply] or table.Copy(EFT.Config.LimbMaxHealth),
            hotbar = EFT.MedHotbar[ply] or {},
            backpacks = {}, rigs = {},
            time = os.time(),
        }
        if equip.backpackUID and EFT.BackpackContents and EFT.BackpackContents[equip.backpackUID] then
            data.backpacks[equip.backpackUID] = EFT.BackpackContents[equip.backpackUID]
        end
        if equip.rigUID and EFT.RigContents and EFT.RigContents[equip.rigUID] then
            data.rigs[equip.rigUID] = EFT.RigContents[equip.rigUID]
        end
        local ok, enc = pcall(util.TableToJSON, data, false)
        if ok and enc then file.Write(SavePath(sid), enc) end
    end

    function EFT.Improvements.LoadPlayer(ply)
        if not EFT.Config.Persistence.Enabled or not IsValid(ply) then return end
        local sid = Sid(ply) if not sid then return end
        EnsureDirs()
        local path = SavePath(sid)
        if not file.Exists(path, "DATA") then return end
        local raw = file.Read(path, "DATA")
        if not raw or raw == "" then return end
        local ok, data = pcall(util.JSONToTable, raw)
        if not ok or not istable(data) then return end
        EFT.VirtualInventory = EFT.VirtualInventory or {}
        EFT.VirtualInventory[ply] = istable(data.personal) and data.personal or {}
        EFT.PlayerEquipment = EFT.PlayerEquipment or {}
        EFT.PlayerEquipment[ply] = istable(data.equipment) and data.equipment or EFT.Improvements.GetEquip(ply)
        EFT.PlayerLimbHealth = EFT.PlayerLimbHealth or {}
        EFT.PlayerLimbHealth[ply] = istable(data.limbs) and data.limbs or table.Copy(EFT.Config.LimbMaxHealth)
        EFT.SecureContents[sid] = istable(data.secure) and data.secure or {}
        EFT.StashContents[sid] = istable(data.stash) and data.stash or {}
        EFT.InsuranceQueue[sid] = istable(data.insurance) and data.insurance or {}
        EFT.MedHotbar[ply] = istable(data.hotbar) and data.hotbar or {}
        if istable(data.backpacks) and EFT.BackpackContents then for u,i in pairs(data.backpacks) do EFT.BackpackContents[u]=i end end
        if istable(data.rigs) and EFT.RigContents then for u,i in pairs(data.rigs) do EFT.RigContents[u]=i end end
        if data.money then ply:SetNWInt("EFT_Money", tonumber(data.money) or 0) end
        print("[EFT-COMPLETE] Loaded " .. tostring(ply:Nick()))
    end

    function EFT.Improvements.SyncAll(ply)
        if not IsValid(ply) then return end
        local equip = EFT.Improvements.GetEquip(ply)
        local weight, cap = ComputeWeight(ply)
        local limbs = EFT.PlayerLimbHealth[ply] or table.Copy(EFT.Config.LimbMaxHealth)
        local meds = {}
        local function scanMed(list)
            if not list then return end
            for _, it in ipairs(list) do
                local d = EFT.ItemDatabase[it.id]
                if d and d.type == "medicine" then meds[#meds+1] = it end
            end
        end
        scanMed(EFT.Improvements.GetPersonal(ply))
        if equip.rigUID and EFT.RigContents then scanMed(EFT.RigContents[equip.rigUID]) end
        if equip.backpackUID and EFT.BackpackContents then scanMed(EFT.BackpackContents[equip.backpackUID]) end

        local rigItems, bpItems = {}, {}
        local rW,rH,bW,bH = 0,0,0,0
        if equip.rigUID and EFT.RigContents then
            rigItems = EFT.RigContents[equip.rigUID] or {}
            local rd = EFT.ItemDatabase[equip.rig]
            if rd and rd.gridSize then rW,rH = rd.gridSize.w, rd.gridSize.h end
        end
        if equip.backpackUID and EFT.BackpackContents then
            bpItems = EFT.BackpackContents[equip.backpackUID] or {}
            local bd = EFT.ItemDatabase[equip.backpack]
            if bd and bd.gridSize then bW,bH = bd.gridSize.w, bd.gridSize.h end
        end

        local secure = EFT.Improvements.GetSecure(ply)
        local sid = Sid(ply)
        local insReady = 0
        if sid and EFT.InsuranceQueue[sid] then
            for _, e in ipairs(EFT.InsuranceQueue[sid]) do
                if e.ready then insReady = insReady + 1 end
            end
        end

        net.Start("EFT_SyncExtended")
            net.WriteTable(EFT.Improvements.GetPersonal(ply))
            net.WriteTable(rigItems)
            net.WriteTable(bpItems)
            net.WriteTable(secure)
            net.WriteBool(false) -- stash only via locker
            net.WriteString(equip.backpack or "")
            net.WriteString(equip.vest or "")
            net.WriteString(equip.helmet or "")
            net.WriteString(equip.rig or "")
            net.WriteString(equip.mask or "")
            net.WriteString(equip.headphones or "")
            net.WriteInt(ply:GetNWInt("EFT_Money", 0), 32)
            net.WriteFloat(weight) net.WriteFloat(cap)
            net.WriteUInt(EFT.Config.PersonalGridBaseW or 2, 8)
            net.WriteUInt(EFT.Config.PersonalGridBaseH or 5, 8)
            net.WriteUInt(rW, 8) net.WriteUInt(rH, 8)
            net.WriteUInt(bW, 8) net.WriteUInt(bH, 8)
            net.WriteUInt(EFT.Config.SecureContainer.GridW or 2, 4)
            net.WriteUInt(EFT.Config.SecureContainer.GridH or 2, 4)
            net.WriteUInt(EFT.Config.Stash.GridW or 10, 8)
            net.WriteUInt(EFT.Config.Stash.GridH or 14, 8)
            net.WriteUInt(math.min(insReady, 255), 8)
            net.WriteTable(limbs)
            net.WriteTable(meds)
            net.WriteInt(InventoryValue(ply), 32)
            net.WriteTable(EFT.MedHotbar[ply] or {})
            -- Clothing pockets: pants 2x2, shirt 2x3
            if EFT.GetClothing then EFT.GetClothing(ply) end
            local pantsItems = (EFT.GetPantsInv and EFT.GetPantsInv(ply)) or {}
            local shirtItems = (EFT.GetShirtInv and EFT.GetShirtInv(ply)) or {}
            local pg = (EFT.GetPantsGridSize and EFT.GetPantsGridSize()) or { w = 2, h = 2 }
            local sg = (EFT.GetShirtGridSize and EFT.GetShirtGridSize()) or { w = 2, h = 3 }
            net.WriteTable(pantsItems)
            net.WriteTable(shirtItems)
            net.WriteUInt(pg.w or 2, 4)
            net.WriteUInt(pg.h or 2, 4)
            net.WriteUInt(sg.w or 2, 4)
            net.WriteUInt(sg.h or 3, 4)
        net.Send(ply)
    end

    net.Receive("EFT_RequestExtended", function(_, ply)
        if IsValid(ply) then EFT.Improvements.SyncAll(ply) end
    end)

    net.Receive("EFT_RequestStash", function(_, ply)
        if not IsValid(ply) then return end
        local locker = net.ReadEntity()
        if not IsValid(locker) or locker:GetClass() ~= "eft_stash_locker" then return end
        if ply:GetPos():DistToSqr(locker:GetPos()) > (EFT.Config.Locker.UseDistance or 100)^2 then return end
        local equip = EFT.Improvements.GetEquip(ply)
        local weight, cap = ComputeWeight(ply)
        local limbs = EFT.PlayerLimbHealth[ply] or table.Copy(EFT.Config.LimbMaxHealth)
        local meds = {}
        local function scanMed(list)
            if not list then return end
            for _, it in ipairs(list) do
                local d = EFT.ItemDatabase[it.id]
                if d and d.type == "medicine" then meds[#meds+1] = it end
            end
        end
        scanMed(EFT.Improvements.GetPersonal(ply))
        local rigItems, bpItems = {}, {}
        local rW,rH,bW,bH = 0,0,0,0
        if equip.rigUID and EFT.RigContents then
            rigItems = EFT.RigContents[equip.rigUID] or {}
            local rd = EFT.ItemDatabase[equip.rig]
            if rd and rd.gridSize then rW,rH = rd.gridSize.w, rd.gridSize.h end
        end
        if equip.backpackUID and EFT.BackpackContents then
            bpItems = EFT.BackpackContents[equip.backpackUID] or {}
            local bd = EFT.ItemDatabase[equip.backpack]
            if bd and bd.gridSize then bW,bH = bd.gridSize.w, bd.gridSize.h end
        end
        net.Start("EFT_SyncExtended")
            net.WriteTable(EFT.Improvements.GetPersonal(ply))
            net.WriteTable(rigItems)
            net.WriteTable(bpItems)
            net.WriteTable(EFT.Improvements.GetSecure(ply))
            net.WriteBool(true)
            net.WriteTable(EFT.Improvements.GetStash(ply))
            net.WriteString(equip.backpack or "")
            net.WriteString(equip.vest or "")
            net.WriteString(equip.helmet or "")
            net.WriteString(equip.rig or "")
            net.WriteString(equip.mask or "")
            net.WriteString(equip.headphones or "")
            net.WriteInt(ply:GetNWInt("EFT_Money", 0), 32)
            net.WriteFloat(weight) net.WriteFloat(cap)
            net.WriteUInt(EFT.Config.PersonalGridBaseW or 2, 8)
            net.WriteUInt(EFT.Config.PersonalGridBaseH or 5, 8)
            net.WriteUInt(rW, 8) net.WriteUInt(rH, 8)
            net.WriteUInt(bW, 8) net.WriteUInt(bH, 8)
            net.WriteUInt(EFT.Config.SecureContainer.GridW or 2, 4)
            net.WriteUInt(EFT.Config.SecureContainer.GridH or 2, 4)
            net.WriteUInt(EFT.Config.Stash.GridW or 10, 8)
            net.WriteUInt(EFT.Config.Stash.GridH or 14, 8)
            net.WriteUInt(0, 8)
            net.WriteTable(limbs)
            net.WriteTable(meds)
            net.WriteInt(InventoryValue(ply), 32)
            net.WriteTable(EFT.MedHotbar[ply] or {})
            if EFT.GetClothing then EFT.GetClothing(ply) end
            local pantsItems = (EFT.GetPantsInv and EFT.GetPantsInv(ply)) or {}
            local shirtItems = (EFT.GetShirtInv and EFT.GetShirtInv(ply)) or {}
            local pg = (EFT.GetPantsGridSize and EFT.GetPantsGridSize()) or { w = 2, h = 2 }
            local sg = (EFT.GetShirtGridSize and EFT.GetShirtGridSize()) or { w = 2, h = 3 }
            net.WriteTable(pantsItems)
            net.WriteTable(shirtItems)
            net.WriteUInt(pg.w or 2, 4)
            net.WriteUInt(pg.h or 2, 4)
            net.WriteUInt(sg.w or 2, 4)
            net.WriteUInt(sg.h or 3, 4)
        net.Send(ply)
        net.Start("EFT_LockerNoise") net.WriteVector(locker:GetPos()) net.SendPVS(locker:GetPos())
    end)

    -- Attachments
    function EFT.GiveZCityAttachment(ply, class)
        if not IsValid(ply) or not class then return false end
        if weapons.GetStored(class) then
            if not ply:HasWeapon(class) then ply:Give(class) end
            return true
        end
        local e = ents.Create(class)
        if not IsValid(e) then return false end
        e:SetPos(ply:EyePos() + ply:GetAimVector() * 20)
        e:Spawn()
        if e.SetOwner then e:SetOwner(ply) end
        if e.Use then pcall(function() e:Use(ply, ply, USE_ON, 0) end) end
        return true
    end

    net.Receive("EFT_ApplyAttachment", function(_, ply)
        if not IsValid(ply) or not ply:Alive() then return end
        local uniqueID = net.ReadString()
        local list, idx, item
        local function find(lst)
            if not lst then return end
            for i, it in ipairs(lst) do if it.uniqueID == uniqueID then return lst, i, it end end
        end
        local equip = EFT.Improvements.GetEquip(ply)
        list, idx, item = find(EFT.Improvements.GetPersonal(ply))
        if not item and equip.rigUID and EFT.RigContents then list, idx, item = find(EFT.RigContents[equip.rigUID]) end
        if not item and equip.backpackUID and EFT.BackpackContents then list, idx, item = find(EFT.BackpackContents[equip.backpackUID]) end
        if not item then return end
        local db = EFT.ItemDatabase[item.id]
        if not db or db.type ~= "attachment" then return end
        if EFT.GiveZCityAttachment(ply, item.id) then
            table.remove(list, idx)
            EFT.AppliedAttachments[ply] = EFT.AppliedAttachments[ply] or {}
            EFT.AppliedAttachments[ply][item.id] = (EFT.AppliedAttachments[ply][item.id] or 0) + 1
            ply:ChatPrint("[EFT] Обвес на оружие: " .. (db.name or item.id))
            ply:EmitSound("items/ammo_pickup.wav", 60, 110)
            EFT.Improvements.SyncAll(ply)
            EFT.Improvements.SavePlayer(ply)
        end
    end)

    net.Receive("EFT_ReturnAttachment", function(_, ply)
        if not IsValid(ply) then return end
        local class = net.ReadString()
        local db = EFT.ItemDatabase[class]
        if not db or db.type ~= "attachment" then return end
        local applied = EFT.AppliedAttachments[ply]
        if applied and applied[class] and applied[class] > 0 then applied[class] = applied[class] - 1 end
        if weapons.GetStored(class) and ply:HasWeapon(class) then ply:StripWeapon(class) end
        for _, ent in ipairs(ents.FindInSphere(ply:GetPos(), 100)) do
            if IsValid(ent) and ent:GetClass() == class then ent:Remove() break end
        end
        if EFT.Improvements.TryAddItem(ply, class, db, { examined = true }) then
            ply:ChatPrint("[EFT] Обвес в инвентарь: " .. (db.name or class))
            EFT.Improvements.SyncAll(ply)
        else
            ply:ChatPrint("[EFT] Нет места!")
        end
    end)

    -- Unequip handled transactionally by the primary inventory handler.

    -- NPC loot
    local function FillNPCCorpse(corpse, npc)
        if not IsValid(corpse) then return end
        local storage = EFT.ContainerStorage
        if not storage then return end
        local gridW = EFT.Config.CorpseGridWidth or 8
        local gridH = EFT.Config.CorpseGridHeight or 8
        local loot = {}
        local armorList, extraList = {}, {}
        for id, d in pairs(EFT.ItemDatabase) do
            if d.type == "armor" then armorList[#armorList+1] = id
            elseif d.type == "medicine" or d.type == "food" or d.type == "valuable" or d.type == "ammo" or d.type == "attachment" or d.type == "part" then
                extraList[#extraList+1] = { id = id, rarity = d.rarity or "common" }
            end
        end
        local rw = { common=100, uncommon=45, rare=18, epic=6, legendary=1 }
        local function pickW(list)
            if #list < 1 then return nil end
            local t = 0 for _,e in ipairs(list) do t = t + (rw[e.rarity] or 20) end
            local r = math.random() * t
            for _,e in ipairs(list) do r = r - (rw[e.rarity] or 20) if r <= 0 then return e.id end end
            return list[#list].id
        end
        if IsValid(npc) and math.random() <= (EFT.Config.TarkovLoot.NPCWeaponChance or 0.55) then
            local wep = npc:GetActiveWeapon()
            if IsValid(wep) then
                local class = wep:GetClass()
                local db = EFT.ItemDatabase[class]
                if db then
                    EFT.Grid.TryInsert(loot, class, db, gridW, gridH, { examined = false })
                    for id, d in pairs(EFT.ItemDatabase) do
                        if d.type == "ammo" then
                            EFT.Grid.TryInsert(loot, id, d, gridW, gridH, { examined=false, count=math.random(10,30) })
                            break
                        end
                    end
                end
            end
        end
        if math.random() <= (EFT.Config.TarkovLoot.NPCArmorChance or 0.35) and #armorList > 0 then
            local id = armorList[math.random(1, #armorList)]
            local db = EFT.ItemDatabase[id]
            if db then EFT.Grid.TryInsert(loot, id, db, gridW, gridH, { examined = false }) end
        end
        local n = math.random(EFT.Config.TarkovLoot.NPCExtraMin or 2, EFT.Config.TarkovLoot.NPCExtraMax or 6)
        for i = 1, n do
            local id = pickW(extraList)
            if id and EFT.ItemDatabase[id] then
                local d = EFT.ItemDatabase[id]
                local extra = { examined = false }
                if d.maxStack then extra.count = math.random(1, math.min(d.maxStack, 20)) end
                if d.maxUses then extra.uses = math.random(1, d.maxUses) end
                EFT.Grid.TryInsert(loot, id, d, gridW, gridH, extra)
            end
        end
        corpse.IsPlayerCorpse = true
        corpse.IsNPCCorpse = true
        corpse.CorpseOwner = IsValid(npc) and (npc:GetClass() or "NPC") or "NPC"
        corpse:SetNWBool("EFT_ForeignLoot", true)
        corpse:SetNWString("EFT_ForeignOwner", corpse.CorpseOwner)
        storage[corpse] = loot
        if EFT.ContainerGridSize then EFT.ContainerGridSize[corpse] = { w = gridW, h = gridH } end
    end

    hook.Add("OnNPCKilled", "EFT_Complete_NPCLoot", function(npc, attacker, inf)
        if not EFT.Config.TarkovLoot.NPCLootEnabled then return end
        if not IsValid(npc) then return end
        timer.Simple(0.2, function()
            if not IsValid(npc) then return end
            local rag = npc:GetRagdollEntity()
            if not IsValid(rag) then
                rag = ents.Create("prop_ragdoll")
                if IsValid(rag) then
                    rag:SetModel(npc:GetModel())
                    rag:SetPos(npc:GetPos())
                    rag:SetAngles(npc:GetAngles())
                    rag:Spawn()
                end
            end
            if IsValid(rag) then FillNPCCorpse(rag, npc) end
        end)
    end)

    -- Player corpse: unexamined items
    hook.Add("DoPlayerDeath", "EFT_Complete_CorpseUnexamined", function(ply, attacker)
        timer.Simple(0.4, function()
            local storage = EFT.ContainerStorage
            if not storage then return end
            local corpse = IsValid(ply) and ply:GetRagdollEntity() or NULL
            if not IsValid(corpse) then
                for _, ent in ipairs(ents.FindInSphere(IsValid(ply) and ply:GetPos() or Vector(), 80)) do
                    if IsValid(ent) and ent.IsPlayerCorpse then corpse = ent break end
                end
            end
            if not IsValid(corpse) or not storage[corpse] then return end
            for _, it in ipairs(storage[corpse]) do it.examined = false end
            -- dogtag
            if IsValid(ply) then
                local tag = ents.Create("eft_dogtag")
                if IsValid(tag) then
                    tag:SetPos(ply:GetPos() + Vector(0,0,20))
                    tag:SetVictimName(ply:Nick() or "?")
                    tag:SetKillerName(IsValid(attacker) and attacker:IsPlayer() and attacker:Nick() or "окружение")
                    tag:SetDeathTime(os.time())
                    tag:Spawn()
                end
                corpse:SetNWBool("EFT_ForeignLoot", true)
                corpse:SetNWString("EFT_ForeignOwner", ply:Nick() or "?")
            end
        end)
    end)

    -- Raid system
    local function CollectEnts(class)
        local t = {}
        for _, e in ipairs(ents.FindByClass(class)) do if IsValid(e) then t[#t+1] = e end end
        return t
    end
    local function PickRandom(list)
        if #list < 1 then return nil end
        return list[math.random(1, #list)]
    end
    local function SafeTeleport(ply, pos, ang)
        if not IsValid(ply) then return end
        ply:ExitVehicle()
        ply:SetPos(pos + Vector(0,0,8))
        if ang then ply:SetEyeAngles(Angle(0, ang.y, 0)) end
        ply:SetVelocity(Vector(0,0,0))
        ply:EmitSound("ambient/machines/teleport1.wav", 70, 100)
    end
    function EFT.Raid.EnterViaGate(ply)
        local entries = CollectEnts("eft_raid_entry")
        if #entries < 1 then ply:ChatPrint("[EFT] Нет eft_raid_entry на карте.") return end
        local dest = PickRandom(entries)
        EFT.Raid.InRaid[ply] = true
        EFT.Raid.Stats[ply] = { startTime = CurTime(), kills = 0, dogtags = 0 }
        ply:SetNWBool("EFT_InRaid", true)
        SafeTeleport(ply, dest:GetPos(), dest:GetAngles())
        net.Start("EFT_Raid_EnteredRaid") net.Send(ply)
        ply:ChatPrint("[EFT] Рейд начат.")
    end
    function EFT.Raid.ExtractHome(ply)
        local dest = PickRandom(CollectEnts("eft_raid_return")) or PickRandom(CollectEnts("eft_raid_gate"))
        if not IsValid(dest) then ply:ChatPrint("[EFT] Нет точки возврата.") return end
        local st = EFT.Raid.Stats[ply] or {}
        st.extracted, st.survived, st.endTime = true, true, CurTime()
        st.lootValue = InventoryValue(ply)
        st.duration = math.floor((st.endTime or CurTime()) - (st.startTime or CurTime()))
        EFT.Raid.InRaid[ply] = false
        ply:SetNWBool("EFT_InRaid", false)
        SafeTeleport(ply, dest:GetPos(), dest:GetAngles())
        EFT.Improvements.SavePlayer(ply)
        net.Start("EFT_Raid_ExtractDone")
            net.WriteTable({ kills=st.kills or 0, dogtags=st.dogtags or 0, lootValue=st.lootValue or 0, duration=st.duration or 0, extracted=true, survived=true })
        net.Send(ply)
    end
    net.Receive("EFT_Raid_HoldStart", function(_, ply)
        if not IsValid(ply) or not ply:Alive() then return end
        local ent = net.ReadEntity()
        if not IsValid(ent) then return end
        local cls = ent:GetClass()
        if cls ~= "eft_raid_gate" and cls ~= "eft_raid_extract" then return end
        if ply:GetPos():DistToSqr(ent:GetPos()) > (EFT.Config.Raid.UseDistance or 140)^2 then return end
        if EFT.Raid.Hold[ply] then return end
        local kind, duration, action
        if cls == "eft_raid_gate" then
            if EFT.Raid.InRaid[ply] then ply:ChatPrint("[EFT] Уже в рейде.") return end
            kind, duration, action = "gate", math.Rand(EFT.Config.Raid.GateWaitMin, EFT.Config.Raid.GateWaitMax), "enter"
        else
            kind, duration, action = "extract", math.Rand(EFT.Config.Raid.ExtractWaitMin, EFT.Config.Raid.ExtractWaitMax), "home"
        end
        EFT.Raid.Hold[ply] = { ent=ent, start=CurTime(), duration=duration, action=action, kind=kind }
        net.Start("EFT_Raid_HoldProgress") net.WriteFloat(0) net.WriteFloat(duration) net.WriteBool(true) net.WriteString(kind) net.Send(ply)
    end)
    net.Receive("EFT_Raid_HoldCancel", function(_, ply)
        EFT.Raid.Hold[ply] = nil
        net.Start("EFT_Raid_HoldProgress") net.WriteFloat(0) net.WriteFloat(0) net.WriteBool(false) net.WriteString("") net.Send(ply)
    end)
    hook.Add("Think", "EFT_Complete_RaidHold", function()
        for ply, data in pairs(EFT.Raid.Hold) do
            if not IsValid(ply) or not ply:Alive() then EFT.Raid.Hold[ply] = nil continue end
            local ent = data.ent
            if not IsValid(ent) or ply:GetPos():DistToSqr(ent:GetPos()) > (EFT.Config.Raid.UseDistance or 140)^2 or ply:GetVelocity():Length2D() > 90 then
                EFT.Raid.Hold[ply] = nil
                net.Start("EFT_Raid_HoldProgress") net.WriteFloat(0) net.WriteFloat(0) net.WriteBool(false) net.WriteString("") net.Send(ply)
                continue
            end
            local elapsed = CurTime() - data.start
            if elapsed >= data.duration then
                local action = data.action
                EFT.Raid.Hold[ply] = nil
                net.Start("EFT_Raid_HoldProgress") net.WriteFloat(1) net.WriteFloat(data.duration) net.WriteBool(false) net.WriteString("") net.Send(ply)
                if action == "enter" then EFT.Raid.EnterViaGate(ply)
                elseif action == "home" then EFT.Raid.ExtractHome(ply) end
            end
        end
    end)

    -- Med limb apply
    net.Receive("EFT_ApplyMedLimb", function(_, ply)
        if not IsValid(ply) then return end
        local uid = net.ReadString()
        local limb = net.ReadString()
        local list, idx, item
        local function find(lst)
            if not lst then return end
            for i, it in ipairs(lst) do if it.uniqueID == uid then return lst, i, it end end
        end
        local equip = EFT.Improvements.GetEquip(ply)
        list, idx, item = find(EFT.Improvements.GetPersonal(ply))
        if not item and equip.rigUID and EFT.RigContents then list, idx, item = find(EFT.RigContents[equip.rigUID]) end
        if not item and equip.backpackUID and EFT.BackpackContents then list, idx, item = find(EFT.BackpackContents[equip.backpackUID]) end
        if not item then return end
        local db = EFT.ItemDatabase[item.id]
        if not db or db.type ~= "medicine" then return end
        EFT.PlayerLimbHealth = EFT.PlayerLimbHealth or {}
        EFT.PlayerLimbHealth[ply] = EFT.PlayerLimbHealth[ply] or table.Copy(EFT.Config.LimbMaxHealth)
        local max = EFT.Config.LimbMaxHealth[limb] or 100
        local heal = db.healAmount or 30
        EFT.PlayerLimbHealth[ply][limb] = math.min(max, (EFT.PlayerLimbHealth[ply][limb] or 0) + heal)
        if item.uses then
            item.uses = item.uses - 1
            if item.uses <= 0 then table.remove(list, idx) end
        elseif item.hp then
            item.hp = item.hp - heal
            if item.hp <= 0 then table.remove(list, idx) end
        else
            table.remove(list, idx)
        end
        ply:EmitSound("items/medshot4.wav", 60, 100)
        EFT.Improvements.SyncAll(ply)
    end)

    hook.Add("PlayerInitialSpawn", "EFT_Complete_Load", function(ply)
        timer.Simple(1, function() if IsValid(ply) then EFT.Improvements.LoadPlayer(ply) end end)
    end)
    hook.Add("PlayerDisconnected", "EFT_Complete_Save", function(ply)
        EFT.Improvements.SavePlayer(ply)
    end)
    timer.Create("EFT_Complete_AutoSave", EFT.Config.Persistence.SaveInterval or 45, 0, function()
        for _, ply in ipairs(player.GetAll()) do EFT.Improvements.SavePlayer(ply) end
    end)

    concommand.Add("eft_spawn_raid_gate", function(p) if IsValid(p) and not p:IsAdmin() then return end local e=ents.Create("eft_raid_gate") if IsValid(e) then e:SetPos(IsValid(p) and p:GetEyeTrace().HitPos+Vector(0,0,8) or Vector()) e:Spawn() end end)
    concommand.Add("eft_spawn_raid_entry", function(p) if IsValid(p) and not p:IsAdmin() then return end local e=ents.Create("eft_raid_entry") if IsValid(e) then e:SetPos(IsValid(p) and p:GetEyeTrace().HitPos+Vector(0,0,8) or Vector()) e:Spawn() end end)
    concommand.Add("eft_spawn_raid_extract", function(p) if IsValid(p) and not p:IsAdmin() then return end local e=ents.Create("eft_raid_extract") if IsValid(e) then e:SetPos(IsValid(p) and p:GetEyeTrace().HitPos+Vector(0,0,8) or Vector()) e:Spawn() end end)
    concommand.Add("eft_spawn_raid_return", function(p) if IsValid(p) and not p:IsAdmin() then return end local e=ents.Create("eft_raid_return") if IsValid(e) then e:SetPos(IsValid(p) and p:GetEyeTrace().HitPos+Vector(0,0,8) or Vector()) e:Spawn() end end)

    print("[EFT-COMPLETE] Server systems ready.")
end


-- ============================================================================
-- CLIENT UNIFIED DESK + RAID HUD
-- ============================================================================
if CLIENT then
    local C = {
        bg = Color(12, 12, 11, 252), panel = Color(22, 18, 14), cell = Color(32, 26, 18),
        cellLine = Color(80, 50, 20), accent = Color(220, 110, 30), accent2 = Color(235, 160, 50),
        stash = Color(200, 100, 40), text = Color(245, 240, 230), dim = Color(160, 130, 90),
        good = Color(100, 180, 90), warn = Color(235, 180, 40), bad = Color(200, 70, 55),
        use = Color(255, 220, 160), header = Color(10, 9, 8), med = Color(220, 140, 50),
    }
    local desk
    local D = {
        personal={}, rig={}, backpack={}, secure={}, stash={},
        pants={}, shirt={},
        equip={}, money=0, weight=0, capacity=15,
        pW=2, pH=5, rW=0, rH=0, bW=0, bH=0, sW=2, sH=2, stW=10, stH=14,
        pantsW=2, pantsH=2, shirtW=2, shirtH=3,
        insReady=0, limbs={}, meds={}, lootValue=0, hotbar={},
    }
    local function Rarity(db)
        return (db and EFT.Rarity and EFT.Rarity[db.rarity]) or { color = Color(180,180,180) }
    end
    local function IsEquippable(db)
        if not db then return false end
        return db.type == "backpack" or db.type == "rig" or (db.type == "armor" and db.armorSlot ~= nil)
    end
    local function IsUsable(db)
        if not db then return false end
        return db.type == "food" or db.type == "medicine" or IsEquippable(db) or db.type == "attachment"
    end
    local function Icon(parent, model, size, ox, oy)
        if not model or model == "" then return end
        local ic = vgui.Create("SpawnIcon", parent)
        ic:SetSize(size, size) ic:SetPos(ox or 2, oy or 2)
        ic:SetModel(model) ic:SetMouseInputEnabled(false)
        return ic
    end
    local function DrawGrid(pnl, gw, gh, cell)
        for x = 0, gw - 1 do
            for y = 0, gh - 1 do
                draw.RoundedBox(0, x*cell, y*cell, cell-1, cell-1, C.cell)
                surface.SetDrawColor(C.cellLine) surface.DrawOutlinedRect(x*cell, y*cell, cell, cell)
            end
        end
    end

    local function ItemBtn(parent, item, cell, kind)
        local db = EFT.ItemDatabase[item.id] if not db then return end
        local rar, usable = Rarity(db), IsUsable(db)
        local iw, ih = item.w * cell - 3, item.h * cell - 3
        local btn = vgui.Create("DButton", parent)
        btn:SetPos((item.x-1)*cell+1, (item.y-1)*cell+1)
        btn:SetSize(iw, ih) btn:SetText("")
        btn:SetMouseInputEnabled(true)
        Icon(btn, db.model, math.min(iw,ih)-4, 2, 2)
        btn.Paint = function(self, w, h)
            local hv = self:IsHovered()
            draw.RoundedBox(2, 0, 0, w, h, Color(26,28,30,245))
            local oc = usable and C.use or rar.color
            surface.SetDrawColor(oc.r, oc.g, oc.b, hv and 255 or (usable and 210 or 130))
            surface.DrawOutlinedRect(0, 0, w, h)
            if usable then surface.DrawOutlinedRect(1, 1, w-2, h-2) end
            if item.fir then draw.SimpleText("FIR", "Default", w-3, 1, C.good, TEXT_ALIGN_RIGHT) end
            if db.maxStack and item.count then draw.SimpleText(item.count, "DermaDefaultBold", w-3, h-13, C.text, TEXT_ALIGN_RIGHT)
            elseif item.uses then draw.SimpleText(item.uses.."x", "DermaDefaultBold", w-3, h-13, C.warn, TEXT_ALIGN_RIGHT)
            elseif item.hp then draw.SimpleText(item.hp, "DermaDefaultBold", w-3, h-13, C.good, TEXT_ALIGN_RIGHT) end
        end
        btn.DoDoubleClick = function()
            if db.type == "attachment" then
                net.Start("EFT_ApplyAttachment") net.WriteString(item.uniqueID) net.SendToServer() return
            end
            if db.type == "food" then
                net.Start("EFT_ConsumeItem") net.WriteString(item.uniqueID) net.SendToServer()
                timer.Simple(0.2, function() net.Start("EFT_RequestExtended") net.SendToServer() end)
                return
            end
            if db.type == "medicine" then
                if IsValid(desk) then desk._selMed = item.uniqueID desk._selMedName = db.name end
                return
            end
            if not IsEquippable(db) then return end
            local slot = db.type == "armor" and db.armorSlot or db.type
            net.Start("EFT_EquipItem") net.WriteString(item.uniqueID) net.WriteString(slot) net.SendToServer()
            timer.Simple(0.25, function() net.Start("EFT_RequestExtended") net.SendToServer() end)
        end
        btn.DoRightClick = function()
            local m = DermaMenu()
            if db.type == "attachment" then
                m:AddOption("★ Надеть на оружие (Z-City)", function()
                    net.Start("EFT_ApplyAttachment") net.WriteString(item.uniqueID) net.SendToServer()
                end)
            end
            if IsEquippable(db) then
                m:AddOption("★ Экипировать", function()
                    local slot = db.type == "armor" and db.armorSlot or db.type
                    net.Start("EFT_EquipItem") net.WriteString(item.uniqueID) net.WriteString(slot) net.SendToServer()
                    timer.Simple(0.25, function() net.Start("EFT_RequestExtended") net.SendToServer() end)
                end)
            end
            if db.type == "medicine" then
                m:AddOption("Выбрать для лечения", function()
                    if IsValid(desk) then desk._selMed = item.uniqueID desk._selMedName = db.name end
                end)
            end
            if db.type == "food" then
                m:AddOption("Съесть", function()
                    net.Start("EFT_ConsumeItem") net.WriteString(item.uniqueID) net.SendToServer()
                    timer.Simple(0.2, function() net.Start("EFT_RequestExtended") net.SendToServer() end)
                end)
            end
            m:AddOption("Выбросить", function()
                net.Start("EFT_DropItem") net.WriteString(tostring(item.uniqueID or "")) net.SendToServer()
                timer.Simple(0.2, function() net.Start("EFT_RequestExtended") net.SendToServer() end)
            end)
            m:Open()
        end

        -- ЛКМ: использование (еда/медицина/экип) без удержания; удержание — drag
        local function UseItemNow()
            if db.type == "food" then
                net.Start("EFT_ConsumeItem") net.WriteString(item.uniqueID) net.SendToServer()
                timer.Simple(0.2, function() net.Start("EFT_RequestExtended") net.SendToServer() end)
                return true
            end
            if db.type == "medicine" then
                if IsValid(desk) then
                    desk._selMed = item.uniqueID
                    desk._selMedName = db.name
                end
                surface.PlaySound("buttons/button15.wav")
                return true
            end
            if db.type == "attachment" then
                net.Start("EFT_ApplyAttachment") net.WriteString(item.uniqueID) net.SendToServer()
                return true
            end
            if IsEquippable(db) then
                local slot = db.type == "armor" and db.armorSlot or db.type
                net.Start("EFT_EquipItem") net.WriteString(item.uniqueID) net.WriteString(slot) net.SendToServer()
                timer.Simple(0.25, function() net.Start("EFT_RequestExtended") net.SendToServer() end)
                return true
            end
            return false
        end

        btn.DoClick = function(self)
            -- если был drag — не используем
            if self._dragged then return end
            UseItemNow()
        end

        -- Перетаскивание: capture только после порога, чтобы не ломать клики
        btn.OnMousePressed = function(self, key)
            if key ~= MOUSE_LEFT then return end
            self._drag = true
            self._dragged = false
            self._ox, self._oy = self:GetPos()
            self._pressTime = CurTime()
        end
        btn.Think = function(self)
            if not self._drag then return end
            local mx, my = self:CursorPos()
            if not self._dragged and (math.abs(mx) > 8 or math.abs(my) > 8) then
                self._dragged = true
                self:MouseCapture(true)
            end
            if self._dragged then
                local px, py = parent:LocalCursorPos()
                self:SetPos(px - self:GetWide()/2, py - self:GetTall()/2)
            end
        end
        btn.OnMouseReleased = function(self, key)
            if key ~= MOUSE_LEFT or not self._drag then return end
            local wasDrag = self._dragged
            self._drag = false
            self:MouseCapture(false)
            if not wasDrag then
                self:SetPos(self._ox or 0, self._oy or 0)
                self._dragged = false
                -- DoClick сработает сам у DButton
                return
            end
            -- после drag сбрасываем флаг после DoClick
            timer.Simple(0, function()
                if IsValid(self) then self._dragged = false end
            end)
            local targetKind, targetPanel, tgW, tgH = nil, nil, nil, nil
            local foundGrid = false
            if IsValid(desk) then
                for _, child in ipairs(desk:GetChildren()) do
                    if child._eftGridKind and IsValid(child) then
                        local cx, cy = child:CursorPos()
                        if cx >= 0 and cy >= 0 and cx <= child:GetWide() and cy <= child:GetTall() then
                            targetKind = child._eftGridKind
                            targetPanel = child
                            tgW, tgH = child._eftGW, child._eftGH
                            foundGrid = true
                            break
                        end
                    end
                end
            end
            -- Если отпустили ВНЕ любой сетки — выбрасываем предмет на землю
            if not foundGrid then
                net.Start("EFT_DropItem")
                    net.WriteString(tostring(item.uniqueID or ""))
                net.SendToServer()
                timer.Simple(0.2, function()
                    net.Start("EFT_RequestExtended") net.SendToServer()
                end)
                return
            end
            local lx, ly = targetPanel:CursorPos()
            local newX = math.max(1, math.floor(lx / cell) + 1)
            local newY = math.max(1, math.floor(ly / cell) + 1)
            if tgW then newX = math.min(newX, tgW) end
            if tgH then newY = math.min(newY, tgH) end
            net.Start("EFT_MoveItem")
                net.WriteString(tostring(item.uniqueID or ""))
                net.WriteUInt(newX, 8)
                net.WriteUInt(newY, 8)
                net.WriteString(targetKind or kind or "pants")
            net.SendToServer()
            timer.Simple(0.15, function()
                net.Start("EFT_RequestExtended") net.SendToServer()
            end)
        end
        return btn
    end

    local function BuildChar(parent, x, y, colW, colH)
        local root = vgui.Create("DPanel", parent)
        root:SetPos(x, y) root:SetSize(colW, colH)
        root.Paint = function(s, w, h)
            draw.RoundedBox(4, 0, 0, w, h, C.panel)
            surface.SetDrawColor(C.cellLine) surface.DrawOutlinedRect(0, 0, w, h)
        end
        local slotW, slotH = 70, 56
        local function EqSlot(sx, sy, label, id, slot)
            local p = vgui.Create("DPanel", root)
            p:SetPos(sx, sy) p:SetSize(slotW, slotH)
            local db = id ~= "" and EFT.ItemDatabase[id] or nil
            p.Paint = function(self, w, h)
                draw.RoundedBox(3, 0, 0, w, h, Color(14,15,17))
                surface.SetDrawColor(db and Rarity(db).color or C.cellLine)
                surface.DrawOutlinedRect(0, 0, w, h)
                draw.SimpleText(label, "Default", w/2, 2, C.dim, TEXT_ALIGN_CENTER)
                if not db then draw.SimpleText("—", "DermaDefault", w/2, h/2+4, Color(50,50,52), TEXT_ALIGN_CENTER) end
            end
            if db then
                Icon(p, db.model, 28, (slotW-28)/2, 16)
                local u = vgui.Create("DButton", p)
                u:SetText("×") u:SetPos(slotW-16, 2) u:SetSize(14, 14)
                u.Paint = function(s,w,h) draw.RoundedBox(2,0,0,w,h,s:IsHovered() and C.bad or Color(40,40,42)) end
                u:SetTextColor(C.text)
                u.DoClick = function()
                    net.Start("EFT_UnequipItem") net.WriteString(slot) net.SendToServer()
                    timer.Simple(0.25, function() net.Start("EFT_RequestExtended") net.SendToServer() end)
                end
            end
        end
        -- КВАДРАТНОЕ ПРЕВЬЮ ПЕРСОНАЖА (DModelPanel) + имя сбоку
        local sq = math.min(160, colW - 100)
        local nameW = colW - sq - 16

        local sqFrame = vgui.Create("DPanel", root)
        sqFrame:SetPos(6, 6)
        sqFrame:SetSize(sq, sq)
        sqFrame.Paint = function(s, w, h)
            draw.RoundedBox(4, 0, 0, w, h, Color(12, 12, 11))
            surface.SetDrawColor(180, 165, 120)
            surface.DrawOutlinedRect(0, 0, w, h, 2)
        end

        local mdl = vgui.Create("DModelPanel", sqFrame)
        mdl:SetPos(2, 2)
        mdl:SetSize(sq - 4, sq - 4)
        -- Камера: видно лицо и верх тела (не обрезано)
        mdl:SetFOV(42)
        mdl:SetCamPos(Vector(48, 18, 58))
        mdl:SetLookAt(Vector(0, 0, 52))
        local ply = LocalPlayer()
        if IsValid(ply) then
            mdl:SetModel(ply:GetModel())
            local ent = mdl:GetEntity()
            if IsValid(ent) then
                ent:SetSkin(ply:GetSkin() or 0)
                for i = 0, (ply:GetNumBodyGroups() or 1) - 1 do
                    ent:SetBodygroup(i, ply:GetBodygroup(i))
                end
                -- чуть приподнять модель, чтобы голова в кадре
                local mn, mx = ent:GetRenderBounds()
                if mn and mx then
                    local center = (mn + mx) * 0.5
                    mdl:SetLookAt(Vector(center.x, center.y, mx.z - 8))
                    mdl:SetCamPos(Vector(center.x + 42, center.y + 16, mx.z - 4))
                end
            end
        end
        function mdl:LayoutEntity(ent)
            if IsValid(ent) then
                ent:SetAngles(Angle(0, 35, 0))
                ent:SetPos(Vector(0, 0, 2))
            end
        end

        local namePanel = vgui.Create("DPanel", root)
        namePanel:SetPos(sq + 12, 6)
        namePanel:SetSize(nameW, sq)
        namePanel.Paint = function(s, w, h)
            local nick = IsValid(LocalPlayer()) and LocalPlayer():Nick() or "Оператор"
            draw.SimpleText(nick, "DermaDefaultBold", 0, 8, Color(220, 218, 210))
            local sk = EFT.ClientSkills or {}
            draw.SimpleText("Репутация: " .. tostring(sk.reputation or 0), "Default", 0, 32, Color(180, 165, 120))
            draw.SimpleText("Навык: " .. tostring(sk.level or 1), "Default", 0, 50, Color(140, 138, 120))
            draw.SimpleText("Перки: " .. tostring(sk.perkPoints or 0), "Default", 0, 68, Color(140, 138, 120))
            draw.SimpleText("Штаны 2×2 · Кофта 2×3", "Default", 0, h - 36, Color(180, 120, 50))
            draw.SimpleText("[P] лист персонажа", "Default", 0, h - 18, Color(160, 110, 50))
        end

        -- ==========================================
        -- СХЕМА ЭКИПИРОВКИ (как на схеме):
        --           [ Голова ]
        -- [Лев.рука] [Бронежилет] [Прав.рука]
        --           [Разгрузка]
        --           [ Рюкзак ]
        -- Оружие в руках: холодное/пистолет = 1 рука, автомат/винтовка/дробовик = 2 руки
        -- ==========================================
        local leftWep, rightWep, twoHanded = EFT.ResolveHandWeapons(LocalPlayer())

        local function HandSlot(sx, sy, label, wepID, isLockedByTwoHand)
            local p = vgui.Create("DPanel", root)
            p:SetPos(sx, sy) p:SetSize(slotW, slotH + 8)
            local db = (wepID and wepID ~= "") and EFT.ItemDatabase[wepID] or nil
            local displayName = db and db.name or (wepID ~= "" and wepID or nil)
            p.Paint = function(self, w, h)
                local bg = isLockedByTwoHand and Color(18, 16, 14) or Color(14, 15, 17)
                draw.RoundedBox(3, 0, 0, w, h, bg)
                local border = db and Rarity(db).color or (isLockedByTwoHand and Color(180, 120, 50) or C.cellLine)
                surface.SetDrawColor(border)
                surface.DrawOutlinedRect(0, 0, w, h)
                draw.SimpleText(label, "Default", w/2, 2, C.dim, TEXT_ALIGN_CENTER)
                if isLockedByTwoHand and not db then
                    draw.SimpleText("2 руки", "Default", w/2, h/2+2, Color(180, 120, 50), TEXT_ALIGN_CENTER)
                elseif not displayName then
                    draw.SimpleText("—", "DermaDefault", w/2, h/2+4, Color(50,50,52), TEXT_ALIGN_CENTER)
                end
            end
            if db then
                Icon(p, db.model, 28, (slotW-28)/2, 14)
                local nm = vgui.Create("DLabel", p)
                nm:SetPos(2, slotH - 6) nm:SetSize(slotW-4, 14)
                nm:SetFont("Default") nm:SetTextColor(C.text)
                nm:SetContentAlignment(5)
                local short = displayName
                if #short > 11 then short = string.sub(short, 1, 10) .. "…" end
                nm:SetText(short)
            elseif wepID and wepID ~= "" and not isLockedByTwoHand then
                local nm = vgui.Create("DLabel", p)
                nm:SetPos(2, 18) nm:SetSize(slotW-4, 28)
                nm:SetFont("Default") nm:SetTextColor(C.dim)
                nm:SetContentAlignment(5) nm:SetWrap(true)
                nm:SetText(wepID)
            end
            return p
        end

        local eqY = sq + 14
        local cx = colW / 2
        local gap = 4
        local colLeft = 6
        local colRight = colW - slotW - 6
        local colMid = cx - slotW / 2

        -- Голова (шлем) по центру сверху
        EqSlot(colMid, eqY, "ГОЛОВА", D.equip.helmet or "", "helmet")

        -- Ряд: левая рука | бронежилет | правая рука
        local row2 = eqY + slotH + gap
        HandSlot(colLeft, row2, "ЛЕВ. РУКА", leftWep, twoHanded and leftWep == rightWep)
        EqSlot(colMid, row2, "БРОНЕЖИЛЕТ", D.equip.vest or "", "vest")
        HandSlot(colRight, row2, "ПРАВ. РУКА", rightWep, false)

        -- Разгрузка и рюкзак столбиком по центру
        local row3 = row2 + slotH + 8 + gap
        EqSlot(colMid, row3, "РАЗГРУЗКА", D.equip.rig or "", "rig")
        local row4 = row3 + slotH + gap
        EqSlot(colMid, row4, "РЮКЗАК", D.equip.backpack or "", "backpack")

        -- Маска / наушники компактно сбоку от разгрузки
        EqSlot(colLeft, row3, "МАСКА", D.equip.mask or "", "mask")
        EqSlot(colRight, row3, "НАУШН.", D.equip.headphones or "", "headphones")

        -- Подсказка по занятым рукам
        local hintY = row4 + slotH + 2
        local handHint = vgui.Create("DLabel", root)
        handHint:SetPos(6, hintY)
        handHint:SetSize(colW - 12, 16)
        handHint:SetFont("Default")
        handHint:SetTextColor(Color(160, 140, 100))
        handHint:SetContentAlignment(5)
        if twoHanded then
            local n = (EFT.ItemDatabase[rightWep] and EFT.ItemDatabase[rightWep].name) or rightWep
            handHint:SetText("Обе руки: " .. tostring(n))
        elseif leftWep ~= "" or rightWep ~= "" then
            handHint:SetText("Одноручное оружие в руках")
        else
            handHint:SetText("Руки свободны")
        end

        local limbY = hintY + 18
        local limbPanel = vgui.Create("DPanel", root)
        limbPanel:SetPos(6, limbY)
        limbPanel:SetSize(colW - 12, 28)
        limbPanel.Paint = function() end
        local function LimbChip(limb, lx, label)
            local b = vgui.Create("DButton", limbPanel)
            b:SetPos(lx, 0) b:SetSize(36, 26) b:SetText("")
            b.Paint = function(self, bw, bh)
                local cur = D.limbs[limb] or 0
                local max = (EFT.Config.LimbMaxHealth and EFT.Config.LimbMaxHealth[limb]) or 100
                local r = math.Clamp(cur / math.max(max, 1), 0, 1)
                local col = r > 0.6 and C.good or (r > 0.3 and C.warn or C.bad)
                draw.RoundedBox(2, 0, 0, bw, bh, Color(12,13,15,230))
                draw.RoundedBox(1, 1, bh-3, (bw-2)*r, 2, col)
                surface.SetDrawColor(col) surface.DrawOutlinedRect(0, 0, bw, bh)
                draw.SimpleText(label, "Default", bw/2, 4, C.dim, TEXT_ALIGN_CENTER)
                if self:IsHovered() and IsValid(desk) and desk._selMed then
                    surface.SetDrawColor(C.med) surface.DrawOutlinedRect(0, 0, bw, bh, 2)
                end
            end
            b.DoClick = function()
                if not IsValid(desk) or not desk._selMed then return end
                net.Start("EFT_ApplyMedLimb") net.WriteString(desk._selMed) net.WriteString(limb) net.SendToServer()
                desk._selMed = nil desk._selMedName = nil
                surface.PlaySound("items/medshot4.wav")
            end
        end
        local limbsList = { {"head","ГЛ"}, {"thorax","ГР"}, {"stomach","ЖВ"}, {"leftarm","ЛР"}, {"rightarm","ПР"}, {"leftleg","ЛН"}, {"rightleg","ПН"} }
        for i, L in ipairs(limbsList) do
            LimbChip(L[1], (i - 1) * 38, L[2])
        end

        local medY = limbY + 34
        local medPanel = vgui.Create("DPanel", root)
        medPanel:SetPos(6, medY)
        medPanel:SetSize(colW-12, math.max(80, colH-medY-8))
        medPanel.Paint = function(self, w, h)
            draw.RoundedBox(3, 0, 0, w, h, Color(12,14,16))
            surface.SetDrawColor(C.med) surface.DrawOutlinedRect(0, 0, w, h)
            draw.SimpleText("МЕДИЦИНА", "DermaDefaultBold", 8, 4, C.med)
            if IsValid(desk) and desk._selMed then
                draw.SimpleText("→ "..(desk._selMedName or "").." (клик по телу)", "Default", 90, 5, C.accent)
            else
                draw.SimpleText("выбери препарат → часть тела", "Default", 90, 5, C.dim)
            end
        end
        local medScroll = vgui.Create("DScrollPanel", medPanel)
        medScroll:SetPos(4, 22)
        medScroll:SetSize(colW-20, math.max(50, colH-medY-36))
        if #(D.meds or {}) == 0 then
            local empty = medScroll:Add("DLabel")
            empty:SetText("  нет медикаментов") empty:SetTextColor(C.dim) empty:Dock(TOP) empty:SetTall(20)
        else
            for _, med in ipairs(D.meds or {}) do
                local db = EFT.ItemDatabase[med.id] if not db then continue end
                local row = medScroll:Add("DButton")
                row:Dock(TOP) row:SetTall(34) row:DockMargin(0,0,2,3) row:SetText("")
                row.Paint = function(s, w, h)
                    local sel = IsValid(desk) and desk._selMed == med.uniqueID
                    draw.RoundedBox(3, 0, 0, w, h, sel and Color(25,50,45) or Color(18,20,22))
                    surface.SetDrawColor(sel and C.med or C.cellLine) surface.DrawOutlinedRect(0, 0, w, h)
                    draw.SimpleText(db.name, "DermaDefaultBold", 8, 4, C.text)
                    local info = (med.uses and (med.uses.." исп.")) or (med.hp and (med.hp.." hp")) or ""
                    draw.SimpleText(info.."  +"..(db.healAmount or 30).." HP", "Default", 8, 18, C.good)
                end
                row.DoClick = function()
                    if IsValid(desk) then desk._selMed = med.uniqueID desk._selMedName = db.name end
                end
            end
        end
        return root
    end

    local function OpenDesk(withStash)
        if ZCityEFTEmptyInventory then ZCityEFTEmptyInventory.Open(true) end
    end

    net.Receive("EFT_SyncExtended", function()
        D.personal = net.ReadTable() or {}
        D.rig = net.ReadTable() or {}
        D.backpack = net.ReadTable() or {}
        D.secure = net.ReadTable() or {}
        local hasStash = net.ReadBool()
        if hasStash then D.stash = net.ReadTable() or {} end
        D.equip = {
            backpack = net.ReadString(), vest = net.ReadString(), helmet = net.ReadString(),
            rig = net.ReadString(), mask = net.ReadString(), headphones = net.ReadString(),
        }
        D.money = net.ReadInt(32)
        D.weight = net.ReadFloat() D.capacity = net.ReadFloat()
        D.pW = net.ReadUInt(8) D.pH = net.ReadUInt(8)
        D.rW = net.ReadUInt(8) D.rH = net.ReadUInt(8)
        D.bW = net.ReadUInt(8) D.bH = net.ReadUInt(8)
        D.sW = net.ReadUInt(4) D.sH = net.ReadUInt(4)
        D.stW = net.ReadUInt(8) D.stH = net.ReadUInt(8)
        D.insReady = net.ReadUInt(8)
        D.limbs = net.ReadTable() or {}
        D.meds = net.ReadTable() or {}
        D.lootValue = net.ReadInt(32)
        D.hotbar = net.ReadTable() or {}
        D.pants = net.ReadTable() or {}
        D.shirt = net.ReadTable() or {}
        D.pantsW = net.ReadUInt(4) D.pantsH = net.ReadUInt(4)
        D.shirtW = net.ReadUInt(4) D.shirtH = net.ReadUInt(4)
        OpenDesk(hasStash)
    end)

    -- I key → our desk
    local wasI = false
    -- I key is handled by cl_eft_empty_inventory.lua.


    -- Block old inventory/medicine spam from main when our desk works
    hook.Add("Think", "EFT_Complete_BlockOldI", function()
        -- main also listens I - both fire; RequestExtended is enough
    end)

    -- Raid hold input
    local holdFrac, holdDur, holding, holdKind, lookEnt = 0, 0, false, "", nil
    local wasUse = false
    hook.Add("Think", "EFT_Complete_RaidHold", function()
        local ply = LocalPlayer()
        if not IsValid(ply) or not ply:Alive() or vgui.CursorVisible() then
            if holding then net.Start("EFT_Raid_HoldCancel") net.SendToServer() holding = false end
            wasUse = IsValid(ply) and ply:KeyDown(IN_USE) or false
            lookEnt = nil return
        end
        lookEnt = nil
        local tr = ply:GetEyeTrace()
        if IsValid(tr.Entity) then
            local cls = tr.Entity:GetClass()
            if (cls == "eft_raid_gate" or cls == "eft_raid_extract")
                and ply:GetPos():DistToSqr(tr.Entity:GetPos()) <= (EFT.Config.Raid.UseDistance or 140)^2 then
                lookEnt = tr.Entity
            end
        end
        local use = ply:KeyDown(IN_USE)
        if lookEnt and use and not wasUse and not holding then
            net.Start("EFT_Raid_HoldStart") net.WriteEntity(lookEnt) net.SendToServer()
            holding = true
        elseif holding and (not use or not lookEnt) then
            net.Start("EFT_Raid_HoldCancel") net.SendToServer()
            holding, holdFrac = false, 0
        end
        wasUse = use
    end)
    net.Receive("EFT_Raid_HoldProgress", function()
        holdFrac = net.ReadFloat() holdDur = net.ReadFloat() holding = net.ReadBool() holdKind = net.ReadString() or ""
        if not holding then holdFrac = 0 end
    end)
    net.Receive("EFT_Raid_EnteredRaid", function()
        surface.PlaySound("ambient/machines/teleport1.wav")
        notification.AddLegacy("[EFT] Телепорт в рейд!", NOTIFY_GENERIC, 4)
    end)
    net.Receive("EFT_Raid_ExtractDone", function()
        local data = net.ReadTable() or {}
        holding, holdFrac = false, 0
        surface.PlaySound("ambient/machines/teleport1.wav")
        notification.AddLegacy(string.format("[EFT] Экстракт! Лут %s₽", string.Comma(data.lootValue or 0)), NOTIFY_GENERIC, 6)
    end)
    net.Receive("EFT_LockerNoise", function()
        local pos = net.ReadVector()
        sound.Play("doors/door_metal_large_chamber_close1.wav", pos, 65, 100, 0.6)
    end)

    hook.Add("HUDPaint", "EFT_Complete_HUD", function()
        if lookEnt and not holding then
            local cls = lookEnt:GetClass()
            local msg = cls == "eft_raid_gate" and "Удерживайте [E] — вход в рейд" or "Удерживайте [E] — экстракт"
            draw.SimpleText(msg, "DermaDefaultBold", ScrW()/2, ScrH()/2+48, Color(80,200,120), TEXT_ALIGN_CENTER)
        end
        if holding and holdDur > 0 then
            local w, h = 300, 22
            local x, y = ScrW()/2-w/2, ScrH()/2+70
            local label = holdKind == "gate" and "ВХОД В РЕЙД" or "ЭКСТРАКТ"
            draw.RoundedBox(4, x-2, y-2, w+4, h+4, Color(0,0,0,200))
            draw.RoundedBox(4, x, y, w, h, Color(20,24,20))
            draw.RoundedBox(4, x, y, w*holdFrac, h, holdKind == "gate" and Color(220,150,40) or Color(60,180,90))
            draw.SimpleText(string.format("%s  %.1f с", label, math.max(0, holdDur*(1-holdFrac))),
                "DermaDefaultBold", ScrW()/2, y+h/2, color_white, TEXT_ALIGN_CENTER, TEXT_ALIGN_CENTER)
        end
        local ply = LocalPlayer()
        if IsValid(ply) and ply:GetNWBool("EFT_InRaid", false) then
            draw.SimpleTextOutlined("● REID", "DermaDefaultBold", ScrW()-12, 12, Color(255,160,60), TEXT_ALIGN_RIGHT, TEXT_ALIGN_TOP, 1, Color(0,0,0,180))
        end
    end)

    -- Stash locker F
    local wasF, fLocker = false, nil
    hook.Add("Think", "EFT_Complete_LockerF", function()
        local ply = LocalPlayer()
        if not IsValid(ply) or not ply:Alive() or vgui.CursorVisible() then
            wasF = input.IsKeyDown(KEY_F) fLocker = nil return
        end
        fLocker = nil
        local tr = ply:GetEyeTrace()
        if IsValid(tr.Entity) and tr.Entity:GetClass() == "eft_stash_locker" then
            local dist = (EFT.Config.Locker and EFT.Config.Locker.UseDistance) or 100
            if ply:GetPos():DistToSqr(tr.Entity:GetPos()) <= dist*dist then fLocker = tr.Entity end
        end
        local down = input.IsKeyDown(KEY_F)
        if down and not wasF and IsValid(fLocker) then
            net.Start("EFT_RequestStash") net.WriteEntity(fLocker) net.SendToServer()
        end
        wasF = down
    end)
    hook.Add("HUDPaint", "EFT_Complete_LockerHint", function()
        if not IsValid(fLocker) then return end
        local cx, cy = ScrW() / 2, ScrH() / 2 + 42
        local size = 28
        local x, y = cx - size / 2, cy - size / 2
        draw.RoundedBox(4, x + 1, y + 1, size, size, Color(0, 0, 0, 160))
        draw.RoundedBox(4, x, y, size, size, Color(12, 12, 12, 230))
        surface.SetDrawColor(160, 120, 255, 200)
        surface.DrawOutlinedRect(x, y, size, size, 1)
        draw.SimpleText("F", "DermaDefaultBold", cx, cy, Color(240, 240, 240), TEXT_ALIGN_CENTER, TEXT_ALIGN_CENTER)
    end)

    concommand.Add("eft_return_att", function(_, _, args)
        local class = args[1]
        if not class then chat.AddText(Color(255,180,60), "[EFT] ", color_white, "eft_return_att ent_att_supressor1") return end
        net.Start("EFT_ReturnAttachment") net.WriteString(class) net.SendToServer()
    end)

    print("[EFT-COMPLETE] Client desk + raid HUD ready.")
end

print("[EFT-COMPLETE v12] Unified addon loaded — one file, all systems.")


--################################################################################
--#  EFT TARKOV MECHANICS + UI HARDENING (v12.2)
--################################################################################

if SERVER then
    -- Energy / Hydration (Tarkov-like vitals)
    EFT.Config.Vitals = EFT.Config.Vitals or {
        Enabled = true,
        MaxEnergy = 100, MaxHydration = 100,
        DrainEnergy = 0.015,   -- per second
        DrainHydration = 0.022,
        LowThreshold = 20,
        DamageWhenEmpty = 1,
        DamageInterval = 8,
    }
    EFT.PlayerVitals = EFT.PlayerVitals or {}

    local function GetVitals(ply)
        EFT.PlayerVitals[ply] = EFT.PlayerVitals[ply] or { energy = 80, hydration = 85 }
        return EFT.PlayerVitals[ply]
    end

    util.AddNetworkString("EFT_SyncVitals")
    local function SyncVitals(ply)
        if not IsValid(ply) then return end
        local v = GetVitals(ply)
        net.Start("EFT_SyncVitals")
            net.WriteFloat(v.energy or 0)
            net.WriteFloat(v.hydration or 0)
        net.Send(ply)
    end

    hook.Add("Think", "EFT_Tarkov_VitalsDrain", function()
        if not EFT.Config.Vitals.Enabled then return end
        local cfg = EFT.Config.Vitals
        for _, ply in ipairs(player.GetAll()) do
            if not IsValid(ply) or not ply:Alive() then continue end
            local v = GetVitals(ply)
            v.energy = math.max(0, (v.energy or 0) - cfg.DrainEnergy * FrameTime())
            v.hydration = math.max(0, (v.hydration or 0) - cfg.DrainHydration * FrameTime())
            ply.EFT_VitalTick = (ply.EFT_VitalTick or 0) + FrameTime()
            if ply.EFT_VitalTick >= (cfg.DamageInterval or 8) then
                ply.EFT_VitalTick = 0
                if v.energy <= 0 or v.hydration <= 0 then
                    local dmg = DamageInfo()
                    dmg:SetDamage(cfg.DamageWhenEmpty or 1)
                    dmg:SetAttacker(ply)
                    dmg:SetDamageType(DMG_GENERIC)
                    ply:TakeDamageInfo(dmg)
                end
                SyncVitals(ply)
            end
        end
    end)

    -- Food restores energy/hydration
    hook.Add("EFT_OnConsumeFood", "EFT_Tarkov_FoodVitals", function(ply, db)
        if not IsValid(ply) or not db then return end
        local v = GetVitals(ply)
        v.energy = math.min(EFT.Config.Vitals.MaxEnergy, (v.energy or 0) + (db.energy or 25))
        v.hydration = math.min(EFT.Config.Vitals.MaxHydration, (v.hydration or 0) + (db.hydration or 15))
        SyncVitals(ply)
    end)

    -- Patch consume to fire hook if not already
    local _consumeDone = false
    timer.Simple(1, function()
        if _consumeDone then return end
        _consumeDone = true
        -- wrap via net re-register is risky; instead hook Player say
    end)

    -- When consuming food via existing EFT_ConsumeItem — post process
    hook.Add("PlayerSpawn", "EFT_Tarkov_VitalsReset", function(ply)
        timer.Simple(0.5, function()
            if not IsValid(ply) then return end
            -- only reset if empty
            local v = GetVitals(ply)
            if not v.energy or v.energy <= 0 then v.energy = 80 end
            if not v.hydration or v.hydration <= 0 then v.hydration = 85 end
            SyncVitals(ply)
        end)
    end)

    -- Auto-loot examined items (Ctrl+take all) 
    util.AddNetworkString("EFT_LootAllExamined")
    net.Receive("EFT_LootAllExamined", function(_, ply)
        if not IsValid(ply) or not ply:Alive() then return end
        local storage = EFT.ContainerStorage
        local active = EFT.ActiveLooters and EFT.ActiveLooters[ply]
        if not storage or not IsValid(active) then return end
        local loot = storage[active]
        if not loot then return end
        local taken = 0
        for i = #loot, 1, -1 do
            local it = loot[i]
            if not it.examined then continue end
            local db = EFT.ItemDatabase[it.id]
            if not db then continue end
            local ok = false
            if db.type == "weapon" then
                if not ply:HasWeapon(it.id) then ply:Give(it.id) ok = true end
            elseif db.type == "ammo" and db.ammoName then
                ply:GiveAmmo(it.count or 1, db.ammoName) ok = true
            else
                if EFT.Improvements and EFT.Improvements.TryAddItem then
                    ok = EFT.Improvements.TryAddItem(ply, it.id, db, {
                        count = it.count, hp = it.hp, uses = it.uses, examined = true, fir = it.fir
                    })
                end
            end
            if ok then
                table.remove(loot, i)
                taken = taken + 1
            end
        end
        if taken > 0 then
            ply:ChatPrint("[EFT] Взято предметов: " .. taken)
            ply:EmitSound("items/itempickup.wav", 60, 100)
            -- resync via OpenLootMenu path
            if SyncLootState then
                -- local function may not be global; reopen
            end
            -- force open loot refresh
            net.Start("EFT_OpenLoot")
                net.WriteEntity(active)
                net.WriteTable(loot)
                net.WriteTable({})
                net.WriteString(active.CorpseOwner or "")
                local size = (EFT.ContainerGridSize and EFT.ContainerGridSize[active]) or { w = 8, h = 8 }
                net.WriteUInt(size.w or 8, 8)
                net.WriteUInt(size.h or 8, 8)
                local personal = (EFT.VirtualInventory and EFT.VirtualInventory[ply]) or {}
                local equip = (EFT.PlayerEquipment and EFT.PlayerEquipment[ply]) or {}
                net.WriteTable(personal)
                net.WriteUInt(EFT.Config.PersonalGridBaseW or 2, 8)
                net.WriteUInt(EFT.Config.PersonalGridBaseH or 5, 8)
                local rigItems, rW, rH = {}, 0, 0
                if equip.rigUID and EFT.RigContents then
                    rigItems = EFT.RigContents[equip.rigUID] or {}
                    local rd = EFT.ItemDatabase[equip.rig]
                    if rd and rd.gridSize then rW, rH = rd.gridSize.w, rd.gridSize.h end
                end
                net.WriteTable(rigItems) net.WriteUInt(rW, 8) net.WriteUInt(rH, 8)
                local bpItems, bW, bH = {}, 0, 0
                if equip.backpackUID and EFT.BackpackContents then
                    bpItems = EFT.BackpackContents[equip.backpackUID] or {}
                    local bd = EFT.ItemDatabase[equip.backpack]
                    if bd and bd.gridSize then bW, bH = bd.gridSize.w, bd.gridSize.h end
                end
                net.WriteTable(bpItems) net.WriteUInt(bW, 8) net.WriteUInt(bH, 8)
            net.Send(ply)
        else
            ply:ChatPrint("[EFT] Нечего взять (осмотрите предметы или нет места).")
        end
    end)

    -- Examine ALL unknown items in open container
    util.AddNetworkString("EFT_ExamineAll")
    net.Receive("EFT_ExamineAll", function(_, ply)
        if not IsValid(ply) then return end
        local storage = EFT.ContainerStorage
        local active = EFT.ActiveLooters and EFT.ActiveLooters[ply]
        if not storage or not IsValid(active) then return end
        local loot = storage[active]
        if not loot then return end
        local n = 0
        for _, it in ipairs(loot) do
            if not it.examined then it.examined = true n = n + 1 end
        end
        if n > 0 then
            ply:ChatPrint("[EFT] Осмотрено: " .. n)
            -- refresh
            net.Start("EFT_SearchContainerComplete") -- won't work from server
        end
        -- use same open refresh as loot all
        net.Start("EFT_OpenLoot")
            net.WriteEntity(active)
            net.WriteTable(loot)
            net.WriteTable({})
            net.WriteString(active.CorpseOwner or "")
            local size = (EFT.ContainerGridSize and EFT.ContainerGridSize[active]) or { w = 8, h = 8 }
            net.WriteUInt(size.w or 8, 8) net.WriteUInt(size.h or 8, 8)
            local personal = (EFT.VirtualInventory and EFT.VirtualInventory[ply]) or {}
            local equip = (EFT.PlayerEquipment and EFT.PlayerEquipment[ply]) or {}
            net.WriteTable(personal)
            net.WriteUInt(EFT.Config.PersonalGridBaseW or 2, 8)
            net.WriteUInt(EFT.Config.PersonalGridBaseH or 5, 8)
            local rigItems, rW, rH = {}, 0, 0
            if equip.rigUID and EFT.RigContents then
                rigItems = EFT.RigContents[equip.rigUID] or {}
                local rd = EFT.ItemDatabase[equip.rig]
                if rd and rd.gridSize then rW, rH = rd.gridSize.w, rd.gridSize.h end
            end
            net.WriteTable(rigItems) net.WriteUInt(rW, 8) net.WriteUInt(rH, 8)
            local bpItems, bW, bH = {}, 0, 0
            if equip.backpackUID and EFT.BackpackContents then
                bpItems = EFT.BackpackContents[equip.backpackUID] or {}
                local bd = EFT.ItemDatabase[equip.backpack]
                if bd and bd.gridSize then bW, bH = bd.gridSize.w, bd.gridSize.h end
            end
            net.WriteTable(bpItems) net.WriteUInt(bW, 8) net.WriteUInt(bH, 8)
        net.Send(ply)
    end)

    -- Ensure armor models get resolved and gear equip works after load
    hook.Add("PlayerSpawn", "EFT_Tarkov_NoAutoInventory", function(ply)
        -- prevent any delayed SyncPersonalInventory from opening UI
        timer.Simple(0.05, function()
            if not IsValid(ply) then return end
            -- nothing
        end)
    end)

    print("[EFT] Tarkov mechanics server OK (vitals, loot-all, examine-all).")
end

if CLIENT then
    -- Mark when old frames try to open — already swallowed by net.Receive
    -- Close any DFrame titled like old inventory if somehow created
    hook.Add("Think", "EFT_Tarkov_KillOldFrames", function()
        -- no-op: local frames are blocked via net.Receive swallow
    end)

    -- Vitals HUD (energy / hydration)
    local vitEnergy, vitHydration = 80, 85
    net.Receive("EFT_SyncVitals", function()
        vitEnergy = net.ReadFloat()
        vitHydration = net.ReadFloat()
    end)

    hook.Add("HUDPaint", "EFT_Tarkov_VitalsHUD", function()
        local ply = LocalPlayer()
        if not IsValid(ply) or not ply:Alive() then return end
        if not EFT.Config.Vitals or not EFT.Config.Vitals.Enabled then return end
        local x, y = 20, ScrH() - 70
        local w, h = 140, 10
        -- energy
        draw.RoundedBox(3, x, y, w, h, Color(20, 20, 18, 200))
        draw.RoundedBox(3, x, y, w * math.Clamp(vitEnergy / 100, 0, 1), h, Color(180, 150, 80))
        draw.SimpleText("ЭНЕРГИЯ", "Default", x, y - 12, Color(140, 138, 120))
        -- hydration
        draw.RoundedBox(3, x, y + 22, w, h, Color(20, 20, 18, 200))
        draw.RoundedBox(3, x, y + 22, w * math.Clamp(vitHydration / 100, 0, 1), h, Color(90, 140, 170))
        draw.SimpleText("ГИДРАТАЦИЯ", "Default", x, y + 10, Color(140, 138, 120))
    end)

    -- Loot UI buttons: examine all + take all (hook after dual menu opens via key)
    local wasCtrlQ, wasCtrlE = false, false
    hook.Add("Think", "EFT_Tarkov_LootHotkeys", function()
        if not IsValid(lootFrame) then wasCtrlQ = false wasCtrlE = false return end
        local ctrl = input.IsKeyDown(KEY_LCONTROL)
        local q = input.IsKeyDown(KEY_Q)
        local e = input.IsKeyDown(KEY_E)
        if ctrl and q and not wasCtrlQ then
            net.Start("EFT_LootAllExamined") net.SendToServer()
            surface.PlaySound("buttons/button14.wav")
        end
        if ctrl and e and not wasCtrlE then
            net.Start("EFT_ExamineAll") net.SendToServer()
            surface.PlaySound("buttons/button15.wav")
        end
        wasCtrlQ = ctrl and q
        wasCtrlE = ctrl and e
    end)

    -- Hint on loot frame
    hook.Add("HUDPaint", "EFT_Tarkov_LootHints", function()
        if not IsValid(lootFrame) then return end
        draw.SimpleText("Ctrl+E — осмотреть всё   ·   Ctrl+Q — взять всё осмотренное", "Default",
            ScrW() / 2, 8, Color(160, 155, 140), TEXT_ALIGN_CENTER)
    end)

    -- Food consume also request vitals refresh (server updates on next tick)
    print("[EFT] Tarkov client mechanics OK.")
end


-- ============================================================================
-- Pickup dropped items with F (backup if E/Use is blocked)
-- ============================================================================
if SERVER then
    util.AddNetworkString("EFT_PickupDrop")
    net.Receive("EFT_PickupDrop", function(_, ply)
        if not IsValid(ply) or not ply:Alive() then return end
        local ent = net.ReadEntity()
        if not IsValid(ent) then return end
        local cls = ent:GetClass()
        if cls ~= "eft_dropped_item" then return end
        if ply:GetPos():DistToSqr(ent:GetPos()) > 25000 then return end
        -- прямой вызов Use (как при нажатии E)
        if ent.Use then
            ent:Use(ply, ply, USE_ON, 0)
        end
    end)
end

if CLIENT then
    local wasFDrop = false
    hook.Add("Think", "EFT_PickupDrop_F", function()
        local ply = LocalPlayer()
        if not IsValid(ply) or not ply:Alive() or vgui.CursorVisible() then
            wasFDrop = input.IsKeyDown(KEY_F)
            return
        end
        local down = input.IsKeyDown(KEY_F)
        if down and not wasFDrop then
            local tr = ply:GetEyeTrace()
            if IsValid(tr.Entity) and tr.Entity:GetClass() == "eft_dropped_item"
                and ply:GetPos():DistToSqr(tr.Entity:GetPos()) <= 25000 then
                net.Start("EFT_PickupDrop")
                    net.WriteEntity(tr.Entity)
                net.SendToServer()
            end
        end
        wasFDrop = down
    end)

    hook.Add("HUDPaint", "EFT_PickupDrop_Hint", function()
        -- Подсказка рисуется общим EFT_LootSystem_FHint (чёрный квадрат F)
    end)
end


--################################################################################
--#  EFT TARKOV EXPANSION PACK  (v13)
--#  Craft 30+ · Overweight · Loot noise · Durability · Insurance · FIR · Sort
--################################################################################

-- Extra materials / items
local EXTRA_ITEMS = {
    ["mat_nails"] = {
        name = "Гвозди", w = 1, h = 1, rarity = "common", weight = 0.15, price = 30,
        desc = "Горсть ржавых гвоздей.", model = "models/props_lab/box01a.mdl", type = "part",
    },
    ["mat_wire"] = {
        name = "Медная проволока", w = 1, h = 1, rarity = "common", weight = 0.1, price = 40,
        desc = "Моток медной проволоки.", model = "models/props_lab/box01a.mdl", type = "part",
    },
    ["mat_oil"] = {
        name = "Оружейное масло", w = 1, h = 1, rarity = "uncommon", weight = 0.25, price = 200,
        desc = "Для обслуживания ствола.", model = "models/props_junk/garbage_plasticbottle002a.mdl", type = "part",
    },
    ["mat_batteries"] = {
        name = "Батарейки", w = 1, h = 1, rarity = "common", weight = 0.1, price = 50,
        desc = "Пара батареек AA.", model = "models/items/battery.mdl", type = "part",
    },
    ["mat_bandage_raw"] = {
        name = "Бинт (сырьё)", w = 1, h = 1, rarity = "common", weight = 0.05, price = 20,
        desc = "Ткань под бинт.", model = "models/props_lab/box01a.mdl", type = "part",
    },
    ["valuable_bolt"] = {
        name = "Болты", w = 1, h = 1, rarity = "common", weight = 0.08, price = 25,
        desc = "Метизы со стройки.", model = "models/props_c17/TrapPropeller_Lever.mdl", type = "valuable",
    },
    ["valuable_cpu"] = {
        name = "Процессор", w = 1, h = 1, rarity = "rare", weight = 0.05, price = 8000,
        desc = "Целый CPU с материнки.", model = "models/props_lab/harddrive01.mdl", type = "valuable",
    },
    ["valuable_gpu"] = {
        name = "Видеокарта", w = 2, h = 1, rarity = "legendary", weight = 0.6, price = 25000,
        desc = "Рабочая видеокарта.", model = "models/props_lab/harddrive01.mdl", type = "valuable",
    },
    ["valuable_flash"] = {
        name = "Флешка", w = 1, h = 1, rarity = "uncommon", weight = 0.02, price = 1500,
        desc = "USB-накопитель с данными.", model = "models/props_lab/box01a.mdl", type = "valuable",
    },
    ["weapon_medkit_car"] = {
        name = "Автоаптечка", w = 2, h = 1, rarity = "uncommon", weight = 0.8, price = 2500,
        desc = "Аптечка из машины. Лечит умеренно.", model = "models/items/healthkit.mdl",
        type = "medicine", healAmount = 35, healTime = 4, limbs = { "thorax", "stomach", "leftarm", "rightarm", "leftleg", "rightleg" },
        maxUses = 3,
    },
    ["weapon_splint"] = {
        name = "Шина", w = 1, h = 2, rarity = "common", weight = 0.3, price = 400,
        desc = "Фиксирует переломы конечностей.", model = "models/props_junk/wood_pallet001a_chunka1.mdl",
        type = "medicine", healAmount = 20, healTime = 5, limbs = { "leftarm", "rightarm", "leftleg", "rightleg" },
        maxUses = 1,
    },
}
for id, data in pairs(EXTRA_ITEMS) do
    if not EFT.ItemDatabase[id] then
        EFT.ItemDatabase[id] = data
        EFT.ItemsByType[data.type] = EFT.ItemsByType[data.type] or {}
        table.insert(EFT.ItemsByType[data.type], id)
    end
end

-- 30+ additional craft recipes
local EXTRA_RECIPES = {
    { name = "Гвозди из металлолома", category = "part", resultID = "mat_nails", resultCount = 4,
      ingredients = { { id = "mat_scrap_metal", count = 2 } } },
    { name = "Медная проволока", category = "part", resultID = "mat_wire", resultCount = 2,
      ingredients = { { id = "mat_electronics", count = 1 }, { id = "mat_scrap_metal", count = 1 } } },
    { name = "Батарейки (переборка)", category = "part", resultID = "mat_batteries", resultCount = 2,
      ingredients = { { id = "mat_electronics", count = 1 }, { id = "mat_plastic", count = 1 } } },
    { name = "Бинт из ткани", category = "medicine", resultID = "weapon_bandage_sh", resultCount = 2,
      ingredients = { { id = "mat_fabric", count = 2 }, { id = "mat_duct_tape", count = 1 } } },
    { name = "Обезболивающее", category = "medicine", resultID = "weapon_painkillers", resultCount = 1,
      ingredients = { { id = "mat_plastic", count = 1 }, { id = "mat_fabric", count = 1 } } },
    { name = "Автоаптечка", category = "medicine", resultID = "weapon_medkit_car", resultCount = 1,
      ingredients = { { id = "weapon_bandage_sh", count = 2 }, { id = "weapon_painkillers", count = 1 }, { id = "mat_plastic", count = 2 } } },
    { name = "Шина", category = "medicine", resultID = "weapon_splint", resultCount = 1,
      ingredients = { { id = "mat_wood_plank", count = 2 }, { id = "mat_fabric", count = 2 }, { id = "mat_duct_tape", count = 1 } } },
    { name = "Патроны 9x19 (малая пачка)", category = "ammo", resultID = "ent_ammo_9x19mmparabellum", resultCount = 30,
      ingredients = { { id = "mat_scrap_metal", count = 2 }, { id = "mat_gunpowder", count = 1 } } },
    { name = "Патроны 5.45x39", category = "ammo", resultID = "ent_ammo_5.45x39mm", resultCount = 30,
      ingredients = { { id = "mat_scrap_metal", count = 3 }, { id = "mat_gunpowder", count = 2 } } },
    { name = "Патроны 7.62x39", category = "ammo", resultID = "ent_ammo_7.62x39mm", resultCount = 30,
      ingredients = { { id = "mat_scrap_metal", count = 3 }, { id = "mat_gunpowder", count = 2 } } },
    { name = "Глушитель 9mm", category = "attachment", resultID = "ent_att_supressor4", resultCount = 1,
      ingredients = { { id = "mat_scrap_metal", count = 4 }, { id = "mat_rubber", count = 2 }, { id = "mat_duct_tape", count = 2 } } },
    { name = "Глушитель АК", category = "attachment", resultID = "ent_att_supressor1", resultCount = 1,
      ingredients = { { id = "mat_scrap_metal", count = 6 }, { id = "mat_rubber", count = 2 }, { id = "mat_oil", count = 1 } } },
    { name = "Самодельный глушитель", category = "attachment", resultID = "ent_att_supressor6", resultCount = 1,
      ingredients = { { id = "valuable_bottle", count = 1 }, { id = "mat_fabric", count = 2 }, { id = "mat_duct_tape", count = 2 } } },
    { name = "Лазерный целеуказатель", category = "attachment", resultID = "ent_att_laser3", resultCount = 1,
      ingredients = { { id = "mat_electronics", count = 3 }, { id = "mat_batteries", count = 1 }, { id = "mat_plastic", count = 1 } } },
    { name = "Коллиматор HOLO", category = "attachment", resultID = "ent_att_holo5", resultCount = 1,
      ingredients = { { id = "mat_electronics", count = 3 }, { id = "mat_glass_shards", count = 2 }, { id = "mat_plastic", count = 2 } } },
    { name = "Фонарь на изоленте", category = "attachment", resultID = "ent_att_flashlight_tape", resultCount = 1,
      ingredients = { { id = "mat_batteries", count = 1 }, { id = "mat_duct_tape", count = 2 }, { id = "mat_plastic", count = 1 } } },
    { name = "Лёгкий рюкзак T-Bag", category = "backpack", resultID = "gear_backpack_tbag", resultCount = 1,
      ingredients = { { id = "mat_fabric", count = 6 }, { id = "mat_duct_tape", count = 2 }, { id = "mat_nails", count = 2 } } },
    { name = "Рюкзак Scav", category = "backpack", resultID = "gear_backpack_scav", resultCount = 1,
      ingredients = { { id = "mat_fabric", count = 10 }, { id = "mat_duct_tape", count = 3 }, { id = "mat_nails", count = 4 } } },
    { name = "Разгрузка Scav", category = "rig", resultID = "gear_rig_scav", resultCount = 1,
      ingredients = { { id = "mat_fabric", count = 5 }, { id = "mat_scrap_metal", count = 2 }, { id = "mat_plastic", count = 2 } } },
    { name = "Починка: оружейное масло", category = "part", resultID = "mat_oil", resultCount = 1,
      ingredients = { { id = "mat_plastic", count = 1 }, { id = "valuable_can", count = 1 } } },
    { name = "Стеклобой из бутылки", category = "part", resultID = "mat_glass_shards", resultCount = 3,
      ingredients = { { id = "valuable_bottle", count = 1 } } },
    { name = "Изолента (рулон)", category = "part", resultID = "mat_duct_tape", resultCount = 2,
      ingredients = { { id = "mat_fabric", count = 1 }, { id = "mat_rubber", count = 1 } } },
    { name = "Порох из утиля", category = "part", resultID = "mat_gunpowder", resultCount = 1,
      ingredients = { { id = "mat_scrap_metal", count = 1 }, { id = "mat_plastic", count = 1 } } },
    { name = "Резина из шин", category = "part", resultID = "mat_rubber", resultCount = 2,
      ingredients = { { id = "mat_plastic", count = 2 }, { id = "mat_duct_tape", count = 1 } } },
    { name = "Ткань из тряпья", category = "part", resultID = "mat_fabric", resultCount = 3,
      ingredients = { { id = "mat_duct_tape", count = 1 } } },
    { name = "Пластик из бутылок", category = "part", resultID = "mat_plastic", resultCount = 2,
      ingredients = { { id = "valuable_bottle", count = 2 } } },
    { name = "Металлолом из болтов", category = "part", resultID = "mat_scrap_metal", resultCount = 2,
      ingredients = { { id = "valuable_bolt", count = 3 } } },
    { name = "Электроника из CPU", category = "part", resultID = "mat_electronics", resultCount = 3,
      ingredients = { { id = "valuable_cpu", count = 1 } } },
    { name = "Флешка (сборка)", category = "valuable", resultID = "valuable_flash", resultCount = 1,
      ingredients = { { id = "mat_electronics", count = 2 }, { id = "mat_plastic", count = 1 } } },
    { name = "IFAK (полный)", category = "medicine", resultID = "weapon_medkit_ifak", resultCount = 1,
      ingredients = { { id = "weapon_bandage_sh", count = 3 }, { id = "weapon_painkillers", count = 1 }, { id = "mat_fabric", count = 2 }, { id = "mat_plastic", count = 1 } } },
    { name = "Глушитель (средний)", category = "attachment", resultID = "ent_att_supressor4", resultCount = 1,
      ingredients = { { id = "mat_scrap_metal", count = 5 }, { id = "mat_oil", count = 1 }, { id = "mat_rubber", count = 1 } } },
    { name = "Коллиматор (бюджет)", category = "attachment", resultID = "ent_att_holo5", resultCount = 1,
      ingredients = { { id = "mat_electronics", count = 2 }, { id = "mat_batteries", count = 1 }, { id = "mat_glass_shards", count = 1 } } },
}

EFT.Recipes = EFT.Recipes or {}
local existing = {}
for _, r in ipairs(EFT.Recipes) do existing[r.name] = true end
for _, r in ipairs(EXTRA_RECIPES) do
    if not existing[r.name] then
        table.insert(EFT.Recipes, r)
        existing[r.name] = true
    end
end
print("[EFT] Total craft recipes: " .. #EFT.Recipes)
if EFT_ApplyRecipeTools then EFT_ApplyRecipeTools() end
-- re-apply after EXTRA_RECIPES
for _, r in ipairs(EFT.Recipes or {}) do
    if not r.requiredTool and EFT.GetRecipeRequiredTool then r.requiredTool = EFT.GetRecipeRequiredTool(r) end
end

-- Config expansion
EFT.Config.Overweight = EFT.Config.Overweight or {
    Enabled = true,
    Soft = 0.75,   -- start slow
    Hard = 1.0,    -- no sprint
    Extreme = 1.25 -- crawl speed
}
EFT.Config.LootNoise = EFT.Config.LootNoise or {
    Enabled = true,
    Radius = 900,
    SearchRadius = 700,
}
EFT.Config.Durability = EFT.Config.Durability or {
    Enabled = true,
    ArmorLossPerHit = 2,
    MinProtect = 0.15, -- 15% protect at 0%
}
EFT.Config.FIR = EFT.Config.FIR or {
    Strict = true,
    MarkOnRaidLoot = true,
}

if SERVER then
    util.AddNetworkString("EFT_SortInventory")
    util.AddNetworkString("EFT_InsureItem")
    util.AddNetworkString("EFT_RaidJournal")

    -- ===================== OVERWEIGHT =====================
    hook.Add("SetupMove", "EFT_Tarkov_Overweight", function(ply, mv, cmd)
        if not EFT.Config.Overweight.Enabled then return end
        if not IsValid(ply) or not ply:Alive() then return end
        local w = ply:GetNWFloat("EFT_Weight", 0)
        local cap = ply:GetNWFloat("EFT_Capacity", 40)
        if cap <= 0 then cap = 40 end
        local ratio = w / cap
        local cfg = EFT.Config.Overweight
        if ratio >= cfg.Extreme then
            mv:SetMaxClientSpeed(mv:GetMaxClientSpeed() * 0.35)
            mv:SetMaxSpeed(mv:GetMaxSpeed() * 0.35)
        elseif ratio >= cfg.Hard then
            mv:SetMaxClientSpeed(mv:GetMaxClientSpeed() * 0.55)
            mv:SetMaxSpeed(mv:GetMaxSpeed() * 0.55)
            if ply:KeyDown(IN_SPEED) then
                mv:SetMaxClientSpeed(mv:GetMaxClientSpeed() * 0.7)
            end
        elseif ratio >= cfg.Soft then
            mv:SetMaxClientSpeed(mv:GetMaxClientSpeed() * 0.8)
            mv:SetMaxSpeed(mv:GetMaxSpeed() * 0.8)
        end
    end)

    -- Sync weight to NW for client+move
    local function PushWeightNW(ply)
        if not IsValid(ply) then return end
        local weight, cap = 0, 40
        if EFT.Improvements and EFT.Improvements.ComputeWeight then
            weight, cap = EFT.Improvements.ComputeWeight(ply)
        end
        ply:SetNWFloat("EFT_Weight", weight or 0)
        ply:SetNWFloat("EFT_Capacity", cap or 40)
    end
    hook.Add("Think", "EFT_Tarkov_WeightNW", function()
        for _, ply in ipairs(player.GetAll()) do
            if IsValid(ply) and ply:Alive() then
                ply.EFT_WTick = (ply.EFT_WTick or 0) + FrameTime()
                if ply.EFT_WTick > 1.5 then
                    ply.EFT_WTick = 0
                    PushWeightNW(ply)
                end
            end
        end
    end)

    -- ===================== LOOT NOISE =====================
    local function EmitLootNoise(ply, radius, msg)
        if not EFT.Config.LootNoise.Enabled or not IsValid(ply) then return end
        radius = radius or EFT.Config.LootNoise.Radius
        local pos = ply:GetPos()
        for _, other in ipairs(player.GetAll()) do
            if other ~= ply and IsValid(other) and other:Alive() then
                if other:GetPos():DistToSqr(pos) <= radius * radius then
                    other:ChatPrint(msg or ("[EFT] Слышен шум обыска рядом..."))
                    other:EmitSound("physics/cardboard/cardboard_box_impact_soft1.wav", 40, 90)
                end
            end
        end
        ply:EmitSound("physics/cardboard/cardboard_box_impact_soft3.wav", 55, 95)
    end

    hook.Add("EFT_OnContainerSearch", "EFT_Tarkov_SearchNoise", function(ply)
        EmitLootNoise(ply, EFT.Config.LootNoise.SearchRadius, "[EFT] Кто-то обыскивает контейнер поблизости...")
    end)

    -- Fire noise when search completes (main uses EFT_SearchContainerComplete)
    local _oldSearch
    -- patch via net re-listen is hard; hook PlayerUse path via Think when ActiveLooters changes
    hook.Add("Think", "EFT_Tarkov_LootNoiseActive", function()
        if not EFT.ActiveLooters then return end
        for ply, ent in pairs(EFT.ActiveLooters) do
            if IsValid(ply) and IsValid(ent) then
                ply.EFT_NoiseTick = (ply.EFT_NoiseTick or 0) + FrameTime()
                if ply.EFT_NoiseTick > 8 then
                    ply.EFT_NoiseTick = 0
                    EmitLootNoise(ply, EFT.Config.LootNoise.Radius * 0.6, "[EFT] Шорох вещей...")
                end
            end
        end
    end)

    -- ===================== DURABILITY (armor HP) =====================
    hook.Add("EntityTakeDamage", "EFT_Tarkov_ArmorDurability", function(target, dmg)
        if not EFT.Config.Durability.Enabled then return end
        if not IsValid(target) or not target:IsPlayer() then return end
        local ply = target
        local equip = EFT.PlayerEquipment and EFT.PlayerEquipment[ply]
        if not equip then return end
        local vestID = equip.vest
        if not vestID then return end
        local db = EFT.ItemDatabase[vestID]
        if not db then return end
        -- reduce "virtual" armor durability stored on player
        ply.EFT_ArmorHP = ply.EFT_ArmorHP or {}
        local key = equip.vestUID or vestID
        local maxhp = db.armorValue or 50
        ply.EFT_ArmorHP[key] = ply.EFT_ArmorHP[key] or maxhp
        local loss = EFT.Config.Durability.ArmorLossPerHit * math.Clamp(dmg:GetDamage() / 20, 0.5, 3)
        ply.EFT_ArmorHP[key] = math.max(0, ply.EFT_ArmorHP[key] - loss)
        local ratio = ply.EFT_ArmorHP[key] / math.max(maxhp, 1)
        local minP = EFT.Config.Durability.MinProtect
        -- scale incoming damage inverse to remaining armor
        local protect = Lerp(ratio, minP, 1)
        if protect < 1 then
            dmg:ScaleDamage(1 - (1 - protect) * 0.35) -- weaker as armor dies
        end
        if ply.EFT_ArmorHP[key] <= 0 and not ply.EFT_ArmorBrokenMsg then
            ply:ChatPrint("[EFT] Броня почти разрушена!")
            ply.EFT_ArmorBrokenMsg = true
        end
    end)

    -- ===================== FIR strict =====================
    -- Mark loot taken in raid as FIR; strip FIR outside raid when selling would check
    hook.Add("EFT_ItemInsertedFromLoot", "EFT_Tarkov_FIR", function(ply, item)
        if not item then return end
        if EFT.Config.FIR.MarkOnRaidLoot then
            if ply.EFT_InRaid then
                item.fir = true
            end
        end
    end)

    -- ===================== INSURANCE improve =====================
    EFT.InsuranceQueue = EFT.InsuranceQueue or {}
    util.AddNetworkString("EFT_InsuranceNotify")

    net.Receive("EFT_InsureItem", function(_, ply)
        if not IsValid(ply) then return end
        local uid = net.ReadString()
        local fee = 0
        -- find item
        local lists = {}
        if EFT.VirtualInventory and EFT.VirtualInventory[ply] then table.insert(lists, EFT.VirtualInventory[ply]) end
        local equip = EFT.PlayerEquipment and EFT.PlayerEquipment[ply]
        if equip and equip.backpackUID and EFT.BackpackContents then
            table.insert(lists, EFT.BackpackContents[equip.backpackUID] or {})
        end
        if equip and equip.rigUID and EFT.RigContents then
            table.insert(lists, EFT.RigContents[equip.rigUID] or {})
        end
        local found
        for _, list in ipairs(lists) do
            for _, it in ipairs(list) do
                if it.uniqueID == uid then found = it break end
            end
            if found then break end
        end
        if not found then ply:ChatPrint("[EFT] Предмет не найден") return end
        if found.insured then ply:ChatPrint("[EFT] Уже застрахован") return end
        local db = EFT.ItemDatabase[found.id]
        if not db then return end
        fee = math.max(EFT.Config.Insurance.MinFee or 50, math.floor((db.price or 100) * (EFT.Config.Insurance.FeePercent or 0.15)))
        local money = ply:GetNWInt("EFT_Money", 0)
        if money < fee then
            ply:ChatPrint("[EFT] Нужно " .. fee .. "₽ для страховки")
            return
        end
        ply:SetNWInt("EFT_Money", money - fee)
        found.insured = true
        ply:ChatPrint("[EFT] Застраховано: " .. db.name .. " (−" .. fee .. "₽)")
        if EFT.Improvements and EFT.Improvements.SyncAll then EFT.Improvements.SyncAll(ply) end
    end)

    -- On death: queue insured items for return
    hook.Add("PlayerDeath", "EFT_Tarkov_InsuranceDeath", function(ply)
        if not IsValid(ply) then return end
        local sid = ply:SteamID64()
        if not sid then return end
        EFT.InsuranceQueue[sid] = EFT.InsuranceQueue[sid] or {}
        local function queueList(list)
            for _, it in ipairs(list or {}) do
                if it.insured then
                    local ret = CurTime() + (EFT.Config.Insurance.ReturnMinutes or 20) * 60
                    table.insert(EFT.InsuranceQueue[sid], {
                        id = it.id, uniqueID = it.uniqueID, count = it.count, hp = it.hp, uses = it.uses,
                        returnAt = ret, name = (EFT.ItemDatabase[it.id] and EFT.ItemDatabase[it.id].name) or it.id
                    })
                end
            end
        end
        queueList(EFT.VirtualInventory and EFT.VirtualInventory[ply])
        local equip = EFT.PlayerEquipment and EFT.PlayerEquipment[ply]
        if equip then
            if equip.backpackUID and EFT.BackpackContents then queueList(EFT.BackpackContents[equip.backpackUID]) end
            if equip.rigUID and EFT.RigContents then queueList(EFT.RigContents[equip.rigUID]) end
            for _, slot in ipairs({ "vest", "helmet", "mask", "headphones", "backpack", "rig" }) do
                if equip[slot] then
                    local id = equip[slot]
                    local db = EFT.ItemDatabase[id]
                    -- equipped items count as insured if flagged on a virtual twin - always insure equipped for simplicity if NW
                    table.insert(EFT.InsuranceQueue[sid], {
                        id = id, uniqueID = equip[slot .. "UID"], returnAt = CurTime() + (EFT.Config.Insurance.ReturnMinutes or 20) * 60,
                        name = db and db.name or id
                    })
                end
            end
        end
        if #EFT.InsuranceQueue[sid] > 0 then
            ply:ChatPrint("[EFT] Страховка: " .. #EFT.InsuranceQueue[sid] .. " предметов вернутся через ~" .. (EFT.Config.Insurance.ReturnMinutes or 20) .. " мин.")
        end
    end)

    -- Claim ready insurance into stash
    hook.Add("Think", "EFT_Tarkov_InsuranceReturn", function()
        for sid, queue in pairs(EFT.InsuranceQueue) do
            local ready = {}
            for i = #queue, 1, -1 do
                local e = queue[i]
                if e.returnAt and CurTime() >= e.returnAt then
                    table.insert(ready, e)
                    table.remove(queue, i)
                end
            end
            if #ready > 0 then
                EFT.PlayerStash = EFT.PlayerStash or {}
                EFT.PlayerStash[sid] = EFT.PlayerStash[sid] or {}
                for _, e in ipairs(ready) do
                    local db = EFT.ItemDatabase[e.id]
                    if db and EFT.Grid and EFT.Grid.TryInsert then
                        EFT.Grid.TryInsert(EFT.PlayerStash[sid], e.id, db, 10, 12, {
                            uniqueID = e.uniqueID, count = e.count, hp = e.hp, uses = e.uses, examined = true, insured = false, fir = false
                        })
                    end
                end
                for _, ply in ipairs(player.GetAll()) do
                    if IsValid(ply) and ply:SteamID64() == sid then
                        ply:ChatPrint("[EFT] Страховка доставлена в STASH: " .. #ready .. " шт.")
                        net.Start("EFT_InsuranceNotify")
                            net.WriteUInt(#ready, 8)
                        net.Send(ply)
                    end
                end
            end
        end
    end)

    -- ===================== SORT INVENTORY =====================
    net.Receive("EFT_SortInventory", function(_, ply)
        if not IsValid(ply) then return end
        local mode = net.ReadString() -- "price" | "type" | "weight"
        local inv = EFT.VirtualInventory and EFT.VirtualInventory[ply]
        if not inv then return end
        table.sort(inv, function(a, b)
            local da, db = EFT.ItemDatabase[a.id], EFT.ItemDatabase[b.id]
            if not da or not db then return false end
            if mode == "weight" then return (da.weight or 0) > (db.weight or 0) end
            if mode == "type" then return tostring(da.type) < tostring(db.type) end
            return (da.price or 0) > (db.price or 0)
        end)
        -- re-pack into grid top-left
        local sorted = table.Copy(inv)
        for i = #inv, 1, -1 do table.remove(inv, i) end
        local gw = EFT.Config.PersonalGridBaseW or 2
        local gh = EFT.Config.PersonalGridBaseH or 5
        for _, it in ipairs(sorted) do
            local db = EFT.ItemDatabase[it.id]
            if db then
                EFT.Grid.TryInsert(inv, it.id, db, gw, gh, {
                    uniqueID = it.uniqueID, count = it.count, hp = it.hp, uses = it.uses,
                    examined = it.examined, fir = it.fir, insured = it.insured, rotated = it.rotated
                })
            end
        end
        if EFT.Improvements and EFT.Improvements.SyncAll then EFT.Improvements.SyncAll(ply)
        else
            -- fallback soft sync
        end
        ply:ChatPrint("[EFT] Инвентарь отсортирован (" .. mode .. ")")
    end)

    -- ===================== RAID JOURNAL on extract =====================
    hook.Add("EFT_RaidExtracted", "EFT_Tarkov_Journal", function(ply, stats)
        if not IsValid(ply) then return end
        stats = stats or {}
        net.Start("EFT_RaidJournal")
            net.WriteUInt(stats.kills or 0, 16)
            net.WriteUInt(stats.dogtags or 0, 8)
            net.WriteUInt(stats.lootValue or 0, 32)
            net.WriteFloat(stats.duration or 0)
            net.WriteBool(stats.survived ~= false)
        net.Send(ply)
    end)

    print("[EFT] Tarkov Expansion SERVER loaded.")
end

if CLIENT then
    net.Receive("EFT_InsuranceNotify", function()
        local n = net.ReadUInt(8)
        chat.AddText(Color(180, 165, 120), "[EFT] ", color_white, "Страховка в STASH: " .. n .. " предметов.")
        surface.PlaySound("buttons/button14.wav")
    end)

    net.Receive("EFT_RaidJournal", function()
        local kills = net.ReadUInt(16)
        local tags = net.ReadUInt(8)
        local value = net.ReadUInt(32)
        local dur = net.ReadFloat()
        local survived = net.ReadBool()
        local fr = vgui.Create("DFrame")
        fr:SetSize(420, 280)
        fr:Center()
        fr:SetTitle("")
        fr:MakePopup()
        fr:ShowCloseButton(true)
        fr.Paint = function(s, w, h)
            draw.RoundedBox(8, 0, 0, w, h, Color(12, 12, 11, 250))
            surface.SetDrawColor(180, 165, 120)
            surface.DrawOutlinedRect(0, 0, w, h)
            draw.SimpleText("ИТОГИ РЕЙДА", "DermaLarge", w/2, 20, Color(180, 165, 120), TEXT_ALIGN_CENTER)
            local y = 70
            local lines = {
                { survived and "ВЫЖИЛ" or "ПОГИБ", survived and Color(100, 180, 100) or Color(200, 80, 70) },
                { "Убийств: " .. kills, color_white },
                { "Жетонов: " .. tags, color_white },
                { "Ценность лута: " .. value .. "₽", Color(180, 165, 120) },
                { "Время: " .. string.ToMinutesSeconds(math.floor(dur)), Color(160, 160, 150) },
            }
            for _, ln in ipairs(lines) do
                draw.SimpleText(ln[1], "DermaDefaultBold", w/2, y, ln[2], TEXT_ALIGN_CENTER)
                y = y + 28
            end
        end
    end)

    -- Overweight HUD
    hook.Add("HUDPaint", "EFT_Tarkov_OverweightHUD", function()
        local ply = LocalPlayer()
        if not IsValid(ply) or not ply:Alive() then return end
        local w = ply:GetNWFloat("EFT_Weight", 0)
        local cap = ply:GetNWFloat("EFT_Capacity", 40)
        if cap <= 0 then return end
        local ratio = w / cap
        if ratio < 0.75 then return end
        local txt = ratio >= 1.25 and "КРИТИЧЕСКИЙ ПЕРЕГРУЗ" or (ratio >= 1 and "ПЕРЕГРУЗ — нет спринта" or "Тяжело...")
        local col = ratio >= 1 and Color(200, 80, 70) or Color(200, 170, 90)
        draw.SimpleTextOutlined(txt, "DermaDefaultBold", ScrW()/2, ScrH() - 90, col, TEXT_ALIGN_CENTER, TEXT_ALIGN_CENTER, 1, Color(0,0,0,200))
    end)

    -- Sort binds when Desk open: Ctrl+1 price, Ctrl+2 type, Ctrl+3 weight
    local wasS1, wasS2, wasS3 = false, false, false
    hook.Add("Think", "EFT_Tarkov_SortKeys", function()
        if not input.IsKeyDown(KEY_LCONTROL) then wasS1=false wasS2=false wasS3=false return end
        local function edge(key, was)
            local d = input.IsKeyDown(key)
            local fire = d and not was
            return fire, d
        end
        local f1; f1, wasS1 = edge(KEY_1, wasS1)
        local f2; f2, wasS2 = edge(KEY_2, wasS2)
        local f3; f3, wasS3 = edge(KEY_3, wasS3)
        if f1 then net.Start("EFT_SortInventory") net.WriteString("price") net.SendToServer() end
        if f2 then net.Start("EFT_SortInventory") net.WriteString("type") net.SendToServer() end
        if f3 then net.Start("EFT_SortInventory") net.WriteString("weight") net.SendToServer() end
    end)

    print("[EFT] Tarkov Expansion CLIENT loaded.")
end


--################################################################################
--################################################################################
--#  UNIFIED: EFT COMPLETE + INVENTORY REWORK (clothing / skills / Odessa quests)
--#  All systems in ONE file. Load this single file in autorun.
--################################################################################
--################################################################################

--[[
    EFT COMPLETE — Inventory Rework + Clothing + Skills/Perks + Odessa Dialog/Quests
    Совместимо с eft_COMPLETE.lua (v12/v13)

    Что добавлено:
    1. Квадратное окно персонажа (DModelPanel) в инвентаре + имя сбоку + репутация снизу
    2. Система одежды: базовые штаны (2x2) и кофта (2x3) всегда надеты
    3. Навыки / перки: 1 очко перка на старте, опыт за пассивные квесты
    4. Репутация с 0 уровня, отображается под превью персонажа
    5. Диалоговое окно с Одессой + 2 квеста с уникальными лут-боксами
]]

AddCSLuaFile()

EFT = EFT or {}
EFT.Config = EFT.Config or {}

-- ==========================================
-- КОНФИГ ОДЕЖДЫ / НАВЫКОВ / РЕПУТАЦИИ
-- ==========================================
EFT.Config.Clothing = {
    PantsGrid   = { w = 2, h = 2 },   -- штаны 2x2
    ShirtGrid   = { w = 2, h = 3 },   -- кофта 2x3
}

EFT.Config.Skills = {
    StartingPerkPoints = 1,
    XPPerLevel = 100,                 -- опыт до следующего уровня навыка (базовый)
    MaxSkillLevel = 10,
}

EFT.Config.Reputation = {
    StartingLevel = 0,
    XPPerRepLevel = 100,              -- очки репутации до следующего уровня
}

-- Пассивные «квесты» (источники XP) — можно расширять
EFT.PassiveQuests = {
    loot_container   = { xp = 5,  name = "Обыск контейнера" },
    kill_npc         = { xp = 15, name = "Убийство NPC" },
    extract_raid     = { xp = 40, name = "Успешный экстракт" },
    craft_item       = { xp = 8,  name = "Крафт предмета" },
    sell_item        = { xp = 3,  name = "Продажа предмета" },
}

-- Базовые перки (простые бонусы)
EFT.PerkDefs = {
    {
        id = "carry_plus",
        name = "Сильная спина",
        desc = "+3 кг к грузоподъёмности",
        maxRank = 3,
        onApply = function(ply, rank)
            ply.EFT_PerkCarryBonus = (ply.EFT_PerkCarryBonus or 0) + 3
        end,
    },
    {
        id = "search_speed",
        name = "Быстрый обыск",
        desc = "Обыск контейнеров быстрее на 15%",
        maxRank = 2,
        onApply = function(ply, rank)
            ply.EFT_PerkSearchMul = 1 + 0.15 * rank
        end,
    },
    {
        id = "med_eff",
        name = "Полевой медик",
        desc = "Лечение медикаментами +10 HP",
        maxRank = 2,
        onApply = function(ply, rank)
            ply.EFT_PerkMedBonus = 10 * rank
        end,
    },
    {
        id = "quiet_loot",
        name = "Тихий лут",
        desc = "Шум от обыска слышен на 30% меньше",
        maxRank = 1,
        onApply = function(ply, rank)
            ply.EFT_PerkQuietLoot = true
        end,
    },
}

-- ==========================================
-- ПРЕДМЕТЫ ОДЕЖДЫ + КВЕСТОВЫЕ ПРЕДМЕТЫ
-- ==========================================
local CLOTHING_AND_QUEST_ITEMS = {
    -- Базовая одежда (нельзя снять полностью — всегда есть слоты)
    ["gear_pants_basic"] = {
        name = "Штаны (базовые)", w = 2, h = 2, rarity = "common", weight = 0.6,
        gridSize = { w = 2, h = 2 },
        desc = "Обычные штаны. Дают сетку карманов 2x2.",
        model = "models/props_c17/BriefCase001a.mdl", -- заглушка, визуал через слот
        type = "clothing", clothingSlot = "pants",
        canUnequip = false, -- базовые нельзя снять «в никуда»
    },
    ["gear_shirt_basic"] = {
        name = "Кофта (базовая)", w = 2, h = 3, rarity = "common", weight = 0.5,
        gridSize = { w = 2, h = 3 },
        desc = "Простая кофта. Даёт сетку карманов 2x3.",
        model = "models/props_c17/BriefCase001a.mdl",
        type = "clothing", clothingSlot = "shirt",
        canUnequip = false,
    },

    -- Квест 1: посылка Одессы
    ["quest_odessa_package"] = {
        name = "Посылка Одессы", w = 2, h = 2, rarity = "epic", weight = 5.0,
        desc = "Закрытый кейс Kappa. Надпись: «Для Одессы. Не вскрывать.» Вес: 5 кг.",
        model = "models/eftpropspack/item_container_cultic_kappa.mdl",
        type = "quest", questID = "odessa_package", canStore = true,
        price = 0,
    },

    -- Квест 2: военный документ (блокнот 2x2)
    ["quest_military_document"] = {
        name = "Военный документ", w = 2, h = 2, rarity = "legendary", weight = 0.5,
        desc = "Папка с грифом. Ценный документ с места крушения вертолёта. Вес: 0.5 кг.",
        model = "models/props_lab/notepad001a.mdl",
        type = "quest", questID = "odessa_document", canStore = true,
        price = 0,
    },
}

for id, data in pairs(CLOTHING_AND_QUEST_ITEMS) do
    if not EFT.ItemDatabase then EFT.ItemDatabase = {} end
    -- всегда обновляем квестовые/одежду (модели, вес, размер)
    EFT.ItemDatabase[id] = data
    EFT.ItemsByType = EFT.ItemsByType or {}
    EFT.ItemsByType[data.type] = EFT.ItemsByType[data.type] or {}
    local found = false
    for _, existing in ipairs(EFT.ItemsByType[data.type]) do
        if existing == id then found = true break end
    end
    if not found then table.insert(EFT.ItemsByType[data.type], id) end
end

-- Квестовые контейнеры: сетка 2x2, только один предмет
EFT.QuestContainerDefs = EFT.QuestContainerDefs or {}
EFT.QuestContainerDefs["models/eftpropspack/item_container_magbox.mdl"] = {
    questItem = "quest_odessa_package",
    questID   = "odessa_package",
    w = 2, h = 2,
}
EFT.QuestContainerDefs["models/eftpropspack/item_container_money.mdl"] = {
    questItem = "quest_military_document",
    questID   = "odessa_document",
    w = 2, h = 2,
}

-- ==========================================
-- СЕРВЕР
-- ==========================================
if SERVER then
    util.AddNetworkString("EFT_OpenOdessaDialog")
    util.AddNetworkString("EFT_OdessaDialogChoice")
    util.AddNetworkString("EFT_SyncSkillsRep")
    util.AddNetworkString("EFT_UnlockPerk")
    util.AddNetworkString("EFT_RequestSkillsRep")
    util.AddNetworkString("EFT_QuestProgress")
    util.AddNetworkString("EFT_TurnInQuest")

    EFT.PlayerSkills = EFT.PlayerSkills or {}
    EFT.PlayerClothing = EFT.PlayerClothing or {}
    EFT.PlayerQuests = EFT.PlayerQuests or {}
    EFT.ClothingContents = EFT.ClothingContents or {} -- [uid] = items

    local function Sid(ply)
        return IsValid(ply) and ply:SteamID64() or nil
    end

    local function EnsurePlayerData(ply)
        if not IsValid(ply) then return end
        local sid = Sid(ply)
        if not sid then return end

        EFT.PlayerSkills[ply] = EFT.PlayerSkills[ply] or {
            xp = 0,
            level = 1,
            perkPoints = EFT.Config.Skills.StartingPerkPoints or 1,
            perks = {}, -- [perkID] = rank
            reputation = EFT.Config.Reputation.StartingLevel or 0,
            reputationXP = 0,
        }

        EFT.PlayerClothing[ply] = EFT.PlayerClothing[ply] or {
            pants = "gear_pants_basic",
            pantsUID = "pants_" .. sid,
            shirt = "gear_shirt_basic",
            shirtUID = "shirt_" .. sid,
        }

        -- Гарантируем хранилища одежды
        local cl = EFT.PlayerClothing[ply]
        EFT.ClothingContents[cl.pantsUID] = EFT.ClothingContents[cl.pantsUID] or {}
        EFT.ClothingContents[cl.shirtUID] = EFT.ClothingContents[cl.shirtUID] or {}

        EFT.PlayerQuests[ply] = EFT.PlayerQuests[ply] or {
            active = {},   -- [questID] = { state = "active"|"ready" }
            completed = {},
        }
    end

    function EFT.GetSkills(ply)
        EnsurePlayerData(ply)
        return EFT.PlayerSkills[ply]
    end

    function EFT.GetClothing(ply)
        EnsurePlayerData(ply)
        return EFT.PlayerClothing[ply]
    end

    function EFT.GetPantsInv(ply)
        local cl = EFT.GetClothing(ply)
        return EFT.ClothingContents[cl.pantsUID] or {}
    end

    function EFT.GetShirtInv(ply)
        local cl = EFT.GetClothing(ply)
        return EFT.ClothingContents[cl.shirtUID] or {}
    end

    function EFT.GetPantsGridSize()
        return EFT.Config.Clothing.PantsGrid
    end

    function EFT.GetShirtGridSize()
        return EFT.Config.Clothing.ShirtGrid
    end

    -- Добавление XP (пассивные квесты / действия)
    function EFT.AddExperience(ply, amount, reason)
        if not IsValid(ply) or not amount or amount <= 0 then return end
        local sk = EFT.GetSkills(ply)
        sk.xp = sk.xp + amount
        local need = EFT.Config.Skills.XPPerLevel * sk.level
        while sk.xp >= need and sk.level < (EFT.Config.Skills.MaxSkillLevel or 10) do
            sk.xp = sk.xp - need
            sk.level = sk.level + 1
            sk.perkPoints = sk.perkPoints + 1
            ply:ChatPrint(string.format("[EFT] Уровень навыка %d! +1 очко перка.", sk.level))
            need = EFT.Config.Skills.XPPerLevel * sk.level
        end
        EFT.SyncSkillsRep(ply)
    end

    -- Репутация
    function EFT.AddReputation(ply, amount)
        if not IsValid(ply) or not amount or amount == 0 then return end
        local sk = EFT.GetSkills(ply)
        sk.reputationXP = (sk.reputationXP or 0) + amount
        local need = EFT.Config.Reputation.XPPerRepLevel or 100
        while sk.reputationXP >= need do
            sk.reputationXP = sk.reputationXP - need
            sk.reputation = (sk.reputation or 0) + 1
            ply:ChatPrint(string.format("[EFT] Репутация повышена! Уровень: %d", sk.reputation))
        end
        -- отрицательная репутация тоже возможна, но уровень не уходит ниже 0
        if sk.reputation < 0 then sk.reputation = 0 end
        EFT.SyncSkillsRep(ply)
    end

    function EFT.SyncSkillsRep(ply)
        if not IsValid(ply) then return end
        local sk = EFT.GetSkills(ply)
        net.Start("EFT_SyncSkillsRep")
            net.WriteUInt(sk.level or 1, 8)
            net.WriteUInt(math.floor(sk.xp or 0), 16)
            net.WriteUInt(sk.perkPoints or 0, 8)
            net.WriteUInt(sk.reputation or 0, 16)
            net.WriteUInt(math.floor(sk.reputationXP or 0), 16)
            net.WriteTable(sk.perks or {})
        net.Send(ply)
    end

    -- Разблокировка перка
    net.Receive("EFT_UnlockPerk", function(_, ply)
        if not IsValid(ply) then return end
        local perkID = net.ReadString()
        local sk = EFT.GetSkills(ply)
        if (sk.perkPoints or 0) < 1 then
            ply:ChatPrint("[EFT] Нет очков перка.")
            return
        end
        local def
        for _, p in ipairs(EFT.PerkDefs) do
            if p.id == perkID then def = p break end
        end
        if not def then return end
        local cur = sk.perks[perkID] or 0
        if cur >= (def.maxRank or 1) then
            ply:ChatPrint("[EFT] Перк уже максимального ранга.")
            return
        end
        sk.perkPoints = sk.perkPoints - 1
        sk.perks[perkID] = cur + 1
        if def.onApply then
            pcall(def.onApply, ply, sk.perks[perkID])
        end
        ply:ChatPrint("[EFT] Перк: " .. def.name .. " (ранг " .. sk.perks[perkID] .. ")")
        EFT.SyncSkillsRep(ply)
    end)

    net.Receive("EFT_RequestSkillsRep", function(_, ply)
        if IsValid(ply) then EFT.SyncSkillsRep(ply) end
    end)

    -- Инициализация при спавне
    hook.Add("PlayerInitialSpawn", "EFT_Rework_InitData", function(ply)
        timer.Simple(1.5, function()
            if not IsValid(ply) then return end
            EnsurePlayerData(ply)
            EFT.SyncSkillsRep(ply)
        end)
    end)

    hook.Add("PlayerSpawn", "EFT_Rework_EnsureClothing", function(ply)
        timer.Simple(0.3, function()
            if IsValid(ply) then EnsurePlayerData(ply) end
        end)
    end)

    -- Пассивный XP за обыск (хук, если основной аддон его вызывает; иначе — при открытии лута)
    hook.Add("EFT_OnContainerSearch", "EFT_Rework_PassiveXP_Search", function(ply)
        if IsValid(ply) then
            local q = EFT.PassiveQuests.loot_container
            if q then EFT.AddExperience(ply, q.xp, q.name) end
        end
    end)

    hook.Add("OnNPCKilled", "EFT_Rework_PassiveXP_Kill", function(npc, attacker)
        if IsValid(attacker) and attacker:IsPlayer() then
            local q = EFT.PassiveQuests.kill_npc
            if q then EFT.AddExperience(attacker, q.xp, q.name) end
        end
    end)

    -- Квестовые контейнеры: всегда ровно один предмет 2x2 (без мусора)
    local function InjectQuestLoot(ent, ply)
        if not IsValid(ent) then return end
        local mdl = string.lower(string.gsub(ent:GetModel() or "", "\\", "/"))
        local qdef = EFT.QuestContainerDefs and EFT.QuestContainerDefs[mdl]
        if not qdef then
            local base = string.match(mdl, "([^/]+%.mdl)$")
            if base and EFT.QuestContainerDefs then
                for path, qd in pairs(EFT.QuestContainerDefs) do
                    if string.match(string.lower(path), base .. "$") then qdef = qd break end
                end
            end
        end
        if not qdef then
            if string.find(mdl, "item_container_magbox", 1, true) then
                qdef = { questItem = "quest_odessa_package", questID = "odessa_package", w = 2, h = 2 }
            elseif string.find(mdl, "item_container_money", 1, true) then
                qdef = { questItem = "quest_military_document", questID = "odessa_document", w = 2, h = 2 }
            end
        end
        if not qdef or not qdef.questItem then return end

        local db = EFT.ItemDatabase[qdef.questItem]
        if not db then return end

        local gw, gh = qdef.w or 2, qdef.h or 2
        EFT.ContainerGridSize = EFT.ContainerGridSize or {}
        EFT.ContainerGridSize[ent] = { w = gw, h = gh }

        local storage = EFT.ContainerStorage
        if not storage then return end

        -- Уже правильный единственный предмет?
        if storage[ent] and #storage[ent] == 1 and storage[ent][1].id == qdef.questItem then
            storage[ent][1].w = db.w or 2
            storage[ent][1].h = db.h or 2
            storage[ent][1].x, storage[ent][1].y = 1, 1
            storage[ent][1].examined = true
            return
        end

        storage[ent] = {
            {
                uniqueID = tostring(util.CRC(qdef.questItem .. tostring(ent:EntIndex()) .. tostring(CurTime()))),
                id = qdef.questItem,
                x = 1, y = 1,
                w = db.w or 2, h = db.h or 2,
                examined = true,
                fir = true,
                count = 1,
            }
        }
    end

    -- При открытии лута — проверяем квестовый контейнер
    hook.Add("Think", "EFT_Rework_QuestLootInject", function()
        if not EFT.ActiveLooters then return end
        for ply, ent in pairs(EFT.ActiveLooters) do
            if IsValid(ply) and IsValid(ent) then
                if not ent.EFT_QuestChecked then
                    ent.EFT_QuestChecked = true
                    InjectQuestLoot(ent, ply)
                end
            end
        end
    end)

    -- Диалог с Одессой
    local function OpenOdessaDialog(ply, ent)
        if not IsValid(ply) then return end
        local quests = EFT.PlayerQuests[ply] or { active = {}, completed = {} }
        net.Start("EFT_OpenOdessaDialog")
            net.WriteEntity(IsValid(ent) and ent or NULL)
            net.WriteTable({
                active = quests.active,
                completed = quests.completed,
            })
        net.Send(ply)
    end

    -- ВАЖНО: НЕ регистрировать повторный net.Receive("EFT_RequestLootF") —
    -- в GMod последний обработчик ПОЛНОСТЬЮ затирает предыдущий, и лут контейнеров ломается.
    -- Диалог Одессы идёт через EFT_RequestOdessaDialog (клиент шлёт F на npc_odessa).

    -- Отдельный запрос диалога (клиент шлёт при F на Одессе)
    util.AddNetworkString("EFT_RequestOdessaDialog")
    net.Receive("EFT_RequestOdessaDialog", function(_, ply)
        if not IsValid(ply) or not ply:Alive() then return end
        local ent = net.ReadEntity()
        if not IsValid(ent) or ent:GetClass() ~= "npc_odessa" then return end
        if ply:GetPos():DistToSqr(ent:GetPos()) > (EFT.Config.LootDistance or 110)^2 then return end
        EnsurePlayerData(ply)
        OpenOdessaDialog(ply, ent)
    end)

    -- ==========================================
    -- ДИАЛОГ С ПРОДАВЦОМ ОРУЖИЯ (БАРНИ / npc_weapon_dealer)
    -- ==========================================
    util.AddNetworkString("EFT_OpenBarneyDialog")
    util.AddNetworkString("EFT_BarneyDialogChoice")
    util.AddNetworkString("EFT_RequestBarneyDialog")

    local function OpenBarneyDialog(ply, ent)
        if not IsValid(ply) then return end
        net.Start("EFT_OpenBarneyDialog")
            net.WriteEntity(IsValid(ent) and ent or NULL)
            net.WriteInt(ply:GetNWInt("EFT_Money", 0), 32)
        net.Send(ply)
    end

    net.Receive("EFT_RequestBarneyDialog", function(_, ply)
        if not IsValid(ply) or not ply:Alive() then return end
        local ent = net.ReadEntity()
        if not IsValid(ent) or ent:GetClass() ~= "npc_weapon_dealer" then return end
        if ply:GetPos():DistToSqr(ent:GetPos()) > (EFT.Config.LootDistance or 110)^2 then return end
        OpenBarneyDialog(ply, ent)
    end)

    net.Receive("EFT_BarneyDialogChoice", function(_, ply)
        if not IsValid(ply) or not ply:Alive() then return end
        local choice = net.ReadString() -- "trade" | "tools" | "bye"
        local ent = net.ReadEntity()

        if choice == "bye" then
            return
        end

        if choice == "trade" then
            -- Открываем витрину оружия только через диалог
            if IsValid(ent) and ent:GetClass() == "npc_weapon_dealer" then
                if ply:GetPos():DistToSqr(ent:GetPos()) > (EFT.Config.LootDistance or 110)^2 then return end
            end
            local items = {}
            for itemID, d in pairs(EFT.ItemDatabase) do
                if d.type == "weapon" and d.buyPrice then items[itemID] = true end
            end
            net.Start("EFT_OpenWeaponShop")
                net.WriteTable(items)
                net.WriteInt(ply:GetNWInt("EFT_Money", 0), 32)
            net.Send(ply)
            return
        end

        if choice == "tools" then
            local price = 2500
            local toolID = "tool_work_light"
            local money = ply:GetNWInt("EFT_Money", 0)
            if money < price then
                ply:ChatPrint("[Барни] Не хватает денег. Набор стоит " .. price .. "₽.")
                return
            end
            local db = EFT.ItemDatabase[toolID]
            if not db then
                ply:ChatPrint("[Барни] Сейчас нет такого набора. Зайди позже.")
                return
            end

            local given = false
            if EFT.Improvements and EFT.Improvements.TryAddItem then
                given = EFT.Improvements.TryAddItem(ply, toolID, db, { examined = true })
            end
            if not given and EFT.Grid and EFT.Grid.TryInsert then
                if EFT.GetPantsInv and EFT.GetPantsGridSize then
                    local pg = EFT.GetPantsGridSize()
                    if pg and pg.w > 0 then
                        given = EFT.Grid.TryInsert(EFT.GetPantsInv(ply), toolID, db, pg.w, pg.h, { examined = true })
                    end
                end
                if not given and EFT.GetShirtInv and EFT.GetShirtGridSize then
                    local sg = EFT.GetShirtGridSize()
                    if sg and sg.w > 0 then
                        given = EFT.Grid.TryInsert(EFT.GetShirtInv(ply), toolID, db, sg.w, sg.h, { examined = true })
                    end
                end
            end

            if not given then
                ply:ChatPrint("[Барни] У тебя нет места в инвентаре. Освободи карманы.")
                return
            end

            ply:SetNWInt("EFT_Money", money - price)
            ply:ChatPrint("[Барни] Держи набор инструментов. −" .. price .. "₽.")
            ply:EmitSound("items/ammo_pickup.wav", 55, 110)

            if EFT.Improvements and EFT.Improvements.SyncAll then
                EFT.Improvements.SyncAll(ply)
            end
            return
        end
    end)

    -- Выбор в диалоге
    net.Receive("EFT_OdessaDialogChoice", function(_, ply)
        if not IsValid(ply) then return end
        local choice = net.ReadString()
        local stage  = net.ReadString() -- "root" | "jobs" | "accept_package" | "accept_document" | "close"
        EnsurePlayerData(ply)
        local quests = EFT.PlayerQuests[ply]

        if stage == "root" then
            if choice == "buy" then
                -- Магазин только из диалога: собираем все продаваемые предметы
                local sellItems = {}
                local function scan(list)
                    if not list then return end
                    for _, it in ipairs(list) do
                        local d = EFT.ItemDatabase[it.id]
                        if d and d.price and d.price > 0 and d.type ~= "quest" then
                            sellItems[it.id] = (sellItems[it.id] or 0) + (it.count or 1)
                        end
                    end
                end
                if EFT.VirtualInventory then scan(EFT.VirtualInventory[ply]) end
                local equip = EFT.PlayerEquipment and EFT.PlayerEquipment[ply]
                if equip and equip.backpackUID and EFT.BackpackContents then
                    scan(EFT.BackpackContents[equip.backpackUID])
                end
                if equip and equip.rigUID and EFT.RigContents then
                    scan(EFT.RigContents[equip.rigUID])
                end
                if EFT.GetPantsInv then scan(EFT.GetPantsInv(ply)) end
                if EFT.GetShirtInv then scan(EFT.GetShirtInv(ply)) end
                -- оружие на руках не продаём через эту витрину (только инвентарь)
                net.Start("EFT_OpenShop")
                    net.WriteTable(sellItems)
                    net.WriteInt(ply:GetNWInt("EFT_Money", 0), 32)
                net.Send(ply)
                return
            elseif choice == "jobs" then
                -- Клиент сам покажет следующий этап; сервер только подтверждает
                return
            elseif choice == "bye" then
                return
            end
        elseif stage == "accept_package" then
            if quests.completed["odessa_package"] then
                ply:ChatPrint("[Одесса] Эту работу ты уже сделал.")
                return
            end
            if quests.active["odessa_package"] then
                ply:ChatPrint("[Одесса] Ты уже взял эту задачу.")
                return
            end
            quests.active["odessa_package"] = { state = "active", givenAt = CurTime() }
            ply:ChatPrint("[Одесса] Посылка возле БТР. Ищи ящик magbox. Принеси — не обижу.")
            net.Start("EFT_QuestProgress")
                net.WriteString("odessa_package")
                net.WriteString("active")
            net.Send(ply)
        elseif stage == "accept_document" then
            if quests.completed["odessa_document"] then
                ply:ChatPrint("[Одесса] Документ уже приносил.")
                return
            end
            if quests.active["odessa_document"] then
                ply:ChatPrint("[Одесса] Ты уже на этом задании.")
                return
            end
            quests.active["odessa_document"] = { state = "active", givenAt = CurTime() }
            ply:ChatPrint("[Одесса] Вертолёт упал. Документ в денежном ящике. Найди и принеси.")
            net.Start("EFT_QuestProgress")
                net.WriteString("odessa_document")
                net.WriteString("active")
            net.Send(ply)
        elseif stage == "turnin_package" then
            -- Проверяем наличие предмета
            local function findAndRemoveQuest(itemID)
                local lists = {
                    EFT.VirtualInventory and EFT.VirtualInventory[ply],
                    EFT.GetPantsInv(ply),
                    EFT.GetShirtInv(ply),
                }
                local equip = EFT.PlayerEquipment and EFT.PlayerEquipment[ply]
                if equip and equip.backpackUID and EFT.BackpackContents then
                    table.insert(lists, EFT.BackpackContents[equip.backpackUID])
                end
                if equip and equip.rigUID and EFT.RigContents then
                    table.insert(lists, EFT.RigContents[equip.rigUID])
                end
                for _, list in ipairs(lists) do
                    if not list then continue end
                    for i, it in ipairs(list) do
                        if it.id == itemID then
                            table.remove(list, i)
                            return true
                        end
                    end
                end
                return false
            end

            if not quests.active["odessa_package"] then
                ply:ChatPrint("[Одесса] Сначала возьми задание.")
                return
            end
            if not findAndRemoveQuest("quest_odessa_package") then
                ply:ChatPrint("[Одесса] Посылки не вижу. Где товар?")
                return
            end
            quests.active["odessa_package"] = nil
            quests.completed["odessa_package"] = true
            EFT.AddReputation(ply, 75)
            local money = ply:GetNWInt("EFT_Money", 0)
            ply:SetNWInt("EFT_Money", money + 5000)
            ply:ChatPrint("[Одесса] Красава. +75 репутации, +5000₽.")
            EFT.AddExperience(ply, 50, "Квест: посылка")
            net.Start("EFT_QuestProgress")
                net.WriteString("odessa_package")
                net.WriteString("completed")
            net.Send(ply)
            if EFT.Improvements and EFT.Improvements.SyncAll then
                EFT.Improvements.SyncAll(ply)
            end
        elseif stage == "turnin_document" then
            local function findAndRemoveQuest(itemID)
                local lists = {
                    EFT.VirtualInventory and EFT.VirtualInventory[ply],
                    EFT.GetPantsInv(ply),
                    EFT.GetShirtInv(ply),
                }
                local equip = EFT.PlayerEquipment and EFT.PlayerEquipment[ply]
                if equip and equip.backpackUID and EFT.BackpackContents then
                    table.insert(lists, EFT.BackpackContents[equip.backpackUID])
                end
                if equip and equip.rigUID and EFT.RigContents then
                    table.insert(lists, EFT.RigContents[equip.rigUID])
                end
                for _, list in ipairs(lists) do
                    if not list then continue end
                    for i, it in ipairs(list) do
                        if it.id == itemID then
                            table.remove(list, i)
                            return true
                        end
                    end
                end
                return false
            end

            if not quests.active["odessa_document"] then
                ply:ChatPrint("[Одесса] Сначала возьми задание.")
                return
            end
            if not findAndRemoveQuest("quest_military_document") then
                ply:ChatPrint("[Одесса] Документа нет. Ищи лучше.")
                return
            end
            quests.active["odessa_document"] = nil
            quests.completed["odessa_document"] = true
            EFT.AddReputation(ply, 100)
            local money = ply:GetNWInt("EFT_Money", 0)
            ply:SetNWInt("EFT_Money", money + 8000)
            ply:ChatPrint("[Одесса] Документ на месте. +100 репутации, +8000₽.")
            EFT.AddExperience(ply, 60, "Квест: документ")
            net.Start("EFT_QuestProgress")
                net.WriteString("odessa_document")
                net.WriteString("completed")
            net.Send(ply)
            if EFT.Improvements and EFT.Improvements.SyncAll then
                EFT.Improvements.SyncAll(ply)
            end
        end
    end)

    -- Интеграция слотов одежды в GetInvAndSize / AddToPersonalInventory (если основной код использует хуки)
    -- Расширяем поиск предметов: штаны и кофта тоже инвентари
    local _oldFindPersonal = nil
    -- Безопасный fallback: при добавлении предметов пробуем штаны/кофту

    print("[EFT-REWORK] Server: clothing, skills, reputation, Odessa dialog/quests ready.")
end

-- ==========================================
-- КЛИЕНТ
-- ==========================================
if CLIENT then
    local SkillsData = {
        level = 1, xp = 0, perkPoints = 1,
        reputation = 0, reputationXP = 0, perks = {},
    }
    EFT.ClientSkills = SkillsData
    local QuestState = { active = {}, completed = {} }

    net.Receive("EFT_SyncSkillsRep", function()
        SkillsData.level = net.ReadUInt(8)
        SkillsData.xp = net.ReadUInt(16)
        SkillsData.perkPoints = net.ReadUInt(8)
        SkillsData.reputation = net.ReadUInt(16)
        SkillsData.reputationXP = net.ReadUInt(16)
        SkillsData.perks = net.ReadTable() or {}
        EFT.ClientSkills = SkillsData
    end)

    net.Receive("EFT_QuestProgress", function()
        local id = net.ReadString()
        local st = net.ReadString()
        if st == "completed" then
            QuestState.active[id] = nil
            QuestState.completed[id] = true
        else
            QuestState.active[id] = { state = st }
        end
    end)

    -- ---------- Диалог Одессы ----------
    local odessaFrame

    local function CloseOdessaDialog()
        if IsValid(odessaFrame) then odessaFrame:Close() end
        odessaFrame = nil
    end

    local function BuildOdessaDialog(ent, questData)
        CloseOdessaDialog()
        QuestState.active = (questData and questData.active) or {}
        QuestState.completed = (questData and questData.completed) or {}

        local fr = vgui.Create("DFrame")
        fr:SetSize(540, 400)
        fr:Center()
        fr:SetTitle("")
        fr:MakePopup()
        fr:ShowCloseButton(false)
        odessaFrame = fr

        local stage = "root" -- root | jobs
        local npcText = "Ну здарова, чего нужно говори."

        -- Область текста NPC (с переносом строк)
        local textBox = vgui.Create("DPanel", fr)
        textBox:SetPos(12, 48)
        textBox:SetSize(516, 110)
        textBox.Paint = function(s, w, h)
            draw.RoundedBox(4, 0, 0, w, h, Color(22, 20, 16))
            surface.SetDrawColor(220, 110, 30, 160)
            surface.DrawOutlinedRect(0, 0, w, h)
        end
        local textLbl = vgui.Create("DLabel", textBox)
        textLbl:SetPos(10, 8)
        textLbl:SetSize(496, 94)
        textLbl:SetFont("DermaDefault")
        textLbl:SetTextColor(Color(240, 235, 220))
        textLbl:SetWrap(true)
        textLbl:SetAutoStretchVertical(false)
        textLbl:SetContentAlignment(7) -- top-left
        textLbl:SetText(npcText)

        local function SetNpcText(t)
            npcText = t or ""
            if IsValid(textLbl) then textLbl:SetText(npcText) end
        end

        fr.Paint = function(self, w, h)
            draw.RoundedBox(6, 0, 0, w, h, Color(14, 14, 12, 250))
            surface.SetDrawColor(220, 110, 30)
            surface.DrawOutlinedRect(0, 0, w, h, 2)
            draw.RoundedBox(0, 0, 0, w, 36, Color(10, 11, 12))
            surface.SetDrawColor(220, 110, 30)
            surface.DrawRect(0, 34, w, 2)
            draw.SimpleText("ОДЕССА", "DermaDefaultBold", 14, 10, Color(235, 180, 40))
        end

        local closeBtn = vgui.Create("DButton", fr)
        closeBtn:SetSize(36, 36)
        closeBtn:SetPos(540 - 36, 0)
        closeBtn:SetText("✕")
        closeBtn.Paint = function(s, w, h)
            if s:IsHovered() then draw.RoundedBox(0, 0, 0, w, h, Color(170, 70, 60)) end
            s:SetTextColor(Color(240, 240, 240))
        end
        closeBtn.DoClick = CloseOdessaDialog

        local btnPanel = vgui.Create("DPanel", fr)
        btnPanel:SetPos(12, 170)
        btnPanel:SetSize(516, 210)
        btnPanel.Paint = function() end

        local function ClearButtons()
            for _, c in ipairs(btnPanel:GetChildren()) do c:Remove() end
        end

        local function AddChoice(text, onClick)
            local b = vgui.Create("DButton", btnPanel)
            b:Dock(TOP)
            b:DockMargin(0, 0, 0, 6)
            b:SetTall(32)
            b:SetText("")
            b.Paint = function(s, w, h)
                local hv = s:IsHovered()
                draw.RoundedBox(3, 0, 0, w, h, hv and Color(40, 38, 32) or Color(28, 27, 24))
                surface.SetDrawColor(hv and Color(180, 165, 120) or Color(70, 68, 60))
                surface.DrawOutlinedRect(0, 0, w, h)
                draw.SimpleText(text, "DermaDefault", 12, h / 2, Color(220, 218, 210), TEXT_ALIGN_LEFT, TEXT_ALIGN_CENTER)
            end
            b.DoClick = onClick
            return b
        end

        local function ShowRoot()
            ClearButtons()
            stage = "root"
            SetNpcText("Ну здарова, чего нужно говори.")

            AddChoice("1. Я хотел бы кое что продать.", function()
                net.Start("EFT_OdessaDialogChoice")
                    net.WriteString("buy")
                    net.WriteString("root")
                net.SendToServer()
                CloseOdessaDialog()
            end)

            AddChoice("2. Слушай, есть какая работа?", function()
                net.Start("EFT_OdessaDialogChoice")
                    net.WriteString("jobs")
                    net.WriteString("root")
                net.SendToServer()
                ShowJobs()
            end)

            AddChoice("3. Ладно, встретимся ещё.", function()
                net.Start("EFT_OdessaDialogChoice")
                    net.WriteString("bye")
                    net.WriteString("root")
                net.SendToServer()
                CloseOdessaDialog()
            end)
        end

        function ShowJobs()
            ClearButtons()
            stage = "jobs"
            SetNpcText("Ну давай глянем что там есть...")

            -- Квест 1
            local q1Done = QuestState.completed["odessa_package"]
            local q1Active = QuestState.active["odessa_package"]
            local q1Label = "1. Посылка возле БТР"
            if q1Done then
                q1Label = "1. [Выполнено] Посылка возле БТР"
            elseif q1Active then
                q1Label = "1. [Сдать] Посылка Одессы"
            end

            AddChoice(q1Label, function()
                if q1Done then return end
                if q1Active then
                    net.Start("EFT_OdessaDialogChoice")
                        net.WriteString("turnin")
                        net.WriteString("turnin_package")
                    net.SendToServer()
                    CloseOdessaDialog()
                    return
                end
                -- Описание квеста
                ClearButtons()
                SetNpcText("Я посылал одного человека за товаром. Но от него нету вестей. По последней информации он оставил эту посылку возле БТР. Твоя задача забрать мою посылку.")
                AddChoice("Принять задание", function()
                    net.Start("EFT_OdessaDialogChoice")
                        net.WriteString("accept")
                        net.WriteString("accept_package")
                    net.SendToServer()
                    QuestState.active["odessa_package"] = { state = "active" }
                    CloseOdessaDialog()
                end)
                AddChoice("Назад", function() ShowJobs() end)
            end)

            -- Квест 2
            local q2Done = QuestState.completed["odessa_document"]
            local q2Active = QuestState.active["odessa_document"]
            local q2Label = "2. Документ с места крушения"
            if q2Done then
                q2Label = "2. [Выполнено] Документ с места крушения"
            elseif q2Active then
                q2Label = "2. [Сдать] Военный документ"
            end

            AddChoice(q2Label, function()
                if q2Done then return end
                if q2Active then
                    net.Start("EFT_OdessaDialogChoice")
                        net.WriteString("turnin")
                        net.WriteString("turnin_document")
                    net.SendToServer()
                    CloseOdessaDialog()
                    return
                end
                ClearButtons()
                SetNpcText("Недавно над городом пролетал военный вертолёт и разбился. По слухам там есть ценный военный документ. Сходи и принеси его мне, деньгами не обижу.")
                AddChoice("Принять задание", function()
                    net.Start("EFT_OdessaDialogChoice")
                        net.WriteString("accept")
                        net.WriteString("accept_document")
                    net.SendToServer()
                    QuestState.active["odessa_document"] = { state = "active" }
                    CloseOdessaDialog()
                end)
                AddChoice("Назад", function() ShowJobs() end)
            end)

            AddChoice("3. Ладно, встретимся ещё.", function()
                CloseOdessaDialog()
            end)
        end

        ShowRoot()
    end

    net.Receive("EFT_OpenOdessaDialog", function()
        local ent = net.ReadEntity()
        local qdata = net.ReadTable() or {}
        BuildOdessaDialog(ent, qdata)
    end)

    -- F на Одессе → диалог (приоритет над магазином)
    local wasFOdessa = false
    hook.Add("Think", "EFT_Rework_OdessaF", function()
        local ply = LocalPlayer()
        if not IsValid(ply) or not ply:Alive() or vgui.CursorVisible() then
            wasFOdessa = input.IsKeyDown(KEY_F)
            return
        end
        local down = input.IsKeyDown(KEY_F)
        if down and not wasFOdessa then
            local tr = ply:GetEyeTrace()
            if IsValid(tr.Entity) and tr.Entity:GetClass() == "npc_odessa" then
                local dist = (EFT.Config.LootDistance or 110)
                if ply:GetPos():DistToSqr(tr.Entity:GetPos()) <= dist * dist then
                    net.Start("EFT_RequestOdessaDialog")
                        net.WriteEntity(tr.Entity)
                    net.SendToServer()
                end
            end
        end
        wasFOdessa = down
    end)

    hook.Add("HUDPaint", "EFT_Rework_OdessaHint", function()
        local ply = LocalPlayer()
        if not IsValid(ply) or not ply:Alive() then return end
        local tr = ply:GetEyeTrace()
        if IsValid(tr.Entity) and tr.Entity:GetClass() == "npc_odessa" then
            local dist = (EFT.Config.LootDistance or 110)
            if ply:GetPos():DistToSqr(tr.Entity:GetPos()) <= dist * dist then
                local cx, cy = ScrW() / 2, ScrH() / 2 + 42
                local size = 28
                local x, y = cx - size / 2, cy - size / 2
                draw.RoundedBox(4, x + 1, y + 1, size, size, Color(0, 0, 0, 160))
                draw.RoundedBox(4, x, y, size, size, Color(12, 12, 12, 230))
                surface.SetDrawColor(220, 110, 30, 200)
                surface.DrawOutlinedRect(x, y, size, size, 1)
                draw.SimpleText("F", "DermaDefaultBold", cx, cy, Color(240, 240, 240), TEXT_ALIGN_CENTER, TEXT_ALIGN_CENTER)
            end
        end
    end)

    -- ---------- Диалог Барни (продавец оружия) ----------
    local barneyFrame
    local barneyEnt = NULL

    local function CloseBarneyDialog()
        if IsValid(barneyFrame) then barneyFrame:Close() end
        barneyFrame = nil
        barneyEnt = NULL
    end

    local function BuildBarneyDialog(ent, money)
        CloseBarneyDialog()
        barneyEnt = IsValid(ent) and ent or NULL

        local fr = vgui.Create("DFrame")
        fr:SetSize(540, 360)
        fr:Center()
        fr:SetTitle("")
        fr:MakePopup()
        fr:ShowCloseButton(false)
        barneyFrame = fr

        local npcText = "Ну чего надо, боец? Оружие есть, если с деньгами."

        local textBox = vgui.Create("DPanel", fr)
        textBox:SetPos(12, 48)
        textBox:SetSize(516, 100)
        textBox.Paint = function(s, w, h)
            draw.RoundedBox(4, 0, 0, w, h, Color(22, 20, 16))
            surface.SetDrawColor(70, 140, 200, 160)
            surface.DrawOutlinedRect(0, 0, w, h)
        end
        local textLbl = vgui.Create("DLabel", textBox)
        textLbl:SetPos(10, 8)
        textLbl:SetSize(496, 84)
        textLbl:SetFont("DermaDefault")
        textLbl:SetTextColor(Color(240, 235, 220))
        textLbl:SetWrap(true)
        textLbl:SetAutoStretchVertical(false)
        textLbl:SetContentAlignment(7)
        textLbl:SetText(npcText)

        local function SetNpcText(t)
            npcText = t or ""
            if IsValid(textLbl) then textLbl:SetText(npcText) end
        end

        fr.Paint = function(self, w, h)
            draw.RoundedBox(6, 0, 0, w, h, Color(14, 14, 12, 250))
            surface.SetDrawColor(70, 140, 200)
            surface.DrawOutlinedRect(0, 0, w, h, 2)
            draw.RoundedBox(0, 0, 0, w, 36, Color(10, 11, 12))
            surface.SetDrawColor(70, 140, 200)
            surface.DrawRect(0, 34, w, 2)
            draw.SimpleText("БАРНИ — ТОРГОВЕЦ ОРУЖИЕМ", "DermaDefaultBold", 14, 10, Color(120, 180, 230))
            draw.SimpleText(string.format("Деньги: %d₽", money or 0), "DermaDefault", w - 14, 10, Color(180, 200, 160), TEXT_ALIGN_RIGHT)
        end

        local closeBtn = vgui.Create("DButton", fr)
        closeBtn:SetSize(36, 36)
        closeBtn:SetPos(540 - 36, 0)
        closeBtn:SetText("✕")
        closeBtn.Paint = function(s, w, h)
            if s:IsHovered() then draw.RoundedBox(0, 0, 0, w, h, Color(170, 70, 60)) end
            s:SetTextColor(Color(240, 240, 240))
        end
        closeBtn.DoClick = CloseBarneyDialog

        local btnPanel = vgui.Create("DPanel", fr)
        btnPanel:SetPos(12, 160)
        btnPanel:SetSize(516, 180)
        btnPanel.Paint = function() end

        local function ClearButtons()
            for _, c in ipairs(btnPanel:GetChildren()) do c:Remove() end
        end

        local function AddChoice(text, onClick)
            local b = vgui.Create("DButton", btnPanel)
            b:Dock(TOP)
            b:DockMargin(0, 0, 0, 6)
            b:SetTall(34)
            b:SetText("")
            b.Paint = function(s, w, h)
                local hv = s:IsHovered()
                draw.RoundedBox(3, 0, 0, w, h, hv and Color(35, 40, 48) or Color(26, 28, 32))
                surface.SetDrawColor(hv and Color(100, 160, 220) or Color(55, 65, 80))
                surface.DrawOutlinedRect(0, 0, w, h)
                draw.SimpleText(text, "DermaDefault", 12, h / 2, Color(220, 222, 230), TEXT_ALIGN_LEFT, TEXT_ALIGN_CENTER)
            end
            b.DoClick = onClick
            return b
        end

        ClearButtons()

        AddChoice("1. Я хотел бы поторговать.", function()
            net.Start("EFT_BarneyDialogChoice")
                net.WriteString("trade")
                net.WriteEntity(barneyEnt)
            net.SendToServer()
            CloseBarneyDialog()
        end)

        AddChoice("2. Ты знаешь где достать простой набор инструментов?", function()
            SetNpcText("Могу достать набор для лёгкой работы. Оборот 2500₽ — бери или проходи мимо.")
            ClearButtons()
            AddChoice("Заплатить 2500₽", function()
                net.Start("EFT_BarneyDialogChoice")
                    net.WriteString("tools")
                    net.WriteEntity(barneyEnt)
                net.SendToServer()
                CloseBarneyDialog()
            end)
            AddChoice("Назад", function()
                CloseBarneyDialog()
                timer.Simple(0, function()
                    if IsValid(barneyEnt) then
                        BuildBarneyDialog(barneyEnt, LocalPlayer():GetNWInt("EFT_Money", 0))
                    end
                end)
            end)
        end)

        AddChoice("3. Встретимся ещё.", function()
            net.Start("EFT_BarneyDialogChoice")
                net.WriteString("bye")
                net.WriteEntity(barneyEnt)
            net.SendToServer()
            CloseBarneyDialog()
        end)
    end

    net.Receive("EFT_OpenBarneyDialog", function()
        local ent = net.ReadEntity()
        local money = net.ReadInt(32)
        BuildBarneyDialog(ent, money)
    end)

    -- F на Барни → диалог (торговля только через окно)
    local wasFBarney = false
    hook.Add("Think", "EFT_Rework_BarneyF", function()
        local ply = LocalPlayer()
        if not IsValid(ply) or not ply:Alive() or vgui.CursorVisible() then
            wasFBarney = input.IsKeyDown(KEY_F)
            return
        end
        local down = input.IsKeyDown(KEY_F)
        if down and not wasFBarney then
            local tr = ply:GetEyeTrace()
            if IsValid(tr.Entity) and tr.Entity:GetClass() == "npc_weapon_dealer" then
                local dist = (EFT.Config.LootDistance or 110)
                if ply:GetPos():DistToSqr(tr.Entity:GetPos()) <= dist * dist then
                    net.Start("EFT_RequestBarneyDialog")
                        net.WriteEntity(tr.Entity)
                    net.SendToServer()
                end
            end
        end
        wasFBarney = down
    end)

    hook.Add("HUDPaint", "EFT_Rework_BarneyHint", function()
        local ply = LocalPlayer()
        if not IsValid(ply) or not ply:Alive() then return end
        local tr = ply:GetEyeTrace()
        if IsValid(tr.Entity) and tr.Entity:GetClass() == "npc_weapon_dealer" then
            local dist = (EFT.Config.LootDistance or 110)
            if ply:GetPos():DistToSqr(tr.Entity:GetPos()) <= dist * dist then
                local cx, cy = ScrW() / 2, ScrH() / 2 + 42
                local size = 28
                local x, y = cx - size / 2, cy - size / 2
                draw.RoundedBox(4, x + 1, y + 1, size, size, Color(0, 0, 0, 160))
                draw.RoundedBox(4, x, y, size, size, Color(12, 12, 12, 230))
                surface.SetDrawColor(70, 140, 200, 200)
                surface.DrawOutlinedRect(x, y, size, size, 1)
                draw.SimpleText("F", "DermaDefaultBold", cx, cy, Color(240, 240, 240), TEXT_ALIGN_CENTER, TEXT_ALIGN_CENTER)
            end
        end
    end)

    -- ---------- Улучшенное превью персонажа (квадрат) ----------
    -- Хук, который основной Desk может использовать, либо отдельная панель
    function EFT.BuildCharacterSquarePreview(parent, x, y, size, playerName)
        size = size or 160
        local root = vgui.Create("DPanel", parent)
        root:SetPos(x, y)
        root:SetSize(size + 120, size + 40) -- квадрат + место под имя сбоку + репутация снизу

        root.Paint = function(self, w, h)
            -- фон
            draw.RoundedBox(4, 0, 0, size, size, Color(16, 16, 14))
            surface.SetDrawColor(180, 165, 120)
            surface.DrawOutlinedRect(0, 0, size, size, 2)
        end

        -- Квадратная моделька
        local mdl = vgui.Create("DModelPanel", root)
        mdl:SetPos(2, 2)
        mdl:SetSize(size - 4, size - 4)
        mdl:SetFOV(28)
        mdl:SetCamPos(Vector(55, 0, 42))
        mdl:SetLookAt(Vector(0, 0, 36))
        local ply = LocalPlayer()
        if IsValid(ply) then
            mdl:SetModel(ply:GetModel())
            -- копируем skin / bodygroups
            local ent = mdl:GetEntity()
            if IsValid(ent) then
                ent:SetSkin(ply:GetSkin() or 0)
                for i = 0, ply:GetNumBodyGroups() - 1 do
                    ent:SetBodygroup(i, ply:GetBodygroup(i))
                end
            end
        end
        function mdl:LayoutEntity(ent)
            if IsValid(ent) then
                ent:SetAngles(Angle(0, 25, 0))
            end
        end

        -- Имя сбоку
        local nameLbl = vgui.Create("DLabel", root)
        nameLbl:SetPos(size + 10, 8)
        nameLbl:SetSize(110, 40)
        nameLbl:SetFont("DermaDefaultBold")
        nameLbl:SetTextColor(Color(220, 218, 210))
        nameLbl:SetText(playerName or (IsValid(LocalPlayer()) and LocalPlayer():Nick()) or "Оператор")
        nameLbl:SetWrap(true)

        -- Репутация под квадратом
        local repLbl = vgui.Create("DLabel", root)
        repLbl:SetPos(0, size + 4)
        repLbl:SetSize(size, 20)
        repLbl:SetFont("DermaDefault")
        repLbl:SetTextColor(Color(180, 165, 120))
        repLbl:SetContentAlignment(5)
        repLbl.Think = function(s)
            s:SetText(string.format("Репутация: %d ур.", SkillsData.reputation or 0))
        end

        -- Уровень навыка / очки перка рядом с именем
        local skillLbl = vgui.Create("DLabel", root)
        skillLbl:SetPos(size + 10, 52)
        skillLbl:SetSize(110, 60)
        skillLbl:SetFont("Default")
        skillLbl:SetTextColor(Color(140, 138, 120))
        skillLbl:SetWrap(true)
        skillLbl.Think = function(s)
            s:SetText(string.format("Навык: %d\nXP: %d\nПерки: %d",
                SkillsData.level or 1,
                SkillsData.xp or 0,
                SkillsData.perkPoints or 0))
        end

        return root, mdl
    end

    -- ---------- Панель перков (открывается из инвентаря или по клавише) ----------
    local perkFrame
    local function OpenPerkMenu()
        if IsValid(perkFrame) then perkFrame:Close() end
        net.Start("EFT_RequestSkillsRep") net.SendToServer()

        local fr = vgui.Create("DFrame")
        fr:SetSize(420, 360)
        fr:Center()
        fr:SetTitle("")
        fr:MakePopup()
        fr:ShowCloseButton(true)
        perkFrame = fr
        fr.Paint = function(s, w, h)
            draw.RoundedBox(6, 0, 0, w, h, Color(12, 12, 11, 250))
            surface.SetDrawColor(180, 165, 120)
            surface.DrawOutlinedRect(0, 0, w, h)
            draw.SimpleText("НАВЫКИ И ПЕРКИ", "DermaDefaultBold", 14, 10, Color(180, 165, 120))
            draw.SimpleText(string.format("Очки перка: %d  |  Уровень: %d  |  Репутация: %d",
                SkillsData.perkPoints or 0, SkillsData.level or 1, SkillsData.reputation or 0),
                "Default", 14, 32, Color(160, 158, 145))
        end

        local scroll = vgui.Create("DScrollPanel", fr)
        scroll:SetPos(12, 56)
        scroll:SetSize(396, 290)

        for _, def in ipairs(EFT.PerkDefs or {}) do
            local rank = (SkillsData.perks and SkillsData.perks[def.id]) or 0
            local row = scroll:Add("DButton")
            row:Dock(TOP)
            row:SetTall(52)
            row:DockMargin(0, 0, 0, 6)
            row:SetText("")
            row.Paint = function(s, w, h)
                local maxed = rank >= (def.maxRank or 1)
                draw.RoundedBox(3, 0, 0, w, h, Color(22, 22, 20))
                surface.SetDrawColor(maxed and Color(100, 160, 100) or Color(70, 68, 60))
                surface.DrawOutlinedRect(0, 0, w, h)
                draw.SimpleText(def.name, "DermaDefaultBold", 10, 6, Color(220, 218, 210))
                draw.SimpleText(def.desc, "Default", 10, 24, Color(140, 138, 120))
                draw.SimpleText(string.format("Ранг %d/%d", rank, def.maxRank or 1), "Default", w - 10, 8, Color(180, 165, 120), TEXT_ALIGN_RIGHT)
            end
            row.DoClick = function()
                if (SkillsData.perkPoints or 0) < 1 then
                    surface.PlaySound("buttons/button10.wav")
                    return
                end
                if rank >= (def.maxRank or 1) then return end
                net.Start("EFT_UnlockPerk")
                    net.WriteString(def.id)
                net.SendToServer()
                timer.Simple(0.2, function()
                    if IsValid(fr) then OpenPerkMenu() end
                end)
            end
        end
    end

    concommand.Add("eft_perks", OpenPerkMenu)

    -- Подсказка по репутации / перкам в HUD (лёгкая)
    hook.Add("HUDPaint", "EFT_Rework_RepHUD", function()
        local ply = LocalPlayer()
        if not IsValid(ply) or not ply:Alive() then return end
        -- Не дублируем, если уже есть vitals — рисуем компактно справа внизу
        draw.SimpleTextOutlined(
            string.format("REP %d  |  PERK %d", SkillsData.reputation or 0, SkillsData.perkPoints or 0),
            "Default", ScrW() - 12, ScrH() - 18,
            Color(180, 165, 120), TEXT_ALIGN_RIGHT, TEXT_ALIGN_BOTTOM, 1, Color(0, 0, 0, 180)
        )
    end)

    -- Интеграция с существующим Desk: при открытии EFT_SyncExtended добавляем квадрат персонажа
    -- Перехватываем после создания desk и вставляем превью
    local _oldOpenDesk
    hook.Add("Think", "EFT_Rework_PatchDeskPreview", function()
        -- Ищем открытый desk по глобальной переменной из основного файла (desk)
        -- В основном клиенте: local desk — недоступна. Используем vgui.GetWorldPanel children.
    end)

    -- Более надёжно: при нажатии I дополнительно запрашиваем skills и патчим UI
    local wasI = false
    -- I key is handled by cl_eft_empty_inventory.lua.


    -- Отдельная команда / хоткей для окна персонажа с квадратом + перками
    local charFrame
    local function OpenCharacterSheet()
        if ZCityEFTEmptyInventory then ZCityEFTEmptyInventory.Open(true) end
    end

    concommand.Add("eft_character", OpenCharacterSheet)

    -- Клавиша P — лист персонажа (не конфликтует с I-инвентарём)
    local wasP = false
    hook.Add("Think", "EFT_Rework_CharSheetKey", function()
        local ply = LocalPlayer()
        if not IsValid(ply) or not ply:Alive() or vgui.CursorVisible() then
            wasP = input.IsKeyDown(KEY_P)
            return
        end
        local down = input.IsKeyDown(KEY_P)
        if down and not wasP then
            if IsValid(charFrame) then charFrame:Close()
            else OpenCharacterSheet() end
        end
        wasP = down
    end)

    print("[EFT-REWORK] Client: character square preview, Odessa/Barney dialogs, perks UI ready.")
end

print("[EFT-COMPLETE UNIFIED] All systems loaded — loot, inventory, clothing, skills, Odessa/Barney dialogs.")
