import 'dart:math' as math;
import 'dart:typed_data';

import 'package:vector_math/vector_math_64.dart';

import 'enums.dart';
import 'geometry.dart';

// ---------------------------------------------------------------------------
// Flat-buffer LP
// ---------------------------------------------------------------------------
//
// The rotated-clamping LP runs on a flat [Float64List] of (a, b, c) triples
// with no per-call allocation. Builders write into a reused [IneqBuffer];
// the projector consumes them and writes its result into a reused
// [FlatProjection].
//
// Layout: index `3*i + 0` = a_i, `3*i + 1` = b_i, `3*i + 2` = c_i.
// Builders emit up to 4 corners × up to 4 axis-aligned edges per corner =
// 16 inequalities; trivially-zero rows (a≈0 and b≈0) are dropped in-place
// so the projector skips no-op constraints.

/// Capacity (number of inequalities) of an [IneqBuffer] data slab.
///
/// 16 is the worst-case row count emitted by any builder
/// ([RotatedClampingSolver.buildCornerIneqsInto],
/// [RotatedClampingSolver.buildSideHandleIneqsInto],
/// [RotatedClampingSolver.buildCenterIneqsInto]): 4 corners × up to 4
/// axis-aligned edges per corner.
const int _kMaxIneqs = 16;

/// Mutable inequality batch reused by the rotated-clamping hot path.
///
/// Builders ([RotatedClampingSolver.buildCornerIneqsInto],
/// [RotatedClampingSolver.buildSideHandleIneqsInto],
/// [RotatedClampingSolver.buildCenterIneqsInto]) write coefficient
/// triples into [data] and set [count];
/// [RotatedClampingSolver.projectOntoFeasibleRegionFlat] consumes them.
/// Single-isolate scratch reuse keeps the steady-state path
/// allocation-free.
class IneqBuffer {
  /// Flat (a, b, c) triples, length [_kMaxIneqs] * 3.
  final Float64List data;

  /// Number of inequalities populated in [data] (0..[_kMaxIneqs]).
  int count;

  /// Creates a fresh empty buffer with capacity [_kMaxIneqs].
  IneqBuffer()
      : data = Float64List(_kMaxIneqs * 3),
        count = 0;

  /// Resets the buffer to empty.
  void clear() {
    count = 0;
  }
}

/// Holds the result of an in-place flat projection. Reused across calls
/// (caller-owned scalar bag) to avoid per-call allocation.
class FlatProjection {
  /// Feasible width.
  double w = 0;

  /// Feasible height.
  double h = 0;

  /// Whether [w] is pinned to the minimum bound.
  bool wMinHit = false;

  /// Whether [w] is pinned to the maximum bound.
  bool wMaxHit = false;

  /// Whether [h] is pinned to the minimum bound.
  bool hMinHit = false;

  /// Whether [h] is pinned to the maximum bound.
  bool hMaxHit = false;

  /// True iff the final (w, h) satisfies every inequality within tolerance.
  /// When false, the projector returned its closest-feasible best-effort
  /// — using that (w, h) directly produces a rect that leaks past the
  /// clamp by `worstResidual` pixels. Callers must treat this as a freeze
  /// signal (return initialRect) instead of using w/h.
  bool feasible = true;

  /// Worst over-violation across all inequalities at the returned (w, h).
  /// Zero when feasible; in pixels otherwise.
  double worstResidual = 0;

  /// Creates an empty projection result. All fields default to a
  /// zero-feasible state: `w = h = 0`, no axes pinned, [feasible] true,
  /// [worstResidual] zero. Reuse one instance across calls to avoid
  /// per-tick allocation; the projector overwrites every field.
  FlatProjection();
}

/// Static surface for the rotated-clamping LP entry points.
///
/// All four operations write into / read from caller-owned scratch
/// buffers ([IneqBuffer], [FlatProjection]) so the steady-state path
/// allocates nothing. Builders fill the inequality buffer with `a*w + b*h
/// <= c` rows; the projector finds the feasible `(w, h)` closest to a
/// target.
abstract final class RotatedClampingSolver {
  const RotatedClampingSolver._();

  /// Fills [buf] with the corner-anchored inequalities.
  ///
  /// Used for **corner-anchored** resizes (freeform, scale). The anchor is
  /// the fixed corner (the handle's opposite corner), expressed in world
  /// coords. [widthSign] and [heightSign] encode which side of [anchor] the
  /// box extends on (±1 each).
  ///
  /// Which corners are enforced depends on [bindingStrategy]:
  ///
  /// * [BindingStrategy.boundingBox]: the rotated rect's four corners
  ///   only (rendered footprint stays in the clamp).
  ///
  ///       C0 = anchor
  ///       C1 = anchor + sx*w*(cos, sin)
  ///       C2 = anchor + sx*w*(cos, sin) + sy*h*(-sin, cos)
  ///       C3 = anchor + sy*h*(-sin, cos)
  ///
  /// * [BindingStrategy.originalBox]: the unrotated rect's four
  ///   axis-aligned corners only. The rendered rotated corners may extend
  ///   beyond the clamp by design.
  ///
  ///       center = anchor + (sx*w/2)*(cos, sin) + (sy*h/2)*(-sin, cos)
  ///       corner = center + (sgnX*w/2, sgnY*h/2)   for sgnX, sgnY ∈ {-1, +1}
  ///
  /// At θ = 0 both strategies collapse to the same axis-aligned
  /// constraints; at θ ≠ 0 they enforce different geometries and neither
  /// set is a subset of the other. Coefficients common across the four
  /// corners (e.g. `sx*cos`, `sx*sin`) are factored out of the loop.
  static void buildCornerIneqsInto(
    IneqBuffer buf, {
    required Vector2 anchor,
    required double theta,
    required Box clampingRect,
    required BindingStrategy bindingStrategy,
    double widthSign = 1.0,
    double heightSign = 1.0,
  }) {
    final cos = math.cos(theta);
    final sin = math.sin(theta);
    final ax = anchor.x;
    final ay = anchor.y;
    final lc = clampingRect.left;
    final tc = clampingRect.top;
    final rc = clampingRect.right;
    final bc = clampingRect.bottom;
    final sx = widthSign;
    final sy = heightSign;

    // Pre-compute constants used by both strategies.
    final sxCos = sx * cos;
    final sxSin = sx * sin;
    final syCos = sy * cos;
    final negSySin = -sy * sin;

    final cRight = rc - ax; // for Cx <= rc -> aW*w + aH*h <= rc - ax
    final cLeft = ax - lc; // for Cx >= lc -> -aW*w - aH*h <= ax - lc
    final cBot = bc - ay; // for Cy <= bc
    final cTop = ay - tc; // for Cy >= tc

    final data = buf.data;
    int n = 0;
    void addEdges(double aW, double aH, double bW, double bH) {
      // Skip the trivially-zero row (corner C0 in boundingBox case has
      // aW=aH=0, bW=bH=0 and produces no useful constraint). We replicate
      // the original behavior of dropping rows where both a and b are
      // negligible.
      if (aW.abs() <= 1e-12 && aH.abs() <= 1e-12) {
        // x-edges have a=b=0; skip both of them.
      } else {
        // Cx <= rc
        data[3 * n] = aW;
        data[3 * n + 1] = aH;
        data[3 * n + 2] = cRight;
        n++;
        // Cx >= lc
        data[3 * n] = -aW;
        data[3 * n + 1] = -aH;
        data[3 * n + 2] = cLeft;
        n++;
      }
      if (bW.abs() <= 1e-12 && bH.abs() <= 1e-12) {
        // y-edges have a=b=0; skip both of them.
      } else {
        // Cy <= bc
        data[3 * n] = bW;
        data[3 * n + 1] = bH;
        data[3 * n + 2] = cBot;
        n++;
        // Cy >= tc
        data[3 * n] = -bW;
        data[3 * n + 1] = -bH;
        data[3 * n + 2] = cTop;
        n++;
      }
    }

    if (bindingStrategy == BindingStrategy.boundingBox) {
      // Rotated rect corners only: C0 (anchor, all-zero coefficients),
      // C1, C2, C3. The rendered rotated polygon must stay in the clamp;
      // the unrotated stored rect is invisible storage and need not be in
      // the clamp. C0: aW=aH=bW=bH=0 → all four edges are degenerate, so
      // addEdges produces nothing (still legal). We pass through to keep
      // code uniform.
      addEdges(0, 0, 0, 0); // C0
      addEdges(sxCos, 0, sxSin, 0); // C1 = anchor + sx*w*e1
      addEdges(sxCos, negSySin, sxSin, syCos); // C2 = + sx*w*e1 + sy*h*e2
      addEdges(0, negSySin, 0, syCos); // C3 = + sy*h*e2
    } else {
      // originalBox: unrotated rect corners, anchored via the rect's center.
      //   center = anchor + (sx*w/2)*(cos, sin) + (sy*h/2)*(-sin, cos)
      //   corner = center + (sgnX*w/2, sgnY*h/2)
      //   corner.x = ax + w*(sx*cos/2 + sgnX/2) + h*(-sy*sin/2)
      //   corner.y = ay + w*(sx*sin/2)          + h*(sy*cos/2 + sgnY/2)
      final halfSxCos = sxCos * 0.5; // sx*cos/2
      final halfSxSin = sxSin * 0.5; // sx*sin/2
      final halfSyCos = syCos * 0.5; // sy*cos/2
      final halfNegSySin = negSySin * 0.5; // -sy*sin/2

      // Four (sgnX, sgnY) combinations: (-1,-1), (-1,+1), (+1,-1), (+1,+1).
      // We unroll for clarity and to avoid loop overhead.
      // sgnX = -1, sgnY = -1
      addEdges(halfSxCos - 0.5, halfNegSySin, halfSxSin, halfSyCos - 0.5);
      // sgnX = -1, sgnY = +1
      addEdges(halfSxCos - 0.5, halfNegSySin, halfSxSin, halfSyCos + 0.5);
      // sgnX = +1, sgnY = -1
      addEdges(halfSxCos + 0.5, halfNegSySin, halfSxSin, halfSyCos - 0.5);
      // sgnX = +1, sgnY = +1
      addEdges(halfSxCos + 0.5, halfNegSySin, halfSxSin, halfSyCos + 0.5);
    }

    buf.count = n;
  }

  /// Fills [buf] with side-handle inequalities for a rect anchored at the
  /// midpoint of the side opposite [handle].
  ///
  /// Unlike the corner builder ([buildCornerIneqsInto]), the rect's anchor
  /// is *not* one of its corners — it's a side midpoint. The default
  /// (unflipped) rect spans:
  ///
  /// * `bottom`: rect-local `x ∈ [-w/2, w/2]`, `y ∈ [0, h]`   (anchor = topCenter)
  /// * `top`:    `x ∈ [-w/2, w/2]`, `y ∈ [-h, 0]`              (anchor = bottomCenter)
  /// * `right`:  `x ∈ [0, w]`,      `y ∈ [-h/2, h/2]`          (anchor = centerLeft)
  /// * `left`:   `x ∈ [-w, 0]`,     `y ∈ [-h/2, h/2]`          (anchor = centerRight)
  ///
  /// [widthSign] and [heightSign] flip the active-axis extent under
  /// force-flip (drag past anchor): `right` with `widthSign=-1` becomes
  /// `x ∈ [-w, 0]`, `top` with `heightSign=+1` becomes `y ∈ [0, h]`, etc.
  /// The convention matches [buildCornerIneqsInto]: "+1 means rect extends
  /// in the +e1/+e2 direction from anchor". Unflipped values are right→+1,
  /// left→−1, top→−1, bottom→+1.
  ///
  /// Which corners are enforced depends on [bindingStrategy]:
  ///
  /// * [BindingStrategy.boundingBox]: the rotated rect's four corners
  ///   only (rendered footprint stays inside the clamp). Up to 16 edge
  ///   inequalities.
  /// * [BindingStrategy.originalBox]: the unrotated rect's four
  ///   axis-aligned corners only (the unrotated stored rect stays inside
  ///   the clamp; rotated corners may extend outside). Up to 16 edge
  ///   inequalities.
  ///
  /// At θ = 0 both strategies collapse to identical axis-aligned
  /// constraints. At θ ≠ 0 they enforce different geometries.
  static void buildSideHandleIneqsInto(
    IneqBuffer buf, {
    required Vector2 anchor,
    required double theta,
    required Box clampingRect,
    required HandlePosition handle,
    required BindingStrategy bindingStrategy,
    double widthSign = 1.0,
    double heightSign = 1.0,
  }) {
    final cos = math.cos(theta);
    final sin = math.sin(theta);
    final ax = anchor.x;
    final ay = anchor.y;
    final lc = clampingRect.left;
    final tc = clampingRect.top;
    final rc = clampingRect.right;
    final bc = clampingRect.bottom;

    final cRight = rc - ax;
    final cLeft = ax - lc;
    final cBot = bc - ay;
    final cTop = ay - tc;

    final data = buf.data;
    int n = 0;
    void addEdges(double aW, double aH, double bW, double bH) {
      if (aW.abs() > 1e-12 || aH.abs() > 1e-12) {
        data[3 * n] = aW;
        data[3 * n + 1] = aH;
        data[3 * n + 2] = cRight;
        n++;
        data[3 * n] = -aW;
        data[3 * n + 1] = -aH;
        data[3 * n + 2] = cLeft;
        n++;
      }
      if (bW.abs() > 1e-12 || bH.abs() > 1e-12) {
        data[3 * n] = bW;
        data[3 * n + 1] = bH;
        data[3 * n + 2] = cBot;
        n++;
        data[3 * n] = -bW;
        data[3 * n + 1] = -bH;
        data[3 * n + 2] = cTop;
        n++;
      }
    }

    // For each side handle the rect extends from [anchor] by either
    // widthSign*w along rect-local x (horizontal-side handles: left/right)
    // or heightSign*h along rect-local y (vertical-side handles: top/
    // bottom). The perpendicular axis is symmetric ±h/2 (or ±w/2) about
    // anchor — the user can't drag in that direction for a side handle.
    //
    // widthSign/heightSign use the same convention as corner-anchored
    // resizes: "+1 means rect extends in +e1 / +e2 from anchor". For an
    // unflipped right handle widthSign=+1; for unflipped top handle
    // heightSign=-1. Force-flip (drag past anchor) flips the relevant sign.
    //
    // Each corner is parameterized by (α, β, γ, δ) such that rel_x = α*w +
    // β*h and rel_y = γ*w + δ*h in rect-local coords.
    final List<({double a, double b, double g, double d})> corners;
    final bool isHorizontalSide =
        handle.influencesLeft || handle.influencesRight;
    if (isHorizontalSide) {
      // Active axis x. Anchor-side corners at rel_x=0; far-side at
      // rel_x = widthSign*w. Both axes' y at ±h/2.
      corners = [
        (a: 0, b: 0, g: 0, d: -0.5), // anchor-side, top
        (a: widthSign, b: 0, g: 0, d: -0.5), // far-side, top
        (a: 0, b: 0, g: 0, d: 0.5), // anchor-side, bottom
        (a: widthSign, b: 0, g: 0, d: 0.5), // far-side, bottom
      ];
    } else {
      // Active axis y (top/bottom).
      corners = [
        (a: -0.5, b: 0, g: 0, d: 0), // anchor-side, left
        (a: 0.5, b: 0, g: 0, d: 0), // anchor-side, right
        (a: -0.5, b: 0, g: 0, d: heightSign), // far-side, left
        (a: 0.5, b: 0, g: 0, d: heightSign), // far-side, right
      ];
    }

    if (bindingStrategy == BindingStrategy.boundingBox) {
      // Emit the rotated rect-local corners: the rendered polygon must
      // stay in the clamp. With rel_x = α*w + β*h, rel_y = γ*w + δ*h:
      //   world_x_offset = cos*rel_x - sin*rel_y
      //                  = (α*cos - γ*sin)*w + (β*cos - δ*sin)*h
      //   world_y_offset = sin*rel_x + cos*rel_y
      //                  = (α*sin + γ*cos)*w + (β*sin + δ*cos)*h
      for (final c in corners) {
        final aW = cos * c.a - sin * c.g;
        final aH = cos * c.b - sin * c.d;
        final bW = sin * c.a + cos * c.g;
        final bH = sin * c.b + cos * c.d;
        addEdges(aW, aH, bW, bH);
      }
    } else {
      // originalBox: emit the unrotated rect's corners (axis-aligned in
      // world). The center sits at anchor + R(theta) * sideOff:
      //   horizontal-side: sideOff = (widthSign*w/2, 0)
      //   vertical-side:   sideOff = (0, heightSign*h/2)
      // Corners are at center + (sgnX*w/2, sgnY*h/2).
      final double centerAW, centerAH, centerBW, centerBH;
      if (isHorizontalSide) {
        centerAW = widthSign * cos / 2;
        centerAH = 0;
        centerBW = widthSign * sin / 2;
        centerBH = 0;
      } else {
        centerAW = 0;
        centerAH = -heightSign * sin / 2;
        centerBW = 0;
        centerBH = heightSign * cos / 2;
      }
      for (final sgnX in const [-1.0, 1.0]) {
        for (final sgnY in const [-1.0, 1.0]) {
          addEdges(
            centerAW + sgnX / 2,
            centerAH,
            centerBW,
            centerBH + sgnY / 2,
          );
        }
      }
    }

    buf.count = n;
  }

  /// Fills [buf] with the center-anchored (symmetric-mode) inequalities.
  ///
  /// Which corners are enforced depends on [bindingStrategy]:
  ///
  /// * [BindingStrategy.boundingBox]: the rotated rect's four corners
  ///   only (`center + sx*(w/2)*e1 + sy*(h/2)*e2`). Rendered footprint
  ///   stays in the clamp.
  /// * [BindingStrategy.originalBox]: the unrotated rect's four
  ///   axis-aligned corners only (`center + (sx*w/2, sy*h/2)`). The
  ///   rendered rotated corners may extend beyond the clamp.
  static void buildCenterIneqsInto(
    IneqBuffer buf, {
    required Vector2 center,
    required double theta,
    required Box clampingRect,
    required BindingStrategy bindingStrategy,
  }) {
    // For [BindingStrategy.originalBox], the unrotated rect's corners are
    // `center ± (w/2, h/2)` regardless of theta — equivalent to cos=1, sin=0.
    final cx = center.x;
    final cy = center.y;
    final lc = clampingRect.left;
    final tc = clampingRect.top;
    final rc = clampingRect.right;
    final bc = clampingRect.bottom;

    final cRight = rc - cx;
    final cLeft = cx - lc;
    final cBot = bc - cy;
    final cTop = cy - tc;

    final data = buf.data;
    int n = 0;
    // Emits the (≤4) edge constraints for one corner with rect-local
    // coefficients (aW, aH, bW, bH) such that
    //   corner.x = cx + aW*w + aH*h
    //   corner.y = cy + bW*w + bH*h
    // and skips trivially-zero rows.
    void emit(double aW, double aH, double bW, double bH) {
      if (!(aW.abs() <= 1e-12 && aH.abs() <= 1e-12)) {
        data[3 * n] = aW;
        data[3 * n + 1] = aH;
        data[3 * n + 2] = cRight;
        n++;
        data[3 * n] = -aW;
        data[3 * n + 1] = -aH;
        data[3 * n + 2] = cLeft;
        n++;
      }
      if (!(bW.abs() <= 1e-12 && bH.abs() <= 1e-12)) {
        data[3 * n] = bW;
        data[3 * n + 1] = bH;
        data[3 * n + 2] = cBot;
        n++;
        data[3 * n] = -bW;
        data[3 * n + 1] = -bH;
        data[3 * n + 2] = cTop;
        n++;
      }
    }

    if (bindingStrategy == BindingStrategy.boundingBox) {
      // Rotated corners only: corner = center + R(theta)*(sx*w/2, sy*h/2).
      //   aW = sx*cos/2, aH = -sy*sin/2,
      //   bW = sx*sin/2, bH =  sy*cos/2
      final halfCos = math.cos(theta) * 0.5;
      final halfSin = math.sin(theta) * 0.5;
      for (final sxSign in const [1, -1]) {
        for (final sySign in const [1, -1]) {
          emit(
            sxSign * halfCos,
            -sySign * halfSin,
            sxSign * halfSin,
            sySign * halfCos,
          );
        }
      }
    } else {
      // originalBox: unrotated corners (axis-aligned in world):
      //   corner = center ± (w/2, h/2). (aW = sx/2, bH = sy/2; aH = bW = 0.)
      for (final sxSign in const [1, -1]) {
        for (final sySign in const [1, -1]) {
          emit(sxSign * 0.5, 0, 0, sySign * 0.5);
        }
      }
    }

    buf.count = n;
  }

  /// Projects `(targetW, targetH)` onto the feasible region described by
  /// the flat inequality buffer [buf], intersected with `[minW, maxW] ×
  /// [minH, maxH]`. Writes results into [out] without allocating.
  ///
  /// The projection is L∞ (Chebyshev): each dimension is clamped
  /// independently where possible, and coupled-inequality violations are
  /// resolved by reducing the dimension whose current contribution to the
  /// violation is largest. Bounded in iterations; converges in practice in
  /// ≤4 passes for 4 corner inequalities.
  static void projectOntoFeasibleRegionFlat(
    IneqBuffer buf, {
    required FlatProjection out,
    required double targetW,
    required double targetH,
    required double minW,
    required double maxW,
    required double minH,
    required double maxH,
  }) {
    final data = buf.data;
    final n = buf.count;

    double w = targetW;
    double h = targetH;

    // Step 1: user min/max.
    if (w < minW) {
      w = minW;
    } else if (w > maxW) {
      w = maxW;
    }
    if (h < minH) {
      h = minH;
    } else if (h > maxH) {
      h = maxH;
    }

    // Step 2: unified violation loop.
    //
    // Each iteration finds the maximally-violated inequality across ALL rows
    // (w-only, h-only, and coupled) and applies the correct fix:
    //
    //   * w-only (b≈0):  set w = c/a (with sign handling), clamp.
    //   * h-only (a≈0):  set h = c/b, clamp.
    //   * coupled:       L2 (orthogonal) projection onto the constraint line,
    //                    clamp.
    //
    // The unified order matters: applying w/h-only constraints *before* the
    // coupled L2 step (as the previous two-step structure did) caused the L2
    // projection to start from a different point as the desired (w, h)
    // crossed an h-only bound, producing a non-monotonic projected dimension
    // as the cursor swept past the constraint corner. Driving everything off
    // the same violator-priority queue avoids that.
    //
    // For locked dimensions (minX == maxX) the L2 step degenerates to 1D
    // reduction of the unlocked axis.
    final bool wLocked = (maxW - minW).abs() < 1e-12;
    final bool hLocked = (maxH - minH).abs() < 1e-12;
    const maxIterations = 32;
    for (int iter = 0; iter < maxIterations; iter++) {
      int violatorIdx = -1;
      double maxOvershoot = 0;
      for (int i = 0; i < n; i++) {
        final a = data[3 * i];
        final b = data[3 * i + 1];
        final c = data[3 * i + 2];
        final over = a * w + b * h - c;
        // Sub-1e-9 residual is expected float-precision noise after an L2
        // projection; tighter thresholds re-trigger iteration and drift the
        // result.
        if (over > maxOvershoot + 1e-9) {
          maxOvershoot = over;
          violatorIdx = i;
        }
      }
      if (violatorIdx < 0) break;

      final a = data[3 * violatorIdx];
      final b = data[3 * violatorIdx + 1];
      final c = data[3 * violatorIdx + 2];
      final aAbs = a.abs();
      final bAbs = b.abs();

      if (bAbs < 1e-12) {
        // w-only.
        var newW = c / a;
        if (newW < minW) {
          newW = minW;
        } else if (newW > maxW) {
          newW = maxW;
        }
        w = newW;
      } else if (aAbs < 1e-12) {
        // h-only.
        var newH = c / b;
        if (newH < minH) {
          newH = minH;
        } else if (newH > maxH) {
          newH = maxH;
        }
        h = newH;
      } else if (wLocked && hLocked) {
        break;
      } else if (wLocked) {
        var newH = (c - a * w) / b;
        if (newH < minH) {
          newH = minH;
        } else if (newH > maxH) {
          newH = maxH;
        }
        h = newH;
      } else if (hLocked) {
        var newW = (c - b * h) / a;
        if (newW < minW) {
          newW = minW;
        } else if (newW > maxW) {
          newW = maxW;
        }
        w = newW;
      } else {
        final d = (a * w + b * h - c) / (a * a + b * b);
        var newW = w - d * a;
        var newH = h - d * b;
        bool wClamped = false;
        bool hClamped = false;
        if (newW < minW) {
          newW = minW;
          wClamped = true;
        } else if (newW > maxW) {
          newW = maxW;
          wClamped = true;
        }
        if (newH < minH) {
          newH = minH;
          hClamped = true;
        } else if (newH > maxH) {
          newH = maxH;
          hClamped = true;
        }
        // If the L2 step pushed one dim past its bound and got clamped, the
        // constraint may still be violated. Without a fallback, the next
        // iteration's L2 step has the saturated dim parked at its bound and
        // the projection becomes effectively 1D — but L2 with one dim
        // saturated converges slowly (~ 0.85^iter for typical geometries),
        // exceeding the 32-iter cap on harsh-delta force-flips. Resolve
        // exactly by 1D-projecting the unclamped dim.
        if (wClamped != hClamped && (a * newW + b * newH - c) > 1e-9) {
          if (wClamped && b.abs() > 1e-12) {
            var solvedH = (c - a * newW) / b;
            if (solvedH < minH) {
              solvedH = minH;
            } else if (solvedH > maxH) {
              solvedH = maxH;
            }
            newH = solvedH;
          } else if (hClamped && a.abs() > 1e-12) {
            var solvedW = (c - b * newH) / a;
            if (solvedW < minW) {
              solvedW = minW;
            } else if (solvedW > maxW) {
              solvedW = maxW;
            }
            newW = solvedW;
          }
        }
        w = newW;
        h = newH;
      }
    }

    // Compute the worst residual across all inequalities at the final
    // (w, h). The projection loop converges to ≤1e-9 when feasible; a
    // non-trivial residual here means the target (w, h) lies strictly
    // outside the feasible region — using (w, h) to build a rect would
    // leak the clamp by `residual` pixels. Callers read `out.feasible` to
    // decide whether to use the result or freeze the gesture.
    double residual = 0;
    for (int i = 0; i < n; i++) {
      final a = data[3 * i];
      final b = data[3 * i + 1];
      final c = data[3 * i + 2];
      final over = a * w + b * h - c;
      if (over > residual) residual = over;
    }
    out.feasible = residual <= 1e-3;
    out.worstResidual = residual;

    out.w = w;
    out.h = h;
    out.wMinHit = (w - minW).abs() < 1e-9;
    out.wMaxHit = maxW.isFinite && (w - maxW).abs() < 1e-9;
    out.hMinHit = (h - minH).abs() < 1e-9;
    out.hMaxHit = maxH.isFinite && (h - maxH).abs() < 1e-9;
  }
}
