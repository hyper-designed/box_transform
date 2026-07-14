import 'dart:math' as math;
import 'dart:ui';

import 'package:box_transform/box_transform.dart';

import 'extensions.dart';
import 'handles.dart';

/// Pure helpers for the Flutter-side rotated-box layout: rotating points,
/// finding handle anchors in parent / world frames, and computing the rect
/// that the clamp solver enforces under a given [BindingStrategy].
///
/// All members are `static`; the class is not instantiable.
abstract final class RotatedLayout {
  const RotatedLayout._();

  /// Rotates [point] around [pivot] by [angle] radians (CW in y-down screen
  /// coords). Pure function; no state.
  static Offset rotateOffsetAround(Offset point, Offset pivot, double angle) {
    if (angle == 0.0) return point;
    final dx = point.dx - pivot.dx;
    final dy = point.dy - pivot.dy;
    final c = math.cos(angle);
    final s = math.sin(angle);
    return Offset(
      pivot.dx + dx * c - dy * s,
      pivot.dy + dx * s + dy * c,
    );
  }

  /// Returns the un-rotated corner (or side midpoint) of [rect] for [handle].
  static Offset handleCornerInParent(Rect rect, HandlePosition handle) {
    switch (handle) {
      case HandlePosition.topLeft:
        return rect.topLeft;
      case HandlePosition.topRight:
        return rect.topRight;
      case HandlePosition.bottomLeft:
        return rect.bottomLeft;
      case HandlePosition.bottomRight:
        return rect.bottomRight;
      case HandlePosition.top:
        return rect.topCenter;
      case HandlePosition.bottom:
        return rect.bottomCenter;
      case HandlePosition.left:
        return rect.centerLeft;
      case HandlePosition.right:
        return rect.centerRight;
      case HandlePosition.none:
        return rect.center;
    }
  }

  /// Returns the visual (rotated) world-space position of [handle]'s corner
  /// given an un-rotated [rect] rotated by [rotation] radians around its centre.
  static Offset rotatedCornerInWorld(
    Rect rect,
    HandlePosition handle,
    double rotation,
  ) {
    final corner = handleCornerInParent(rect, handle);
    if (rotation == 0.0) return corner;
    return rotateOffsetAround(corner, rect.center, rotation);
  }

  /// Returns the offset within a [handleSize]×[handleSize] handle widget where
  /// the box's corner lands, for the given [handle] position and
  /// [alignment]. This depends on how the handle is positioned relative to the
  /// box edge (inside/outside/center).
  static Offset anchorInHandle(
    HandlePosition handle,
    double handleSize,
    HandleAlignment alignment,
  ) {
    final p = alignment.offset(handleSize);
    return Offset(
      handle.influencesLeft ? p : handleSize - p,
      handle.influencesTop ? p : handleSize - p,
    );
  }

  /// Returns the top-left position (world/parent-local coord frame) where a
  /// handle widget of size [handleSize]×[handleSize] should be placed so that
  /// its internal anchor coincides with the visually-rotated corner of [rect].
  static Offset handleTopLeftInWorld({
    required Rect rect,
    required HandlePosition handle,
    required double rotation,
    required double handleSize,
    required HandleAlignment alignment,
  }) {
    final cornerWorld = rotatedCornerInWorld(rect, handle, rotation);
    final anchor = anchorInHandle(handle, handleSize, alignment);
    return cornerWorld - anchor;
  }

  /// Returns the visual world-space center of the top rotation handle.
  ///
  /// [offsetFromTopEdge] is measured from the unrotated top edge to the handle
  /// center, then rotated with the box around [rect.center].
  static Offset topRotationHandleCenterInWorld({
    required Rect rect,
    required double rotation,
    required double offsetFromTopEdge,
  }) {
    final unrotatedCenter = rect.topCenter.translate(0, -offsetFromTopEdge);
    return rotateOffsetAround(unrotatedCenter, rect.center, rotation);
  }

  /// Returns the top-left position for a square top rotation handle.
  static Offset topRotationHandleTopLeftInWorld({
    required Rect rect,
    required double rotation,
    required double offsetFromTopEdge,
    required double handleSize,
  }) {
    final center = topRotationHandleCenterInWorld(
      rect: rect,
      rotation: rotation,
      offsetFromTopEdge: offsetFromTopEdge,
    );
    return center - Offset(handleSize / 2, handleSize / 2);
  }

  /// Returns the parent-frame rect occupied by a side handle at the un-rotated
  /// [rect]. Only valid for side handles (top/bottom/left/right); rotation is
  /// not supported for side handles in v1.
  ///
  /// The handle is a thin strip of thickness [handleTapSize], inset from the
  /// corners by [handleTapSize] so it doesn't overlap corner handles. The
  /// [alignment] controls whether the strip sits inside, centred on, or
  /// outside the edge.
  static Rect sideHandleRectInWorld(
    Rect rect,
    HandlePosition handle, {
    required double handleTapSize,
    required HandleAlignment alignment,
  }) {
    final inset = alignment.offset(handleTapSize);
    switch (handle) {
      case HandlePosition.top:
        return Rect.fromLTWH(
          rect.left - inset + handleTapSize,
          rect.top - inset,
          rect.width + 2 * inset - 2 * handleTapSize,
          handleTapSize,
        );
      case HandlePosition.bottom:
        return Rect.fromLTWH(
          rect.left - inset + handleTapSize,
          rect.bottom + inset - handleTapSize,
          rect.width + 2 * inset - 2 * handleTapSize,
          handleTapSize,
        );
      case HandlePosition.left:
        return Rect.fromLTWH(
          rect.left - inset,
          rect.top - inset + handleTapSize,
          handleTapSize,
          rect.height + 2 * inset - 2 * handleTapSize,
        );
      case HandlePosition.right:
        return Rect.fromLTWH(
          rect.right + inset - handleTapSize,
          rect.top - inset + handleTapSize,
          handleTapSize,
          rect.height + 2 * inset - 2 * handleTapSize,
        );
      default:
        throw ArgumentError(
            'sideHandleRectInWorld requires a side handle, got $handle');
    }
  }

  /// Returns the rect that must be contained in the clamp under
  /// [bindingStrategy] for a rotated rect with the given [rect] and
  /// [rotation].
  ///
  /// * [BindingStrategy.boundingBox]: returns the axis-aligned bounding rect
  ///   of [rect] rotated by [rotation] about its center. This is what the
  ///   clamp solver enforces under `boundingBox` semantics (rotated corners
  ///   stay in clamp, rendered footprint fully contained).
  ///
  /// * [BindingStrategy.originalBox]: returns [rect] unchanged. Rotation does
  ///   not affect which rect must be contained - the unrotated logical rect
  ///   stays in the clamp, and rotated corners may extend outside.
  ///
  /// At [rotation] == 0 both strategies return [rect].
  ///
  /// See also: `TransformableBoxController.effectiveContainmentRect` which
  /// uses the controller's own state.
  static Rect computeEffectiveContainmentRect({
    required Rect rect,
    required double rotation,
    required BindingStrategy bindingStrategy,
  }) {
    switch (bindingStrategy) {
      case BindingStrategy.boundingBox:
        return ClampHelpers.calculateBoundingRect(
                rect.toBox(rotation: rotation))
            .toRect();
      case BindingStrategy.originalBox:
        return rect;
    }
  }
}
