import 'dart:math' as math;

import 'package:flame/components.dart';
import 'package:flame/events.dart';
import 'package:flame/game.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/painting.dart';

import 'balance.dart';
import 'components/building.dart';
import 'components/resource_node.dart';
import 'components/terrain.dart';
import 'components/unit.dart';
import 'enums.dart';
import 'systems/economy.dart';
import 'systems/production.dart';

class RtsGame extends FlameGame
    with MultiTouchDragDetector, ScaleDetector, TapCallbacks {
  final Economy economy = Economy();
  final ProductionQueue production = ProductionQueue();

  final List<GameUnit> units = [];
  final List<Building> buildings = [];
  final List<ResourceNode> resources = [];
  final List<GameUnit> selectedUnits = [];
  final List<Building> selectedBuildings = [];

  /// Control groups 1..4
  final Map<int, List<GameUnit>> controlGroups = {1: [], 2: [], 3: [], 4: []};

  BuildMode buildMode = BuildMode.none;
  String? toastMessage;
  double toastTimer = 0;
  double missionTime = 0;
  int? activePointerPan;
  Vector2? lastPanWorld;
  bool _isScaling = false;

  final ValueNotifier<int> hudTick = ValueNotifier(0);

  @override
  Color backgroundColor() => const Color(0xFF1A120C);

  @override
  Future<void> onLoad() async {
    camera.viewfinder.anchor = Anchor.center;
    camera.viewfinder.zoom = Balance.cameraStartZoom;

    world.add(TerrainBackground());
    _spawnStartingBase();
    _notifyHud();
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

    // Minerals near base
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

    // Gas geyser near base
    final geyser = ResourceNode(
      kind: ResourceKind.gas,
      position: basePos + Vector2(140, 90),
      remaining: Balance.gasGeyserAmount,
      maxAmount: Balance.gasGeyserAmount,
    );
    world.add(geyser);
    resources.add(geyser);

    // Expansion minerals + geyser (northeast)
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
    final geyser2 = ResourceNode(
      kind: ResourceKind.gas,
      position: exp + Vector2(80, 70),
      remaining: Balance.gasGeyserAmount,
      maxAmount: Balance.gasGeyserAmount,
    );
    world.add(geyser2);
    resources.add(geyser2);

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

  // --- Selection ---

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
    // Pan camera to group center
    final cx =
        alive.fold<double>(0, (a, u) => a + u.position.x) / alive.length;
    final cy =
        alive.fold<double>(0, (a, u) => a + u.position.y) / alive.length;
    camera.viewfinder.position = Vector2(cx, cy);
  }

  // --- Commands ---

  void commandMove(Vector2 worldPos) {
    if (selectedUnits.isEmpty) return;
    for (final u in selectedUnits) {
      u.orderMove(worldPos);
    }
    buildMode = BuildMode.none;
    _notifyHud();
  }

  void commandHold() {
    for (final u in selectedUnits) {
      u.orderHold();
    }
    showToast('Mantener posición');
    _notifyHud();
  }

  void commandAttackStub() {
    showToast('Ataque: no disponible en v0.1');
  }

  void commandPatrolStub() {
    showToast('Patrulla: no disponible en v0.1');
  }

  void commandSpecialStub() {
    showToast('Especial: no disponible en v0.1');
  }

  void enterBuildMode(BuildMode mode) {
    if (selectedUnits.isEmpty) {
      showToast('Selecciona obreros para construir');
      return;
    }
    buildMode = mode;
    final names = {
      BuildMode.refinery: 'Refinería (sobre géiser)',
      BuildMode.supplyDepot: 'Depósito de suministro',
      BuildMode.barracks: 'Cuartel',
      BuildMode.outpost: 'Puesto avanzado',
      BuildMode.commandCenter: 'Centro de mando (expansión)',
    };
    showToast('Construir: ${names[mode] ?? mode.name}');
    _notifyHud();
  }

  void trainWorker() {
    final cc = selectedBuildings.cast<Building?>().firstWhere(
          (b) => b!.canTrainWorkers,
          orElse: () => buildings.cast<Building?>().firstWhere(
                (b) => b!.canTrainWorkers,
                orElse: () => null,
              ),
        );
    if (cc == null) {
      showToast('Necesitas un Centro de Mando');
      return;
    }
    if (production.isFull) {
      showToast('Cola llena');
      return;
    }
    if (!economy.canAfford(
      mineral: Balance.workerMineralCost,
      supply: Balance.workerSupplyCost,
    )) {
      if (economy.supplyUsed + Balance.workerSupplyCost > economy.supplyMax) {
        showToast('Sin suministro — construye un Depósito');
      } else {
        showToast('Minerales insuficientes');
      }
      return;
    }
    economy.spend(
      mineral: Balance.workerMineralCost,
      supply: Balance.workerSupplyCost,
    );
    production.enqueue(QueueItem.worker(cc));
    showToast('Entrenando obrero');
    _notifyHud();
  }

  void cancelQueueAt(int index) {
    if (index < 0 || index >= production.items.length) return;
    final item = production.items[index];
    economy.minerals += Balance.workerMineralCost;
    economy.refundSupply(Balance.workerSupplyCost);
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

  void _tryPlaceBuilding(Vector2 worldPos) {
    if (buildMode == BuildMode.none) return;
    final workers = selectedUnits.where((u) => u.kind == UnitKind.worker).toList();
    if (workers.isEmpty) {
      showToast('Selecciona obreros');
      buildMode = BuildMode.none;
      return;
    }

    late BuildingKind kind;
    late int mineralCost;
    late int gasCost;
    late double buildSecs;

    switch (buildMode) {
      case BuildMode.refinery:
        kind = BuildingKind.refinery;
        mineralCost = Balance.refineryMineralCost;
        gasCost = Balance.refineryGasCost;
        buildSecs = Balance.refineryBuildSeconds;
      case BuildMode.supplyDepot:
        kind = BuildingKind.supplyDepot;
        mineralCost = Balance.supplyDepotMineralCost;
        gasCost = Balance.supplyDepotGasCost;
        buildSecs = Balance.supplyDepotBuildSeconds;
      case BuildMode.barracks:
        kind = BuildingKind.barracks;
        mineralCost = Balance.barracksMineralCost;
        gasCost = Balance.barracksGasCost;
        buildSecs = Balance.barracksBuildSeconds;
      case BuildMode.outpost:
        kind = BuildingKind.outpost;
        mineralCost = Balance.outpostMineralCost;
        gasCost = Balance.outpostGasCost;
        buildSecs = Balance.outpostBuildSeconds;
      case BuildMode.commandCenter:
        kind = BuildingKind.commandCenter;
        mineralCost = Balance.ccMineralCost;
        gasCost = Balance.ccGasCost;
        buildSecs = Balance.ccBuildSeconds;
      case BuildMode.none:
        return;
    }

    ResourceNode? geyser;
    Vector2 placeAt = worldPos.clone();

    if (kind == BuildingKind.refinery) {
      geyser = _findGeyserNear(worldPos, 60);
      if (geyser == null) {
        showToast('Coloca la Refinería sobre un géiser de gas');
        return;
      }
      if (geyser.hasRefinery) {
        showToast('Ese géiser ya tiene Refinería');
        return;
      }
      placeAt = geyser.position.clone();
    }

    if (!economy.canAfford(mineral: mineralCost, gasCost: gasCost)) {
      showToast('Recursos insuficientes');
      return;
    }

    // Overlap check (simple)
    for (final b in buildings) {
      if (b.position.distanceTo(placeAt) < b.radius + 30) {
        showToast('Espacio ocupado');
        return;
      }
    }

    economy.spend(mineral: mineralCost, gasCost: gasCost);
    final site = Building(
      kind: kind,
      position: placeAt,
      isComplete: false,
    );
    site.buildSecondsNeeded = buildSecs;
    site.buildProgress = 0;
    if (geyser != null) {
      site.geyser = geyser;
      geyser.hasRefinery = true; // reserve while building
    }
    world.add(site);
    buildings.add(site);

    // Assign closest workers to build
    workers.sort(
      (a, b) => a.position
          .distanceTo(placeAt)
          .compareTo(b.position.distanceTo(placeAt)),
    );
    final builders = workers.take(3).toList();
    for (final w in builders) {
      w.orderBuild(site);
    }

    buildMode = BuildMode.none;
    showToast('Construyendo ${kind.labelEs}');
    _notifyHud();
  }

  ResourceNode? _findGeyserNear(Vector2 pos, double range) {
    ResourceNode? best;
    var bestD = range;
    for (final r in resources) {
      if (r.kind != ResourceKind.gas) continue;
      final d = r.position.distanceTo(pos);
      if (d <= bestD) {
        bestD = d;
        best = r;
      }
    }
    return best;
  }

  void _onBuildComplete(Building b) {
    switch (b.kind) {
      case BuildingKind.commandCenter:
        economy.addSupplyMax(Balance.ccSupplyProvided);
        showToast('Centro de Mando listo (+${Balance.ccSupplyProvided} suministro)');
      case BuildingKind.supplyDepot:
        economy.addSupplyMax(Balance.supplyDepotSupply);
        showToast('Depósito listo (+${Balance.supplyDepotSupply} suministro)');
      case BuildingKind.refinery:
        if (b.geyser != null) {
          b.geyser!.hasRefinery = true;
        }
        showToast('Refinería lista — puedes recolectar gas');
      case BuildingKind.barracks:
        showToast('Cuartel listo (combate en versiones futuras)');
      case BuildingKind.outpost:
        showToast('Puesto avanzado listo — punto de depósito');
    }
    _notifyHud();
  }

  // --- Input ---

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

    // Hit-test units first (smaller)
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
      selectUnits([hitUnit]);
      return;
    }

    Building? hitBuilding;
    var bestB = 60.0;
    for (final b in buildings) {
      final d = b.position.distanceTo(worldPos);
      if (d < b.radius + 8 && d < bestB) {
        bestB = d;
        hitBuilding = b;
      }
    }
    if (hitBuilding != null) {
      selectBuilding(hitBuilding);
      return;
    }

    // Resource node — if workers selected, harvest
    ResourceNode? hitNode;
    var bestN = 40.0;
    for (final r in resources) {
      final d = r.position.distanceTo(worldPos);
      if (d < bestN) {
        bestN = d;
        hitNode = r;
      }
    }
    if (hitNode != null && selectedUnits.isNotEmpty) {
      if (hitNode.kind == ResourceKind.gas && !hitNode.hasRefinery) {
        showToast('Construye una Refinería sobre el géiser');
        return;
      }
      for (final u in selectedUnits) {
        u.orderHarvest(hitNode);
      }
      showToast(
        hitNode.kind == ResourceKind.mineral
            ? 'Recolectando minerales'
            : 'Recolectando gas',
      );
      _notifyHud();
      return;
    }

    // Empty ground — move if units selected
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
      // Pan with focal delta
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

  // --- Update ---

  @override
  void update(double dt) {
    super.update(dt);
    missionTime += dt;
    economy.update(dt);

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
        onDeposit: (unit, m, g) {
          if (m > 0) economy.depositMineral(m);
          if (g > 0) economy.depositGas(g);
          _notifyHud();
        },
        onBuildComplete: _onBuildComplete,
      );
    }

    final finished = production.update(dt);
    for (final item in finished) {
      final spawnNear = item.source.position + Vector2(70, 40);
      final u = GameUnit(kind: item.kind, position: spawnNear);
      world.add(u);
      units.add(u);
      showToast('${item.kind.labelEs} listo');
      _notifyHud();
    }

    // Periodic HUD refresh for timer / rates
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
