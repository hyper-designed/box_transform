import 'package:flutter/material.dart';

import '../flutter_rect_resizer.dart';
import 'resizable_box_controller.dart';

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
  final FocusScopeNode? focusNode;

  const ResizableBox({
    super.key,
    required this.contentBuilder,
    this.controller,
    this.handleBuilder,
    this.handleGestureResponseSize = 24,
    this.handleRenderedSize = 12,
    this.focusNode,
  });

  @override
  State<ResizableBox> createState() => _ResizableBoxState();
}

class _ResizableBoxState extends State<ResizableBox> {
  late final ResizableBoxController controller =
      widget.controller ?? ResizableBoxController();

  @override
  void dispose() {
    if (widget.controller == null) controller.dispose();
    super.dispose();
  }

  Widget defaultHandleBuilder(BuildContext context, HandlePosition handle) {
    final Color handleColor = controller.hasFocus
        ? Theme.of(context).colorScheme.primary
        : Theme.of(context).disabledColor;
    return Container(
      decoration: BoxDecoration(
        color: Theme.of(context).scaffoldBackgroundColor,
        shape: BoxShape.circle,
        border: Border.all(
          color: handleColor,
          width: 1.5,
        ),
      ),
    );
  }

  Widget buildHandle(HandlePosition handle) {
    final Rect box = controller.box;
    final double left;
    final double top;

    switch (handle) {
      case HandlePosition.topLeft:
        left = box.left;
        top = box.top;
        break;
      case HandlePosition.topRight:
        left = box.right;
        top = box.top;
        break;
      case HandlePosition.bottomLeft:
        left = box.left;
        top = box.bottom;
        break;
      case HandlePosition.bottomRight:
        left = box.right;
        top = box.bottom;
        break;
    }

    return Positioned(
      left: left - widget.handleGestureResponseSize / 2,
      top: top - widget.handleGestureResponseSize / 2,
      width: widget.handleGestureResponseSize,
      height: widget.handleGestureResponseSize,
      child: GestureDetector(
        onPanStart: controller.onResizeStart,
        onPanUpdate: (details) => controller.onResizeUpdate(
          details,
          HandlePosition.topRight,
        ),
        onPanEnd: controller.onResizeEnd,
        child: MouseRegion(
          cursor: SystemMouseCursors.resizeUpRight,
          child: Container(
            width: widget.handleRenderedSize,
            height: widget.handleRenderedSize,
            alignment: Alignment.center,
            child:
                widget.handleBuilder?.call(context, HandlePosition.topRight) ??
                    defaultHandleBuilder(context, HandlePosition.topRight),
          ),
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final Flip flip = controller.flip;
    final Rect box = controller.box;
    // TODO: NOT SURE ABOUT FOCUS SCOPE STATE HANDLING.
    return FocusScope(
      node: controller.focusNode,
      autofocus: true,
      onFocusChange: controller.updateHasFocus,
      onKey: controller.onKeyEvent,
      child: Stack(
        children: [
          Positioned.fromRect(
            rect: box,
            child: GestureDetector(
              behavior: HitTestBehavior.opaque,
              onPanUpdate: controller.onDragUpdate,
              child: Transform.scale(
                scaleX: flip.isHorizontal ? -1 : 1,
                scaleY: flip.isVertical ? -1 : 1,
                child: widget.contentBuilder(context, box, flip),
              ),
            ),
          ),
          buildHandle(HandlePosition.topLeft),
          buildHandle(HandlePosition.bottomRight),
          buildHandle(HandlePosition.topRight),
          buildHandle(HandlePosition.bottomLeft),
        ],
      ),
    );
  }
}
