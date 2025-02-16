import 'dart:ui';

import 'package:box_transform/box_transform.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';

import 'typedefs.dart';

/// Creates a new corner handle widget, with its appropriate gesture splash
/// zone.
@protected
class CornerHandleWidget extends StatelessWidget {
  /// The position of the handle.
  final HandlePosition handlePosition;

  /// The builder that is used to build the handle widget.
  final HandleBuilder builder;

  /// The size of the handle's gesture response area.
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

  /// Whether to paint the handle's bounds for debugging purposes.
  final bool debugPaintHandleBounds;

  /// Creates a new handle widget.
  CornerHandleWidget({
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
    this.debugPaintHandleBounds = false,
  }) : assert(handlePosition.isDiagonal, 'A corner handle must be diagonal.');

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
        color: Colors.orange.withValues(alpha: 0.5),
        child: child,
      );
    }

    return Positioned(
      left: handlePosition.influencesLeft ? 0 : null,
      right: handlePosition.influencesRight ? 0 : null,
      top: handlePosition.influencesTop ? 0 : null,
      bottom: handlePosition.influencesBottom ? 0 : null,
      width: handleTapSize,
      height: handleTapSize,
      child: child,
    );
  }

  /// Returns the cursor for the given handle position.
  MouseCursor getCursorForHandle(HandlePosition handle) {
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

    return Positioned(
      left: handlePosition.isVertical
          ? handleTapSize
          : handlePosition.influencesLeft
              ? 0
              : null,
      right: handlePosition.isVertical
          ? handleTapSize
          : handlePosition.influencesRight
              ? 0
              : null,
      top: handlePosition.isHorizontal
          ? handleTapSize
          : handlePosition.influencesTop
              ? 0
              : null,
      bottom: handlePosition.isHorizontal
          ? handleTapSize
          : handlePosition.influencesBottom
              ? 0
              : null,
      width: handlePosition.isHorizontal ? handleTapSize : null,
      height: handlePosition.isVertical ? handleTapSize : null,
      child: child,
    );
  }

  /// Returns the cursor for the given handle position.
  MouseCursor getCursorForHandle(HandlePosition handle) {
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
