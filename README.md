# RTS Moba Flame

RTS móvil 2D (top-down / ¾) con **Flutter + Flame**. UI en **español**.

Repo: [GerardoRosas-27/rts-moba-flame](https://github.com/GerardoRosas-27/rts-moba-flame)

## v0.2 — Kit Quaternius + Cuartel

Tema espacial con sprites del **Ultimate Platformer Pack** de Quaternius (CC0).
Economía de v0.1 (obreros, minerales, gas, expansión) + **Cuartel** con cola de producción militar.

### Cómo jugar

1. Empiezas con **1 Centro de Mando** (`Base_Large`) y **5 obreros** (`Astronaut_Rae`), **150 minerales**.
2. Recolecta minerales (cristales azules). Construye **Refinería** (`SolarPanel_Structure`) sobre el géiser para gas.
3. Construye **Depósito** (`GeodesicDome`) para suministro y **Cuartel** (`Building_L`) para tropas.
4. Selecciona el **Cuartel** → produce:
   - Infantería Finn / Barbara (`Astronaut_*`)
   - **Rover** (`Rover_1`)
   - **Mech** (`Mech_FinnTheFrog`)
5. Pan / zoom / grupos 1–4 como en v0.1. Combate sigue en stub.

### Costos de unidades (v0.2)

| Unidad | Minerales | Gas | Suministro | Tiempo |
|--------|-----------|-----|------------|--------|
| Obrero (Rae) | 50 | 0 | 1 | 12 s |
| Infantería Finn | 50 | 0 | 1 | 15 s |
| Infantería Barbara | 50 | 15 | 1 | 16 s |
| Rover | 100 | 25 | 2 | 25 s |
| Mech | 150 | 50 | 3 | 35 s |

Edificios (sin cambio mayor vs v0.1): Refinería 100, Depósito 100 (+8 suministro), Cuartel 150, Puesto 150, CC 400 (+10 suministro).

### Mapeo de assets (Quaternius)

| Rol | Sprite | Modelo |
|-----|--------|--------|
| CC | `building_base_large.png` | Base_Large |
| Refinería / power | `building_solarpanel_structure.png` | SolarPanel_Structure |
| Depósito | `building_geodesic_dome.png` | GeodesicDome |
| Cuartel | `building_l.png` | Building_L |
| Puesto | `building_house_cylinder.png` | House_Cylinder |
| Obreros / infantería | `unit_astronaut_*.png` | Astronaut_* |
| Rover / Mech | `vehicle_rover_*.png`, `vehicle_mech_*.png` | Rover_*, Mech_* |
| Props | `prop_rock_*`, `prop_tree_*`, `prop_planet_1` | Environment |

Sprites en `assets/images/` (PNG RGBA). Manifest: `assets/MANIFEST.md`.

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
  main.dart
  game/
    assets.dart       # carga sprites Quaternius
    balance.dart      # feel numbers
    enums.dart
    rts_game.dart
    components/       # unidades, edificios, props, terreno
    systems/          # economía, cola de producción
  ui/hud.dart         # HUD español
assets/
  images/             # PNG del kit
  License.txt         # Quaternius CC0
  MANIFEST.md
```

## Roadmap

- v0.1 — construcción + harvesting
- v0.2 — kit Quaternius + Cuartel / producción militar (este release)
- v0.3+ — combate real / capas MOBA

## Créditos / licencia de assets

**Ultimate Platformer Pack** by [Quaternius](https://quaternius.com) — **CC0 1.0 Universal**
(Public Domain Dedication). Ver `assets/License.txt`.

Considera apoyar a Quaternius en Patreon: https://www.patreon.com/quaternius

Código del juego: uso privado / demo del autor salvo que se indique lo contrario.
