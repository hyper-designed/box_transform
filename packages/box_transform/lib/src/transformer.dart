import 'dart:math';

import 'package:meta/meta.dart';
import 'package:vector_math/vector_math.dart';

import '../box_transform.dart';
import 'helpers.dart';

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
    bool flipRect = true,
    bool allowResizeOverflow = false,
  }) {
    Vector2 delta = localPosition - initialLocalPosition;

    // getFlipForBox uses delta instead of localPosition to know exactly when
    // to flip based on the current local position of the mouse cursor.
    final Flip currentFlip = !flipRect
        ? Flip.none
        : getFlipForBox(initialBox, delta, handle, resizeMode);

    // This sets the constraints such that it reflects flipRect state.
    if (flipRect && (constraints.minWidth == 0 || constraints.minHeight == 0)) {
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
    } else if (!flipRect && constraints.isUnconstrained) {
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

    InternalResizeResult result = _calculateNewBox(
      initialBox: initialBox,
      handle: handle,
      delta: delta,
      flip: currentFlip,
      resizeMode: resizeMode,
      clampingRect: clampingRect,
      constraints: constraints,
      allowResizeOverflow: allowResizeOverflow,
      localPosition: localPosition,
    );

    final Box newRect = result.rect;
    final Box largestRect = result.largest;

    // final newSize = newRect.size;

    // newRect = clampingRect.containOther(
    //   newRect,
    //   handle: handle,
    //   currentFlip: currentFlip,
    // );

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
  }) {
    double left;
    double top;
    double right;
    double bottom;

    left = initialBox.left + (handle.influencesLeft ? delta.x : 0);
    top = initialBox.top + (handle.influencesTop ? delta.y : 0);
    right = initialBox.right + (handle.influencesRight ? delta.x : 0);
    bottom = initialBox.bottom + (handle.influencesBottom ? delta.y : 0);

    final double width = (right - left).abs();
    final double height = (bottom - top).abs();

    if (resizeMode.hasSymmetry) {
      final widthDelta = (initialBox.width - width) / 2;
      final heightDelta = (initialBox.height - height) / 2;
      left = initialBox.left + widthDelta;
      top = initialBox.top + heightDelta;
      right = initialBox.right - widthDelta;
      bottom = initialBox.bottom - heightDelta;
    }

    return Box.fromLTRB(
      min(left, right),
      min(top, bottom),
      max(left, right),
      max(top, bottom),
    );
  }

  static InternalResizeResult _calculateNewBox({
    required Box initialBox,
    required HandlePosition handle,
    required Vector2 delta,
    required Flip flip,
    required ResizeMode resizeMode,
    Box clampingRect = Box.largest,
    Constraints constraints = const Constraints.unconstrained(),
    bool allowResizeOverflow = true,
    required Vector2 localPosition,
  }) {
    // No constraints or clamping is done. Only delta is applied to the
    // initial box.
    Box rect = _applyDelta(
      initialBox: initialBox,
      handle: handle,
      delta: delta,
      resizeMode: resizeMode,
    );

    InternalResizeResult result;
    switch (resizeMode) {
      case ResizeMode.freeform:
        result = handleFreeformResizing(
          rect: rect,
          clampingRect: clampingRect,
          handle: handle,
          constraints: constraints,
          initialRect: initialBox,
          flip: flip,
        );
        break;
      case ResizeMode.symmetric:
        result = handleSymmetricResizing(
          rect: rect,
          clampingRect: clampingRect,
          handle: handle,
        );
        break;
      case ResizeMode.scale:
        result = handleScaleResizing(
          rect: rect,
          initialBox: initialBox,
          clampingRect: clampingRect,
          handle: handle,
          flip: flip,
        );
        break;
      case ResizeMode.symmetricScale:
        result = handleSymmetricScaleResizing(
          rect: rect,
          initialBox: initialBox,
          clampingRect: clampingRect,
          handle: handle,
          flip: flip,
        );
        break;
    }

    return result;
    // initialBox = flipBox(initialBox, flip, handle);

    // rect = clampingRect.containOther(
    //   rect,
    //   resizeMode: resizeMode,
    //   aspectRatio: aspectRatio,
    //   handle: handle,
    //   allowResizeOverflow: allowResizeOverflow,
    //   currentFlip: flip,
    // );

    // When constraining this rect, it might have a negative width or height
    // because it has not been normalized yet. If the minimum width or height
    // is larger than zero, constraining will not work as expected because the
    // negative width or height will be ignored. To fix this, we take the
    // absolute value of the width and height before constraining and then
    // multiply the result with the sign of the width and height.
    // final double wSign = rect.width.sign;
    // final double hSign = rect.height.sign;
    // rect = constraints.constrainBox(rect, absolute: true);
    // rect = Box.fromLTWH(
    //   rect.left,
    //   rect.top,
    //   rect.width * wSign,
    //   rect.height * hSign,
    // );
    //
    // final double newWidth;
    // final double newHeight;
    // final newAspectRatio = rect.width / rect.height;
    //
    // if (resizeMode.isScalable) {
    //   if (newAspectRatio.abs() < aspectRatio.abs()) {
    //     newHeight = rect.height;
    //     newWidth = newHeight * aspectRatio;
    //   } else {
    //     newWidth = rect.width;
    //     newHeight = newWidth / aspectRatio;
    //   }
    // } else {
    //   newWidth = rect.width;
    //   newHeight = rect.height;
    // }

    // return Dimension(
    //   newWidth.abs() * (flip.isHorizontal ? -1 : 1),
    //   newHeight.abs() * (flip.isVertical ? -1 : 1),
    // );
  }

  /// Handles resizing for [ResizeMode.freeform].
  static InternalResizeResult handleFreeformResizing({
    required Box rect,
    required Box clampingRect,
    required HandlePosition handle,
    required Constraints constraints,
    required Box initialRect,
    required Flip flip,
  }) {
    Box effectiveInitialRect = flipBox(initialRect, flip, handle);

    Box newRect = Box.fromLTRB(
      max(rect.left, clampingRect.left),
      max(rect.top, clampingRect.top),
      min(rect.right, clampingRect.right),
      min(rect.bottom, clampingRect.bottom),
    );

    if (!constraints.isUnconstrained) {
      final maxWidth =
          newRect.width.clamp(constraints.minWidth, constraints.maxWidth);
      final maxHeight =
          newRect.height.clamp(constraints.minHeight, constraints.maxHeight);

      newRect = Box.fromHandle(
        handle.flip(flip).anchor(effectiveInitialRect),
        handle.flip(flip),
        maxWidth,
        maxHeight,
      );
    }

    return InternalResizeResult(
      rect: newRect,
      largest: effectiveInitialRect,
    );
  }

  /// Handle resizing for [HandlePosition.bottomRight] handle
  /// for [ResizeMode.scale].
  static InternalResizeResult handleBottomRight(
    Box rect,
    Box initialRect,
    Box clampingRect,
    HandlePosition handle,
  ) {
    final area = getAvailableAreaForHandle(
      rect: rect,
      clampingRect: clampingRect,
      handle: handle,
    );

    final initialAspectRatio = initialRect.width / initialRect.height;

    double rectWidth = rect.width;
    double rectHeight = rect.height;

    final cursorRect = rect;

    if (cursorRect.aspectRatio.abs() < initialAspectRatio.abs()) {
      rectWidth = rectHeight * initialAspectRatio;
    } else {
      rectHeight = rectWidth / initialAspectRatio;
    }

    final effectiveArea = getClampingRectForHandle(
      initialRect: initialRect,
      availableArea: area,
      handle: handle,
    );

    rect = Box.fromHandle(
      handle.anchor(initialRect),
      handle,
      rectWidth,
      rectHeight,
    );

    if (rect.width > effectiveArea.width ||
        rect.height > effectiveArea.height) {
      return InternalResizeResult(rect: effectiveArea, largest: effectiveArea);
    }

    return InternalResizeResult(rect: rect, largest: effectiveArea);
  }

  /// Handle resizing for the right handle.
  static InternalResizeResult handleRight(
    Box rect,
    Box initialRect,
    Box clampingRect,
    HandlePosition handle,
  ) {
    final initialAspectRatio = initialRect.width / initialRect.height;

    final availableArea = getAvailableAreaForHandle(
      rect: initialRect,
      clampingRect: clampingRect,
      handle: handle,
    );

    if (availableArea.width < initialRect.width) {
      // initial box needs shrinking
      final maxWidth = availableArea.width;
      final maxHeight = maxWidth / initialAspectRatio;

      initialRect = Box.fromHandle(
        handle.anchor(initialRect),
        handle,
        maxWidth,
        maxHeight,
      );
    }

    final area = getClampingRectForHandle(
      initialRect: initialRect,
      availableArea: clampingRect,
      handle: handle,
    );

    double rectWidth = rect.width;
    double rectHeight = rect.height;

    rectHeight = rectWidth / initialAspectRatio;

    rect = Box.fromHandle(
      handle.anchor(initialRect),
      handle,
      rectWidth,
      rectHeight,
    );

    if (rect.width > area.width || rect.height > area.height) {
      rect = area;
      return InternalResizeResult(rect: area, largest: area);
    }

    return InternalResizeResult(rect: rect, largest: area);
  }

  /// handle resizing for the left handle
  static InternalResizeResult handleLeft(
    Box rect,
    Box initialRect,
    Box clampingRect,
    HandlePosition handle,
  ) {
    final initialAspectRatio = initialRect.width / initialRect.height;

    final availableArea = getAvailableAreaForHandle(
      rect: initialRect,
      clampingRect: clampingRect,
      handle: handle,
    );

    if (availableArea.width < initialRect.width) {
      // initial box needs shrinking
      final maxWidth = availableArea.width;
      final maxHeight = maxWidth / initialAspectRatio;

      initialRect = Box.fromHandle(
        handle.anchor(initialRect),
        handle,
        maxWidth,
        maxHeight,
      );
    }

    final area = getClampingRectForHandle(
      initialRect: initialRect,
      availableArea: clampingRect,
      handle: handle,
    );

    double rectWidth = rect.width;
    double rectHeight = rect.height;

    rectHeight = rectWidth / initialAspectRatio;

    rect = Box.fromHandle(
      handle.anchor(initialRect),
      handle,
      rectWidth,
      rectHeight,
    );

    if (rect.width > area.width || rect.height > area.height) {
      rect = area;
      return InternalResizeResult(rect: area, largest: area);
    }

    return InternalResizeResult(rect: rect, largest: area);
  }

  /// handle resizing for the bottom handle.
  static InternalResizeResult handleBottom(
    Box rect,
    Box initialRect,
    Box clampingRect,
    HandlePosition handle,
  ) {
    final initialAspectRatio = initialRect.width / initialRect.height;

    final availableArea = getAvailableAreaForHandle(
      rect: initialRect,
      clampingRect: clampingRect,
      handle: handle,
    );

    if (availableArea.height < initialRect.height) {
      // initial box needs shrinking
      final maxHeight = availableArea.height;
      final maxWidth = maxHeight * initialAspectRatio;

      initialRect = Box.fromHandle(
        handle.anchor(initialRect),
        handle,
        maxWidth,
        maxHeight,
      );
    }

    final effectiveArea = getClampingRectForHandle(
      initialRect: initialRect,
      availableArea: clampingRect,
      handle: handle,
    );

    double rectWidth = rect.width;
    double rectHeight = rect.height;

    rectWidth = rectHeight * initialAspectRatio;

    rect = Box.fromHandle(
      handle.anchor(initialRect),
      handle,
      rectWidth,
      rectHeight,
    );

    if (rect.width > effectiveArea.width ||
        rect.height > effectiveArea.height) {
      rect = effectiveArea;
      return InternalResizeResult(rect: effectiveArea, largest: effectiveArea);
    }

    return InternalResizeResult(rect: rect, largest: effectiveArea);
  }

  /// handle resizing for the top handle.
  static InternalResizeResult handleTop(
    Box rect,
    Box initialRect,
    Box clampingRect,
    HandlePosition handle,
  ) {
    final initialAspectRatio = initialRect.width / initialRect.height;

    final availableArea = getAvailableAreaForHandle(
      rect: initialRect,
      clampingRect: clampingRect,
      handle: handle,
    );

    if (availableArea.height < initialRect.height) {
      // initial box needs shrinking
      final maxHeight = availableArea.height;
      final maxWidth = maxHeight * initialAspectRatio;

      initialRect = Box.fromHandle(
        handle.anchor(initialRect),
        handle,
        maxWidth,
        maxHeight,
      );
    }

    final area = getClampingRectForHandle(
      initialRect: initialRect,
      availableArea: clampingRect,
      handle: handle,
    );

    double rectWidth = rect.width;
    double rectHeight = rect.height;

    rectWidth = rectHeight * initialAspectRatio;

    rect = Box.fromHandle(
      handle.anchor(initialRect),
      handle,
      rectWidth,
      rectHeight,
    );

    if (rect.width > area.width || rect.height > area.height) {
      rect = area;
      return InternalResizeResult(rect: area, largest: area);
    }

    return InternalResizeResult(rect: rect, largest: area);
  }

  /// Handles the symmetric resize mode for corner handles.
  static InternalResizeResult handleScaleSymmetricCorner(
    Box rect,
    Box initialRect,
    Box clampingRect,
    HandlePosition handle,
  ) {
    final initialAspectRatio = initialRect.width / initialRect.height;
    final area = scaledSymmetricClampingBox(initialRect, clampingRect);

    double rectWidth = rect.width;
    double rectHeight = rect.height;

    final cursorRect = rect;

    if (cursorRect.aspectRatio.abs() < initialAspectRatio.abs()) {
      rectWidth = rectHeight * initialAspectRatio;
    } else {
      rectHeight = rectWidth / initialAspectRatio;
    }

    rect = Box.fromCenter(
      center: initialRect.center,
      width: rectWidth,
      height: rectHeight,
    );

    if (rect.width > area.width || rect.height > area.height) {
      rect = area;
      return InternalResizeResult(rect: area, largest: area);
    }

    return InternalResizeResult(rect: rect, largest: area);
  }

  /// Handles the symmetric resize mode for side handles.
  static InternalResizeResult handleScaleSymmetricSide(
    Box rect,
    Box initialRect,
    Box clampingRect,
    HandlePosition handle,
  ) {
    final initialAspectRatio = initialRect.width / initialRect.height;
    final area = scaledSymmetricClampingBox(initialRect, clampingRect);

    double rectWidth = rect.width.abs();
    double rectHeight = rect.height.abs();

    if (handle.isHorizontal) {
      rectHeight = rectWidth / initialAspectRatio;
    } else {
      rectWidth = rectHeight * initialAspectRatio;
    }

    rect = Box.fromCenter(
      center: initialRect.center,
      width: rectWidth,
      height: rectHeight,
    );

    if (rect.width > area.width || rect.height > area.height) {
      rect = area;
      return InternalResizeResult(rect: area, largest: area);
    }

    return InternalResizeResult(rect: rect, largest: area);
  }

  /// Handle resizing for [HandlePosition.topLeft] handle
  /// for [ResizeMode.scale].
  static InternalResizeResult handleTopLeft(
    Box rect,
    Box initialRect,
    Box clampingRect,
    HandlePosition handle,
  ) {
    final area = getAvailableAreaForHandle(
      rect: rect,
      clampingRect: clampingRect,
      handle: handle,
    );

    final initialAspectRatio = initialRect.width / initialRect.height;

    double rectWidth = rect.width;
    double rectHeight = rect.height;

    final cursorRect = rect;

    if (cursorRect.aspectRatio.abs() < initialAspectRatio.abs()) {
      rectWidth = rectHeight * initialAspectRatio;
    } else {
      rectHeight = rectWidth / initialAspectRatio;
    }

    final effectiveArea = getClampingRectForHandle(
      initialRect: initialRect,
      availableArea: area,
      handle: handle,
    );

    rect = Box.fromHandle(
      handle.anchor(initialRect),
      handle,
      rectWidth,
      rectHeight,
    );

    if (rect.width > effectiveArea.width ||
        rect.height > effectiveArea.height) {
      return InternalResizeResult(rect: effectiveArea, largest: effectiveArea);
    }

    return InternalResizeResult(rect: rect, largest: effectiveArea);
  }

  /// Handle resizing for [HandlePosition.bottomLeft] handle
  /// for [ResizeMode.scale].
  static InternalResizeResult handleBottomLeft(
    Box rect,
    Box initialRect,
    Box clampingRect,
    HandlePosition handle,
  ) {
    final area = getAvailableAreaForHandle(
      rect: rect,
      clampingRect: clampingRect,
      handle: handle,
    );

    final initialAspectRatio = initialRect.width / initialRect.height;

    double rectWidth = rect.width;
    double rectHeight = rect.height;

    final cursorRect = rect;

    if (cursorRect.aspectRatio.abs() < initialAspectRatio.abs()) {
      rectWidth = rectHeight * initialAspectRatio;
    } else {
      rectHeight = rectWidth / initialAspectRatio;
    }

    final effectiveArea = getClampingRectForHandle(
      initialRect: initialRect,
      availableArea: area,
      handle: handle,
    );

    rect = Box.fromHandle(
      handle.anchor(initialRect),
      handle,
      rectWidth,
      rectHeight,
    );

    if (rect.width > effectiveArea.width ||
        rect.height > effectiveArea.height) {
      return InternalResizeResult(rect: effectiveArea, largest: effectiveArea);
    }

    return InternalResizeResult(rect: rect, largest: effectiveArea);
  }

  /// Handle resizing for [HandlePosition.topRight] handle
  /// for [ResizeMode.scale].
  static InternalResizeResult handleTopRight(
    Box rect,
    Box initialRect,
    Box clampingRect,
    HandlePosition handle,
  ) {
    final area = getAvailableAreaForHandle(
      rect: rect,
      clampingRect: clampingRect,
      handle: handle,
    );

    final initialAspectRatio = initialRect.width / initialRect.height;

    double rectWidth = rect.width;
    double rectHeight = rect.height;

    final cursorRect = rect;

    if (cursorRect.aspectRatio.abs() < initialAspectRatio.abs()) {
      rectWidth = rectHeight * initialAspectRatio;
    } else {
      rectHeight = rectWidth / initialAspectRatio;
    }

    final effectiveArea = getClampingRectForHandle(
      initialRect: initialRect,
      availableArea: area,
      handle: handle,
    );

    rect = Box.fromHandle(
      handle.anchor(initialRect),
      handle,
      rectWidth,
      rectHeight,
    );

    if (rect.width > effectiveArea.width ||
        rect.height > effectiveArea.height) {
      return InternalResizeResult(rect: effectiveArea, largest: effectiveArea);
    }

    return InternalResizeResult(rect: rect, largest: effectiveArea);
  }

  /// Handle resizing for [ResizeMode.symmetric].
  static InternalResizeResult handleSymmetricResizing({
    required Box rect,
    required Box clampingRect,
    required HandlePosition handle,
  }) {
    final double horizontalMirrorRight = clampingRect.right - rect.center.x;
    final double horizontalMirrorLeft = rect.center.x - clampingRect.left;
    final double verticalMirrorTop = rect.center.y - clampingRect.top;
    final double verticalMirrorBottom = clampingRect.bottom - rect.center.y;
    return InternalResizeResult(
      rect: Box.fromCenter(
        center: rect.center,
        width: min(
          min(horizontalMirrorLeft, horizontalMirrorRight) * 2,
          rect.width,
        ),
        height: min(
          min(verticalMirrorTop, verticalMirrorBottom) * 2,
          rect.height,
        ),
      ),
      largest: clampingRect,
    );
  }

  /// Handle resizing for [ResizeMode.scale].
  static InternalResizeResult handleScaleResizing({
    required Box rect,
    required Box initialBox,
    required Box clampingRect,
    required HandlePosition handle,
    required Flip flip,
  }) {
    final flippedHandle = handle.flip(flip);
    final initialRect = flipBox(initialBox, flip, handle);

    InternalResizeResult result;

    switch (flippedHandle) {
      case HandlePosition.topLeft:
        result = handleTopLeft(rect, initialRect, clampingRect, flippedHandle);
        break;
      case HandlePosition.topRight:
        result = handleTopRight(rect, initialRect, clampingRect, flippedHandle);
        break;
      case HandlePosition.bottomLeft:
        result =
            handleBottomLeft(rect, initialRect, clampingRect, flippedHandle);
        break;
      case HandlePosition.none:
      case HandlePosition.bottomRight:
        result =
            handleBottomRight(rect, initialRect, clampingRect, flippedHandle);
        break;
      case HandlePosition.left:
        result = handleLeft(rect, initialRect, clampingRect, flippedHandle);
        break;
      case HandlePosition.top:
        result = handleTop(rect, initialRect, clampingRect, flippedHandle);
        break;
      case HandlePosition.right:
        result = handleRight(rect, initialRect, clampingRect, flippedHandle);
        break;
      case HandlePosition.bottom:
        result = handleBottom(rect, initialRect, clampingRect, flippedHandle);
        break;
    }
    return result;
  }

  /// Handle resizing for [ResizeMode.scaledSymmetric].
  static InternalResizeResult handleSymmetricScaleResizing({
    required Box rect,
    required Box initialBox,
    required Box clampingRect,
    required HandlePosition handle,
    required Flip flip,
  }) {
    switch (handle) {
      case HandlePosition.none:
      case HandlePosition.topLeft:
      case HandlePosition.topRight:
      case HandlePosition.bottomLeft:
      case HandlePosition.bottomRight:
        return handleScaleSymmetricCorner(
            rect, initialBox, clampingRect, handle);
      case HandlePosition.left:
      case HandlePosition.top:
      case HandlePosition.right:
      case HandlePosition.bottom:
        return handleScaleSymmetricSide(rect, initialBox, clampingRect, handle);
    }
  }
}

/// The result of a resize operation.
@visibleForTesting
class InternalResizeResult {
  /// The resulting rect after the resize operation.
  final Box rect;

  /// The largest rect that was used as clamping rect during
  /// the resize operation.
  final Box largest;

  /// The result of a resize operation.
  InternalResizeResult({
    required this.rect,
    required this.largest,
  });

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is InternalResizeResult &&
          runtimeType == other.runtimeType &&
          rect == other.rect &&
          largest == other.largest;

  @override
  int get hashCode => Object.hash(rect, largest);

  @override
  String toString() {
    return 'InternalResizeResult(rect: $rect, largest: $largest)';
  }
}
