import 'dart:ui';

import 'package:flame/components.dart';

import '../balance.dart';
import '../enums.dart';
import 'resource_node.dart';

class Building extends PositionComponent {
  Building({
    required this.kind,
    required Vector2 position,
    this.isComplete = true,
    int? hp,
    int? maxHp,
  }) : super(
          position: position,
          size: Vector2.all(_radiusFor(kind) * 2),
          anchor: Anchor.center,
        ) {
    this.hp = hp ?? _maxHpFor(kind);
    this.maxHp = maxHp ?? _maxHpFor(kind);
  }

  final BuildingKind kind;
  bool isComplete;
  double buildProgress = 0;
  double buildSecondsNeeded = 1;
  late int hp;
  late int maxHp;
  bool selected = false;
  ResourceNode? geyser;

  static double _radiusFor(BuildingKind k) {
    switch (k) {
      case BuildingKind.commandCenter:
        return Balance.ccRadius;
      case BuildingKind.refinery:
        return Balance.refineryRadius;
      case BuildingKind.supplyDepot:
        return Balance.supplyDepotRadius;
      case BuildingKind.barracks:
        return Balance.barracksRadius;
      case BuildingKind.outpost:
        return Balance.outpostRadius;
    }
  }

  static int _maxHpFor(BuildingKind k) {
    switch (k) {
      case BuildingKind.commandCenter:
        return Balance.ccMaxHp;
      case BuildingKind.refinery:
        return Balance.refineryMaxHp;
      case BuildingKind.supplyDepot:
        return Balance.supplyDepotMaxHp;
      case BuildingKind.barracks:
        return Balance.barracksMaxHp;
      case BuildingKind.outpost:
        return Balance.outpostMaxHp;
    }
  }

  double get radius => size.x / 2;

  bool get isDepositPoint =>
      isComplete &&
      (kind == BuildingKind.commandCenter || kind == BuildingKind.outpost);

  bool get canTrainWorkers => isComplete && kind == BuildingKind.commandCenter;

  @override
  void render(Canvas canvas) {
    final c = Offset(size.x / 2, size.y / 2);
    final body = Paint()..color = const Color(0xFF2B2F36);
    final accent = Paint()..color = const Color(0xFF00AEEF);
    final outline = Paint()
      ..color = selected ? const Color(0xFF39FF14) : const Color(0xFF5A6270)
      ..style = PaintingStyle.stroke
      ..strokeWidth = selected ? 2.5 : 1.5;

    switch (kind) {
      case BuildingKind.commandCenter:
        final r = RRect.fromRectAndRadius(
          Rect.fromCenter(
            center: c,
            width: size.x * 0.9,
            height: size.y * 0.75,
          ),
          const Radius.circular(6),
        );
        canvas.drawRRect(r, body);
        canvas.drawRRect(r, outline);
        canvas.drawRect(
          Rect.fromCenter(
            center: c.translate(0, -size.y * 0.15),
            width: size.x * 0.35,
            height: 10,
          ),
          accent,
        );
        final ant = Paint()
          ..color = const Color(0xFF00AEEF)
          ..strokeWidth = 2;
        canvas.drawLine(
          c.translate(size.x * 0.25, -size.y * 0.2),
          c.translate(size.x * 0.25, -size.y * 0.45),
          ant,
        );
        canvas.drawCircle(
          c.translate(size.x * 0.25, -size.y * 0.48),
          4,
          accent,
        );
      case BuildingKind.refinery:
        canvas.drawCircle(c, radius * 0.85, body);
        canvas.drawCircle(c, radius * 0.85, outline);
        canvas.drawCircle(
          c,
          radius * 0.35,
          Paint()..color = const Color(0xFF39FF14),
        );
        canvas.drawOval(
          Rect.fromCenter(
            center: c.translate(0, -radius * 1.1),
            width: 12,
            height: 36,
          ),
          Paint()..color = const Color(0xAA39FF14),
        );
      case BuildingKind.supplyDepot:
        final r = RRect.fromRectAndRadius(
          Rect.fromCenter(
            center: c,
            width: size.x * 0.85,
            height: size.y * 0.7,
          ),
          const Radius.circular(4),
        );
        canvas.drawRRect(r, body);
        canvas.drawRRect(r, outline);
        canvas.drawRect(
          Rect.fromCenter(center: c, width: size.x * 0.5, height: 6),
          accent,
        );
      case BuildingKind.barracks:
        final r = RRect.fromRectAndRadius(
          Rect.fromCenter(
            center: c,
            width: size.x * 0.9,
            height: size.y * 0.8,
          ),
          const Radius.circular(3),
        );
        canvas.drawRRect(r, body);
        canvas.drawRRect(r, outline);
        canvas.drawRect(
          Rect.fromCenter(center: c.translate(-10, 0), width: 8, height: 18),
          accent,
        );
        canvas.drawRect(
          Rect.fromCenter(center: c.translate(10, 0), width: 8, height: 18),
          accent,
        );
      case BuildingKind.outpost:
        canvas.drawCircle(c, radius * 0.8, body);
        canvas.drawCircle(c, radius * 0.8, outline);
        canvas.drawCircle(c, radius * 0.25, accent);
    }

    if (!isComplete) {
      final barW = size.x * 0.8;
      const barH = 6.0;
      final left = (size.x - barW) / 2;
      final top = size.y - 10;
      canvas.drawRect(
        Rect.fromLTWH(left, top, barW, barH),
        Paint()..color = const Color(0xFF111111),
      );
      canvas.drawRect(
        Rect.fromLTWH(left, top, barW * buildProgress.clamp(0.0, 1.0), barH),
        Paint()..color = const Color(0xFF39FF14),
      );
      canvas.drawRect(size.toRect(), Paint()..color = const Color(0x5500AEEF));
    }

    if (selected) {
      final ring = Paint()
        ..color = const Color(0x8800AEEF)
        ..style = PaintingStyle.stroke
        ..strokeWidth = 2;
      canvas.drawCircle(c, radius + 4, ring);
    }
  }
}
