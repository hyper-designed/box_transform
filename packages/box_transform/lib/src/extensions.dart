import 'dart:math' as math;

import 'package:vector_math/vector_math_64.dart';

import 'geometry.dart';
import 'result.dart';

/// Provides convenient getters for [TransformResult].
extension RawTransformResultExt on RawTransformResult {
  /// Convenient getter for the size of [rect].
  Dimension get size => rect.size;

  /// Convenient getter for the top-left of [rect].
  Vector2 get position => rect.topLeft;

  /// Convenient getter for the size of [oldRect].
  Dimension get oldSize => oldRect.size;

  /// Convenient getter for the top-left of [oldRect].
  Vector2 get oldPosition => oldRect.topLeft;
}

/// Pre-computed `10^n` for `n ∈ [0..9]`. Avoids both `math.pow` (which
/// promotes int→double on each call) and recomputation in the hot path.
const List<double> _kPowersOfTen = <double>[
  1.0,
  10.0,
  100.0,
  1000.0,
  10000.0,
  100000.0,
  1000000.0,
  10000000.0,
  100000000.0,
  1000000000.0,
];

/// Extensions for double.
extension DoubleExt on double {
  /// Rounds this double to [precision] decimal places.
  ///
  /// Implementation: scale by `10^precision`, round to the nearest integer
  /// (Dart's [num.round] rounds half-away-from-zero), then descale. This is
  /// ~25× faster than the previous `double.parse(toStringAsFixed(p))` form
  /// — the string round-trip dominated `isValidRect` in the AA-resize hot
  /// path. Note: differs from `toStringAsFixed` at exact halves
  /// (banker's-rounding vs away-from-zero), which is irrelevant to the
  /// tolerance-style comparisons this is used for.
  double roundToPrecision(int precision) {
    // Pass through non-finite (Infinity, -Infinity, NaN). `isValidRect` calls
    // this on `Constraints.maxWidth`/`maxHeight` which sentinel-encode "no
    // upper bound" as `double.infinity`; the old string round-trip handled
    // these gracefully via `double.parse("Infinity")`, but `infinity.round()`
    // throws.
    if (!isFinite) return this;
    final double mod = (precision >= 0 && precision < _kPowersOfTen.length)
        ? _kPowersOfTen[precision]
        : math.pow(10.0, precision).toDouble();
    return (this * mod).round() / mod;
  }
}
