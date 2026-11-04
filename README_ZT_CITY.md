# ZT-City — режим для Z-City + EFT

## Возможности

- **F6 → ZT-City** (`ztcity`)
- **Без спавна ящиков** Z-City (`LootSpawn = false`)
- Контейнеры на карте **обновляет твой EFT** (`LootRespawnTime`)
- **Свободный респавн** с таймером и полоской на экране смерти
- **Spawn-protection** (god + полупрозрачность) после появления
- Выбор точки спавна **подальше от живых** игроков
- Поздний вход в раунд
- K/D в HUD, уведомления в чат
- Динамическая музыка пака `ztcity`
- Раунд **не** заканчивается от смертей

## Установка

1. В геймод Z-City:
   ```
   gamemodes/zcity/gamemode/modes/ztcity/
     sv_ztcity.lua
     cl_ztcity.lua
     sh_ztcity.lua
   ```
2. В свой аддон:
   ```
   lua/autorun/sh_ztcity_dynmusic.lua
   sound/zc_dyna_music/ztcity/*.mp3
   ```
3. Рестарт / `changelevel` → **F6** → **ZT-City**

## ConVars (сервер)

| ConVar | По умолчанию | Описание |
|--------|--------------|----------|
| `ztcity_respawn_time` | `12` | Секунд до респавна (`0` = сразу) |
| `ztcity_spawn_protect` | `6` | Секунд защиты после спавна |
| `ztcity_spawn_min_enemy` | `800` | Мин. дистанция от живых при выборе точки |
| `ztcity_start_bandage` | `1` | Выдавать бинт при спавне |

```
ztcity_respawn_time 8
ztcity_spawn_protect 4
```

## Команды

| Команда | Кто | Действие |
|---------|-----|----------|
| `ztcity_force_respawn` | админ | Мгновенно зареспавнить себя |
| `ztcity_rebuild_spawns` | админ | Пересобрать кэш точек спавна |

## Музыка

`lua/autorun/sh_ztcity_dynmusic.lua` + mp3 в `sound/zc_dyna_music/ztcity/`.

## Респавн

После смерти → отсчёт → `Spawn()` на `info_player_*`.  
`PlayerDeathThink` не даёт ядру зареспавнить раньше таймера.  
Инвентарь EFT этим режимом **не** чистится.

## Хуки

```lua
hook.Add("EFT_RaidStarted", "...", function(mode) end) -- "ztcity"
hook.Add("EFT_RaidEnded",   "...", function(mode) end)
```
