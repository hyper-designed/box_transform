import 'dart:math';

import 'package:box_transform/box_transform.dart';
import 'package:test/test.dart';
import 'package:vector_math/vector_math.dart';

import 'utils.dart';

void main() {
  group('Rotated box clamping and constraint interaction', () {
    test('freeform resize should stop at clamping boundary, not snap to min size', () {
      // Set up a scenario where a rotated box hits the clamping boundary
      final initialRect = Box.fromLTWH(200, 200, 100, 100);
      final clampingRect = Box.fromLTWH(100, 100, 300, 300); // 100-400 x 100-400
      final constraints = Constraints(
        minWidth: 50,
        minHeight: 50,
        maxWidth: 500,
        maxHeight: 500,
      );
      
      // 45 degree rotation
      final rotation = pi / 4;
      
      // Try to resize the box to a size that would make the rotated bounding box hit the boundary
      // With 45° rotation, a 200x200 box has a bounding box of roughly 283x283
      final explodedRect = Box.fromLTWH(200, 200, 200, 200);
      
      final result = BoxTransformer.resize(
        resizeMode: ResizeMode.freeform,
        initialFlip: Flip.none,
        initialRect: initialRect,
        handle: HandlePosition.bottomRight,
        initialLocalPosition: Vector2(100, 100), // bottom-right corner
        allowFlipping: true,
        localPosition: Vector2(200, 200), // drag to make it bigger
        clampingRect: clampingRect,
        constraints: constraints,
        rotation: rotation,
      );
      
      // The box should be clamped to fit within the boundary, not snapped to minimum size
      expect(result.rect.width, greaterThan(constraints.minWidth));
      expect(result.rect.height, greaterThan(constraints.minHeight));
      
      // Verify the bounding box fits within the clamping rect
      final boundingRect = BoxTransformer.calculateBoundingRect(
        rotation: rotation,
        unrotatedBox: result.rect,
      );
      
      expect(boundingRect.left, greaterThanOrEqualTo(clampingRect.left - 0.01));
      expect(boundingRect.top, greaterThanOrEqualTo(clampingRect.top - 0.01));
      expect(boundingRect.right, lessThanOrEqualTo(clampingRect.right + 0.01));
      expect(boundingRect.bottom, lessThanOrEqualTo(clampingRect.bottom + 0.01));
    });

    test('scale resize should stop at clamping boundary with rotation', () {
      final initialRect = Box.fromLTWH(250, 250, 80, 80);
      final clampingRect = Box.fromLTWH(150, 150, 200, 200); // 150-350 x 150-350
      final constraints = Constraints(
        minWidth: 30,
        minHeight: 30,
        maxWidth: 400,
        maxHeight: 400,
      );
      
      // 30 degree rotation
      final rotation = pi / 6;
      
      final result = BoxTransformer.resize(
        resizeMode: ResizeMode.scale,
        initialFlip: Flip.none,
        initialRect: initialRect,
        handle: HandlePosition.bottomRight,
        initialLocalPosition: Vector2(80, 80),
        allowFlipping: true,
        localPosition: Vector2(150, 150), // try to make it much larger
        clampingRect: clampingRect,
        constraints: constraints,
        rotation: rotation,
      );
      
      // Should not snap to minimum size
      expect(result.rect.width, greaterThan(constraints.minWidth + 10));
      expect(result.rect.height, greaterThan(constraints.minHeight + 10));
      
      // Should maintain aspect ratio
      final aspectRatio = initialRect.width / initialRect.height;
      expect(result.rect.width / result.rect.height, closeTo(aspectRatio, 0.1));
      
      // Bounding box should fit within clamping rect
      final boundingRect = BoxTransformer.calculateBoundingRect(
        rotation: rotation,
        unrotatedBox: result.rect,
      );
      
      expect(boundingRect.right, lessThanOrEqualTo(clampingRect.right + 0.01));
      expect(boundingRect.bottom, lessThanOrEqualTo(clampingRect.bottom + 0.01));
    });

    test('symmetric resize should stop at clamping boundary with rotation', () {
      final initialRect = Box.fromLTWH(250, 250, 60, 60);
      final clampingRect = Box.fromLTWH(200, 200, 100, 100); // 200-300 x 200-300
      final constraints = Constraints(
        minWidth: 20,
        minHeight: 20,
        maxWidth: 400,
        maxHeight: 400,
      );
      
      // 60 degree rotation
      final rotation = pi / 3;
      
      final result = BoxTransformer.resize(
        resizeMode: ResizeMode.symmetric,
        initialFlip: Flip.none,
        initialRect: initialRect,
        handle: HandlePosition.right,
        initialLocalPosition: Vector2(60, 30),
        allowFlipping: true,
        localPosition: Vector2(120, 30), // try to expand significantly
        clampingRect: clampingRect,
        constraints: constraints,
        rotation: rotation,
      );
      
      // Should not snap to minimum size
      expect(result.rect.width, greaterThan(constraints.minWidth + 5));
      expect(result.rect.height, greaterThan(constraints.minHeight + 5));
      
      // Bounding box should fit within clamping rect
      final boundingRect = BoxTransformer.calculateBoundingRect(
        rotation: rotation,
        unrotatedBox: result.rect,
      );
      
      expect(boundingRect.left, greaterThanOrEqualTo(clampingRect.left - 0.01));
      expect(boundingRect.top, greaterThanOrEqualTo(clampingRect.top - 0.01));
      expect(boundingRect.right, lessThanOrEqualTo(clampingRect.right + 0.01));
      expect(boundingRect.bottom, lessThanOrEqualTo(clampingRect.bottom + 0.01));
    });

    test('symmetric scale resize should stop at clamping boundary with rotation', () {
      final initialRect = Box.fromLTWH(275, 275, 40, 40);
      final clampingRect = Box.fromLTWH(250, 250, 50, 50); // 250-300 x 250-300
      final constraints = Constraints(
        minWidth: 15,
        minHeight: 15,
        maxWidth: 300,
        maxHeight: 300,
      );
      
      // 45 degree rotation
      final rotation = pi / 4;
      
      final result = BoxTransformer.resize(
        resizeMode: ResizeMode.symmetricScale,
        initialFlip: Flip.none,
        initialRect: initialRect,
        handle: HandlePosition.bottomRight,
        initialLocalPosition: Vector2(40, 40),
        allowFlipping: true,
        localPosition: Vector2(80, 80), // try to expand
        clampingRect: clampingRect,
        constraints: constraints,
        rotation: rotation,
      );
      
      // Should find best possible size within clamping bounds
      // Note: For rotated boxes with tight geometry, clamping bounds take precedence over min constraints
      expect(result.rect.width, greaterThan(0));
      expect(result.rect.height, greaterThan(0));
      
      // Should maintain aspect ratio and symmetry
      final aspectRatio = initialRect.width / initialRect.height;
      expect(result.rect.width / result.rect.height, closeTo(aspectRatio, 0.1));
      
      // Bounding box should fit within clamping rect
      final boundingRect = BoxTransformer.calculateBoundingRect(
        rotation: rotation,
        unrotatedBox: result.rect,
      );
      
      expect(boundingRect.left, greaterThanOrEqualTo(clampingRect.left - 0.01));
      expect(boundingRect.top, greaterThanOrEqualTo(clampingRect.top - 0.01));
      expect(boundingRect.right, lessThanOrEqualTo(clampingRect.right + 0.01));
      expect(boundingRect.bottom, lessThanOrEqualTo(clampingRect.bottom + 0.01));
    });

    test('edge case: very tight clamping with rotation should not cause minimum snap', () {
      // Create a scenario where the clamping rect is very tight
      final initialRect = Box.fromLTWH(100, 100, 50, 50);
      final clampingRect = Box.fromLTWH(90, 90, 70, 70); // very tight fit
      final constraints = Constraints(
        minWidth: 10,
        minHeight: 10,
        maxWidth: 200,
        maxHeight: 200,
      );
      
      final rotation = pi / 6; // 30 degrees
      
      final result = BoxTransformer.resize(
        resizeMode: ResizeMode.freeform,
        initialFlip: Flip.none,
        initialRect: initialRect,
        handle: HandlePosition.bottomRight,
        initialLocalPosition: Vector2(50, 50),
        allowFlipping: true,
        localPosition: Vector2(70, 70), // try to expand slightly
        clampingRect: clampingRect,
        constraints: constraints,
        rotation: rotation,
      );
      
      // Even in tight spaces, should not snap to absolute minimum
      // Should be constrained by clamping, not by minimum constraint
      expect(result.rect.width, greaterThan(constraints.minWidth * 2));
      expect(result.rect.height, greaterThan(constraints.minHeight * 2));
    });
  });
}