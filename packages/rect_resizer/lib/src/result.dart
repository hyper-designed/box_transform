import 'enums.dart';
import 'geometry.dart';

class ResizeResult {
  /// The new [Rect] of the node after the resize.
  final Rect newRect;

  /// The old [Rect] of the node before the resize.
  final Rect oldRect;

  /// The [Flip] of the node after the resize.
  final Flip flip;

  /// The [ResizeMode] of the node after the resize.
  final ResizeMode resizeMode;

  /// The delta used to resize the node.
  final Offset delta;

  /// Creates a [ResizeResult] object.
  ResizeResult({
    required this.newRect,
    required this.oldRect,
    required this.flip,
    required this.resizeMode,
    required this.delta,
  });

  @override
  bool operator ==(Object other) {
    if (identical(this, other)) return true;

    return other is ResizeResult &&
        other.newRect == newRect &&
        other.oldRect == oldRect &&
        other.flip == flip &&
        other.resizeMode == resizeMode &&
        other.delta == delta;
  }

  @override
  int get hashCode => Object.hash(newRect, oldRect, flip, resizeMode, delta);

  @override
  String toString() {
    return 'ResizeResult(newRect: $newRect, oldRect: $oldRect, flip: $flip, resizeMode: $resizeMode, delta: $delta)';
  }
}
