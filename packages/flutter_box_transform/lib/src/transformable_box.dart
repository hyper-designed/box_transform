import 'dart:ui';

import 'package:box_transform/box_transform.dart';
import 'package:flutter/material.dart';

import 'handle_builders.dart';
import 'handles.dart';
import 'transformable_box_controller.dart';
import 'typedefs.dart';
import 'ui_result.dart';

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

  /// A set containing handles that are enabled. This is different from
  /// [visibleHandles].
  ///
  /// [enabledHandles] determines which handles are
  /// interactive and can be used to resize the box. [visibleHandles]
  /// determines which handles are visible. If a handle is visible but not
  /// enabled, it will not be interactive. If a handle is enabled but not
  /// visible, it will not be shown and will not be interactive.
  final Set<HandlePosition> enabledHandles;

  /// A set containing which handles to show. This is different from
  /// [enabledHandles].
  ///
  /// [enabledHandles] determines which handles are
  /// interactive and can be used to resize the box. [visibleHandles]
  /// determines which handles are visible. If a handle is visible but not
  /// enabled, it will not be interactive. If a handle is enabled but not
  /// visible, it will not be shown and will not be interactive.
  final Set<HandlePosition> visibleHandles;

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

  /// Whether the box is resizable or not. Setting this to false will disable
  /// all resizing operations. This is a convenience parameter that will ignore
  /// the [enabledHandles] parameter and set all handles to disabled.
  final bool resizable;

  /// Whether the box is movable or not. Setting this to false will disable
  /// all moving operations.
  final bool draggable;

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
  final ValueGetter<ResizeMode> resizeModeResolver;

  /// A callback that is called every time the [TransformableBox] is updated.
  /// This is called every time the [TransformableBoxController] mutates the box
  /// or the flip.
  final RectChangeEvent? onChanged;

  /// A callback that is called when [TransformableBox] triggers a pointer down
  /// event to begin a drag operation.
  final RectDragStartEvent? onDragStart;

  /// A callback that is called every time the [TransformableBox] is moved.
  /// This is called every time the [TransformableBoxController] mutates the
  /// box through a drag operation.
  ///
  /// This is different from [onChanged] in that it is only called when the
  /// box is moved, not when the box is resized.
  final RectDragUpdateEvent? onDragUpdate;

  /// A callback that is called every time the [TransformableBox] is completes
  /// its drag operation via the pan end event.
  final RectDragEndEvent? onDragEnd;

  /// A callback that is called every time the [TransformableBox] cancels
  /// its drag operation via the pan cancel event.
  final RectDragCancelEvent? onDragCancel;

  /// A callback function that triggers when the box is about to start resizing.
  final RectResizeStart? onResizeStart;

  /// A callback that is called every time the [TransformableBox] is resized.
  /// This is called every time the [TransformableBoxController] mutates the
  /// box.
  ///
  /// This is different from [onChanged] in that it is only called when the box
  /// is resized, not when the box is moved.
  final RectResizeUpdateEvent? onResizeUpdate;

  /// A callback function that triggers when the box is about to end resizing.
  final RectResizeEnd? onResizeEnd;

  /// A callback function that triggers when the box cancels resizing.
  final RectResizeCancel? onResizeCancel;

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
    this.handleAlignment = HandleAlignment.center,
    this.enabledHandles = const {...HandlePosition.values},
    this.visibleHandles = const {...HandlePosition.values},

    // Raw values.
    Rect? rect,
    Flip? flip,
    Rect? clampingRect,
    BoxConstraints? constraints,
    ValueGetter<ResizeMode>? resizeModeResolver,

    // Additional controls.
    this.resizable = true,
    this.draggable = true,
    this.allowFlippingWhileResizing = true,

    // Either resize or drag triggers.
    this.onChanged,

    // Resize events
    this.onResizeStart,
    this.onResizeUpdate,
    this.onResizeEnd,
    this.onResizeCancel,

    // Drag Events.
    this.onDragStart,
    this.onDragUpdate,
    this.onDragEnd,
    this.onDragCancel,

    // Terminal update events.
    this.onMinWidthReached,
    this.onMaxWidthReached,
    this.onMinHeightReached,
    this.onMaxHeightReached,
    this.onTerminalWidthReached,
    this.onTerminalHeightReached,
    this.onTerminalSizeReached,
  })  : assert(
          (controller == null) ||
              ((rect == null) &&
                  (flip == null) &&
                  (clampingRect == null) &&
                  (constraints == null) &&
                  (resizeModeResolver == null)),
          'If a controller is provided, the raw values should not be provided.',
        ),
        rect = rect ?? Rect.zero,
        flip = flip ?? Flip.none,
        clampingRect = clampingRect ?? Rect.largest,
        constraints = constraints ?? const BoxConstraints.expand(),
        resizeModeResolver = resizeModeResolver ?? defaultResizeModeResolver;

  /// Returns the [TransformableBox] of the closest ancestor.
  static TransformableBox? widgetOf(BuildContext context) {
    return context.findAncestorWidgetOfExactType<TransformableBox>();
  }

  /// Returns the [TransformableBoxController] of the closest ancestor.
  static TransformableBoxController? controllerOf(BuildContext context) {
    return context
        .findAncestorStateOfType<_TransformableBoxState>()
        ?.controller;
  }

  @override
  State<TransformableBox> createState() => _TransformableBoxState();
}

class _TransformableBoxState extends State<TransformableBox> {
  late TransformableBoxController controller;

  bool isLegalGesture = false;

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
      controller.setResizeModeResolver(
        widget.resizeModeResolver,
        notify: false,
      );
    }

    if (oldWidget.clampingRect != widget.clampingRect) {
      controller.setClampingRect(widget.clampingRect, notify: false);
      shouldRecalculatePosition = true;
    }

    if (oldWidget.constraints != widget.constraints) {
      controller.setConstraints(widget.constraints, notify: false);
      shouldRecalculateSize = true;
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
  void onHandlePanStart(DragStartDetails event, HandlePosition handle) {
    // Two fingers were used to start the drag. This produces issues with
    // the box drag event. Therefore, we ignore it.
    if (event.kind == PointerDeviceKind.trackpad) {
      isLegalGesture = false;
      return;
    } else {
      isLegalGesture = true;
    }

    controller.onResizeStart(event.localPosition);
    widget.onResizeStart?.call(handle, event);
  }

  /// Called when the handle drag updates.
  void onHandlePanUpdate(DragUpdateDetails event, HandlePosition handle) {
    if (!isLegalGesture) return;

    final UIResizeResult result = controller.onResizeUpdate(
      event.localPosition,
      handle,
    );

    widget.onChanged?.call(result, event);
    widget.onResizeUpdate?.call(result, event);
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
  void onHandlePanEnd(DragEndDetails event, HandlePosition handle) {
    if (!isLegalGesture) return;

    controller.onResizeEnd();
    widget.onResizeEnd?.call(handle, event);
    widget.onMinWidthReached?.call(false);
    widget.onMaxWidthReached?.call(false);
    widget.onMinHeightReached?.call(false);
    widget.onMaxHeightReached?.call(false);
    widget.onTerminalWidthReached?.call(false, false);
    widget.onTerminalHeightReached?.call(false, false);
    widget.onTerminalSizeReached?.call(false, false, false, false);
  }

  void onHandlePanCancel(HandlePosition handle) {
    if (!isLegalGesture) return;

    controller.onResizeEnd();
    widget.onResizeCancel?.call(handle);
    widget.onMinWidthReached?.call(false);
    widget.onMaxWidthReached?.call(false);
    widget.onMinHeightReached?.call(false);
    widget.onMaxHeightReached?.call(false);
    widget.onTerminalWidthReached?.call(false, false);
    widget.onTerminalHeightReached?.call(false, false);
    widget.onTerminalSizeReached?.call(false, false, false, false);
  }

  /// Called when the box drag event starts.
  void onDragPanStart(DragStartDetails event) {
    // Two fingers were used to start the drag. This produces issues with
    // the box drag event. Therefore, we ignore it.
    if (event.kind == PointerDeviceKind.trackpad) {
      isLegalGesture = false;
      return;
    } else {
      isLegalGesture = true;
    }

    controller.onDragStart(event.localPosition);
    widget.onDragStart?.call(event);
  }

  /// Called when the box drag event updates.
  void onDragPanUpdate(DragUpdateDetails event) {
    if (!isLegalGesture) return;

    final UIMoveResult result = controller.onDragUpdate(
      event.localPosition,
    );

    widget.onChanged?.call(result, event);
    widget.onDragUpdate?.call(result, event);
  }

  /// Called when the box drag event ends.
  void onDragPanEnd(DragEndDetails event) {
    if (!isLegalGesture) return;

    controller.onDragEnd();
    widget.onDragEnd?.call(event);
  }

  void onDragPanCancel() {
    if (!isLegalGesture) return;

    controller.onDragEnd();
    widget.onDragCancel?.call();
  }

  @override
  Widget build(BuildContext context) {
    final Flip flip = controller.flip;
    final Rect rect = controller.rect;

    Widget content = Transform.scale(
      scaleX: widget.allowContentFlipping && flip.isHorizontal ? -1 : 1,
      scaleY: widget.allowContentFlipping && flip.isVertical ? -1 : 1,
      child: widget.contentBuilder(context, rect, flip),
    );

    if (widget.draggable) {
      content = GestureDetector(
        behavior: HitTestBehavior.translucent,
        onPanStart: onDragPanStart,
        onPanUpdate: onDragPanUpdate,
        onPanEnd: onDragPanEnd,
        onPanCancel: onDragPanCancel,
        child: content,
      );
    }

    return Positioned.fromRect(
      rect: rect.inflate(widget.handleAlignment.offset(widget.handleTapSize)),
      child: Stack(
        clipBehavior: Clip.none,
        fit: StackFit.expand,
        children: [
          Positioned(
            left: widget.handleAlignment.offset(widget.handleTapSize),
            top: widget.handleAlignment.offset(widget.handleTapSize),
            width: rect.width,
            height: rect.height,
            child: content,
          ),
          for (final handle
              in widget.visibleHandles.where((handle) => handle.isDiagonal))
            CornerHandleWidget(
              key: ValueKey(handle),
              handlePosition: handle,
              handleTapSize: widget.handleTapSize,
              enabled:
                  widget.resizable && widget.enabledHandles.contains(handle),
              onPanStart: (event) => onHandlePanStart(event, handle),
              onPanUpdate: (event) => onHandlePanUpdate(event, handle),
              onPanEnd: (event) => onHandlePanEnd(event, handle),
              onPanCancel: () => onHandlePanCancel(handle),
              builder: widget.cornerHandleBuilder,
            ),
          for (final handle
              in widget.visibleHandles.where((handle) => handle.isSide))
            SideHandleWidget(
              key: ValueKey(handle),
              handlePosition: handle,
              handleTapSize: widget.handleTapSize,
              enabled:
                  widget.resizable && widget.enabledHandles.contains(handle),
              onPanStart: (event) => onHandlePanStart(event, handle),
              onPanUpdate: (event) => onHandlePanUpdate(event, handle),
              onPanEnd: (event) => onHandlePanEnd(event, handle),
              onPanCancel: () => onHandlePanCancel(handle),
              builder: widget.sideHandleBuilder,
            ),
        ],
      ),
    );
  }
}

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
