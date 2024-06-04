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
    final Box effectiveInitialBoundingRect =
        flipRect(initialBoundingRect, flip, handle);

    final HandlePosition flippedHandle = handle.flip(flip);

    Box newRect = explodedRect;
    newRect = repositionRotatedResizedBox(
      newRect: newRect,
      initialRect: initialRect,
      rotation: rotation,
    );
    Box newBoundingRect = BoxTransformer.calculateBoundingRect(
      rotation: rotation,
      unrotatedBox: newRect,
    );
    final bool isClamped = isRectClamped(
      newBoundingRect,
      // switch (bindingStrategy) {
      //   BindingStrategy.originalBox => newRect,
      //   BindingStrategy.boundingBox => newBoundingRect,
      // },
      clampingRect,
    );
    if (!isClamped) {
      final Vector2 correctiveDelta = BoxTransformer.stopRectAtClampingRect(
        rect: newRect,
        clampingRect: clampingRect,
        rotation: rotation,
      );

      newRect = BoxTransformer.applyDelta(
        initialRect: newRect,
        delta: correctiveDelta,
        handle: handle,
        resizeMode: ResizeMode.scale,
        allowFlipping: false,
      );

      newBoundingRect = BoxTransformer.calculateBoundingRect(
        rotation: rotation,
        unrotatedBox: newRect,
      );
    }

    bool isBound = false;
    if (!constraints.isUnconstrained) {
      final Dimension constrainedSize = Dimension(
        newRect.width.clamp(constraints.minWidth, constraints.maxWidth),
        newRect.height.clamp(constraints.minHeight, constraints.maxHeight),
      );
      final Dimension constrainedDelta = Dimension(
        constrainedSize.width - newRect.width,
        constrainedSize.height - newRect.height,
      );

      newRect = Box.fromHandle(
        flippedHandle.anchor(effectiveInitialRect),
        flippedHandle,
        newRect.width + constrainedDelta.width,
        newRect.height + constrainedDelta.height,
      );
      newRect = repositionRotatedResizedBox(
        newRect: newRect,
        initialRect: initialRect,
        rotation: rotation,
      );
      newBoundingRect = BoxTransformer.calculateBoundingRect(
        rotation: rotation,
        unrotatedBox: newRect,
      );

      isBound = isRectConstrained(
        newRect,
        constraints,
      );

      if (!isBound) {
        newRect = Box.fromHandle(
          handle.anchor(initialRect),
          handle,
          handle.influencesHorizontal
              ? constraints.minWidth
              : constrainedSize.width,
          handle.influencesVertical
              ? constraints.minHeight
              : constrainedSize.height,
        );
        newRect = repositionRotatedResizedBox(
          newRect: newRect,
          initialRect: initialRect,
          rotation: rotation,
        );
        newBoundingRect = BoxTransformer.calculateBoundingRect(
          rotation: rotation,
          unrotatedBox: newRect,
        );
      }
    }

    if (rotation != 0) {
      // final Vector2 positionDelta = newRect.topLeft - initialRect.topLeft;
      // final Vector2 newPos = BoxTransformer.calculateUnrotatedPos(
      //   initialRect,
      //   rotation,
      //   positionDelta,
      //   newRect.size,
      // );
      // newRect = Box.fromLTWH(newPos.x, newPos.y, newRect.width, newRect.height);
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
      rect: isBound ? effectiveBindingRect : bindingRect,
      handle: isBound ? flippedHandle : handle,
      clampingRect: clampingRect,
    );

    return (rect: newRect, largest: area, hasValidFlip: isBound);
  }

  Box repositionRotatedResizedBox({
    required Box newRect,
    required Box initialRect,
    required double rotation,
  }) {
    if (rotation == 0) return initialRect;

    final Vector2 positionDelta = newRect.topLeft - initialRect.topLeft;
    final Vector2 newPos = BoxTransformer.calculateUnrotatedPos(
      initialRect,
      rotation,
      positionDelta,
      newRect.size,
    );
    return Box.fromLTWH(newPos.x, newPos.y, newRect.width, newRect.height);
  }
}
