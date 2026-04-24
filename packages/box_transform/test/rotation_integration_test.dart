import 'dart:math' as math;

import 'package:box_transform/box_transform.dart';
import 'package:test/test.dart';
import 'package:vector_math/vector_math_64.dart';

void main() {
  const theta = math.pi / 4;

  group('Figma-parity behaviors at rotation=pi/4', () {
    test('1. Aspect-ratio lock (ResizeMode.scale) preserves aspect', () {
      final initial = Box.fromLTWH(0, 0, 200, 100, rotation: theta);
      final initialCorner = _worldCorner(initial, HandlePosition.bottomRight);
      final result = BoxTransformer.resize(
        initialRect: initial,
        initialLocalPosition: initialCorner,
        localPosition: Vector2(200, 200),
        handle: HandlePosition.bottomRight,
        resizeMode: ResizeMode.scale,
        initialFlip: Flip.none,
        clampingRect: Box.fromLTRB(-500, -500, 500, 500),
        constraints: const Constraints(),
        allowFlipping: false,
        rotation: theta,
      );
      expect(result.rect.width / result.rect.height, closeTo(2.0, 1e-4));
    });

    test('2. Symmetric resize grows from center', () {
      final initial = Box.fromLTWH(0, 0, 100, 100, rotation: theta);
      final initialCorner = _worldCorner(initial, HandlePosition.bottomRight);
      final result = BoxTransformer.resize(
        initialRect: initial,
        initialLocalPosition: initialCorner,
        localPosition: Vector2(120, 120),
        handle: HandlePosition.bottomRight,
        resizeMode: ResizeMode.symmetric,
        initialFlip: Flip.none,
        clampingRect: Box.fromLTRB(-500, -500, 500, 500),
        constraints: const Constraints(),
        allowFlipping: false,
        rotation: theta,
      );
      final cx = (result.rect.left + result.rect.right) / 2;
      final cy = (result.rect.top + result.rect.bottom) / 2;
      expect(cx, closeTo(50, 1e-4));
      expect(cy, closeTo(50, 1e-4));
    });

    test('3. Symmetric-scale combines both', () {
      final initial = Box.fromLTWH(0, 0, 100, 50, rotation: theta);
      final initialCorner = _worldCorner(initial, HandlePosition.bottomRight);
      final result = BoxTransformer.resize(
        initialRect: initial,
        initialLocalPosition: initialCorner,
        localPosition: Vector2(150, 75),
        handle: HandlePosition.bottomRight,
        resizeMode: ResizeMode.symmetricScale,
        initialFlip: Flip.none,
        clampingRect: Box.fromLTRB(-500, -500, 500, 500),
        constraints: const Constraints(),
        allowFlipping: false,
        rotation: theta,
      );
      expect(result.rect.width / result.rect.height, closeTo(2.0, 1e-4));
      final cx = (result.rect.left + result.rect.right) / 2;
      expect(cx, closeTo(50, 1e-4));
    });

    test('4. clamp rect constrains the rotated rect (all four corners in)', () {
      final initial = Box.fromLTWH(0, 0, 50, 50, rotation: theta);
      final clamp = Box.fromLTRB(-100, -100, 100, 100);
      final initialCorner = _worldCorner(initial, HandlePosition.bottomRight);
      final result = BoxTransformer.resize(
        initialRect: initial,
        initialLocalPosition: initialCorner,
        localPosition: Vector2(1000, 1000),
        handle: HandlePosition.bottomRight,
        resizeMode: ResizeMode.freeform,
        initialFlip: Flip.none,
        clampingRect: clamp,
        constraints: const Constraints(),
        allowFlipping: false,
        rotation: theta,
        bindingStrategy: BindingStrategy.boundingBox,
      );
      final corners = _allWorldCorners(result.rect);
      for (final c in corners) {
        expect(c.x, inInclusiveRange(-100 - 1e-4, 100 + 1e-4));
        expect(c.y, inInclusiveRange(-100 - 1e-4, 100 + 1e-4));
      }
    });

    test('5. min/max constraints honored under rotation', () {
      final initial = Box.fromLTWH(0, 0, 100, 100, rotation: theta);
      final initialCorner = _worldCorner(initial, HandlePosition.bottomRight);
      final result = BoxTransformer.resize(
        initialRect: initial,
        initialLocalPosition: initialCorner,
        localPosition: Vector2(0, 0),
        handle: HandlePosition.bottomRight,
        resizeMode: ResizeMode.freeform,
        initialFlip: Flip.none,
        clampingRect: Box.fromLTRB(-500, -500, 500, 500),
        constraints: const Constraints(
            minWidth: 20, minHeight: 20, maxWidth: 200, maxHeight: 200),
        allowFlipping: false,
        rotation: theta,
      );
      expect(result.rect.width, greaterThanOrEqualTo(20 - 1e-4));
      expect(result.rect.height, greaterThanOrEqualTo(20 - 1e-4));
    });

    test('6. BindingStrategy.boundingBox constrains AABB extent', () {
      final initial = Box.fromLTWH(0, 0, 50, 50, rotation: theta);
      final clamp = Box.fromLTRB(-70.71, -70.71, 70.71, 70.71);
      final initialCorner = _worldCorner(initial, HandlePosition.bottomRight);
      final result = BoxTransformer.resize(
        initialRect: initial,
        initialLocalPosition: initialCorner,
        localPosition: Vector2(1000, 1000),
        handle: HandlePosition.bottomRight,
        resizeMode: ResizeMode.freeform,
        initialFlip: Flip.none,
        clampingRect: clamp,
        constraints: const Constraints(),
        allowFlipping: false,
        rotation: theta,
        bindingStrategy: BindingStrategy.boundingBox,
      );
      expect(result.boundingRect.left, greaterThanOrEqualTo(clamp.left - 1e-4));
      expect(result.boundingRect.right, lessThanOrEqualTo(clamp.right + 1e-4));
      expect(result.boundingRect.top, greaterThanOrEqualTo(clamp.top - 1e-4));
      expect(
          result.boundingRect.bottom, lessThanOrEqualTo(clamp.bottom + 1e-4));
    });
  });
}

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

List<Vector2> _allWorldCorners(Box box) {
  return [
    HandlePosition.topLeft,
    HandlePosition.topRight,
    HandlePosition.bottomRight,
    HandlePosition.bottomLeft,
  ].map((h) => _worldCorner(box, h)).toList();
}
