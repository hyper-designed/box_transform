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
typedef BoxContentBuilder = Widget Function(
  BuildContext context,
  Rect rect,
  Flip flip,
);

/// A callback that is called when the box is moved or resized.
/// The [rect] is the current position and size of the box.
/// The [flip] is the current flip state of the box.
typedef OnBoxChanged = void Function(Rect rect, Flip flip);

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

/// A default implementation of the [HandleBuilder] callback.
Widget _defaultHandleBuilder(BuildContext context, HandlePosition handle) {
  return Container(
    decoration: BoxDecoration(
      color: Theme.of(context).scaffoldBackgroundColor,
      shape: BoxShape.circle,
      border: Border.all(
        color: Theme.of(context).colorScheme.primary,
        width: 1.5,
      ),
    ),
  );
}

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
  final BoxContentBuilder contentBuilder;

  /// A builder function that is used to build the handles of the
  /// [TransformableBox]. If you don't specify it, the default handles will be
  /// used.
  ///
  /// Note that this will build for all four corners of the rectangle.
  final HandleBuilder handleBuilder;

  /// The radius of the gesture response area of the handles. If you don't
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
  final double handleGestureResponseDiameter;

  /// The size of the handles that will be rendered on the screen. If you don't
  /// specify it, the default value will be used.
  ///
  /// The default value is 12 pixels in diameter.
  final double handleRenderedDiameter;

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
  final Rect box;

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

  /// A box that will contain the [box] inside of itself, forcing [box] to
  /// be clamped inside of this [clampingBox].
  final Rect clampingBox;

  /// A set of constraints that will be applied to the [box] when it is
  /// resized by the [TransformableBoxController].
  final BoxConstraints constraints;

  /// A callback that is called every time the [TransformableBox] is updated.
  /// This is called every time the [TransformableBoxController] mutates the box
  /// or the flip.
  final OnBoxChanged? onChanged;

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

  /// Creates a [TransformableBox] widget.
  const TransformableBox({
    super.key,
    required this.contentBuilder,
    this.onChanged,
    this.controller,
    this.handleBuilder = _defaultHandleBuilder,
    this.handleGestureResponseDiameter = 24,
    this.handleRenderedDiameter = 12,
    // raw
    Rect? box,
    Flip? flip,
    Rect? clampingBox,
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
  })  : assert(
          handleGestureResponseDiameter >= handleRenderedDiameter,
          'The handle gesture response diameter must be '
          'greater than or equal to the handle rendered diameter.',
        ),
        assert(
          controller == null ||
              (box == null &&
                  flip == null &&
                  clampingBox == null &&
                  constraints == null &&
                  resolveResizeModeCallback == null),
          'You can either provide a [controller] OR a [box], [flip], '
          '[clampingBox], [constraints], and [resolveResizeModeCallback]. '
          'You cannot use any of those properties when providing a controller and'
          'vice versa.',
        ),
        box = box ?? Rect.zero,
        flip = flip ?? Flip.none,
        clampingBox = clampingBox ?? Rect.largest,
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
        ..box = widget.box
        ..flip = widget.flip
        ..clampingBox = widget.clampingBox
        ..constraints = widget.constraints
        ..resolveResizeModeCallback = widget.resolveResizeModeCallback;
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
        ..box = widget.box
        ..flip = widget.flip
        ..clampingBox = widget.clampingBox
        ..constraints = widget.constraints
        ..resolveResizeModeCallback = widget.resolveResizeModeCallback;
    }

    // Return if the controller is external.
    if (widget.controller != null) return;

    // Below code should only be executed if the controller is internal.

    if (oldWidget.box != widget.box) {
      controller.box = widget.box;
    }
    if (oldWidget.flip != widget.flip) {
      controller.flip = widget.flip;
    }
    if (oldWidget.resolveResizeModeCallback !=
        widget.resolveResizeModeCallback) {
      controller.resolveResizeModeCallback = widget.resolveResizeModeCallback;
    }
    if (oldWidget.clampingBox != widget.clampingBox) {
      controller.clampingBox = widget.clampingBox;
      controller.recalculateBox(notify: false);
    }

    if (oldWidget.constraints != widget.constraints) {
      controller.constraints = widget.constraints;
      controller.recalculateBox(notify: false);
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
    if (widget.box != controller.box || widget.flip != controller.flip) {
      if (mounted) setState(() {});
    }
  }

  /// Called when the handle drag starts.
  void onHandlePanStart(Offset localPosition) {
    controller.onResizeStart(localPosition);
  }

  /// Called when the handle drag updates.
  void onHandlePanUpdate(Offset localPosition, HandlePosition handlePosition) {
    final UIResizeResult result = controller.onResizeUpdate(
      localPosition,
      handlePosition,
      notify: false,
    );

    widget.onChanged?.call(result.newRect, controller.flip);
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
    final Rect box = controller.box;
    return Positioned.fromRect(
      rect: box.inflate(widget.handleGestureResponseDiameter / 2),
      child: Stack(
        clipBehavior: Clip.none,
        fit: StackFit.expand,
        children: [
          Positioned(
            left: widget.handleGestureResponseDiameter / 2,
            top: widget.handleGestureResponseDiameter / 2,
            width: box.width,
            height: box.height,
            child: Listener(
              behavior: HitTestBehavior.opaque,
              onPointerDown: (event) =>
                  controller.onDragStart(event.localPosition),
              onPointerMove: (event) {
                final UIMoveResult result = controller.onDragUpdate(
                  event.localPosition,
                  notify: false,
                );
                widget.onChanged?.call(result.newRect, flip);
              },
              onPointerUp: (event) => controller.onDragEnd(),
              onPointerCancel: (event) => controller.onDragEnd(),
              child: widget.contentBuilder(context, box, flip),
            ),
          ),
          HandleWidget(
            handlePosition: HandlePosition.topLeft,
            renderedDiameter: widget.handleRenderedDiameter,
            gestureResponseDiameter: widget.handleGestureResponseDiameter,
            builder: widget.handleBuilder,
            onPointerDown: onHandlePanStart,
            onPointerUpdate: onHandlePanUpdate,
            onPointerUp: onHandlePanEnd,
          ),
          HandleWidget(
            handlePosition: HandlePosition.topRight,
            renderedDiameter: widget.handleRenderedDiameter,
            gestureResponseDiameter: widget.handleGestureResponseDiameter,
            builder: widget.handleBuilder,
            onPointerDown: onHandlePanStart,
            onPointerUpdate: onHandlePanUpdate,
            onPointerUp: onHandlePanEnd,
          ),
          HandleWidget(
            handlePosition: HandlePosition.bottomRight,
            renderedDiameter: widget.handleRenderedDiameter,
            gestureResponseDiameter: widget.handleGestureResponseDiameter,
            builder: widget.handleBuilder,
            onPointerDown: onHandlePanStart,
            onPointerUpdate: onHandlePanUpdate,
            onPointerUp: onHandlePanEnd,
          ),
          HandleWidget(
            handlePosition: HandlePosition.bottomLeft,
            renderedDiameter: widget.handleRenderedDiameter,
            gestureResponseDiameter: widget.handleGestureResponseDiameter,
            builder: widget.handleBuilder,
            onPointerDown: onHandlePanStart,
            onPointerUpdate: onHandlePanUpdate,
            onPointerUp: onHandlePanEnd,
          ),
        ],
      ),
    );
  }
}

typedef PointerDownCallback = void Function(Offset localPosition);
typedef PointerUpdateCallback = void Function(
  Offset localPosition,
  HandlePosition handlePosition,
);
typedef PointerUpCallback = VoidCallback;

/// Creates a new handle widget, with its appropriate gesture splash zone.
class HandleWidget extends StatelessWidget {
  /// The position of the handle.
  final HandlePosition handlePosition;

  /// The builder that is used to build the handle widget.
  final HandleBuilder builder;

  /// The diameter of the handle that is rendered.
  final double renderedDiameter;

  /// The diameter of the handle that is used for gesture detection.
  final double gestureResponseDiameter;

  /// Called when the handle dragging starts.
  final PointerDownCallback onPointerDown;

  /// Called when the handle dragging is updated.
  final PointerUpdateCallback onPointerUpdate;

  /// Called when the handle dragging ends.
  final PointerUpCallback onPointerUp;

  /// Creates a new handle widget.
  const HandleWidget({
    super.key,
    required this.handlePosition,
    required this.renderedDiameter,
    required this.gestureResponseDiameter,
    required this.builder,
    required this.onPointerDown,
    required this.onPointerUpdate,
    required this.onPointerUp,
  });

  @override
  Widget build(BuildContext context) {
    return Positioned(
      left: handlePosition.influencesLeft ? 0 : null,
      right: handlePosition.influencesRight ? 0 : null,
      top: handlePosition.influencesTop ? 0 : null,
      bottom: handlePosition.influencesBottom ? 0 : null,
      width: gestureResponseDiameter,
      height: gestureResponseDiameter,
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
          child: Center(
            child: SizedBox.square(
              dimension: renderedDiameter,
              child: builder(context, handlePosition),
            ),
          ),
        ),
      ),
    );
  }

  MouseCursor getCursorForHandle(HandlePosition handle) {
    switch (handle) {
      case HandlePosition.topLeft:
      case HandlePosition.bottomRight:
        return SystemMouseCursors.resizeUpLeftDownRight;
      case HandlePosition.topRight:
      case HandlePosition.bottomLeft:
        return SystemMouseCursors.resizeUpRightDownLeft;
    }
  }
}
