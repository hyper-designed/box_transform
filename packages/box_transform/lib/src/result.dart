import 'package:vector_math/vector_math.dart';

import 'enums.dart';
import 'geometry.dart';

/// An abstract class that represents the result of a transform operation.
abstract class BoxTransformResult {
  /// The new [Box] of the node after the resize.
  final Box newBox;

  /// The old [Box] of the node before the resize.
  final Box oldBox;

  /// The delta used to move the node.
  final Vector2 delta;

  const BoxTransformResult({
    required this.newBox,
    required this.oldBox,
    required this.delta,
  });

  @override
  bool operator ==(Object other) {
    if (identical(this, other)) return true;

    return other is MoveResult &&
        other.newBox == newBox &&
        other.oldBox == oldBox &&
        other.delta == delta;
  }

  @override
  int get hashCode => newBox.hashCode ^ oldBox.hashCode ^ delta.hashCode;

  @override
  String toString() =>
      'BoxTransformResult(newRect: $newBox, oldRect: $oldBox, delta: $delta)';
}

/// An object that represents the result of a move operation.
/// Helps disambiguate between [MoveResult] and [ResizeResult].
class MoveResult extends BoxTransformResult {
  /// Creates a [MoveResult] object.
  const MoveResult({
    required super.newBox,
    required super.oldBox,
    required super.delta,
  });
}

/// An object that represents the result of a resize operation.
class ResizeResult extends BoxTransformResult {
  /// The [Flip] of the node after the resize.
  final Flip flip;

  /// The [ResizeMode] of the node after the resize.
  final ResizeMode resizeMode;

  /// The new [Dimension] of the node after the resize. Unlike [newBox], this
  /// reflects flip state. For example, if the node is flipped horizontally,
  /// the width of the [newSize] will be negative.
  final Dimension newSize;

  /// Whether the resizing box hit its maximum possible width.
  final bool minWidthReached;

  /// Whether the resizing box hit its minimum possible width.
  final bool maxWidthReached;

  /// Whether the resizing box hit its maximum possible height.
  final bool minHeightReached;

  /// Whether the resizing box hit its minimum possible height.
  final bool maxHeightReached;

  /// Creates a [ResizeResult] object.
  const ResizeResult({
    required super.newBox,
    required super.oldBox,
    required super.delta,
    required this.flip,
    required this.resizeMode,
    required this.newSize,
    required this.minWidthReached,
    required this.maxWidthReached,
    required this.minHeightReached,
    required this.maxHeightReached,
  });

  @override
  bool operator ==(Object other) =>
      other is ResizeResult &&
      other.newBox == newBox &&
      other.oldBox == oldBox &&
      other.flip == flip &&
      other.resizeMode == resizeMode &&
      other.delta == delta &&
      other.newSize == newSize;

  @override
  int get hashCode =>
      Object.hash(newBox, oldBox, flip, resizeMode, delta, newSize);

  @override
  String toString() {
    return 'ResizeResult(newRect: $newBox, oldRect: $oldBox, flip: $flip, resizeMode: $resizeMode, delta: $delta, newSize: $newSize)';
  }
}
