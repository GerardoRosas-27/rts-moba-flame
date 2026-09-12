import 'dart:math' as math;
import 'dart:ui';

import 'package:flame/components.dart';

import '../balance.dart';

class BattleTerrain extends PositionComponent {
  BattleTerrain()
      : super(
          position: Vector2.zero(),
          size: Vector2(Balance.battleMapWidth, Balance.battleMapHeight),
          priority: -100,
        );

  final _rng = math.Random(11);
  late final List<Offset> _rocks;
  late final List<Offset> _stars;

  @override
  Future<void> onLoad() async {
    _rocks = List.generate(18, (_) {
      return Offset(
        40 + _rng.nextDouble() * (Balance.battleMapWidth - 80),
        80 + _rng.nextDouble() * (Balance.battleMapHeight - 160),
      );
    });
    _stars = List.generate(40, (_) {
      return Offset(
        _rng.nextDouble() * Balance.battleMapWidth,
        _rng.nextDouble() * Balance.battleMapHeight,
      );
    });
  }

  @override
  void render(Canvas canvas) {
    canvas.drawRect(
      size.toRect(),
      Paint()..color = const Color(0xFF1A1520),
    );
    // Approach lane
    canvas.drawRect(
      Rect.fromLTWH(
        Balance.battleMapWidth * 0.28,
        200,
        Balance.battleMapWidth * 0.44,
        Balance.battleMapHeight - 360,
      ),
      Paint()..color = const Color(0xFF2A2230),
    );
    for (final s in _stars) {
      canvas.drawCircle(s, 1.2, Paint()..color = const Color(0x66FFFFFF));
    }
    for (final r in _rocks) {
      canvas.drawOval(
        Rect.fromCenter(center: r, width: 28, height: 18),
        Paint()..color = const Color(0xFF3E3428),
      );
    }
    // Player rally zone marker
    canvas.drawRect(
      Rect.fromCenter(
        center: Offset(Balance.battleMapWidth / 2, Balance.battlePlayerSpawnY),
        width: 280,
        height: 60,
      ),
      Paint()..color = const Color(0x3300AEEF),
    );
  }
}
