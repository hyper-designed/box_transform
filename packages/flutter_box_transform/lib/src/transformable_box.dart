import 'package:flutter/material.dart';

import '../flutter_box_transform.dart';

/// A callback that expects a [Widget] that represents any of the handles.
/// The [handle] is the current position and size of the handle.
typedef HandleBuilder = Widget Function(
  BuildContext context,
  HandlePosition handle,
);

/// A callback that expects a [Widget] that represents the content of the box.
/// The [rect] is the current position and size of the box.
/// The [flip] is the current flip state of the box.
typedef TransformableChildBuilder = Widget Function(
  BuildContext context,
  Rect rect,
  Flip flip,
);

/// A callback that is called when the box is moved or resized.
typedef OnBoxChanged = void Function(UITransformResult result);

/// A callback that is called when the box is moved.
typedef OnBoxMoved = void Function(UIMoveResult result);

/// A callback that is called when the box is resized.
typedef OnBoxResized = void Function(UIResizeResult result);

/// A callback that is called when the box reaches a terminal edge when
/// resizing.
typedef TerminalEdgeEvent = void Function(bool reached);

/// A callback that is called when the box reaches a minimum or maximum size
/// when resizing a specific axis.
typedef TerminalAxisEvent = void Function(bool reachedMin, bool reachedMax);

/// A callback that is called when the box reaches a minimum or maximum size
/// when resizing.
typedef TerminalEvent = void Function(
  bool reachedMinWidth,
  bool reachedMaxWidth,
  bool reachedMinHeight,
  bool reachedMaxHeight,
);

/// A callback for pointer down events.
typedef PointerDownCallback = void Function(Offset localPosition);

/// A callback for pointer update events.
typedef PointerUpdateCallback = void Function(
  Offset localPosition,
  HandlePosition handlePosition,
);

/// A callback for pointer up events.
typedef PointerUpCallback = VoidCallback;

/// A default implementation of the corner [HandleBuilder] callback.
Widget _defaultCornerHandleBuilder(
  BuildContext context,
  HandlePosition handle,
) =>
    DefaultCornerHandle(handle: handle);

/// A default implementation of the side [HandleBuilder] callback.
Widget _defaultSideHandleBuilder(
  BuildContext context,
  HandlePosition handle,
) =>
    DefaultSideHandle(handle: handle);

/// A widget that allows you to resize and drag a box around a widget.
class TransformableBox extends StatefulWidget {
  /// If you need more control over the [TransformableBox] you can pass a
  /// custom [TransformableBoxController] instance through the [controller]
  /// parameter.
  ///
  /// If you do not specify one, a default [TransformableBoxController] instance
  /// will be created internally, along with its lifecycle.
  final TransformableBoxController? controller;

  /// A builder function that is used to build the content of the
  /// [TransformableBox]. This is the physical widget you wish to show resizable
  /// handles on. It's most commonly something like an image widget, but it
  /// could be anything you want to have resizable & draggable box handles on.
  final TransformableChildBuilder childBuilder;

  /// A builder function that is used to build the corners handles of the
  /// [TransformableBox]. If you don't specify it, the default handles will be
  /// used.
  ///
  /// Note that this will build for all four corners of the rectangle.
  final HandleBuilder cornerHandleBuilder;

  /// A builder function that is used to build the side handles of the
  /// [TransformableBox]. If you don't specify it, the default handles will be
  /// used.
  ///
  /// Note that this will build for all four sides of the rectangle.
  final HandleBuilder sideHandleBuilder;

  /// The size of the gesture response area of the handles. If you don't
  /// specify it, the default value will be used.
  ///
  /// This is similar to Flutter's [MaterialTapTargetSize] property, in which
  /// the actual handle size is smaller than the gesture response area. This is
  /// done to improve accessibility and usability of the handles; users will not
  /// need cursor precision over the handle's pixels to be able to perform
  /// operations with them, they need only to be able to reach the handle's
  /// gesture response area to make it forgiving.
  ///
  /// The default value is 24 pixels in diameter.
  final double handleTapSize;

  /// The initial box that will be used to position set the initial size of
  /// the [TransformableBox] widget.
  ///
  /// This initial box will be mutated by the [TransformableBoxController] through
  /// different dragging, panning, and resizing operations.
  ///
  /// [Rect] is immutable, so a new [Rect] instance will be created every time
  /// the [TransformableBoxController] mutates the box. You can acquire your
  /// updated box through the [onChanged] callback or through an externally
  /// provided [TransformableBoxController] instance.
  final Rect rect;

  /// The initial flip that will be used to set the initial flip of the
  /// [TransformableBox] widget. Normally, flipping is done by the user through
  /// the handles, but you can set the initial flip through this parameter in
  /// case the initial state of the box is in a flipped state.
  ///
  /// This utility cannot predicate if a box is flipped or not, so you will
  /// need to provide the correct initial flip state.
  ///
  /// Note that the flip is optional, if you're resizing an image, for example,
  /// you might want to allow flipping of the image when the user drags the
  /// handles to opposite corners of the box. This flip behavior is entirely
  /// optional and will allow handling such cases.
  ///
  /// You can leave it at the default [Flip.none] if flipping is not desired.
  /// Note that this will not prevent the drag handles from crossing to
  /// opposite corners of the box, it will only give oyu a lack of information
  /// on the state of the box if flipping were to occur.
  final Flip flip;

  /// A box that will contain the [rect] inside of itself, forcing [rect] to
  /// be clamped inside of this [clampingRect].
  final Rect clampingRect;

  /// A set of constraints that will be applied to the [rect] when it is
  /// resized by the [TransformableBoxController].
  final BoxConstraints constraints;

  /// A callback that is called every time the [TransformableBox] is updated.
  /// This is called every time the [TransformableBoxController] mutates the box
  /// or the flip.
  final OnBoxChanged? onChanged;

  /// A callback that is called every time the [TransformableBox] is moved.
  /// This is called every time the [TransformableBoxController] mutates the
  /// box.
  ///
  /// This is different from [onChanged] in that it is only called when the box
  /// is moved, not when the box is resized.
  final OnBoxMoved? onMoved;

  /// A callback that is called every time the [TransformableBox] is resized.
  /// This is called every time the [TransformableBoxController] mutates the
  /// box.
  ///
  /// This is different from [onChanged] in that it is only called when the box
  /// is resized, not when the box is moved.
  final OnBoxResized? onResized;

  /// The callback function that is used to resolve the [ResizeMode] based on
  /// the pressed keys on the keyboard.
  final ResolveResizeModeCallback? resolveResizeModeCallback;

  /// A callback function that triggers when the box reaches its minimum width
  /// when resizing.
  final TerminalEdgeEvent? onMinWidthReached;

  /// A callback function that triggers when the box reaches its maximum width
  /// when resizing.
  final TerminalEdgeEvent? onMaxWidthReached;

  /// A callback function that triggers when the box reaches its minimum height
  /// when resizing.
  final TerminalEdgeEvent? onMinHeightReached;

  /// A callback function that triggers when the box reaches its maximum height
  /// when resizing.
  final TerminalEdgeEvent? onMaxHeightReached;

  /// A callback function that triggers when the box reaches a terminal width
  /// when resizing. A terminal width is a width that is either the minimum or
  /// maximum width of the box.
  ///
  /// This function combines both [onMinWidthReached] and [onMaxWidthReached]
  /// into one callback function.
  final TerminalAxisEvent? onTerminalWidthReached;

  /// A callback function that triggers when the box reaches a terminal height
  /// when resizing. A terminal height is a height that is either the minimum or
  /// maximum height of the box.
  ///
  /// This function combines both [onMinHeightReached] and [onMaxHeightReached]
  /// into one callback function.
  final TerminalAxisEvent? onTerminalHeightReached;

  /// A callback function that triggers when the box reaches a terminal size
  /// when resizing. A terminal size is a size that is either the minimum or
  /// maximum size of the box on either axis.
  ///
  /// This function combines both [onTerminalWidthReached] and
  /// [onTerminalHeightReached] into one callback function.
  final TerminalEvent? onTerminalSizeReached;

  /// Whether the box is resizable or not. Setting this to false will disable
  /// all resizing operations.
  final bool resizable;

  /// Whether the box is movable or not. Setting this to false will disable
  /// all moving operations.
  final bool movable;

  /// Whether to allow flipping of the box while resizing. If this is set to
  /// true, the box will flip when the user drags the handles to opposite
  /// corners of the rect.
  final bool flipWhileResizing;

  /// Whether to flip the child of the box when the box is flipped. If this is
  /// set to true, the child will be flipped when the box is flipped.
  final bool flipChild;

  /// Creates a [TransformableBox] widget.
  const TransformableBox({
    super.key,
    required this.childBuilder,
    this.onChanged,
    this.onMoved,
    this.onResized,
    this.controller,
    this.cornerHandleBuilder = _defaultCornerHandleBuilder,
    this.sideHandleBuilder = _defaultSideHandleBuilder,
    this.handleTapSize = 24,
    // raw
    Rect? rect,
    Flip? flip,
    Rect? clampingRect,
    BoxConstraints? constraints,
    ResolveResizeModeCallback? resolveResizeModeCallback,
    // terminal update events
    this.onMinWidthReached,
    this.onMaxWidthReached,
    this.onMinHeightReached,
    this.onMaxHeightReached,
    this.onTerminalWidthReached,
    this.onTerminalHeightReached,
    this.onTerminalSizeReached,
    this.resizable = true,
    this.movable = true,
    this.flipWhileResizing = true,
    this.flipChild = true,
  })  : assert(
          controller == null ||
              (rect == null &&
                  flip == null &&
                  clampingRect == null &&
                  constraints == null &&
                  resolveResizeModeCallback == null),
          'You can either provide a [controller] OR a [box], [flip], '
          '[clampingRect], [constraints], and [resolveResizeModeCallback]. '
          'You cannot use any of those properties when providing a controller and'
          'vice versa.',
        ),
        rect = rect ?? Rect.zero,
        flip = flip ?? Flip.none,
        clampingRect = clampingRect ?? Rect.largest,
        constraints = constraints ?? const BoxConstraints.expand(),
        resolveResizeModeCallback =
            resolveResizeModeCallback ?? defaultResolveResizeModeCallback;

  @override
  State<TransformableBox> createState() => _TransformableBoxState();
}

class _TransformableBoxState extends State<TransformableBox> {
  late TransformableBoxController controller;

  @override
  void initState() {
    super.initState();

    if (widget.controller != null) {
      controller = widget.controller!;
      // We only want to listen to the controller if it is provided externally.
      controller.addListener(onControllerUpdate);
    } else {
      // If it is provided internally, we should not listen to it.
      controller = TransformableBoxController()
        ..rect = widget.rect
        ..flip = widget.flip
        ..clampingRect = widget.clampingRect
        ..constraints = widget.constraints
        ..resolveResizeModeCallback = widget.resolveResizeModeCallback
        ..movable = widget.movable
        ..resizable = widget.resizable
        ..flipWhileResizing = widget.flipWhileResizing
        ..flipChild = widget.flipChild;
    }
  }

  @override
  void didUpdateWidget(covariant TransformableBox oldWidget) {
    super.didUpdateWidget(oldWidget);

    if (widget.controller != null && oldWidget.controller == null ||
        widget.controller != oldWidget.controller) {
      // New explicit controller provided or explicit controller changed.
      controller.removeListener(onControllerUpdate);
      controller = widget.controller!;
      controller.addListener(onControllerUpdate);
    } else if (oldWidget.controller != null && widget.controller == null) {
      // Explicit controller removed.
      controller.removeListener(onControllerUpdate);
      controller = TransformableBoxController()
        ..rect = widget.rect
        ..flip = widget.flip
        ..clampingRect = widget.clampingRect
        ..constraints = widget.constraints
        ..resolveResizeModeCallback = widget.resolveResizeModeCallback
        ..resizable = widget.resizable
        ..movable = widget.movable
        ..flipWhileResizing = widget.flipWhileResizing
        ..flipChild = widget.flipChild;
    }

    // Return if the controller is external.
    if (widget.controller != null) return;

    // Below code should only be executed if the controller is internal.

    if (oldWidget.rect != widget.rect) {
      controller.rect = widget.rect;
    }
    if (oldWidget.flip != widget.flip) {
      controller.flip = widget.flip;
    }
    if (oldWidget.resolveResizeModeCallback !=
        widget.resolveResizeModeCallback) {
      controller.resolveResizeModeCallback = widget.resolveResizeModeCallback;
    }
    if (oldWidget.clampingRect != widget.clampingRect) {
      controller.clampingRect = widget.clampingRect;
      controller.recalculatePosition(notify: false);
    }

    if (oldWidget.constraints != widget.constraints) {
      controller.constraints = widget.constraints;
      controller.recalculateSize(notify: false);
    }

    if (oldWidget.resizable != widget.resizable) {
      controller.resizable = widget.resizable;
    }

    if (oldWidget.movable != widget.movable) {
      controller.movable = widget.movable;
    }

    if (oldWidget.flipChild != widget.flipChild) {
      controller.flipChild = widget.flipChild;
    }

    if (oldWidget.flipWhileResizing != widget.flipWhileResizing) {
      controller.flipWhileResizing = widget.flipWhileResizing;
    }
  }

  @override
  void dispose() {
    controller.removeListener(onControllerUpdate);
    if (widget.controller == null) controller.dispose();
    super.dispose();
  }

  /// Called when the controller is updated.
  void onControllerUpdate() {
    if (widget.rect != controller.rect || widget.flip != controller.flip) {
      if (mounted) setState(() {});
    }
  }

  /// Called when the handle drag starts.
  void onHandlePanStart(Offset localPosition) {
    controller.onResizeStart(localPosition);
  }

  /// Called when the handle drag updates.
  void onHandlePanUpdate(Offset localPosition, HandlePosition handlePosition) {
    if (!controller.resizable) return;
    final UIResizeResult result = controller.onResizeUpdate(
      localPosition,
      handlePosition,
      notify: false,
    );

    widget.onChanged?.call(result);
    widget.onResized?.call(result);
    widget.onMinWidthReached?.call(result.minWidthReached);
    widget.onMaxWidthReached?.call(result.maxWidthReached);
    widget.onMinHeightReached?.call(result.minHeightReached);
    widget.onMaxHeightReached?.call(result.maxHeightReached);
    widget.onTerminalWidthReached?.call(
      result.minWidthReached,
      result.maxWidthReached,
    );
    widget.onTerminalHeightReached?.call(
      result.minHeightReached,
      result.maxHeightReached,
    );
    widget.onTerminalSizeReached?.call(
      result.minWidthReached,
      result.maxWidthReached,
      result.minHeightReached,
      result.maxHeightReached,
    );
  }

  /// Called when the handle drag ends.
  void onHandlePanEnd() {
    controller.onResizeEnd();
    widget.onMinWidthReached?.call(false);
    widget.onMaxWidthReached?.call(false);
    widget.onMinHeightReached?.call(false);
    widget.onMaxHeightReached?.call(false);
    widget.onTerminalWidthReached?.call(false, false);
    widget.onTerminalHeightReached?.call(false, false);
    widget.onTerminalSizeReached?.call(false, false, false, false);
  }

  @override
  Widget build(BuildContext context) {
    final Flip flip = controller.flip;
    final Rect box = controller.rect;
    return Positioned.fromRect(
      rect: box.inflate(widget.handleTapSize / 2),
      child: Stack(
        clipBehavior: Clip.none,
        fit: StackFit.expand,
        children: [
          Positioned(
            left: widget.handleTapSize / 2,
            top: widget.handleTapSize / 2,
            width: box.width,
            height: box.height,
            child: Listener(
              behavior: HitTestBehavior.opaque,
              onPointerDown: (event) =>
                  controller.onDragStart(event.localPosition),
              onPointerMove: (event) {
                if (!controller.movable) return;
                final UIMoveResult result = controller.onDragUpdate(
                  event.localPosition,
                  notify: false,
                );
                widget.onChanged?.call(result);
                widget.onMoved?.call(result);
              },
              onPointerUp: (event) => controller.onDragEnd(),
              onPointerCancel: (event) => controller.onDragEnd(),
              child: Transform.scale(
                scaleX: controller.flipChild && flip.isHorizontal ? -1 : 1,
                scaleY: controller.flipChild && flip.isVertical ? -1 : 1,
                child: widget.childBuilder(context, box, flip),
              ),
            ),
          ),
          for (final handle in HandlePosition.corners)
            _CornerHandleWidget(
              key: ValueKey(handle),
              handlePosition: handle,
              handleTapSize: widget.handleTapSize,
              builder: widget.cornerHandleBuilder,
              onPointerDown: onHandlePanStart,
              onPointerUpdate: onHandlePanUpdate,
              onPointerUp: onHandlePanEnd,
            ),
          for (final handle in HandlePosition.sides)
            _SideHandleWidget(
              key: ValueKey(handle),
              handlePosition: handle,
              handleTapSize: widget.handleTapSize,
              builder: widget.sideHandleBuilder,
              onPointerDown: onHandlePanStart,
              onPointerUpdate: onHandlePanUpdate,
              onPointerUp: onHandlePanEnd,
            ),
        ],
      ),
    );
  }
}

/// Creates a new corner handle widget, with its appropriate gesture splash
/// zone.
class _CornerHandleWidget extends StatelessWidget {
  /// The position of the handle.
  final HandlePosition handlePosition;

  /// The builder that is used to build the handle widget.
  final HandleBuilder builder;

  /// The size of the handle's gesture response area.
  final double handleTapSize;

  /// Called when the handle dragging starts.
  final PointerDownCallback onPointerDown;

  /// Called when the handle dragging is updated.
  final PointerUpdateCallback onPointerUpdate;

  /// Called when the handle dragging ends.
  final PointerUpCallback onPointerUp;

  /// Creates a new handle widget.
  _CornerHandleWidget({
    super.key,
    required this.handlePosition,
    required this.handleTapSize,
    required this.builder,
    required this.onPointerDown,
    required this.onPointerUpdate,
    required this.onPointerUp,
  }) : assert(handlePosition.isDiagonal, 'A corner handle must be diagonal.');

  @override
  Widget build(BuildContext context) {
    return Positioned(
      left: handlePosition.influencesLeft ? 0 : null,
      right: handlePosition.influencesRight ? 0 : null,
      top: handlePosition.influencesTop ? 0 : null,
      bottom: handlePosition.influencesBottom ? 0 : null,
      width: handleTapSize,
      height: handleTapSize,
      child: Listener(
        behavior: HitTestBehavior.opaque,
        onPointerDown: (event) {
          onPointerDown(event.localPosition);
        },
        onPointerMove: (event) {
          onPointerUpdate(event.localPosition, handlePosition);
        },
        onPointerUp: (event) {
          onPointerUp();
        },
        onPointerCancel: (event) {
          onPointerUp();
        },
        child: MouseRegion(
          cursor: getCursorForHandle(handlePosition),
          child: builder(context, handlePosition),
        ),
      ),
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
class _SideHandleWidget extends StatelessWidget {
  /// The position of the handle.
  final HandlePosition handlePosition;

  /// The builder that is used to build the handle widget.
  final HandleBuilder builder;

  /// The thickness of the handle that is used for gesture detection.
  final double handleTapSize;

  /// Called when the handle dragging starts.
  final PointerDownCallback onPointerDown;

  /// Called when the handle dragging is updated.
  final PointerUpdateCallback onPointerUpdate;

  /// Called when the handle dragging ends.
  final PointerUpCallback onPointerUp;

  /// Creates a new handle widget.
  _SideHandleWidget({
    super.key,
    required this.handlePosition,
    required this.handleTapSize,
    required this.builder,
    required this.onPointerDown,
    required this.onPointerUpdate,
    required this.onPointerUp,
  }) : assert(handlePosition.isSide, 'A cardinal handle must be cardinal.');

  @override
  Widget build(BuildContext context) {
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
      child: Listener(
        behavior: HitTestBehavior.opaque,
        onPointerDown: (event) {
          onPointerDown(event.localPosition);
        },
        onPointerMove: (event) {
          onPointerUpdate(event.localPosition, handlePosition);
        },
        onPointerUp: (event) {
          onPointerUp();
        },
        onPointerCancel: (event) {
          onPointerUp();
        },
        child: MouseRegion(
          cursor: getCursorForHandle(handlePosition),
          child: builder(context, handlePosition),
        ),
      ),
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
