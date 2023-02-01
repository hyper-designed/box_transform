import 'enums.dart';
import 'geometry.dart';
import 'result.dart';

/// main entry point.
class Resizer {
  /// Calculates what kind of flip should be applied to the [ResizeMode] for
  /// given [handle] and [localPosition].
  ///
  /// [mode] must be the [ResizeMode] that is being used. This determines
  /// whether ALT and/or SHIFT keys are pressed.
  ///
  /// [initialRect] must be the [Rect] of the [node] before the resize started.
  ///
  /// [localPosition] must be [PointerEvent.localPosition] of the event that
  /// triggered the resize.
  ///
  /// [handle] must be the [HandlePosition] that is being dragged.
  Flip calculateFlip({
    required ResizeMode mode,
    required Rect initialRect,
    required Offset localPosition,
    required HandlePosition handle,
  }) {
    double effectiveWidth = initialRect.width;
    double effectiveHeight = initialRect.height;
    if (mode.isSymmetricScale || mode.isSymmetric) {
      // Whether to flip or not is decided at half width because of symmetric
      // resizing.
      effectiveWidth = initialRect.width / 2;
      effectiveHeight = initialRect.height / 2;
    }
    final deltaX = effectiveWidth + localPosition.dx * (handle.isLeft ? -1 : 1);
    final deltaY = effectiveHeight + localPosition.dy * (handle.isTop ? -1 : 1);

    final bool isFlippedX = deltaX < 0;
    final bool isFlippedY = deltaY < 0;

    if (isFlippedX && !isFlippedY) {
      return Flip.horizontal;
    } else if (!isFlippedX && isFlippedY) {
      return Flip.vertical;
    } else if (isFlippedX && isFlippedY) {
      return Flip.diagonal;
    }
    return Flip.none;
  }

  ResizeResult resize({
    required Rect initialRect,
    required Offset initialLocalPosition,
    required Offset localPosition,
    required HandlePosition handle,
    required ResizeMode resizeMode,
  }) {
    Offset delta;
    if (handle.isLeft) {
      // Top left or bottom left.
      delta = initialLocalPosition - localPosition;
    } else {
      // Top right or bottom right.``
      delta = localPosition - initialLocalPosition;
    }

    // Multiply by 2 to make the resize symmetric.
    if (resizeMode.isSymmetric) delta = delta.scale(2, 2);

    double newWidth;
    double newHeight;
    if (initialRect.aspectRatio > 1) {
      newWidth = initialRect.width + delta.dx;
      newHeight = newWidth / initialRect.aspectRatio;
    } else {
      newHeight = initialRect.height + delta.dy;
      newWidth = newHeight * initialRect.aspectRatio;
    }

    final Flip flip = calculateFlip(
      mode: ResizeMode.symmetricScale,
      initialRect: initialRect,
      localPosition: localPosition,
      handle: handle,
    );

    final Rect newRect;

    if (resizeMode.isSymmetricScale || resizeMode.isSymmetric) {
      final double effectiveDeltaX =
          (newWidth.abs() / 2) * (flip.isFlippingOnX ? -1 : 1);
      final double effectiveDeltaY =
          newHeight.abs() / 2 * (flip.isFlippingOnY ? -1 : 1);
      newRect = Rect.fromCenter(
          center: initialRect.center,
          width: effectiveDeltaX,
          height: effectiveDeltaY);
    } else {
      switch (handle) {
        case HandlePosition.topLeft:
          newRect = handleTopLeft(
            newWidth: newWidth,
            newHeight: newHeight,
            flip: flip,
            initialRect: initialRect,
          );
          break;
        case HandlePosition.topRight:
          newRect = handleTopRight(
            newWidth: newWidth,
            newHeight: newHeight,
            flip: flip,
            initialRect: initialRect,
          );
          break;
        case HandlePosition.bottomLeft:
          newRect = handleBottomLeft(
            newWidth: newWidth,
            newHeight: newHeight,
            flip: flip,
            initialRect: initialRect,
          );
          break;
        case HandlePosition.bottomRight:
          newRect = handleBottomRight(
            newWidth: newWidth,
            newHeight: newHeight,
            flip: flip,
            initialRect: initialRect,
          );
          break;
      }
    }

    return ResizeResult(
      newRect: newRect,
      oldRect: initialRect,
      flip: flip,
      resizeMode: resizeMode,
      delta: delta,
    );
  }

  Rect handleTopLeft({
    required double newWidth,
    required double newHeight,
    required Flip flip,
    required Rect initialRect,
  }) {
    double left = initialRect.left;
    double right = initialRect.right;
    double top = initialRect.top;
    double bottom = initialRect.bottom;

    // Initial Anchor: bottom-right
    switch (flip) {
      case Flip.horizontal:
        // Anchor: bottom-right becomes bottom-left.
        bottom = initialRect.bottom;
        left = initialRect.right;
        right = left + newWidth.abs();
        top = bottom - newHeight.abs();
        break;
      case Flip.vertical:
        // Anchor: bottom-right becomes top-right.
        top = initialRect.bottom;
        right = initialRect.right;
        left = right - newWidth.abs();
        bottom = top + newHeight.abs();
        break;
      case Flip.diagonal:
        // Anchor: bottom-right becomes top-left.
        top = initialRect.bottom;
        left = initialRect.right;
        right = left + newWidth.abs();
        bottom = top + newHeight.abs();
        break;
      case Flip.none:
        // No flip.
        left = initialRect.right - newWidth;
        top = initialRect.bottom - newHeight;
        break;
    }
    return Rect.fromLTRB(left, top, right, bottom);
  }

  Rect handleTopRight({
    required double newWidth,
    required double newHeight,
    required Flip flip,
    required Rect initialRect,
  }) {
    double left = initialRect.left;
    double right = initialRect.right;
    double top = initialRect.top;
    double bottom = initialRect.bottom;

    // Initial Anchor: bottom-left
    switch (flip) {
      case Flip.horizontal:
        // Anchor: bottom-left becomes bottom-right.
        bottom = initialRect.bottom;
        right = initialRect.left;
        left = right - newWidth.abs();
        top = bottom - newHeight.abs();
        break;
      case Flip.vertical:
        // Anchor: bottom-left becomes top-left.
        top = initialRect.bottom;
        left = initialRect.left;
        right = left + newWidth.abs();
        bottom = top + newHeight.abs();
        break;
      case Flip.diagonal:
        // Anchor: bottom-left becomes top-right.
        top = initialRect.bottom;
        right = initialRect.left;
        left = right - newWidth.abs();
        bottom = top + newHeight.abs();
        break;
      case Flip.none:
        // No flip.
        right = initialRect.left + newWidth;
        top = initialRect.bottom - newHeight;
        break;
    }

    return Rect.fromLTRB(left, top, right, bottom);
  }

  Rect handleBottomRight({
    required double newWidth,
    required double newHeight,
    required Flip flip,
    required Rect initialRect,
  }) {
    double left = initialRect.left;
    double right = initialRect.right;
    double top = initialRect.top;
    double bottom = initialRect.bottom;

    // Initial Anchor: top-left
    switch (flip) {
      case Flip.horizontal:
        // Anchor: top-left becomes top-right.
        right = initialRect.left;
        top = initialRect.top;
        left = right - newWidth.abs();
        bottom = top + newHeight.abs();
        break;
      case Flip.vertical:
        // Anchor: top-left becomes bottom-left.
        left = initialRect.left;
        bottom = initialRect.top;
        right = left + newWidth.abs();
        top = bottom - newHeight.abs();
        break;
      case Flip.diagonal:
        // Anchor: top-left becomes bottom-right.
        right = initialRect.left;
        bottom = initialRect.top;
        left = right - newWidth.abs();
        top = bottom - newHeight.abs();
        break;
      case Flip.none:
        // No flip.
        right = initialRect.left + newWidth;
        bottom = initialRect.top + newHeight;
        break;
    }

    return Rect.fromLTRB(left, top, right, bottom);
  }

  Rect handleBottomLeft({
    required double newWidth,
    required double newHeight,
    required Flip flip,
    required Rect initialRect,
  }) {
    double left = initialRect.left;
    double right = initialRect.right;
    double top = initialRect.top;
    double bottom = initialRect.bottom;
    // Initial Anchor: top-right
    switch (flip) {
      case Flip.horizontal:
        // Anchor: top-right becomes top-left.
        left = initialRect.right;
        top = initialRect.top;
        right = left + newWidth.abs();
        bottom = bottom + newHeight.abs();
        break;
      case Flip.vertical:
        // Anchor: top-right becomes bottom-right.
        right = initialRect.right;
        bottom = initialRect.top;
        left = right - newWidth.abs();
        top = bottom - newHeight.abs();
        break;
      case Flip.diagonal:
        // Anchor: top-right becomes bottom-left.
        left = initialRect.right;
        bottom = initialRect.top;
        right = left + newWidth.abs();
        top = bottom - newHeight.abs();
        break;
      case Flip.none:
        // No flip.
        left = initialRect.right - newWidth;
        bottom = initialRect.top + newHeight;
        break;
    }
    return Rect.fromLTRB(left, top, right, bottom);
  }
}
