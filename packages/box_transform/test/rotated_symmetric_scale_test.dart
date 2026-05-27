import 'dart:math' as math;

import 'package:box_transform/box_transform.dart';
import 'package:test/test.dart';
import 'package:vector_math/vector_math_64.dart';

void main() {
  group('Symmetric-scale resize with rotation', () {
    test('preserves aspect ratio and grows from center', () {
      final initial = Box.fromLTWH(0, 0, 200, 100, rotation: math.pi / 5);
      final initialAspect = initial.width / initial.height;
      final initialCenter = Vector2(100, 50);
      final result = BoxTransformer.resize(
        initialRect: initial,
        initialLocalPosition: Vector2(200, 100),
        localPosition: Vector2(300, 200),
        handle: HandlePosition.bottomRight,
        resizeMode: ResizeMode.symmetricScale,
        initialFlip: Flip.none,
        clampingRect: Box.fromLTRB(-1000, -1000, 1000, 1000),
        constraints: const Constraints(),
        allowFlipping: false,
        rotation: math.pi / 5,
      );
      expect(
          result.rect.width / result.rect.height, closeTo(initialAspect, 1e-4));
      final resultCenter = Vector2(
        (result.rect.left + result.rect.right) / 2,
        (result.rect.top + result.rect.bottom) / 2,
      );
      expect(resultCenter.x, closeTo(initialCenter.x, 1e-4));
      expect(resultCenter.y, closeTo(initialCenter.y, 1e-4));
    });
  });
}
