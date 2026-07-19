import 'dart:math' as math;

import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';

import '../flutter_box_transform.dart';
import 'rotated_hit_gate.dart';

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

  /// A builder function that is used to build the visible top rotation handle.
  /// Only used when [rotatable] is true and [rotationHandleMode] includes
  /// [RotationHandleMode.topHandle].
  final RotationHandleBuilder rotationHandleBuilder;

  /// Optional override for the [MouseCursor] shown over each handle's gesture
  /// zone. Receives the [HandlePosition] and a [HandleCursorKind] indicating
  /// the resize zone vs. the rotation ring (the latter only on corners when
  /// [rotatable] is true).
  ///
  /// This applies to the handle's gesture zones, not to pixels painted by
  /// [cornerHandleBuilder] or [sideHandleBuilder] — a custom builder that
  /// wraps its output in its own [MouseRegion] will win on its own footprint.
  ///
  /// Return `null` for any case to fall back to the package defaults — the
  /// appropriate diagonal/cardinal `SystemMouseCursors.resize*` for resize
  /// zones, and the diagonal resize cursor for rotation rings (Flutter has
  /// no native rotation cursor; pair with the
  /// [`custom_mouse_cursor`](https://pub.dev/packages/custom_mouse_cursor)
  /// package if you want to ship a real rotate glyph).
  final HandleCursorResolver? cursorResolver;

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

  /// Size of the rotation gesture capture ring surrounding a corner handle.
  /// Must be >= [handleTapSize]. Only used when [rotatable] is true. Default
  /// 64 pixels.
  final double rotationHandleGestureSize;

  /// Whether corner handles should capture rotation gestures in an outer
  /// ring around the resize zone. Default false.
  final bool rotatable;

  /// Controls where rotation gestures are exposed when [rotatable] is true.
  final RotationHandleMode rotationHandleMode;

  /// Distance from the box's visual top edge to the center of the top rotation
  /// handle. Only used when [rotationHandleMode] includes
  /// [RotationHandleMode.topHandle]. Default 40 pixels.
  final double rotationHandleOffset;

  /// Whether to paint a connector line between the top edge and the top
  /// rotation handle. Only used when [rotationHandleMode] includes
  /// [RotationHandleMode.topHandle]. Default true.
  final bool showRotationHandleLine;

  /// The current rotation angle (radians) of the box around its center.
  /// Ignored if a [controller] is provided.
  final double rotation;

  /// Controls whether size constraints and clamping apply to the unrotated
  /// box or its rendered bounding rect. Ignored if a [controller] is provided.
  final BindingStrategy bindingStrategy;

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

  /// The kind of devices that are allowed to be recognized for drag events.
  ///
  /// By default, events from all device types will be recognized for drag events.
  final Set<PointerDeviceKind> supportedDragDevices;

  /// The kind of devices that are allowed to be recognized for resize events.
  ///
  /// By default, events from all device types will be recognized for resize events.
  final Set<PointerDeviceKind> supportedResizeDevices;

  /// The kind of devices that are allowed to be recognized for rotation events.
  ///
  /// Defaults to [supportedResizeDevices].
  final Set<PointerDeviceKind> supportedRotationDevices;

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

  /// A callback that is called every time the [TransformableBox] is tapped.
  final VoidCallback? onTap;

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

  /// Fires when a rotation gesture begins on a corner handle.
  final RectRotateStart? onRotationStart;

  /// Fires during a rotation gesture.
  final RectRotateUpdateEvent? onRotationUpdate;

  /// Fires when a rotation gesture ends.
  final RectRotateEnd? onRotationEnd;

  /// Fires when a rotation gesture is cancelled.
  final RectRotateCancel? onRotationCancel;

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

  /// Whether to paint the handle's bounds for debugging purposes.
  final bool debugPaintHandleBounds;

  /// When true, paints a red border around the rotated axis-aligned bounding
  /// box of the box. Useful for visualizing the rendered footprint at non-zero
  /// [rotation]. Only active in debug mode.
  final bool debugShowBoundingRect;

  /// When true, paints a green border around the unrotated rect. Useful for
  /// visualizing the logical (pre-rotation) box. Only active in debug mode.
  final bool debugShowUnrotatedRect;

  /// When true, renders red+blue arrows during a rotation gesture: from box
  /// center to the initial pointer position, and to the current pointer
  /// position. Only active in debug mode.
  final bool debugShowRotationArrows;

  /// Creates a [TransformableBox] widget.
  const TransformableBox({
    super.key,
    required this.contentBuilder,
    this.controller,
    this.cornerHandleBuilder = HandleBuilders.defaultCorner,
    this.sideHandleBuilder = HandleBuilders.defaultSide,
    this.rotationHandleBuilder = HandleBuilders.defaultRotation,
    this.cursorResolver,
    this.handleTapSize = 24,
    this.rotationHandleGestureSize = 64,
    this.rotationHandleMode = RotationHandleMode.cornerRing,
    this.rotationHandleOffset = 40,
    this.showRotationHandleLine = true,
    this.allowContentFlipping = true,
    this.handleAlignment = HandleAlignment.center,
    this.enabledHandles = const {...HandlePosition.values},
    this.visibleHandles = const {...HandlePosition.values},
    this.supportedDragDevices = const {...PointerDeviceKind.values},
    this.supportedResizeDevices = const {...PointerDeviceKind.values},
    Set<PointerDeviceKind>? supportedRotationDevices,

    // Raw values.
    Rect? rect,
    Flip? flip,
    Rect? clampingRect,
    BoxConstraints? constraints,
    ValueGetter<ResizeMode>? resizeModeResolver,
    double? rotation,
    this.bindingStrategy = BindingStrategy.boundingBox,

    // Additional controls.
    this.resizable = true,
    this.draggable = true,
    this.rotatable = false,
    this.allowFlippingWhileResizing = true,

    // Tap events
    this.onTap,

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

    // Rotation Events.
    this.onRotationStart,
    this.onRotationUpdate,
    this.onRotationEnd,
    this.onRotationCancel,

    // Terminal update events.
    this.onMinWidthReached,
    this.onMaxWidthReached,
    this.onMinHeightReached,
    this.onMaxHeightReached,
    this.onTerminalWidthReached,
    this.onTerminalHeightReached,
    this.onTerminalSizeReached,
    this.debugPaintHandleBounds = false,
    this.debugShowBoundingRect = false,
    this.debugShowUnrotatedRect = false,
    this.debugShowRotationArrows = false,
  })  : assert(
          (controller == null) ||
              ((rect == null) &&
                  (flip == null) &&
                  (clampingRect == null) &&
                  (constraints == null) &&
                  (resizeModeResolver == null) &&
                  (rotation == null)),
          'If a controller is provided, the raw values should not be provided.',
        ),
        assert(rotationHandleGestureSize >= handleTapSize,
            'rotationHandleGestureSize must be >= handleTapSize.'),
        assert(rotationHandleOffset >= 0,
            'rotationHandleOffset must be non-negative.'),
        supportedRotationDevices =
            supportedRotationDevices ?? supportedResizeDevices,
        rect = rect ?? Rect.zero,
        flip = flip ?? Flip.none,
        clampingRect = clampingRect ?? Rect.largest,
        constraints = constraints ?? const BoxConstraints.expand(),
        rotation = rotation ?? 0.0,
        resizeModeResolver = resizeModeResolver ??
            TransformableBoxController.defaultResizeModeResolver;

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

enum _PrimaryGestureOperation {
  resize,
  drag,
  rotate;

  bool get isDragging => this == _PrimaryGestureOperation.drag;

  bool get isResizing => this == _PrimaryGestureOperation.resize;

  bool get isRotating => this == _PrimaryGestureOperation.rotate;
}

class _TransformableBoxState extends State<TransformableBox> {
  late TransformableBoxController controller;

  _PrimaryGestureOperation? primaryGestureOperation;

  HandlePosition? lastHandle;

  /// Current pointer position during a rotation gesture, in this widget's
  /// local coordinate space. Used by the rotation-arrows debug overlay.
  Offset? _rotationArrowPointer;

  /// Offset to add to `event.globalPosition` to yield a world/parent-frame
  /// coordinate. Captured at gesture start so subsequent updates are immune
  /// to the widget moving during the gesture.
  ///
  /// Flutter's `event.localPosition` is transformed using the hit-test-time
  /// transform; once the widget moves mid-gesture, `localPosition` goes
  /// stale. `globalPosition` stays accurate in screen coordinates, and a
  /// captured offset gives a stable global→world conversion.
  Offset? _gestureGlobalToWorldOffset;

  bool get isDragging => primaryGestureOperation?.isDragging == true;

  bool get isResizing => primaryGestureOperation?.isResizing == true;

  bool get isRotating => primaryGestureOperation?.isRotating == true;

  bool get isGestureActive => isDragging || isResizing || isRotating;

  bool mismatchedHandle(HandlePosition handle) =>
      lastHandle != null && lastHandle != handle;

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
        rotation: widget.rotation,
        bindingStrategy: widget.bindingStrategy,
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
        rotation: widget.rotation,
        bindingStrategy: widget.bindingStrategy,
      );
    }

    // Return if the controller is external.
    if (widget.controller != null) return;

    // Below code should only be executed if the controller is internal.
    bool shouldRecalculatePosition = false;
    bool shouldRecalculateSize = false;

    // Two distinct cases:
    //
    //  * Real rect change (caller supplied a new widget.rect): needs a full
    //    recalc to honour constraints + clamping.
    //  * Drift mismatch (widget.rect unchanged across rebuilds, but
    //    controller.rect has drifted): happens when an external rebuild
    //    trigger (parent setState, new clampingRect / constraints, etc.)
    //    fires while the controller carries a translation that the parent
    //    hasn't mirrored back via onChanged. Snapping controller.rect back
    //    to widget.rect without re-applying position recalc produces a
    //    visible snap-back — e.g. at clamp saturation, when the clamp
    //    branch doesn't fire so nothing re-translates the box. We push
    //    widget.rect in (restoring caller source-of-truth) and then let
    //    the end-of-method recalculatePosition re-apply any clamp-driven
    //    translation. Size is NOT recalculated on drift-only — that would
    //    reintroduce V7's clamp-induced scale shrink.
    final bool rectChangedByCaller = oldWidget.rect != widget.rect;
    final bool rectMismatch = widget.rect != controller.rect;
    if (rectChangedByCaller || rectMismatch) {
      controller.setRect(widget.rect, notify: false, recalculate: false);
      if (rectChangedByCaller) {
        shouldRecalculatePosition = true;
        shouldRecalculateSize = true;
      } else {
        // Drift-only: re-apply clamp translation, but do not resize.
        shouldRecalculatePosition = true;
      }
    }

    if (oldWidget.flip != widget.flip || widget.flip != controller.flip) {
      controller.setFlip(widget.flip, notify: false);
    }

    if (oldWidget.resizeModeResolver != widget.resizeModeResolver ||
        widget.resizeModeResolver != controller.resizeModeResolver) {
      controller.setResizeModeResolver(
        widget.resizeModeResolver,
        notify: false,
      );
    }

    if (oldWidget.clampingRect != widget.clampingRect ||
        widget.clampingRect != controller.clampingRect) {
      // `recalculate: false` + position-only reconciliation. A clamp change
      // should translate the box to stay inside the clamp, not resize it.
      // setClampingRect's internal recalculate() runs recalculateSize via a
      // zero-delta scale resize; for a rotated box against a tight clamp
      // that picks the largest (w, h) that fits the new clamp, which is
      // strictly smaller than the current box by a sliver. Repeated clamp
      // repumps (e.g. parent drags the clamp in tiny ticks) accumulate the
      // slivers into a visible shrink + off-edge flick.
      controller.setClampingRect(widget.clampingRect,
          notify: false, recalculate: false);
      shouldRecalculatePosition = true;
      // Intentionally do NOT set shouldRecalculateSize.
    }

    if (oldWidget.constraints != widget.constraints ||
        widget.constraints != controller.constraints) {
      controller.setConstraints(widget.constraints, notify: false);
      shouldRecalculateSize = true;
    }

    if (oldWidget.allowFlippingWhileResizing !=
            widget.allowFlippingWhileResizing ||
        widget.allowFlippingWhileResizing !=
            controller.allowFlippingWhileResizing) {
      controller.setAllowFlippingWhileResizing(
        widget.allowFlippingWhileResizing,
        notify: false,
      );
    }

    if (oldWidget.rotation != widget.rotation ||
        widget.rotation != controller.rotation) {
      controller.setRotation(widget.rotation, notify: false);
    }

    if (oldWidget.bindingStrategy != widget.bindingStrategy ||
        widget.bindingStrategy != controller.bindingStrategy) {
      controller.setBindingStrategy(widget.bindingStrategy, notify: false);
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
  ///
  /// Trigger a rebuild for any observable controller state that the widget
  /// renders: rect, flip, rotation, or bindingStrategy.
  void onControllerUpdate() {
    if (widget.rect != controller.rect ||
        widget.flip != controller.flip ||
        widget.rotation != controller.rotation ||
        widget.bindingStrategy != controller.bindingStrategy) {
      if (mounted) setState(() {});
    }
  }

  /// Called when the handle drag starts.
  ///
  /// Any new gesture start forcibly clears prior state (defensive guard
  /// against stale `primaryGestureOperation` from a previous gesture whose
  /// end/cancel event was dropped).
  ///
  /// [handleTopLeftWorld] is the parent-frame offset of the handle widget's
  /// top-left. It's combined with [event.localPosition] to produce the
  /// starting world-frame pointer position, and with [event.globalPosition]
  /// to capture a stable global→world offset used by subsequent updates.
  void onHandlePanStart(
    DragStartDetails event,
    HandlePosition handle,
    Offset handleTopLeftWorld, {
    double rotation = 0.0,
    Offset? rotationPivotWorld,
    Size? widgetSize,
  }) {
    primaryGestureOperation = _PrimaryGestureOperation.resize;
    lastHandle = handle;

    final Offset worldPos = _eventToWorld(
      event.localPosition,
      handleTopLeftWorld: handleTopLeftWorld,
      rotation: rotation,
      rotationPivotWorld: rotationPivotWorld,
      widgetSize: widgetSize,
    );
    _gestureGlobalToWorldOffset = worldPos - event.globalPosition;
    controller.onResizeStart(worldPos);
    widget.onResizeStart?.call(handle, event);
  }

  /// Converts a gesture event's local-frame position to world coords.
  ///
  /// For axis-aligned handles (corners and side handles when rotation == 0)
  /// this is a translation: `worldPos = handleTopLeftWorld + localPos`.
  ///
  /// For side handles wrapped in `Transform.rotate(rotation, alignment:
  /// center)`, the gesture's local frame is the strip's pre-rotation
  /// rectangle. We undo the Transform by rotating the offset-from-center
  /// around the strip's world center.
  Offset _eventToWorld(
    Offset localPos, {
    required Offset handleTopLeftWorld,
    required double rotation,
    required Offset? rotationPivotWorld,
    required Size? widgetSize,
  }) {
    if (rotation == 0.0 || widgetSize == null || rotationPivotWorld == null) {
      return handleTopLeftWorld + localPos;
    }
    final Offset localCenter = Offset(
      widgetSize.width / 2,
      widgetSize.height / 2,
    );
    final Offset off = localPos - localCenter;
    final double c = math.cos(rotation);
    final double s = math.sin(rotation);
    final Offset rotated =
        Offset(off.dx * c - off.dy * s, off.dx * s + off.dy * c);
    return rotationPivotWorld + rotated;
  }

  /// Called when the handle drag updates.
  void onHandlePanUpdate(
    DragUpdateDetails event,
    HandlePosition handle,
    Offset handleTopLeftWorld,
  ) {
    if (!isResizing || mismatchedHandle(handle)) return;

    final Offset worldPos =
        event.globalPosition + (_gestureGlobalToWorldOffset ?? Offset.zero);
    final UIResizeResult result = controller.onResizeUpdate(
      worldPos,
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
    if (!isResizing || mismatchedHandle(handle)) return;

    primaryGestureOperation = null;
    lastHandle = null;

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
    if (!isResizing || mismatchedHandle(handle)) return;

    primaryGestureOperation = null;
    lastHandle = null;

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

  /// Called when a rotation gesture starts on a handle's outer ring.
  /// Force-clears any stale gesture state.
  void onHandleRotateStart(
    DragStartDetails event,
    HandlePosition handle,
    Offset handleTopLeftWorld,
  ) {
    primaryGestureOperation = _PrimaryGestureOperation.rotate;
    lastHandle = handle;
    final Offset worldPos = handleTopLeftWorld + event.localPosition;
    _gestureGlobalToWorldOffset = worldPos - event.globalPosition;
    controller.onRotateStart(worldPos);
    widget.onRotationStart?.call(handle, event);
  }

  /// Called during a rotation gesture.
  void onHandleRotateUpdate(
    DragUpdateDetails event,
    HandlePosition handle,
    Offset handleTopLeftWorld,
  ) {
    if (!isRotating || mismatchedHandle(handle)) return;
    final Offset worldPos =
        event.globalPosition + (_gestureGlobalToWorldOffset ?? Offset.zero);
    final result = controller.onRotateUpdate(worldPos, handle);
    if (widget.debugShowRotationArrows) {
      setState(() => _rotationArrowPointer = worldPos);
    }
    widget.onRotationUpdate?.call(result, event);
  }

  /// Called when a rotation gesture ends.
  void onHandleRotateEnd(DragEndDetails event, HandlePosition handle) {
    if (!isRotating || mismatchedHandle(handle)) return;
    primaryGestureOperation = null;
    lastHandle = null;
    controller.onRotateEnd();
    if (_rotationArrowPointer != null) {
      setState(() => _rotationArrowPointer = null);
    }
    widget.onRotationEnd?.call(handle, event);
  }

  /// Called when a rotation gesture is cancelled.
  void onHandleRotateCancel(HandlePosition handle) {
    if (!isRotating || mismatchedHandle(handle)) return;
    primaryGestureOperation = null;
    lastHandle = null;
    controller.onRotateCancel();
    if (_rotationArrowPointer != null) {
      setState(() => _rotationArrowPointer = null);
    }
    widget.onRotationCancel?.call(handle);
  }

  /// Called when the box is tapped.
  void onTap() {
    if (isGestureActive) return;

    widget.onTap?.call();
  }

  /// Called when the box drag event starts.
  ///
  /// [dragTopLeftWorld] is the parent-frame top-left of the drag hit region.
  /// Combined with [event.localPosition] to seed the world pointer, and with
  /// [event.globalPosition] to capture the stable global→world offset.
  void onDragPanStart(DragStartDetails event, Offset dragTopLeftWorld) {
    primaryGestureOperation = _PrimaryGestureOperation.drag;
    lastHandle = HandlePosition.none;

    final Offset worldPos = dragTopLeftWorld + event.localPosition;
    _gestureGlobalToWorldOffset = worldPos - event.globalPosition;
    controller.onDragStart(worldPos);
    widget.onDragStart?.call(event);
  }

  /// Called when the box drag event updates.
  void onDragPanUpdate(DragUpdateDetails event, Offset dragTopLeftWorld) {
    if (!isDragging) return;

    final Offset worldPos =
        event.globalPosition + (_gestureGlobalToWorldOffset ?? Offset.zero);
    final UIMoveResult result = controller.onDragUpdate(worldPos);

    widget.onChanged?.call(result, event);
    widget.onDragUpdate?.call(result, event);
  }

  /// Called when the box drag event ends.
  void onDragPanEnd(DragEndDetails event) {
    if (!isDragging) return;

    primaryGestureOperation = null;
    lastHandle = null;

    controller.onDragEnd();
    widget.onDragEnd?.call(event);
  }

  void onDragPanCancel() {
    if (!isDragging) return;

    primaryGestureOperation = null;
    lastHandle = null;

    controller.onDragEnd();
    widget.onDragCancel?.call();
  }

  @override
  Widget build(BuildContext context) {
    final Flip flip = controller.flip;
    final Rect rect = controller.rect;
    final double rotation = controller.rotation;
    final Rect boundingRect = controller.boundingRect;

    final double handleTap = widget.handleTapSize;
    final bool useCornerRotationRing =
        widget.rotatable && widget.rotationHandleMode.usesCornerRing;
    final bool useTopRotationHandle =
        widget.rotatable && widget.rotationHandleMode.usesTopHandle;
    final double outerHandleSize =
        useCornerRotationRing ? widget.rotationHandleGestureSize : handleTap;
    final double rotationHandleSize = widget.rotationHandleGestureSize;

    final Offset? topRotationHandleCenterWorld = useTopRotationHandle
        ? RotatedLayout.topRotationHandleCenterInWorld(
            rect: rect,
            rotation: rotation,
            offsetFromTopEdge: widget.rotationHandleOffset,
          )
        : null;
    final Offset? topRotationHandleTopLeftWorld = useTopRotationHandle
        ? topRotationHandleCenterWorld! -
            Offset(rotationHandleSize / 2, rotationHandleSize / 2)
        : null;
    final Rect? topRotationHandleRect = topRotationHandleTopLeftWorld == null
        ? null
        : Rect.fromLTWH(
            topRotationHandleTopLeftWorld.dx,
            topRotationHandleTopLeftWorld.dy,
            rotationHandleSize,
            rotationHandleSize,
          );
    final Offset? topRotationLineAnchorWorld = useTopRotationHandle
        ? RotatedLayout.rotateOffsetAround(
            rect.topCenter, rect.center, rotation)
        : null;

    // --- Outer Positioned bounds ---------------------------------------------
    // Must contain the visually rotated box AND all handle hit regions.
    // We take the union of boundingRect (rotated AABB) and rect (unrotated,
    // since side handles at theta=0 hang off rect's edges), then inflate to
    // accommodate handle gesture zones.
    double paintLeft =
        (boundingRect.left < rect.left ? boundingRect.left : rect.left) -
            outerHandleSize;
    double paintTop =
        (boundingRect.top < rect.top ? boundingRect.top : rect.top) -
            outerHandleSize;
    double paintRight =
        (boundingRect.right > rect.right ? boundingRect.right : rect.right) +
            outerHandleSize;
    double paintBottom = (boundingRect.bottom > rect.bottom
            ? boundingRect.bottom
            : rect.bottom) +
        outerHandleSize;
    if (topRotationHandleRect != null) {
      paintLeft = math.min(paintLeft, topRotationHandleRect.left);
      paintTop = math.min(paintTop, topRotationHandleRect.top);
      paintRight = math.max(paintRight, topRotationHandleRect.right);
      paintBottom = math.max(paintBottom, topRotationHandleRect.bottom);
    }
    final Rect paintRect =
        Rect.fromLTRB(paintLeft, paintTop, paintRight, paintBottom);
    final Offset origin = paintRect.topLeft;

    // --- Visual content (rotated + flipped, never receives gestures) --------
    Widget visualContent = Transform.rotate(
      angle: rotation,
      alignment: Alignment.center,
      child: Transform.scale(
        scaleX: widget.allowContentFlipping && flip.isHorizontal ? -1 : 1,
        scaleY: widget.allowContentFlipping && flip.isVertical ? -1 : 1,
        child: widget.contentBuilder(context, rect, flip),
      ),
    );
    // Visual content is NOT wrapped in IgnorePointer: consumers may put a
    // tap/hover detector inside [contentBuilder] and those need to see
    // pointer events. The drag GestureDetector is a sibling (in Stack) with
    // HitTestBehavior.translucent so events reach content underneath too.
    final Widget contentLayer = Positioned(
      left: rect.left - origin.dx,
      top: rect.top - origin.dy,
      width: rect.width,
      height: rect.height,
      child: visualContent,
    );

    // --- Drag detector (axis-aligned, covers the visually-rotated AABB) ----
    Widget? dragLayer;
    if (widget.draggable) {
      final Rect dragRect = boundingRect;
      final Offset dragTopLeftWorld = dragRect.topLeft;
      dragLayer = Positioned(
        left: dragRect.left - origin.dx,
        top: dragRect.top - origin.dy,
        width: dragRect.width,
        height: dragRect.height,
        child: RotatedHitGate(
          unrotatedRectInWorld: rect,
          rotation: rotation,
          hitBoxTopLeftInWorld: dragRect.topLeft,
          child: GestureDetector(
            behavior: HitTestBehavior.translucent,
            supportedDevices: widget.supportedDragDevices,
            onTap: widget.onTap == null ? null : onTap,
            onPanStart: (event) => onDragPanStart(event, dragTopLeftWorld),
            onPanUpdate: (event) => onDragPanUpdate(event, dragTopLeftWorld),
            onPanEnd: onDragPanEnd,
            onPanCancel: onDragPanCancel,
          ),
        ),
      );
    }

    // --- Corner handles (at visually-rotated corners, axis-aligned) --------
    final List<Widget> handleWidgets = [];
    // Corner ring mode uses a larger outer square for rotation and positions
    // the inner resize square by matching both zones' alignment anchors.
    if (widget.resizable) {
      for (final handle in HandlePosition.corners) {
        final bool visible = widget.visibleHandles.contains(handle);
        final bool enabled = widget.enabledHandles.contains(handle);
        if (!visible && !enabled) continue;
        final Offset outerTopLeftWorld = RotatedLayout.handleTopLeftInWorld(
          rect: rect,
          handle: handle,
          rotation: rotation,
          handleSize: outerHandleSize,
          alignment: widget.handleAlignment,
        );
        // Inner resize zone's world top-left. It may not be concentric with
        // the outer zone when handleAlignment is inside/outside.
        final Offset innerTopLeftWorld = RotatedLayout.handleTopLeftInWorld(
          rect: rect,
          handle: handle,
          rotation: rotation,
          handleSize: handleTap,
          alignment: widget.handleAlignment,
        );
        handleWidgets.add(Positioned(
          left: outerTopLeftWorld.dx - origin.dx,
          top: outerTopLeftWorld.dy - origin.dy,
          width: outerHandleSize,
          height: outerHandleSize,
          child: CornerHandleWidget(
            key: ValueKey(handle),
            handlePosition: handle,
            handleTapSize: handleTap,
            rotationHandleGestureSize: outerHandleSize,
            rotatable: useCornerRotationRing,
            rotation: rotation,
            supportedDevices: widget.supportedResizeDevices,
            supportedRotationDevices: widget.supportedRotationDevices,
            enabled: enabled,
            visible: visible,
            handleAlignment: widget.handleAlignment,
            // Resize callbacks: use inner top-left (event.localPosition is
            // local to the inner padded resize zone).
            onPanStart: (event) =>
                onHandlePanStart(event, handle, innerTopLeftWorld),
            onPanUpdate: (event) =>
                onHandlePanUpdate(event, handle, innerTopLeftWorld),
            onPanEnd: (event) => onHandlePanEnd(event, handle),
            onPanCancel: () => onHandlePanCancel(handle),
            // Rotation callbacks: use outer top-left (event.localPosition is
            // local to the full 64x64 outer zone).
            onRotationStart: useCornerRotationRing
                ? (event) =>
                    onHandleRotateStart(event, handle, outerTopLeftWorld)
                : null,
            onRotationUpdate: useCornerRotationRing
                ? (event) =>
                    onHandleRotateUpdate(event, handle, outerTopLeftWorld)
                : null,
            onRotationEnd: useCornerRotationRing
                ? (event) => onHandleRotateEnd(event, handle)
                : null,
            onRotationCancel: useCornerRotationRing
                ? () => onHandleRotateCancel(handle)
                : null,
            builder: widget.cornerHandleBuilder,
            cursorResolver: widget.cursorResolver,
            debugPaintHandleBounds: widget.debugPaintHandleBounds,
          ),
        ));
      }
      // Side handles: rendered under any rotation. The rotated resize
      // methods route side handles through `_buildSideRotatedRect` with
      // the appropriate locked dimension per mode.
      for (final handle in HandlePosition.sides) {
        final bool visible = widget.visibleHandles.contains(handle);
        final bool enabled = widget.enabledHandles.contains(handle);
        if (!visible && !enabled) continue;
        // Strip's natural (unrotated) AABB along the rect's edge.
        final Rect sideRect = RotatedLayout.sideHandleRectInWorld(
          rect,
          handle,
          handleTapSize: handleTap,
          alignment: widget.handleAlignment,
        );
        // Place the strip's rotation pivot at its rotated edge midpoint in
        // world space. The strip widget itself is laid out axis-aligned at
        // (pivot − size/2, pivot + size/2), then a Transform.rotate around
        // its local center realigns it with the rotated edge.
        final Offset stripCenterWorld = rotation == 0.0
            ? sideRect.center
            : RotatedLayout.rotateOffsetAround(
                sideRect.center, rect.center, rotation);
        final Size stripSize = sideRect.size;
        final Offset sideTopLeftWorld =
            stripCenterWorld - stripSize.center(Offset.zero);

        Widget stripWidget = SideHandleWidget(
          key: ValueKey(handle),
          handlePosition: handle,
          handleTapSize: handleTap,
          supportedDevices: widget.supportedResizeDevices,
          enabled: enabled,
          visible: visible,
          onPanStart: (event) => onHandlePanStart(
            event,
            handle,
            sideTopLeftWorld,
            rotation: rotation,
            rotationPivotWorld: stripCenterWorld,
            widgetSize: stripSize,
          ),
          onPanUpdate: (event) =>
              onHandlePanUpdate(event, handle, sideTopLeftWorld),
          onPanEnd: (event) => onHandlePanEnd(event, handle),
          onPanCancel: () => onHandlePanCancel(handle),
          builder: widget.sideHandleBuilder,
          cursorResolver: widget.cursorResolver,
          debugPaintHandleBounds: widget.debugPaintHandleBounds,
        );
        if (rotation != 0.0) {
          stripWidget = Transform.rotate(
            angle: rotation,
            alignment: Alignment.center,
            child: stripWidget,
          );
        }
        handleWidgets.add(Positioned(
          left: sideTopLeftWorld.dx - origin.dx,
          top: sideTopLeftWorld.dy - origin.dy,
          width: stripSize.width,
          height: stripSize.height,
          child: stripWidget,
        ));
      }
    }

    if (useTopRotationHandle &&
        topRotationHandleTopLeftWorld != null &&
        topRotationHandleCenterWorld != null) {
      if (widget.showRotationHandleLine &&
          topRotationLineAnchorWorld != null &&
          widget.rotationHandleOffset > 0) {
        handleWidgets.add(Positioned.fill(
          child: IgnorePointer(
            child: CustomPaint(
              painter: RenderRotationHandleLine(
                start: topRotationLineAnchorWorld - origin,
                end: topRotationHandleCenterWorld - origin,
                color: Theme.of(context)
                    .colorScheme
                    .primary
                    .withValues(alpha: 0.45),
              ),
            ),
          ),
        ));
      }

      handleWidgets.add(Positioned(
        left: topRotationHandleTopLeftWorld.dx - origin.dx,
        top: topRotationHandleTopLeftWorld.dy - origin.dy,
        width: rotationHandleSize,
        height: rotationHandleSize,
        child: RotationHandleWidget(
          key: const ValueKey('box_transform_top_rotation_handle'),
          handleTapSize: rotationHandleSize,
          supportedDevices: widget.supportedRotationDevices,
          onPanStart: (event) => onHandleRotateStart(
            event,
            HandlePosition.top,
            topRotationHandleTopLeftWorld,
          ),
          onPanUpdate: (event) => onHandleRotateUpdate(
            event,
            HandlePosition.top,
            topRotationHandleTopLeftWorld,
          ),
          onPanEnd: (event) => onHandleRotateEnd(event, HandlePosition.top),
          onPanCancel: () => onHandleRotateCancel(HandlePosition.top),
          builder: widget.rotationHandleBuilder,
          cursorResolver: widget.cursorResolver,
          debugPaintHandleBounds: widget.debugPaintHandleBounds,
        ),
      ));
    }

    final List<Widget> overlays = <Widget>[];
    if (widget.debugShowUnrotatedRect) {
      overlays.add(Positioned(
        left: rect.left - origin.dx,
        top: rect.top - origin.dy,
        width: rect.width,
        height: rect.height,
        child: IgnorePointer(
          child: Container(
            decoration: BoxDecoration(
              border: Border.all(color: Colors.green, width: 2),
            ),
          ),
        ),
      ));
    }
    if (widget.debugShowBoundingRect) {
      overlays.add(Positioned(
        left: boundingRect.left - origin.dx,
        top: boundingRect.top - origin.dy,
        width: boundingRect.width,
        height: boundingRect.height,
        child: IgnorePointer(
          child: Container(
            decoration: BoxDecoration(
              border: Border.all(color: Colors.red, width: 3),
            ),
          ),
        ),
      ));
    }
    if (widget.debugShowRotationArrows && _rotationArrowPointer != null) {
      overlays.add(Positioned.fill(
        child: IgnorePointer(
          child: CustomPaint(
            painter: RenderRotationArrows(
              // controller.initialLocalPosition is now in world (parent) frame.
              initialPosition: controller.initialLocalPosition - origin,
              currentPosition: _rotationArrowPointer! - origin,
              rectCenter: rect.center - origin,
            ),
          ),
        ),
      ));
    }

    return Positioned.fromRect(
      rect: paintRect,
      child: Stack(
        clipBehavior: Clip.none,
        children: [
          contentLayer,
          if (dragLayer != null) dragLayer,
          ...handleWidgets,
          ...overlays,
        ],
      ),
    );
  }
}

/// Paints the connector line from the rotated top edge to the top rotation
/// handle.
class RenderRotationHandleLine extends CustomPainter {
  /// Start point on the rotated top edge.
  final Offset start;

  /// End point at the rotation handle center.
  final Offset end;

  /// Line color.
  final Color color;

  /// Creates a [RenderRotationHandleLine] painter.
  const RenderRotationHandleLine({
    required this.start,
    required this.end,
    required this.color,
  });

  @override
  void paint(Canvas canvas, Size size) {
    final Paint paint = Paint()
      ..color = color
      ..strokeWidth = 1.5
      ..strokeCap = StrokeCap.round
      ..style = PaintingStyle.stroke;
    canvas.drawLine(start, end, paint);
  }

  @override
  bool shouldRepaint(covariant RenderRotationHandleLine oldDelegate) =>
      oldDelegate.start != start ||
      oldDelegate.end != end ||
      oldDelegate.color != color;
}

/// Debug painter that renders vectors from the box center to the initial
/// rotation pointer position and the current rotation pointer position.
/// Red = initial, blue = current.
class RenderRotationArrows extends CustomPainter {
  /// Pointer position when the rotation gesture started.
  final Offset initialPosition;

  /// Current pointer position during the rotation gesture.
  final Offset currentPosition;

  /// Center of the rotated box (in the same coordinate space as the pointer
  /// positions).
  final Offset rectCenter;

  /// Creates a [RenderRotationArrows] painter.
  const RenderRotationArrows({
    required this.initialPosition,
    required this.currentPosition,
    required this.rectCenter,
  });

  @override
  void paint(Canvas canvas, Size size) {
    final Paint paint = Paint()
      ..style = PaintingStyle.stroke
      ..strokeWidth = 3
      ..strokeCap = StrokeCap.round;

    // Initial (red).
    paint.color = Colors.red;
    canvas.drawLine(rectCenter, initialPosition, paint);
    canvas.drawCircle(initialPosition, 6, paint);

    // Current (blue).
    paint.color = Colors.blue;
    canvas.drawLine(rectCenter, currentPosition, paint);
    canvas.drawCircle(currentPosition, 6, paint);
  }

  @override
  bool shouldRepaint(covariant RenderRotationArrows oldDelegate) =>
      oldDelegate.initialPosition != initialPosition ||
      oldDelegate.currentPosition != currentPosition ||
      oldDelegate.rectCenter != rectCenter;
}
