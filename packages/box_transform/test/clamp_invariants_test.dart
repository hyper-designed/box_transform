import 'package:box_transform/box_transform.dart';
import 'package:test/test.dart';
import 'package:vector_math/vector_math_64.dart';

// Stress-tests for clamp containment under gestures that historically
// produced visibly wrong on-screen states: force-flip into infeasible
// regions, side handles hugging clamp edges, and gestures that the
// recorder captured as "successful" but where the resulting rect either
// leaked the clamp or changed dimensions a side handle should never touch.
//
// Each test asserts engine *invariants* — clamp containment, side-handle
// scope, constraint compliance — rather than specific recorded values, so
// the tests survive engine refinement that produces a different (but
// still correct) rect.

void main() {
  void expectInsideClamp(Box rect, Box clamp, {String? reason}) {
    expect(rect.left, greaterThanOrEqualTo(clamp.left - 1e-3),
        reason: '${reason ?? ''}: rect.left=${rect.left} '
            'clamp.left=${clamp.left}');
    expect(rect.top, greaterThanOrEqualTo(clamp.top - 1e-3),
        reason: '${reason ?? ''}: rect.top=${rect.top} '
            'clamp.top=${clamp.top}');
    expect(rect.right, lessThanOrEqualTo(clamp.right + 1e-3),
        reason: '${reason ?? ''}: rect.right=${rect.right} '
            'clamp.right=${clamp.right}');
    expect(rect.bottom, lessThanOrEqualTo(clamp.bottom + 1e-3),
        reason: '${reason ?? ''}: rect.bottom=${rect.bottom} '
            'clamp.bottom=${clamp.bottom}');
  }

  void expectRespectsConstraints(Box rect, Constraints c, {String? reason}) {
    expect(rect.width, greaterThanOrEqualTo(c.minWidth - 1e-3),
        reason: '${reason ?? ''}: width=${rect.width} < '
            'minWidth=${c.minWidth}');
    expect(rect.width, lessThanOrEqualTo(c.maxWidth + 1e-3),
        reason: '${reason ?? ''}: width=${rect.width} > '
            'maxWidth=${c.maxWidth}');
    expect(rect.height, greaterThanOrEqualTo(c.minHeight - 1e-3),
        reason: '${reason ?? ''}: height=${rect.height} < '
            'minHeight=${c.minHeight}');
    expect(rect.height, lessThanOrEqualTo(c.maxHeight + 1e-3),
        reason: '${reason ?? ''}: height=${rect.height} > '
            'maxHeight=${c.maxHeight}');
  }

  // Recorded playground scenarios that captured visibly buggy on-screen
  // states. The recorder used those states as expected values; here we
  // re-run the same gesture inputs and assert the engine produces output
  // that respects clamp containment, side-handle scope, and constraints.
  group('recorded playground scenarios — engine respects invariants', () {
    final clamp = Box.fromLTWH(264, 228, 655, 440);
    const constraints = Constraints(
      minWidth: 100,
      minHeight: 100,
      maxWidth: 500,
      maxHeight: 500,
    );

    test(
      'topLeft corner force-flip into infeasible diagonal stays in clamp',
      () {
        // Drag topLeft handle by (+313, +382). Cursor crosses bottomRight
        // anchor on both axes → diagonal flip requested. Min size 100×100
        // anchored at (761, 614) facing down-right would have bottom=714,
        // past clamp.bottom=668 — infeasible. Engine must NOT leak.
        final result = BoxTransformer.resize(
          resizeMode: ResizeMode.freeform,
          initialFlip: Flip.none,
          initialRect: Box.fromLTWH(517, 494, 244, 120),
          handle: HandlePosition.topLeft,
          initialLocalPosition: Vector2(13, 14),
          allowFlipping: true,
          localPosition: Vector2(326, 396),
          clampingRect: clamp,
          constraints: constraints,
        );
        expectInsideClamp(result.rect, clamp);
        expectRespectsConstraints(result.rect, constraints);
      },
    );

    test(
      'left side handle past clamp.left changes only width',
      () {
        // Side handles must never touch the perpendicular axis. Recorded
        // expected leaked top/bottom/right; engine must keep them pinned.
        const initial = (left: 344.0, top: 516.0, w: 167.0, h: 118.0);
        final result = BoxTransformer.resize(
          resizeMode: ResizeMode.freeform,
          initialFlip: Flip.none,
          initialRect:
              Box.fromLTWH(initial.left, initial.top, initial.w, initial.h),
          handle: HandlePosition.left,
          initialLocalPosition: Vector2(10, 51),
          allowFlipping: true,
          localPosition: Vector2(-168, 126),
          clampingRect: clamp,
          constraints: constraints,
        );
        expectInsideClamp(result.rect, clamp);
        expectRespectsConstraints(result.rect, constraints);
        expect(result.rect.top, closeTo(initial.top, 1e-3),
            reason: 'left handle moved top axis');
        expect(result.rect.bottom, closeTo(initial.top + initial.h, 1e-3),
            reason: 'left handle moved bottom axis');
        expect(result.rect.right, closeTo(initial.left + initial.w, 1e-3),
            reason: 'left handle moved right axis (anchor)');
      },
    );

    test(
      'top side handle vertical force-flip stays in clamp',
      () {
        // Top handle dragged DOWN past bottomCenter anchor → vertical
        // flip. Recorded expected leaked clamp.bottom by 32 px; must not.
        final result = BoxTransformer.resize(
          resizeMode: ResizeMode.freeform,
          initialFlip: Flip.none,
          initialRect: Box.fromLTWH(277, 498, 239, 118),
          handle: HandlePosition.top,
          initialLocalPosition: Vector2(103, 17),
          allowFlipping: true,
          localPosition: Vector2(467, 409),
          clampingRect: clamp,
          constraints: constraints,
        );
        expectInsideClamp(result.rect, clamp);
        expectRespectsConstraints(result.rect, constraints);
      },
    );

    test(
      'multi-step gesture sequence stays in clamp at every step',
      () {
        // Replays the original recorded sequence using the engine's actual
        // output as each step's input — i.e. what the user would actually
        // see frame-to-frame. The recorded values fed each step's *buggy*
        // output forward as the next step's input; this version uses real
        // engine output so we exercise the chain from valid intermediates.
        var step = BoxTransformer.resize(
          resizeMode: ResizeMode.freeform,
          initialFlip: Flip.none,
          initialRect: Box.fromLTWH(344, 516, 167, 118),
          handle: HandlePosition.left,
          initialLocalPosition: Vector2(10, 51),
          allowFlipping: true,
          localPosition: Vector2(-168, 126),
          clampingRect: clamp,
          constraints: constraints,
        );
        expectInsideClamp(step.rect, clamp, reason: 'step 1 (left)');
        expectRespectsConstraints(step.rect, constraints,
            reason: 'step 1 (left)');

        step = BoxTransformer.resize(
          resizeMode: ResizeMode.freeform,
          initialFlip: step.flip,
          initialRect: step.rect,
          handle: HandlePosition.top,
          initialLocalPosition: Vector2(103, 17),
          allowFlipping: true,
          localPosition: Vector2(467, 409),
          clampingRect: clamp,
          constraints: constraints,
        );
        expectInsideClamp(step.rect, clamp, reason: 'step 2 (top flip)');
        expectRespectsConstraints(step.rect, constraints,
            reason: 'step 2 (top flip)');

        step = BoxTransformer.resize(
          resizeMode: ResizeMode.freeform,
          initialFlip: step.flip,
          initialRect: step.rect,
          handle: HandlePosition.bottomLeft,
          initialLocalPosition: Vector2(16, 12),
          allowFlipping: true,
          localPosition: Vector2(210, 147),
          clampingRect: clamp,
          constraints: constraints,
        );
        expectInsideClamp(step.rect, clamp, reason: 'step 3 (bottomLeft)');
        expectRespectsConstraints(step.rect, constraints,
            reason: 'step 3 (bottomLeft)');
      },
    );
  });

  // Force-flip fallback: when the cursor is past the anchor but the
  // flipped state can't fit clamp + constraints, the engine retries the
  // LP with natural-direction signs. The rect then tracks the cursor by
  // clamp-pinning at the natural wall — feasible=true, flip=none. The
  // engine only signals feasible=false when no direction works.
  group('force-flip fallback: natural direction when flip is infeasible', () {
    test(
      'flip-impossible cursor reverts to natural direction (no flip, '
      'clamp-pinned), feasible=true',
      () {
        const theta = 0.3; // ~17°
        final result = BoxTransformer.resize(
          resizeMode: ResizeMode.freeform,
          initialFlip: Flip.none,
          initialRect: Box.fromLTWH(40, 40, 100, 100, rotation: theta),
          handle: HandlePosition.topLeft,
          initialLocalPosition: Vector2(40, 40),
          allowFlipping: true,
          // Drag topLeft cursor far past bottomRight anchor diagonally.
          // Min 100×100 flipped at this rotation cannot fit clamp.
          localPosition: Vector2(400, 400),
          rotation: theta,
          bindingStrategy: BindingStrategy.boundingBox,
          clampingRect: Box.fromLTRB(0, 0, 200, 200),
          constraints: const Constraints(
            minWidth: 100,
            minHeight: 100,
            maxWidth: 500,
            maxHeight: 500,
          ),
        );
        // The engine falls back to the natural (un-flipped) direction.
        expect(result.feasible, isTrue,
            reason: 'natural-direction fallback must be feasible');
        expect(result.flip, equals(Flip.none),
            reason: 'fallback rect is NOT flipped (force-flip aborted)');
        expectInsideClamp(result.rect, Box.fromLTRB(0, 0, 200, 200),
            reason: 'fallback rect must stay inside clamp');
      },
    );

    test(
      'cursor far past anchor in flip direction does NOT grow rect in '
      'the opposite direction (regression: fallback used cursor distance '
      'as natural-direction target, growing rect away from cursor)',
      () {
        // bottomRight handle, anchor = topLeft world. Drag the cursor far
        // past the anchor in the flip direction (-x, -y). Force-flip is
        // infeasible (would extend past clamp.left/top). Without the
        // axis-zeroing fix, the natural-direction fallback would use
        // |cursor - anchor| as the natural target, producing a rect that
        // grows toward (+x, +y) — the OPPOSITE of where the cursor went.
        const theta = 0.3;
        final result = BoxTransformer.resize(
          resizeMode: ResizeMode.freeform,
          initialFlip: Flip.none,
          initialRect: Box.fromLTWH(20, 20, 80, 80, rotation: theta),
          handle: HandlePosition.bottomRight,
          // Cursor starts at the rotated bottomRight world position.
          initialLocalPosition: Vector2(100, 100),
          allowFlipping: true,
          // Drag cursor far past topLeft anchor in -x, -y direction.
          localPosition: Vector2(-2000, -2000),
          rotation: theta,
          bindingStrategy: BindingStrategy.boundingBox,
          clampingRect: Box.fromLTRB(0, 0, 200, 200),
          constraints: const Constraints(
            minWidth: 60,
            minHeight: 60,
            maxWidth: 500,
            maxHeight: 500,
          ),
        );
        expect(result.feasible, isTrue);
        expect(result.flip, equals(Flip.none));
        // The rect must NOT have grown larger than initial in the natural
        // direction. With cursor far in flip territory, the fallback
        // collapses each flipped axis to minimum, so the rect should be
        // at most the gesture-start size on each axis (often smaller).
        expect(result.rect.width, lessThanOrEqualTo(80 + 1e-3),
            reason: 'rect must not grow in opposite direction of cursor');
        expect(result.rect.height, lessThanOrEqualTo(80 + 1e-3),
            reason: 'rect must not grow in opposite direction of cursor');
      },
    );

    test(
      'rotated freeform: small feasible target returns feasible=true',
      () {
        const theta = 0.3;
        final result = BoxTransformer.resize(
          resizeMode: ResizeMode.freeform,
          initialFlip: Flip.none,
          initialRect: Box.fromLTWH(50, 50, 80, 80, rotation: theta),
          handle: HandlePosition.bottomRight,
          initialLocalPosition: Vector2(130, 130),
          allowFlipping: true,
          localPosition: Vector2(140, 140),
          rotation: theta,
          bindingStrategy: BindingStrategy.boundingBox,
          clampingRect: Box.fromLTRB(0, 0, 500, 500),
        );
        expect(result.feasible, isTrue);
      },
    );
  });
}
