import 'dart:ui' as ui;

import 'package:rect_resizer/rect_resizer.dart' as resizer;

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
  bool operator ==(Object other) {
    if (identical(this, other)) return true;

    return other is UIResizeResult &&
        other.newRect == newRect &&
        other.oldRect == oldRect &&
        other.flip == flip &&
        other.resizeMode == resizeMode &&
        other.delta == delta &&
        other.delta == newSize;
  }

  @override
  int get hashCode =>
      Object.hash(newRect, oldRect, flip, resizeMode, delta, newSize);

  @override
  String toString() {
    return 'FlutterResizeResult(newRect: $newRect, oldRect: $oldRect, flip: $flip, resizeMode: $resizeMode, delta: $delta, newSize: $newSize)';
  }
}
