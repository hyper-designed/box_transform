import 'dart:math' as math;

import 'package:box_transform/box_transform.dart';
import 'package:test/test.dart';
import 'package:vector_math/vector_math_64.dart';

import 'lp_inspect.dart';

/// Cross-strategy divergence tests. These prove that `BindingStrategy.
/// originalBox` and `BindingStrategy.boundingBox` produce materially
/// different resize results at non-zero rotation — i.e. Phase 2's semantic
/// fix is active. Each test picks a geometry where the two modes MUST
/// disagree and asserts the specific direction of the difference.
void main() {
  group('Divergence: corner-anchored feasibility region at pi/6', () {
    test('projections diverge for a tight clamp and nonzero theta', () {
      // Solver-level proof: build corner ineqs under each strategy, project
      // the same target onto both feasible regions, assert different (w, h).
      // Geometry: anchor at origin, theta = pi/6, clamp = asymmetric rect
      // that binds differently for rotated vs unrotated corners.
      const theta = math.pi / 6;
      final anchor = Vector2(0, 0);
      final clamp = Box.fromLTRB(-50, -50, 150, 150);

      final ineqO = buildCornerInequalities(
        anchor: anchor,
        theta: theta,
        clampingRect: clamp,
        bindingStrategy: BindingStrategy.originalBox,
      );
      final ineqB = buildCornerInequalities(
        anchor: anchor,
        theta: theta,
        clampingRect: clamp,
        bindingStrategy: BindingStrategy.boundingBox,
      );

      final resO = projectOntoFeasibleRegion(
        ineqO,
        targetW: 300,
        targetH: 100,
        minW: 1,
        minH: 1,
        maxW: 1e9,
        maxH: 1e9,
      );
      final resB = projectOntoFeasibleRegion(
        ineqB,
        targetW: 300,
        targetH: 100,
        minW: 1,
        minH: 1,
        maxW: 1e9,
        maxH: 1e9,
      );

      // Both strategies must produce feasible (w, h) under their own ineqs.
      for (final i in ineqO) {
        expect(i.isSatisfied(resO.w, resO.h), isTrue,
            reason: 'originalBox projection violates $i');
      }
      for (final i in ineqB) {
        expect(i.isSatisfied(resB.w, resB.h), isTrue,
            reason: 'boundingBox projection violates $i');
      }
      // The two projections must differ measurably. If the coefficient
      // tables were identical (pre-fix state) these would match exactly.
      final dw = (resO.w - resB.w).abs();
      final dh = (resO.h - resB.h).abs();
      expect(dw + dh, greaterThan(1.0),
          reason: 'projections should diverge when strategies differ; '
              'got original=(${resO.w}, ${resO.h}) '
              'bounding=(${resB.w}, ${resB.h})');
    });
  });

  group('Divergence: center-anchored feasibility region at pi/6', () {
    test('projections diverge for symmetric geometry at nonzero theta', () {
      // Analogous to the corner-anchored case, but using the center-anchored
      // builder. Same target, same clamp, different bindingStrategy.
      const theta = math.pi / 6;
      final center = Vector2(0, 0);
      final clamp = Box.fromLTRB(-80, -80, 80, 80);

      final ineqO = buildCenterInequalities(
        center: center,
        theta: theta,
        clampingRect: clamp,
        bindingStrategy: BindingStrategy.originalBox,
      );
      final ineqB = buildCenterInequalities(
        center: center,
        theta: theta,
        clampingRect: clamp,
        bindingStrategy: BindingStrategy.boundingBox,
      );

      final resO = projectOntoFeasibleRegion(
        ineqO,
        targetW: 200,
        targetH: 80,
        minW: 1,
        minH: 1,
        maxW: 1e9,
        maxH: 1e9,
      );
      final resB = projectOntoFeasibleRegion(
        ineqB,
        targetW: 200,
        targetH: 80,
        minW: 1,
        minH: 1,
        maxW: 1e9,
        maxH: 1e9,
      );

      for (final i in ineqO) {
        expect(i.isSatisfied(resO.w, resO.h), isTrue,
            reason: 'originalBox projection violates $i');
      }
      for (final i in ineqB) {
        expect(i.isSatisfied(resB.w, resB.h), isTrue,
            reason: 'boundingBox projection violates $i');
      }
      final dw = (resO.w - resB.w).abs();
      final dh = (resO.h - resB.h).abs();
      expect(dw + dh, greaterThan(1.0),
          reason: 'center-anchored projections should diverge; '
              'got original=(${resO.w}, ${resO.h}) '
              'bounding=(${resB.w}, ${resB.h})');
    });
  });

  group('Divergence: scale-aspect resize at pi/4', () {
    test('originalBox allows scale to grow past the boundingBox cap', () {
      // Scale mode preserves aspect — exercises the scalable engine's
      // `h = k*w` reduction and sanity-check that Phase 2 ripples through
      // the aspect-preserving path too.
      final initial = Box.fromLTWH(0, 0, 100, 100, rotation: math.pi / 4);
      final half = 100 * math.sqrt2 / 2;
      final clamp = Box.fromLTRB(50 - half, 50 - half, 50 + half, 50 + half);
      final initialCorner = _worldCorner(initial, HandlePosition.bottomRight);

      final resO = BoxTransformer.resize(
        initialRect: initial,
        initialLocalPosition: initialCorner,
        localPosition: Vector2(500, 500),
        handle: HandlePosition.bottomRight,
        resizeMode: ResizeMode.scale,
        initialFlip: Flip.none,
        clampingRect: clamp,
        constraints: const Constraints.unconstrained(),
        allowFlipping: false,
        rotation: math.pi / 4,
        bindingStrategy: BindingStrategy.originalBox,
      );
      final resB = BoxTransformer.resize(
        initialRect: initial,
        initialLocalPosition: initialCorner,
        localPosition: Vector2(500, 500),
        handle: HandlePosition.bottomRight,
        resizeMode: ResizeMode.scale,
        initialFlip: Flip.none,
        clampingRect: clamp,
        constraints: const Constraints.unconstrained(),
        allowFlipping: false,
        rotation: math.pi / 4,
        bindingStrategy: BindingStrategy.boundingBox,
      );

      // Aspect ratio preserved in both.
      expect(resO.rect.width, closeTo(resO.rect.height, 1e-4));
      expect(resB.rect.width, closeTo(resB.rect.height, 1e-4));
      // Divergence.
      expect(resB.rect.width, closeTo(100, 1.0));
      expect(resO.rect.width, greaterThan(resB.rect.width + 5.0));
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
