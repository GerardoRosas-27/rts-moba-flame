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
          size: Vector2.all(kind == ResourceKind.mineral ? 28 : 44),
          anchor: Anchor.center,
        );

  final ResourceKind kind;
  int remaining;
  final int maxAmount;
  bool hasRefinery = false;

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
    if (kind == ResourceKind.mineral) {
      _drawMinerals(canvas, center);
    } else {
      _drawGeyser(canvas, center);
    }
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

  void _drawGeyser(Canvas canvas, Offset c) {
    final ring = Paint()
      ..color = const Color(0xFF2A2A2A)
      ..style = PaintingStyle.stroke
      ..strokeWidth = 4;
    final fill = Paint()..color = const Color(0xFF1A1A1A);
    canvas.drawCircle(c, 20, fill);
    canvas.drawCircle(c, 20, ring);
    if (!hasRefinery && !depleted) {
      final gas = Paint()
        ..color = const Color(0xFF39FF14)
        ..maskFilter = const MaskFilter.blur(BlurStyle.normal, 4);
      canvas.drawCircle(c.translate(0, -8), 6, gas);
      canvas.drawOval(
        Rect.fromCenter(center: c.translate(0, -22), width: 10, height: 28),
        Paint()..color = const Color(0x8839FF14),
      );
    }
  }
}
