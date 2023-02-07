import 'package:flutter/material.dart';

import '../flutter_rect_resizer.dart';

typedef HandleBuilder = Widget Function(
  BuildContext context,
  HandlePosition handle,
);

typedef BoxContentBuilder = Widget Function(
  BuildContext context,
  Rect rect,
  Flip flip,
);

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
class ResizableBox extends StatefulWidget {
  /// If you need more control over the [ResizableBox] you can pass a
  /// custom [ResizableBoxController] instance through the [controller]
  /// parameter.
  ///
  /// If you do not specify one, a default [ResizableBoxController] instance
  /// will be created internally, along with its lifecycle.
  final ResizableBoxController? controller;

  /// A builder function that is used to build the content of the
  /// [ResizableBox]. This is the physical widget you wish to show resizable
  /// handles on. It's most commonly something like an image widget, but it
  /// could be anything you want to have resizable & draggable box handles on.
  final BoxContentBuilder contentBuilder;

  /// A builder function that is used to build the handles of the
  /// [ResizableBox]. If you don't specify it, the default handles will be
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
  /// the [ResizableBox] widget.
  ///
  /// This initial box will be mutated by the [ResizableBoxController] through
  /// different dragging, panning, and resizing operations.
  ///
  /// [Rect] is immutable, so a new [Rect] instance will be created every time
  /// the [ResizableBoxController] mutates the box. You can acquire your
  /// updated box through the [onChanged] callback or through an externally
  /// provided [ResizableBoxController] instance.
  final Rect box;

  /// The initial flip that will be used to set the initial flip of the
  /// [ResizableBox] widget. Normally, flipping is done by the user through
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

  /// A callback that is called every time the [ResizableBox] is updated.
  /// This is called every time the [ResizableBoxController] mutates the box
  /// or the flip.
  final Function(Rect rect, Flip flip) onChanged;

  /// Creates a [ResizableBox] widget.
  const ResizableBox({
    super.key,
    required this.contentBuilder,
    required this.onChanged,
    this.controller,
    this.handleBuilder = _defaultHandleBuilder,
    this.handleGestureResponseDiameter = 24,
    this.handleRenderedDiameter = 12,
    // raw
    Rect? box,
    Flip? flip,
    Rect? clampingBox,
  })  : assert(
          handleGestureResponseDiameter >= handleRenderedDiameter,
          'The handle gesture response diameter must be '
          'greater than or equal to the handle rendered diameter.',
        ),
        assert(
            controller == null ||
                (box == null && flip == null && clampingBox == null),
            'You can either provide a controller or a box, flip, and clamping box, but not both.'),
        box = box ?? Rect.zero,
        flip = flip ?? Flip.none,
        clampingBox = clampingBox ?? Rect.largest;

  @override
  State<ResizableBox> createState() => _ResizableBoxState();
}

class _ResizableBoxState extends State<ResizableBox> {
  late ResizableBoxController controller;

  @override
  void initState() {
    super.initState();

    if (widget.controller != null) {
      controller = widget.controller!;
      // We only want to listen to the controller if it is provided externally.
      controller.addListener(onControllerUpdate);
    } else {
      // If it is provided internally, we should not listen to it.
      // TODO[@saad]: does this make sense? If not, move the controller out of the if statement.
      controller = ResizableBoxController()
        ..box = widget.box
        ..flip = widget.flip;
      // TODO[@saad]: add clamping box.
    }
  }

  @override
  void didUpdateWidget(covariant ResizableBox oldWidget) {
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
      controller = ResizableBoxController()
        ..box = widget.box
        ..flip = widget.flip;
      // TODO[@saad]: add clamping box.
      // TODO[@saad]: should we add a listener here?
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
    // TODO[@saad]: account for clamping box and update box if required.
  }

  /// Called when the controller is updated.
  void onControllerUpdate() {
    if (widget.box != controller.box || widget.flip != controller.flip) {
      if (mounted) setState(() {});
    }
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
            child: GestureDetector(
              behavior: HitTestBehavior.opaque,
              onPanStart: (event) =>
                  controller.onDragStart(event.localPosition),
              onPanUpdate: (event) {
                final UIMoveResult result = controller.onDragUpdate(
                  event.localPosition,
                  clampingBox: widget.clampingBox,
                  notify: false,
                );
                widget.onChanged(result.newRect, flip);
              },
              onPanEnd: (event) => controller.onDragEnd(),
              child: widget.contentBuilder(context, box, flip),
            ),
          ),
          HandleWidget(
            handlePosition: HandlePosition.topLeft,
            renderedDiameter: widget.handleRenderedDiameter,
            gestureResponseDiameter: widget.handleGestureResponseDiameter,
            builder: widget.handleBuilder,
            onPanStart: onHandlePanStart,
            onPanUpdate: onHandlePanUpdate,
            onPanEnd: onHandlePanEnd,
          ),
          HandleWidget(
            handlePosition: HandlePosition.topRight,
            renderedDiameter: widget.handleRenderedDiameter,
            gestureResponseDiameter: widget.handleGestureResponseDiameter,
            builder: widget.handleBuilder,
            onPanStart: onHandlePanStart,
            onPanUpdate: onHandlePanUpdate,
            onPanEnd: onHandlePanEnd,
          ),
          HandleWidget(
            handlePosition: HandlePosition.bottomRight,
            renderedDiameter: widget.handleRenderedDiameter,
            gestureResponseDiameter: widget.handleGestureResponseDiameter,
            builder: widget.handleBuilder,
            onPanStart: onHandlePanStart,
            onPanUpdate: onHandlePanUpdate,
            onPanEnd: onHandlePanEnd,
          ),
          HandleWidget(
            handlePosition: HandlePosition.bottomLeft,
            renderedDiameter: widget.handleRenderedDiameter,
            gestureResponseDiameter: widget.handleGestureResponseDiameter,
            builder: widget.handleBuilder,
            onPanStart: onHandlePanStart,
            onPanUpdate: onHandlePanUpdate,
            onPanEnd: onHandlePanEnd,
          ),
        ],
      ),
    );
  }

  void onHandlePanStart(DragStartDetails details) {
    controller.onResizeStart(details.localPosition);
  }

  void onHandlePanEnd(DragEndDetails details) {
    controller.onResizeEnd();
  }

  void onHandlePanUpdate(
      DragUpdateDetails details, HandlePosition handlePosition) {
    final UIResizeResult result = controller.onResizeUpdate(
      details.localPosition,
      handlePosition,
      clampingBox: widget.clampingBox,
      notify: false,
    );
    widget.onChanged(result.newRect, controller.flip);
  }

  @override
  void dispose() {
    controller.removeListener(onControllerUpdate);
    if (widget.controller == null) controller.dispose();
    super.dispose();
  }
}

class HandleWidget extends StatelessWidget {
  /// The position of the handle.
  final HandlePosition handlePosition;

  /// The builder that is used to build the handle widget.
  final HandleBuilder builder;

  /// The diameter of the handle that is rendered.
  final double renderedDiameter;

  /// The diameter of the handle that is used for gesture detection.
  final double gestureResponseDiameter;

  final GestureDragStartCallback onPanStart;

  final void Function(DragUpdateDetails details, HandlePosition handle)
      onPanUpdate;

  final GestureDragEndCallback onPanEnd;

  const HandleWidget({
    super.key,
    required this.handlePosition,
    required this.renderedDiameter,
    required this.gestureResponseDiameter,
    required this.builder,
    required this.onPanStart,
    required this.onPanUpdate,
    required this.onPanEnd,
  });

  @override
  Widget build(BuildContext context) {
    return Positioned(
      left: handlePosition.isLeft ? 0 : null,
      right: handlePosition.isRight ? 0 : null,
      top: handlePosition.isTop ? 0 : null,
      bottom: handlePosition.isBottom ? 0 : null,
      width: gestureResponseDiameter,
      height: gestureResponseDiameter,
      child: GestureDetector(
        behavior: HitTestBehavior.opaque,
        onPanStart: onPanStart,
        onPanUpdate: (details) => onPanUpdate(details, handlePosition),
        onPanEnd: onPanEnd,
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
