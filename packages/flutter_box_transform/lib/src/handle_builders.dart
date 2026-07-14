import 'dart:math' as math;
import 'dart:ui';

import 'package:box_transform/box_transform.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';

import 'handles.dart';
import 'typedefs.dart';

/// Default [HandleBuilder] implementations used by `TransformableBox` when
/// the consumer does not supply their own.
abstract final class HandleBuilders {
  const HandleBuilders._();

  /// A default implementation of the corner [HandleBuilder] callback.
  /// Renders a [DefaultCornerHandle] for the given [handle] position.
  static Widget defaultCorner(
    BuildContext context,
    HandlePosition handle,
  ) =>
      DefaultCornerHandle(handle: handle);

  /// A default implementation of the side [HandleBuilder] callback.
  /// Renders a [DefaultSideHandle] for the given [handle] position.
  static Widget defaultSide(
    BuildContext context,
    HandlePosition handle,
  ) =>
      DefaultSideHandle(handle: handle);

  /// A default implementation of the top rotation handle builder.
  static Widget defaultRotation(BuildContext context) =>
      const DefaultRotationHandle();
}

/// Creates a new corner handle widget, with its appropriate gesture splash
/// zone.
///
/// When [rotatable] is true, the corner exposes an outer rotation-capture
/// ring of size [rotationHandleGestureSize] surrounding the inner resize zone
/// of size [handleTapSize].
@protected
class CornerHandleWidget extends StatelessWidget {
  /// The position of the handle.
  final HandlePosition handlePosition;

  /// The builder that is used to build the handle widget.
  final HandleBuilder builder;

  /// The size of the resize gesture response area (inner).
  final double handleTapSize;

  /// The size of the rotation gesture response ring (outer). Ignored when
  /// [rotatable] is false.
  final double rotationHandleGestureSize;

  /// Whether the handle should also capture rotation gestures (in the outer
  /// ring around the resize zone).
  final bool rotatable;

  /// The current rotation angle of the parent box (radians). Used by the
  /// rotation indicator painter so the visible arc points outward from the
  /// box regardless of rotation.
  final double rotation;

  /// The kind of devices that are allowed to be recognized.
  final Set<PointerDeviceKind> supportedDevices;

  /// The kind of devices that are allowed to be recognized for rotation.
  final Set<PointerDeviceKind>? supportedRotationDevices;

  /// Called when the handle resize dragging starts.
  final GestureDragStartCallback? onPanStart;

  /// Called when the handle resize dragging is updated.
  final GestureDragUpdateCallback? onPanUpdate;

  /// Called when the handle resize dragging ends.
  final GestureDragEndCallback? onPanEnd;

  /// Called when the handle resize dragging is canceled.
  final GestureDragCancelCallback? onPanCancel;

  /// Called when a rotation gesture starts on the outer ring.
  final GestureDragStartCallback? onRotationStart;

  /// Called when a rotation gesture is updated.
  final GestureDragUpdateCallback? onRotationUpdate;

  /// Called when a rotation gesture ends.
  final GestureDragEndCallback? onRotationEnd;

  /// Called when a rotation gesture is canceled.
  final GestureDragCancelCallback? onRotationCancel;

  /// Whether the handle is resizable.
  final bool enabled;

  /// Whether the handle is visible.
  final bool visible;

  /// How the inner resize zone is aligned relative to the corner.
  final HandleAlignment handleAlignment;

  /// Optional override for the [MouseCursor] shown over this handle's gesture
  /// zones. Receives the [HandlePosition] and a [HandleCursorKind] indicating
  /// whether the resize zone or the rotation ring is being queried. Return
  /// `null` from the resolver to fall back to the package defaults.
  final HandleCursorResolver? cursorResolver;

  /// Whether to paint the handle's bounds for debugging purposes.
  final bool debugPaintHandleBounds;

  /// Creates a new handle widget.
  CornerHandleWidget({
    super.key,
    required this.handlePosition,
    required this.handleTapSize,
    required this.supportedDevices,
    required this.builder,
    this.supportedRotationDevices,
    this.rotationHandleGestureSize = 64.0,
    this.rotatable = false,
    this.rotation = 0.0,
    this.onPanStart,
    this.onPanUpdate,
    this.onPanEnd,
    this.onPanCancel,
    this.onRotationStart,
    this.onRotationUpdate,
    this.onRotationEnd,
    this.onRotationCancel,
    this.enabled = true,
    this.visible = true,
    this.handleAlignment = HandleAlignment.center,
    this.cursorResolver,
    this.debugPaintHandleBounds = false,
  })  : assert(handlePosition.isDiagonal, 'A corner handle must be diagonal.'),
        assert(rotationHandleGestureSize >= handleTapSize,
            'rotationHandleGestureSize must be >= handleTapSize.');

  @override
  Widget build(BuildContext context) {
    Widget visual =
        visible ? builder(context, handlePosition) : const SizedBox.shrink();

    final double outerSize =
        rotatable ? rotationHandleGestureSize : handleTapSize;
    final Offset resizeOffset =
        _anchorInHandle(handlePosition, outerSize, handleAlignment) -
            _anchorInHandle(handlePosition, handleTapSize, handleAlignment);

    // Resize zone: square of size [handleTapSize] whose own alignment anchor
    // lands on the same box corner as the outer rotation zone anchor.
    Widget resizeInner = enabled
        ? GestureDetector(
            behavior: HitTestBehavior.opaque,
            supportedDevices: supportedDevices,
            onPanStart: onPanStart,
            onPanUpdate: onPanUpdate,
            onPanEnd: onPanEnd,
            onPanCancel: onPanCancel,
            child: MouseRegion(
              cursor: getResizeCursorForHandle(handlePosition),
              child: visual,
            ),
          )
        : visual;

    if (kDebugMode && debugPaintHandleBounds) {
      resizeInner = ColoredBox(
        color: Colors.orange.withValues(alpha: 0.5),
        child: resizeInner,
      );
    }

    Widget resizeZone = Positioned(
      left: resizeOffset.dx,
      top: resizeOffset.dy,
      width: handleTapSize,
      height: handleTapSize,
      child: resizeInner,
    );

    // Outer rotation ring fills the entire outer zone as the bottom layer;
    // resize sits on top. Hit testing: clicks on the inner resize area go to
    // resize (top of stack); clicks outside it fall through to rotation.
    Widget outer = resizeZone;
    if (rotatable && enabled) {
      Widget rotationGesture = GestureDetector(
        behavior: HitTestBehavior.opaque,
        supportedDevices: supportedRotationDevices ?? supportedDevices,
        onPanStart: onRotationStart,
        onPanUpdate: onRotationUpdate,
        onPanEnd: onRotationEnd,
        onPanCancel: onRotationCancel,
        child: MouseRegion(
          cursor: getRotationCursorForHandle(handlePosition),
          child: CustomPaint(
            painter: _RotationIndicatorPainter(
              handle: handlePosition,
              rotation: rotation,
              color: Theme.of(context).colorScheme.primary,
              haloColor: Theme.of(context).scaffoldBackgroundColor,
            ),
            child: const SizedBox.expand(),
          ),
        ),
      );
      if (kDebugMode && debugPaintHandleBounds) {
        rotationGesture = ColoredBox(
          color: Colors.blue.withValues(alpha: 0.35),
          child: rotationGesture,
        );
      }
      outer = Stack(
        fit: StackFit.expand,
        children: [
          rotationGesture, // bottom: catches everything
          resizeZone, // top: wins in the resize zone
        ],
      );
    } else {
      outer = Stack(
        fit: StackFit.expand,
        children: [resizeZone],
      );
    }

    // Return a fixed-size box; positioning is the caller's responsibility.
    return SizedBox(width: outerSize, height: outerSize, child: outer);
  }

  Offset _anchorInHandle(
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

  /// Returns the resize cursor for the given handle position.
  ///
  /// If a [cursorResolver] was supplied and returns non-null for this handle,
  /// that value is used; otherwise the appropriate diagonal
  /// `SystemMouseCursors.resize*` constant is returned.
  MouseCursor getResizeCursorForHandle(HandlePosition handle) {
    final MouseCursor? overridden =
        cursorResolver?.call(handle, HandleCursorKind.resize);
    if (overridden != null) return overridden;
    switch (handle) {
      case HandlePosition.topLeft:
      case HandlePosition.bottomRight:
        return SystemMouseCursors.resizeUpLeftDownRight;
      case HandlePosition.topRight:
      case HandlePosition.bottomLeft:
        return SystemMouseCursors.resizeUpRightDownLeft;
      default:
        throw Exception('Invalid handle position.');
    }
  }

  /// Returns the cursor shown over the rotation ring for the given handle.
  ///
  /// Flutter's [SystemMouseCursors] has no rotation cursor and there is no
  /// open Flutter issue tracking one — confirmed against the Flutter API
  /// docs. As a default we reuse the diagonal resize cursor so the gesture
  /// zone still feels actionable.
  ///
  /// If you want a real rotate glyph, supply a [cursorResolver] that returns
  /// a custom [MouseCursor] for [HandleCursorKind.rotation]. The
  /// [`custom_mouse_cursor`](https://pub.dev/packages/custom_mouse_cursor)
  /// package can build a native, DPR-aware [MouseCursor] from an asset, icon,
  /// or `ui.Image` (works on Windows, macOS, Linux, and web). Returning
  /// `null` from the resolver falls back to this default.
  MouseCursor getRotationCursorForHandle(HandlePosition handle) {
    final MouseCursor? overridden =
        cursorResolver?.call(handle, HandleCursorKind.rotation);
    if (overridden != null) return overridden;
    return getResizeCursorForHandle(handle);
  }

  /// Deprecated; use [getResizeCursorForHandle]. Kept for backward-compat
  /// with any callers that use the legacy name.
  MouseCursor getCursorForHandle(HandlePosition handle) =>
      getResizeCursorForHandle(handle);
}

/// Creates a visible top rotation handle with a large gesture response area.
@protected
class RotationHandleWidget extends StatelessWidget {
  /// The builder that is used to build the visible handle widget.
  final RotationHandleBuilder builder;

  /// The size of the rotation gesture response area.
  final double handleTapSize;

  /// The kind of devices that are allowed to be recognized.
  final Set<PointerDeviceKind> supportedDevices;

  /// Called when a rotation gesture starts.
  final GestureDragStartCallback? onPanStart;

  /// Called when a rotation gesture is updated.
  final GestureDragUpdateCallback? onPanUpdate;

  /// Called when a rotation gesture ends.
  final GestureDragEndCallback? onPanEnd;

  /// Called when a rotation gesture is canceled.
  final GestureDragCancelCallback? onPanCancel;

  /// Optional override for the cursor shown over the rotation handle.
  final HandleCursorResolver? cursorResolver;

  /// Whether to paint the handle's bounds for debugging purposes.
  final bool debugPaintHandleBounds;

  /// Creates a new top rotation handle widget.
  const RotationHandleWidget({
    super.key,
    required this.builder,
    required this.handleTapSize,
    required this.supportedDevices,
    this.onPanStart,
    this.onPanUpdate,
    this.onPanEnd,
    this.onPanCancel,
    this.cursorResolver,
    this.debugPaintHandleBounds = false,
  });

  @override
  Widget build(BuildContext context) {
    Widget child = GestureDetector(
      behavior: HitTestBehavior.opaque,
      supportedDevices: supportedDevices,
      onPanStart: onPanStart,
      onPanUpdate: onPanUpdate,
      onPanEnd: onPanEnd,
      onPanCancel: onPanCancel,
      child: MouseRegion(
        cursor: getRotationCursor(),
        child: builder(context),
      ),
    );

    if (kDebugMode && debugPaintHandleBounds) {
      child = ColoredBox(
        color: Colors.blue.withValues(alpha: 0.35),
        child: child,
      );
    }

    return SizedBox.square(dimension: handleTapSize, child: child);
  }

  /// Returns the cursor shown over the top rotation handle.
  MouseCursor getRotationCursor() {
    final MouseCursor? overridden =
        cursorResolver?.call(HandlePosition.top, HandleCursorKind.rotation);
    if (overridden != null) return overridden;
    return SystemMouseCursors.resizeUpDown;
  }
}

/// Creates a new cardinal handle widget, with its appropriate gesture splash
/// zone.
@protected
class SideHandleWidget extends StatelessWidget {
  /// The position of the handle.
  final HandlePosition handlePosition;

  /// The builder that is used to build the handle widget.
  final HandleBuilder builder;

  /// The thickness of the handle that is used for gesture detection.
  final double handleTapSize;

  /// The kind of devices that are allowed to be recognized.
  final Set<PointerDeviceKind> supportedDevices;

  /// Called when the handle dragging starts.
  final GestureDragStartCallback? onPanStart;

  /// Called when the handle dragging is updated.
  final GestureDragUpdateCallback? onPanUpdate;

  /// Called when the handle dragging ends.
  final GestureDragEndCallback? onPanEnd;

  /// Called when the handle dragging is canceled.
  final GestureDragCancelCallback? onPanCancel;

  /// Whether the handle is resizable.
  final bool enabled;

  /// Whether the handle is visible.
  final bool visible;

  /// Optional override for the [MouseCursor] shown over this handle. Side
  /// handles only have a resize zone, so the resolver is always called with
  /// [HandleCursorKind.resize]. Return `null` to fall back to the package
  /// default.
  final HandleCursorResolver? cursorResolver;

  /// Whether to paint the handle's bounds for debugging purposes.
  final bool debugPaintHandleBounds;

  /// Creates a new handle widget.
  SideHandleWidget({
    super.key,
    required this.handlePosition,
    required this.handleTapSize,
    required this.supportedDevices,
    required this.builder,
    this.onPanStart,
    this.onPanUpdate,
    this.onPanEnd,
    this.onPanCancel,
    this.enabled = true,
    this.visible = true,
    this.cursorResolver,
    this.debugPaintHandleBounds = false,
  }) : assert(handlePosition.isSide, 'A cardinal handle must be cardinal.');

  @override
  Widget build(BuildContext context) {
    Widget child =
        visible ? builder(context, handlePosition) : const SizedBox.shrink();

    if (enabled) {
      child = GestureDetector(
        behavior: HitTestBehavior.opaque,
        supportedDevices: supportedDevices,
        onPanStart: onPanStart,
        onPanUpdate: onPanUpdate,
        onPanEnd: onPanEnd,
        onPanCancel: onPanCancel,
        child: MouseRegion(
          cursor: getCursorForHandle(handlePosition),
          child: child,
        ),
      );
    }

    if (kDebugMode && debugPaintHandleBounds) {
      child = ColoredBox(
        color: Colors.yellow.withValues(alpha: 0.5),
        child: child,
      );
    }

    // SideHandleWidget now returns just its interactive child; positioning
    // is the caller's responsibility (see TransformableBox build).
    return child;
  }

  /// Returns the cursor for the given handle position.
  ///
  /// If a [cursorResolver] was supplied and returns non-null for this handle,
  /// that value is used; otherwise the appropriate cardinal
  /// `SystemMouseCursors.resize*` constant is returned.
  MouseCursor getCursorForHandle(HandlePosition handle) {
    final MouseCursor? overridden =
        cursorResolver?.call(handle, HandleCursorKind.resize);
    if (overridden != null) return overridden;
    switch (handle) {
      case HandlePosition.left:
      case HandlePosition.right:
        return SystemMouseCursors.resizeLeftRight;
      case HandlePosition.top:
      case HandlePosition.bottom:
        return SystemMouseCursors.resizeUpDown;
      default:
        throw Exception('Invalid handle position.');
    }
  }
}

/// Paints a subtle arc in the outer rotation ring of a corner handle so
/// users can see where to grab for rotation. Arc spans the quadrant of the
/// ring that sits outside the box corner (accounting for rotation so the
/// indicator always points away from the box's visual centre).
class _RotationIndicatorPainter extends CustomPainter {
  final HandlePosition handle;
  final double rotation;
  final Color color;
  final Color haloColor;

  const _RotationIndicatorPainter({
    required this.handle,
    this.rotation = 0.0,
    required this.color,
    required this.haloColor,
  });

  @override
  void paint(Canvas canvas, Size size) {
    // Centre the arc on the handle widget itself; the handle is axis-aligned
    // so the arc's geometric centre is just (size.width/2, size.height/2).
    final Offset centre = Offset(size.width / 2, size.height / 2);
    final double radius = math.min(size.width, size.height) * 0.4;
    // Base start angle selects the quadrant that would be outward when
    // rotation == 0 (the "outside-the-box" direction from the corner).
    final double baseStartAngle;
    switch (handle) {
      case HandlePosition.topLeft:
        baseStartAngle = math.pi;
      case HandlePosition.topRight:
        baseStartAngle = math.pi * 1.5;
      case HandlePosition.bottomRight:
        baseStartAngle = 0;
      case HandlePosition.bottomLeft:
        baseStartAngle = math.pi * 0.5;
      default:
        return;
    }
    // Since this handle widget is now axis-aligned in world frame but placed
    // at the visually-rotated corner of the box, add [rotation] so the arc
    // still points outward relative to the box's current orientation.
    final double startAngle = baseStartAngle + rotation;
    const double sweepAngle = math.pi / 2;
    final Rect arcRect = Rect.fromCircle(center: centre, radius: radius);
    final Paint haloPaint = Paint()
      ..color = haloColor.withValues(alpha: 0.9)
      ..style = PaintingStyle.stroke
      ..strokeWidth = 5.5
      ..strokeCap = StrokeCap.round;
    final Paint paint = Paint()
      ..color = color.withValues(alpha: 0.95)
      ..style = PaintingStyle.stroke
      ..strokeWidth = 2.5
      ..strokeCap = StrokeCap.round;
    canvas
      ..drawArc(arcRect, startAngle, sweepAngle, false, haloPaint)
      ..drawArc(arcRect, startAngle, sweepAngle, false, paint);

    final double endAngle = startAngle + sweepAngle;
    final Offset startPoint = _pointOnCircle(centre, radius, startAngle);
    final Offset endPoint = _pointOnCircle(centre, radius, endAngle);
    final Paint arrowHaloPaint = Paint()
      ..color = haloColor.withValues(alpha: 0.9)
      ..style = PaintingStyle.fill;
    final Paint arrowPaint = Paint()
      ..color = color.withValues(alpha: 0.95)
      ..style = PaintingStyle.fill;

    _drawArrowHead(
      canvas,
      startPoint,
      startAngle - math.pi / 2,
      arrowHaloPaint,
      size: 8,
    );
    _drawArrowHead(
      canvas,
      endPoint,
      endAngle + math.pi / 2,
      arrowHaloPaint,
      size: 8,
    );
    _drawArrowHead(
      canvas,
      startPoint,
      startAngle - math.pi / 2,
      arrowPaint,
    );
    _drawArrowHead(
      canvas,
      endPoint,
      endAngle + math.pi / 2,
      arrowPaint,
    );
  }

  Offset _pointOnCircle(Offset centre, double radius, double angle) {
    return Offset(
      centre.dx + math.cos(angle) * radius,
      centre.dy + math.sin(angle) * radius,
    );
  }

  void _drawArrowHead(
    Canvas canvas,
    Offset tip,
    double direction,
    Paint paint, {
    double size = 6,
  }) {
    final Offset back = Offset(
      tip.dx - math.cos(direction) * size,
      tip.dy - math.sin(direction) * size,
    );
    final double wingAngle = direction + math.pi / 2;
    final Offset wing = Offset(
      math.cos(wingAngle) * size * 0.45,
      math.sin(wingAngle) * size * 0.45,
    );
    final Path path = Path()
      ..moveTo(tip.dx, tip.dy)
      ..lineTo(back.dx + wing.dx, back.dy + wing.dy)
      ..lineTo(back.dx - wing.dx, back.dy - wing.dy)
      ..close();
    canvas.drawPath(path, paint);
  }

  @override
  bool shouldRepaint(covariant _RotationIndicatorPainter oldDelegate) =>
      oldDelegate.handle != handle ||
      oldDelegate.rotation != rotation ||
      oldDelegate.color != color ||
      oldDelegate.haloColor != haloColor;
}
