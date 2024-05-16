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

  /// Calculates the new position of the [initialRect] based on the
  /// [initialLocalPosition] of the mouse cursor and wherever [localPosition]
  /// of the mouse cursor is currently at.
  ///
  /// The [clampingRect] is the rect that the [initialRect] is not allowed
  /// to go outside of when dragging or resizing.
  static RawMoveResult move({
    required Box initialRect,
    required Vector2 initialLocalPosition,
    required Vector2 localPosition,
    Box clampingRect = Box.largest,
  }) {
    final Vector2 delta = localPosition - initialLocalPosition;

    final Box unclampedRect = initialRect.translate(delta.x, delta.y);
    final Box clampedRect = clampingRect.containOther(unclampedRect);
    final Vector2 clampedDelta = clampedRect.topLeft - initialRect.topLeft;

    final Box newRect = initialRect.translate(clampedDelta.x, clampedDelta.y);

    return MoveResult(
      rect: newRect,
      oldRect: initialRect,
      delta: delta,
      rawSize: newRect.size,
      largestRect: clampingRect,
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
  /// The [clampingRect] is the rect that the [initialRect] is not allowed
  /// to go outside of when dragging or resizing.
  ///
  /// The [constraints] is the constraints that the [initialRect] is not allowed
  /// to shrink or grow beyond.
  ///
  /// [allowResizeOverflow] decides whether to allow the rect to overflow the
  /// resize operation to its opposite side to continue the resize operation
  /// until its constrained on both sides.
  ///
  /// If this is set to false, the rect will cease the resize operation the
  /// instant it hits an edge of the [clampingRect].
  ///
  /// If this is set to true, the rect will continue the resize operation until
  /// it is constrained to both sides of the [clampingRect].
  static RawResizeResult resize({
    required Box initialRect,
    required Vector2 initialLocalPosition,
    required Vector2 localPosition,
    required HandlePosition handle,
    required ResizeMode resizeMode,
    required Flip initialFlip,
    Box clampingRect = Box.largest,
    Constraints constraints = const Constraints.unconstrained(),
    bool allowFlipping = true,
  }) {
    if (handle == HandlePosition.none) {
      log('Using bottomRight handle instead of none.');
      handle = HandlePosition.bottomRight;
    }

    Vector2 delta = localPosition - initialLocalPosition;

    // getFlipForRect uses delta instead of localPosition to know exactly when
    // to flip based on the current local position of the mouse cursor.
    final Flip currentFlip = !allowFlipping
        ? Flip.none
        : getFlipForRect(initialRect, delta, handle, resizeMode);

    // This sets the constraints such that it reflects flipRect state.
    if (allowFlipping &&
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
    } else if (!allowFlipping && constraints.isUnconstrained) {
      // Rect flipping is disabled, but the constraints are unconstrained.
      // So we update the constraints to prevent flipping.
      constraints = Constraints(
        minWidth: 0,
        minHeight: 0,
        maxWidth: constraints.maxWidth,
        maxHeight: constraints.maxHeight,
      );
    }

    // Check if clampingRect is smaller than initialRect.
    // If it is, then we return the initialRect and not resize it.
    if (clampingRect.width < initialRect.width ||
        clampingRect.height < initialRect.height) {
      return ResizeResult(
        rect: initialRect,
        oldRect: initialRect,
        flip: initialFlip,
        resizeMode: resizeMode,
        delta: delta,
        handle: handle,
        rawSize: initialRect.size,
        minWidthReached: false,
        minHeightReached: false,
        largestRect: clampingRect,
        maxHeightReached: false,
        maxWidthReached: false,
      );
    }

    // Symmetric resizing requires the delta to be doubled since it grows or
    // shrinks in all directions from center.
    if (resizeMode.hasSymmetry) delta = Vector2(delta.x * 2, delta.y * 2);

    // No constraints or clamping is done. Only delta is applied to the
    // initial rect.
    Box explodedRect = _applyDelta(
      initialRect: initialRect,
      handle: handle,
      delta: delta,
      resizeMode: resizeMode,
      allowFlipping: allowFlipping,
    );

    final Resizer resizer = Resizer.from(resizeMode);
    final result = resizer.resize(
      explodedRect: explodedRect,
      clampingRect: clampingRect,
      handle: handle,
      constraints: constraints,
      initialRect: initialRect,
      flip: currentFlip,
    );

    final Box newRect = result.rect;
    final Box largestRect = result.largest;

    // Detect terminal resizing, where the resizing reached a hard limit.
    final terminalResult = checkForTerminalSizes(
      rect: newRect,
      initialRect: initialRect,
      clampingRect: clampingRect,
      constraints: constraints,
      handle: handle,
    );

    return ResizeResult(
      rect: newRect,
      oldRect: initialRect,
      flip: currentFlip * initialFlip,
      resizeMode: resizeMode,
      delta: delta,
      rawSize: newRect.size,
      minWidthReached: terminalResult.minWidthReached,
      maxWidthReached: terminalResult.maxWidthReached,
      minHeightReached: terminalResult.minHeightReached,
      maxHeightReached: terminalResult.maxHeightReached,
      largestRect: largestRect,
      handle: handle,
    );
  }

  /// Checks if the [rect] has reached a terminal size.
  /// Terminal size is when the rect has reached the min or max size according
  /// to the constraints defined by the [constraints] and [clampingRect].
  static ({
    bool minWidthReached,
    bool maxWidthReached,
    bool minHeightReached,
    bool maxHeightReached
  }) checkForTerminalSizes({
    required Box rect,
    required Box initialRect,
    required Box clampingRect,
    required Constraints constraints,
    required HandlePosition handle,
  }) {
    bool minWidthReached = false;
    bool maxWidthReached = false;
    bool minHeightReached = false;
    bool maxHeightReached = false;
    if (handle.influencesHorizontal) {
      if (rect.width <= initialRect.width &&
          rect.width == constraints.minWidth) {
        minWidthReached = true;
      }
      if (rect.width >= initialRect.width &&
          (rect.width == constraints.maxWidth ||
              rect.width == clampingRect.width)) {
        maxWidthReached = true;
      }
    }
    if (handle.influencesVertical) {
      if (rect.height <= initialRect.height &&
          rect.height == constraints.minHeight) {
        minHeightReached = true;
      }
      if (rect.height >= initialRect.height &&
          (rect.height == constraints.maxHeight ||
              rect.height == clampingRect.height)) {
        maxHeightReached = true;
      }
    }

    return (
      minWidthReached: minWidthReached,
      maxWidthReached: maxWidthReached,
      minHeightReached: minHeightReached,
      maxHeightReached: maxHeightReached,
    );
  }

  static Box _applyDelta({
    required Box initialRect,
    required HandlePosition handle,
    required Vector2 delta,
    required ResizeMode resizeMode,
    required bool allowFlipping,
  }) {
    double left;
    double top;
    double right;
    double bottom;

    left = initialRect.left + (handle.influencesLeft ? delta.x : 0);
    top = initialRect.top + (handle.influencesTop ? delta.y : 0);
    right = initialRect.right + (handle.influencesRight ? delta.x : 0);
    bottom = initialRect.bottom + (handle.influencesBottom ? delta.y : 0);

    double width = right - left;
    double height = bottom - top;

    if (allowFlipping) {
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
    // the new rect from its center.
    if (resizeMode.hasSymmetry) {
      // symmetric resizing is not affected if flipping is disabled.
      final widthDelta = (initialRect.width - width) / 2;
      final heightDelta = (initialRect.height - height) / 2;
      left = initialRect.left + widthDelta;
      top = initialRect.top + heightDelta;
      right = initialRect.right - widthDelta;
      bottom = initialRect.bottom - heightDelta;
    } else if (!allowFlipping) {
      // If not flipping, then we know that handles are not allowed to
      // cross the opposite one. So we use handle with width and height
      // instead of left, top, right, bottom to construct the new rect.
      return Box.fromHandle(
        handle.anchor(initialRect),
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
}
