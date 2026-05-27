import 'dart:math';

import 'package:vector_math/vector_math_64.dart';

import 'enums.dart';
import 'extensions.dart';
import 'geometry.dart';

/// Static helpers for axis-aligned box clamping, handle resolution,
/// flip-aware resizing, and 2-D line / rect intersection geometry.
///
/// All members are `static`. The class cannot be constructed or extended.
abstract final class ClampHelpers {
  const ClampHelpers._();

  /// Flips the given [rect] with given [flip] with [handle] being the
  /// pivot point.
  static Box flipRect(Box rect, Flip flip, HandlePosition handle) {
    switch (handle) {
      case HandlePosition.none:
        throw ArgumentError('HandlePosition.none is not supported!');
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
      case HandlePosition.left:
        return rect.translate(
          flip.isHorizontal ? rect.width : 0,
          0,
        );
      case HandlePosition.top:
        return rect.translate(
          0,
          flip.isVertical ? rect.height : 0,
        );
      case HandlePosition.right:
        return rect.translate(
          flip.isHorizontal ? -rect.width : 0,
          0,
        );
      case HandlePosition.bottom:
        return rect.translate(
          0,
          flip.isVertical ? -rect.height : 0,
        );
    }
  }

  /// Calculates flip state of the given [rect] w.r.t [localPosition] and
  /// [handle]. It uses [handle] and [localPosition] to determine the quadrant
  /// of the [rect] and then checks if the [rect] is flipped in that quadrant.
  static Flip getFlipForRect(
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

  /// Returns a clamping rect for [ResizeMode.symmetricScale].
  static Box scaledSymmetricClampingRect(Box initialRect, Box clampingRect) {
    final closestHandle = getClosestEdge(initialRect, clampingRect);

    final initialAspectRatio = initialRect.width / initialRect.height;

    double width;
    double height;
    switch (closestHandle) {
      case HandlePosition.top:
        height = (initialRect.center.y - clampingRect.top) * 2;
        width = height * initialAspectRatio;
        break;
      case HandlePosition.right:
        width = (clampingRect.right - initialRect.center.x) * 2;
        height = width / initialAspectRatio;
        break;
      case HandlePosition.bottom:
        height = (clampingRect.bottom - initialRect.center.y) * 2;
        width = height * initialAspectRatio;
        break;
      case HandlePosition.left:
        width = (initialRect.center.x - clampingRect.left) * 2;
        height = width / initialAspectRatio;
        break;
      default:
        throw Exception('Unknown handle');
    }

    return Box.fromCenter(
      center: initialRect.center,
      width: width,
      height: height,
    );
  }

  /// Returns the handle/edge of the [initialRect] that is closest to one of
  /// the edge of [clampingRect] for [ResizeMode.scale].
  static HandlePosition getClosestEdge(
    Box initialRect,
    Box clampingRect, {
    HandlePosition? excludeHandle,
  }) {
    return intersectionBetweenRects(
      outerRect: clampingRect,
      innerRect: initialRect,
      excludeHandle: excludeHandle,
    );
  }

  /// Returns a clamping rect for given side handle that preserves aspect
  /// ratio.
  static Box getClampingRectForSideHandle({
    required Box initialRect,
    required Box availableArea,
    required HandlePosition handle,
  }) {
    final closestEdge = getClosestEdge(
      initialRect,
      availableArea,
      excludeHandle: handle.opposite,
    );

    final initialAspectRatio = initialRect.width / initialRect.height;

    double width;
    double height;

    switch (closestEdge) {
      case HandlePosition.left:
        width = (initialRect.center.x - availableArea.left) * 2;
        height = width / initialAspectRatio;
        break;
      case HandlePosition.top:
        height = (initialRect.center.y - availableArea.top) * 2;
        width = height * initialAspectRatio;
        break;
      case HandlePosition.right:
        width = (availableArea.right - initialRect.center.x) * 2;
        height = width / initialAspectRatio;
        break;
      case HandlePosition.bottom:
        height = (availableArea.bottom - initialRect.center.y) * 2;
        width = height * initialAspectRatio;
        break;
      default:
        throw Exception('Unsupported handle');
    }

    switch (handle) {
      case HandlePosition.none:
        throw ArgumentError('HandlePosition.none is not supported!');
      case HandlePosition.left:
        final maxWidth = min(width, initialRect.right - availableArea.left);
        final maxHeight = maxWidth / initialAspectRatio;
        return Box.fromLTWH(
          initialRect.right - maxWidth,
          initialRect.center.y - maxHeight / 2,
          maxWidth,
          maxHeight,
        );
      case HandlePosition.top:
        final maxHeight = min(height, initialRect.bottom - availableArea.top);
        final maxWidth = maxHeight * initialAspectRatio;
        return Box.fromLTWH(
          initialRect.center.x - maxWidth / 2,
          initialRect.bottom - maxHeight,
          maxWidth,
          maxHeight,
        );
      case HandlePosition.right:
        final maxWidth = min(width, availableArea.right - initialRect.left);
        final maxHeight = maxWidth / initialAspectRatio;

        return Box.fromLTWH(
          initialRect.centerLeft.x,
          initialRect.centerLeft.y - maxHeight / 2,
          maxWidth,
          maxHeight,
        );
      case HandlePosition.bottom:
        final maxHeight = min(height, availableArea.bottom - initialRect.top);
        final maxWidth = maxHeight * initialAspectRatio;
        return Box.fromLTWH(
          initialRect.center.x - maxWidth / 2,
          initialRect.top,
          maxWidth,
          maxHeight,
        );
      default:
        throw Exception('Unsupported handle');
    }
  }

  /// Returns a vector of the point of intersection between two given lines.
  /// First two vectors [p1] and [p2] are the first line, and the second two
  /// vectors [p3] and [p4] are the second line.
  ///
  /// Returns the point of intersection. If there is no intersection, then
  /// the function returns null.
  static Vector2? intersectionBetweenTwoLines(
      Vector2 p1, Vector2 p2, Vector2 p3, Vector2 p4) {
    final double t =
        ((p1.x - p3.x) * (p3.y - p4.y) - (p1.y - p3.y) * (p3.x - p4.x)) /
            ((p1.x - p2.x) * (p3.y - p4.y) - (p1.y - p2.y) * (p3.x - p4.x));
    final double u =
        ((p1.x - p3.x) * (p1.y - p2.y) - (p1.y - p3.y) * (p1.x - p2.x)) /
            ((p1.x - p2.x) * (p3.y - p4.y) - (p1.y - p2.y) * (p3.x - p4.x));

    if (0 <= t && t <= 1 && 0 <= u && u <= 1) {
      return Vector2(p1.x + t * (p2.x - p1.x), p1.y + t * (p2.y - p1.y));
    } else {
      return null;
    }
  }

  /// Extends given line to the given rectangle such that it touches the
  /// rectangle.
  static (Vector2, Vector2)? extendLineToRect(
      Box rect, Vector2 p1, Vector2 p2) {
    final (
      double,
      double,
      double,
      double
    )? result = extendLinePointsToRectPoints(
        rect.left, rect.top, rect.right, rect.bottom, p1.x, p1.y, p2.x, p2.y);

    if (result == null) return null;

    return (Vector2(result.$1, result.$2), Vector2(result.$3, result.$4));
  }

  /// Extends given line to the given rectangle such that it touches the
  /// rectangle points.
  static (double, double, double, double)? extendLinePointsToRectPoints(
    double left,
    double top,
    double right,
    double bottom,
    double x1,
    double y1,
    double x2,
    double y2,
  ) {
    if (y1 == y2) {
      return (left, y1, right, y1);
    }
    if (x1 == x2) {
      return (x1, top, x1, bottom);
    }

    double yForLeft = y1 + (y2 - y1) * (left - x1) / (x2 - x1);
    double yForRight = y1 + (y2 - y1) * (right - x1) / (x2 - x1);

    double xForTop = x1 + (x2 - x1) * (top - y1) / (y2 - y1);
    double xForBottom = x1 + (x2 - x1) * (bottom - y1) / (y2 - y1);

    if (top <= yForLeft &&
        yForLeft <= bottom &&
        top <= yForRight &&
        yForRight <= bottom) {
      return (left, yForLeft, right, yForRight);
    } else if (top <= yForLeft && yForLeft <= bottom) {
      if (left <= xForBottom && xForBottom <= right) {
        return (left, yForLeft, xForBottom, bottom);
      } else if (left <= xForTop && xForTop <= right) {
        return (left, yForLeft, xForTop, top);
      }
    } else if (top <= yForRight && yForRight <= bottom) {
      if (left <= xForTop && xForTop <= right) {
        return (xForTop, top, right, yForRight);
      }
      if (left <= xForBottom && xForBottom <= right) {
        return (xForBottom, bottom, right, yForRight);
      }
    } else if (left <= xForTop &&
        xForTop <= right &&
        left <= xForBottom &&
        xForBottom <= right) {
      return (xForTop, top, xForBottom, bottom);
    }
    return null;
  }

  /// Returns the intersection between the given rectangles with assumption
  /// that [innerRect] is completely inside [outerRect]. The intersection is
  /// calculated using the center of the [innerRect] and the corners of the
  /// [outerRect]. Returns the closest edge/handle of [outerRect] to the
  /// [innerRect].
  static HandlePosition intersectionBetweenRects({
    required Box outerRect,
    required Box innerRect,
    HandlePosition? excludeHandle,
  }) {
    final line1 =
        extendLineToRect(outerRect, innerRect.center, innerRect.bottomRight)!;

    final line2 =
        extendLineToRect(outerRect, innerRect.center, innerRect.topRight)!;

    final intersections1 = findLineIntersection(
      line1.$1,
      line1.$2,
      outerRect,
      innerRect,
    );

    intersections1.remove(excludeHandle);

    final intersections2 = findLineIntersection(
      line2.$1,
      line2.$2,
      outerRect,
      innerRect,
    );

    intersections2.remove(excludeHandle);

    final List<MapEntry<HandlePosition, Vector2>> intersections = [
      ...intersections1.entries,
      ...intersections2.entries,
    ];

    final closest = intersections.reduce((value, element) {
      final valueDistance = value.value.distanceToSquared(innerRect.center);
      final elementDistance = element.value.distanceToSquared(innerRect.center);

      if (valueDistance < elementDistance) {
        return value;
      } else {
        return element;
      }
    });

    return closest.key;
  }

  /// Finds the intersection between the given line and the given rectangle
  /// and returns distance between the intersection and the [inner] point.
  static Map<HandlePosition, Vector2> findLineIntersection(
      Vector2 inner, Vector2 outer, Box rect, Box initialRect) {
    final Vector2 topLeft = rect.topLeft;
    final Vector2 topRight = rect.topRight;
    final Vector2 bottomLeft = rect.bottomLeft;
    final Vector2 bottomRight = rect.bottomRight;

    final Vector2? top =
        intersectionBetweenTwoLines(inner, outer, topLeft, topRight);
    final Vector2? bottom =
        intersectionBetweenTwoLines(inner, outer, bottomLeft, bottomRight);
    final Vector2? left =
        intersectionBetweenTwoLines(inner, outer, topLeft, bottomLeft);
    final Vector2? right =
        intersectionBetweenTwoLines(inner, outer, topRight, bottomRight);

    final Map<HandlePosition, Vector2?> sides = {
      HandlePosition.top: top,
      HandlePosition.bottom: bottom,
      HandlePosition.left: left,
      HandlePosition.right: right,
    };

    return {
      for (final entry in sides.entries)
        if (entry.value != null) entry.key: entry.value!
    };
  }

  /// Returns the available area for the given handle.
  static Box getAvailableAreaForHandle({
    required Box rect,
    required Box clampingRect,
    required HandlePosition handle,
    Constraints constraints = const Constraints.unconstrained(),
  }) {
    if (handle.isSide) {
      final opposite = handle.opposite;
      return Box.fromLTRB(
        opposite.influencesLeft ? rect.left : clampingRect.left,
        opposite.influencesTop ? rect.top : clampingRect.top,
        opposite.influencesRight ? rect.right : clampingRect.right,
        opposite.influencesBottom ? rect.bottom : clampingRect.bottom,
      );
    } else {
      return Box.fromLTRB(
        handle.influencesLeft ? clampingRect.left : rect.left,
        handle.influencesTop ? clampingRect.top : rect.top,
        handle.influencesRight ? clampingRect.right : rect.right,
        handle.influencesBottom ? clampingRect.bottom : rect.bottom,
      );
    }
  }

  /// Returns the clamping rect for the given handle for [ResizeMode.scale].
  static Box getClampingRectForHandle({
    required Box initialRect,
    required Box availableArea,
    required HandlePosition handle,
  }) {
    switch (handle) {
      case HandlePosition.none:
        throw ArgumentError('HandlePosition.none is not supported!');
      case HandlePosition.topLeft:
      case HandlePosition.topRight:
      case HandlePosition.bottomLeft:
      case HandlePosition.bottomRight:
        return getClampingRectForCornerHandle(
          initialRect: initialRect,
          availableArea: availableArea,
          handle: handle,
        );
      case HandlePosition.left:
      case HandlePosition.top:
      case HandlePosition.right:
      case HandlePosition.bottom:
        return getClampingRectForSideHandle(
          initialRect: initialRect,
          availableArea: availableArea,
          handle: handle,
        );
    }
  }

  /// Returns the clamping rect for the given corner handle for
  /// [ResizeMode.scale].
  static Box getClampingRectForCornerHandle({
    required Box initialRect,
    required Box availableArea,
    required HandlePosition handle,
  }) {
    final initialAspectRatio = initialRect.safeAspectRatio;

    final double areaAspectRatio = availableArea.safeAspectRatio;

    double maxWidth;
    double maxHeight;

    if (areaAspectRatio > 1) {
      // Clamping area:    Landscape
      // Box:              Landscape
      // Limiting factor:  Width
      if (initialAspectRatio > areaAspectRatio) {
        maxWidth = availableArea.width;
        maxHeight = maxWidth / initialAspectRatio;
      } else {
        // Clamping area:    Landscape
        // Box:              Portrait
        // Limiting factor:  Height
        maxHeight = availableArea.height;
        maxWidth = maxHeight * initialAspectRatio;
      }
    } else {
      // Clamping area:    Portrait
      // Box:              Landscape
      // Limiting factor:  Width
      if (initialAspectRatio > areaAspectRatio) {
        maxWidth = availableArea.width;
        maxHeight = maxWidth / initialAspectRatio;
      } else {
        // Clamping area:    Portrait
        // Box:              Portrait
        // Limiting factor:  Height
        maxHeight = availableArea.height;
        maxWidth = maxHeight * initialAspectRatio;
      }
    }

    return Box.fromHandle(
      handle.anchor(initialRect),
      handle,
      maxWidth,
      maxHeight,
    );
  }

  /// Constrains available area for [ResizeMode.scale].
  static Box constrainAvailableAreaForScaling({
    required Box area,
    required Box initialRect,
    required HandlePosition handle,
    required Constraints constraints,
  }) {
    if (constraints.isUnconstrained) return area;

    final maxWidth = min(constraints.maxWidth, area.width);
    final maxHeight = min(constraints.maxHeight, area.height);

    final constrainedRect = Box.fromHandle(
      handle.anchor(initialRect),
      handle,
      maxWidth,
      maxHeight,
    );

    return Box.fromLTRB(
      max(constrainedRect.left, area.left),
      max(constrainedRect.top, area.top),
      min(constrainedRect.right, area.right),
      min(constrainedRect.bottom, area.bottom),
    );
  }

  /// Returns a minimum Rect for given constraints when [ResizeMode.scale].
  static Box getMinRectForScaling({
    required Box initialRect,
    required HandlePosition handle,
    required Constraints constraints,
  }) {
    final double minWidth;
    final double minHeight;

    if (!constraints.isUnconstrained) {
      if (initialRect.safeAspectRatio < 1) {
        minWidth = constraints.minWidth;
        minHeight = minWidth / initialRect.safeAspectRatio;
      } else {
        minHeight = constraints.minHeight;
        minWidth = minHeight * initialRect.safeAspectRatio;
      }
    } else {
      minWidth = 0;
      minHeight = 0;
    }

    return Box.fromHandle(
      handle.anchor(initialRect),
      handle,
      minWidth,
      minHeight,
    );
  }

  /// Returns whether the given [rect] is properly confined within its
  /// [constraints] but at the same time is not outside of the [clampingRect].
  static bool isValidRect(Box rect, Constraints constraints, Box clampingRect) {
    if (clampingRect.left.roundToPrecision(4) > rect.left.roundToPrecision(4) ||
        clampingRect.top.roundToPrecision(4) > rect.top.roundToPrecision(4) ||
        clampingRect.right.roundToPrecision(4) <
            rect.right.roundToPrecision(4) ||
        clampingRect.bottom.roundToPrecision(4) <
            rect.bottom.roundToPrecision(4)) {
      return false;
    }
    if (!constraints.isUnconstrained) {
      if (rect.width.roundToPrecision(4) <
              constraints.minWidth.roundToPrecision(4) ||
          rect.width.roundToPrecision(4) >
              constraints.maxWidth.roundToPrecision(4) ||
          rect.height.roundToPrecision(4) <
              constraints.minHeight.roundToPrecision(4) ||
          rect.height.roundToPrecision(4) >
              constraints.maxHeight.roundToPrecision(4)) {
        return false;
      }
    }
    return true;
  }

  // Per-isolate memo for cos/sin keyed by the most recent theta. A single
  // rotated transform op invokes [rotatePointAround] 4-5 times with the
  // same [theta]; caching skips redundant trig. NaN inputs miss cleanly
  // because `NaN == NaN` is false in Dart, forcing recomputation.
  static double _cachedTheta = double.nan;
  static double _cachedCos = 0.0;
  static double _cachedSin = 0.0;

  /// Rotates [point] by [theta] radians around [pivot] (clockwise).
  ///
  /// When [theta] is 0, returns a copy of [point] unchanged (fast-path).
  static Vector2 rotatePointAround(Vector2 point, Vector2 pivot, double theta) {
    if (theta == 0.0) return Vector2.copy(point);
    final dx = point.x - pivot.x;
    final dy = point.y - pivot.y;
    double c;
    double s;
    if (theta == _cachedTheta) {
      c = _cachedCos;
      s = _cachedSin;
    } else {
      c = cos(theta);
      s = sin(theta);
      _cachedTheta = theta;
      _cachedCos = c;
      _cachedSin = s;
    }
    return Vector2(
      pivot.x + dx * c - dy * s,
      pivot.y + dx * s + dy * c,
    );
  }

  /// Converts [worldPoint] from world space into the box's unrotated-local
  /// frame.
  ///
  /// The box is rotated by [theta] around [pivot] (the pivot is in world
  /// coords). Inverse of [unrotatedToWorld].
  static Vector2 worldToUnrotated(
          Vector2 worldPoint, Vector2 pivot, double theta) =>
      rotatePointAround(worldPoint, pivot, -theta);

  /// Converts [localPoint] from the box's unrotated-local frame into world
  /// space.
  ///
  /// The box is rotated by [theta] around [pivot] (the pivot is in world
  /// coords). Inverse of [worldToUnrotated].
  static Vector2 unrotatedToWorld(
          Vector2 localPoint, Vector2 pivot, double theta) =>
      rotatePointAround(localPoint, pivot, theta);

  /// Returns the axis-aligned bounding rectangle of [box] after applying
  /// its [Box.rotation] around its center.
  ///
  /// For `box.rotation == 0`, returns an AABB copy of [box]. The returned
  /// [Box] has `rotation = 0`.
  static Box calculateBoundingRect(Box box) {
    if (box.rotation == 0.0) {
      return Box.fromLTRB(box.left, box.top, box.right, box.bottom);
    }
    final w = box.width;
    final h = box.height;
    final cx = box.left + w / 2;
    final cy = box.top + h / 2;
    final theta = box.rotation;
    final double c;
    final double s;
    if (theta == _cachedTheta) {
      c = _cachedCos;
      s = _cachedSin;
    } else {
      c = cos(theta);
      s = sin(theta);
      _cachedTheta = theta;
      _cachedCos = c;
      _cachedSin = s;
    }
    final absCos = c.abs();
    final absSin = s.abs();
    final boundingW = w * absCos + h * absSin;
    final boundingH = w * absSin + h * absCos;
    return Box.fromLTWH(
      cx - boundingW / 2,
      cy - boundingH / 2,
      boundingW,
      boundingH,
    );
  }
}
