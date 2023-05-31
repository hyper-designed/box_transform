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
typedef RectChangeEvent = void Function(
  UITransformResult result,
  PointerMoveEvent event,
);

/// A callback that is called when the box begins a drag operation.
typedef RectDragStartEvent = void Function(
  UIMoveResult result,
  PointerMoveEvent event,
);

/// A callback that is called when the box is being dragged.
typedef RectDragUpdateEvent = void Function(
  UIMoveResult result,
  PointerMoveEvent event,
);

/// A callback that is called when the box ends a drag operation.
/// [event] is either [PointerUpEvent] or [PointerCancelEvent].
typedef RectDragEndEvent = void Function(
  UIMoveResult result,
  PointerEvent event,
);

/// A callback that is called when the box begins a resize operation.
typedef RectResizeStart = void Function(
  HandlePosition handle,
  PointerDownEvent event,
);

/// A callback that is called when the box is being resized.
typedef RectResizeUpdateEvent = void Function(
  UIResizeResult result,
  PointerMoveEvent event,
);

/// A callback that is called when the box ends a resize operation.
/// [event] is either [PointerUpEvent] or [PointerCancelEvent].
typedef RectResizeEnd = void Function(
  HandlePosition handle,
  PointerEvent event,
);

/// A callback that is called when the box reaches a terminal edge when
/// resizing.
/// [event] is either [PointerUpEvent] or [PointerCancelEvent].
typedef TerminalEdgeEvent = void Function(
  bool reached,
  PointerEvent event,
);

/// A callback that is called when the box reaches a minimum or maximum size
/// when resizing a specific axis.
/// [event] is either [PointerUpEvent] or [PointerCancelEvent].
typedef TerminalAxisEvent = void Function(
  bool reachedMin,
  bool reachedMax,
  PointerEvent event,
);

/// A callback that is called when the box reaches a minimum or maximum size
/// when resizing.
/// [event] is either [PointerUpEvent] or [PointerCancelEvent].
typedef TerminalEvent = void Function(
  bool reachedMinWidth,
  bool reachedMaxWidth,
  bool reachedMinHeight,
  bool reachedMaxHeight,
  PointerEvent event,
);

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
  final TransformableChildBuilder contentBuilder;

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
  /// updated box through the [onChangeUpdate] callback or through an externally
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

  /// Whether the box is resizable or not. Setting this to false will disable
  /// all resizing operations.
  final bool resizable;

  /// Whether the box should hide the corner/side resize controls when [resizable] is
  /// false.
  final bool hideHandlesWhenNotResizable;

  /// Whether the box is movable or not. Setting this to false will disable
  /// all moving operations.
  final bool movable;

  /// Whether to allow flipping of the box while resizing. If this is set to
  /// true, the box will flip when the user drags the handles to opposite
  /// corners of the rect.
  final bool allowFlippingWhileResizing;

  /// Decides whether to flip the contents of the box when the box is flipped.
  /// If this is set to true, the contents will be flipped when the box is
  /// flipped.
  final bool allowContentFlipping;

  /// How to align the handles.
  final HandleAlignment handleAlignment;

  /// The callback function that is used to resolve the [ResizeMode] based on
  /// the pressed keys on the keyboard.
  final ResizeModeResolver? resizeModeResolver;

  /// A callback that is called every time the [TransformableBox] is updated.
  /// This is called every time the [TransformableBoxController] mutates the box
  /// or the flip.
  final RectChangeEvent? onChangeUpdate;

  /// A callback that is called when [TransformableBox] triggers a pointer down
  /// event to begin a drag operation.
  final RectDragStartEvent? onDragStart;

  /// A callback that is called every time the [TransformableBox] is moved.
  /// This is called every time the [TransformableBoxController] mutates the
  /// box through a drag operation.
  ///
  /// This is different from [onChangeUpdate] in that it is only called when the
  /// box is moved, not when the box is resized.
  final RectDragUpdateEvent? onDragUpdate;

  /// A callback that is called every time the [TransformableBox] is completes
  /// its drag operation via pointer up or cancel events.
  final RectDragEndEvent? onDragEnd;

  /// A callback function that triggers when the box is about to start resizing.
  final RectResizeStart? onResizeStart;

  /// A callback that is called every time the [TransformableBox] is resized.
  /// This is called every time the [TransformableBoxController] mutates the
  /// box.
  ///
  /// This is different from [onChangeUpdate] in that it is only called when the box
  /// is resized, not when the box is moved.
  final RectResizeUpdateEvent? onResizeUpdate;

  /// A callback function that triggers when the box is about to end resizing.
  final RectResizeEnd? onResizeEnd;

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

  /// Creates a [TransformableBox] widget.
  const TransformableBox({
    super.key,
    required this.contentBuilder,
    this.controller,
    this.cornerHandleBuilder = _defaultCornerHandleBuilder,
    this.sideHandleBuilder = _defaultSideHandleBuilder,
    this.handleTapSize = 24,
    this.allowContentFlipping = true,
    this.hideHandlesWhenNotResizable = true,
    this.handleAlignment = HandleAlignment.center,

    // Raw values.
    Rect? rect,
    Flip? flip,
    Rect? clampingRect,
    BoxConstraints? constraints,
    ResizeModeResolver? resizeModeResolver,

    // Additional controls.
    this.resizable = true,
    this.movable = true,
    this.allowFlippingWhileResizing = true,

    // Terminal update events.
    this.onMinWidthReached,
    this.onMaxWidthReached,
    this.onMinHeightReached,
    this.onMaxHeightReached,
    this.onTerminalWidthReached,
    this.onTerminalHeightReached,
    this.onTerminalSizeReached,

    // Resize events
    this.onResizeStart,
    this.onResizeUpdate,
    this.onResizeEnd,

    // Drag Events.
    this.onDragStart,
    this.onDragUpdate,
    this.onDragEnd,
    this.onChangeUpdate,
  })  : assert(
          (controller == null) != (rect == null),
          'Either provide a controller or a rect, not both. If you wish to use a controller, you cannot use the other parameters.',
        ),
        assert(
          (controller == null) != (flip == null),
          'Either provide a controller or a flip, not both. If you wish to use a controller, you cannot use the other parameters.',
        ),
        assert(
          (controller == null) != (clampingRect == null),
          'Either provide a controller or a clampingRect, not both. If you wish to use a controller, you cannot use the other parameters.',
        ),
        assert(
          (controller == null) != (constraints == null),
          'Either provide a controller or a constraints, not both. If you wish to use a controller, you cannot use the other parameters.',
        ),
        assert(
          (controller == null) != (resizeModeResolver == null),
          'Either provide a controller or a resizeModeResolver, not both. If you wish to use a controller, you cannot use the other parameters.',
        ),
        rect = rect ?? Rect.zero,
        flip = flip ?? Flip.none,
        clampingRect = clampingRect ?? Rect.largest,
        constraints = constraints ?? const BoxConstraints.expand(),
        resizeModeResolver = resizeModeResolver ?? defaultResizeModeResolver;

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
      controller = TransformableBoxController(
        rect: widget.rect,
        flip: widget.flip,
        clampingRect: widget.clampingRect,
        constraints: widget.constraints,
        resizeModeResolver: widget.resizeModeResolver,
        allowFlippingWhileResizing: widget.allowFlippingWhileResizing,
        resizable: widget.resizable,
        movable: widget.movable,
      );
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
      controller = TransformableBoxController(
        rect: widget.rect,
        flip: widget.flip,
        clampingRect: widget.clampingRect,
        constraints: widget.constraints,
        resizeModeResolver: widget.resizeModeResolver,
        allowFlippingWhileResizing: widget.allowFlippingWhileResizing,
        resizable: widget.resizable,
        movable: widget.movable,
      );
    }

    // Return if the controller is external.
    if (widget.controller != null) return;

    // Below code should only be executed if the controller is internal.
    bool shouldRecalculatePosition = false;
    bool shouldRecalculateSize = false;

    if (oldWidget.rect != widget.rect) {
      controller.setRect(widget.rect, notify: false);
    }

    if (oldWidget.flip != widget.flip) {
      controller.setFlip(widget.flip, notify: false);
    }

    if (oldWidget.resizeModeResolver != widget.resizeModeResolver) {
      controller.setResizeModeResolver(widget.resizeModeResolver,
          notify: false);
    }

    if (oldWidget.clampingRect != widget.clampingRect) {
      controller.setClampingRect(widget.clampingRect, notify: false);
      shouldRecalculatePosition = true;
    }

    if (oldWidget.constraints != widget.constraints) {
      controller.setConstraints(widget.constraints, notify: false);
      shouldRecalculateSize = true;
    }

    if (oldWidget.resizable != widget.resizable) {
      controller.setResizable(widget.resizable, notify: false);
    }

    if (oldWidget.hideHandlesWhenNotResizable !=
        widget.hideHandlesWhenNotResizable) {
      controller.setHideHandlesWhenNotResizable(
        widget.hideHandlesWhenNotResizable,
        notify: false,
      );
    }

    if (oldWidget.movable != widget.movable) {
      controller.setMovable(widget.movable, notify: false);
    }

    if (oldWidget.allowFlippingWhileResizing !=
        widget.allowFlippingWhileResizing) {
      controller.setAllowFlippingWhileResizing(
        widget.allowFlippingWhileResizing,
        notify: false,
      );
    }

    if (shouldRecalculatePosition) {
      controller.recalculatePosition(notify: false);
    }

    if (shouldRecalculateSize) {
      controller.recalculateSize(notify: false);
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
  void onPointerDown(PointerDownEvent event, HandlePosition handle) {
    controller.onResizeStart(event.localPosition);
    widget.onResizeStart?.call(handle, event);
  }

  /// Called when the handle drag updates.
  void onPointerUpdate(PointerMoveEvent event, HandlePosition handlePosition) {
    if (!controller.resizable) return;
    final UIResizeResult result = controller.onResizeUpdate(
      event.localPosition,
      handlePosition,
      notify: false,
    );

    widget.onChangeUpdate?.call(result, event);
    widget.onResizeUpdate?.call(result, event);
    widget.onMinWidthReached?.call(result.minWidthReached, event);
    widget.onMaxWidthReached?.call(result.maxWidthReached, event);
    widget.onMinHeightReached?.call(result.minHeightReached, event);
    widget.onMaxHeightReached?.call(result.maxHeightReached, event);
    widget.onTerminalWidthReached?.call(
      result.minWidthReached,
      result.maxWidthReached,
      event,
    );
    widget.onTerminalHeightReached?.call(
      result.minHeightReached,
      result.maxHeightReached,
      event,
    );
    widget.onTerminalSizeReached?.call(
      result.minWidthReached,
      result.maxWidthReached,
      result.minHeightReached,
      result.maxHeightReached,
      event,
    );
  }

  /// Called when the handle drag ends.
  void onPointerUp(PointerEvent event, HandlePosition handle) {
    controller.onResizeEnd();
    widget.onMinWidthReached?.call(false, event);
    widget.onMaxWidthReached?.call(false, event);
    widget.onMinHeightReached?.call(false, event);
    widget.onMaxHeightReached?.call(false, event);
    widget.onTerminalWidthReached?.call(false, false, event);
    widget.onTerminalHeightReached?.call(false, false, event);
    widget.onTerminalSizeReached?.call(false, false, false, false, event);
    widget.onResizeEnd?.call(handle, event);
  }

  @override
  Widget build(BuildContext context) {
    final Flip flip = controller.flip;
    final Rect box = controller.rect;
    return Positioned.fromRect(
      rect: box.inflate(widget.handleAlignment.offset(widget.handleTapSize)),
      child: Stack(
        clipBehavior: Clip.none,
        fit: StackFit.expand,
        children: [
          Positioned(
            left: widget.handleAlignment.offset(widget.handleTapSize),
            top: widget.handleAlignment.offset(widget.handleTapSize),
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
                widget.onChangeUpdate?.call(result, event);
                widget.onDragUpdate?.call(result, event);
              },
              onPointerUp: (event) => controller.onDragEnd(),
              onPointerCancel: (event) => controller.onDragEnd(),
              child: Transform.scale(
                scaleX:
                    widget.allowContentFlipping && flip.isHorizontal ? -1 : 1,
                scaleY: widget.allowContentFlipping && flip.isVertical ? -1 : 1,
                child: widget.contentBuilder(context, box, flip),
              ),
            ),
          ),
          if (controller.resizable || !controller.hideHandlesWhenNotResizable)
            for (final handle in HandlePosition.corners)
              _CornerHandleWidget(
                key: ValueKey(handle),
                handlePosition: handle,
                handleTapSize: widget.handleTapSize,
                builder: widget.cornerHandleBuilder,
                onPointerDown: (event) => onPointerDown(event, handle),
                onPointerUpdate: (event) => onPointerUpdate(event, handle),
                onPointerUp: (event) => onPointerUp(event, handle),
                onPointerCancel: (event) => onPointerUp(event, handle),
              ),
          if (controller.resizable || !controller.hideHandlesWhenNotResizable)
            for (final handle in HandlePosition.sides)
              _SideHandleWidget(
                key: ValueKey(handle),
                handlePosition: handle,
                handleTapSize: widget.handleTapSize,
                builder: widget.sideHandleBuilder,
                onPointerDown: (event) => onPointerDown(event, handle),
                onPointerUpdate: (event) => onPointerUpdate(event, handle),
                onPointerUp: (event) => onPointerUp(event, handle),
                onPointerCancel: (event) => onPointerUp(event, handle),
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
  final PointerDownEventListener onPointerDown;

  /// Called when the handle dragging is updated.
  final PointerMoveEventListener onPointerUpdate;

  /// Called when the handle dragging ends.
  final PointerUpEventListener onPointerUp;

  /// Called when the handle dragging is canceled.
  final PointerCancelEventListener onPointerCancel;

  /// Creates a new handle widget.
  _CornerHandleWidget({
    super.key,
    required this.handlePosition,
    required this.handleTapSize,
    required this.builder,
    required this.onPointerDown,
    required this.onPointerUpdate,
    required this.onPointerUp,
    required this.onPointerCancel,
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
        onPointerDown: onPointerDown,
        onPointerMove: onPointerUpdate,
        onPointerUp: onPointerUp,
        onPointerCancel: onPointerCancel,
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
  final PointerDownEventListener onPointerDown;

  /// Called when the handle dragging is updated.
  final PointerMoveEventListener onPointerUpdate;

  /// Called when the handle dragging ends.
  final PointerUpEventListener onPointerUp;

  /// Called when the handle dragging is canceled.
  final PointerCancelEventListener onPointerCancel;

  /// Creates a new handle widget.
  _SideHandleWidget({
    super.key,
    required this.handlePosition,
    required this.handleTapSize,
    required this.builder,
    required this.onPointerDown,
    required this.onPointerUpdate,
    required this.onPointerUp,
    required this.onPointerCancel,
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
        onPointerDown: onPointerDown,
        onPointerMove: onPointerUpdate,
        onPointerUp: onPointerUp,
        onPointerCancel: onPointerCancel,
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
