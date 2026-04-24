// Tests for rotation that respects the clamping rect.
//
// Bug: BoxTransformer.rotate() does not take a clampingRect, so the rotated
// AABB can extend beyond the clamp. The user's symptom: rotating a box
// flush against a clamp boundary leaks the rendered footprint outside, and
// the next move() call snaps it back in. The fix is to make rotation aware
// of the clamp via slide-then-freeze:
//
//   1. If the rotated rect can be translated such that all relevant corners
//      fit in the clamp (per bindingStrategy), slide to the closest such
//      position. Rotation is accepted, `feasible` is true.
//   2. If no translation can satisfy the clamp at the desired rotation,
//      reject the rotation entirely: return `rotation == initialRotation`,
//      `rect == initialRect`, `feasible == false`. The controller skips
//      its state update in this case, freezing rotation at the cap.

import 'dart:math' as math;

import 'package:box_transform/box_transform.dart';
import 'package:test/test.dart';
import 'package:vector_math/vector_math_64.dart';

void main() {
  group('BoxTransformer.rotate respects clampingRect', () {
    test('slides box into clamp when rotation has slack room', () {
      // 100×100 box flush against the top-left corner of a 200×200 clamp.
      // Rotating by π/12 inflates the AABB beyond the box, poking out by
      // ~11 px on each axis. The box must slide into the clamp.
      final initial = Box.fromLTWH(0, 0, 100, 100);
      final clamp = Box.fromLTRB(0, 0, 200, 200);
      const theta = math.pi / 12;
      final center = Vector2(50, 50);
      // Pointer moves from east of center (angle 0) to angle +theta.
      final initialPointer = Vector2(center.x + 50, center.y);
      final targetPointer = Vector2(
        center.x + 50 * math.cos(theta),
        center.y + 50 * math.sin(theta),
      );

      final result = BoxTransformer.rotate(
        initialRect: initial,
        initialLocalPosition: initialPointer,
        localPosition: targetPointer,
        initialRotation: 0.0,
        clampingRect: clamp,
        bindingStrategy: BindingStrategy.boundingBox,
      );

      expect(
        result.feasible,
        isTrue,
        reason: 'There is room to slide the box into the clamp.',
      );
      expect(result.rotation, closeTo(theta, 1e-9));
      // The rotated AABB must fit entirely inside the clamp.
      final aabb = ClampHelpers.calculateBoundingRect(result.rect);
      expect(aabb.left, greaterThanOrEqualTo(clamp.left - 1e-6));
      expect(aabb.top, greaterThanOrEqualTo(clamp.top - 1e-6));
      expect(aabb.right, lessThanOrEqualTo(clamp.right + 1e-6));
      expect(aabb.bottom, lessThanOrEqualTo(clamp.bottom + 1e-6));
    });

    test('rejects rotation when clamp is too tight to fit any translation', () {
      // 100×100 box exactly filling a 100×100 clamp — at θ=π/4 the rotated
      // AABB needs ~141×141, which cannot fit even with translation.
      final initial = Box.fromLTWH(0, 0, 100, 100);
      final clamp = Box.fromLTRB(0, 0, 100, 100);
      const theta = math.pi / 4;
      final center = Vector2(50, 50);
      final initialPointer = Vector2(center.x + 50, center.y);
      final targetPointer = Vector2(
        center.x + 50 * math.cos(theta),
        center.y + 50 * math.sin(theta),
      );

      final result = BoxTransformer.rotate(
        initialRect: initial,
        initialLocalPosition: initialPointer,
        localPosition: targetPointer,
        initialRotation: 0.0,
        clampingRect: clamp,
        bindingStrategy: BindingStrategy.boundingBox,
      );

      expect(result.feasible, isFalse);
      expect(result.rotation, equals(0.0),
          reason: 'Rejected rotation must report initialRotation.');
      expect(result.rect, equals(initial),
          reason: 'Rejected rotation must leave rect unchanged.');
    });

    test('rejected rotation reports the attempted delta, not zero', () {
      // R3: delta on infeasible should reflect the user's gesture motion
      // so consumers (telemetry, UI) can read it without first checking
      // `feasible`. Mirrors how `move()` reports clamped delta.
      final initial = Box.fromLTWH(0, 0, 100, 100);
      final clamp = Box.fromLTRB(0, 0, 100, 100); // tight
      const theta = math.pi / 4;
      final center = Vector2(50, 50);
      final initialPointer = Vector2(center.x + 50, center.y);
      final targetPointer = Vector2(
        center.x + 50 * math.cos(theta),
        center.y + 50 * math.sin(theta),
      );

      final result = BoxTransformer.rotate(
        initialRect: initial,
        initialLocalPosition: initialPointer,
        localPosition: targetPointer,
        initialRotation: 0.0,
        clampingRect: clamp,
        bindingStrategy: BindingStrategy.boundingBox,
      );

      expect(result.feasible, isFalse);
      final expected = targetPointer - initialPointer;
      expect(result.delta.x, closeTo(expected.x, 1e-9));
      expect(result.delta.y, closeTo(expected.y, 1e-9));
    });

    test(
      'originalBox keeps unrotated rect inside clamp; rotated corners may '
      'extend outside',
      () {
        // R4: originalBox lets the rotated quad poke out as long as the
        // unrotated rect stays in clamp. With a 100×100 box exactly filling
        // a 100×100 clamp, originalBox should *accept* π/4 rotation (the
        // unrotated corners are still at clamp corners) but the rotated
        // AABB extends beyond — that's by design.
        final initial = Box.fromLTWH(0, 0, 100, 100);
        final clamp = Box.fromLTRB(0, 0, 100, 100);
        const theta = math.pi / 4;
        final center = Vector2(50, 50);
        final initialPointer = Vector2(center.x + 50, center.y);
        final targetPointer = Vector2(
          center.x + 50 * math.cos(theta),
          center.y + 50 * math.sin(theta),
        );

        final result = BoxTransformer.rotate(
          initialRect: initial,
          initialLocalPosition: initialPointer,
          localPosition: targetPointer,
          initialRotation: 0.0,
          clampingRect: clamp,
          bindingStrategy: BindingStrategy.originalBox,
        );

        expect(result.feasible, isTrue);
        expect(result.rotation, closeTo(theta, 1e-9));
        // Rotated AABB at π/4 needs ~141×141 — must extend beyond the clamp.
        final aabb = ClampHelpers.calculateBoundingRect(result.rect);
        expect(aabb.width, greaterThan(clamp.width + 1.0));
      },
    );

    test('negative rotation is symmetric to positive', () {
      // R5: rotation cap should kick in at the same magnitude regardless
      // of sign. Use a small negative rotation that fits with sliding.
      final initial = Box.fromLTWH(0, 0, 100, 100);
      final clamp = Box.fromLTRB(0, 0, 200, 200);
      const theta = -math.pi / 12;
      final center = Vector2(50, 50);
      final initialPointer = Vector2(center.x + 50, center.y);
      final targetPointer = Vector2(
        center.x + 50 * math.cos(theta),
        center.y + 50 * math.sin(theta),
      );

      final result = BoxTransformer.rotate(
        initialRect: initial,
        initialLocalPosition: initialPointer,
        localPosition: targetPointer,
        initialRotation: 0.0,
        clampingRect: clamp,
        bindingStrategy: BindingStrategy.boundingBox,
      );

      expect(result.feasible, isTrue);
      expect(result.rotation, closeTo(theta, 1e-9));
      final aabb = ClampHelpers.calculateBoundingRect(result.rect);
      expect(aabb.left, greaterThanOrEqualTo(clamp.left - 1e-6));
      expect(aabb.top, greaterThanOrEqualTo(clamp.top - 1e-6));
      expect(aabb.right, lessThanOrEqualTo(clamp.right + 1e-6));
      expect(aabb.bottom, lessThanOrEqualTo(clamp.bottom + 1e-6));
    });

    test('default behavior (no clampingRect) is unchanged', () {
      // Pre-fix call sites that omit clampingRect/bindingStrategy must see
      // the same rotation/rect they used to get.
      final initial = Box.fromLTWH(0, 0, 100, 100);
      const theta = math.pi / 6;
      final center = Vector2(50, 50);
      final initialPointer = Vector2(center.x + 50, center.y);
      final targetPointer = Vector2(
        center.x + 50 * math.cos(theta),
        center.y + 50 * math.sin(theta),
      );

      final result = BoxTransformer.rotate(
        initialRect: initial,
        initialLocalPosition: initialPointer,
        localPosition: targetPointer,
        initialRotation: 0.0,
      );

      expect(result.feasible, isTrue);
      expect(result.rotation, closeTo(theta, 1e-9));
      // Position unchanged (Box.largest leaves tx/ty interval unconstrained,
      // so 0 is feasible and the slide is a no-op).
      expect(result.rect.left, closeTo(initial.left, 1e-9));
      expect(result.rect.top, closeTo(initial.top, 1e-9));
    });
  });
}
