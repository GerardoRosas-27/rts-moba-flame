import 'package:flame/components.dart';
import 'package:flame/flame.dart';
import 'package:flutter/foundation.dart';

import 'enums.dart';

/// Quaternius Ultimate Platformer Pack sprites (CC0) — see assets/License.txt.
///
/// Keys are filenames only: Flame [Images.prefix] is already `assets/images/`.
class GameAssets {
  GameAssets._();
  static final GameAssets instance = GameAssets._();

  final Map<String, Sprite> _sprites = {};

  /// 0.0–1.0 while [load] runs; HUD / splash listen via [loadProgress].
  final ValueNotifier<double> loadProgress = ValueNotifier(0);
  final ValueNotifier<String> loadLabel = ValueNotifier('Preparando…');

  static const List<String> allPaths = <String>[
    // Buildings
    'building_base_large.png',
    'building_geodesic_dome.png',
    'building_solarpanel_structure.png',
    'building_l.png',
    'building_house_long.png',
    'building_house_cylinder.png',
    'building_house_single.png',
    'building_roof_radar.png',
    'building_solarpanel_ground.png',
    // Units
    'unit_astronaut_barbara.png',
    'unit_astronaut_fernando.png',
    'unit_astronaut_finn.png',
    'unit_astronaut_rae.png',
    // Vehicles
    'vehicle_rover_1.png',
    'vehicle_rover_2.png',
    'vehicle_rover_round.png',
    'vehicle_mech_finn.png',
    'vehicle_mech_barbara.png',
    'vehicle_mech_rae.png',
    // Props
    'prop_rock_1.png',
    'prop_rock_2.png',
    'prop_rock_3.png',
    'prop_rock_4.png',
    'prop_rock_large_1.png',
    'prop_rock_large_2.png',
    'prop_rock_large_3.png',
    'prop_tree_blob_1.png',
    'prop_tree_spiral_1.png',
    'prop_tree_swirl_1.png',
    'prop_tree_lava_1.png',
    'prop_tree_light_1.png',
    'prop_tree_spikes_1.png',
    'prop_planet_1.png',
  ];

  Future<void> load() async {
    _sprites.clear();
    loadProgress.value = 0;
    loadLabel.value = 'Cargando…';
    final total = allPaths.length;
    for (var i = 0; i < total; i++) {
      final p = allPaths[i];
      loadLabel.value = 'Cargando… (${i + 1}/$total)';
      final image = await Flame.images.load(p);
      _sprites[p] = Sprite(image);
      loadProgress.value = (i + 1) / total;
    }
    loadLabel.value = 'Listo';
  }

  void resetProgress() {
    loadProgress.value = 0;
    loadLabel.value = 'Preparando…';
  }

  Sprite? get(String path) => _sprites[path];

  Sprite? forBuilding(BuildingKind kind) {
    switch (kind) {
      case BuildingKind.commandCenter:
        return get('building_base_large.png');
      case BuildingKind.solarPanel:
        return get('building_solarpanel_structure.png');
      case BuildingKind.supplyDepot:
        return get('building_geodesic_dome.png');
      case BuildingKind.barracks:
        return get('building_l.png');
      case BuildingKind.outpost:
        return get('building_house_cylinder.png');
    }
  }

  Sprite? forUnit(UnitKind kind) {
    switch (kind) {
      case UnitKind.worker:
        return get('unit_astronaut_rae.png');
      case UnitKind.infantryFrog:
        return get('unit_astronaut_finn.png');
      case UnitKind.infantryBee:
        return get('unit_astronaut_barbara.png');
      case UnitKind.rover:
        return get('vehicle_rover_1.png');
      case UnitKind.mech:
        return get('vehicle_mech_finn.png');
    }
  }
}
