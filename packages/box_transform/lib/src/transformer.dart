import 'dart:developer';
import 'dart:math' hide log;

import 'package:vector_math/vector_math.dart';

import '../box_transform.dart';
import 'resizers/resizer.dart';

/// A class that transforms a [Box] in several different supported forms.
class BoxTransformer {
  /// A private constructor to prevent instantiation.
  const BoxTransformer._();

  /// Rotates the given [rect] with the given [initialLocalPosition] of
  /// the mouse cursor and wherever [localPosition] of the mouse cursor is
  /// currently at.
  ///
  /// The [clampingRect] is the rect that the [rect] is not allowed
  /// to go outside of when dragging or resizing.
  static RawRotateResult rotate({
    required Box rect,
    required Vector2 initialLocalPosition,
    required Vector2 localPosition,
    required double initialRotation,
    Box clampingRect = Box.largest,
    BindingStrategy bindingStrategy = BindingStrategy.boundingBox,
  }) {
    final Vector2 delta = localPosition - initialLocalPosition;
    final Vector2 from = rect.center - initialLocalPosition;
    final Vector2 to = rect.center - localPosition;
    double rotation = atan2(to.y, to.x) - atan2(from.y, from.x);
    rotation += initialRotation;

    // Normalize the angle to the range [0, 2π).
    if (rotation < 0) {
      rotation += 2 * pi;
    }

    final initialBoundingRect = calculateBoundingRect(
      rotation: rotation,
      unrotatedBox: rect,
    );

    return RotateResult(
      rect: rect,
      boundingRect: initialBoundingRect,
      oldBoundingRect: initialBoundingRect,
      delta: delta,
      rawSize: rect.size,
      rotation: rotation,
    );
  }

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
    double rotation = 0.0,
    Box clampingRect = Box.largest,
    BindingStrategy bindingStrategy = BindingStrategy.boundingBox,
  }) {
    final Vector2 delta = localPosition - initialLocalPosition;
    final Box initialBoundingRect = calculateBoundingRect(
      rotation: rotation,
      unrotatedBox: initialRect,
    );

    // If the box is rotated, the incoming delta is also rotated. We need to
    // unrotate the delta to get the actual delta.
    if (rotation != 0) {
      Matrix2.rotation(rotation).transform(delta);
    }

    final Box initialBinding = switch (bindingStrategy) {
      BindingStrategy.originalBox => initialRect,
      BindingStrategy.boundingBox => initialBoundingRect,
    };
    final Box unclampedRect = initialBinding.translate(delta.x, delta.y);

    final Vector2 clampDelta = calculateRectClampingPositionDelta(
      initialRect: initialBinding,
      rect: unclampedRect,
      clampingRect: clampingRect,
    );
    final Box newRect = initialRect.translate(clampDelta.x, clampDelta.y);
    final Box newBoundingRect =
        initialBoundingRect.translate(clampDelta.x, clampDelta.y);

    return MoveResult(
      rect: newRect,
      oldRect: initialRect,
      boundingRect: newBoundingRect,
      oldBoundingRect: initialBoundingRect,
      delta: delta,
      rawSize: newRect.size,
      largestRect: clampingRect,
    );
  }

  /// Returns the delta required to move the [rect] in such a way that it
  /// remains within the [clampingRect].
  static Vector2 calculateRectClampingPositionDelta({
    required Box initialRect,
    required Box rect,
    required Box clampingRect,
  }) {
    final Box clampedRect = clampingRect.containOther(rect);
    return clampedRect.topLeft - initialRect.topLeft;
  }

  /// Returns a [Vector2] delta that grows as the intersection between [rect]
  /// and [clampingRect] grows.
  static Vector2 stopRectAtClampingRect({
    required Box rect,
    required Box clampingRect,
    required double rotation,
  }) {
    final Map<Quadrant, Vector2> rotatedPoints = {
      for (final MapEntry(key: quadrant, value: point)
          in rect.sidedPoints.entries)
        quadrant: rotatePointAroundVec(rect.center, rotation, point)
    };

    // Check if any rotated point is outside the clamping rect.
    (
      Side side,
      Quadrant quadrant,
      Vector2 point,
      double dist
    )? biggestOutOfBounds;
    for (final MapEntry(key: quadrant, value: point) in rotatedPoints.entries) {
      if (biggestOutOfBounds == null) {
        final (side, dist) = clampingRect.distanceOfPoint(point);
        biggestOutOfBounds = (side, quadrant, point, dist);
      } else {
        final (side, dist) = clampingRect.distanceOfPoint(point);
        final (_, biggestDist) =
            clampingRect.distanceOfPoint(biggestOutOfBounds.$3);
        if (dist < biggestDist) {
          biggestOutOfBounds = (side, quadrant, point, dist);
        }
      }
    }

    assert(biggestOutOfBounds != null);

    final side = biggestOutOfBounds!.$1;
    final quadrant = biggestOutOfBounds.$2;
    final point = biggestOutOfBounds.$3;
    final dist = biggestOutOfBounds.$4;

    // Move the out of bounds vector by the perpendicular vector of the side
    // that was hit.
    final cardinalCorrection = switch (side) {
      Side.left => Vector2(-dist, 0),
      Side.right => Vector2(dist, 0),
      Side.top => Vector2(0, -dist),
      Side.bottom => Vector2(0, dist),
    };

    final correctedRotatedPoint =
        Vector2(point.x + cardinalCorrection.x, point.y + cardinalCorrection.y);

    // Rotate back
    final unrotated =
        rotatePointAroundVec(rect.center, -rotation, correctedRotatedPoint);
    final delta = unrotated - rect.pointFromQuadrant(quadrant);

    print('     quad: ${rect.pointFromQuadrant(quadrant)..round()}');
    print('unrotated: ${unrotated..round()}');

    // Matrix2.rotation(rotation).transform(delta);
    print('delta: $delta');

    return delta;
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
    double rotation = 0.0,
    Box clampingRect = Box.largest,
    Constraints constraints = const Constraints.unconstrained(),
    bool allowFlipping = true,
    BindingStrategy bindingStrategy = BindingStrategy.boundingBox,
  }) {
    if (handle == HandlePosition.none) {
      log('Using bottomRight handle instead of none.');
      handle = HandlePosition.bottomRight;
    }

    final initialBoundingRect = calculateBoundingRect(
      rotation: rotation,
      unrotatedBox: initialRect,
    );

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

    final Box initialBindingRect = switch (bindingStrategy) {
      BindingStrategy.originalBox => initialRect,
      BindingStrategy.boundingBox => initialBoundingRect,
    };
    final double initialBindingWidth = initialBindingRect.width;
    final double initialBindingHeight = initialBindingRect.height;

    // Check if clampingRect is smaller than initialRect.
    // If it is, then we return the initialRect and not resize it.
    if (clampingRect.width < initialBindingWidth ||
        clampingRect.height < initialBindingHeight) {
      return ResizeResult(
        rect: initialRect,
        oldRect: initialRect,
        boundingRect: initialBoundingRect,
        oldBoundingRect: initialBoundingRect,
        flip: initialFlip,
        resizeMode: resizeMode,
        delta: delta,
        handle: handle,
        rawSize: initialRect.size,
        largestRect: clampingRect,
        minWidthReached: false,
        minHeightReached: false,
        maxHeightReached: false,
        maxWidthReached: false,
      );
    }

    // Symmetric resizing requires the delta to be doubled since it grows or
    // shrinks in all directions from center.
    if (resizeMode.hasSymmetry) delta = Vector2(delta.x * 2, delta.y * 2);

    // No constraints or clamping is done. Only delta is applied to the
    // initial rect.
    final Box explodedRect = applyDelta(
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
      rotation: rotation,
      bindingStrategy: bindingStrategy,
    );

    final Box newRect = result.rect;
    final Box largestRect = result.largest;
    final Box newBoundingRect = calculateBoundingRect(
      rotation: rotation,
      unrotatedBox: newRect,
    );

    // Detect terminal resizing, where the resizing reached a hard limit.
    final terminalResult = checkForTerminalSizes(
      rect: newRect,
      initialRect: initialRect,
      clampingRect: clampingRect,
      rotation: rotation,
      constraints: constraints,
      handle: handle,
      bindingStrategy: bindingStrategy,
    );

    return ResizeResult(
      rect: newRect,
      oldRect: initialRect,
      boundingRect: newBoundingRect,
      oldBoundingRect: initialBoundingRect,
      flip: currentFlip * initialFlip,
      resizeMode: resizeMode,
      delta: delta,
      handle: handle,
      rawSize: newRect.size,
      largestRect: largestRect,
      minWidthReached: terminalResult.minWidthReached,
      maxWidthReached: terminalResult.maxWidthReached,
      minHeightReached: terminalResult.minHeightReached,
      maxHeightReached: terminalResult.maxHeightReached,
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
    required double rotation,
    required Constraints constraints,
    required HandlePosition handle,
    required BindingStrategy bindingStrategy,
  }) {
    final initialBoundingRect = calculateBoundingRect(
      rotation: rotation,
      unrotatedBox: initialRect,
    );
    final boundingRect = calculateBoundingRect(
      rotation: rotation,
      unrotatedBox: rect,
    );
    final initialBindingWidth = bindingStrategy == BindingStrategy.originalBox
        ? initialRect.width
        : initialBoundingRect.width;
    final initialBindingHeight = bindingStrategy == BindingStrategy.originalBox
        ? initialRect.height
        : initialBoundingRect.height;

    final bindingWidth = bindingStrategy == BindingStrategy.originalBox
        ? rect.width
        : boundingRect.width;
    final bindingHeight = bindingStrategy == BindingStrategy.originalBox
        ? rect.height
        : boundingRect.height;

    bool minWidthReached = false;
    bool maxWidthReached = false;
    bool minHeightReached = false;
    bool maxHeightReached = false;
    if (handle.influencesHorizontal) {
      if (bindingWidth <= initialBindingWidth &&
          bindingWidth == constraints.minWidth) {
        minWidthReached = true;
      }
      if (bindingWidth >= initialBindingWidth &&
          (bindingWidth == constraints.maxWidth ||
              bindingWidth == clampingRect.width)) {
        maxWidthReached = true;
      }
    }
    if (handle.influencesVertical) {
      if (bindingHeight <= initialBindingHeight &&
          bindingHeight == constraints.minHeight) {
        minHeightReached = true;
      }
      if (bindingHeight >= initialBindingHeight &&
          (bindingHeight == constraints.maxHeight ||
              bindingHeight == clampingRect.height)) {
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

  static Box applyDelta({
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

  /// Rotates a point [point] around [origin] by the given [radians] and returns
  /// the new coordinates as a [Vec].
  static Vector2 rotatePointAroundVec(
    Vector2 origin,
    double radians,
    Vector2 point,
  ) {
    final Matrix4 transform = Matrix4.translationValues(origin.x, origin.y, 0)
      ..rotateZ(radians)
      ..translate(-origin.x, -origin.y, 0);

    final List<double> rotated = transform.applyToVector3Array(
      [point.x, point.y, 0],
    );

    return Vector2(rotated[0], rotated[1]);
  }

  static Vector2 calculateUnrotatedPos(Box unrotatedRect, double rotation,
      Vector2 positionDelta, Dimension newSize) {
    // This was our old rotated position. We will be using it as the point of
    // reference. We're given the [unrotatedRect], but we need it's top left
    // corner rotated to the new position.
    final Vector2 oldRotatedXY = rotatePointAroundVec(
      unrotatedRect.center,
      rotation,
      unrotatedRect.topLeft,
    );

    // This is how the rotated position changes in parents system.
    final double sinA = sin(-rotation);
    final double cosA = cos(-rotation);
    final double xChange = cosA * positionDelta.x + sinA * positionDelta.y;
    final double yChange = cosA * positionDelta.y - sinA * positionDelta.x;

    // The new position in parent's system accounting for the changes:
    final Vector2 newRotatedXY = oldRotatedXY + Vector2(xChange, yChange);

    // Rotate back again because we're interested in the new unrotated position,
    // not the rotated one. For that we need the new center.
    final Vector2 newRotatedBR = newRotatedXY +
        Vector2(
          cosA * newSize.width + sinA * newSize.height,
          cosA * newSize.height - sinA * newSize.width,
        );

    final Vector2 newCenter = newRotatedXY + (newRotatedBR - newRotatedXY) / 2;
    // final Vector2 newCenter = Box.fromLTRB(
    //         newRotatedXY.x, newRotatedXY.y, newRotatedBR.x, newRotatedBR.y)
    //     .center;

    // Now we can rotate the top left point back.
    return rotatePointAroundVec(newCenter, -rotation, newRotatedXY);
  }

  static Box calculateBoundingRect({
    required double rotation,
    required Box unrotatedBox,
  }) {
    final double sinA = sin(rotation);
    final double cosA = cos(rotation);

    final double width = unrotatedBox.width;
    final double height = unrotatedBox.height;
    final double boundingWidth = (width * cosA).abs() + (height * sinA).abs();
    final double boundingHeight = (width * sinA).abs() + (height * cosA).abs();
    final double left = (unrotatedBox.left + (width / 2)) - (boundingWidth / 2);
    final double top = (unrotatedBox.top + (height / 2)) - (boundingHeight / 2);

    final Box explodedRect = Box.fromLTWH(
      left,
      top,
      boundingWidth,
      boundingHeight,
    );

    return explodedRect;
  }

  static Constraints calculateBoundingConstraints(
      {required double rotation, required Constraints constraints}) {
    final double sinA = sin(rotation);
    final double cosA = cos(rotation);

    final double maxWidth = constraints.maxWidth;
    final double maxHeight = constraints.maxHeight;
    final double minWidth = constraints.minWidth;
    final double minHeight = constraints.minHeight;

    final double maxBoundingWidth = !maxWidth.isFinite
        ? double.infinity
        : (maxWidth * cosA).abs() + (maxHeight * sinA).abs();
    final double maxBoundingHeight = !maxHeight.isFinite
        ? double.infinity
        : (maxWidth * sinA).abs() + (maxHeight * cosA).abs();
    final double minBoundingWidth = !minWidth.isFinite
        ? double.infinity
        : (minWidth * cosA).abs() + (minHeight * sinA).abs();
    final double minBoundingHeight = !minHeight.isFinite
        ? double.infinity
        : (minWidth * sinA).abs() + (minHeight * cosA).abs();

    return Constraints(
      minWidth: minBoundingWidth,
      minHeight: minBoundingHeight,
      maxWidth: maxBoundingWidth,
      maxHeight: maxBoundingHeight,
    );
  }

// static Dimension calculateBoundingSize({
//   required double rotation,
//   required Dimension unrotatedSize,
// }) {
//   final double sinA = sin(rotation);
//   final double cosA = cos(rotation);
//
//   final double width = unrotatedSize.width;
//   final double height = unrotatedSize.height;
//   final double boundingWidth = (width * cosA).abs() + (height * sinA).abs();
//   final double boundingHeight = (width * sinA).abs() + (height * cosA).abs();
//
//   return Dimension(boundingWidth, boundingHeight);
// }

// static Box calculateUnrotatedRect({
//   required Box boundingBox,
//   required double rotation,
//   required double aspectRatio,
// }) {
//   final Vector2 center = boundingBox.center;
//
//   final double width = boundingBox.width * cos(-rotation) +
//       boundingBox.height * sin(-rotation);
//
//   // derive from aspect ratio.
//   final double height = width / aspectRatio;
//
//   final Box unrotatedRect = Box.fromCenter(
//     center: center,
//     width: width,
//     height: height,
//   );
//
//   return unrotatedRect;
// }
}
