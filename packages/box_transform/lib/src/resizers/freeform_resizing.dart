part of 'resizer.dart';

/// Handles freeform resizing with support for rotation.
///
/// In addition to the freeform resizing logic from the non‐rotated version,
/// this implementation attempts to reposition and constrain a rotated
/// rectangle. The new rectangle is computed based on the user’s drag (the
/// [explodedRect]), the allowed clamping area ([clampingRect]), size
/// constraints, and rotation. It also applies a binding strategy which affects
/// how the available area is computed for the resizing handle.
///
/// **NOTE:** Several parts of this implementation are problematic compared to
/// the non-rotated version which is flawless and passes all tests. The issues
/// are marked inline with `// [ISSUE]`.
final class FreeformResizer extends Resizer {
  /// Creates a constant instance of [FreeformResizer].
  const FreeformResizer();

  /// Resizes the rectangle based on user interaction, constraints, and
  /// rotation.
  ///
  /// Parameters:
  /// - [initialRect]: The original rectangle before resizing begins.
  /// - [explodedRect]: The rectangle produced by applying the user’s drag. It
  ///   might temporarily exceed constraints.
  /// - [clampingRect]: The bounding rectangle within which the resized
  ///   rectangle must remain.
  /// - [handle]: The resizing handle (e.g., a corner or side) that anchors the
  ///   resize operation.
  /// - [constraints]: Minimum and maximum size constraints for the rectangle.
  /// - [flip]: Determines whether the rectangle’s coordinates should be
  ///   flipped.
  /// - [rotation]: The rotation angle (in radians) applied to the rectangle.
  /// - [bindingStrategy]: A strategy indicating whether to bind to the original
  ///   box or its bounding rectangle when computing available area.
  ///
  /// Returns a record containing:
  /// - [rect]: The newly computed rectangle after applying repositioning,
  ///   constraints, and rotation.
  /// - [largest]: The largest available area for the handle, useful for UI hints.
  /// - [hasValidFlip]: A boolean indicating whether the computed rectangle meets
  ///   the constraints (used here as a proxy for valid flipping and binding).
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
    final HandlePosition flippedHandle = handle.flip(flip);

    final Box effectiveInitialRect = flipRect(initialRect, flip, handle);
    final Box initialBoundingRect = BoxTransformer.calculateBoundingRect(
      rotation: rotation,
      unrotatedBox: effectiveInitialRect,
    );
    final Box effectiveInitialBoundingRect =
        flipRect(initialBoundingRect, flip, handle);

    Box newRect = explodedRect;

    // When resizing with rotation, the box must be repositioned immediately
    // after resizing to ensure the opposite handle is anchored properly.
    // The reason this is needed is because when resizing with rotation,
    // the resize happens around the center of the rect, which mobilizes all
    // handles. This corrects that behavior by repositioning the rect.
    newRect = repositionRotatedResizedBox(
      newRect: newRect,
      initialRect: initialRect,
      rotation: rotation,
    );
    Box newBoundingRect = BoxTransformer.calculateBoundingRect(
      rotation: rotation,
      unrotatedBox: newRect,
    );

    // For rotation=0, use simple clamping like the original version
    if (rotation == 0) {
      newRect = Box.fromLTRB(
        max(newRect.left, clampingRect.left),
        max(newRect.top, clampingRect.top),
        min(newRect.right, clampingRect.right),
        min(newRect.bottom, clampingRect.bottom),
      );
    } else {
      // For rotation!=0, use the complex rotation-aware clamping
      final bool isClamped = isRectClamped(
        newBoundingRect,
        clampingRect,
      );

      if (!isClamped) {
        Vector2 correctiveDelta = BoxTransformer.stopRectAtClampingRect(
          rect: newRect,
          clampingRect: clampingRect,
          rotation: rotation,
        );

        final dx = correctiveDelta.x;
        final dy = correctiveDelta.y;

        if (dx != 0 || dy != 0) {
          newRect = Box.fromLTWH(
            newRect.left + dx,
            newRect.top + dy,
            newRect.width,
            newRect.height,
          );
        }

        // Recalculate the bounding rectangle after applying the corrective delta.
        newBoundingRect = BoxTransformer.calculateBoundingRect(
          rotation: rotation,
          unrotatedBox: newRect,
        );
      }
    }

    bool isValid = true;
    if (!constraints.isUnconstrained) {
      final constrainedWidth =
          newRect.width.clamp(constraints.minWidth, constraints.maxWidth);
      final constrainedHeight =
          newRect.height.clamp(constraints.minHeight, constraints.maxHeight);

      if (newRect.width != constrainedWidth ||
          newRect.height != constrainedHeight) {
        isValid = false;
      }

      final constrainedRect = Box.fromHandle(
        flippedHandle.anchor(effectiveInitialRect),
        flippedHandle,
        constrainedWidth,
        constrainedHeight,
      );

      // Reposition again after applying constraints if there's rotation.
      if (rotation != 0) {
        newRect = repositionRotatedResizedBox(
          newRect: constrainedRect,
          initialRect: initialRect,
          rotation: rotation,
        );
      } else {
        newRect = constrainedRect;
      }

      // Update the bounding rectangle to reflect the constrained rect.
      newBoundingRect = BoxTransformer.calculateBoundingRect(
        rotation: rotation,
        unrotatedBox: newRect,
      );

      // Check if the constrained rectangle is valid (both constrained and clamped)
      final bool isRectValid = isRectConstrained(newRect, constraints) && 
                              (rotation == 0 ? isRectClamped(newRect, clampingRect) 
                                             : isRectClamped(newBoundingRect, clampingRect));

      if (!isRectValid) {
        // Instead of falling back to minimum size, find the largest size that fits
        // within clamping bounds while respecting constraints
        // Constraint/clamping conflict detected, finding max size
        if (rotation != 0) {
          // For rotated boxes, we need to find a size where the bounding rect fits
          newRect = _findMaxSizeWithinClampingBounds(
            anchor: handle.anchor(initialRect),
            handle: handle,
            clampingRect: clampingRect,
            constraints: constraints,
            rotation: rotation,
            initialRect: initialRect,
          );
        } else {
          // For non-rotated boxes, use direct clamping
          newRect = Box.fromLTRB(
            max(newRect.left, clampingRect.left),
            max(newRect.top, clampingRect.top),
            min(newRect.right, clampingRect.right),
            min(newRect.bottom, clampingRect.bottom),
          );
          
          // Ensure we still respect constraints
          final clampedWidth = newRect.width.clamp(constraints.minWidth, constraints.maxWidth);
          final clampedHeight = newRect.height.clamp(constraints.minHeight, constraints.maxHeight);
          
          newRect = Box.fromHandle(
            handle.anchor(initialRect),
            handle,
            clampedWidth,
            clampedHeight,
          );
        }

        newBoundingRect = BoxTransformer.calculateBoundingRect(
          rotation: rotation,
          unrotatedBox: newRect,
        );
        isValid = true;
      }
    }

    final Box effectiveBindingRect = switch (bindingStrategy) {
      BindingStrategy.originalBox => effectiveInitialRect,
      BindingStrategy.boundingBox => effectiveInitialBoundingRect,
    };
    final Box bindingRect = switch (bindingStrategy) {
      BindingStrategy.originalBox => initialRect,
      BindingStrategy.boundingBox => initialBoundingRect,
    };

    final Box area = getAvailableAreaForHandle(
      rect: isValid ? effectiveBindingRect : bindingRect,
      handle: isValid ? flippedHandle : handle,
      clampingRect: clampingRect,
    );

    return (rect: newRect, largest: area, hasValidFlip: isValid);
  }

  /// Repositions a rotated and resized box back to its original unrotated
  /// position.
  ///
  /// This method attempts to calculate the correct position for a rectangle
  /// that has been both rotated and resized, returning it to the coordinate
  /// space of the unrotated original rectangle.
  ///
  /// Parameters:
  /// - [newRect]: The current, potentially rotated rectangle.
  /// - [initialRect]: The original rectangle before rotation and resizing.
  /// - [rotation]: The rotation angle (in radians).
  ///
  /// Returns a new [Box] that represents the repositioned rectangle.
  Box repositionRotatedResizedBox({
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

  /// Finds the maximum size rectangle that fits within clamping bounds when rotated
  /// while respecting constraints.
  Box _findMaxSizeWithinClampingBounds({
    required Vector2 anchor,
    required HandlePosition handle,
    required Box clampingRect,
    required Constraints constraints,
    required double rotation,
    required Box initialRect,
  }) {
    // Start with a conservative estimate - the clamping rect dimensions
    // For rotation, the max unrotated size that could fit is roughly clampingRect size / sqrt(2)
    final maxPossibleWidth = clampingRect.width;
    final maxPossibleHeight = clampingRect.height;
    
    double width = min(constraints.maxWidth, maxPossibleWidth);
    double height = min(constraints.maxHeight, maxPossibleHeight);
    
    // Binary search to find the maximum size that fits
    // We'll search for width and height independently if it's a corner handle
    // or just the relevant dimension for side handles
    
    if (handle.isDiagonal) {
      // For corner handles, search for the optimal size as a whole
      final result = _binarySearchOptimalSize(
        anchor: anchor,
        handle: handle,
        clampingRect: clampingRect,
        constraints: constraints,
        rotation: rotation,
        initialRect: initialRect,
      );
      width = result.width;
      height = result.height;
    } else if (handle.isHorizontal) {
      // For horizontal handles, only adjust width
      width = _binarySearchMaxDimension(
        anchor: anchor,
        handle: handle,
        clampingRect: clampingRect,
        constraints: constraints,
        rotation: rotation,
        initialRect: initialRect,
        isWidth: true,
        otherDimension: initialRect.height,
      );
      height = initialRect.height;
    } else {
      // For vertical handles, only adjust height
      height = _binarySearchMaxDimension(
        anchor: anchor,
        handle: handle,
        clampingRect: clampingRect,
        constraints: constraints,
        rotation: rotation,
        initialRect: initialRect,
        isWidth: false,
        otherDimension: initialRect.width,
      );
      width = initialRect.width;
    }
    
    // Create the final rectangle
    final result = Box.fromHandle(anchor, handle, width, height);
    // Found max size within clamping bounds
    
    // Reposition for rotation
    return repositionRotatedResizedBox(
      newRect: result,
      initialRect: initialRect,
      rotation: rotation,
    );
  }

  /// Binary search to find the maximum dimension (width or height) that fits within clamping bounds
  double _binarySearchMaxDimension({
    required Vector2 anchor,
    required HandlePosition handle,
    required Box clampingRect,
    required Constraints constraints,
    required double rotation,
    required Box initialRect,
    required bool isWidth,
    required double otherDimension,
  }) {
    final minConstraint = isWidth ? constraints.minWidth : constraints.minHeight;
    final maxConstraint = isWidth ? constraints.maxWidth : constraints.maxHeight;
    final clampingDimension = isWidth ? clampingRect.width : clampingRect.height;
    
    double low = minConstraint;
    double high = min(maxConstraint, clampingDimension);
    double best = minConstraint;
    
    // Binary search with reasonable precision
    for (int i = 0; i < 20; i++) {
      final mid = (low + high) / 2;
      
      final testWidth = isWidth ? mid : otherDimension;
      final testHeight = isWidth ? otherDimension : mid;
      
      final testRect = Box.fromHandle(anchor, handle, testWidth, testHeight);
      final repositionedRect = repositionRotatedResizedBox(
        newRect: testRect,
        initialRect: initialRect,
        rotation: rotation,
      );
      
      final boundingRect = BoxTransformer.calculateBoundingRect(
        rotation: rotation,
        unrotatedBox: repositionedRect,
      );
      
      if (isRectClamped(boundingRect, clampingRect)) {
        best = mid;
        low = mid;
      } else {
        high = mid;
      }
    }
    
    return best;
  }

  /// Binary search for optimal size for diagonal handles where width and height interact
  ({double width, double height}) _binarySearchOptimalSize({
    required Vector2 anchor,
    required HandlePosition handle,
    required Box clampingRect,
    required Constraints constraints,
    required double rotation,
    required Box initialRect,
  }) {
    // Start with constraint limits
    double bestWidth = constraints.minWidth;
    double bestHeight = constraints.minHeight;
    
    // Try different scaling factors to find the largest that fits
    double lowScale = 0.1;
    double highScale = 5.0; // Start high and work down
    
    for (int i = 0; i < 25; i++) {
      final scale = (lowScale + highScale) / 2;
      
      // Try proportional scaling from initial rect
      final testWidth = (initialRect.width * scale).clamp(constraints.minWidth, constraints.maxWidth);
      final testHeight = (initialRect.height * scale).clamp(constraints.minHeight, constraints.maxHeight);
      
      final testRect = Box.fromHandle(anchor, handle, testWidth, testHeight);
      final repositionedRect = repositionRotatedResizedBox(
        newRect: testRect,
        initialRect: initialRect,
        rotation: rotation,
      );
      
      final boundingRect = BoxTransformer.calculateBoundingRect(
        rotation: rotation,
        unrotatedBox: repositionedRect,
      );
      
      if (isRectClamped(boundingRect, clampingRect) && 
          isRectConstrained(repositionedRect, constraints)) {
        // This size works, try bigger
        bestWidth = testWidth;
        bestHeight = testHeight;
        lowScale = scale;
      } else {
        // Too big, try smaller
        highScale = scale;
      }
    }
    
    return (width: bestWidth, height: bestHeight);
  }
}
