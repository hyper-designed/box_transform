part of 'resize_handler.dart';

/// Handles resizing for [ResizeMode.freeform].
final class FreeformResizeHandler extends ResizeHandler {
  /// A default constructor for [FreeformResizeHandler].
  const FreeformResizeHandler();

  @override
  (Box rect, Box largest, bool hasValidFlip) resize({
    required Box initialRect,
    required Box explodedRect,
    required Box clampingRect,
    required HandlePosition handle,
    required Constraints constraints,
    required Flip flip,
  }) {
    final flippedHandle = handle.flip(flip);
    Box effectiveInitialRect = flipBox(initialRect, flip, handle);

    Box newRect = Box.fromLTRB(
      max(explodedRect.left, clampingRect.left),
      max(explodedRect.top, clampingRect.top),
      min(explodedRect.right, clampingRect.right),
      min(explodedRect.bottom, clampingRect.bottom),
    );

    bool isValid = true;
    if (!constraints.isUnconstrained) {
      final constrainedWidth =
      newRect.width.clamp(constraints.minWidth, constraints.maxWidth);
      final constrainedHeight =
      newRect.height.clamp(constraints.minHeight, constraints.maxHeight);

      newRect = Box.fromHandle(
        flippedHandle.anchor(effectiveInitialRect),
        flippedHandle,
        constrainedWidth,
        constrainedHeight,
      );

      isValid = isValidBox(newRect, constraints, clampingRect);
      if (!isValid) {
        newRect = Box.fromHandle(
          handle.anchor(initialRect),
          handle,
          !handle.isSide || handle.isHorizontal
              ? constraints.minWidth
              : constrainedWidth,
          !handle.isSide || handle.isVertical
              ? constraints.minHeight
              : constrainedHeight,
        );
      }
    }

    // Not used but calculating it for returning correct largest box.
    final Box area = getAvailableAreaForHandle(
      rect: isValid ? effectiveInitialRect : initialRect,
      handle: isValid ? flippedHandle : handle,
      clampingRect: clampingRect,
    );

    return (newRect, area, isValid);
  }
}
