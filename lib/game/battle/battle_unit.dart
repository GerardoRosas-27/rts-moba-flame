import 'dart:math' as math;
import 'dart:ui';

import 'package:flame/components.dart';

import '../assets.dart';
import '../balance.dart';
import '../enums.dart';
import '../gfx.dart';
import 'gate.dart';

enum BattleStance { idle, move, hold, charge, focus, retreat }

/// Combat unit used only inside [BattleGame].
class BattleUnit extends PositionComponent {
  BattleUnit({
    required this.kind,
    required this.friendly,
    required Vector2 position,
    this.group,
    this.enemyVariant = 0,
  }) : super(
          position: position,
          size: Vector2.all(
            (friendly
                    ? Balance.radiusOf(kind)
                    : Balance.enemyRadius) *
                2,
          ),
          anchor: Anchor.center,
        ) {
    maxHp = friendly ? Balance.maxHpOf(kind) : Balance.enemyHp;
    hp = maxHp;
  }

  final UnitKind kind;
  final bool friendly;
  BattleGroupKind? group;
  final int enemyVariant;
  late int hp;
  late int maxHp;
  BattleStance stance = BattleStance.idle;
  Vector2? moveTarget;
  double attackCooldown = 0;
  bool dead = false;
  bool selected = false;
  double facing = -math.pi / 2; // default toward gate (up)

  double get radius => size.x / 2;

  double get speed =>
      friendly ? Balance.speedOf(kind) : Balance.enemySpeed;

  int get damage =>
      friendly ? Balance.damageOf(kind) : Balance.enemyDamage;

  double get attackRange =>
      friendly ? Balance.attackRangeOf(kind) : Balance.enemyAttackRange;

  double get cooldownMax => friendly
      ? Balance.attackCooldownOf(kind)
      : Balance.enemyAttackCooldown;

  bool get usesFullRotation =>
      kind.isShip || kind == UnitKind.rover || kind == UnitKind.mech || !friendly;

  void orderMove(Vector2 world) {
    if (dead) return;
    stance = BattleStance.move;
    moveTarget = world.clone();
  }

  void orderHold() {
    if (dead) return;
    stance = BattleStance.hold;
    moveTarget = null;
  }

  void orderCharge(Vector2 toward) {
    if (dead) return;
    stance = BattleStance.charge;
    moveTarget = toward.clone();
  }

  void orderRetreat(Vector2 home) {
    if (dead) return;
    stance = BattleStance.retreat;
    moveTarget = home.clone();
  }

  void orderFocus(Vector2 toward) {
    if (dead) return;
    stance = BattleStance.focus;
    moveTarget = toward.clone();
  }

  void takeDamage(int amount) {
    if (dead) return;
    hp -= amount;
    if (hp <= 0) {
      hp = 0;
      dead = true;
      removeFromParent();
    }
  }

  static const ColorFilter _enemyTint = ColorFilter.mode(
    Color(0xFFCE93D8),
    BlendMode.modulate,
  );

  @override
  void render(Canvas canvas) {
    if (dead) return;
    final c = Offset(size.x / 2, size.y / 2);
    Gfx.drawProjectedShadow(
      canvas,
      center: c,
      radius: radius,
      offsetY: radius * 0.32,
    );

    if (selected) {
      canvas.drawCircle(
        c,
        radius + 5,
        Paint()
          ..color = const Color(0xFF00AEEF)
          ..style = PaintingStyle.stroke
          ..strokeWidth = 1.6,
      );
    }

    if (friendly) {
      final sprite = GameAssets.instance.forUnit(kind);
      if (sprite != null) {
        Gfx.drawOrientedSprite(
          canvas,
          sprite: sprite,
          center: c,
          width: size.x * 1.1,
          height: size.y * 1.1,
          facingRad: facing,
          rotate: usesFullRotation,
        );
        Gfx.drawHighlight(
          canvas,
          center: c,
          width: size.x,
          height: size.y,
        );
      } else {
        canvas.drawCircle(c, radius, Paint()..color = const Color(0xFF4FC3F7));
      }
    } else {
      final sprite = GameAssets.instance.forEnemy(variant: enemyVariant);
      if (sprite != null) {
        Gfx.drawOrientedSprite(
          canvas,
          sprite: sprite,
          center: c,
          width: size.x * 1.2,
          height: size.y * 1.2,
          facingRad: facing,
          rotate: true,
          tint: _enemyTint,
        );
      } else {
        canvas.drawCircle(c, radius, Paint()..color = const Color(0xFFE53935));
        canvas.drawCircle(
          c,
          radius * 0.45,
          Paint()..color = const Color(0xFF8B0000),
        );
      }
    }

    final barW = size.x;
    const barH = 3.0;
    canvas.drawRect(
      Rect.fromLTWH(0, -6, barW, barH),
      Paint()..color = const Color(0xFF222222),
    );
    canvas.drawRect(
      Rect.fromLTWH(0, -6, barW * (hp / maxHp).clamp(0.0, 1.0), barH),
      Paint()
        ..color = friendly ? const Color(0xFF39FF14) : const Color(0xFFFF7043),
    );
  }

  bool _stepToward(Vector2 target, double dt) {
    final delta = target - position;
    final dist = delta.length;
    if (dist < 3) {
      position.setFrom(target);
      return true;
    }
    facing = math.atan2(delta.y, delta.x);
    final step = math.min(speed * dt, dist);
    position += delta.normalized() * step;
    return false;
  }

  void tickCombat({
    required double dt,
    required List<BattleUnit> allies,
    required List<BattleUnit> foes,
    required SiegeGate? gate,
    required Vector2 retreatPoint,
    required void Function(
      BattleUnit attacker,
      Vector2 from,
      Vector2 to,
      int dmg,
      bool vsGate,
    ) onFire,
  }) {
    if (dead) return;
    attackCooldown = math.max(0, attackCooldown - dt);

    // Stance-driven movement
    if (stance == BattleStance.hold) {
      // stay put; still shoot if in range below
    } else if (moveTarget != null) {
      final arrived = _stepToward(moveTarget!, dt);
      if (arrived &&
          (stance == BattleStance.move || stance == BattleStance.retreat)) {
        if (stance == BattleStance.retreat) {
          stance = BattleStance.hold;
        } else {
          stance = BattleStance.idle;
        }
        moveTarget = null;
      }
    }

    // Acquire target
    BattleUnit? nearestFoe;
    var best = double.infinity;
    for (final f in foes) {
      if (f.dead) continue;
      final d = position.distanceTo(f.position);
      if (d < best) {
        best = d;
        nearestFoe = f;
      }
    }

    final focusGate = stance == BattleStance.focus ||
        stance == BattleStance.charge ||
        (!friendly && gate != null);

    void face(Vector2 target) {
      facing = math.atan2(target.y - position.y, target.x - position.x);
    }

    void fireAtUnit(BattleUnit target) {
      face(target.position);
      attackCooldown = cooldownMax;
      onFire(this, position.clone(), target.position.clone(), damage, false);
    }

    void fireAtGate(SiegeGate g) {
      face(g.position);
      attackCooldown = cooldownMax;
      onFire(
        this,
        position.clone(),
        g.position.clone(),
        damage,
        true,
      );
    }

    // Enemies prioritize player units; if none, push south.
    if (!friendly) {
      if (nearestFoe != null) {
        if (best > attackRange) {
          _stepToward(nearestFoe.position, dt);
        } else if (attackCooldown <= 0) {
          fireAtUnit(nearestFoe);
        }
      } else {
        _stepToward(Vector2(position.x, Balance.battleRetreatY), dt);
      }
      return;
    }

    // Friendly: focus fire on gate if commanded / charging
    if (focusGate && gate != null && !gate.destroyed) {
      final gDist = position.distanceTo(gate.position);
      if (gDist > attackRange) {
        if (stance != BattleStance.hold) {
          _stepToward(gate.position, dt);
        }
      } else if (attackCooldown <= 0) {
        fireAtGate(gate);
      }
      // Also shoot nearby foes while focusing
      if (nearestFoe != null &&
          best <= attackRange &&
          attackCooldown <= 0 &&
          stance != BattleStance.focus) {
        fireAtUnit(nearestFoe);
      }
      return;
    }

    if (nearestFoe != null) {
      if (best > attackRange) {
        if (stance != BattleStance.hold && stance != BattleStance.retreat) {
          _stepToward(nearestFoe.position, dt);
        }
      } else if (attackCooldown <= 0) {
        fireAtUnit(nearestFoe);
      }
    }
  }
}
