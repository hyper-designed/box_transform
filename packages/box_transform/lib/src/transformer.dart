import 'dart:developer';
import 'dart:math' hide log;

import 'package:vector_math/vector_math.dart';

import 'enums.dart';
import 'geometry.dart';
import 'helpers.dart';
import 'resizers/resizer.dart';
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
    final Box clampedBox = clampingRect.containOther(unclampedBox,
        handle: HandlePosition.bottomRight);
    final Vector2 clampedDelta = clampedBox.topLeft - initialBox.topLeft;

    final Box newRect = initialBox.translate(clampedDelta.x, clampedDelta.y);

    return MoveResult(
      rect: newRect,
      oldRect: initialBox,
      delta: delta,
      rawSize: newRect.size,
      largestRect: clampingRect,
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
  ///
  /// [allowResizeOverflow] decides whether to allow the box to overflow the
  /// resize operation to its opposite side to continue the resize operation
  /// until its constrained on both sides.
  ///
  /// If this is set to false, the box will cease the resize operation the
  /// instant it hits an edge of the [clampingRect].
  ///
  /// If this is set to true, the box will continue the resize operation until
  /// it is constrained to both sides of the [clampingRect].
  static RawResizeResult resize({
    required Box initialBox,
    required Vector2 initialLocalPosition,
    required Vector2 localPosition,
    required HandlePosition handle,
    required ResizeMode resizeMode,
    required Flip initialFlip,
    Box clampingRect = Box.largest,
    Constraints constraints = const Constraints.unconstrained(),
    bool allowBoxFlipping = true,
    bool allowResizeOverflow = false,
  }) {
    if (handle == HandlePosition.none) {
      log('Using bottomRight handle instead of none.');
      handle = HandlePosition.bottomRight;
    }

    Vector2 delta = localPosition - initialLocalPosition;

    // getFlipForBox uses delta instead of localPosition to know exactly when
    // to flip based on the current local position of the mouse cursor.
    final Flip currentFlip = !allowBoxFlipping
        ? Flip.none
        : getFlipForBox(initialBox, delta, handle, resizeMode);

    // This sets the constraints such that it reflects flipRect state.
    if (allowBoxFlipping &&
        (constraints.minWidth == 0 || constraints.minHeight == 0)) {
      // Rect flipping is enabled, but minWidth or minHeight is 0 which
      // means it won't be able to flip. So we update the constraints
      // to allow flipping.
      constraints = Constraints(
        minWidth: constraints.minWidth == 0
            ? -constraints.maxWidth
            : constraints.minWidth,
        minHeight: constraints.minHeight == 0
            ? -constraints.maxHeight
            : constraints.minHeight,
        maxWidth: constraints.maxWidth,
        maxHeight: constraints.maxHeight,
      );
    } else if (!allowBoxFlipping && constraints.isUnconstrained) {
      // Rect flipping is disabled, but the constraints are unconstrained.
      // So we update the constraints to prevent flipping.
      constraints = Constraints(
        minWidth: 0,
        minHeight: 0,
        maxWidth: constraints.maxWidth,
        maxHeight: constraints.maxHeight,
      );
    }

    if (resizeMode.hasSymmetry) delta = Vector2(delta.x * 2, delta.y * 2);

    ({Box rect, Box largest, bool hasValidFlip}) result = _calculateNewBox(
      initialBox: initialBox,
      handle: handle,
      delta: delta,
      flip: currentFlip,
      resizeMode: resizeMode,
      clampingRect: clampingRect,
      constraints: constraints,
      allowResizeOverflow: allowResizeOverflow,
      localPosition: localPosition,
      flipRect: allowBoxFlipping,
    );

    final Box newRect = result.rect;
    final Box largestRect = result.largest;

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
      rawSize: newRect.size,
      minWidthReached: minWidthReached,
      maxWidthReached: maxWidthReached,
      minHeightReached: minHeightReached,
      maxHeightReached: maxHeightReached,
      largestRect: largestRect,
      handle: handle,
    );
  }

  static Box _applyDelta({
    required Box initialBox,
    required HandlePosition handle,
    required Vector2 delta,
    required ResizeMode resizeMode,
    required bool flipRect,
  }) {
    double left;
    double top;
    double right;
    double bottom;

    left = initialBox.left + (handle.influencesLeft ? delta.x : 0);
    top = initialBox.top + (handle.influencesTop ? delta.y : 0);
    right = initialBox.right + (handle.influencesRight ? delta.x : 0);
    bottom = initialBox.bottom + (handle.influencesBottom ? delta.y : 0);

    double width = right - left;
    double height = bottom - top;

    if (flipRect) {
      width = width.abs();
      height = height.abs();
    } else {
      // If not flipping, we need to make sure the width and height are
      // positive which would imply that the left and top are less than
      // the right and bottom respectively stopping rect from flipping.
      width = width.clamp(0, double.infinity);
      height = height.clamp(0, double.infinity);
    }

    // If in symmetric scaling mode, utilize width and height to constructor
    // the new box from its center.
    if (resizeMode.hasSymmetry) {
      // symmetric resizing is not affected if flipping is disabled.
      final widthDelta = (initialBox.width - width) / 2;
      final heightDelta = (initialBox.height - height) / 2;
      left = initialBox.left + widthDelta;
      top = initialBox.top + heightDelta;
      right = initialBox.right - widthDelta;
      bottom = initialBox.bottom - heightDelta;
    } else if (!flipRect) {
      // If not flipping, then we know that handles are not allowed to
      // cross the opposite one. So we use handle with width and height
      // instead of left, top, right, bottom to construct the new box.
      return Box.fromHandle(
        handle.anchor(initialBox),
        handle,
        width,
        height,
      );
    }

    return Box.fromLTRB(
      min(left, right),
      min(top, bottom),
      max(left, right),
      max(top, bottom),
    );
  }

  static ({Box rect, Box largest, bool hasValidFlip}) _calculateNewBox({
    required Box initialBox,
    required HandlePosition handle,
    required Vector2 delta,
    required Flip flip,
    required ResizeMode resizeMode,
    Box clampingRect = Box.largest,
    Constraints constraints = const Constraints.unconstrained(),
    bool allowResizeOverflow = true,
    required Vector2 localPosition,
    required bool flipRect,
  }) {
    // No constraints or clamping is done. Only delta is applied to the
    // initial box.
    Box explodedRect = _applyDelta(
      initialBox: initialBox,
      handle: handle,
      delta: delta,
      resizeMode: resizeMode,
      flipRect: flipRect,
    );

    final Resizer resizer = Resizer.from(resizeMode);
    return resizer.resize(
      explodedRect: explodedRect,
      clampingRect: clampingRect,
      handle: handle,
      constraints: constraints,
      initialRect: initialBox,
      flip: flip,
    );
  }
}
