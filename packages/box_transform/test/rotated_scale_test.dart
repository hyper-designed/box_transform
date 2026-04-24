import 'dart:math' as math;

import 'package:box_transform/box_transform.dart';
import 'package:test/test.dart';
import 'package:vector_math/vector_math_64.dart';

void main() {
  group('Scale resize with rotation', () {
    test('preserves aspect ratio under rotation', () {
      final initial = Box.fromLTWH(0, 0, 200, 100, rotation: math.pi / 6);
      final initialAspect = initial.width / initial.height;
      final initialCorner = _worldCorner(initial, HandlePosition.bottomRight);
      final result = BoxTransformer.resize(
        initialRect: initial,
        initialLocalPosition: initialCorner,
        localPosition: Vector2(400, 300),
        handle: HandlePosition.bottomRight,
        resizeMode: ResizeMode.scale,
        initialFlip: Flip.none,
        clampingRect: Box.fromLTRB(-500, -500, 500, 500),
        constraints: const Constraints(),
        allowFlipping: false,
        rotation: math.pi / 6,
      );
      expect(
          result.rect.width / result.rect.height, closeTo(initialAspect, 1e-4));
    });

    test(
        'clamps rotated corners within bounds while preserving aspect '
        '(boundingBox)', () {
      final initial = Box.fromLTWH(0, 0, 100, 100, rotation: math.pi / 4);
      final initialCorner = _worldCorner(initial, HandlePosition.bottomRight);
      final result = BoxTransformer.resize(
        initialRect: initial,
        initialLocalPosition: initialCorner,
        localPosition: Vector2(1000, 1000),
        handle: HandlePosition.bottomRight,
        resizeMode: ResizeMode.scale,
        initialFlip: Flip.none,
        clampingRect: Box.fromLTRB(-100, -100, 100, 100),
        constraints: const Constraints(),
        allowFlipping: false,
        rotation: math.pi / 4,
        bindingStrategy: BindingStrategy.boundingBox,
      );
      expect(result.rect.width, closeTo(result.rect.height, 1e-4));
      final corners = _allWorldCorners(result.rect);
      for (final c in corners) {
        expect(c.x, inInclusiveRange(-100 - 1e-4, 100 + 1e-4));
        expect(c.y, inInclusiveRange(-100 - 1e-4, 100 + 1e-4));
      }
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
