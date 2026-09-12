import 'dart:math' as math;
import 'dart:ui';

import 'package:flame/components.dart';

/// Shared mid-tier 2.5D helpers: projected shadow + facing.
class Gfx {
  Gfx._();

  /// World feel: double-tap type-select radius (world px).
  static const double typeSelectRadius = 150;

  /// Max ms between taps to count as double-tap.
  static const int doubleTapMs = 320;

  /// Formation cell spacing (world px).
  static const double formationSpacing = 34;

  /// Max columns in a march grid.
  static const int formationMaxCols = 5;

  /// Draw soft elliptical drop shadow under a sprite (projected ground).
  static void drawProjectedShadow(
    Canvas canvas, {
    required Offset center,
    required double radius,
    double offsetY = 6,
    double scaleX = 1.15,
    double scaleY = 0.42,
    double opacity = 0.38,
  }) {
    final shadow = Paint()
      ..color = Color.fromRGBO(0, 0, 0, opacity)
      ..maskFilter = const MaskFilter.blur(BlurStyle.normal, 3);
    canvas.drawOval(
      Rect.fromCenter(
        center: center.translate(0, offsetY),
        width: radius * 2 * scaleX,
        height: radius * 2 * scaleY,
      ),
      shadow,
    );
  }

  /// Soft roof / hull highlight (cheap specular).
  static void drawHighlight(
    Canvas canvas, {
    required Offset center,
    required double width,
    required double height,
  }) {
    final highlight = Paint()
      ..shader = Gradient.linear(
        center.translate(-width * 0.2, -height * 0.35),
        center.translate(width * 0.15, height * 0.1),
        [
          const Color(0x55FFFFFF),
          const Color(0x00FFFFFF),
        ],
      );
    canvas.drawOval(
      Rect.fromCenter(
        center: center.translate(0, -height * 0.12),
        width: width * 0.55,
        height: height * 0.28,
      ),
      highlight,
    );
  }

  /// Render a sprite with optional flip / rotate toward [facingRad].
  /// [rotate] true → full angle; false → horizontal flip only.
  static void drawOrientedSprite(
    Canvas canvas, {
    required Sprite sprite,
    required Offset center,
    required double width,
    required double height,
    required double facingRad,
    required bool rotate,
    ColorFilter? tint,
  }) {
    canvas.save();
    canvas.translate(center.dx, center.dy);
    if (rotate) {
      canvas.rotate(facingRad);
    } else {
      // Flip when facing left (π/2 … 3π/2).
      final facingRight =
          facingRad > -math.pi / 2 && facingRad < math.pi / 2;
      if (!facingRight) {
        canvas.scale(-1, 1);
      }
    }
    final dest = Rect.fromCenter(
      center: Offset.zero,
      width: width,
      height: height,
    );
    if (tint != null) {
      final paint = Paint()..colorFilter = tint;
      sprite.renderRect(canvas, dest, overridePaint: paint);
    } else {
      sprite.renderRect(canvas, dest);
    }
    canvas.restore();
  }

  /// Slot offsets for an ordered formation around [center].
  static List<Vector2> formationSlots(Vector2 center, int count) {
    if (count <= 0) return const [];
    if (count == 1) return [center.clone()];
    final cols = math.min(formationMaxCols, math.sqrt(count).ceil());
    final rows = (count / cols).ceil();
    final slots = <Vector2>[];
    for (var i = 0; i < count; i++) {
      final col = i % cols;
      final row = i ~/ cols;
      final ox = (col - (cols - 1) / 2) * formationSpacing;
      final oy = (row - (rows - 1) / 2) * formationSpacing;
      slots.add(center + Vector2(ox, oy));
    }
    return slots;
  }

  static double angleToward(Vector2 from, Vector2 to) {
    final d = to - from;
    if (d.length2 < 0.01) return 0;
    return math.atan2(d.y, d.x);
  }
}
