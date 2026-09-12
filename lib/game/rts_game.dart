import 'dart:math' as math;

import 'package:flame/components.dart';
import 'package:flame/events.dart';
import 'package:flame/game.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/painting.dart';

import 'assets.dart';
import 'balance.dart';
import 'components/building.dart';
import 'components/prop.dart';
import 'components/resource_node.dart';
import 'components/terrain.dart';
import 'components/unit.dart';
import 'enums.dart';
import 'gfx.dart';
import 'systems/economy.dart';
import 'systems/production.dart';
import 'systems/research.dart';
import 'battle/battle_game.dart';

class RtsGame extends FlameGame
    with MultiTouchDragDetector, ScaleDetector, TapCallbacks {
  RtsGame({this.onRequestBattle});

  /// Called when the player taps Batalla (city stays alive underneath).
  final VoidCallback? onRequestBattle;

  final Economy economy = Economy();
  final ProductionQueue production = ProductionQueue();
  final ResearchQueue research = ResearchQueue();

  final List<GameUnit> units = [];
  final List<Building> buildings = [];
  final List<ResourceNode> resources = [];
  final List<GameUnit> selectedUnits = [];
  final List<Building> selectedBuildings = [];

  final Map<int, List<GameUnit>> controlGroups = {1: [], 2: [], 3: [], 4: []};

  BuildMode buildMode = BuildMode.none;
  String? toastMessage;
  double toastTimer = 0;
  double missionTime = 0;
  int? activePointerPan;
  Vector2? lastPanWorld;
  bool _isScaling = false;
  DateTime? _lastTapAt;
  Vector2? _lastTapWorld;

  final ValueNotifier<int> hudTick = ValueNotifier(0);

  @override
  Color backgroundColor() => const Color(0xFF0B0E14);

  @override
  Future<void> onLoad() async {
    await GameAssets.instance.load();
    camera.viewfinder.anchor = Anchor.center;
    camera.viewfinder.zoom = Balance.cameraStartZoom;

    world.add(TerrainBackground());
    _spawnLandscapeProps();
    _spawnStartingBase();
    overlays.add('hud');
    _notifyHud();
  }

  void _spawnLandscapeProps() {
    final rng = math.Random(7);
    const rocks = [
      'prop_rock_1.png',
      'prop_rock_2.png',
      'prop_rock_3.png',
      'prop_rock_4.png',
      'prop_rock_large_1.png',
      'prop_rock_large_2.png',
      'prop_rock_large_3.png',
    ];
    const trees = [
      'prop_tree_spiral_1.png',
      'prop_tree_swirl_1.png',
      'prop_tree_blob_1.png',
      'prop_tree_lava_1.png',
      'prop_tree_light_1.png',
      'prop_tree_spikes_1.png',
    ];
    const scrub = [
      'prop_planet_1.png',
    ];

    void scatter(List<String> paths, int count, double minSize, double maxSize) {
      for (var i = 0; i < count; i++) {
        final path = paths[rng.nextInt(paths.length)];
        final pos = Vector2(
          80 + rng.nextDouble() * (Balance.mapWidth - 160),
          80 + rng.nextDouble() * (Balance.mapHeight - 160),
        );
        // Keep clear of starting base / expansion mineral patches
        if (pos.distanceTo(Vector2(520, 900)) < 220) continue;
        if (pos.distanceTo(Vector2(1700, 500)) < 180) continue;
        final sz = minSize + rng.nextDouble() * (maxSize - minSize);
        world.add(MapProp(assetPath: path, position: pos, sizePx: sz));
      }
    }

    scatter(rocks, 24, 28, 72);
    scatter(trees, 16, 42, 80);
    scatter(scrub, 4, 56, 96); // planet decor
  }

  void _spawnStartingBase() {
    final basePos = Vector2(520, 900);
    final cc = Building(
      kind: BuildingKind.commandCenter,
      position: basePos.clone(),
    );
    world.add(cc);
    buildings.add(cc);

    for (var i = 0; i < Balance.startWorkers; i++) {
      final angle = i * (math.pi * 2 / Balance.startWorkers);
      final u = GameUnit(
        kind: UnitKind.worker,
        position: basePos + Vector2(math.cos(angle), math.sin(angle)) * 70,
      );
      world.add(u);
      units.add(u);
    }
    economy.supplyUsed = Balance.startWorkers;

    for (var i = 0; i < Balance.mineralNodesNearBase; i++) {
      final a = -0.6 + i * 0.22;
      final node = ResourceNode(
        kind: ResourceKind.mineral,
        position: basePos + Vector2(math.cos(a), math.sin(a) - 0.3) * 160,
        remaining: Balance.mineralNodeAmount,
        maxAmount: Balance.mineralNodeAmount,
      );
      world.add(node);
      resources.add(node);
    }

    final exp = Vector2(1700, 500);
    for (var i = 0; i < Balance.mineralNodesExpansion; i++) {
      final a = i * 0.35;
      final node = ResourceNode(
        kind: ResourceKind.mineral,
        position: exp + Vector2(math.cos(a), math.sin(a)) * 100,
        remaining: Balance.mineralNodeAmount,
        maxAmount: Balance.mineralNodeAmount,
      );
      world.add(node);
      resources.add(node);
    }

    camera.viewfinder.position = basePos.clone();
  }

  void _notifyHud() {
    hudTick.value++;
  }

  void showToast(String msg) {
    toastMessage = msg;
    toastTimer = 2.5;
    _notifyHud();
  }

  void clearSelection() {
    for (final u in selectedUnits) {
      u.selected = false;
    }
    for (final b in selectedBuildings) {
      b.selected = false;
    }
    selectedUnits.clear();
    selectedBuildings.clear();
  }

  void selectUnits(List<GameUnit> list) {
    clearSelection();
    for (final u in list) {
      u.selected = true;
      selectedUnits.add(u);
    }
    _notifyHud();
  }

  void selectBuilding(Building b) {
    clearSelection();
    b.selected = true;
    selectedBuildings.add(b);
    _notifyHud();
  }

  void assignControlGroup(int index) {
    if (selectedUnits.isEmpty) return;
    controlGroups[index] = List.of(selectedUnits);
    showToast('Grupo $index asignado (${selectedUnits.length})');
    _notifyHud();
  }

  void recallControlGroup(int index) {
    final g = controlGroups[index] ?? [];
    final alive = g.where((u) => u.parent != null).toList();
    controlGroups[index] = alive;
    if (alive.isEmpty) {
      showToast('Grupo $index vacío');
      return;
    }
    selectUnits(alive);
    final cx =
        alive.fold<double>(0, (a, u) => a + u.position.x) / alive.length;
    final cy =
        alive.fold<double>(0, (a, u) => a + u.position.y) / alive.length;
    camera.viewfinder.position = Vector2(cx, cy);
  }

  void commandMove(Vector2 worldPos) {
    if (selectedUnits.isEmpty) return;
    final slots = Gfx.formationSlots(worldPos, selectedUnits.length);
    for (var i = 0; i < selectedUnits.length; i++) {
      selectedUnits[i].orderMove(slots[i]);
    }
    buildMode = BuildMode.none;
    _notifyHud();
  }

  void selectUnitsByTypeNear(GameUnit seed) {
    final nearby = <GameUnit>[];
    for (final u in units) {
      if (u.parent == null) continue;
      if (u.kind != seed.kind) continue;
      if (u.position.distanceTo(seed.position) > Gfx.typeSelectRadius) continue;
      nearby.add(u);
    }
    selectUnits(nearby);
    showToast(
      'Selección local: ${seed.kind.labelEs} ×${nearby.length} (r=${Gfx.typeSelectRadius.toInt()})',
    );
  }

  void commandHold() {
    for (final u in selectedUnits) {
      u.orderHold();
    }
    showToast('Mantener posición');
    _notifyHud();
  }

  void commandAttackStub() {
    showToast('Usa BATALLA para Asedio PvE');
  }

  void commandPatrolStub() {
    showToast('Patrulla: próximamente');
  }

  void commandSpecialStub() {
    showToast('Especial: próximamente');
  }

  /// Opens Asedio if the city has deployable military.
  void requestBattle() {
    onRequestBattle?.call();
  }

  /// Pull military off the map into a battle detachment (workers stay).
  BattleDetachment? prepareBattleDetachment() {
    final military = units.where((u) => u.kind.isMilitary && u.parent != null).toList();
    if (military.isEmpty) {
      showToast('Entrena tropas en el Cuartel antes de batallar');
      return null;
    }
    final counts = <UnitKind, int>{};
    for (final u in military) {
      counts[u.kind] = (counts[u.kind] ?? 0) + 1;
    }
    // Remove from city (economy supply stays reserved until return).
    for (final u in military) {
      u.removeFromParent();
      units.remove(u);
      selectedUnits.remove(u);
    }
    for (final g in controlGroups.values) {
      g.removeWhere((u) => u.parent == null);
    }
    showToast('Desplegando ${military.length} tropas…');
    _notifyHud();
    return BattleDetachment(
      counts: counts,
      unlockedTechs: research.snapshotUnlocked(),
    );
  }

  void applyBattleResult({
    required Map<UnitKind, int> deployed,
    required Map<UnitKind, int> survivors,
    required BattleOutcome outcome,
  }) {
    // Refund supply for fallen troops.
    for (final entry in deployed.entries) {
      final lost = entry.value - (survivors[entry.key] ?? 0);
      if (lost > 0) {
        economy.refundSupply(Balance.supplyCostOf(entry.key) * lost);
      }
    }
    // Respawn survivors near CC.
    Building? cc;
    for (final b in buildings) {
      if (b.kind == BuildingKind.commandCenter && b.isComplete) {
        cc = b;
        break;
      }
    }
    final base = (cc?.position.clone()) ?? Vector2(520, 900);
    var i = 0;
    for (final entry in survivors.entries) {
      for (var n = 0; n < entry.value; n++) {
        final angle = i * 0.55;
        final u = GameUnit(
          kind: entry.key,
          position: base + Vector2(math.cos(angle), math.sin(angle)) * (90 + (i % 5) * 12),
        );
        world.add(u);
        units.add(u);
        i++;
      }
    }
    final label = switch (outcome) {
      BattleOutcome.victory => 'Victoria — supervivientes de vuelta',
      BattleOutcome.defeat => 'Derrota — supervivientes de vuelta',
      BattleOutcome.retreat => 'Retirada — tropas de vuelta',
      BattleOutcome.ongoing => 'Batalla terminada',
    };
    showToast(label);
    _notifyHud();
  }

  void enterBuildMode(BuildMode mode) {
    if (selectedUnits.where((u) => u.isWorker).isEmpty) {
      showToast('Selecciona obreros para construir');
      return;
    }
    if (mode == BuildMode.starport && !research.shipConstructionUnlocked) {
      showToast('Investiga «Construcción de naves» en el Laboratorio');
      return;
    }
    buildMode = mode;
    final names = {
      BuildMode.solarPanel: 'Panel solar (cualquier sitio válido)',
      BuildMode.supplyDepot: 'Depósito (GeodesicDome)',
      BuildMode.barracks: 'Cuartel (Building_L)',
      BuildMode.outpost: 'Puesto avanzado',
      BuildMode.commandCenter: 'Centro de mando (Base_Large)',
      BuildMode.laboratory: 'Laboratorio (Roof_Radar)',
      BuildMode.starport: 'Puerto estelar (House_Open)',
    };
    showToast('Construir: ${names[mode] ?? mode.name}');
    _notifyHud();
  }

  Building? _findTrainer({required bool Function(Building b) pred}) {
    for (final b in selectedBuildings) {
      if (pred(b)) return b;
    }
    for (final b in buildings) {
      if (pred(b)) return b;
    }
    return null;
  }

  void trainUnit(UnitKind kind) {
    final need = Balance.techRequiredForUnit(kind);
    if (need != null && !research.isUnlocked(need)) {
      showToast('Investiga «${need.labelEs}» en el Laboratorio');
      return;
    }

    final Building? source;
    if (kind == UnitKind.worker) {
      source = _findTrainer(pred: (b) => b.canTrainWorkers);
      if (source == null) {
        showToast('Necesitas un Centro de Mando');
        return;
      }
    } else if (kind.isShip) {
      source = _findTrainer(pred: (b) => b.canTrainShips);
      if (source == null) {
        showToast('Necesitas un Puerto estelar completo');
        return;
      }
    } else {
      source = _findTrainer(pred: (b) => b.canTrainMilitary);
      if (source == null) {
        showToast('Necesitas un Cuartel completo');
        return;
      }
    }
    if (production.isFull) {
      showToast('Cola llena');
      return;
    }
    final m = Balance.mineralCostOf(kind);
    final e = Balance.energyCostOf(kind);
    final s = Balance.supplyCostOf(kind);
    if (!economy.canAfford(mineral: m, energyCost: e, supply: s)) {
      if (economy.supplyUsed + s > economy.supplyMax) {
        showToast('Sin suministro — construye un Depósito');
      } else if (economy.minerals < m) {
        showToast('Minerales insuficientes');
      } else {
        showToast('Energía insuficiente — construye Paneles solares');
      }
      return;
    }
    economy.spend(mineral: m, energyCost: e, supply: s);
    production.enqueue(QueueItem.unit(kind, source));
    showToast('Entrenando ${kind.labelEs}');
    _notifyHud();
  }

  void trainWorker() => trainUnit(UnitKind.worker);

  void researchTech(TechKind kind) {
    final source = _findTrainer(pred: (b) => b.canResearch);
    if (source == null) {
      showToast('Necesitas un Laboratorio completo');
      return;
    }
    final blocked = research.blockedReason(kind);
    if (blocked != null) {
      showToast(blocked);
      return;
    }
    final m = Balance.techMineralCostOf(kind);
    final e = Balance.techEnergyCostOf(kind);
    if (!economy.canAfford(mineral: m, energyCost: e)) {
      if (economy.minerals < m) {
        showToast('Minerales insuficientes');
      } else {
        showToast('Energía insuficiente — construye Paneles solares');
      }
      return;
    }
    economy.spend(mineral: m, energyCost: e);
    research.enqueue(ResearchItem.tech(kind, source));
    showToast('Investigando ${kind.labelEs}');
    _notifyHud();
  }

  void cancelResearch() {
    if (research.isEmpty) return;
    final item = research.items.first;
    economy.minerals += Balance.techMineralCostOf(item.kind);
    economy.energy += Balance.techEnergyCostOf(item.kind);
    research.cancel();
    showToast('Investigación cancelada: ${item.kind.labelEs}');
    _notifyHud();
  }

  void cancelQueueAt(int index) {
    if (index < 0 || index >= production.items.length) return;
    final item = production.items[index];
    economy.minerals += Balance.mineralCostOf(item.kind);
    economy.energy += Balance.energyCostOf(item.kind);
    economy.refundSupply(Balance.supplyCostOf(item.kind));
    production.cancelAt(index);
    showToast('Cancelado: ${item.kind.labelEs}');
    _notifyHud();
  }

  Building? _nearestDeposit(Vector2 from) {
    Building? best;
    var bestDist = double.infinity;
    for (final b in buildings) {
      if (!b.isDepositPoint) continue;
      final d = from.distanceTo(b.position);
      if (d < bestDist) {
        bestDist = d;
        best = b;
      }
    }
    return best;
  }

  int get completedSolarPanels =>
      buildings.where((b) => b.generatesEnergy).length;

  /// Asigna obreros a una obra incompleta sin reiniciar [buildProgress].
  void resumeConstruction(Building site, {List<GameUnit>? workers}) {
    if (site.isComplete || site.parent == null) return;
    final pool = workers ??
        selectedUnits.where((u) => u.isWorker).toList();
    var builders = pool.where((u) => u.isWorker).toList();
    if (builders.isEmpty) {
      // Botón Continuar: busca obreros cercanos libres / disponibles.
      builders = units.where((u) => u.isWorker && u.parent != null).toList();
      builders.sort(
        (a, b) => a.position
            .distanceTo(site.position)
            .compareTo(b.position.distanceTo(site.position)),
      );
    } else {
      builders.sort(
        (a, b) => a.position
            .distanceTo(site.position)
            .compareTo(b.position.distanceTo(site.position)),
      );
    }
    if (builders.isEmpty) {
      showToast('No hay obreros para continuar');
      return;
    }
    final take = builders.take(Balance.maxBuildersPerSite).toList();
    for (final w in take) {
      w.orderBuild(site);
    }
    final pct = (site.buildProgress * 100).clamp(0, 99).floor();
    showToast(
      'Continuando ${site.kind.labelEs} ($pct%) — ${take.length} obrero(s)',
    );
    _notifyHud();
  }

  void _tryPlaceBuilding(Vector2 worldPos) {
    if (buildMode == BuildMode.none) return;
    final workers =
        selectedUnits.where((u) => u.kind == UnitKind.worker).toList();
    if (workers.isEmpty) {
      showToast('Selecciona obreros');
      buildMode = BuildMode.none;
      return;
    }

    late BuildingKind kind;
    late int mineralCost;
    late int energyCost;
    late double buildSecs;

    switch (buildMode) {
      case BuildMode.solarPanel:
        kind = BuildingKind.solarPanel;
        mineralCost = Balance.solarPanelMineralCost;
        energyCost = Balance.solarPanelEnergyCost;
        buildSecs = Balance.solarPanelBuildSeconds;
      case BuildMode.supplyDepot:
        kind = BuildingKind.supplyDepot;
        mineralCost = Balance.supplyDepotMineralCost;
        energyCost = Balance.supplyDepotEnergyCost;
        buildSecs = Balance.supplyDepotBuildSeconds;
      case BuildMode.barracks:
        kind = BuildingKind.barracks;
        mineralCost = Balance.barracksMineralCost;
        energyCost = Balance.barracksEnergyCost;
        buildSecs = Balance.barracksBuildSeconds;
      case BuildMode.outpost:
        kind = BuildingKind.outpost;
        mineralCost = Balance.outpostMineralCost;
        energyCost = Balance.outpostEnergyCost;
        buildSecs = Balance.outpostBuildSeconds;
      case BuildMode.commandCenter:
        kind = BuildingKind.commandCenter;
        mineralCost = Balance.ccMineralCost;
        energyCost = Balance.ccEnergyCost;
        buildSecs = Balance.ccBuildSeconds;
      case BuildMode.laboratory:
        kind = BuildingKind.laboratory;
        mineralCost = Balance.laboratoryMineralCost;
        energyCost = Balance.laboratoryEnergyCost;
        buildSecs = Balance.laboratoryBuildSeconds;
      case BuildMode.starport:
        if (!research.shipConstructionUnlocked) {
          showToast('Investiga «Construcción de naves» en el Laboratorio');
          return;
        }
        kind = BuildingKind.starport;
        mineralCost = Balance.starportMineralCost;
        energyCost = Balance.starportEnergyCost;
        buildSecs = Balance.starportBuildSeconds;
      case BuildMode.none:
        return;
    }

    final placeAt = worldPos.clone();

    if (!economy.canAfford(mineral: mineralCost, energyCost: energyCost)) {
      showToast('Recursos insuficientes');
      return;
    }

    for (final b in buildings) {
      if (b.position.distanceTo(placeAt) < b.radius + 30) {
        showToast('Espacio ocupado');
        return;
      }
    }

    economy.spend(mineral: mineralCost, energyCost: energyCost);
    final site = Building(
      kind: kind,
      position: placeAt,
      isComplete: false,
    );
    site.buildSecondsNeeded = buildSecs;
    site.buildProgress = 0;
    world.add(site);
    buildings.add(site);

    workers.sort(
      (a, b) => a.position
          .distanceTo(placeAt)
          .compareTo(b.position.distanceTo(placeAt)),
    );
    for (final w in workers.take(Balance.maxBuildersPerSite)) {
      w.orderBuild(site);
    }

    buildMode = BuildMode.none;
    showToast('Construyendo ${kind.labelEs}');
    _notifyHud();
  }

  void _onBuildComplete(Building b) {
    switch (b.kind) {
      case BuildingKind.commandCenter:
        economy.addSupplyMax(Balance.ccSupplyProvided);
        showToast(
            'Centro de Mando listo (+${Balance.ccSupplyProvided} suministro)');
      case BuildingKind.supplyDepot:
        economy.addSupplyMax(Balance.supplyDepotSupply);
        showToast('Depósito listo (+${Balance.supplyDepotSupply} suministro)');
      case BuildingKind.solarPanel:
        showToast(
          'Panel solar listo — +${Balance.energyPerPanelPerMin.toInt()} Energía/min',
        );
      case BuildingKind.barracks:
        showToast('Cuartel listo — produce infantería, rover y mech');
      case BuildingKind.outpost:
        showToast('Puesto avanzado listo — punto de depósito');
      case BuildingKind.laboratory:
        showToast('Laboratorio listo — panel Investigar');
      case BuildingKind.starport:
        showToast('Puerto estelar listo — produce naves');
    }
    _notifyHud();
  }

  Vector2 _screenToWorld(Vector2 screen) {
    return camera.globalToLocal(screen);
  }

  @override
  void onTapUp(TapUpEvent event) {
    final worldPos = _screenToWorld(event.canvasPosition);

    if (buildMode != BuildMode.none) {
      _tryPlaceBuilding(worldPos);
      return;
    }

    final now = DateTime.now();
    final isDouble = _lastTapAt != null &&
        now.difference(_lastTapAt!).inMilliseconds <= Gfx.doubleTapMs &&
        _lastTapWorld != null &&
        _lastTapWorld!.distanceTo(worldPos) < 48;

    GameUnit? hitUnit;
    var bestU = 28.0;
    for (final u in units) {
      final d = u.position.distanceTo(worldPos);
      if (d < bestU) {
        bestU = d;
        hitUnit = u;
      }
    }
    if (hitUnit != null) {
      if (isDouble) {
        selectUnitsByTypeNear(hitUnit);
        _lastTapAt = null;
        _lastTapWorld = null;
      } else {
        selectUnits([hitUnit]);
        _lastTapAt = now;
        _lastTapWorld = worldPos.clone();
      }
      return;
    }

    _lastTapAt = now;
    _lastTapWorld = worldPos.clone();

    Building? hitBuilding;
    var bestB = 70.0;
    for (final b in buildings) {
      final d = b.position.distanceTo(worldPos);
      if (d < b.radius + 8 && d < bestB) {
        bestB = d;
        hitBuilding = b;
      }
    }
    if (hitBuilding != null) {
      final workersSel = selectedUnits.where((u) => u.isWorker).toList();
      // Obreros seleccionados + obra incompleta → reanudar sin resetear progreso.
      if (!hitBuilding.isComplete && workersSel.isNotEmpty) {
        resumeConstruction(hitBuilding, workers: workersSel);
        return;
      }
      selectBuilding(hitBuilding);
      return;
    }

    ResourceNode? hitNode;
    var bestN = 40.0;
    for (final r in resources) {
      final d = r.position.distanceTo(worldPos);
      if (d < bestN) {
        bestN = d;
        hitNode = r;
      }
    }
    if (hitNode != null && selectedUnits.any((u) => u.isWorker)) {
      for (final u in selectedUnits) {
        if (u.isWorker) u.orderHarvest(hitNode);
      }
      showToast('Recolectando minerales');
      _notifyHud();
      return;
    }

    if (selectedUnits.isNotEmpty) {
      commandMove(worldPos);
      return;
    }

    clearSelection();
    _notifyHud();
  }

  @override
  void onDragStart(int pointerId, DragStartInfo info) {
    if (_isScaling) return;
    activePointerPan = pointerId;
    lastPanWorld = info.eventPosition.widget.clone();
  }

  @override
  void onDragUpdate(int pointerId, DragUpdateInfo info) {
    if (_isScaling || activePointerPan != pointerId) return;
    final prev = lastPanWorld;
    final cur = info.eventPosition.widget.clone();
    if (prev != null) {
      final delta = (prev - cur) / camera.viewfinder.zoom;
      camera.viewfinder.position += delta;
      _clampCamera();
    }
    lastPanWorld = cur;
  }

  @override
  void onDragEnd(int pointerId, DragEndInfo info) {
    if (activePointerPan == pointerId) {
      activePointerPan = null;
      lastPanWorld = null;
    }
  }

  @override
  void onScaleStart(ScaleStartInfo info) {
    _isScaling = info.pointerCount >= 2;
  }

  @override
  void onScaleUpdate(ScaleUpdateInfo info) {
    if (info.pointerCount >= 2) {
      _isScaling = true;
      final zoom = (camera.viewfinder.zoom * info.scale.global.y)
          .clamp(Balance.cameraMinZoom, Balance.cameraMaxZoom);
      camera.viewfinder.zoom = zoom;
      final delta = info.delta.global / camera.viewfinder.zoom;
      camera.viewfinder.position -= delta;
      _clampCamera();
    }
  }

  @override
  void onScaleEnd(ScaleEndInfo info) {
    _isScaling = false;
  }

  void _clampCamera() {
    final pos = camera.viewfinder.position;
    pos.x = pos.x.clamp(200, Balance.mapWidth - 200);
    pos.y = pos.y.clamp(200, Balance.mapHeight - 200);
    camera.viewfinder.position = pos;
  }

  void zoomBy(double factor) {
    camera.viewfinder.zoom = (camera.viewfinder.zoom * factor)
        .clamp(Balance.cameraMinZoom, Balance.cameraMaxZoom);
    _notifyHud();
  }

  @override
  void update(double dt) {
    super.update(dt);
    missionTime += dt;
    economy.update(dt);
    economy.tickPassiveEnergy(dt, completedSolarPanels);

    if (toastTimer > 0) {
      toastTimer -= dt;
      if (toastTimer <= 0) {
        toastMessage = null;
        _notifyHud();
      }
    }

    for (final u in List.of(units)) {
      u.tickAI(
        dt: dt,
        findDeposit: () => _nearestDeposit(u.position),
        onDeposit: (unit, m) {
          if (m > 0) economy.depositMineral(m);
          _notifyHud();
        },
        onBuildComplete: _onBuildComplete,
      );
    }

    final finished = production.update(dt);
    for (final item in finished) {
      final offset = item.kind.isShip ? Vector2(90, -30) : Vector2(70, 40);
      final spawnNear = item.source.position + offset;
      final u = GameUnit(kind: item.kind, position: spawnNear);
      world.add(u);
      units.add(u);
      showToast('${item.kind.labelEs} listo');
      _notifyHud();
    }

    final researched = research.update(dt);
    for (final item in researched) {
      switch (item.kind) {
        case TechKind.shipConstruction:
          showToast('¡Tech listo! Puerto estelar + grupo Naves');
        case TechKind.combatArchers:
          showToast('¡Arqueros desbloqueados en Cuartel y Asedio!');
        case TechKind.combatVehicles:
          showToast('¡Rovers desbloqueados en Cuartel y Asedio!');
        case TechKind.combatMechs:
          showToast('¡Mechs desbloqueados en Cuartel y Asedio!');
      }
      _notifyHud();
    }

    if ((missionTime * 10).floor() % 5 == 0) {
      _notifyHud();
    }
  }

  String formatTime() {
    final t = missionTime.floor();
    final m = (t ~/ 60).toString().padLeft(2, '0');
    final s = (t % 60).toString().padLeft(2, '0');
    return '$m:$s';
  }
}
