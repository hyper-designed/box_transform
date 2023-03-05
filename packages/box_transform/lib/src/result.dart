import 'package:vector_math/vector_math.dart';

import 'enums.dart';
import 'geometry.dart';
import 'transformer.dart';

/// A convenient typedef for [TransformResult] with [Box], [Vector2], and
/// [Dimension] as the generic types that is used by [BoxTransformer].
typedef RawMoveResult = MoveResult<Box, Vector2, Dimension>;

/// A convenient typedef for [TransformResult] with [Box], [Vector2], and
/// [Dimension] as the generic types that is used by [BoxTransformer].
typedef RawResizeResult = ResizeResult<Box, Vector2, Dimension>;

/// A convenient typedef for [TransformResult] with [Box], [Vector2], and
/// [Dimension] as the generic types that is used by [BoxTransformer].
typedef RawTransformResult = TransformResult<Box, Vector2, Dimension>;

/// An abstract class that represents the result of a transform operation.
abstract class RectResult {
  /// Creates a [RectResult].
  const RectResult();

  @override
  operator ==(Object other);

  @override
  int get hashCode;

  @override
  String toString();
}

/// An object that represents the result of a transform operation. Could be
/// resize or move or both.
///
/// B is the type of the [Box] that is used by the [BoxTransformer]. This is
/// usually [Box] or [Rect]. It represents the bounds of a rectangle.
///
/// V is the type of the [Vector2] that is used by the [BoxTransformer]. This is
/// usually [Vector2] or [Offset]. It represents the delta of the transform.
///
/// D is the type of the [Dimension] that is used by the [BoxTransformer]. This
/// is usually [Dimension] or [Size]. It represents the size of the box.
class TransformResult<B extends Object, V extends Object, D extends Object>
    extends RectResult {
  /// The new [Box] of the node after the resize.
  final B rect;

  /// The old [Box] of the node before the resize.
  final B oldRect;

  /// The delta used to move the node.
  final V delta;

  /// The [Flip] of the node after the resize.
  final Flip flip;

  /// The [ResizeMode] of the node after the resize.
  final ResizeMode resizeMode;

  /// The new [Dimension] of the node after the resize. Unlike [newRect], this
  /// reflects flip state. For example, if the node is flipped horizontally,
  /// the width of the [newSize] will be negative.
  final D rawSize;

  /// Whether the resizing box hit its maximum possible width.
  final bool minWidthReached;

  /// Whether the resizing box hit its minimum possible width.
  final bool maxWidthReached;

  /// Whether the resizing box hit its maximum possible height.
  final bool minHeightReached;

  /// Whether the resizing box hit its minimum possible height.
  final bool maxHeightReached;

  /// Creates a [ResizeResult] object.
  const TransformResult({
    required this.rect,
    required this.oldRect,
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
        other.rect == rect &&
        other.oldRect == oldRect &&
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
        rect,
        oldRect,
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
    return 'TransformResult(box: $rect, oldBox: $oldRect, flip: $flip, resizeMode: $resizeMode, delta: $delta, rawSize: $rawSize, minWidthReached: $minWidthReached, maxWidthReached: $maxWidthReached, minHeightReached: $minHeightReached, maxHeightReached: $maxHeightReached)';
  }
}

/// An object that represents the result of a move operation.
/// Helps disambiguate between [MoveResult] and [ResizeResult].
class MoveResult<B extends Object, V extends Object, D extends Object>
    extends TransformResult<B, V, D> {
  /// Creates a [MoveResult] object.
  const MoveResult({
    required super.rect,
    required super.oldRect,
    required super.delta,
    required super.rawSize,
  }) : super(
          flip: Flip.none,
          resizeMode: ResizeMode.freeform,
          minWidthReached: false,
          maxWidthReached: false,
          minHeightReached: false,
          maxHeightReached: false,
        );

  @override
  String toString() {
    return 'MoveResult(box: $rect, oldBox: $oldRect, delta: $delta)';
  }
}

/// An object that represents the result of a resize operation.
class ResizeResult<B extends Object, V extends Object, D extends Object>
    extends TransformResult<B, V, D> {
  /// Creates a [ResizeResult] object.
  const ResizeResult({
    required super.rect,
    required super.oldRect,
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
    return 'ResizeResult(box: $rect, oldBox: $oldRect, flip: $flip, resizeMode: $resizeMode, delta: $delta, rawSize: $rawSize, minWidthReached: $minWidthReached, maxWidthReached: $maxWidthReached, minHeightReached: $minHeightReached, maxHeightReached: $maxHeightReached)';
  }
}
