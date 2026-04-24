import 'dart:math' as math;

import 'package:box_transform/box_transform.dart';
import 'package:test/test.dart';
import 'package:vector_math/vector_math_64.dart';

/// Cross-strategy divergence tests for BoxTransformer.move at nonzero
/// rotation. Proves that `originalBox` and `boundingBox` produce materially
/// different translation results — the Phase 2 move() fix is active.
void main() {
  group('Divergence: move() at nonzero theta', () {
    test(
        'translation beyond rotated bounding is allowed in originalBox '
        'but blocked in boundingBox', () {
      // 100x100 box at pi/4 centered at (50, 50). Rotated bounding spans
      // ~(−20.71, −20.71, 120.71, 120.71). Clamp sized exactly to that
      // bounding so boundingBox has zero slack; originalBox sees the
      // unrotated rect (0, 0, 100, 100) which has 20.71px slack on the
      // right edge (120.71 − 100) before the unrotated-corner hits clamp.
      final initial = Box.fromLTWH(0, 0, 100, 100, rotation: math.pi / 4);
      final half = 100 * math.sqrt2 / 2;
      final clamp = Box.fromLTRB(50 - half, 50 - half, 50 + half, 50 + half);

      // User wants to translate rightward by 50px.
      final resB = BoxTransformer.move(
        initialRect: initial,
        initialLocalPosition: Vector2(0, 0),
        localPosition: Vector2(50, 0),
        clampingRect: clamp,
        rotation: math.pi / 4,
        bindingStrategy: BindingStrategy.boundingBox,
      );
      final resO = BoxTransformer.move(
        initialRect: initial,
        initialLocalPosition: Vector2(0, 0),
        localPosition: Vector2(50, 0),
        clampingRect: clamp,
        rotation: math.pi / 4,
        bindingStrategy: BindingStrategy.originalBox,
      );

      // boundingBox: rotated bounding already at clamp edge, no slack.
      expect(resB.delta.x, closeTo(0, 0.5),
          reason: 'boundingBox must block translation — saturated');
      // originalBox: unrotated rect (0,0,100,100) has ~20.71 slack before
      // the right unrotated edge (x=100) hits clamp.right (120.71).
      expect(resO.delta.x, greaterThan(10),
          reason: 'originalBox must allow at least some translation');
      // And the two deltas must differ measurably.
      expect((resO.delta.x - resB.delta.x).abs(), greaterThan(5),
          reason: 'originalBox and boundingBox must diverge on translation');
    });

    test('at theta=0 the two strategies produce identical translation', () {
      // Sanity: rotation=0 takes the non-rotated branch and strategy is
      // moot. Both modes must match.
      final initial = Box.fromLTWH(0, 0, 100, 100);
      final clamp = Box.fromLTRB(-100, -100, 200, 200);
      final resB = BoxTransformer.move(
        initialRect: initial,
        initialLocalPosition: Vector2(50, 50),
        localPosition: Vector2(150, 150),
        clampingRect: clamp,
        rotation: 0.0,
        bindingStrategy: BindingStrategy.boundingBox,
      );
      final resO = BoxTransformer.move(
        initialRect: initial,
        initialLocalPosition: Vector2(50, 50),
        localPosition: Vector2(150, 150),
        clampingRect: clamp,
        rotation: 0.0,
        bindingStrategy: BindingStrategy.originalBox,
      );
      expect(resO.rect.left, closeTo(resB.rect.left, 1e-9));
      expect(resO.rect.top, closeTo(resB.rect.top, 1e-9));
    });
  });
}
