# RTS Moba Flame

RTS móvil 2D (top-down / ¾) con **Flutter + Flame**. UI en **español**.

Repo: [GerardoRosas-27/rts-moba-flame](https://github.com/GerardoRosas-27/rts-moba-flame)

## v0.3.0 — Laboratorio + Construcción de naves + Puerto estelar

- Nuevo edificio **Laboratorio** (`building_roof_radar.png`) — obreros; al seleccionarlo: panel **Investigar**.
- Tech v0.3: **«Construcción de naves»** (minerales + Energía + tiempo). Al completar → flag global de desbloqueo.
- Tras la tech: se habilita **Puerto estelar** (`building_house_open.png`) — cola de producción de **5 naves** (tier 1→5).
- Naves (stubs Quaternius `vehicle_spaceship_*`): **Caza / Interceptor / Fragata / Crucero / Acorazado**.
- Se mantienen: Energía por paneles solares, harvest de minerales, obras incompletas reanudables (v0.2.2).

### Costos tech (v0.3)

| Tech | Minerales | Energía | Tiempo |
|------|-----------|---------|--------|
| Construcción de naves | 150 | 100 | 60 s |

### Costos edificios nuevos

| Edificio | Minerales | Energía | Tiempo | Notas |
|----------|-----------|---------|--------|-------|
| Laboratorio | 150 | 50 | 40 s | Panel Investigar |
| Puerto estelar | 200 | 100 | 50 s | Requiere tech naves |

### Costos naves (Puerto estelar)

| Nave | Minerales | Energía | Suministro | Tiempo | Sprite stub |
|------|-----------|---------|------------|--------|-------------|
| Caza | 75 | 25 | 2 | 20 s | `vehicle_spaceship_rae.png` |
| Interceptor | 100 | 40 | 2 | 25 s | `vehicle_spaceship_finn.png` |
| Fragata | 150 | 60 | 3 | 35 s | `vehicle_spaceship_barbara.png` |
| Crucero | 225 | 90 | 4 | 50 s | `vehicle_spaceship_fernando.png` |
| Acorazado | 350 | 150 | 6 | 75 s | `vehicle_spaceship_fernando.png` (mayor) |

### Cómo jugar (ruta naves)

1. Economia base: minerales + **Paneles solares** (Energía).
2. Construye **Laboratorio** → selecciona → **Investigar** «Construcción de naves».
3. Cuando termine la tech, construye **Puerto estelar** con obreros.
4. Selecciona el Puerto → produce Caza…Acorazado (spawn cerca del puerto).

## v0.2.2 — Energía (paneles solares) + reanudar construcción

- Recurso **Gas → Energía** (HUD, costos, toasts). Sin géiseres ni recolección de gas.
- Nuevo edificio **Panel solar** — colocable en cualquier sitio válido.
- Energía **pasiva**: **+12 Energía/min** por cada Panel solar completo.
- **Reanudar obra**: sitios incompletos permanecen; cualquier obrero continúa desde el progreso actual (máx. 3).

## v0.2.1 — Hotfix pantalla gris (móvil)

- Rutas Flame corregidas + splash de carga + HUD tras `onLoad`.

## v0.2 — Kit Quaternius + Cuartel

Tema espacial con sprites del **Ultimate Platformer Pack** de Quaternius (CC0).

### Costos de unidades terrestres (heredados)

| Unidad | Minerales | Energía | Suministro | Tiempo |
|--------|-----------|---------|------------|--------|
| Obrero (Rae) | 50 | 0 | 1 | 12 s |
| Infantería Finn | 50 | 0 | 1 | 15 s |
| Infantería Barbara | 50 | 15 | 1 | 16 s |
| Rover | 100 | 25 | 2 | 25 s |
| Mech | 150 | 50 | 3 | 35 s |

Edificios base: Panel solar 100 (+12 Energía/min), Depósito 100 (+8 suministro), Cuartel 150, Puesto 150, CC 400 (+10 suministro).

### Mapeo de assets (Quaternius)

| Rol | Sprite | Modelo |
|-----|--------|--------|
| CC | `building_base_large.png` | Base_Large |
| Panel solar | `building_solarpanel_structure.png` | SolarPanel_Structure |
| Depósito | `building_geodesic_dome.png` | GeodesicDome |
| Cuartel | `building_l.png` | Building_L |
| Puesto | `building_house_cylinder.png` | House_Cylinder |
| Laboratorio | `building_roof_radar.png` | Roof_Radar |
| Puerto estelar | `building_house_open.png` | House_Open |
| Obreros / infantería | `unit_astronaut_*.png` | Astronaut_* |
| Rover / Mech | `vehicle_rover_*.png`, `vehicle_mech_*.png` | Rover_*, Mech_* |
| Naves (stub) | `vehicle_spaceship_*.png` | Spaceship_* |
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
    systems/          # economía, cola de producción, investigación
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
- v0.2.2 — Energía (paneles) + reanudar construcción
- v0.3 — Laboratorio + tech naves + Puerto estelar (este release)
- v0.3+ — combate real / capas MOBA / sprites Ultimate Spaceships

## Créditos / licencia de assets

**Ultimate Platformer Pack** by [Quaternius](https://quaternius.com) — **CC0 1.0 Universal**
