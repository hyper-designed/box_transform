import 'dart:math' as math;

import 'package:box_transform/box_transform.dart';
import 'package:test/test.dart';
import 'package:vector_math/vector_math_64.dart';

void main() {
  group('rotatePointAround', () {
    test('identity at theta=0', () {
      final p = Vector2(10, 5);
      final result = ClampHelpers.rotatePointAround(p, Vector2.zero(), 0.0);
      expect(result.x, closeTo(10, 1e-12));
      expect(result.y, closeTo(5, 1e-12));
    });

    test('rotates pi/2 around origin maps (1,0) -> (0,1)', () {
      final result = ClampHelpers.rotatePointAround(
          Vector2(1, 0), Vector2.zero(), math.pi / 2);
      expect(result.x, closeTo(0, 1e-12));
      expect(result.y, closeTo(1, 1e-12));
    });

    test('rotates around a non-origin pivot', () {
      // Rotate (2,0) by pi around pivot (1,0). Expected: (0,0).
      final result =
          ClampHelpers.rotatePointAround(Vector2(2, 0), Vector2(1, 0), math.pi);
      expect(result.x, closeTo(0, 1e-12));
      expect(result.y, closeTo(0, 1e-12));
    });
  });

  group('worldToUnrotated / unrotatedToWorld round-trip', () {
    test('round-trips at arbitrary theta', () {
      // vector_math_64 gives full double precision; tolerance ~1e-12.
      final pivot = Vector2(5, 7);
      const theta = 0.6435;
      final original = Vector2(42, -3);
      final local = ClampHelpers.worldToUnrotated(original, pivot, theta);
      final back = ClampHelpers.unrotatedToWorld(local, pivot, theta);
      expect(back.x, closeTo(original.x, 1e-12));
      expect(back.y, closeTo(original.y, 1e-12));
    });

    test('identity at theta=0', () {
      final pivot = Vector2(5, 7);
      final p = Vector2(1, 2);
      expect(ClampHelpers.worldToUnrotated(p, pivot, 0.0).x, closeTo(1, 1e-12));
      expect(ClampHelpers.worldToUnrotated(p, pivot, 0.0).y, closeTo(2, 1e-12));
    });
  });

  group('calculateBoundingRect', () {
    test('equals rect when theta=0', () {
      final r = Box.fromLTWH(10, 20, 100, 50);
      final bounding = ClampHelpers.calculateBoundingRect(r);
      expect(bounding.left, closeTo(10, 1e-12));
      expect(bounding.top, closeTo(20, 1e-12));
      expect(bounding.right, closeTo(110, 1e-12));
      expect(bounding.bottom, closeTo(70, 1e-12));
    });

    test('100x100 rotated pi/4 has bounding ~141x141 centered at box center',
        () {
      final r = Box.fromLTWH(0, 0, 100, 100, rotation: math.pi / 4);
      final bounding = ClampHelpers.calculateBoundingRect(r);
      final expectedSide = 100 * math.sqrt(2);
      expect(bounding.width, closeTo(expectedSide, 1e-9));
      expect(bounding.height, closeTo(expectedSide, 1e-9));
      expect((bounding.left + bounding.right) / 2, closeTo(50, 1e-9));
      expect((bounding.top + bounding.bottom) / 2, closeTo(50, 1e-9));
    });

    test('rotation pi/2 swaps width/height', () {
      final r = Box.fromLTWH(0, 0, 200, 50, rotation: math.pi / 2);
      final bounding = ClampHelpers.calculateBoundingRect(r);
      expect(bounding.width, closeTo(50, 1e-9));
      expect(bounding.height, closeTo(200, 1e-9));
    });
  });
}
