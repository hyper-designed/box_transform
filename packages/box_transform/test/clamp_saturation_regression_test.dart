import 'dart:math' as math;
import 'dart:typed_data';

import 'package:box_transform/box_transform.dart';
import 'package:test/test.dart';
import 'package:vector_math/vector_math_64.dart';

/// Regression for the playground crash:
///
///   Invalid argument(s): 500.00001525878906
///   #0  double.clamp
///   #1  BoxTransformer._resizeRotatedScale (transformer.dart:662)
///   #2  BoxTransformer.resize (transformer.dart:146)
///   #4  TransformableBoxController.recalculateSize (controller.dart:441)
///
/// Chain (per Codex audit): `vector_math` backs `Vector2` in a Float32List,
/// so every read/write quantises to 32-bit. Rotation helpers and corner
/// offset math round-trip through `Vector2`, drifting the returned Box's
/// edges. On the next rebuild, `recalculateSize` computes
/// `k = rect.height / rect.width` from drifted edges (so k ≠ exactly 0.2),
/// then `effMinH / k` over-shoots `maxWidth` by ~1e-5, producing an empty
/// interval [wLower > wUpper] that throws in `.clamp`.
///
/// These tests force the scenario by constructing a rect whose edges match
/// what the Float32 pipeline produces after saturation.
void main() {
  /// Rounds [v] through a Float32List to simulate Vector2's storage.
  double asFloat32(double v) {
    final buf = Float32List(1);
    buf[0] = v;
    return buf[0];
  }

  test('rotated scale at aspect-saturation: zero-delta resize does not throw',
      () {
    // At saturation with maxW=500 and h = minH = 100, the feasible w is a
    // mathematical point at exactly 500. But a rect whose height has been
    // round-tripped through Float32 will have h = Float32(100)*something or
    // near-100 with drift in either direction. Here we simulate h drifting
    // *below* 100 (Float32 step down), which makes k = h/w < 0.2, which in
    // turn makes effMinH / k > 500 > maxWidth → wLower > wUpper.
    const double maxW = 500.0;
    const double minH = 100.0;
    // One Float32-ULP below 100. Dart parses this as the nearest double.
    final double driftedHeight = asFloat32(100.0 - 1e-5);
    expect(driftedHeight < 100.0, isTrue,
        reason: 'test pre-condition: need drift below exact 100');

    final Box initialRect = Box.fromLTWH(
      0,
      0,
      maxW,
      driftedHeight,
      rotation: math.pi / 6,
    );
    final constraints = Constraints(
      minWidth: 100,
      minHeight: minH,
      maxWidth: maxW,
      maxHeight: maxW,
    );

    expect(
      () => BoxTransformer.resize(
        initialRect: initialRect,
        initialLocalPosition: Vector2(maxW, driftedHeight),
        localPosition: Vector2(maxW, driftedHeight),
        handle: HandlePosition.bottomRight,
        resizeMode: ResizeMode.scale,
        initialFlip: Flip.none,
        clampingRect: Box.fromLTRB(-1e6, -1e6, 1e6, 1e6),
        constraints: constraints,
        allowFlipping: false,
        rotation: math.pi / 6,
      ),
      returnsNormally,
      reason: 'zero-delta resize at aspect-saturation must not throw on '
          'float-precision drift',
    );
  });

  test('rotated symmetric-scale at aspect-saturation: no throw', () {
    // Same crash class exists at transformer.dart:823.
    const double maxW = 500.0;
    const double minH = 100.0;
    final double driftedHeight = asFloat32(100.0 - 1e-5);

    final Box initialRect = Box.fromLTWH(
      0,
      0,
      maxW,
      driftedHeight,
      rotation: math.pi / 6,
    );
    final constraints = Constraints(
      minWidth: 100,
      minHeight: minH,
      maxWidth: maxW,
      maxHeight: maxW,
    );

    expect(
      () => BoxTransformer.resize(
        initialRect: initialRect,
        initialLocalPosition: Vector2(maxW / 2, driftedHeight / 2),
        localPosition: Vector2(maxW / 2, driftedHeight / 2),
        handle: HandlePosition.bottomRight,
        resizeMode: ResizeMode.symmetricScale,
        initialFlip: Flip.none,
        clampingRect: Box.fromLTRB(-1e6, -1e6, 1e6, 1e6),
        constraints: constraints,
        allowFlipping: false,
        rotation: math.pi / 6,
      ),
      returnsNormally,
      reason: 'symmetric-scale zero-delta at saturation must not throw',
    );
  });
}
