import 'dart:ui';

import 'package:flame/components.dart';

import '../assets.dart';

/// Decorative landscape prop (rock / tree / bush) from Quaternius kit.
class MapProp extends PositionComponent {
  MapProp({
    required this.assetPath,
    required Vector2 position,
    required double sizePx,
  }) : super(
          position: position,
          size: Vector2.all(sizePx),
          anchor: Anchor.center,
          priority: -50,
        );

  final String assetPath;

  @override
  void render(Canvas canvas) {
    final sprite = GameAssets.instance.get(assetPath);
    if (sprite == null) return;
    sprite.renderRect(canvas, size.toRect());
  }
}
