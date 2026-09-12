import 'dart:math' as math;
import 'dart:ui';

import 'package:flame/components.dart';

/// Animated projectile that flies toward a world point, then invokes [onHit].
class Projectile extends PositionComponent {
  Projectile({
    required Vector2 from,
    required Vector2 to,
    required this.onHit,
    this.color = const Color(0xFFFFF176),
    this.speed = 420,
    this.radius = 3.5,
  })  : _to = to.clone(),
        super(
          position: from.clone(),
          size: Vector2.all(radius * 2),
          anchor: Anchor.center,
          priority: 80,
        );

  final Vector2 _to;
  final void Function() onHit;
  final Color color;
  final double speed;
  final double radius;
  bool _done = false;

  @override
  void update(double dt) {
    if (_done) return;
    final delta = _to - position;
    final dist = delta.length;
    final step = math.min(speed * dt, dist);
    if (dist < 4) {
      _done = true;
      onHit();
      removeFromParent();
      return;
    }
    position += delta.normalized() * step;
  }

  @override
  void render(Canvas canvas) {
    final c = Offset(size.x / 2, size.y / 2);
    canvas.drawCircle(
      c,
      radius + 2,
      Paint()..color = color.withValues(alpha: 0.35),
    );
    canvas.drawCircle(c, radius, Paint()..color = color);
    canvas.drawCircle(
      c.translate(-radius * 0.25, -radius * 0.25),
      radius * 0.35,
      Paint()..color = const Color(0xCCFFFFFF),
    );
  }
}

/// Brief radial explosion / impact puff.
class Explosion extends PositionComponent {
  Explosion({
    required Vector2 position,
    this.maxRadius = 28,
    this.duration = 0.45,
    this.color = const Color(0xFFFF6D00),
  }) : super(
          position: position.clone(),
          size: Vector2.all(maxRadius * 2),
          anchor: Anchor.center,
          priority: 90,
        );

  final double maxRadius;
  final double duration;
  final Color color;
  double _t = 0;

  @override
  void update(double dt) {
    _t += dt;
    if (_t >= duration) {
      removeFromParent();
    }
  }

  @override
  void render(Canvas canvas) {
    final p = (_t / duration).clamp(0.0, 1.0);
    final r = maxRadius * (0.35 + 0.65 * p);
    final alpha = (1.0 - p);
    final c = Offset(size.x / 2, size.y / 2);
    canvas.drawCircle(
      c,
      r,
      Paint()..color = color.withValues(alpha: 0.55 * alpha),
    );
    canvas.drawCircle(
      c,
      r * 0.55,
      Paint()..color = const Color(0xFFFFEB3B).withValues(alpha: 0.7 * alpha),
    );
    canvas.drawCircle(
      c,
      r * 0.22,
      Paint()..color = const Color(0xFFFFFFFF).withValues(alpha: 0.85 * alpha),
    );
    // Sparks
    final spark = Paint()
      ..color = const Color(0xFFFFAB40).withValues(alpha: 0.8 * alpha)
      ..strokeWidth = 2
      ..style = PaintingStyle.stroke;
    for (var i = 0; i < 6; i++) {
      final a = i * math.pi / 3 + p * 0.8;
      final len = r * (0.7 + 0.4 * p);
      canvas.drawLine(
        c,
        Offset(c.dx + math.cos(a) * len, c.dy + math.sin(a) * len),
        spark,
      );
    }
  }
}
