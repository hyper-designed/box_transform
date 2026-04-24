import 'dart:math' as math;

import 'package:box_transform/box_transform.dart';
import 'package:test/test.dart';
import 'package:vector_math/vector_math_64.dart';

void main() {
  group('Symmetric resize with rotation', () {
    test('grows symmetrically around center', () {
      final initial = Box.fromLTWH(0, 0, 100, 100, rotation: math.pi / 6);
      final initialCenter = Vector2(50, 50);
      final result = BoxTransformer.resize(
        initialRect: initial,
        initialLocalPosition: Vector2(100, 100),
        localPosition: Vector2(150, 150),
        handle: HandlePosition.bottomRight,
        resizeMode: ResizeMode.symmetric,
        initialFlip: Flip.none,
        clampingRect: Box.fromLTRB(-500, -500, 500, 500),
        constraints: const Constraints(),
        allowFlipping: false,
        rotation: math.pi / 6,
      );
      final resultCenter = Vector2(
        (result.rect.left + result.rect.right) / 2,
        (result.rect.top + result.rect.bottom) / 2,
      );
      expect(resultCenter.x, closeTo(initialCenter.x, 1e-4));
      expect(resultCenter.y, closeTo(initialCenter.y, 1e-4));
    });

    test('clamp rect constrains symmetric growth under rotation', () {
      final initial = Box.fromLTWH(0, 0, 50, 50, rotation: math.pi / 4);
      final result = BoxTransformer.resize(
        initialRect: initial,
        initialLocalPosition: Vector2(50, 50),
        localPosition: Vector2(500, 500),
        handle: HandlePosition.bottomRight,
        resizeMode: ResizeMode.symmetric,
        initialFlip: Flip.none,
        clampingRect: Box.fromLTRB(-100, -100, 100, 100),
        constraints: const Constraints(),
        allowFlipping: false,
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
      ].map((p) => ClampHelpers.rotatePointAround(
          p, Vector2(cx, cy), result.rect.rotation));
      for (final c in corners) {
        expect(c.x, inInclusiveRange(-100 - 1e-4, 100 + 1e-4));
        expect(c.y, inInclusiveRange(-100 - 1e-4, 100 + 1e-4));
      }
    });
  });
}
