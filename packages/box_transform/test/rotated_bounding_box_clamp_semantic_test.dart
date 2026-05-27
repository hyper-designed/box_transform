import 'dart:math' as math;

import 'package:box_transform/box_transform.dart';
import 'package:test/test.dart';
import 'package:vector_math/vector_math_64.dart';

// `BindingStrategy.boundingBox` must constrain the rendered axis-aligned
// bounding box of the rotated rect, NOT the unrotated stored rect's
// corners. For stretched rotated rects the unrotated rect can extend
// further than the rotated AABB on one axis (W·|cos θ| + H·|sin θ| can be
// less than W when H is much smaller than W, and vice versa); enforcing
// both makes the unrotated rect the binding constraint and steals slack
// the rendered footprint genuinely has.
//
// Reproduces the playground report: a slim/tall rotated box flush with
// the clamp's top edge could not move down even though the rotated AABB
// had ~30 px of slack from the clamp.

void main() {
  group('boundingBox: rendered AABB is the binding constraint', () {
    test(
      'stretched (100×500) rotated rect can move into rotated-AABB slack '
      'past the unrotated rect bound',
      () {
        // Geometry: 100×500 slim-tall rect at θ=π/4. Stored bounds are
        // flush with clamp.top and clamp.bottom; the rotated AABB has
        // ~38 px of slack on each side.
        final initial = Box.fromLTWH(450, 0, 100, 500, rotation: math.pi / 4);
        final clamp = Box.fromLTRB(0, 0, 1000, 500);
        // Pre-checks: rotated AABB has slack to clamp.top/bottom.
        final aabb = ClampHelpers.calculateBoundingRect(initial);
        expect(aabb.top, greaterThan(clamp.top + 30),
            reason: 'rotated AABB must have meaningful slack to clamp.top '
                '(setup invariant)');
        expect(aabb.bottom, lessThan(clamp.bottom - 30),
            reason: 'rotated AABB must have meaningful slack to clamp.bottom '
                '(setup invariant)');
        // The unrotated rect is flush with the clamp by construction.
        expect(initial.top, closeTo(clamp.top, 1e-9));
        expect(initial.bottom, closeTo(clamp.bottom, 1e-9));

        final result = BoxTransformer.move(
          initialRect: initial,
          initialLocalPosition: Vector2(500, 250),
          // Request 30 px down. Easily inside the AABB's vertical slack.
          localPosition: Vector2(500, 280),
          rotation: math.pi / 4,
          bindingStrategy: BindingStrategy.boundingBox,
          clampingRect: clamp,
        );

        expect(result.delta.y, closeTo(30, 1e-3),
            reason: 'boundingBox must let the rect move into the rotated '
                'AABB slack (this is the user-reported regression)');
        // And the rotated AABB after the move must stay inside the clamp.
        final movedAabb = ClampHelpers.calculateBoundingRect(result.rect);
        expect(movedAabb.top, greaterThanOrEqualTo(clamp.top - 1e-3));
        expect(movedAabb.bottom, lessThanOrEqualTo(clamp.bottom + 1e-3));
      },
    );

    test(
      'wide (500×100) rotated rect can move into rotated-AABB slack '
      'past the unrotated rect bound (x-axis variant)',
      () {
        // Mirror scenario, swapped axes: 500×100 wide-flat rect at θ=π/4.
        // Stored bounds flush with clamp.left/right; rotated AABB has
        // slack on the x-axis.
        final initial = Box.fromLTWH(0, 450, 500, 100, rotation: math.pi / 4);
        final clamp = Box.fromLTRB(0, 0, 500, 1000);
        final aabb = ClampHelpers.calculateBoundingRect(initial);
        expect(aabb.left, greaterThan(clamp.left + 30));
        expect(aabb.right, lessThan(clamp.right - 30));
        expect(initial.left, closeTo(clamp.left, 1e-9));
        expect(initial.right, closeTo(clamp.right, 1e-9));

        final result = BoxTransformer.move(
          initialRect: initial,
          initialLocalPosition: Vector2(250, 500),
          localPosition: Vector2(280, 500),
          rotation: math.pi / 4,
          bindingStrategy: BindingStrategy.boundingBox,
          clampingRect: clamp,
        );

        expect(result.delta.x, closeTo(30, 1e-3),
            reason: 'boundingBox must let the rect move into the rotated '
                'AABB slack on the x-axis');
        final movedAabb = ClampHelpers.calculateBoundingRect(result.rect);
        expect(movedAabb.left, greaterThanOrEqualTo(clamp.left - 1e-3));
        expect(movedAabb.right, lessThanOrEqualTo(clamp.right + 1e-3));
      },
    );

    test(
      'originalBox keeps its semantic: stretched rotated rect cannot move '
      'past the unrotated rect bound',
      () {
        // Same setup as the first test, but originalBox enforces the
        // unrotated rect. The rect IS flush with the clamp on the
        // unrotated bounds, so it cannot move at all on y.
        final initial = Box.fromLTWH(450, 0, 100, 500, rotation: math.pi / 4);
        final clamp = Box.fromLTRB(0, 0, 1000, 500);
        final result = BoxTransformer.move(
          initialRect: initial,
          initialLocalPosition: Vector2(500, 250),
          localPosition: Vector2(500, 280),
          rotation: math.pi / 4,
          bindingStrategy: BindingStrategy.originalBox,
          clampingRect: clamp,
        );
        expect(result.delta.y, closeTo(0, 1e-3),
            reason: 'originalBox must keep the unrotated rect inside the '
                'clamp; with rect flush to clamp.bottom no movement is '
                'allowed');
      },
    );
  });
}
