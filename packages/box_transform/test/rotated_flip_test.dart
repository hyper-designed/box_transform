// Tests for flip-state computation under rotation.
//
// Bug: when the box has nonzero rotation and the user drags a handle past
// its opposite anchor (in the un-rotated frame), the rect repositions to
// the other side correctly but `result.flip` stays at `initialFlip`. The
// AA path computes `currentFlip * initialFlip` via `getFlipForRect`; the
// rotated path skipped that step entirely, so the playground's content
// mirroring (which keys off `controller.flip`) never engages under rotation.

import 'dart:math' as math;

import 'package:box_transform/box_transform.dart';
import 'package:test/test.dart';
import 'package:vector_math/vector_math_64.dart';

void main() {
  group('Rotated freeform resize updates flip state', () {
    test(
      'dragging bottomRight past topLeft anchor (in un-rotated frame) '
      'produces Flip.diagonal at rotation=π/6',
      () {
        final result = _resizeRotated(
          handle: HandlePosition.bottomRight,
          mode: ResizeMode.freeform,
          // Un-rotated target (100, 100) is past anchor (150, 150) on both
          // axes → diagonal flip.
          unrotatedTarget: Vector2(100, 100),
        );
        expect(result.flip, equals(Flip.diagonal));
      },
    );

    test(
      'dragging bottomRight past anchor on x only produces Flip.horizontal',
      () {
        final result = _resizeRotated(
          handle: HandlePosition.bottomRight,
          mode: ResizeMode.freeform,
          // Un-rotated target (100, 250): past anchor on x, still below it
          // on y → horizontal flip only.
          unrotatedTarget: Vector2(100, 250),
        );
        expect(result.flip, equals(Flip.horizontal));
      },
    );

    test(
      'dragging bottomRight past anchor on y only produces Flip.vertical',
      () {
        final result = _resizeRotated(
          handle: HandlePosition.bottomRight,
          mode: ResizeMode.freeform,
          unrotatedTarget: Vector2(250, 100),
        );
        expect(result.flip, equals(Flip.vertical));
      },
    );

    test('dragging within bounds keeps Flip.none', () {
      final result = _resizeRotated(
        handle: HandlePosition.bottomRight,
        mode: ResizeMode.freeform,
        unrotatedTarget: Vector2(220, 220),
      );
      expect(result.flip, equals(Flip.none));
    });

    test(
      'initialFlip=horizontal + new horizontal flip during gesture cancels '
      'to Flip.none',
      () {
        final result = _resizeRotated(
          handle: HandlePosition.bottomRight,
          mode: ResizeMode.freeform,
          unrotatedTarget: Vector2(100, 250),
          initialFlip: Flip.horizontal,
        );
        expect(result.flip, equals(Flip.none));
      },
    );
  });

  group('Rotated scale resize updates flip state', () {
    test(
      'dragging bottomRight past anchor diagonally produces Flip.diagonal',
      () {
        final result = _resizeRotated(
          handle: HandlePosition.bottomRight,
          mode: ResizeMode.scale,
          unrotatedTarget: Vector2(100, 100),
        );
        expect(result.flip, equals(Flip.diagonal));
      },
    );
  });

  group('Rotated symmetric resize updates flip state', () {
    test(
      'pulling bottomRight past center produces Flip.diagonal',
      () {
        // Symmetric: anchor is the center (200, 200). Crossing center on
        // both axes is a diagonal flip.
        final result = _resizeRotated(
          handle: HandlePosition.bottomRight,
          mode: ResizeMode.symmetric,
          unrotatedTarget: Vector2(150, 150),
        );
        expect(result.flip, equals(Flip.diagonal));
      },
    );
  });

  group('allowFlipping=false under rotation', () {
    test(
      'freeform: allowFlipping=false suppresses flip even when pointer '
      'crosses anchor',
      () {
        final result = _resizeRotated(
          handle: HandlePosition.bottomRight,
          mode: ResizeMode.freeform,
          // Same target as the diagonal-flip test — would normally produce
          // Flip.diagonal.
          unrotatedTarget: Vector2(100, 100),
          allowFlipping: false,
        );
        expect(
          result.flip,
          equals(Flip.none),
          reason: 'AA path returns Flip.none when allowFlipping=false; '
              'rotated path must do the same.',
        );
      },
    );

    test(
      'symmetric: allowFlipping=false suppresses flip even when pointer '
      'crosses center',
      () {
        final result = _resizeRotated(
          handle: HandlePosition.bottomRight,
          mode: ResizeMode.symmetric,
          unrotatedTarget: Vector2(150, 150),
          allowFlipping: false,
        );
        expect(result.flip, equals(Flip.none));
      },
    );
  });

  group('Symmetric boundary at exact center', () {
    test('pointer exactly at center stays Flip.none (symmetric)', () {
      final result = _resizeRotated(
        handle: HandlePosition.bottomRight,
        mode: ResizeMode.symmetric,
        // Exactly the center of the test rect (200, 200). Strict `<`
        // boundary in the flip math means this is *not* a flip transition.
        unrotatedTarget: Vector2(200, 200),
      );
      expect(result.flip, equals(Flip.none));
    });

    test('pointer exactly at center stays Flip.none (symmetricScale)', () {
      final result = _resizeRotated(
        handle: HandlePosition.bottomRight,
        mode: ResizeMode.symmetricScale,
        unrotatedTarget: Vector2(200, 200),
      );
      expect(result.flip, equals(Flip.none));
    });
  });

  group('Rotated symmetricScale resize updates flip state', () {
    test(
      'pulling bottomRight past center produces Flip.diagonal',
      () {
        final result = _resizeRotated(
          handle: HandlePosition.bottomRight,
          mode: ResizeMode.symmetricScale,
          unrotatedTarget: Vector2(150, 150),
        );
        expect(result.flip, equals(Flip.diagonal));
      },
    );
  });
}

/// Test helper: drives `BoxTransformer.resize` at rotation π/6 with a target
/// expressed in the box's un-rotated frame.
///
/// The box is fixed at `Box.fromLTWH(150, 150, 100, 100)` with rotation
/// π/6 — center (200, 200), corners (150, 150), (250, 150), (250, 250),
/// (150, 250). Pointer positions are constructed by rotating the supplied
/// un-rotated coordinates back into world space, mirroring how a real
/// gesture's world-frame pointer would un-rotate inside the resize math.
RawResizeResult _resizeRotated({
  required HandlePosition handle,
  required ResizeMode mode,
  required Vector2 unrotatedTarget,
  Flip initialFlip = Flip.none,
  bool allowFlipping = true,
}) {
  const theta = math.pi / 6;
  final initial = Box.fromLTWH(150, 150, 100, 100, rotation: theta);
  final center = Vector2(200, 200);
  final initialPointerLocal = switch (handle) {
    HandlePosition.topLeft => Vector2(initial.left, initial.top),
    HandlePosition.topRight => Vector2(initial.right, initial.top),
    HandlePosition.bottomRight => Vector2(initial.right, initial.bottom),
    HandlePosition.bottomLeft => Vector2(initial.left, initial.bottom),
    _ => throw UnsupportedError('handle $handle not used in this suite'),
  };
  final initialPointerWorld =
      ClampHelpers.rotatePointAround(initialPointerLocal, center, theta);
  final targetPointerWorld =
      ClampHelpers.rotatePointAround(unrotatedTarget, center, theta);

  return BoxTransformer.resize(
    initialRect: initial,
    initialLocalPosition: initialPointerWorld,
    localPosition: targetPointerWorld,
    handle: handle,
    resizeMode: mode,
    initialFlip: initialFlip,
    rotation: theta,
    bindingStrategy: BindingStrategy.originalBox,
    allowFlipping: allowFlipping,
  );
}
