import 'package:vector_math/vector_math.dart';

import 'enums.dart';
import 'geometry.dart';

/// An abstract class that represents the result of a transform operation.
abstract class BoxResult {
  const BoxResult();

  @override
  operator ==(Object other);

  @override
  int get hashCode;

  @override
  String toString();
}

/// An object that represents the result of a transform operation. Could be
/// resize or move or both.
class TransformResult extends BoxResult {
  /// The new [Box] of the node after the resize.
  final Box box;

  /// The old [Box] of the node before the resize.
  final Box oldBox;

  /// The delta used to move the node.
  final Vector2 delta;

  /// The [Flip] of the node after the resize.
  final Flip flip;

  /// The [ResizeMode] of the node after the resize.
  final ResizeMode resizeMode;

  /// The new [Dimension] of the node after the resize. Unlike [newBox], this
  /// reflects flip state. For example, if the node is flipped horizontally,
  /// the width of the [newSize] will be negative.
  final Dimension rawSize;

  /// Whether the resizing box hit its maximum possible width.
  final bool minWidthReached;

  /// Whether the resizing box hit its minimum possible width.
  final bool maxWidthReached;

  /// Whether the resizing box hit its maximum possible height.
  final bool minHeightReached;

  /// Whether the resizing box hit its minimum possible height.
  final bool maxHeightReached;

  /// Convenient getter for [box.size].
  Dimension get size => box.size;

  /// Convenient getter for [box.topLeft].
  Vector2 get position => box.topLeft;

  /// Convenient getter for [oldBox.size].
  Dimension get oldSize => oldBox.size;

  /// Convenient getter for [oldBox.topLeft].
  Vector2 get oldPosition => oldBox.topLeft;

  /// Creates a [ResizeResult] object.
  const TransformResult({
    required this.box,
    required this.oldBox,
    required this.delta,
    required this.flip,
    required this.resizeMode,
    required this.rawSize,
    required this.minWidthReached,
    required this.maxWidthReached,
    required this.minHeightReached,
    required this.maxHeightReached,
  });

  @override
  bool operator ==(Object other) {
    if (identical(this, other)) return true;

    return other is TransformResult &&
        other.box == box &&
        other.oldBox == oldBox &&
        other.delta == delta &&
        other.flip == flip &&
        other.resizeMode == resizeMode &&
        other.rawSize == rawSize &&
        other.minWidthReached == minWidthReached &&
        other.maxWidthReached == maxWidthReached &&
        other.minHeightReached == minHeightReached &&
        other.maxHeightReached == maxHeightReached;
  }

  @override
  int get hashCode => Object.hash(
        box,
        oldBox,
        delta,
        flip,
        resizeMode,
        rawSize,
        minWidthReached,
        maxWidthReached,
        minHeightReached,
        maxHeightReached,
      );

  @override
  String toString() {
    return 'TransformResult(box: $box, oldBox: $oldBox, flip: $flip, resizeMode: $resizeMode, delta: $delta, rawSize: $rawSize, minWidthReached: $minWidthReached, maxWidthReached: $maxWidthReached, minHeightReached: $minHeightReached, maxHeightReached: $maxHeightReached)';
  }
}

/// An object that represents the result of a move operation.
/// Helps disambiguate between [MoveResult] and [ResizeResult].
class MoveResult extends TransformResult {
  @override
  Dimension get rawSize => box.size;

  /// Creates a [MoveResult] object.
  const MoveResult({
    required super.box,
    required super.oldBox,
    required super.delta,
  }) : super(
          flip: Flip.none,
          resizeMode: ResizeMode.freeform,
          rawSize: Dimension.zero,
          minWidthReached: false,
          maxWidthReached: false,
          minHeightReached: false,
          maxHeightReached: false,
        );

  @override
  String toString() {
    return 'MoveResult(box: $box, oldBox: $oldBox, delta: $delta)';
  }
}

/// An object that represents the result of a resize operation.
class ResizeResult extends TransformResult {
  const ResizeResult({
    required super.box,
    required super.oldBox,
    required super.delta,
    required super.flip,
    required super.resizeMode,
    required super.rawSize,
    required super.minWidthReached,
    required super.maxWidthReached,
    required super.minHeightReached,
    required super.maxHeightReached,
  });

  @override
  String toString() {
    return 'ResizeResult(box: $box, oldBox: $oldBox, flip: $flip, resizeMode: $resizeMode, delta: $delta, rawSize: $rawSize, minWidthReached: $minWidthReached, maxWidthReached: $maxWidthReached, minHeightReached: $minHeightReached, maxHeightReached: $maxHeightReached)';
  }
}
