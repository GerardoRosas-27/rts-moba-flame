# RTS MOBA Kit — Sprite Manifest

Transparent PNG sprites rendered from Quaternius packs (CC0):
- **Ultimate Platformer Pack** — buildings, astronauts, rovers, mechs, props
- **Ultimate Spaceships** (May 2021) — Puerto estelar ship tiers (blue variant)

Orthographic RTS isometric (~55° pitch, 45° yaw), PNG RGBA, film transparent.

License: see `License.txt` (CC0 1.0 Public Domain Dedication)

## Camera / format

- Orthographic, pitch ≈ 55° looking down, yaw ≈ 45° (classic RTS isometric-ish)
- PNG RGBA, film transparent
- Units/vehicles ≈ 128–224px; buildings ≈ 256–384px; props ≈ 160–224px
- Ships (Ultimate Spaceships): 160–320px by tier

## Suggested game roles

| Role | Sprites | Notes |
|------|---------|-------|
| **Command Center (CC)** | `building_base_large.png` | Main base / HQ |
| **Barracks → foot troops** | `unit_astronaut_*.png` | Train Astronaut_* infantry |
| **Barracks → ground vehicles** | `vehicle_rover_*.png`, `vehicle_mech_*.png` | Rovers + Mechs |
| **Puerto estelar → naves** | `ship_tier*_*.png` | Ultimate Spaceships tiers 1–5 |
| **Refinery / power** | `building_solarpanel_structure.png`, `building_geodesic_dome.png` | Also `building_solarpanel_ground.png` |
| **Secondary structures** | `building_l.png`, `building_house_*.png`, `building_roof_radar.png` | Outposts / housing / radar |
| **Terrain props** | `prop_rock_*.png`, `prop_tree_*.png`, `prop_planet_1.png` | Decor / obstacles |

---

## Units (foot troops — Barracks)

| PNG | Source model | Size | Role |
|-----|--------------|------|------|
| `unit_astronaut_barbara.png` | Astronaut_BarbaraTheBee | 192 | Foot troop (Bee skin) |
| `unit_astronaut_fernando.png` | Astronaut_FernandoTheFlamingo | 192 | Foot troop (Flamingo skin) |
| `unit_astronaut_finn.png` | Astronaut_FinnTheFrog | 192 | Foot troop (Frog skin) |
| `unit_astronaut_rae.png` | Astronaut_RaeTheRedPanda | 192 | Foot troop (Red Panda skin) |

## Vehicles (Barracks / factory)

| PNG | Source model | Size | Role |
|-----|--------------|------|------|
| `vehicle_mech_barbara.png` | Mech_BarbaraTheBee | 224 | Ground mech |
| `vehicle_mech_finn.png` | Mech_FinnTheFrog | 224 | Ground mech |
| `vehicle_mech_rae.png` | Mech_RaeTheRedPanda | 224 | Ground mech |
| `vehicle_rover_1.png` | Rover_1 | 224 | Ground rover |
| `vehicle_rover_2.png` | Rover_2 | 224 | Ground rover |
| `vehicle_rover_round.png` | Rover_Round | 224 | Ground rover |

## Naves (Puerto estelar — Ultimate Spaceships)

| PNG | Game name (ES) | Quaternius model | Canvas | Tier |
|-----|----------------|------------------|--------|------|
| `ship_tier1_dispatcher.png` | Caza | Dispatcher | 160×160 | 1 |
| `ship_tier2_bob.png` | Interceptor | Bob | 200×200 | 2 |
| `ship_tier3_challenger.png` | Fragata | Challenger | 240×240 | 3 |
| `ship_tier4_imperial.png` | Crucero | Imperial | 280×280 | 4 |
| `ship_tier5_insurgent.png` | Acorazado | Insurgent | 320×320 | 5 |

Stubs `vehicle_spaceship_*` removed in v0.3.1.

## Buildings

| PNG | Source model | Size | Role |
|-----|--------------|------|------|
| `building_base_large.png` | Base_Large | 384 | **CC** — command center |
| `building_geodesic_dome.png` | GeodesicDome | 320 | Depósito / supply |
| `building_solarpanel_structure.png` | SolarPanel_Structure | 320 | Panel solar |
| `building_solarpanel_ground.png` | SolarPanel_Ground | 256 | Power addon |
| `building_l.png` | Building_L | 320 | Cuartel |
| `building_roof_radar.png` | Roof_Radar | 256 | Laboratorio |
| `building_house_single.png` | House_Single | 288 | Housing |
| `building_house_long.png` | House_Long | 320 | Housing |
| `building_house_cylinder.png` | House_Cylinder | 288 | Puesto |
| `building_house_open.png` | House_Open | 288 | Puerto estelar |

## Terrain props

| PNG | Source model | Size | Role |
|-----|--------------|------|------|
| `prop_rock_1.png` … `prop_rock_4.png` | Rock_* | 160 | Terrain rock |
| `prop_rock_large_1.png` … `_3.png` | Rock_Large_* | 224 | Large rock |
| `prop_tree_blob_1.png` | Tree_Blob_1 | 224 | Tree prop |
| `prop_tree_spiral_1.png` | Tree_Spiral_1 | 224 | Spiral tree |
| `prop_tree_swirl_1.png` | Tree_Swirl_1 | 224 | Swirl tree |
| `prop_tree_lava_1.png` | Tree_Lava_1 | 224 | Alien tree |
| `prop_tree_light_1.png` | Tree_Light_1 | 224 | Glowing tree |
| `prop_tree_spikes_1.png` | Tree_Spikes_1 | 224 | Spiky tree |
| `prop_planet_1.png` | Planet_1 | 192 | Sky / decor planet |

## v0.3.1 roles

| Role | Sprite | Notes |
|------|--------|-------|
| Laboratorio | `building_roof_radar.png` | Investigación (tech naves) |
| Puerto estelar | `building_house_open.png` | Produce 5 naves |
| Caza | `ship_tier1_dispatcher.png` | Ultimate Spaceships — Dispatcher |
| Interceptor | `ship_tier2_bob.png` | Ultimate Spaceships — Bob |
| Fragata | `ship_tier3_challenger.png` | Ultimate Spaceships — Challenger |
| Crucero | `ship_tier4_imperial.png` | Ultimate Spaceships — Imperial |
| Acorazado | `ship_tier5_insurgent.png` | Ultimate Spaceships — Insurgent |


## Enemies (Asedio — tintados en juego)

| PNG | Role |
|-----|------|
| `unit_enemy_small.png` | Hostile small |
| `unit_enemy_extrasmall.png` | Hostile extrasmall |
| `unit_enemy_flying.png` | Hostile flying |
| `unit_enemy_large.png` | Hostile large |

En batalla se recoloran (tint púrpura/rojo) para distinguir facción.
