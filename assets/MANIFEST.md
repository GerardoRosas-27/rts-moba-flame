# RTS MOBA Kit — Sprite Manifest

Transparent PNG sprites rendered from Quaternius **Ultimate Platformer Pack** (CC0)
GLTF models via Blender 4.2 Cycles (orthographic camera, ~55° pitch, 45° yaw).

Source: `/workspace/rts-moba-kit/`  
Renderer: `/workspace/tools/blender/blender` + `render_sprites.py`  
License: see `License.txt` (CC0 1.0 Public Domain Dedication)

## Camera / format

- Orthographic, pitch ≈ 55° looking down, yaw ≈ 45° (classic RTS isometric-ish)
- PNG RGBA, film transparent
- Units/vehicles ≈ 128–224px; buildings ≈ 256–384px; props ≈ 160–224px

## Suggested game roles

| Role | Sprites | Notes |
|------|---------|-------|
| **Command Center (CC)** | `building_base_large.png` | Main base / HQ |
| **Barracks → foot troops** | `unit_astronaut_*.png` | Train Astronaut_* infantry |
| **Barracks → ground vehicles** | `vehicle_rover_*.png`, `vehicle_mech_*.png` | Rovers + Mechs |
| **Barracks / air pad → air** | `vehicle_spaceship_*.png` | Optional air units |
| **Refinery / power** | `building_solarpanel_structure.png`, `building_geodesic_dome.png` | Also `building_solarpanel_ground.png`, `building_solarpanel_roof.png` |
| **Secondary structures** | `building_l.png`, `building_house_*.png`, `building_roof_radar.png` | Outposts / housing / radar |
| **Hostile units** | `unit_enemy_*.png` | Enemy faction / creeps |
| **Terrain props** | `prop_rock_*.png`, `prop_tree_*.png`, `prop_planet_1.png` | Decor / obstacles |

---

## Units (foot troops — Barracks)

| PNG | Source model | Size | Role |
|-----|--------------|------|------|
| `unit_astronaut_barbara.png` | Astronaut_BarbaraTheBee | 192 | Foot troop (Bee skin) |
| `unit_astronaut_fernando.png` | Astronaut_FernandoTheFlamingo | 192 | Foot troop (Flamingo skin) |
| `unit_astronaut_finn.png` | Astronaut_FinnTheFrog | 192 | Foot troop (Frog skin) |
| `unit_astronaut_rae.png` | Astronaut_RaeTheRedPanda | 192 | Foot troop (Red Panda skin) |

## Enemies

| PNG | Source model | Size | Role |
|-----|--------------|------|------|
| `unit_enemy_extrasmall.png` | Enemy_ExtraSmall | 128 | Creep / scout enemy |
| `unit_enemy_small.png` | Enemy_Small | 160 | Standard enemy |
| `unit_enemy_large.png` | Enemy_Large | 224 | Elite / heavy enemy |
| `unit_enemy_flying.png` | Enemy_Flying | 192 | Flying enemy |

## Vehicles (Barracks / factory)

| PNG | Source model | Size | Role |
|-----|--------------|------|------|
| `vehicle_mech_barbara.png` | Mech_BarbaraTheBee | 224 | Ground mech |
| `vehicle_mech_fernando.png` | Mech_FernandoTheFlamingo | 224 | Ground mech |
| `vehicle_mech_finn.png` | Mech_FinnTheFrog | 224 | Ground mech |
| `vehicle_mech_rae.png` | Mech_RaeTheRedPanda | 224 | Ground mech |
| `vehicle_rover_1.png` | Rover_1 | 224 | Ground rover |
| `vehicle_rover_2.png` | Rover_2 | 224 | Ground rover |
| `vehicle_rover_round.png` | Rover_Round | 224 | Ground rover |

## Air (optional)

| PNG | Source model | Size | Role |
|-----|--------------|------|------|
| `vehicle_spaceship_barbara.png` | Spaceship_BarbaraTheBee | 224 | Air unit |
| `vehicle_spaceship_fernando.png` | Spaceship_FernandoTheFlamingo | 224 | Air unit |
| `vehicle_spaceship_finn.png` | Spaceship_FinnTheFrog | 224 | Air unit |
| `vehicle_spaceship_rae.png` | Spaceship_RaeTheRedPanda | 224 | Air unit |

## Buildings

| PNG | Source model | Size | Role |
|-----|--------------|------|------|
| `building_base_large.png` | Base_Large | 384 | **CC** — command center |
| `building_geodesic_dome.png` | GeodesicDome | 320 | Refinery / power / tech |
| `building_solarpanel_structure.png` | SolarPanel_Structure | 320 | Power plant / refinery |
| `building_solarpanel_ground.png` | SolarPanel_Ground | 256 | Power addon |
| `building_solarpanel_roof.png` | SolarPanel_Roof | 256 | Power addon |
| `building_l.png` | Building_L | 320 | Barracks / factory candidate |
| `building_roof_radar.png` | Roof_Radar | 256 | Radar / detection |
| `building_house_single.png` | House_Single | 288 | Housing / depot |
| `building_house_long.png` | House_Long | 320 | Housing / depot |
| `building_house_cylinder.png` | House_Cylinder | 288 | Housing / silo |
| `building_house_open.png` | House_Open | 288 | Open bay / hangar |
| `building_house_openback.png` | House_OpenBack | 288 | Open bay variant |
| `building_house_single_support.png` | House_Single_Support | 288 | Elevated housing |

## Terrain props

| PNG | Source model | Size | Role |
|-----|--------------|------|------|
| `prop_rock_1.png` | Rock_1 | 160 | Terrain rock |
| `prop_rock_2.png` | Rock_2 | 160 | Terrain rock |
| `prop_rock_3.png` | Rock_3 | 160 | Terrain rock |
| `prop_rock_4.png` | Rock_4 | 160 | Terrain rock |
| `prop_rock_large_1.png` | Rock_Large_1 | 224 | Large rock obstacle |
| `prop_rock_large_2.png` | Rock_Large_2 | 224 | Large rock obstacle |
| `prop_rock_large_3.png` | Rock_Large_3 | 224 | Large rock obstacle |
| `prop_tree_blob_1.png` | Tree_Blob_1 | 224 | Tree prop |
| `prop_tree_blob_2.png` | Tree_Blob_2 | 224 | Tree prop |
| `prop_tree_lava_1.png` | Tree_Lava_1 | 224 | Alien tree |
| `prop_tree_light_1.png` | Tree_Light_1 | 224 | Glowing tree |
| `prop_tree_spikes_1.png` | Tree_Spikes_1 | 224 | Spiky tree |
| `prop_tree_floating_1.png` | Tree_Floating_1 | 224 | Floating tree |
| `prop_tree_spiral_1.png` | Tree_Spiral_1 | 224 | Spiral tree |
| `prop_tree_swirl_1.png` | Tree_Swirl_1 | 224 | Swirl tree |
| `prop_planet_1.png` | Planet_1 | 192 | Sky / decor planet |

## Re-render

```bash
/workspace/tools/blender/blender -b -P /workspace/rts-moba-kit-sprites/render_sprites.py
```

Note: an older experimental set may exist under `out/`; prefer the root-level PNGs listed above.
