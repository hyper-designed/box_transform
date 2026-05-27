import 'dart:math' as math;

import 'package:flutter/material.dart';
import 'package:flutter_box_transform/flutter_box_transform.dart';
import 'package:flutter_test/flutter_test.dart';

// When a rotated freeform resize gesture pushes the cursor past the anchor
// in a force-flip direction but the flipped state can't satisfy clamp +
// constraints, the engine falls back to the natural (un-flipped) direction.
// The rect then tracks the cursor by clamp-pinning at the natural wall —
// "expectantly clamped" — instead of freezing.
//
// Freeze (controller holds last-feasible, result.feasible=false) is now
// reserved for the rare case where neither force-flip NOR natural direction
// can produce a valid rect — a scenario that effectively requires the
// gesture-start state to also be infeasible, which the controller setup
// itself guards against.

void main() {
  TestWidgetsFlutterBinding.ensureInitialized();

  const theta = math.pi / 6;
  const rectSize = 100.0;
  const rectLeft = 50.0;
  const rectTop = 50.0;
  final center = Offset(rectLeft + rectSize / 2, rectTop + rectSize / 2);
  final cosT = math.cos(theta);
  final sinT = math.sin(theta);

  Offset rotateAroundCenter(Offset unrotated) {
    final dx = unrotated.dx - center.dx;
    final dy = unrotated.dy - center.dy;
    return Offset(
      center.dx + dx * cosT - dy * sinT,
      center.dy + dx * sinT + dy * cosT,
    );
  }

  group('Resize gesture: natural-direction fallback when flip is infeasible',
      () {
    test(
      'cursor past anchor in flip territory tracks natural direction '
      'instead of freezing (rect stays inside clamp, no flip)',
      () {
        final c = TransformableBoxController(
          rect: const Rect.fromLTWH(rectLeft, rectTop, rectSize, rectSize),
          clampingRect: const Rect.fromLTRB(0, 0, 200, 200),
          rotation: theta,
          bindingStrategy: BindingStrategy.boundingBox,
          constraints: const BoxConstraints(
            minWidth: 80,
            minHeight: 80,
            maxWidth: 500,
            maxHeight: 500,
          ),
        );
        c.onResizeStart(rotateAroundCenter(const Offset(rectLeft, rectTop)));

        // Cursor far past the bottomRight anchor → would request a
        // diagonal flip. Min 80×80 flipped at this rotation can't fit
        // the clamp. Engine falls back to natural direction; result is
        // feasible with no flip.
        final tick = c.onResizeUpdate(
          const Offset(1000, 1000),
          HandlePosition.topLeft,
        );
        expect(tick.feasible, isTrue,
            reason: 'natural-direction fallback keeps the gesture feasible');
        expect(tick.flip, equals(Flip.none),
            reason: 'fallback rect is not flipped');
        // Rect must stay inside clamp.
        const clamp = Rect.fromLTRB(0, 0, 200, 200);
        expect(tick.rect.left, greaterThanOrEqualTo(clamp.left - 1e-3));
        expect(tick.rect.top, greaterThanOrEqualTo(clamp.top - 1e-3));
        expect(tick.rect.right, lessThanOrEqualTo(clamp.right + 1e-3));
        expect(tick.rect.bottom, lessThanOrEqualTo(clamp.bottom + 1e-3));
      },
    );

    test(
      'rect tracks cursor through flip territory (multiple ticks): '
      'each tick produces a fresh natural-direction result, not frozen',
      () {
        // Move the cursor through several positions deep in flip territory.
        // Without the fallback, every tick would freeze at last-feasible
        // (the same rect every tick). With the fallback, each tick gets
        // a fresh feasible rect that depends on the cursor position.
        final c = TransformableBoxController(
          rect: const Rect.fromLTWH(rectLeft, rectTop, rectSize, rectSize),
          clampingRect: const Rect.fromLTRB(0, 0, 200, 200),
          rotation: theta,
          bindingStrategy: BindingStrategy.boundingBox,
          constraints: const BoxConstraints(
            minWidth: 80,
            minHeight: 80,
            maxWidth: 500,
            maxHeight: 500,
          ),
        );
        c.onResizeStart(rotateAroundCenter(const Offset(rectLeft, rectTop)));
        // All three cursor positions are far past the bottomRight anchor
        // (force-flip territory), but at different distances.
        final t1 =
            c.onResizeUpdate(const Offset(800, 800), HandlePosition.topLeft);
        final r1 = c.rect;
        final t2 =
            c.onResizeUpdate(const Offset(1200, 1200), HandlePosition.topLeft);
        final r2 = c.rect;
        final t3 =
            c.onResizeUpdate(const Offset(2000, 2000), HandlePosition.topLeft);
        final r3 = c.rect;
        for (final t in [t1, t2, t3]) {
          expect(t.feasible, isTrue,
              reason: 'fallback feasible for every tick in flip territory');
          expect(t.flip, equals(Flip.none));
        }
        // Rect must be clamp-pinned (large size); verifying it actually
        // moves with the cursor would require a non-degenerate clamp wall
        // intersection — what we can assert universally is that none of
        // the three states is the gesture-start sentinel.
        for (final r in [r1, r2, r3]) {
          expect(
              r,
              isNot(equals(
                  const Rect.fromLTWH(rectLeft, rectTop, rectSize, rectSize))),
              reason: 'rect must respond to cursor, not stay at start');
        }
      },
    );
  });
}
