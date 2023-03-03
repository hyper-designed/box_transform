import 'dart:ui' as ui;

import 'package:box_transform/box_transform.dart' as transform;

/// An abstract class that represents the result of a transform operation.
abstract class UIResult {
  const UIResult();

  @override
  bool operator ==(Object other);

  @override
  int get hashCode;

  @override
  String toString();
}

/// A Flutter translation of a [transform.ResizeResult].
class UIResizeResult extends UITransformResult {
  /// Creates a [UIMoveResult] object.
  UIResizeResult({
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
    return 'UIResizeResult(rect: $rect, oldRect: $oldRect, flip: $flip, resizeMode: $resizeMode, delta: $delta, rawSize: $rawSize, minWidthReached: $minWidthReached, maxWidthReached: $maxWidthReached, minHeightReached: $minHeightReached, maxHeightReached: $maxHeightReached)';
  }
}

/// A Flutter translation of a [transform.MoveResult].
class UIMoveResult extends UITransformResult {
  @override
  ui.Size get rawSize => rect.size;

  /// Creates a [UIMoveResult] object.
  const UIMoveResult({
    required super.rect,
    required super.oldRect,
    required super.delta,
  }) : super(
          flip: transform.Flip.none,
          resizeMode: transform.ResizeMode.freeform,
          rawSize: ui.Size.zero,
          minWidthReached: false,
          maxWidthReached: false,
          minHeightReached: false,
          maxHeightReached: false,
        );

  @override
  String toString() =>
      'UIMoveResult(rect: $rect, oldRect: $oldRect, delta: $delta)';
}

/// A Flutter translation of a [transform.TransformResult].
class UITransformResult extends UIResult {
  /// The new [Rect] of the node after the move.
  final ui.Rect rect;

  /// The old [Rect] of the node before the move.
  final ui.Rect oldRect;

  /// The delta used to move the node.
  final ui.Offset delta;

  /// The [Flip] of the node after the resize.
  final transform.Flip flip;

  /// The [ResizeMode] of the node after the resize.
  final transform.ResizeMode resizeMode;

  /// The new size of the node after the resize.
  final ui.Size rawSize;

  /// Whether the resizing box hit its maximum possible width.
  final bool minWidthReached;

  /// Whether the resizing box hit its minimum possible width.
  final bool maxWidthReached;

  /// Whether the resizing box hit its maximum possible height.
  final bool minHeightReached;

  /// Whether the resizing box hit its minimum possible height.
  final bool maxHeightReached;

  /// Convenient getter for [rect.size].
  ui.Size get size => rect.size;

  /// Convenient getter for [rect.topLeft].
  ui.Offset get position => rect.topLeft;

  /// Convenient getter for [oldRect.size].
  ui.Size get oldSize => oldRect.size;

  /// Convenient getter for [oldRect.topLeft].
  ui.Offset get oldPosition => oldRect.topLeft;

  /// Creates a [UITransformResult] object.
  const UITransformResult({
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

    return other is UITransformResult &&
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
    return 'UITransformResult(rect: $rect, oldRect: $oldRect, flip: $flip, resizeMode: $resizeMode, delta: $delta, rawSize: $rawSize, minWidthReached: $minWidthReached, maxWidthReached: $maxWidthReached, minHeightReached: $minHeightReached, maxHeightReached: $maxHeightReached)';
  }
}
