part of 'resizer.dart';

/// Handles resizing for [ResizeMode.symmetric].
final class SymmetricResizer extends Resizer {
  /// A default constructor for [SymmetricResizer].
  const SymmetricResizer();

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
    final double horizontalMirrorRight =
        clampingRect.right - explodedRect.center.x;
    final double horizontalMirrorLeft =
        explodedRect.center.x - clampingRect.left;
    final double verticalMirrorTop = explodedRect.center.y - clampingRect.top;
    final double verticalMirrorBottom =
        clampingRect.bottom - explodedRect.center.y;

    Box area = Box.fromCenter(
      center: explodedRect.center,
      width: min(horizontalMirrorLeft, horizontalMirrorRight) * 2,
      height: min(verticalMirrorTop, verticalMirrorBottom) * 2,
    );

    if (!constraints.isUnconstrained) {
      final constrainedBox = Box.fromCenter(
        center: explodedRect.center,
        width: constraints.maxWidth,
        height: constraints.maxHeight,
      );

      area = Box.fromLTRB(
        max(area.left, constrainedBox.left),
        max(area.top, constrainedBox.top),
        min(area.right, constrainedBox.right),
        min(area.bottom, constrainedBox.bottom),
      );
    }

    final Box minRect = Box.fromCenter(
      center: explodedRect.center,
      width: constraints.isUnconstrained ? 0 : constraints.minWidth,
      height: constraints.isUnconstrained ? 0 : constraints.minHeight,
    );

    Box newRect = Box.fromCenter(
      center: explodedRect.center,
      width: min(area.width, max(explodedRect.width, minRect.width)),
      height: min(area.height, max(explodedRect.height, minRect.height)),
    );

    // Apply rotation handling if there's rotation
    bool hasValidFlip = true;
    if (rotation != 0) {
      final rotationResult = _applyRotationHandling(
        rect: newRect,
        initialRect: initialRect,
        clampingRect: clampingRect,
        constraints: constraints,
        rotation: rotation,
      );
      
      newRect = rotationResult.rect;
      hasValidFlip = rotationResult.isValid;
    }

    return (rect: newRect, largest: area, hasValidFlip: hasValidFlip);
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
      // For symmetric mode, scale down while maintaining center
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

  /// Scales a rectangle down to fit within clamping bounds for symmetric resizing
  Box _scaleToFitClampingBounds({
    required Box rect,
    required Box clampingRect,
    required double rotation,
    required Constraints constraints,
  }) {
    final center = rect.center;
    
    // Binary search for the maximum scale that fits
    double lowScale = 0.1;
    double highScale = 1.0;
    double bestScale = lowScale;
    
    for (int i = 0; i < 20; i++) {
      final scale = (lowScale + highScale) / 2;
      
      final scaledWidth = (rect.width * scale).clamp(constraints.minWidth, constraints.maxWidth);
      final scaledHeight = (rect.height * scale).clamp(constraints.minHeight, constraints.maxHeight);
      
      final testRect = Box.fromCenter(
        center: center,
        width: scaledWidth,
        height: scaledHeight,
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
