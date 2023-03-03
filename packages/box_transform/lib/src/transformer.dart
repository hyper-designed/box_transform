import 'package:vector_math/vector_math.dart';

import 'enums.dart';
import 'geometry.dart';
import 'result.dart';

/// A class that transforms a [Box] in several different supported forms.
class BoxTransformer {
  /// A private constructor to prevent instantiation.
  const BoxTransformer._();

  /// Calculates the new position of the [initialBox] based on the
  /// [initialLocalPosition] of the mouse cursor and wherever [localPosition]
  /// of the mouse cursor is currently at.
  ///
  /// The [clampingRect] is the box that the [initialBox] is not allowed
  /// to go outside of when dragging or resizing.
  static RawMoveResult move({
    required Box initialBox,
    required Vector2 initialLocalPosition,
    required Vector2 localPosition,
    Box clampingRect = Box.largest,
  }) {
    final Vector2 delta = localPosition - initialLocalPosition;

    final Box unclampedBox = initialBox.translate(delta.x, delta.y);
    final Box clampedBox = clampingRect.containOther(unclampedBox);
    final Vector2 clampedDelta = clampedBox.topLeft - initialBox.topLeft;

    final Box newRect = initialBox.translate(clampedDelta.x, clampedDelta.y);

    return MoveResult(
      rect: newRect,
      oldRect: initialBox,
      delta: delta,
      rawSize: newRect.size,
    );
  }

  /// Resizes the given [initialBox] with given [initialLocalPosition] of
  /// the mouse cursor and wherever [localPosition] of the mouse cursor is
  /// currently at.
  ///
  /// Specifying the [handle] and [resizeMode] will determine how the
  /// [initialBox] will be resized.
  ///
  /// The [initialFlip] helps determine the initial state of the rectangle.
  ///
  /// The [clampingRect] is the box that the [initialBox] is not allowed
  /// to go outside of when dragging or resizing.
  ///
  /// The [constraints] is the constraints that the [initialBox] is not allowed
  /// to shrink or grow beyond.
  static RawResizeResult resize({
    required Box initialBox,
    required Vector2 initialLocalPosition,
    required Vector2 localPosition,
    required HandlePosition handle,
    required ResizeMode resizeMode,
    required Flip initialFlip,
    Box clampingRect = Box.largest,
    Constraints constraints = const Constraints.unconstrained(),
  }) {
    final Flip currentFlip =
        getFlipForBox(initialBox, localPosition, handle, resizeMode);

    Vector2 delta = localPosition - initialLocalPosition;

    if (resizeMode.hasSymmetry) delta = Vector2(delta.x * 2, delta.y * 2);

    final Dimension newSize = _calculateNewSize(
      initialBox: initialBox,
      handle: handle,
      delta: delta,
      flip: currentFlip,
      resizeMode: resizeMode,
      clampingRect: clampingRect,
      constraints: constraints,
    );
    final double newWidth = newSize.width.abs();
    final double newHeight = newSize.height.abs();

    Box newRect;
    if (resizeMode.hasSymmetry) {
      newRect = Box.fromCenter(
          center: initialBox.center, width: newWidth, height: newHeight);
    } else {
      Box rect = Box.fromLTWH(
        handle.influencesLeft ? initialBox.right - newWidth : initialBox.left,
        handle.influencesTop ? initialBox.bottom - newHeight : initialBox.top,
        newWidth,
        newHeight,
      );

      newRect = flipBox(rect, currentFlip, handle);
    }

    newRect = clampingRect.containOther(newRect);

    // Detect terminal resizing, where the resizing reached a hard limit.
    bool minWidthReached = false;
    bool maxWidthReached = false;
    bool minHeightReached = false;
    bool maxHeightReached = false;
    if (delta.x != 0) {
      if (newRect.width <= initialBox.width &&
          newRect.width == constraints.minWidth) {
        minWidthReached = true;
      }
      if (newRect.width >= initialBox.width &&
          (newRect.width == constraints.maxWidth ||
              newRect.width == clampingRect.width)) {
        maxWidthReached = true;
      }
    }
    if (delta.y != 0) {
      if (newRect.height <= initialBox.height &&
          newRect.height == constraints.minHeight) {
        minHeightReached = true;
      }
      if (newRect.height >= initialBox.height &&
              newRect.height == constraints.maxHeight ||
          newRect.height == clampingRect.height) {
        maxHeightReached = true;
      }
    }

    return ResizeResult(
      rect: newRect,
      oldRect: initialBox,
      flip: currentFlip * initialFlip,
      resizeMode: resizeMode,
      delta: delta,
      rawSize: newSize,
      minWidthReached: minWidthReached,
      maxWidthReached: maxWidthReached,
      minHeightReached: minHeightReached,
      maxHeightReached: maxHeightReached,
    );
  }

  /// Flips the given [rect] with given [flip] with [handle] being the
  /// pivot point.
  static Box flipBox(Box rect, Flip flip, HandlePosition handle) {
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
  static Flip getFlipForBox(
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

  static Dimension _calculateNewSize({
    required Box initialBox,
    required HandlePosition handle,
    required Vector2 delta,
    required Flip flip,
    required ResizeMode resizeMode,
    Box clampingRect = Box.largest,
    Constraints constraints = const Constraints.unconstrained(),
  }) {
    final double aspectRatio = initialBox.width / initialBox.height;

    initialBox = flipBox(initialBox, flip, handle);
    Box rect;
    rect = Box.fromLTRB(
      initialBox.left + (handle.influencesLeft ? delta.x : 0),
      initialBox.top + (handle.influencesTop ? delta.y : 0),
      initialBox.right + (handle.influencesRight ? delta.x : 0),
      initialBox.bottom + (handle.influencesBottom ? delta.y : 0),
    );
    if (resizeMode.hasSymmetry) {
      final widthDelta = (initialBox.width - rect.width) / 2;
      final heightDelta = (initialBox.height - rect.height) / 2;
      rect = Box.fromLTRB(
        initialBox.left + widthDelta,
        initialBox.top + heightDelta,
        initialBox.right - widthDelta,
        initialBox.bottom - heightDelta,
      );
    }

    rect = clampingRect.containOther(
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
