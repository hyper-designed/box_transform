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

class ResizableBox extends StatefulWidget {
  final ResizableBoxController? controller;

  final BoxContentBuilder contentBuilder;
  final HandleBuilder? handleBuilder;
  final double handleGestureResponseSize;
  final double handleRenderedSize;
  final Rect box;
  final Flip flip;
  final Function(Rect rect, Flip flip) onChanged;

  const ResizableBox({
    super.key,
    required this.contentBuilder,
    this.controller,
    this.handleBuilder,
    this.handleGestureResponseSize = 24,
    this.handleRenderedSize = 12,
    required this.box,
    required this.onChanged,
    this.flip = Flip.none,
  }) : assert(handleGestureResponseSize >= handleRenderedSize);

  @override
  State<ResizableBox> createState() => _ResizableBoxState();
}

class _ResizableBoxState extends State<ResizableBox> {
  late ResizableBoxController controller =
      widget.controller ?? ResizableBoxController()
        ..box = widget.box
        ..flip = widget.flip;

  @override
  void initState() {
    super.initState();
    controller.addListener(onControllerUpdate);
  }

  @override
  void didUpdateWidget(covariant ResizableBox oldWidget) {
    super.didUpdateWidget(oldWidget);
    if (oldWidget.controller != widget.controller) {
      oldWidget.controller?.removeListener(onControllerUpdate);
      controller = widget.controller ?? ResizableBoxController()
        ..box = widget.box
        ..flip = widget.flip;
      controller.addListener(onControllerUpdate);
    }

    if (oldWidget.box != widget.box) {
      controller.box = widget.box;
    }
    if (oldWidget.flip != widget.flip) {
      controller.flip = widget.flip;
    }
  }

  void onControllerUpdate() {
    if (widget.box != controller.box || widget.flip != controller.flip) {
      if (mounted) setState(() {});
      widget.onChanged(controller.box, controller.flip);
    }
  }

  @override
  Widget build(BuildContext context) {
    final Flip flip = controller.flip;
    final Rect box = controller.box;
    return Positioned.fromRect(
      rect: box.inflate(widget.handleGestureResponseSize / 2),
      child: Stack(
        clipBehavior: Clip.none,
        fit: StackFit.expand,
        children: [
          Positioned(
            width: box.width,
            height: box.height,
            child: GestureDetector(
              behavior: HitTestBehavior.opaque,
              onPanUpdate: (event) {
                final box = controller.onDragUpdate(event, notify: false);
                widget.onChanged(box, flip);
              },
              child: widget.contentBuilder(context, box, flip),
            ),
          ),
          HandleWidget(
            handle: HandlePosition.topLeft,
            controller: controller,
            size: widget.handleRenderedSize,
            responseSize: widget.handleGestureResponseSize,
            onResize: widget.onChanged,
          ),
          HandleWidget(
            handle: HandlePosition.topRight,
            controller: controller,
            size: widget.handleRenderedSize,
            responseSize: widget.handleGestureResponseSize,
            onResize: widget.onChanged,
          ),
          HandleWidget(
            handle: HandlePosition.bottomRight,
            controller: controller,
            size: widget.handleRenderedSize,
            responseSize: widget.handleGestureResponseSize,
            onResize: widget.onChanged,
          ),
          HandleWidget(
            handle: HandlePosition.bottomLeft,
            controller: controller,
            size: widget.handleRenderedSize,
            responseSize: widget.handleGestureResponseSize,
            onResize: widget.onChanged,
          ),
        ],
      ),
    );
  }

  @override
  void dispose() {
    controller.removeListener(onControllerUpdate);
    if (widget.controller == null) controller.dispose();
    super.dispose();
  }
}

class HandleWidget extends StatelessWidget {
  final HandlePosition handle;
  final ResizableBoxController controller;
  final HandleBuilder? handleBuilder;
  final double size;
  final double responseSize;
  final Function(Rect rect, Flip flip) onResize;

  const HandleWidget({
    super.key,
    required this.handle,
    required this.controller,
    this.handleBuilder,
    required this.size,
    required this.responseSize,
    required this.onResize,
  });

  @override
  Widget build(BuildContext context) {
    final Offset handleOffset =
        getLocalOffsetForHandle(handle, controller.box.size)
            .translate(-responseSize / 2, -responseSize / 2);

    final builder = (handleBuilder ?? defaultHandleBuilder);

    return Positioned(
      left: handleOffset.dx,
      top: handleOffset.dy,
      width: responseSize,
      height: responseSize,
      child: GestureDetector(
        behavior: HitTestBehavior.opaque,
        onPanStart: controller.onResizeStart,
        onPanUpdate: (details) {
          final result = controller.onResizeUpdate(
            details,
            handle,
            notify: false,
          );
          onResize(result.newRect, controller.flip);
        },
        onPanEnd: controller.onResizeEnd,
        child: MouseRegion(
          cursor: getCursorForHandle(handle),
          child: Center(
            child: SizedBox.square(
              dimension: size,
              child: builder(context, handle),
            ),
          ),
        ),
      ),
    );
  }

  Widget defaultHandleBuilder(BuildContext context, HandlePosition handle) {
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

  Offset getLocalOffsetForHandle(HandlePosition handle, Size size) {
    switch (handle) {
      case HandlePosition.topLeft:
        return Offset.zero;
      case HandlePosition.topRight:
        return Offset(size.width, 0);
      case HandlePosition.bottomLeft:
        return Offset(0, size.height);
      case HandlePosition.bottomRight:
        return Offset(size.width, size.height);
    }
  }

  // TODO: this is unused and might not be relevant, remove?
  Offset getGlobalOffsetForHandle(HandlePosition handle, Rect box) {
    switch (handle) {
      case HandlePosition.topLeft:
        return Offset(box.left, box.top);
      case HandlePosition.topRight:
        return Offset(box.right, box.top);
      case HandlePosition.bottomLeft:
        return Offset(box.left, box.bottom);
      case HandlePosition.bottomRight:
        return Offset(box.right, box.bottom);
    }
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
