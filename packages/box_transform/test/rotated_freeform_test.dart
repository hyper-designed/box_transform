import 'dart:math' as math;

import 'package:box_transform/box_transform.dart';
import 'package:test/test.dart';
import 'package:vector_math/vector_math_64.dart';

void main() {
  group('resize() accepts rotation and bindingStrategy parameters', () {
    test('theta=0 call with new params produces same result as old call', () {
      final initial = Box.fromLTWH(0, 0, 100, 100);
      final clamp = Box.fromLTRB(-500, -500, 500, 500);
      final oldResult = BoxTransformer.resize(
        initialRect: initial,
        initialLocalPosition: Vector2(100, 100),
        localPosition: Vector2(150, 120),
        handle: HandlePosition.bottomRight,
        resizeMode: ResizeMode.freeform,
        initialFlip: Flip.none,
        clampingRect: clamp,
        constraints: const Constraints.unconstrained(),
        allowFlipping: true,
      );
      final newResult = BoxTransformer.resize(
        initialRect: initial,
        initialLocalPosition: Vector2(100, 100),
        localPosition: Vector2(150, 120),
        handle: HandlePosition.bottomRight,
        resizeMode: ResizeMode.freeform,
        initialFlip: Flip.none,
        clampingRect: clamp,
        constraints: const Constraints.unconstrained(),
        allowFlipping: true,
        rotation: 0.0,
        bindingStrategy: BindingStrategy.originalBox,
      );
      expect(newResult.rect, equals(oldResult.rect));
      expect(newResult.flip, equals(oldResult.flip));
      expect(newResult.rotation, 0.0);
    });
  });

  group('Freeform resize with rotation', () {
    test('theta=pi/4 bottomRight drag stays within clamp rect (boundingBox)',
        () {
      final initial = Box.fromLTWH(0, 0, 100, 100, rotation: math.pi / 4);
      final initialCorner = _worldCorner(initial, HandlePosition.bottomRight);
      final result = BoxTransformer.resize(
        initialRect: initial,
        initialLocalPosition: initialCorner,
        localPosition: Vector2(300, 300),
        handle: HandlePosition.bottomRight,
        resizeMode: ResizeMode.freeform,
        initialFlip: Flip.none,
        clampingRect: Box.fromLTRB(-200, -200, 200, 200),
        constraints: const Constraints.unconstrained(),
        allowFlipping: false,
        rotation: math.pi / 4,
        bindingStrategy: BindingStrategy.boundingBox,
      );
      final corners = _allWorldCorners(result.rect);
      for (final c in corners) {
        expect(c.x, greaterThanOrEqualTo(-200 - 1e-4));
        expect(c.x, lessThanOrEqualTo(200 + 1e-4));
        expect(c.y, greaterThanOrEqualTo(-200 - 1e-4));
        expect(c.y, lessThanOrEqualTo(200 + 1e-4));
      }
      expect(result.rect.rotation, closeTo(math.pi / 4, 1e-12));
    });

    test('anchor (opposite corner) world position is preserved', () {
      final initial = Box.fromLTWH(0, 0, 100, 100, rotation: math.pi / 6);
      final initialAnchor = _worldCorner(initial, HandlePosition.topLeft);
      final initialCorner = _worldCorner(initial, HandlePosition.bottomRight);
      final result = BoxTransformer.resize(
        initialRect: initial,
        initialLocalPosition: initialCorner,
        localPosition: Vector2(50, 150),
        handle: HandlePosition.bottomRight,
        resizeMode: ResizeMode.freeform,
        initialFlip: Flip.none,
        clampingRect: Box.fromLTRB(-500, -500, 500, 500),
        constraints: const Constraints.unconstrained(),
        allowFlipping: false,
        rotation: math.pi / 6,
      );
      final anchorAfter = _worldCorner(result.rect, HandlePosition.topLeft);
      expect(anchorAfter.x, closeTo(initialAnchor.x, 1e-4));
      expect(anchorAfter.y, closeTo(initialAnchor.y, 1e-4));
    });

    test('minWidth respected under rotation', () {
      final initial = Box.fromLTWH(0, 0, 100, 100, rotation: math.pi / 4);
      final initialCorner = _worldCorner(initial, HandlePosition.bottomRight);
      final result = BoxTransformer.resize(
        initialRect: initial,
        initialLocalPosition: initialCorner,
        localPosition: Vector2(0, 0), // try to shrink past zero
        handle: HandlePosition.bottomRight,
        resizeMode: ResizeMode.freeform,
        initialFlip: Flip.none,
        clampingRect: Box.fromLTRB(-500, -500, 500, 500),
        constraints: const Constraints(minWidth: 30, minHeight: 30),
        allowFlipping: false,
        rotation: math.pi / 4,
      );
      expect(result.rect.width, greaterThanOrEqualTo(30 - 1e-4));
      expect(result.rect.height, greaterThanOrEqualTo(30 - 1e-4));
    });
  });
}

/// Test helper: world position of a specific corner of a rotated [box].
Vector2 _worldCorner(Box box, HandlePosition handle) {
  final cx = (box.left + box.right) / 2;
  final cy = (box.top + box.bottom) / 2;
  final center = Vector2(cx, cy);
  late final Vector2 unrotated;
  switch (handle) {
    case HandlePosition.topLeft:
      unrotated = Vector2(box.left, box.top);
    case HandlePosition.topRight:
      unrotated = Vector2(box.right, box.top);
    case HandlePosition.bottomRight:
      unrotated = Vector2(box.right, box.bottom);
    case HandlePosition.bottomLeft:
      unrotated = Vector2(box.left, box.bottom);
    default:
      throw UnsupportedError('handle $handle not supported');
  }
  return ClampHelpers.rotatePointAround(unrotated, center, box.rotation);
}

/// Test helper: all four world-space rotated corners of [box].
List<Vector2> _allWorldCorners(Box box) {
  return [
    HandlePosition.topLeft,
    HandlePosition.topRight,
    HandlePosition.bottomRight,
    HandlePosition.bottomLeft,
  ].map((h) => _worldCorner(box, h)).toList();
}
