# RTS Moba Flame

RTS móvil 2D (top-down / ¾) con **Flutter + Flame**. UI en **español**.

Repo: [GerardoRosas-27/rts-moba-flame](https://github.com/GerardoRosas-27/rts-moba-flame)

## v0.4.1 — Polish móvil

- Sombras proyectadas + highlight ligero en edificios/unidades (kit space).
- Tropas / naves / mechs / rovers **miran** hacia el movimiento o persecución.
- **Doble toque** en una unidad: selecciona el **mismo tipo** en radio corto (~150 px mundo); lejos no entra. Base + Asedio.
- Marcha en **formación** (rejilla) al ordenar movimiento (base + batalla).
- Combate: **proyectiles** animados, **explosiones** al impacto/muerte; enemigos con texturas `enemy_*` **tintadas** (púrpura).

### Feel (v0.4.1)

| Parámetro | Valor |
|-----------|-------|
| Radio selección por tipo | 150 world px |
| Ventana doble toque | 320 ms |
| Espaciado formación | 34 world px |
| Columnas máx. formación | 5 |

## v0.4.0 — Asedio PvE + Ciencias (grupos)

Pivot **base 4X + battle RTS lite**:

- Botón **BATALLA** en la base → Asedio PvE corto (3 min).
- Un mapa con **muralla/puerta** + IA enemiga por oleadas.
- Hasta **5 grupos** (botones grandes): drag a zona + comandos **Cargar / Mantener / Retirar / Fuego concentrado**.
- Progresión por **Ciencias** (Laboratorio). Al inicio solo **Soldados**; el resto se desbloquea por tech.
- Tropas de la ciudad se despliegan al Asedio; supervivientes regresan. Economía/ciudad se conserva (pausa).

### Orden de desbloqueo (grupos)

| # | Grupo | Tech requerida | Minerales | Energía | Tiempo |
|---|-------|----------------|-----------|---------|--------|
| 1 | Soldados | — (inicio) | — | — | — |
| 2 | Arqueros | Arqueros / choque | 75 | 25 | 40 s |
| 3 | Rovers | Vehículos terrestres | 100 | 50 | 50 s |
| 4 | Mechs | Mechs de asedio | 125 | 75 | 55 s |
| 5 | Naves | Construcción de naves (+ Puerto) | 150 | 100 | 60 s |

Cuartel/Puerto respetan las mismas techs al entrenar.

### Cómo jugar (loop diario)

1. Ciudad: minerales + paneles solares (Energía) + Cuartel.
2. Laboratorio → Ciencias (cadena Soldados → … → Naves).
3. Entrena tropas desbloqueadas → **BATALLA**.
4. En Asedio: selecciona grupo, Cargar / Fuego concentrado a la puerta; Retirada vuelve a base.

## v0.3.1 — Sprites Ultimate Spaceships (Puerto estelar)

Sprites CC0 Ultimate Spaceships para 5 tiers del Puerto estelar.

## v0.3.0 — Laboratorio + Construcción de naves + Puerto estelar

Laboratorio, tech naves, Puerto estelar (heredado; ahora encadenado tras Mechs).

## v0.2.x — Energía, reanudar obras, kit Quaternius

Paneles solares (+12 Energía/min), obras reanudables, Cuartel, sprites CC0.

### Costos de unidades terrestres

| Unidad | Minerales | Energía | Suministro | Tiempo | Tech |
|--------|-----------|---------|------------|--------|------|
| Obrero (Rae) | 50 | 0 | 1 | 12 s | — |
| Soldado (Finn) | 50 | 0 | 1 | 15 s | — |
| Arquero (Barbara) | 50 | 15 | 1 | 16 s | Arqueros |
| Rover | 100 | 25 | 2 | 25 s | Vehículos |
| Mech | 150 | 50 | 3 | 35 s | Mechs |

### Mapeo de assets (Quaternius)

Claves Flame **sin** prefijo `images/` (`Flame.images` ya usa `assets/images/`).

| Rol | Sprite |
|-----|--------|
| Soldados / Arqueros | `unit_astronaut_finn.png`, `unit_astronaut_barbara.png` |
| Rover / Mech | `vehicle_rover_1.png`, `vehicle_mech_finn.png` |
| Naves | `ship_tier1_dispatcher.png` … `ship_tier5_insurgent.png` |

## Ejecutar

```bash
export PATH="/home/box/flutter/bin:$PATH"
export ANDROID_HOME=/home/box/Android/Sdk
cd rts-moba-flame
flutter pub get
flutter run
```

Release Android:

```bash
flutter build apk --release
```

## Estructura

```
lib/
  main.dart                 # ciudad ↔ Asedio (Offstage + TickerMode)
  game/
    assets.dart
    balance.dart
    enums.dart
    rts_game.dart           # base 4X
    battle/                 # Asedio PvE
    components/
    systems/                # economía, producción, investigación
  ui/hud.dart
  ui/battle_hud.dart
```

## Roadmap

- v0.3.1 — sprites Ultimate Spaceships
- **v0.4.0 — Asedio + Ciencias / grupos (este release)**
- v0.4+ — más mapas / frentes, balance fino, MOBA layers

## Créditos

**Ultimate Platformer Pack** y **Ultimate Spaceships** by [Quaternius](https://quaternius.com) — **CC0 1.0 Universal**
