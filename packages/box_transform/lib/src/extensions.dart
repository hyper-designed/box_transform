import 'package:vector_math/vector_math.dart';

import 'geometry.dart';
import 'result.dart';

/// Provides convenient getters for [TransformResult].
extension RawTransformResultExt on RawTransformResult {
  /// Convenient getter for [box.size].
  Dimension get size => rect.size;

  /// Convenient getter for [box.topLeft].
  Vector2 get position => rect.topLeft;

  /// Convenient getter for [oldBox.size].
  Dimension get oldSize => oldRect.size;

  /// Convenient getter for [oldBox.topLeft].
  Vector2 get oldPosition => oldRect.topLeft;
}

/// Extensions for double.
extension DoubleExt on double {
  /// Rounds a double to the given precision.
  double roundToPrecision(int precision) =>
      double.parse((this).toStringAsFixed(precision));
}