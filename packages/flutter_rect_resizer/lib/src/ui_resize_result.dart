import 'dart:ui' as ui;

import 'package:rect_resizer/rect_resizer.dart' as resizer;

/// A Flutter translation of a [resizer.MoveResult].
class UIMoveResult {
  /// The new [Rect] of the node after the move.
  final ui.Rect newRect;

  /// The old [Rect] of the node before the move.
  final ui.Rect oldRect;

  /// The delta used to move the node.
  final ui.Offset delta;

  /// Creates a [UIMoveResult] object.
  UIMoveResult({
    required this.newRect,
    required this.oldRect,
    required this.delta,
  });

  @override
  bool operator ==(Object other) =>
      other is UIMoveResult &&
      other.newRect == newRect &&
      other.oldRect == oldRect &&
      other.delta == delta;

  @override
  int get hashCode => newRect.hashCode ^ oldRect.hashCode ^ delta.hashCode;

  @override
  String toString() =>
      'UIMoveResult(newRect: $newRect, oldRect: $oldRect, delta: $delta)';
}

/// A Flutter translation of a [resizer.ResizeResult].
class UIResizeResult {
  /// The new [Rect] of the node after the resize.
  final ui.Rect newRect;

  /// The old [Rect] of the node before the resize.
  final ui.Rect oldRect;

  /// The [Flip] of the node after the resize.
  final resizer.Flip flip;

  /// The [ResizeMode] of the node after the resize.
  final resizer.ResizeMode resizeMode;

  /// The delta used to resize the node.
  final ui.Offset delta;

  /// The new size of the node after the resize.
  final ui.Size newSize;

  /// Creates a [UIResizeResult] object.
  UIResizeResult({
    required this.newRect,
    required this.oldRect,
    required this.flip,
    required this.resizeMode,
    required this.delta,
    required this.newSize,
  });

  @override
  bool operator ==(Object other) =>
      other is UIResizeResult &&
      other.newRect == newRect &&
      other.oldRect == oldRect &&
      other.flip == flip &&
      other.resizeMode == resizeMode &&
      other.delta == delta &&
      other.delta == newSize;

  @override
  int get hashCode =>
      Object.hash(newRect, oldRect, flip, resizeMode, delta, newSize);

  @override
  String toString() {
    return 'FlutterResizeResult(newRect: $newRect, oldRect: $oldRect, flip: $flip, resizeMode: $resizeMode, delta: $delta, newSize: $newSize)';
  }
}
