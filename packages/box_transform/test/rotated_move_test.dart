import 'dart:math' as math;

import 'package:box_transform/box_transform.dart';
import 'package:test/test.dart';
import 'package:vector_math/vector_math_64.dart';

void main() {
  group('Rotation-aware move', () {
    test('rotated box translation keeps all corners in clamp', () {
      final initial = Box.fromLTWH(0, 0, 100, 100, rotation: math.pi / 4);
      final result = BoxTransformer.move(
        initialRect: initial,
        initialLocalPosition: Vector2(50, 50),
        localPosition: Vector2(300, 300),
        clampingRect: Box.fromLTRB(-100, -100, 200, 200),
        rotation: math.pi / 4,
        bindingStrategy: BindingStrategy.boundingBox,
      );
      final cx = (result.rect.left + result.rect.right) / 2;
      final cy = (result.rect.top + result.rect.bottom) / 2;
      final corners = [
        Vector2(result.rect.left, result.rect.top),
        Vector2(result.rect.right, result.rect.top),
        Vector2(result.rect.right, result.rect.bottom),
        Vector2(result.rect.left, result.rect.bottom),
      ].map((p) =>
          ClampHelpers.rotatePointAround(p, Vector2(cx, cy), math.pi / 4));
      for (final c in corners) {
        expect(c.x, inInclusiveRange(-100 - 1e-4, 200 + 1e-4));
        expect(c.y, inInclusiveRange(-100 - 1e-4, 200 + 1e-4));
      }
      expect(result.rect.rotation, closeTo(math.pi / 4, 1e-12));
    });

    test('theta=0 move is unchanged from existing behavior', () {
      final initial = Box.fromLTWH(0, 0, 100, 100);
      final result = BoxTransformer.move(
        initialRect: initial,
        initialLocalPosition: Vector2(50, 50),
        localPosition: Vector2(70, 80),
        clampingRect: Box.fromLTRB(-500, -500, 500, 500),
      );
      expect(result.rect.left, closeTo(20, 1e-9));
      expect(result.rect.top, closeTo(30, 1e-9));
    });
  });
}
