part of 'resizer.dart';

/// Handles resizing for [ResizeMode.symmetricScale].
final class SymmetricScaleResizer extends Resizer {
  /// A default constructor for [SymmetricScaleResizer].
  const SymmetricScaleResizer();

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
    switch (handle) {
      case HandlePosition.none:
        throw ArgumentError('HandlePosition.none is not supported!');
      case HandlePosition.topLeft:
      case HandlePosition.topRight:
      case HandlePosition.bottomLeft:
      case HandlePosition.bottomRight:
        return handleScaleSymmetricCorner(
          explodedRect,
          initialRect,
          clampingRect,
          handle.isNone ? HandlePosition.bottomRight : handle,
          constraints,
          rotation,
        );
      case HandlePosition.left:
      case HandlePosition.top:
      case HandlePosition.right:
      case HandlePosition.bottom:
        return handleScaleSymmetricSide(
          explodedRect,
          initialRect,
          clampingRect,
          handle,
          constraints,
          rotation,
        );
    }
  }

  /// Handles the symmetric resize mode for corner handles.
  ({Box rect, Box largest, bool hasValidFlip}) handleScaleSymmetricCorner(
    Box rect,
    Box initialRect,
    Box clampingRect,
    HandlePosition handle,
    Constraints constraints,
    double rotation,
  ) {
    final initialAspectRatio = initialRect.safeAspectRatio;

    final Box availableArea;

    if (!constraints.isUnconstrained) {
      final constrainedBox = Box.fromCenter(
        center: initialRect.center,
        width: constraints.maxWidth,
        height: constraints.maxHeight,
      );
      availableArea = Box.fromLTRB(
        max(constrainedBox.left, clampingRect.left),
        max(constrainedBox.top, clampingRect.top),
        min(constrainedBox.right, clampingRect.right),
        min(constrainedBox.bottom, clampingRect.bottom),
      );
    } else {
      availableArea = clampingRect;
    }

    final maxRect = scaledSymmetricClampingRect(initialRect, availableArea);

    final Box minRect;
    if (!constraints.isUnconstrained) {
      final double minWidth;
      final double minHeight;
      if (initialRect.safeAspectRatio > 1) {
        minHeight = constraints.minHeight;
        minWidth = minHeight * initialAspectRatio;
      } else {
        minWidth = constraints.minWidth;
        minHeight = minWidth / initialAspectRatio;
      }
      minRect = Box.fromCenter(
        center: initialRect.center,
        width: minWidth,
        height: minHeight,
      );
    } else {
      minRect = Box.fromCenter(
        center: initialRect.center,
        width: 0,
        height: 0,
      );
    }

    double rectWidth = rect.width;
    double rectHeight = rect.height;

    final cursorRect = rect;

    if (cursorRect.safeAspectRatio.abs() < initialAspectRatio.abs()) {
      rectWidth = rectHeight * initialAspectRatio;
    } else {
      rectHeight = rectWidth / initialAspectRatio;
    }

    rect = Box.fromCenter(
      center: initialRect.center,
      width: rectWidth,
      height: rectHeight,
    );

    // Check for conflicting constraints when rotation is involved
    if (rotation != 0 && (maxRect.width < minRect.width || maxRect.height < minRect.height)) {
      // Let rotation handling find the optimal size
    } else if (rect.width > maxRect.width || rect.height > maxRect.height) {
      rect = maxRect;
    } else if (rect.width < minRect.width || rect.height < minRect.height) {
      rect = minRect;
    }

    // Apply rotation handling if there's rotation - after size constraints
    bool hasValidFlip = true;
    if (rotation != 0) {
      final rotationResult = _applyRotationHandling(
        rect: rect,
        initialRect: initialRect,
        clampingRect: clampingRect,
        constraints: constraints,
        rotation: rotation,
      );
      
      rect = rotationResult.rect;
      hasValidFlip = rotationResult.isValid;
    }

    return (rect: rect, largest: maxRect, hasValidFlip: hasValidFlip);
  }

  /// Handles the symmetric resize mode for side handles.
  ({Box rect, Box largest, bool hasValidFlip}) handleScaleSymmetricSide(
    Box rect,
    Box initialRect,
    Box clampingRect,
    HandlePosition handle,
    Constraints constraints,
    double rotation,
  ) {
    final initialAspectRatio = initialRect.safeAspectRatio;

    final Box availableArea;

    if (!constraints.isUnconstrained) {
      final constrainedBox = Box.fromCenter(
        center: initialRect.center,
        width: constraints.maxWidth,
        height: constraints.maxHeight,
      );
      availableArea = Box.fromLTRB(
        max(constrainedBox.left, clampingRect.left),
        max(constrainedBox.top, clampingRect.top),
        min(constrainedBox.right, clampingRect.right),
        min(constrainedBox.bottom, clampingRect.bottom),
      );
    } else {
      availableArea = clampingRect;
    }

    final maxRect = scaledSymmetricClampingRect(initialRect, availableArea);

    final Box minRect;
    if (!constraints.isUnconstrained) {
      final double minWidth;
      final double minHeight;
      if (initialRect.safeAspectRatio > 1) {
        minHeight = constraints.minHeight;
        minWidth = minHeight * initialAspectRatio;
      } else {
        minWidth = constraints.minWidth;
        minHeight = minWidth / initialAspectRatio;
      }
      minRect = Box.fromCenter(
        center: initialRect.center,
        width: minWidth,
        height: minHeight,
      );
    } else {
      minRect = Box.fromCenter(
        center: initialRect.center,
        width: 0,
        height: 0,
      );
    }

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

    if (rect.width > maxRect.width || rect.height > maxRect.height) {
      rect = maxRect;
    } else if (rect.width < minRect.width || rect.height < minRect.height) {
      rect = minRect;
    }

    // Apply rotation handling if there's rotation - after size constraints
    bool hasValidFlip = true;
    if (rotation != 0) {
      final rotationResult = _applyRotationHandling(
        rect: rect,
        initialRect: initialRect,
        clampingRect: clampingRect,
        constraints: constraints,
        rotation: rotation,
      );
      
      rect = rotationResult.rect;
      hasValidFlip = rotationResult.isValid;
    }

    return (rect: rect, largest: maxRect, hasValidFlip: hasValidFlip);
  }

  /// Applies rotation handling to a resized rectangle.
  /// This includes repositioning, clamping, and validation for rotated rectangles.
  ({Box rect, bool isValid}) _applyRotationHandling({
    required Box rect,
    required Box initialRect,
    required Box clampingRect,
    required Constraints constraints,
    required double rotation,
  }) {
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
      // For symmetric scale mode, scale down while maintaining aspect ratio and center
      rect = _scaleToFitClampingBounds(
        rect: rect,
        initialRect: initialRect,
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

    return (rect: rect, isValid: isValid);
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
    required Box initialRect,
    required Box clampingRect,
    required double rotation,
    required Constraints constraints,
  }) {
    final center = initialRect.center; // Use initial rect center for symmetric resize
    
    // Binary search for the maximum scale that fits
    // Start with a range that could potentially work
    double lowScale = 0.01; // Start very small to find any possible size
    double highScale = 10.0; // Allow scaling up beyond original size
    double bestScale = lowScale;
    
    for (int i = 0; i < 30; i++) {
      final scale = (lowScale + highScale) / 2;
      
      final scaledWidth = rect.width * scale;
      final scaledHeight = rect.height * scale;
      
      
      // Maintain aspect ratio (should be maintained already since both are scaled equally)
      double finalWidth = scaledWidth;
      double finalHeight = scaledHeight;
      
      final testRect = Box.fromCenter(
        center: center,
        width: finalWidth,
        height: finalHeight,
      );
      
      final testBoundingRect = BoxTransformer.calculateBoundingRect(
        rotation: rotation,
        unrotatedBox: testRect,
      );
      
      final isClamped = isRectClamped(testBoundingRect, clampingRect);
      final isConstrained = isRectConstrained(testRect, constraints);
      
      if (isClamped && isConstrained) {
        bestScale = scale;
        lowScale = scale;
      } else {
        highScale = scale;
      }
    }
    
    // Apply the best scale found
    final scaledWidth = rect.width * bestScale;
    final scaledHeight = rect.height * bestScale;
    
    // For rotation cases, prioritize clamping bounds over minimum constraints
    // to avoid returning a box that exceeds the clamping rect
    final finalWidth = scaledWidth.clamp(0.0, constraints.maxWidth);
    final finalHeight = scaledHeight.clamp(0.0, constraints.maxHeight);
    
    return Box.fromCenter(
      center: center,
      width: finalWidth,
      height: finalHeight,
    );
  }
}
