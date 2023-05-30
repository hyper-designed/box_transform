part of 'resize_handler.dart';

/// Handles resizing for [ResizeMode.symmetric].
final class SymmetricResizeHandler extends ResizeHandler {
  /// A default constructor for [SymmetricResizeHandler].
  const SymmetricResizeHandler();

  @override
  (Box, Box, bool) resize({
    required Box initialRect,
    required Box explodedRect,
    required Box clampingRect,
    required HandlePosition handle,
    required Constraints constraints,
    required Flip flip,
  }) {
    final double horizontalMirrorRight =
        clampingRect.right - explodedRect.center.x;
    final double horizontalMirrorLeft =
        explodedRect.center.x - clampingRect.left;
    final double verticalMirrorTop = explodedRect.center.y - clampingRect.top;
    final double verticalMirrorBottom =
        clampingRect.bottom - explodedRect.center.y;

    Box area = Box.fromCenter(
      center: explodedRect.center,
      width: min(horizontalMirrorLeft, horizontalMirrorRight) * 2,
      height: min(verticalMirrorTop, verticalMirrorBottom) * 2,
    );

    if (!constraints.isUnconstrained) {
      final constrainedBox = Box.fromCenter(
        center: explodedRect.center,
        width: constraints.maxWidth,
        height: constraints.maxHeight,
      );

      area = Box.fromLTRB(
        max(area.left, constrainedBox.left),
        max(area.top, constrainedBox.top),
        min(area.right, constrainedBox.right),
        min(area.bottom, constrainedBox.bottom),
      );
    }

    final Box minRect = Box.fromCenter(
      center: explodedRect.center,
      width: constraints.isUnconstrained ? 0 : constraints.minWidth,
      height: constraints.isUnconstrained ? 0 : constraints.minHeight,
    );

    final Box newRect = Box.fromCenter(
      center: explodedRect.center,
      width: min(area.width, max(explodedRect.width, minRect.width)),
      height: min(area.height, max(explodedRect.height, minRect.height)),
    );

    return (newRect, area, true);
  }
}
