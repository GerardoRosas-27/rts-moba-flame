import 'dart:math' as math;
import 'dart:ui';

import 'package:flame/components.dart';

import '../enums.dart';

class ResourceNode extends PositionComponent {
  ResourceNode({
    required this.kind,
    required Vector2 position,
    required this.remaining,
    this.maxAmount = 1500,
  }) : super(
          position: position,
          size: Vector2.all(28),
          anchor: Anchor.center,
        );

  final ResourceKind kind;
  int remaining;
  final int maxAmount;

  bool get depleted => remaining <= 0;

  int take(int amount) {
    if (depleted) return 0;
    final taken = math.min(amount, remaining);
    remaining -= taken;
    return taken;
  }

  @override
  void render(Canvas canvas) {
    final center = Offset(size.x / 2, size.y / 2);
    _drawMinerals(canvas, center);
  }

  void _drawMinerals(Canvas canvas, Offset c) {
    final paint = Paint()..color = const Color(0xFF00AEEF);
    final dark = Paint()..color = const Color(0xFF006A99);
    final glow = Paint()
      ..color = const Color(0x6600AEEF)
      ..maskFilter = const MaskFilter.blur(BlurStyle.normal, 6);
    canvas.drawCircle(c, 14, glow);
    final path = Path()
      ..moveTo(c.dx, c.dy - 16)
      ..lineTo(c.dx + 10, c.dy + 4)
      ..lineTo(c.dx + 2, c.dy + 12)
      ..lineTo(c.dx - 8, c.dy + 6)
      ..close();
    canvas.drawPath(path, paint);
    canvas.drawPath(
      Path()
        ..moveTo(c.dx - 6, c.dy - 8)
        ..lineTo(c.dx + 4, c.dy - 2)
        ..lineTo(c.dx - 2, c.dy + 8)
        ..lineTo(c.dx - 12, c.dy + 2)
        ..close(),
      dark,
    );
    if (depleted) {
      canvas.drawCircle(c, 12, Paint()..color = const Color(0x88000000));
    }
  }
}
