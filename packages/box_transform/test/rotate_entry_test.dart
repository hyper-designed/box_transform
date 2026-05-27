import 'dart:math' as math;

import 'package:box_transform/box_transform.dart';
import 'package:test/test.dart';
import 'package:vector_math/vector_math_64.dart';

void main() {
  group('BoxTransformer.rotate', () {
    test('drag pointer quarter-turn produces +pi/2 rotation', () {
      final initial = Box.fromLTWH(-50, -50, 100, 100);
      // Center = (0,0). Initial pointer at (100,0), drag to (0,100).
      // Angle from +X to +Y is +pi/2 in screen coords (y-down).
      final result = BoxTransformer.rotate(
        initialRect: initial,
        initialLocalPosition: Vector2(100, 0),
        localPosition: Vector2(0, 100),
        initialRotation: 0.0,
      );
      expect(result.rotation, closeTo(math.pi / 2, 1e-6));
    });

    test('initialRotation is preserved additively', () {
      final initial = Box.fromLTWH(-50, -50, 100, 100, rotation: 0.3);
      final result = BoxTransformer.rotate(
        initialRect: initial,
        initialLocalPosition: Vector2(100, 0),
        localPosition: Vector2(100, 0), // no delta
        initialRotation: 0.3,
      );
      expect(result.rotation, closeTo(0.3, 1e-6));
    });
  });
}
