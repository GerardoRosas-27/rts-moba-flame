import 'package:flame/components.dart';
import 'package:flame/flame.dart';

import 'enums.dart';

/// Quaternius Ultimate Platformer Pack sprites (CC0) — see assets/License.txt.
class GameAssets {
  GameAssets._();
  static final GameAssets instance = GameAssets._();

  final Map<String, Sprite> _sprites = {};

  Future<void> load() async {
    const paths = <String>[
      // Buildings
      'images/building_base_large.png',
      'images/building_geodesic_dome.png',
      'images/building_solarpanel_structure.png',
      'images/building_l.png',
      'images/building_house_long.png',
      'images/building_house_cylinder.png',
      'images/building_house_single.png',
      'images/building_roof_radar.png',
      'images/building_solarpanel_ground.png',
      // Units
      'images/unit_astronaut_barbara.png',
      'images/unit_astronaut_fernando.png',
      'images/unit_astronaut_finn.png',
      'images/unit_astronaut_rae.png',
      // Vehicles
      'images/vehicle_rover_1.png',
      'images/vehicle_rover_2.png',
      'images/vehicle_rover_round.png',
      'images/vehicle_mech_finn.png',
      'images/vehicle_mech_barbara.png',
      'images/vehicle_mech_rae.png',
      // Props
      'images/prop_rock_1.png',
      'images/prop_rock_2.png',
      'images/prop_rock_3.png',
      'images/prop_rock_4.png',
      'images/prop_rock_large_1.png',
      'images/prop_rock_large_2.png',
      'images/prop_rock_large_3.png',
      'images/prop_tree_blob_1.png',
      'images/prop_tree_spiral_1.png',
      'images/prop_tree_swirl_1.png',
      'images/prop_tree_lava_1.png',
      'images/prop_tree_light_1.png',
      'images/prop_tree_spikes_1.png',
      'images/prop_planet_1.png',
    ];
    for (final p in paths) {
      final image = await Flame.images.load(p);
      _sprites[p] = Sprite(image);
    }
  }

  Sprite? get(String path) => _sprites[path];

  Sprite? forBuilding(BuildingKind kind) {
    switch (kind) {
      case BuildingKind.commandCenter:
        return get('images/building_base_large.png');
      case BuildingKind.refinery:
        return get('images/building_solarpanel_structure.png');
      case BuildingKind.supplyDepot:
        return get('images/building_geodesic_dome.png');
      case BuildingKind.barracks:
        return get('images/building_l.png');
      case BuildingKind.outpost:
        return get('images/building_house_cylinder.png');
    }
  }

  Sprite? forUnit(UnitKind kind) {
    switch (kind) {
      case UnitKind.worker:
        return get('images/unit_astronaut_rae.png');
      case UnitKind.infantryFrog:
        return get('images/unit_astronaut_finn.png');
      case UnitKind.infantryBee:
        return get('images/unit_astronaut_barbara.png');
      case UnitKind.rover:
        return get('images/vehicle_rover_1.png');
      case UnitKind.mech:
        return get('images/vehicle_mech_finn.png');
    }
  }
}
