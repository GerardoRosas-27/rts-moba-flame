# RTS Moba Flame

RTS móvil 2D (top-down / ¾) con **Flutter + Flame**. UI en **español**.

Repo: [GerardoRosas-27/rts-moba-flame](https://github.com/GerardoRosas-27/rts-moba-flame)

## v0.2.2 — Energía (paneles solares) + reanudar construcción

- Recurso **Gas → Energía** (HUD, costos, toasts). Sin géiseres ni recolección de gas.
- Nuevo edificio **Panel solar** (`building_solarpanel_structure.png` / ground) — colocable en **cualquier sitio válido**.
- Energía **pasiva**: **+12 Energía/min** por cada Panel solar completo (los obreros no cosechan energía).
- Costos que pedían gas ahora piden Energía (Barbara 15, Rover 25, Mech 50).
- **Reanudar obra**: si un obrero abandona un edificio a medias, el sitio **permanece**. Cualquier obrero puede continuar desde el progreso actual (no se reinicia a 0).
  - Toca la obra incompleta con obreros seleccionados → `orderBuild`.
  - O selecciona la obra → botón **Continuar construir**.
- **Varios obreros** en la misma obra: aceleran la construcción (cada uno suma progreso; hasta 3 asignados al colocar/reanudar).

## v0.2.1 — Hotfix pantalla gris (móvil)

- Rutas Flame corregidas: claves sin prefijo `images/` (prefix ya es `assets/images/`)
- Splash con barra de progreso «Cargando…» + pantalla de error con Reintentar
- HUD solo tras `onLoad` completo
- Sprites reducidos (~192–256px) y menos props de paisaje

## v0.2 — Kit Quaternius + Cuartel

Tema espacial con sprites del **Ultimate Platformer Pack** de Quaternius (CC0).
Economía de v0.1 (obreros, minerales, expansión) + **Cuartel** con cola de producción militar.

### Cómo jugar

1. Empiezas con **1 Centro de Mando** (`Base_Large`) y **5 obreros** (`Astronaut_Rae`), **150 minerales**, **0 Energía**.
2. Recolecta minerales (cristales azules). Construye **Panel solar** en cualquier sitio libre para generar Energía.
3. Construye **Depósito** (`GeodesicDome`) para suministro y **Cuartel** (`Building_L`) para tropas.
4. Selecciona el **Cuartel** → produce:
   - Infantería Finn / Barbara (`Astronaut_*`)
   - **Rover** (`Rover_1`)
   - **Mech** (`Mech_FinnTheFrog`)
5. Pan / zoom / grupos 1–4 como en v0.1. Combate sigue en stub.

### Costos de unidades (v0.2.2)

| Unidad | Minerales | Energía | Suministro | Tiempo |
|--------|-----------|---------|------------|--------|
| Obrero (Rae) | 50 | 0 | 1 | 12 s |
| Infantería Finn | 50 | 0 | 1 | 15 s |
| Infantería Barbara | 50 | 15 | 1 | 16 s |
| Rover | 100 | 25 | 2 | 25 s |
| Mech | 150 | 50 | 3 | 35 s |

Edificios: Panel solar 100 (+12 Energía/min), Depósito 100 (+8 suministro), Cuartel 150, Puesto 150, CC 400 (+10 suministro).

### Reanudar construcción

Si un obrero deja una obra a medias (`isComplete == false`, `buildProgress` parcial), el edificio **sigue en el mapa**. Cualquier obrero puede retomar desde el progreso actual. Varios obreros en la misma obra **aceleran** (suma de `dt / buildSecondsNeeded`; máx. 3 al asignar).

### Mapeo de assets (Quaternius)

| Rol | Sprite | Modelo |
|-----|--------|--------|
| CC | `building_base_large.png` | Base_Large |
| Panel solar | `building_solarpanel_structure.png` | SolarPanel_Structure |
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
- v0.2 — kit Quaternius + Cuartel / producción militar
- v0.2.1 — hotfix carga assets móvil
- v0.2.2 — Energía (paneles) + reanudar construcción (este release)
- v0.3+ — combate real / capas MOBA

## Créditos / licencia de assets

**Ultimate Platformer Pack** by [Quaternius](https://quaternius.com) — **CC0 1.0 Universal**
