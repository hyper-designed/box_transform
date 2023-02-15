import 'package:vector_math/vector_math.dart';

import 'enums.dart';
import 'geometry.dart';
import 'result.dart';

/// A class that resizes a [Box] in several different supported forms.
class RectResizer {
  /// Calculates the new position of the [initialRect] based on the
  /// [initialLocalPosition] of the mouse cursor and wherever [localPosition]
  /// of the mouse cursor is currently at.
  ///
  /// The [clampingBox] is the box that the [initialRect] is not allowed
  /// to go outside of when dragging or resizing.
  MoveResult move({
    required Box initialRect,
    required Vector2 initialLocalPosition,
    required Vector2 localPosition,
    Box clampingBox = Box.largest,
  }) {
    final Vector2 delta = localPosition - initialLocalPosition;

    final Box unclampedRect = initialRect.translate(delta.x, delta.y);
    final Box clampedRect = clampingBox.containOther(unclampedRect);
    final Vector2 clampedDelta = clampedRect.topLeft - initialRect.topLeft;

    final Box newRect = initialRect.translate(clampedDelta.x, clampedDelta.y);

    return MoveResult(
      newRect: newRect,
      oldRect: initialRect,
      delta: delta,
    );
  }

  /// Resizes the given [initialRect] with given [initialLocalPosition] of
  /// the mouse cursor and wherever [localPosition] of the mouse cursor is
  /// currently at.
  ///
  /// Specifying the [handle] and [resizeMode] will determine how the
  /// [initialRect] will be resized.
  ///
  /// The [initialFlip] helps determine the initial state of the rectangle.
  ///
  /// The [clampingBox] is the box that the [initialRect] is not allowed
  /// to go outside of when dragging or resizing.
  ///
  /// The [constraints] is the constraints that the [initialRect] is not allowed
  /// to shrink or grow beyond.
  ResizeResult resize({
    required Box initialRect,
    required Vector2 initialLocalPosition,
    required Vector2 localPosition,
    required HandlePosition handle,
    required ResizeMode resizeMode,
    required Flip initialFlip,
    Box clampingBox = Box.largest,
    Constraints constraints = const Constraints.unconstrained(),
  }) {
    final Flip currentFlip =
        getFlipForRect(initialRect, localPosition, handle, resizeMode);

    Vector2 delta = localPosition - initialLocalPosition;

    if (resizeMode.hasSymmetry) delta = Vector2(delta.x * 2, delta.y * 2);

    final Dimension newSize = _calculateNewSize(
      initialRect: initialRect,
      handle: handle,
      delta: delta,
      flip: currentFlip,
      resizeMode: resizeMode,
      clampingBox: clampingBox,
      constraints: constraints,
    );
    final double newWidth = newSize.width.abs();
    final double newHeight = newSize.height.abs();

    Box newRect;
    if (resizeMode.hasSymmetry) {
      newRect = Box.fromCenter(
          center: initialRect.center, width: newWidth, height: newHeight);
    } else {
      Box rect = Box.fromLTWH(
        handle.influencesLeft ? initialRect.right - newWidth : initialRect.left,
        handle.influencesTop ? initialRect.bottom - newHeight : initialRect.top,
        newWidth,
        newHeight,
      );

      newRect = flipRect(rect, currentFlip, handle);
    }

    newRect = clampingBox.containOther(newRect);

    // Detect terminal resizing, where the resizing reached a hard limit.
    bool minWidthReached = false;
    bool maxWidthReached = false;
    bool minHeightReached = false;
    bool maxHeightReached = false;
    if (delta.x != 0) {
      if (newRect.width <= initialRect.width &&
          newRect.width == constraints.minWidth) {
        minWidthReached = true;
      }
      if (newRect.width >= initialRect.width &&
          (newRect.width == constraints.maxWidth || newRect.width == clampingBox.width)) {
        maxWidthReached = true;
      }
    }
    if (delta.y != 0) {
      if (newRect.height <= initialRect.height &&
          newRect.height == constraints.minHeight) {
        minHeightReached = true;
      }
      if (newRect.height >= initialRect.height &&
          newRect.height == constraints.maxHeight || newRect.height == clampingBox.height) {
        maxHeightReached = true;
      }
    }

    return ResizeResult(
      newBox: newRect,
      oldBox: initialRect,
      flip: currentFlip * initialFlip,
      resizeMode: resizeMode,
      delta: delta,
      newSize: newSize,
      minWidthReached: minWidthReached,
      maxWidthReached: maxWidthReached,
      minHeightReached: minHeightReached,
      maxHeightReached: maxHeightReached,
    );
  }

  /// Flips the given [rect] with given [flip] with [handle] being the
  /// pivot point.
  Box flipRect(Box rect, Flip flip, HandlePosition handle) {
    switch (handle) {
      case HandlePosition.topLeft:
        return rect.translate(
          flip.isHorizontal ? rect.width : 0,
          flip.isVertical ? rect.height : 0,
        );
      case HandlePosition.topRight:
        return rect.translate(
          flip.isHorizontal ? -rect.width : 0,
          flip.isVertical ? rect.height : 0,
        );
      case HandlePosition.bottomLeft:
        return rect.translate(
          flip.isHorizontal ? rect.width : 0,
          flip.isVertical ? -rect.height : 0,
        );
      case HandlePosition.bottomRight:
        return rect.translate(
          flip.isHorizontal ? -rect.width : 0,
          flip.isVertical ? -rect.height : 0,
        );
    }
  }

  /// Calculates flip state of the given [rect] w.r.t [localPosition] and
  /// [handle]. It uses [handle] and [localPosition] to determine the quadrant
  /// of the [rect] and then checks if the [rect] is flipped in that quadrant.
  Flip getFlipForRect(
    Box rect,
    Vector2 localPosition,
    HandlePosition handle,
    ResizeMode resizeMode,
  ) {
    final double widthFactor = resizeMode.hasSymmetry ? 0.5 : 1;
    final double heightFactor = resizeMode.hasSymmetry ? 0.5 : 1;

    final double effectiveWidth = rect.width * widthFactor;
    final double effectiveHeight = rect.height * heightFactor;

    final double handleXFactor = handle.influencesLeft ? -1 : 1;
    final double handleYFactor = handle.influencesTop ? -1 : 1;

    final double posX = effectiveWidth + localPosition.x * handleXFactor;
    final double posY = effectiveHeight + localPosition.y * handleYFactor;

    return Flip.fromValue(posX, posY);
  }

  Dimension _calculateNewSize({
    required Box initialRect,
    required HandlePosition handle,
    required Vector2 delta,
    required Flip flip,
    required ResizeMode resizeMode,
    Box clampingBox = Box.largest,
    Constraints constraints = const Constraints.unconstrained(),
  }) {
    final double aspectRatio = initialRect.width / initialRect.height;

    initialRect = flipRect(initialRect, flip, handle);
    Box rect;
    rect = Box.fromLTRB(
      initialRect.left + (handle.influencesLeft ? delta.x : 0),
      initialRect.top + (handle.influencesTop ? delta.y : 0),
      initialRect.right + (handle.influencesRight ? delta.x : 0),
      initialRect.bottom + (handle.influencesBottom ? delta.y : 0),
    );
    if (resizeMode.hasSymmetry) {
      final widthDelta = (initialRect.width - rect.width) / 2;
      final heightDelta = (initialRect.height - rect.height) / 2;
      rect = Box.fromLTRB(
        initialRect.left + widthDelta,
        initialRect.top + heightDelta,
        initialRect.right - widthDelta,
        initialRect.bottom - heightDelta,
      );
    }

    rect = clampingBox.containOther(
      rect,
      resizeMode: resizeMode,
      aspectRatio: aspectRatio,
    );
    rect = constraints.constrainBox(rect);

    final double newWidth;
    final double newHeight;
    final newAspectRatio = rect.width / rect.height;

    if (resizeMode.isScalable) {
      if (newAspectRatio.abs() < aspectRatio.abs()) {
        newHeight = rect.height;
        newWidth = newHeight * aspectRatio;
      } else {
        newWidth = rect.width;
        newHeight = newWidth / aspectRatio;
      }
    } else {
      newWidth = rect.width;
      newHeight = rect.height;
    }

    return Dimension(
      newWidth.abs() * (flip.isHorizontal ? -1 : 1),
      newHeight.abs() * (flip.isVertical ? -1 : 1),
    );
  }
}
