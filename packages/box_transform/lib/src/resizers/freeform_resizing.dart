part of 'resizer.dart';

/// Handles resizing for [ResizeMode.freeform].
final class FreeformResizer extends Resizer {
  /// A default constructor for [FreeformResizer].
  const FreeformResizer();

  @override
  ({Box rect, Box largest, bool hasValidFlip}) resize({
    required Box initialRect,
    required Box explodedRect,
    required Box clampingRect,
    required HandlePosition handle,
    required Constraints constraints,
    required Flip flip,
    required double rotation,
    required BindingStrategy bindingStrategy,
  }) {
    final Box effectiveInitialRect = flipRect(initialRect, flip, handle);
    final Box initialBoundingRect = BoxTransformer.calculateBoundingRect(
      rotation: rotation,
      unrotatedBox: effectiveInitialRect,
    );

    final flippedHandle = handle.flip(flip);

    final Box effectiveInitialBoundingRect =
        flipRect(initialBoundingRect, flip, handle);

    Box newRect = Box.fromLTRB(
      max(explodedRect.left, clampingRect.left),
      max(explodedRect.top, clampingRect.top),
      min(explodedRect.right, clampingRect.right),
      min(explodedRect.bottom, clampingRect.bottom),
    );
    Box newBoundingRect = BoxTransformer.calculateBoundingRect(
      rotation: rotation,
      unrotatedBox: newRect,
    );

    bool isValid = true;
    if (!constraints.isUnconstrained) {
      final bindingRect = bindingStrategy == BindingStrategy.originalBox
          ? newRect
          : newBoundingRect;

      final Dimension constrainedSize = Dimension(
        bindingRect.width.clamp(constraints.minWidth, constraints.maxWidth),
        bindingRect.height.clamp(constraints.minHeight, constraints.maxHeight),
      );
      final Dimension constrainedDelta = Dimension(
        constrainedSize.width - bindingRect.width,
        constrainedSize.height - bindingRect.height,
      );

      newRect = Box.fromHandle(
        flippedHandle.anchor(effectiveInitialRect),
        flippedHandle,
        newRect.width + constrainedDelta.width,
        newRect.height + constrainedDelta.height,
      );
      newBoundingRect = Box.fromHandle(
        flippedHandle.anchor(effectiveInitialBoundingRect),
        flippedHandle,
        newBoundingRect.width + constrainedDelta.width,
        newBoundingRect.height + constrainedDelta.height,
      );

      isValid = isValidRect(
        switch (bindingStrategy) {
          BindingStrategy.originalBox => newRect,
          BindingStrategy.boundingBox => newBoundingRect,
        },
        constraints,
        clampingRect,
      );
      if (!isValid) {
        newRect = Box.fromHandle(
          handle.anchor(initialRect),
          handle,
          !handle.isSide || handle.isHorizontal
              ? constraints.minWidth
              : newRect.width,
          !handle.isSide || handle.isVertical
              ? constraints.minHeight
              : newRect.height,
        );
        newBoundingRect = Box.fromHandle(
          handle.anchor(initialBoundingRect),
          handle,
          !handle.isSide || handle.isHorizontal
              ? constraints.minWidth
              : newBoundingRect.width,
          !handle.isSide || handle.isVertical
              ? constraints.minHeight
              : newBoundingRect.height,
        );
      }
    }

    if (rotation != 0) {
      final Vector2 positionDelta = newRect.topLeft - initialRect.topLeft;
      final Vector2 newPos = BoxTransformer.calculateUnrotatedPos(
        initialRect,
        rotation,
        positionDelta,
        newRect.size,
      );
      newRect = Box.fromLTWH(newPos.x, newPos.y, newRect.width, newRect.height);
    }

    final Box effectiveBindingRect = switch (bindingStrategy) {
      BindingStrategy.originalBox => effectiveInitialRect,
      BindingStrategy.boundingBox => effectiveInitialBoundingRect,
    };
    final Box bindingRect = switch (bindingStrategy) {
      BindingStrategy.originalBox => initialRect,
      BindingStrategy.boundingBox => initialBoundingRect,
    };

    // Only used for calculating the correct largest box.
    final Box area = getAvailableAreaForHandle(
      rect: isValid ? effectiveBindingRect : bindingRect,
      handle: isValid ? flippedHandle : handle,
      clampingRect: clampingRect,
    );

    return (rect: newRect, largest: area, hasValidFlip: isValid);
  }
}
