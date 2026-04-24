import 'dart:math' as math;
import 'dart:typed_data';

import 'package:box_transform/box_transform.dart';
import 'package:test/test.dart';
import 'package:vector_math/vector_math_64.dart';

/// Regression: when the clamping rect is exactly the size of the rotated
/// box's bounding rect (the minimum that still contains the box), a
/// zero-delta `move()` should leave the box in place. Before this fix, the
/// per-corner `tx`/`ty` intervals were applied sequentially — at saturation
/// they degenerate to a single point, and float precision could invert the
/// order, making the sequential loop produce a `tx` that violates earlier
/// corners. Visible symptom in the playground: at the very last tick of
/// shrinking the clamping rect, the box "flicks" to an offset outside the
/// clamp before restoring when the user gives it breathing room.
void main() {
  /// Quantise via Float32List to simulate the residual drift that could have
  /// crept in through `Vector2` math in historical builds.
  double asFloat32(double v) {
    final buf = Float32List(1);
    buf[0] = v;
    return buf[0];
  }

  test('rotated move with clamp at exact bounding-rect saturation: no jump',
      () {
    const theta = math.pi / 6;
    final rect = Box.fromLTWH(200, 200, 100, 100, rotation: theta);
    final bounding = ClampHelpers.calculateBoundingRect(rect);
    // Clamping rect exactly equal to the rotated box's bounding rect —
    // the feasible tx/ty interval is a single point (0, 0).
    final clamp = Box.fromLTRB(
      bounding.left,
      bounding.top,
      bounding.right,
      bounding.bottom,
    );

    final result = BoxTransformer.move(
      initialRect: rect,
      initialLocalPosition: Vector2(250, 250),
      localPosition: Vector2(250, 250),
      clampingRect: clamp,
      rotation: theta,
      bindingStrategy: BindingStrategy.boundingBox,
    );

    expect(result.rect.left, closeTo(rect.left, 1e-9),
        reason: 'zero-delta move at clamp saturation must not shift left');
    expect(result.rect.top, closeTo(rect.top, 1e-9),
        reason: 'zero-delta move at clamp saturation must not shift top');
    expect(result.rect.width, closeTo(rect.width, 1e-9));
    expect(result.rect.height, closeTo(rect.height, 1e-9));
  });

  test('rotated move with infeasible clamp: no order-dependent "flick"', () {
    // Reproduces the user's playground report: when the clamp shrinks to a
    // size TIGHTER than the rotated box's bounding rect (even by a few
    // pixels), the box "flicks" to an offset that's outside the clamp on
    // one side instead of staying close to its last valid position.
    //
    // Root cause: the per-corner tx/ty constraints are applied sequentially
    // (`tx = max(tx, leftLimit); tx = min(tx, rightLimit)` per corner),
    // which is order-dependent when the global intersection is empty. Two
    // opposite corners push tx in opposite directions; the LAST corner
    // visited wins, producing a shift that violates earlier corners.
    //
    // Example values: 100x100 box at theta=pi/6 centered at (250,250).
    // Clamp shrunk symmetrically by 5px on each side (10px infeasibility).
    // True global intersection of tx is [5, -5] (empty); the correct fallback
    // is tx=0 (midpoint of the collapsed point). Sequential max/min gives
    // tx=5 (the last-visited corner's lower bound), shifting the box 5px
    // outside the clamp's right edge.
    const theta = math.pi / 6;
    final rect = Box.fromLTWH(200, 200, 100, 100, rotation: theta);
    final bounding = ClampHelpers.calculateBoundingRect(rect);
    final clamp = Box.fromLTRB(
      bounding.left + 5,
      bounding.top + 5,
      bounding.right - 5,
      bounding.bottom - 5,
    );

    final result = BoxTransformer.move(
      initialRect: rect,
      initialLocalPosition: Vector2(250, 250),
      localPosition: Vector2(250, 250),
      clampingRect: clamp,
      rotation: theta,
      bindingStrategy: BindingStrategy.boundingBox,
    );

    // Correct: tx/ty should be ~0 (midpoint of the empty [+5, -5] interval).
    // Current buggy sequential max/min produces tx=5 (last corner wins),
    // flicking the box to the right. Assert we're within 1 px of the initial
    // position — the sequential bug would shift by ~5 px.
    expect(result.rect.left, closeTo(rect.left, 1.0),
        reason: 'box must not flick by more than the infeasibility gap');
    expect(result.rect.top, closeTo(rect.top, 1.0));
  });

  test('rotated move with float-drifted saturation: no throw, no jump', () {
    // Same guard against Float32-ULP drift remnants — even post vector_math_64
    // migration the solver must tolerate eps-scale precision wiggles.
    const theta = math.pi / 6;
    final rect = Box.fromLTWH(200, 200, 100, 100, rotation: theta);
    final bounding = ClampHelpers.calculateBoundingRect(rect);
    final clamp = Box.fromLTRB(
      asFloat32(bounding.left + 1e-6),
      asFloat32(bounding.top + 1e-6),
      asFloat32(bounding.right - 1e-6),
      asFloat32(bounding.bottom - 1e-6),
    );

    final result = BoxTransformer.move(
      initialRect: rect,
      initialLocalPosition: Vector2(250, 250),
      localPosition: Vector2(250, 250),
      clampingRect: clamp,
      rotation: theta,
      bindingStrategy: BindingStrategy.boundingBox,
    );
    expect(result.rect.left, closeTo(rect.left, 1e-3));
    expect(result.rect.top, closeTo(rect.top, 1e-3));
  });
}
