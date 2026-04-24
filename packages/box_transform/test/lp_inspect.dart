// Test-only inspection helpers for the rotated-clamping LP.
//
// Production callers use the flat-buffer hot path directly:
//   * `IneqBuffer` + `RotatedClampingSolver.buildCornerIneqsInto` /
//     `RotatedClampingSolver.buildSideHandleIneqsInto` /
//     `RotatedClampingSolver.buildCenterIneqsInto` to build inequalities
//     into a reused buffer.
//   * `FlatProjection` + `RotatedClampingSolver.projectOntoFeasibleRegionFlat`
//     to project a target (w, h) onto the feasible region without
//     allocation.
//
// Tests want an inspectable, allocation-friendly view: a list of
// `LinearInequality` triples and a `ProjectionResult` value type.
// Those representations live here, never in `lib/`.

import 'package:box_transform/box_transform.dart';
import 'package:vector_math/vector_math_64.dart';

/// A linear inequality of the form `a*w + b*h <= c`.
class LinearInequality {
  /// Coefficient of `w`.
  final double a;

  /// Coefficient of `h`.
  final double b;

  /// Upper bound.
  final double c;

  /// Creates a [LinearInequality] `a*w + b*h <= c`.
  const LinearInequality({required this.a, required this.b, required this.c});

  /// Evaluates `a*w + b*h`.
  double evaluate(double w, double h) => a * w + b * h;

  /// Returns true iff `a*w + b*h <= c` (with a small epsilon tolerance).
  bool isSatisfied(double w, double h, {double epsilon = 1e-9}) =>
      evaluate(w, h) <= c + epsilon;

  /// True if this inequality depends only on `w`.
  bool get isWOnly => b.abs() < 1e-12 && a.abs() > 1e-12;

  /// True if this inequality depends only on `h`.
  bool get isHOnly => a.abs() < 1e-12 && b.abs() > 1e-12;

  /// True if this inequality couples `w` and `h` (both coefficients nonzero).
  bool get isCoupled => a.abs() > 1e-12 && b.abs() > 1e-12;

  @override
  String toString() => 'LinearInequality(${a}w + ${b}h <= $c)';
}

/// Output of [projectOntoFeasibleRegion]: a feasible `(w, h)` pair, plus
/// flags indicating whether each dimension hit a min or max bound.
class ProjectionResult {
  /// Feasible unrotated width.
  final double w;

  /// Feasible unrotated height.
  final double h;

  /// True if [w] was pinned to the minimum-width bound.
  final bool wMinHit;

  /// True if [w] was pinned to the maximum-width bound.
  final bool wMaxHit;

  /// True if [h] was pinned to the minimum-height bound.
  final bool hMinHit;

  /// True if [h] was pinned to the maximum-height bound.
  final bool hMaxHit;

  /// Creates a [ProjectionResult].
  const ProjectionResult({
    required this.w,
    required this.h,
    required this.wMinHit,
    required this.wMaxHit,
    required this.hMinHit,
    required this.hMaxHit,
  });
}

/// Snapshots an [IneqBuffer] into a `List<LinearInequality>` so tests can
/// inspect coefficient triples directly.
List<LinearInequality> bufToList(IneqBuffer buf) {
  final data = buf.data;
  final n = buf.count;
  return List<LinearInequality>.generate(
    n,
    (i) => LinearInequality(
      a: data[3 * i],
      b: data[3 * i + 1],
      c: data[3 * i + 2],
    ),
  );
}

/// Test-side wrapper around
/// [RotatedClampingSolver.buildCornerIneqsInto].
List<LinearInequality> buildCornerInequalities({
  required Vector2 anchor,
  required double theta,
  required Box clampingRect,
  required BindingStrategy bindingStrategy,
  double widthSign = 1.0,
  double heightSign = 1.0,
}) {
  final buf = IneqBuffer();
  RotatedClampingSolver.buildCornerIneqsInto(
    buf,
    anchor: anchor,
    theta: theta,
    clampingRect: clampingRect,
    bindingStrategy: bindingStrategy,
    widthSign: widthSign,
    heightSign: heightSign,
  );
  return bufToList(buf);
}

/// Test-side wrapper around
/// [RotatedClampingSolver.buildCenterIneqsInto].
List<LinearInequality> buildCenterInequalities({
  required Vector2 center,
  required double theta,
  required Box clampingRect,
  required BindingStrategy bindingStrategy,
}) {
  final buf = IneqBuffer();
  RotatedClampingSolver.buildCenterIneqsInto(
    buf,
    center: center,
    theta: theta,
    clampingRect: clampingRect,
    bindingStrategy: bindingStrategy,
  );
  return bufToList(buf);
}

/// Test-side wrapper around
/// [RotatedClampingSolver.projectOntoFeasibleRegionFlat].
ProjectionResult projectOntoFeasibleRegion(
  List<LinearInequality> inequalities, {
  required double targetW,
  required double targetH,
  required double minW,
  required double maxW,
  required double minH,
  required double maxH,
}) {
  final buf = IneqBuffer();
  final n = inequalities.length <= buf.data.length ~/ 3
      ? inequalities.length
      : buf.data.length ~/ 3;
  final data = buf.data;
  for (int i = 0; i < n; i++) {
    final ineq = inequalities[i];
    data[3 * i] = ineq.a;
    data[3 * i + 1] = ineq.b;
    data[3 * i + 2] = ineq.c;
  }
  buf.count = n;

  final out = FlatProjection();
  RotatedClampingSolver.projectOntoFeasibleRegionFlat(
    buf,
    out: out,
    targetW: targetW,
    targetH: targetH,
    minW: minW,
    maxW: maxW,
    minH: minH,
    maxH: maxH,
  );
  return ProjectionResult(
    w: out.w,
    h: out.h,
    wMinHit: out.wMinHit,
    wMaxHit: out.wMaxHit,
    hMinHit: out.hMinHit,
    hMaxHit: out.hMaxHit,
  );
}
