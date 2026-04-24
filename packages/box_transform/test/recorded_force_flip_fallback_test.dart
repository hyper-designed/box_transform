import 'package:box_transform/box_transform.dart';
import 'package:test/test.dart';
import 'package:vector_math/vector_math_64.dart';

// Regression coverage for two scenarios captured by the playground's test
// recorder while reproducing the "rotated force-flip leaks the clamp" bug.
//
// Both gestures drag a topLeft corner past the bottomRight anchor under
// non-trivial rotation with min/max constraints. The pre-fix engine would
// return a flipped rect that leaked the clamp by tens of pixels; the
// post-fix engine signals the flipped state is infeasible and falls back
// to the natural (un-flipped) direction so the rect stays inside the clamp.
//
// Asserted invariants per gesture:
//   * result.rect stays inside clampingRect
//   * result.rect respects min/max constraints
//   * result.flip == Flip.none (force-flip aborted because flipped state
//     was infeasible — the engine fell back rather than emitting a leaky
//     diagonal flip)
//
// File kept under a recorder-style name to mark its origin; the assertions
// describe the *intended* behavior, not the buggy state the recorder once
// captured.

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
        reason: '${reason ?? ''}: width=${rect.width} '
            '< minWidth=${c.minWidth}');
    expect(rect.width, lessThanOrEqualTo(c.maxWidth + 1e-3),
        reason: '${reason ?? ''}: width=${rect.width} '
            '> maxWidth=${c.maxWidth}');
    expect(rect.height, greaterThanOrEqualTo(c.minHeight - 1e-3),
        reason: '${reason ?? ''}: height=${rect.height} '
            '< minHeight=${c.minHeight}');
    expect(rect.height, lessThanOrEqualTo(c.maxHeight + 1e-3),
        reason: '${reason ?? ''}: height=${rect.height} '
            '> maxHeight=${c.maxHeight}');
  }

  group('Recorded force-flip fallback regressions', () {
    const constraints = Constraints(
      minWidth: 100,
      minHeight: 100,
      maxWidth: 500,
      maxHeight: 500,
    );

    test('topLeft drag past anchor at theta=0.59 stays inside clamp', () {
      final clamp = Box.fromLTWH(208.74, 182.10, 713.90, 517.23);
      final result = BoxTransformer.resize(
        resizeMode: ResizeMode.freeform,
        initialFlip: Flip.none,
        initialRect:
            Box.fromLTWH(289.67, 579.95, 100.00, 100.00, rotation: 0.5910843),
        handle: HandlePosition.topLeft,
        initialLocalPosition: Vector2(16.08, 13.30),
        allowFlipping: true,
        rotation: 0.5910843,
        bindingStrategy: BindingStrategy.boundingBox,
        localPosition: Vector2(69.20, 240.04),
        clampingRect: clamp,
        constraints: constraints,
      );
      expect(result.flip, equals(Flip.none),
          reason: 'force-flip aborted (fallback engaged)');
      expectInsideClamp(result.rect, clamp);
      expectRespectsConstraints(result.rect, constraints);
    });

    test('two-step gesture at theta=0.35: each tick stays inside clamp', () {
      // Step 1: small pull that grows the rect inside the clamp (feasible).
      final clamp = Box.fromLTWH(144.46, 139.27, 787.62, 556.81);
      var step = BoxTransformer.resize(
        resizeMode: ResizeMode.freeform,
        initialFlip: Flip.none,
        initialRect:
            Box.fromLTWH(351.89, 412.78, 400.00, 224.73, rotation: 0.3510944),
        handle: HandlePosition.topLeft,
        initialLocalPosition: Vector2(10.58, 17.55),
        allowFlipping: true,
        rotation: 0.3510944,
        bindingStrategy: BindingStrategy.boundingBox,
        localPosition: Vector2(103.86, 53.10),
        clampingRect: clamp,
        constraints: constraints,
      );
      expect(step.flip, equals(Flip.none));
      expectInsideClamp(step.rect, clamp, reason: 'step 1');
      expectRespectsConstraints(step.rect, constraints, reason: 'step 1');

      // Step 2: from the step-1 rect, drag past the bottomRight anchor.
      // Under boundingBox with these min/max constraints the flipped state
      // does not fit — the engine must fall back to natural direction.
      step = BoxTransformer.resize(
        resizeMode: ResizeMode.freeform,
        initialFlip: step.flip,
        initialRect: step.rect,
        handle: HandlePosition.topLeft,
        initialLocalPosition: Vector2(12.75, 19.64),
        allowFlipping: true,
        rotation: 0.3510944,
        bindingStrategy: BindingStrategy.boundingBox,
        localPosition: Vector2(239.31, 427.13),
        clampingRect: clamp,
        constraints: constraints,
      );
      expect(step.flip, equals(Flip.none),
          reason: 'force-flip aborted (fallback engaged)');
      expectInsideClamp(step.rect, clamp, reason: 'step 2');
      expectRespectsConstraints(step.rect, constraints, reason: 'step 2');
    });
  });
}
