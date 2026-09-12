import 'dart:ui';

import 'package:flame/components.dart';

import '../assets.dart';
import '../balance.dart';
import '../enums.dart';
import '../gfx.dart';

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

  static double _radiusFor(BuildingKind k) {
    switch (k) {
      case BuildingKind.commandCenter:
        return Balance.ccRadius;
      case BuildingKind.solarPanel:
        return Balance.solarPanelRadius;
      case BuildingKind.supplyDepot:
        return Balance.supplyDepotRadius;
      case BuildingKind.barracks:
        return Balance.barracksRadius;
      case BuildingKind.outpost:
        return Balance.outpostRadius;
      case BuildingKind.laboratory:
        return Balance.laboratoryRadius;
      case BuildingKind.starport:
        return Balance.starportRadius;
    }
  }

  static int _maxHpFor(BuildingKind k) {
    switch (k) {
      case BuildingKind.commandCenter:
        return Balance.ccMaxHp;
      case BuildingKind.solarPanel:
        return Balance.solarPanelMaxHp;
      case BuildingKind.supplyDepot:
        return Balance.supplyDepotMaxHp;
      case BuildingKind.barracks:
        return Balance.barracksMaxHp;
      case BuildingKind.outpost:
        return Balance.outpostMaxHp;
      case BuildingKind.laboratory:
        return Balance.laboratoryMaxHp;
      case BuildingKind.starport:
        return Balance.starportMaxHp;
    }
  }

  double get radius => size.x / 2;

  bool get isDepositPoint =>
      isComplete &&
      (kind == BuildingKind.commandCenter || kind == BuildingKind.outpost);

  bool get canTrainWorkers => isComplete && kind == BuildingKind.commandCenter;

  bool get canTrainMilitary => isComplete && kind == BuildingKind.barracks;

  bool get canResearch => isComplete && kind == BuildingKind.laboratory;

  bool get canTrainShips => isComplete && kind == BuildingKind.starport;

  bool get generatesEnergy => isComplete && kind == BuildingKind.solarPanel;

  @override
  void render(Canvas canvas) {
    final c = Offset(size.x / 2, size.y / 2);
    Gfx.drawProjectedShadow(
      canvas,
      center: c,
      radius: radius,
      offsetY: radius * 0.28,
      scaleX: 1.25,
      scaleY: 0.38,
      opacity: 0.42,
    );

    final sprite = GameAssets.instance.forBuilding(kind);
    if (sprite != null) {
      final dest = Rect.fromCenter(
        center: c,
        width: size.x * 1.05,
        height: size.y * 1.05,
      );
      sprite.renderRect(canvas, dest);
      Gfx.drawHighlight(
        canvas,
        center: c,
        width: size.x * 0.95,
        height: size.y * 0.95,
      );
    } else {
      final body = Paint()..color = const Color(0xFFE8EEF5);
      canvas.drawRRect(
        RRect.fromRectAndRadius(
          Rect.fromCenter(center: c, width: size.x * 0.9, height: size.y * 0.75),
          const Radius.circular(6),
        ),
        body,
      );
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
        ..strokeWidth = 2.5;
      canvas.drawCircle(c, radius + 4, ring);
    }
  }
}
