import 'dart:math' as math;
import 'dart:ui';

import 'package:flame/components.dart';

import '../balance.dart';

class TerrainBackground extends PositionComponent {
  TerrainBackground()
      : super(
          position: Vector2.zero(),
          size: Vector2(Balance.mapWidth, Balance.mapHeight),
          priority: -100,
        );

  final _rng = math.Random(42);
  late final List<Offset> _rocks;
  late final List<Offset> _craters;

  @override
  Future<void> onLoad() async {
    _rocks = List.generate(80, (_) {
      return Offset(
        _rng.nextDouble() * Balance.mapWidth,
        _rng.nextDouble() * Balance.mapHeight,
      );
    });
    _craters = List.generate(24, (_) {
      return Offset(
        _rng.nextDouble() * Balance.mapWidth,
        _rng.nextDouble() * Balance.mapHeight,
      );
    });
  }

  @override
  void render(Canvas canvas) {
    canvas.drawRect(
      size.toRect(),
      Paint()..color = const Color(0xFF3A2418),
    );
    // Subtle grid / dunes
    final dune = Paint()..color = const Color(0xFF4A3020);
    for (var y = 0.0; y < size.y; y += 120) {
      canvas.drawRect(Rect.fromLTWH(0, y, size.x, 40), dune);
    }
    final craterPaint = Paint()..color = const Color(0xFF2A1810);
    for (final c in _craters) {
      canvas.drawOval(
        Rect.fromCenter(center: c, width: 70, height: 40),
        craterPaint,
      );
    }
    final rockPaint = Paint()..color = const Color(0xFF5A3A28);
    for (final r in _rocks) {
      canvas.drawCircle(r, 6 + (r.dx % 5), rockPaint);
    }
    // Border
    canvas.drawRect(
      size.toRect().deflate(2),
      Paint()
        ..color = const Color(0xFF00AEEF)
        ..style = PaintingStyle.stroke
        ..strokeWidth = 3,
    );
  }
}
