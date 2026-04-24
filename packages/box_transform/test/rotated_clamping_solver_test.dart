import 'dart:math' as math;

import 'package:box_transform/box_transform.dart';
import 'package:test/test.dart';
import 'package:vector_math/vector_math_64.dart';

import 'lp_inspect.dart';

void main() {
  group('LinearInequality', () {
    test('evaluates aw + bh <= c correctly', () {
      final ineq = LinearInequality(a: 1, b: 2, c: 10);
      expect(ineq.evaluate(3, 2), 7); // 3 + 4 = 7
      expect(ineq.isSatisfied(3, 2), isTrue);
      expect(ineq.isSatisfied(5, 3), isFalse); // 11 > 10
    });
  });

  group('buildCornerInequalities (originalBox)', () {
    test('theta=0 with anchor topLeft at origin produces w <= 200 ineq', () {
      final ineqs = buildCornerInequalities(
        anchor: Vector2(0, 0),
        theta: 0.0,
        clampingRect: Box.fromLTRB(-50, -50, 200, 200),
        bindingStrategy: BindingStrategy.originalBox,
      );
      // Locate the w-only upper-bound inequality.
      final wUpper = ineqs
          .firstWhere((i) => i.a.abs() > 0 && i.b.abs() < 1e-12 && i.a > 0);
      expect(wUpper.c / wUpper.a, closeTo(200, 1e-9));
    });

    test('all inequalities satisfied when (w,h) fits clamp', () {
      final ineqs = buildCornerInequalities(
        anchor: Vector2(50, 50),
        theta: math.pi / 4,
        clampingRect: Box.fromLTRB(0, 0, 300, 300),
        bindingStrategy: BindingStrategy.originalBox,
      );
      for (final i in ineqs) {
        expect(i.isSatisfied(10, 10), isTrue,
            reason: 'Inequality $i violated at (10,10)');
      }
    });
  });

  group('projectOntoFeasibleRegion', () {
    test('returns target unchanged when inside feasible region', () {
      final ineqs = buildCornerInequalities(
        anchor: Vector2(0, 0),
        theta: 0.0,
        clampingRect: Box.fromLTRB(-10, -10, 500, 500),
        bindingStrategy: BindingStrategy.originalBox,
      );
      final result = projectOntoFeasibleRegion(
        ineqs,
        targetW: 100,
        targetH: 50,
        minW: 1,
        minH: 1,
        maxW: 1e9,
        maxH: 1e9,
      );
      expect(result.w, closeTo(100, 1e-9));
      expect(result.h, closeTo(50, 1e-9));
    });

    test('clamps w when upper bound binds (theta=0)', () {
      final ineqs = buildCornerInequalities(
        anchor: Vector2(0, 0),
        theta: 0.0,
        clampingRect: Box.fromLTRB(-10, -10, 200, 500),
        bindingStrategy: BindingStrategy.originalBox,
      );
      final result = projectOntoFeasibleRegion(
        ineqs,
        targetW: 500,
        targetH: 50,
        minW: 1,
        minH: 1,
        maxW: 1e9,
        maxH: 1e9,
      );
      expect(result.w, closeTo(200, 1e-9));
      expect(result.h, closeTo(50, 1e-9));
    });

    test('min constraint prevents shrinking past minimum', () {
      final ineqs = buildCornerInequalities(
        anchor: Vector2(0, 0),
        theta: 0.0,
        clampingRect: Box.fromLTRB(-10, -10, 500, 500),
        bindingStrategy: BindingStrategy.originalBox,
      );
      final result = projectOntoFeasibleRegion(
        ineqs,
        targetW: 5,
        targetH: 5,
        minW: 20,
        minH: 20,
        maxW: 1e9,
        maxH: 1e9,
      );
      expect(result.w, closeTo(20, 1e-9));
      expect(result.h, closeTo(20, 1e-9));
    });

    test('coupled inequality at theta=pi/4 stays feasible', () {
      final ineqs = buildCornerInequalities(
        anchor: Vector2(0, 0),
        theta: math.pi / 4,
        clampingRect: Box.fromLTRB(-200, -200, 141.42, 500),
        bindingStrategy: BindingStrategy.originalBox,
      );
      final result = projectOntoFeasibleRegion(
        ineqs,
        targetW: 500,
        targetH: 50,
        minW: 1,
        minH: 1,
        maxW: 1e9,
        maxH: 1e9,
      );
      for (final i in ineqs) {
        expect(i.isSatisfied(result.w, result.h), isTrue,
            reason: 'Inequality violated: $i at (${result.w}, ${result.h})');
      }
    });
  });

  group('buildCornerInequalities (boundingBox)', () {
    test(
        'boundingBox strategy produces feasible ineqs when small box fits '
        'clamp with room around the anchor', () {
      // Anchor well inside clamp so rotated corners can extend in any
      // direction without violating the clamp.
      final ineqs = buildCornerInequalities(
        anchor: Vector2(50, 50),
        theta: math.pi / 4,
        clampingRect: Box.fromLTRB(-200, -200, 200, 200),
        bindingStrategy: BindingStrategy.boundingBox,
      );
      for (final i in ineqs) {
        expect(i.isSatisfied(10, 10), isTrue,
            reason: 'Small box should be feasible at pi/4: $i');
      }
    });

    test(
        'boundingBox clamping marks oversized rotated boxes infeasible '
        '(corner ineqs suffice since they already enforce AABB extent)', () {
      final ineqs = buildCornerInequalities(
        anchor: Vector2(0, 0),
        theta: math.pi / 4,
        clampingRect: Box.fromLTRB(-100, -100, 100, 100),
        bindingStrategy: BindingStrategy.boundingBox,
      );
      // (200, 200) at pi/4 has corners at roughly ±141, well outside clamp.
      final someViolated = ineqs.any((i) => !i.isSatisfied(200, 200));
      expect(someViolated, isTrue);
    });
  });

  group('originalBox vs boundingBox coefficients diverge at nonzero theta', () {
    // Verifies the Phase 2 semantic fix: the two strategies produce
    // different linear-coefficient tables for corner-anchored inequalities
    // whenever theta != 0. (They coincide at theta = 0 because cos=1, sin=0
    // collapses the unrotated-corner formula onto the rotated-corner one.)
    test(
      'corner-anchored: at theta != 0 the strategies emit different '
      'inequality sets',
      () {
        // boundingBox enforces the rotated quad's four corners (the
        // rendered footprint stays in the clamp). originalBox enforces
        // the unrotated rect's four axis-aligned corners (the logical
        // stored rect stays in the clamp; rotated corners may extend
        // outside). At theta != 0 these are different geometries with
        // different coefficients; at theta == 0 they collapse onto the
        // same axis-aligned constraints.
        final common = {
          'anchor': Vector2(0, 0),
          'theta': math.pi / 6,
          'clampingRect': Box.fromLTRB(-100, -100, 200, 200),
        };
        final original = buildCornerInequalities(
          anchor: common['anchor'] as Vector2,
          theta: common['theta'] as double,
          clampingRect: common['clampingRect'] as Box,
          bindingStrategy: BindingStrategy.originalBox,
        );
        final bounding = buildCornerInequalities(
          anchor: common['anchor'] as Vector2,
          theta: common['theta'] as double,
          clampingRect: common['clampingRect'] as Box,
          bindingStrategy: BindingStrategy.boundingBox,
        );
        expect(original, isNotEmpty);
        expect(bounding, isNotEmpty);
        bool same(LinearInequality a, LinearInequality b) =>
            (a.a - b.a).abs() < 1e-9 &&
            (a.b - b.b).abs() < 1e-9 &&
            (a.c - b.c).abs() < 1e-9;
        // The unrotated corners (originalBox) and the rotated quad
        // corners (boundingBox) at theta=π/6 are geometrically distinct
        // axes — every row in one must NOT appear in the other.
        for (final o in original) {
          expect(bounding.any((b) => same(o, b)), isFalse,
              reason: 'originalBox row $o must not appear in boundingBox '
                  'at theta != 0; the strategies enforce different '
                  'corners.');
        }
      },
    );

    test('corner-anchored: at theta=0 both strategies coincide', () {
      // Sanity: theta=0 collapses both formulas to axis-aligned corners,
      // so the projection solutions for any feasible target must match.
      final ineqsO = buildCornerInequalities(
        anchor: Vector2(0, 0),
        theta: 0.0,
        clampingRect: Box.fromLTRB(-10, -10, 200, 200),
        bindingStrategy: BindingStrategy.originalBox,
      );
      final ineqsB = buildCornerInequalities(
        anchor: Vector2(0, 0),
        theta: 0.0,
        clampingRect: Box.fromLTRB(-10, -10, 200, 200),
        bindingStrategy: BindingStrategy.boundingBox,
      );
      final resO = projectOntoFeasibleRegion(
        ineqsO,
        targetW: 100,
        targetH: 50,
        minW: 1,
        minH: 1,
        maxW: 1e9,
        maxH: 1e9,
      );
      final resB = projectOntoFeasibleRegion(
        ineqsB,
        targetW: 100,
        targetH: 50,
        minW: 1,
        minH: 1,
        maxW: 1e9,
        maxH: 1e9,
      );
      expect(resO.w, closeTo(resB.w, 1e-9));
      expect(resO.h, closeTo(resB.h, 1e-9));
    });

    test('center-anchored: originalBox at nonzero theta is angle-independent',
        () {
      // originalBox center-anchored coefficients must equal theta=0 case.
      final ineqsRotated = buildCenterInequalities(
        center: Vector2(0, 0),
        theta: math.pi / 3,
        clampingRect: Box.fromLTRB(-50, -50, 50, 50),
        bindingStrategy: BindingStrategy.originalBox,
      );
      final ineqsZero = buildCenterInequalities(
        center: Vector2(0, 0),
        theta: 0.0,
        clampingRect: Box.fromLTRB(-50, -50, 50, 50),
        bindingStrategy: BindingStrategy.originalBox,
      );
      expect(ineqsRotated.length, ineqsZero.length);
      for (int i = 0; i < ineqsRotated.length; i++) {
        expect(ineqsRotated[i].a, closeTo(ineqsZero[i].a, 1e-9));
        expect(ineqsRotated[i].b, closeTo(ineqsZero[i].b, 1e-9));
        expect(ineqsRotated[i].c, closeTo(ineqsZero[i].c, 1e-9));
      }
    });
  });
}
