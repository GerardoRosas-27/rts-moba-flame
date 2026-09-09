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
  late final List<Offset> _dunes;
  late final List<Offset> _craters;
  late final List<(Offset, double)> _stars;

  @override
  Future<void> onLoad() async {
    _dunes = List.generate(36, (_) {
      return Offset(
        _rng.nextDouble() * Balance.mapWidth,
        _rng.nextDouble() * Balance.mapHeight,
      );
    });
    _craters = List.generate(20, (_) {
      return Offset(
        _rng.nextDouble() * Balance.mapWidth,
        _rng.nextDouble() * Balance.mapHeight,
      );
    });
    _stars = List.generate(60, (_) {
      return (
        Offset(
          _rng.nextDouble() * Balance.mapWidth,
          _rng.nextDouble() * Balance.mapHeight,
        ),
        0.6 + _rng.nextDouble() * 1.4,
      );
    });
  }

  @override
  void render(Canvas canvas) {
    // Space / planetary ochre ground
    canvas.drawRect(
      size.toRect(),
      Paint()..color = const Color(0xFF2A1810),
    );
    canvas.drawRect(
      size.toRect(),
      Paint()..color = const Color(0xFF3E2618),
    );
    final dune = Paint()..color = const Color(0xFF4A3020);
    for (final d in _dunes) {
      canvas.drawOval(
        Rect.fromCenter(center: d, width: 180 + (d.dx % 80), height: 50),
        dune,
      );
    }
    final craterPaint = Paint()..color = const Color(0xFF24140C);
    for (final c in _craters) {
      canvas.drawOval(
        Rect.fromCenter(center: c, width: 70, height: 40),
        craterPaint,
      );
    }
    // Sparse “stars” / glitter on ground for space vibe
    final starPaint = Paint()..color = const Color(0x33FFFFFF);
    for (final (o, r) in _stars) {
      canvas.drawCircle(o, r, starPaint);
    }
    canvas.drawRect(
      size.toRect().deflate(2),
      Paint()
        ..color = const Color(0xFF00AEEF)
        ..style = PaintingStyle.stroke
        ..strokeWidth = 3,
    );
  }
}
