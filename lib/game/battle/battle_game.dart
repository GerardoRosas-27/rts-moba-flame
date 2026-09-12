import 'dart:math' as math;

import 'package:flame/components.dart';
import 'package:flame/events.dart';
import 'package:flame/game.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/painting.dart';

import '../assets.dart';
import '../balance.dart';
import '../enums.dart';
import 'battle_group.dart';
import 'battle_terrain.dart';
import 'battle_unit.dart';
import 'gate.dart';

/// Detachment taken from the city into Asedio.
class BattleDetachment {
  BattleDetachment({
    required this.counts,
    required this.unlockedTechs,
  });

  /// How many city units of each [UnitKind] are sent.
  final Map<UnitKind, int> counts;
  final Set<TechKind> unlockedTechs;
}

/// Result returned to the city when Asedio ends.
class BattleResult {
  BattleResult({
    required this.outcome,
    required this.survivors,
    required this.gateDestroyed,
    required this.elapsed,
  });

  final BattleOutcome outcome;
  /// Surviving units by kind to restore into the city.
  final Map<UnitKind, int> survivors;
  final bool gateDestroyed;
  final double elapsed;
}

/// Asedio PvE lite — one gate, group buttons, 2–4 min.
class BattleGame extends FlameGame with TapCallbacks, ScaleDetector {
  BattleGame({
    required this.detachment,
    required this.onFinished,
  });

  final BattleDetachment detachment;
  final void Function(BattleResult result) onFinished;

  final List<BattleGroup> groups = [];
  final List<BattleUnit> friendlies = [];
  final List<BattleUnit> enemies = [];
  SiegeGate? gate;

  BattleGroupKind? selectedGroup;
  BattleGroupKind? draggingGroup;
  String? toastMessage;
  double toastTimer = 0;
  double battleTime = 0;
  double waveTimer = 8;
  BattleOutcome outcome = BattleOutcome.ongoing;
  bool _finished = false;

  final ValueNotifier<int> hudTick = ValueNotifier(0);

  final Vector2 retreatPoint =
      Vector2(Balance.battleMapWidth / 2, Balance.battleRetreatY);
  final Vector2 gatePoint =
      Vector2(Balance.battleMapWidth / 2, Balance.battleGateY);

  @override
  Color backgroundColor() => const Color(0xFF120E18);

  @override
  Future<void> onLoad() async {
    // Assets already loaded by city; refresh if needed.
    if (GameAssets.instance.get('unit_astronaut_finn.png') == null) {
      await GameAssets.instance.load();
    }
    camera.viewfinder.anchor = Anchor.center;
    camera.viewfinder.zoom = Balance.battleCameraZoom;
    camera.viewfinder.position = Vector2(
      Balance.battleMapWidth / 2,
      Balance.battleMapHeight * 0.55,
    );

    world.add(BattleTerrain());
    gate = SiegeGate(position: gatePoint.clone());
    world.add(gate!);

    _spawnGroupsFromDetachment();
    _spawnInitialEnemies();
    overlays.add('battleHud');
    _notifyHud();
    showToast('¡Asedio! Destruye la puerta');
  }

  bool _techOk(BattleGroupKind g) {
    final t = g.requiredTech;
    if (t == null) return true;
    return detachment.unlockedTechs.contains(t);
  }

  List<(UnitKind, int)> _unitsForGroup(BattleGroupKind kind) {
    switch (kind) {
      case BattleGroupKind.soldados:
        return [(UnitKind.infantryFrog, detachment.counts[UnitKind.infantryFrog] ?? 0)];
      case BattleGroupKind.arqueros:
        return [(UnitKind.infantryBee, detachment.counts[UnitKind.infantryBee] ?? 0)];
      case BattleGroupKind.vehiculos:
        return [(UnitKind.rover, detachment.counts[UnitKind.rover] ?? 0)];
      case BattleGroupKind.mechs:
        return [(UnitKind.mech, detachment.counts[UnitKind.mech] ?? 0)];
      case BattleGroupKind.naves:
        final ships = <UnitKind>[
          UnitKind.shipCaza,
          UnitKind.shipInterceptor,
          UnitKind.shipFragata,
          UnitKind.shipCrucero,
          UnitKind.shipAcorazado,
        ];
        return [
          for (final s in ships)
            if ((detachment.counts[s] ?? 0) > 0) (s, detachment.counts[s]!),
        ];
    }
  }

  void _spawnGroupsFromDetachment() {
    final spawnBase = Vector2(
      Balance.battleMapWidth / 2,
      Balance.battlePlayerSpawnY,
    );
    var slot = 0;
    for (final kind in BattleGroupKind.values) {
      final unlocked = _techOk(kind);
      if (!unlocked) {
        groups.add(BattleGroup(kind: kind, unlocked: false));
        continue;
      }
      final roster = _unitsForGroup(kind);
      final total = roster.fold<int>(0, (a, e) => a + e.$2);
      if (total <= 0) {
        groups.add(BattleGroup(kind: kind, unlocked: true));
        continue;
      }
      final group = BattleGroup(kind: kind, unlocked: true);
      final ox = (slot - 1) * 90.0;
      var i = 0;
      for (final (unitKind, countRaw) in roster) {
        final count = countRaw.clamp(1, 12);
        for (var n = 0; n < count; n++) {
          final pos = spawnBase +
              Vector2(
                ox + (i % 4) * 28 - 40,
                (i ~/ 4) * 32,
              );
          final u = BattleUnit(
            kind: unitKind,
            friendly: true,
            position: pos,
            group: kind,
          );
          world.add(u);
          friendlies.add(u);
          group.units.add(u);
          i++;
          if (i >= 12) break;
        }
        if (i >= 12) break;
      }
      groups.add(group);
      slot++;
    }
    // Auto-select first unlocked group with units
    for (final g in groups) {
      if (g.unlocked && g.aliveCount > 0) {
        selectedGroup = g.kind;
        break;
      }
    }
  }

  void _spawnInitialEnemies() {
    final rng = math.Random(3);
    for (var i = 0; i < 5; i++) {
      _spawnEnemy(
        Vector2(
          gatePoint.x + (rng.nextDouble() - 0.5) * 200,
          gatePoint.y + 80 + rng.nextDouble() * 60,
        ),
      );
    }
  }

  void _spawnEnemy(Vector2 pos) {
    if (enemies.where((e) => !e.dead).length >= Balance.battleMaxEnemyAlive) {
      return;
    }
    final u = BattleUnit(
      kind: UnitKind.infantryFrog,
      friendly: false,
      position: pos,
    );
    world.add(u);
    enemies.add(u);
  }

  void _notifyHud() => hudTick.value++;

  void showToast(String msg) {
    toastMessage = msg;
    toastTimer = 2.4;
    _notifyHud();
  }

  BattleGroup? groupOf(BattleGroupKind kind) {
    for (final g in groups) {
      if (g.kind == kind) return g;
    }
    return null;
  }

  void selectGroup(BattleGroupKind kind) {
    final g = groupOf(kind);
    if (g == null || !g.unlocked) {
      showToast('Grupo bloqueado — investiga en el Laboratorio');
      return;
    }
    if (g.aliveCount <= 0) {
      showToast('${kind.labelEs}: sin tropas');
      return;
    }
    selectedGroup = kind;
    showToast('${kind.labelEs} (${g.aliveCount})');
    _notifyHud();
  }

  void issueCommand(BattleCommand cmd) {
    if (outcome != BattleOutcome.ongoing) return;
    final kind = selectedGroup;
    if (kind == null) {
      showToast('Selecciona un grupo');
      return;
    }
    final g = groupOf(kind);
    if (g == null || !g.unlocked || g.aliveCount <= 0) {
      showToast('Grupo no disponible');
      return;
    }
    g.applyCommand(cmd, gatePoint, retreatPoint);
    showToast('${cmd.labelEs} → ${kind.labelEs}');
    _notifyHud();
  }

  void dropGroupAt(BattleGroupKind kind, Vector2 screenPos) {
    if (outcome != BattleOutcome.ongoing) return;
    final g = groupOf(kind);
    if (g == null || !g.unlocked || g.aliveCount <= 0) return;
    selectedGroup = kind;
    final world = camera.globalToLocal(screenPos);
    // Clamp to map
    world.x = world.x.clamp(40, Balance.battleMapWidth - 40);
    world.y = world.y.clamp(80, Balance.battleMapHeight - 40);
    g.moveTo(world);
    showToast('${kind.labelEs} → zona');
    draggingGroup = null;
    _notifyHud();
  }

  void beginDragGroup(BattleGroupKind kind) {
    final g = groupOf(kind);
    if (g == null || !g.unlocked || g.aliveCount <= 0) return;
    draggingGroup = kind;
    selectedGroup = kind;
    _notifyHud();
  }

  void cancelDrag() {
    draggingGroup = null;
    _notifyHud();
  }

  void requestRetreat() {
    if (_finished) return;
    _end(BattleOutcome.retreat);
  }

  void _end(BattleOutcome o) {
    if (_finished) return;
    _finished = true;
    outcome = o;
    final survivors = <UnitKind, int>{};
    for (final u in friendlies) {
      if (!u.dead && u.parent != null) {
        survivors[u.kind] = (survivors[u.kind] ?? 0) + 1;
      }
    }
    _notifyHud();
    // Brief delay so HUD can show banner, then callback.
    Future<void>.delayed(const Duration(milliseconds: 900), () {
      onFinished(
        BattleResult(
          outcome: o,
          survivors: survivors,
          gateDestroyed: gate?.destroyed ?? false,
          elapsed: battleTime,
        ),
      );
    });
  }

  @override
  void onTapUp(TapUpEvent event) {
    if (outcome != BattleOutcome.ongoing) return;
    final world = camera.globalToLocal(event.canvasPosition);
    final kind = selectedGroup;
    if (kind != null) {
      final g = groupOf(kind);
      g?.moveTo(world);
      showToast('Mover ${kind.labelEs}');
      _notifyHud();
    }
  }

  @override
  void onScaleUpdate(ScaleUpdateInfo info) {
    if (info.pointerCount >= 2) {
      final zoom = (camera.viewfinder.zoom * info.scale.global.y)
          .clamp(0.45, 1.3);
      camera.viewfinder.zoom = zoom;
    } else {
      camera.viewfinder.position -= info.delta.global / camera.viewfinder.zoom;
      final pos = camera.viewfinder.position;
      pos.x = pos.x.clamp(200, Balance.battleMapWidth - 200);
      pos.y = pos.y.clamp(200, Balance.battleMapHeight - 200);
      camera.viewfinder.position = pos;
    }
  }

  @override
  void update(double dt) {
    super.update(dt);
    if (outcome != BattleOutcome.ongoing) return;

    battleTime += dt;
    if (toastTimer > 0) {
      toastTimer -= dt;
      if (toastTimer <= 0) {
        toastMessage = null;
        _notifyHud();
      }
    }

    // Waves
    waveTimer -= dt;
    if (waveTimer <= 0) {
      waveTimer = Balance.battleEnemyWaveSeconds;
      final rng = math.Random();
      for (var i = 0; i < Balance.battleEnemyWaveSize; i++) {
        _spawnEnemy(
          Vector2(
            gatePoint.x + (rng.nextDouble() - 0.5) * 240,
            gatePoint.y + 50 + rng.nextDouble() * 80,
          ),
        );
      }
      showToast('Oleada enemiga');
    }

    final g = gate;
    final aliveFriends = friendlies.where((u) => !u.dead).toList();
    final aliveEnemies = enemies.where((u) => !u.dead).toList();

    for (final u in aliveFriends) {
      u.tickCombat(
        dt: dt,
        allies: aliveFriends,
        foes: aliveEnemies,
        gate: g,
        retreatPoint: retreatPoint,
      );
    }
    for (final u in aliveEnemies) {
      u.tickCombat(
        dt: dt,
        allies: aliveEnemies,
        foes: aliveFriends,
        gate: g,
        retreatPoint: retreatPoint,
      );
    }

    if (g != null && g.destroyed) {
      showToast('¡Puerta destruida!');
      _end(BattleOutcome.victory);
      return;
    }

    if (aliveFriends.isEmpty) {
      showToast('Tropas derrotadas');
      _end(BattleOutcome.defeat);
      return;
    }

    if (battleTime >= Balance.battleDurationSeconds) {
      showToast('Tiempo agotado');
      _end(BattleOutcome.defeat);
      return;
    }

    if ((battleTime * 8).floor() % 3 == 0) {
      _notifyHud();
    }
  }

  String formatTimeLeft() {
    final left =
        (Balance.battleDurationSeconds - battleTime).clamp(0, 9999).floor();
    final m = (left ~/ 60).toString().padLeft(2, '0');
    final s = (left % 60).toString().padLeft(2, '0');
    return '$m:$s';
  }
}
