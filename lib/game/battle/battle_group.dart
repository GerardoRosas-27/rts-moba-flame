import 'dart:math' as math;

import 'package:flame/components.dart';

import '../enums.dart';
import 'battle_unit.dart';

/// Logical squad of one [BattleGroupKind] controlled as a single large button.
class BattleGroup {
  BattleGroup({
    required this.kind,
    required this.unlocked,
    List<BattleUnit>? units,
  }) : units = units ?? <BattleUnit>[];

  final BattleGroupKind kind;
  bool unlocked;
  List<BattleUnit> units;
  BattleCommand? lastCommand;
  Vector2? rallyPoint;

  int get aliveCount => units.where((u) => !u.dead && u.parent != null).length;

  List<BattleUnit> get alive =>
      units.where((u) => !u.dead && u.parent != null).toList();

  Vector2 get centroid {
    final a = alive;
    if (a.isEmpty) return Vector2.zero();
    var x = 0.0;
    var y = 0.0;
    for (final u in a) {
      x += u.position.x;
      y += u.position.y;
    }
    return Vector2(x / a.length, y / a.length);
  }

  void applyCommand(BattleCommand cmd, Vector2 gatePos, Vector2 retreatPos) {
    lastCommand = cmd;
    final living = alive;
    if (living.isEmpty) return;
    switch (cmd) {
      case BattleCommand.cargar:
        for (var i = 0; i < living.length; i++) {
          final spread = Vector2((i - living.length / 2) * 22, 0);
          living[i].orderCharge(gatePos + spread);
        }
      case BattleCommand.mantener:
        for (final u in living) {
          u.orderHold();
        }
      case BattleCommand.retirar:
        for (var i = 0; i < living.length; i++) {
          final spread = Vector2((i - living.length / 2) * 26, 0);
          living[i].orderRetreat(retreatPos + spread);
        }
      case BattleCommand.fuegoConcentrado:
        for (var i = 0; i < living.length; i++) {
          final spread = Vector2((i - living.length / 2) * 18, 30);
          living[i].orderFocus(gatePos + spread);
        }
    }
  }

  void moveTo(Vector2 world) {
    rallyPoint = world.clone();
    final living = alive;
    for (var i = 0; i < living.length; i++) {
      final angle = i * 0.7;
      final offset = Vector2(math.cos(angle) * 18, math.sin(angle) * 18);
      living[i].orderMove(world + offset);
    }
  }
}
