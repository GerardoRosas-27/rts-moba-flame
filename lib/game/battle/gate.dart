import 'dart:ui';

import 'package:flame/components.dart';

import '../balance.dart';

/// Muralla / puerta enemiga — destruirla gana el Asedio.
class SiegeGate extends PositionComponent {
  SiegeGate({required Vector2 position})
      : super(
          position: position,
          size: Vector2(Balance.battleGateWidth, Balance.battleGateHeight),
          anchor: Anchor.center,
          priority: -10,
        ) {
    hp = Balance.battleGateHp;
    maxHp = Balance.battleGateHp;
  }

  late double hp;
  late double maxHp;
  bool destroyed = false;

  void takeDamage(int amount) {
    if (destroyed) return;
    hp -= amount;
    if (hp <= 0) {
      hp = 0;
      destroyed = true;
    }
  }

  double get hpRatio => (hp / maxHp).clamp(0.0, 1.0);

  @override
  void render(Canvas canvas) {
    final rect = size.toRect();
    final wall = Paint()
      ..color = destroyed
          ? const Color(0xFF4A3728)
          : const Color(0xFF6D4C41);
    canvas.drawRRect(
      RRect.fromRectAndRadius(rect, const Radius.circular(6)),
      wall,
    );

    // Gate door
    final door = Rect.fromCenter(
      center: Offset(size.x / 2, size.y / 2),
      width: size.x * 0.28,
      height: size.y * 0.85,
    );
    canvas.drawRRect(
      RRect.fromRectAndRadius(door, const Radius.circular(4)),
      Paint()
        ..color = destroyed
            ? const Color(0xFF3E2723)
            : const Color(0xFF8D6E63),
    );

    // Metal braces
    final brace = Paint()
      ..color = const Color(0xFFB0BEC5)
      ..strokeWidth = 3
      ..style = PaintingStyle.stroke;
    canvas.drawLine(Offset(8, 8), Offset(size.x - 8, 8), brace);
    canvas.drawLine(
      Offset(8, size.y - 8),
      Offset(size.x - 8, size.y - 8),
      brace,
    );

    // HP bar above
    final barW = size.x * 0.9;
    const barH = 8.0;
    final left = (size.x - barW) / 2;
    canvas.drawRect(
      Rect.fromLTWH(left, -16, barW, barH),
      Paint()..color = const Color(0xFF111111),
    );
    canvas.drawRect(
      Rect.fromLTWH(left, -16, barW * hpRatio, barH),
      Paint()
        ..color = destroyed
            ? const Color(0xFF757575)
            : const Color(0xFFFF5252),
    );
  }
}
