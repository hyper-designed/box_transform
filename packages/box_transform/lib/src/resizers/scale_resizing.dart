part of 'resizer.dart';

/// Handles resizing for [ResizeMode.scale].
final class ScaleResizer extends Resizer {
  /// A default constructor for [ScaleResizer].
  const ScaleResizer();

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
    ({Box rect, Box largest, bool hasValidFlip}) result = _resizeRect(
      initialRect: initialRect,
      explodedRect: explodedRect,
      clampingRect: clampingRect,
      handle: handle,
      constraints: constraints,
      flip: flip,
    );

    // Apply rotation handling if there's rotation
    if (rotation != 0 && result.hasValidFlip) {
      result = _applyRotationHandling(
        result: result,
        initialRect: initialRect,
        clampingRect: clampingRect,
        constraints: constraints,
        rotation: rotation,
      );
    }

    if (!result.hasValidFlip) {
      // Since we can't flip the box, explodedRect (which is a raw rect with delta applied)
      // would be flipped so we can't use that because it would make the size
      // calculations wrong. Instead we use box from the result which is the
      // flipped box but with correct constraints applied. (min rect always).
      final newResult = _resizeRect(
        explodedRect: result.rect,
        initialRect: initialRect,
        clampingRect: clampingRect,
        handle: handle,
        flip: Flip.none,
        constraints: constraints,
      );

      // Apply rotation handling to the fallback result if there's rotation
      if (rotation != 0 && newResult.hasValidFlip) {
        final rotatedNewResult = _applyRotationHandling(
          result: newResult,
          initialRect: initialRect,
          clampingRect: clampingRect,
          constraints: constraints,
          rotation: rotation,
        );
        
        if (!rotatedNewResult.hasValidFlip) {
          // This should never happen. If it does, it means that the box is
          // invalid even after flipping it back to the original state and we
          // can't flip it back again. This means that the box might be invalid
          // in the first place or something catastrophic happened!!! Contact
          // the package author if this happens.
          return (
            rect: initialRect,
            largest: result.largest,
            hasValidFlip: false
          );
        }

        return rotatedNewResult;
      }

      if (!newResult.hasValidFlip) {
        // This should never happen. If it does, it means that the box is
        // invalid even after flipping it back to the original state and we
        // can't flip it back again. This means that the box might be invalid
        // in the first place or something catastrophic happened!!! Contact
        // the package author if this happens.
        return (
          rect: initialRect,
          largest: result.largest,
          hasValidFlip: false
        );
      }

      return newResult;
    }

    return result;
  }

  ({Box rect, Box largest, bool hasValidFlip}) _resizeRect({
    required Box initialRect,
    required Box explodedRect,
    required Box clampingRect,
    required HandlePosition handle,
    required Constraints constraints,
    required Flip flip,
  }) {
    final flippedHandle = handle.flip(flip);
    final effectiveInitialRect = flipRect(initialRect, flip, handle);

    ({Box rect, Box largest, bool hasValidFlip}) result;

    switch (flippedHandle) {
      case HandlePosition.none:
        throw ArgumentError('HandlePosition.none is not supported!');
      case HandlePosition.topLeft:
        result = handleTopLeft(explodedRect, effectiveInitialRect, clampingRect,
            flippedHandle, constraints, flip);
        break;
      case HandlePosition.topRight:
        result = handleTopRight(explodedRect, effectiveInitialRect,
            clampingRect, flippedHandle, constraints, flip);
        break;
      case HandlePosition.bottomLeft:
        result = handleBottomLeft(explodedRect, effectiveInitialRect,
            clampingRect, flippedHandle, constraints, flip);
        break;
      case HandlePosition.bottomRight:
        result = handleBottomRight(explodedRect, effectiveInitialRect,
            clampingRect, flippedHandle, constraints, flip);
        break;
      case HandlePosition.left:
        result = handleLeft(explodedRect, effectiveInitialRect, clampingRect,
            flippedHandle, constraints, flip);
        break;
      case HandlePosition.top:
        result = handleTop(explodedRect, effectiveInitialRect, clampingRect,
            flippedHandle, constraints, flip);
        break;
      case HandlePosition.right:
        result = handleRight(explodedRect, effectiveInitialRect, clampingRect,
            flippedHandle, constraints, flip);
        break;
      case HandlePosition.bottom:
        result = handleBottom(explodedRect, effectiveInitialRect, clampingRect,
            flippedHandle, constraints, flip);
        break;
    }

    return result;
  }

  /// Handle resizing for [HandlePosition.bottomRight] handle
  /// for [ResizeMode.scale].
  ({Box rect, Box largest, bool hasValidFlip}) handleBottomRight(
    Box rect,
    Box initialRect,
    Box clampingRect,
    HandlePosition handle,
    Constraints constraints,
    Flip flip,
  ) {
    Box area = getAvailableAreaForHandle(
      rect: initialRect,
      clampingRect: clampingRect,
      handle: handle,
      constraints: constraints,
    );

    area = constrainAvailableAreaForScaling(
      area: area,
      initialRect: initialRect,
      handle: handle,
      constraints: constraints,
    );

    final initialAspectRatio = initialRect.safeAspectRatio;

    double rectWidth = rect.width;
    double rectHeight = rect.height;

    final cursorRect = rect;

    if (cursorRect.safeAspectRatio.abs() < initialAspectRatio.abs()) {
      rectWidth = rectHeight * initialAspectRatio;
    } else {
      rectHeight = rectWidth / initialAspectRatio;
    }

    final maxRect = getClampingRectForHandle(
      initialRect: initialRect,
      availableArea: area,
      handle: handle,
    );

    final minRect = getMinRectForScaling(
      initialRect: initialRect,
      handle: handle,
      constraints: constraints,
    );

    rect = Box.fromHandle(
      handle.anchor(initialRect),
      handle,
      rectWidth,
      rectHeight,
    );

    Box largest = maxRect;
    if (rect.width > maxRect.width || rect.height > maxRect.height) {
      rect = maxRect;
      largest = maxRect;
    } else if (rect.width < minRect.width || rect.height < minRect.height) {
      rect = minRect;
      largest = maxRect;
    }

    final isValid = isRectBound(rect, constraints, clampingRect);

    return (rect: rect, largest: largest, hasValidFlip: isValid);
  }

  /// Handle resizing for the right handle.
  ({Box rect, Box largest, bool hasValidFlip}) handleRight(
    Box rect,
    Box initialRect,
    Box clampingRect,
    HandlePosition handle,
    Constraints constraints,
    Flip flip,
  ) {
    final initialAspectRatio = initialRect.safeAspectRatio;

    Box area = getAvailableAreaForHandle(
      rect: initialRect,
      clampingRect: clampingRect,
      handle: handle,
      constraints: constraints,
    );

    area = constrainAvailableAreaForScaling(
      area: area,
      initialRect: initialRect,
      handle: handle,
      constraints: constraints,
    );

    if (area.width < initialRect.width) {
      // initial box needs shrinking
      final maxWidth = area.width;
      final maxHeight = maxWidth / initialAspectRatio;

      initialRect = Box.fromHandle(
        handle.anchor(initialRect),
        handle,
        maxWidth,
        maxHeight,
      );
    }

    final maxRect = getClampingRectForHandle(
      initialRect: initialRect,
      availableArea: area,
      handle: handle,
    );

    final minRect = getMinRectForScaling(
      initialRect: initialRect,
      handle: handle,
      constraints: constraints,
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

    Box largest = maxRect;
    if (rect.width > maxRect.width || rect.height > maxRect.height) {
      rect = maxRect;
      largest = maxRect;
    } else if (rect.width < minRect.width || rect.height < minRect.height) {
      rect = minRect;
      largest = maxRect;
    }

    final isValid = isRectBound(rect, constraints, clampingRect);

    return (rect: rect, largest: largest, hasValidFlip: isValid);
  }

  /// handle resizing for the left handle
  ({Box rect, Box largest, bool hasValidFlip}) handleLeft(
    Box rect,
    Box initialRect,
    Box clampingRect,
    HandlePosition handle,
    Constraints constraints,
    Flip flip,
  ) {
    final initialAspectRatio = initialRect.safeAspectRatio;

    Box area = getAvailableAreaForHandle(
      rect: initialRect,
      clampingRect: clampingRect,
      handle: handle,
      constraints: constraints,
    );

    area = constrainAvailableAreaForScaling(
      area: area,
      initialRect: initialRect,
      handle: handle,
      constraints: constraints,
    );

    if (area.width < initialRect.width) {
      // initial box needs shrinking
      final maxWidth = area.width;
      final maxHeight = maxWidth / initialAspectRatio;

      initialRect = Box.fromHandle(
        handle.anchor(initialRect),
        handle,
        maxWidth,
        maxHeight,
      );
    }

    final maxRect = getClampingRectForHandle(
      initialRect: initialRect,
      availableArea: area,
      handle: handle,
    );

    final minRect = getMinRectForScaling(
      initialRect: initialRect,
      handle: handle,
      constraints: constraints,
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

    Box largest = maxRect;
    if (rect.width > maxRect.width || rect.height > maxRect.height) {
      rect = maxRect;
      largest = maxRect;
    } else if (rect.width < minRect.width || rect.height < minRect.height) {
      rect = minRect;
      largest = maxRect;
    }

    final isValid = isRectBound(rect, constraints, clampingRect);

    return (rect: rect, largest: largest, hasValidFlip: isValid);
  }

  /// handle resizing for the bottom handle.
  ({Box rect, Box largest, bool hasValidFlip}) handleBottom(
    Box rect,
    Box initialRect,
    Box clampingRect,
    HandlePosition handle,
    Constraints constraints,
    Flip flip,
  ) {
    final initialAspectRatio = initialRect.safeAspectRatio;

    Box area = getAvailableAreaForHandle(
      rect: initialRect,
      clampingRect: clampingRect,
      handle: handle,
      constraints: constraints,
    );

    area = constrainAvailableAreaForScaling(
      area: area,
      initialRect: initialRect,
      handle: handle,
      constraints: constraints,
    );

    if (area.height < initialRect.height) {
      // initial box needs shrinking
      final maxHeight = area.height;
      final maxWidth = maxHeight * initialAspectRatio;

      initialRect = Box.fromHandle(
        handle.anchor(initialRect),
        handle,
        maxWidth,
        maxHeight,
      );
    }

    final maxRect = getClampingRectForHandle(
      initialRect: initialRect,
      availableArea: area,
      handle: handle,
    );

    final minRect = getMinRectForScaling(
      initialRect: initialRect,
      handle: handle,
      constraints: constraints,
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

    Box largest = maxRect;
    if (rect.width > maxRect.width || rect.height > maxRect.height) {
      rect = maxRect;
      largest = maxRect;
    } else if (rect.width < minRect.width || rect.height < minRect.height) {
      rect = minRect;
      largest = maxRect;
    }

    final isValid = isRectBound(rect, constraints, clampingRect);

    return (rect: rect, largest: largest, hasValidFlip: isValid);
  }

  /// handle resizing for the top handle.
  ({Box rect, Box largest, bool hasValidFlip}) handleTop(
    Box rect,
    Box initialRect,
    Box clampingRect,
    HandlePosition handle,
    Constraints constraints,
    Flip flip,
  ) {
    final initialAspectRatio = initialRect.safeAspectRatio;

    Box area = getAvailableAreaForHandle(
      rect: initialRect,
      clampingRect: clampingRect,
      handle: handle,
      constraints: constraints,
    );

    area = constrainAvailableAreaForScaling(
      area: area,
      initialRect: initialRect,
      handle: handle,
      constraints: constraints,
    );

    if (area.height < initialRect.height) {
      // initial box needs shrinking
      final maxHeight = area.height;
      final maxWidth = maxHeight * initialAspectRatio;

      initialRect = Box.fromHandle(
        handle.anchor(initialRect),
        handle,
        maxWidth,
        maxHeight,
      );
    }

    final maxRect = getClampingRectForHandle(
      initialRect: initialRect,
      availableArea: area,
      handle: handle,
    );

    final minRect = getMinRectForScaling(
      initialRect: initialRect,
      handle: handle,
      constraints: constraints,
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

    Box largest = maxRect;
    if (rect.width > maxRect.width || rect.height > maxRect.height) {
      rect = maxRect;
      largest = maxRect;
    } else if (rect.width < minRect.width || rect.height < minRect.height) {
      rect = minRect;
      largest = maxRect;
    }

    final isValid = isRectBound(rect, constraints, clampingRect);

    return (rect: rect, largest: largest, hasValidFlip: isValid);
  }

  /// Handle resizing for [HandlePosition.topLeft] handle
  /// for [ResizeMode.scale].
  ({Box rect, Box largest, bool hasValidFlip}) handleTopLeft(
    Box rect,
    Box initialRect,
    Box clampingRect,
    HandlePosition handle,
    Constraints constraints,
    Flip flip,
  ) {
    Box area = getAvailableAreaForHandle(
      rect: initialRect,
      clampingRect: clampingRect,
      handle: handle,
      constraints: constraints,
    );

    area = constrainAvailableAreaForScaling(
      area: area,
      initialRect: initialRect,
      handle: handle,
      constraints: constraints,
    );

    final initialAspectRatio = initialRect.safeAspectRatio;

    double rectWidth = rect.width;
    double rectHeight = rect.height;

    final cursorRect = rect;

    if (cursorRect.safeAspectRatio.abs() < initialAspectRatio.abs()) {
      rectWidth = rectHeight * initialAspectRatio;
    } else {
      rectHeight = rectWidth / initialAspectRatio;
    }

    final maxRect = getClampingRectForHandle(
      initialRect: initialRect,
      availableArea: area,
      handle: handle,
    );

    final minRect = getMinRectForScaling(
      initialRect: initialRect,
      handle: handle,
      constraints: constraints,
    );

    rect = Box.fromHandle(
      handle.anchor(initialRect),
      handle,
      rectWidth,
      rectHeight,
    );

    Box largest = maxRect;
    if (rect.width > maxRect.width || rect.height > maxRect.height) {
      rect = maxRect;
      largest = maxRect;
    } else if (rect.width < minRect.width || rect.height < minRect.height) {
      rect = minRect;
      largest = maxRect;
    }

    final isValid = isRectBound(rect, constraints, clampingRect);

    return (rect: rect, largest: largest, hasValidFlip: isValid);
  }

  /// Handle resizing for [HandlePosition.bottomLeft] handle
  /// for [ResizeMode.scale].
  ({Box rect, Box largest, bool hasValidFlip}) handleBottomLeft(
    Box rect,
    Box initialRect,
    Box clampingRect,
    HandlePosition handle,
    Constraints constraints,
    Flip flip,
  ) {
    Box area = getAvailableAreaForHandle(
      rect: initialRect,
      clampingRect: clampingRect,
      handle: handle,
      constraints: constraints,
    );

    area = constrainAvailableAreaForScaling(
      area: area,
      initialRect: initialRect,
      handle: handle,
      constraints: constraints,
    );

    final initialAspectRatio = initialRect.safeAspectRatio;

    double rectWidth = rect.width;
    double rectHeight = rect.height;

    final cursorRect = rect;

    if (cursorRect.safeAspectRatio.abs() < initialAspectRatio.abs()) {
      rectWidth = rectHeight * initialAspectRatio;
    } else {
      rectHeight = rectWidth / initialAspectRatio;
    }

    final maxRect = getClampingRectForHandle(
      initialRect: initialRect,
      availableArea: area,
      handle: handle,
    );

    final minRect = getMinRectForScaling(
      initialRect: initialRect,
      handle: handle,
      constraints: constraints,
    );

    rect = Box.fromHandle(
      handle.anchor(initialRect),
      handle,
      rectWidth,
      rectHeight,
    );

    Box largest = maxRect;
    if (rect.width > maxRect.width || rect.height > maxRect.height) {
      rect = maxRect;
      largest = maxRect;
    } else if (rect.width < minRect.width || rect.height < minRect.height) {
      rect = minRect;
      largest = maxRect;
    }

    final isValid = isRectBound(rect, constraints, clampingRect);

    return (rect: rect, largest: largest, hasValidFlip: isValid);
  }

  /// Handle resizing for [HandlePosition.topRight] handle
  /// for [ResizeMode.scale].
  ({Box rect, Box largest, bool hasValidFlip}) handleTopRight(
    Box rect,
    Box initialRect,
    Box clampingRect,
    HandlePosition handle,
    Constraints constraints,
    Flip flip,
  ) {
    Box area = getAvailableAreaForHandle(
      rect: initialRect,
      clampingRect: clampingRect,
      handle: handle,
      constraints: constraints,
    );

    area = constrainAvailableAreaForScaling(
      area: area,
      initialRect: initialRect,
      handle: handle,
      constraints: constraints,
    );

    final initialAspectRatio = initialRect.safeAspectRatio;

    double rectWidth = rect.width;
    double rectHeight = rect.height;

    final cursorRect = rect;

    if (cursorRect.safeAspectRatio.abs() < initialAspectRatio.abs()) {
      rectWidth = rectHeight * initialAspectRatio;
    } else {
      rectHeight = rectWidth / initialAspectRatio;
    }

    final maxRect = getClampingRectForHandle(
      initialRect: initialRect,
      availableArea: area,
      handle: handle,
    );

    final minRect = getMinRectForScaling(
      initialRect: initialRect,
      handle: handle,
      constraints: constraints,
    );

    rect = Box.fromHandle(
      handle.anchor(initialRect),
      handle,
      rectWidth,
      rectHeight,
    );

    Box largest = maxRect;
    if (rect.width > maxRect.width || rect.height > maxRect.height) {
      rect = maxRect;
      largest = maxRect;
    } else if (rect.width < minRect.width || rect.height < minRect.height) {
      rect = minRect;
      largest = maxRect;
    }

    final isValid = isRectBound(rect, constraints, clampingRect);

    return (rect: rect, largest: largest, hasValidFlip: isValid);
  }

  /// Applies rotation handling to a resize result.
  /// This includes repositioning, clamping, and validation for rotated rectangles.
  ({Box rect, Box largest, bool hasValidFlip}) _applyRotationHandling({
    required ({Box rect, Box largest, bool hasValidFlip}) result,
    required Box initialRect,
    required Box clampingRect,
    required Constraints constraints,
    required double rotation,
  }) {
    Box rect = result.rect;

    // Apply rotation repositioning
    rect = _repositionRotatedResizedBox(
      newRect: rect,
      initialRect: initialRect,
      rotation: rotation,
    );

    // Apply rotation-aware clamping
    final newBoundingRect = BoxTransformer.calculateBoundingRect(
      rotation: rotation,
      unrotatedBox: rect,
    );

    final bool isClamped = isRectClamped(
      newBoundingRect,
      clampingRect,
    );

    if (!isClamped) {
      // For scale mode, we need to scale down while maintaining aspect ratio
      // Try to find the maximum scale factor that fits within clamping bounds
      rect = _scaleToFitClampingBounds(
        rect: rect,
        clampingRect: clampingRect,
        rotation: rotation,
        constraints: constraints,
      );
    }

    // Update validation to handle rotation
    final newBoundingRectFinal = BoxTransformer.calculateBoundingRect(
      rotation: rotation,
      unrotatedBox: rect,
    );
    final bool isValid = isRectConstrained(rect, constraints) && 
                         isRectClamped(newBoundingRectFinal, clampingRect);

    return (rect: rect, largest: result.largest, hasValidFlip: isValid);
  }

  /// Repositions a resized box when rotation is applied to maintain proper
  /// handle anchoring.
  Box _repositionRotatedResizedBox({
    required Box newRect,
    required Box initialRect,
    required double rotation,
  }) {
    // If there is no rotation, no repositioning is needed.
    if (rotation == 0) return newRect;

    // Compute the delta between the top-left corners of the new and initial
    // rectangles.
    final Vector2 positionDelta = newRect.topLeft - initialRect.topLeft;

    // Calculate the new position in the unrotated space.
    final Vector2 newPos = BoxTransformer.calculateUnrotatedPos(
      initialRect,
      rotation,
      positionDelta,
      newRect.size,
    );

    // Return a new Box with the repositioned top-left coordinates.
    return Box.fromLTWH(newPos.x, newPos.y, newRect.width, newRect.height);
  }

  /// Scales a rectangle down to fit within clamping bounds while maintaining aspect ratio
  Box _scaleToFitClampingBounds({
    required Box rect,
    required Box clampingRect,
    required double rotation,
    required Constraints constraints,
  }) {
    final aspectRatio = rect.width / rect.height;
    final center = rect.center;
    
    // Binary search for the maximum scale that fits
    double lowScale = 0.1;
    double highScale = 1.0;
    double bestScale = lowScale;
    
    for (int i = 0; i < 20; i++) {
      final scale = (lowScale + highScale) / 2;
      
      final scaledWidth = (rect.width * scale).clamp(constraints.minWidth, constraints.maxWidth);
      final scaledHeight = (rect.height * scale).clamp(constraints.minHeight, constraints.maxHeight);
      
      // Maintain aspect ratio by adjusting the smaller dimension
      double finalWidth, finalHeight;
      if (scaledWidth / scaledHeight > aspectRatio) {
        finalHeight = scaledHeight;
        finalWidth = finalHeight * aspectRatio;
      } else {
        finalWidth = scaledWidth;
        finalHeight = finalWidth / aspectRatio;
      }
      
      final testRect = Box.fromCenter(
        center: center,
        width: finalWidth,
        height: finalHeight,
      );
      
      final testBoundingRect = BoxTransformer.calculateBoundingRect(
        rotation: rotation,
        unrotatedBox: testRect,
      );
      
      if (isRectClamped(testBoundingRect, clampingRect) && 
          isRectConstrained(testRect, constraints)) {
        bestScale = scale;
        lowScale = scale;
      } else {
        highScale = scale;
      }
    }
    
    // Apply the best scale found
    final finalWidth = (rect.width * bestScale).clamp(constraints.minWidth, constraints.maxWidth);
    final finalHeight = (rect.height * bestScale).clamp(constraints.minHeight, constraints.maxHeight);
    
    return Box.fromCenter(
      center: center,
      width: finalWidth,
      height: finalHeight,
    );
  }
}
