import 'dart:math' as math;
import 'dart:ui';

import 'package:flame/components.dart';
import 'package:flutter/painting.dart';

import '../balance.dart';
import '../enums.dart';
import 'building.dart';
import 'resource_node.dart';

class GameUnit extends PositionComponent {
  GameUnit({
    required this.kind,
    required Vector2 position,
  }) : super(
          position: position,
          size: Vector2.all(Balance.workerRadius * 2),
          anchor: Anchor.center,
        );

  final UnitKind kind;
  int hp = Balance.workerMaxHp;
  int maxHp = Balance.workerMaxHp;
  bool selected = false;
  WorkerJob job = WorkerJob.idle;

  Vector2? moveTarget;
  ResourceNode? harvestTarget;
  Building? depositTarget;
  Building? buildTarget;
  ResourceKind? carryingKind;
  int carryingAmount = 0;
  double gatherTimer = 0;
  bool holdPosition = false;

  double get radius => size.x / 2;
  double get speed => Balance.workerSpeed;
  bool get isCarrying => carryingAmount > 0;

  void orderMove(Vector2 worldPos) {
    holdPosition = false;
    moveTarget = worldPos.clone();
    harvestTarget = null;
    depositTarget = null;
    buildTarget = null;
    job = WorkerJob.moving;
    // Keep cargo if any — player can re-route.
  }

  void orderHold() {
    holdPosition = true;
    moveTarget = null;
    harvestTarget = null;
    depositTarget = null;
    buildTarget = null;
    job = WorkerJob.holding;
  }

  void orderHarvest(ResourceNode node) {
    holdPosition = false;
    harvestTarget = node;
    buildTarget = null;
    moveTarget = node.position.clone();
    job = WorkerJob.moving;
  }

  void orderBuild(Building site) {
    holdPosition = false;
    buildTarget = site;
    harvestTarget = null;
    depositTarget = null;
    moveTarget = site.position.clone();
    job = WorkerJob.moving;
  }

  @override
  void render(Canvas canvas) {
    final c = Offset(size.x / 2, size.y / 2);
    if (selected) {
      final dash = Paint()
        ..color = const Color(0xFF00AEEF)
        ..style = PaintingStyle.stroke
        ..strokeWidth = 1.5;
      canvas.drawCircle(c, radius + 5, dash);
    }
    final body = Paint()..color = const Color(0xFF4A5568);
    final armor = Paint()..color = const Color(0xFF00AEEF);
    canvas.drawCircle(c, radius, body);
    canvas.drawCircle(c, radius * 0.55, armor);
    canvas.drawCircle(
      c.translate(0, -2),
      3,
      Paint()..color = const Color(0xFFE2E8F0),
    );
    if (isCarrying) {
      final cargoColor = carryingKind == ResourceKind.gas
          ? const Color(0xFF39FF14)
          : const Color(0xFF00AEEF);
      canvas.drawCircle(
        c.translate(radius * 0.7, -radius * 0.5),
        5,
        Paint()..color = cargoColor,
      );
    }
    // HP bar
    final barW = size.x;
    const barH = 3.0;
    canvas.drawRect(
      Rect.fromLTWH(0, -6, barW, barH),
      Paint()..color = const Color(0xFF222222),
    );
    canvas.drawRect(
      Rect.fromLTWH(0, -6, barW * (hp / maxHp).clamp(0.0, 1.0), barH),
      Paint()..color = const Color(0xFF39FF14),
    );
  }

  /// Returns true if arrived.
  bool _stepToward(Vector2 target, double dt) {
    final delta = target - position;
    final dist = delta.length;
    if (dist < 2) {
      position.setFrom(target);
      return true;
    }
    final step = math.min(speed * dt, dist);
    position += delta.normalized() * step;
    return false;
  }

  void tickAI({
    required double dt,
    required Building? Function() findDeposit,
    required void Function(GameUnit u, int minerals, int gas) onDeposit,
    required void Function(Building b) onBuildComplete,
  }) {
    if (holdPosition && job == WorkerJob.holding) return;

    if (buildTarget != null) {
      final site = buildTarget!;
      if (site.isComplete || site.parent == null) {
        buildTarget = null;
        job = WorkerJob.idle;
        return;
      }
      final dist = position.distanceTo(site.position);
      if (dist > site.radius + radius + 8) {
        job = WorkerJob.moving;
        _stepToward(site.position, dt);
        return;
      }
      job = WorkerJob.building;
      site.buildProgress += dt / site.buildSecondsNeeded;
      if (site.buildProgress >= 1) {
        site.buildProgress = 1;
        site.isComplete = true;
        onBuildComplete(site);
        buildTarget = null;
        job = WorkerJob.idle;
      }
      return;
    }

    if (harvestTarget != null || isCarrying) {
      _tickHarvest(dt, findDeposit, onDeposit);
      return;
    }

    if (moveTarget != null) {
      job = WorkerJob.moving;
      if (_stepToward(moveTarget!, dt)) {
        moveTarget = null;
        job = WorkerJob.idle;
      }
    }
  }

  void _tickHarvest(
    double dt,
    Building? Function() findDeposit,
    void Function(GameUnit u, int minerals, int gas) onDeposit,
  ) {
    if (isCarrying) {
      depositTarget ??= findDeposit();
      final dep = depositTarget;
      if (dep == null) {
        job = WorkerJob.idle;
        return;
      }
      final dist = position.distanceTo(dep.position);
      if (dist > Balance.harvestDepositRange) {
        job = WorkerJob.carrying;
        _stepToward(dep.position, dt);
        return;
      }
      job = WorkerJob.depositing;
      if (carryingKind == ResourceKind.mineral) {
        onDeposit(this, carryingAmount, 0);
      } else {
        onDeposit(this, 0, carryingAmount);
      }
      carryingAmount = 0;
      carryingKind = null;
      depositTarget = null;
      // Auto-loop
      if (harvestTarget != null && !harvestTarget!.depleted) {
        moveTarget = harvestTarget!.position.clone();
        job = WorkerJob.moving;
      } else {
        harvestTarget = null;
        job = WorkerJob.idle;
      }
      return;
    }

    final node = harvestTarget;
    if (node == null || node.depleted || node.parent == null) {
      harvestTarget = null;
      job = WorkerJob.idle;
      return;
    }
    // Gas requires refinery
    if (node.kind == ResourceKind.gas && !node.hasRefinery) {
      harvestTarget = null;
      job = WorkerJob.idle;
      return;
    }

    final dist = position.distanceTo(node.position);
    if (dist > Balance.harvestNodeRange) {
      job = WorkerJob.moving;
      _stepToward(node.position, dt);
      return;
    }

    job = WorkerJob.harvesting;
    gatherTimer += dt;
    if (gatherTimer >= Balance.harvestGatherSeconds) {
      gatherTimer = 0;
      final amount = node.kind == ResourceKind.mineral
          ? Balance.mineralCarryAmount
          : Balance.gasCarryAmount;
      final taken = node.take(amount);
      if (taken > 0) {
        carryingAmount = taken;
        carryingKind = node.kind;
        depositTarget = findDeposit();
        job = WorkerJob.carrying;
      } else {
        harvestTarget = null;
        job = WorkerJob.idle;
      }
    }
  }
}
