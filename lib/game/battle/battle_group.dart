import 'package:flame/components.dart';

import '../enums.dart';
import '../gfx.dart';
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
        final slots = Gfx.formationSlots(gatePos, living.length);
        for (var i = 0; i < living.length; i++) {
          living[i].orderCharge(slots[i]);
        }
      case BattleCommand.mantener:
        for (final u in living) {
          u.orderHold();
        }
      case BattleCommand.retirar:
        final slots = Gfx.formationSlots(retreatPos, living.length);
        for (var i = 0; i < living.length; i++) {
          living[i].orderRetreat(slots[i]);
        }
      case BattleCommand.fuegoConcentrado:
        final approach = gatePos + Vector2(0, 80);
        final slots = Gfx.formationSlots(approach, living.length);
        for (var i = 0; i < living.length; i++) {
          living[i].orderFocus(slots[i]);
        }
    }
  }

  void moveTo(Vector2 world) {
    rallyPoint = world.clone();
    final living = alive;
    final slots = Gfx.formationSlots(world, living.length);
    for (var i = 0; i < living.length; i++) {
      living[i].orderMove(slots[i]);
    }
  }
}
