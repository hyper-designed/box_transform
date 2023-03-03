import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

import '../flutter_box_transform.dart';

/// A callback function type definition that is used to resolve the
/// [ResizeMode] based on the pressed keys on the keyboard.
typedef ResolveResizeModeCallback = ValueGetter<ResizeMode>;

/// Default [ResolveResizeModeCallback] implementation. This implementation
/// doesn't rely on the focus system .It resolves the [ResizeMode] based on
/// the pressed keys on the keyboard from the
/// [WidgetsBinding.keyboard.logicalKeysPressed] hence it only works on
/// hardware keyboards.
///
/// If you want to use it on soft keyboards, you can
/// implement your own [ResolveResizeModeCallback] and pass it to the
/// [TransformableBoxController] constructor.
ResizeMode defaultResolveResizeModeCallback() {
  final pressedKeys = WidgetsBinding.instance.keyboard.logicalKeysPressed;

  final isAltPressed = pressedKeys.contains(LogicalKeyboardKey.altLeft) ||
      pressedKeys.contains(LogicalKeyboardKey.altRight);

  final isShiftPressed = pressedKeys.contains(LogicalKeyboardKey.shiftLeft) ||
      pressedKeys.contains(LogicalKeyboardKey.shiftRight);

  if (isAltPressed && isShiftPressed) {
    return ResizeMode.symmetricScale;
  } else if (isAltPressed) {
    return ResizeMode.symmetric;
  } else if (isShiftPressed) {
    return ResizeMode.scale;
  } else {
    return ResizeMode.freeform;
  }
}

/// A controller class that is used to control the [TransformableBox] widget.
class TransformableBoxController extends ChangeNotifier {
  /// The callback function that is used to resolve the [ResizeMode] based on
  /// the pressed keys on the keyboard.
  ResolveResizeModeCallback? resolveResizeModeCallback;

  /// Creates a [TransformableBoxController] instance.
  TransformableBoxController({
    this.resolveResizeModeCallback = defaultResolveResizeModeCallback,
  });

  /// The current [Rect] of the [TransformableBox].
  Rect rect = Rect.zero;

  /// The current [Flip] of the [TransformableBox].
  Flip flip = Flip.none;

  /// The initial [Offset] of the [TransformableBox] when the resizing starts.
  Offset initialLocalPosition = Offset.zero;

  Offset offsetFromTopLeft = Offset.zero;

  /// The initial [Rect] of the [TransformableBox] when the resizing starts.
  Rect initialRect = Rect.zero;

  /// The initial [Flip] of the [TransformableBox] when the resizing starts.
  Flip initialFlip = Flip.none;

  /// The box that limits the dragging and resizing of the [TransformableBox] inside
  /// its bounds.
  Rect clampingRect = Rect.largest;

  /// /// Whether the box is movable or not. Setting this to false will disable
  /// all moving operations.
  bool movable = true;

  /// Whether the box is resizable or not. Setting this to false will disable
  /// all resizing operations.
  bool resizable = true;

  /// The constraints that limits the resizing of the [TransformableBox] inside its
  /// bounds.
  BoxConstraints constraints = const BoxConstraints.expand();

  /// Sets the current [box] of the [TransformableBox].
  void setRect(Rect rect) {
    this.rect = rect;
    notifyListeners();
  }

  /// Sets the current [flip] of the [TransformableBox].
  void setFlip(Flip flip) {
    this.flip = flip;
    notifyListeners();
  }

  /// Sets the initial local position of the [TransformableBox].
  void setInitialLocalPosition(Offset initialLocalPosition) {
    this.initialLocalPosition = initialLocalPosition;
    notifyListeners();
  }

  /// Sets the initial [Rect] of the [TransformableBox].
  void setInitialRect(Rect initialRect) {
    this.initialRect = initialRect;
    notifyListeners();
  }

  /// Sets the initial [Flip] of the [TransformableBox].
  void setInitialFlip(Flip initialFlip) {
    this.initialFlip = initialFlip;
    notifyListeners();
  }

  /// Sets the current [clampingRect] of the [TransformableBox].
  void setClampingRect(Rect clampingRect, {bool notify = true}) {
    this.clampingRect = clampingRect;
    if (notify) notifyListeners();
  }

  /// Sets the current [constraints] of the [TransformableBox].
  void setConstraints(BoxConstraints constraints, {bool notify = true}) {
    this.constraints = constraints;
    if (notify) notifyListeners();
  }

  /// Called when dragging of the [TransformableBox] starts.
  ///
  /// [localPosition] is the position of the pointer relative to the
  ///               [TransformableBox] when the dragging starts.
  void onDragStart(Offset localPosition) {
    initialLocalPosition = localPosition;
    initialRect = rect;
    offsetFromTopLeft = rect.topLeft - localPosition;
  }

  /// Called when the [TransformableBox] is dragged.
  ///
  /// [localPosition] is the position of the pointer relative to the
  ///                [TransformableBox].
  ///
  /// [notify] is a boolean value that determines whether to notify the
  ///          listeners or not. It is set to `true` by default.
  ///          If you want to update the [TransformableBox] without notifying the
  ///          listeners, you can set it to `false`.
  UIMoveResult onDragUpdate(
    Offset localPosition, {
    bool notify = true,
  }) {
    final UIMoveResult result = UIBoxTransform.move(
      initialRect: initialRect,
      initialLocalPosition: initialLocalPosition,
      localPosition: localPosition,
      clampingRect: clampingRect,
    );

    rect = result.rect;

    if (notify) notifyListeners();

    return result;
  }

  /// Called when the dragging of the [TransformableBox] ends.
  void onDragEnd() {
    initialLocalPosition = Offset.zero;
    initialRect = Rect.zero;
    offsetFromTopLeft = Offset.zero;

    notifyListeners();
  }

  /// Called when the resizing starts on [TransformableBox].
  ///
  /// [localPosition] is the position of the pointer relative to the
  ///               [TransformableBox] when the resizing starts.
  void onResizeStart(Offset localPosition) {
    initialLocalPosition = localPosition;
    initialRect = rect;
    initialFlip = flip;
  }

  /// Called when the [TransformableBox] is being resized.
  ///
  /// [localPosition] is the position of the pointer relative to the
  ///                 [TransformableBox] when the resizing starts.
  ///                 It is used to calculate the new [Rect] of the
  ///                 [TransformableBox].
  ///
  /// [handle] is the handle that is being dragged.
  ///
  /// [notify] is a boolean value that determines whether to notify the
  ///          listeners or not. It is set to `true` by default.
  ///          If you want to update the [TransformableBox] without notifying the
  ///          listeners, you can set it to `false`.
  UIResizeResult onResizeUpdate(
    Offset localPosition,
    HandlePosition handle, {
    bool notify = true,
  }) {
    // Calculate the new rect based on the initial rect, initial local position,
    final UIResizeResult result = UIBoxTransform.resize(
      localPosition: localPosition,
      handle: handle,
      initialRect: initialRect,
      initialLocalPosition: initialLocalPosition,
      resizeMode: resolveResizeModeCallback!(),
      initialFlip: initialFlip,
      clampingRect: clampingRect,
      constraints: constraints,
    );

    rect = result.rect;
    flip = result.flip;

    if (notify) notifyListeners();
    return result;
  }

  /// Called when the resizing ends on [TransformableBox].
  void onResizeEnd() {
    initialLocalPosition = Offset.zero;
    initialRect = Rect.zero;
    initialFlip = Flip.none;

    notifyListeners();
  }

  /// Recalculates the current state of this [rect] to ensure the position is
  /// correct in case of extreme jumps of the [TransformableBox].
  void recalculateBox({bool notify = true}) {
    final UIMoveResult result = UIBoxTransform.move(
      initialRect: rect,
      initialLocalPosition: initialLocalPosition,
      localPosition: initialLocalPosition,
      clampingRect: clampingRect,
    );

    rect = result.rect;

    if (notify) notifyListeners();
  }
}
