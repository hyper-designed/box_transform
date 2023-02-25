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
/// [BoxTransformController] constructor.
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

/// A controller class that is used to control the [BoxTransform] widget.
class BoxTransformController extends ChangeNotifier {
  /// The callback function that is used to resolve the [ResizeMode] based on
  /// the pressed keys on the keyboard.
  final ResolveResizeModeCallback? resolveResizeModeCallback;

  /// Creates a [BoxTransformController] instance.
  BoxTransformController({
    this.resolveResizeModeCallback = defaultResolveResizeModeCallback,
  });

  /// The current [Rect] of the [BoxTransform].
  Rect box = Rect.zero;

  /// The current [Flip] of the [BoxTransform].
  Flip flip = Flip.none;

  /// The initial [Offset] of the [BoxTransform] when the resizing starts.
  Offset initialLocalPosition = Offset.zero;

  Offset offsetFromTopLeft = Offset.zero;

  /// The initial [Rect] of the [BoxTransform] when the resizing starts.
  Rect initialRect = Rect.zero;

  /// The initial [Flip] of the [BoxTransform] when the resizing starts.
  Flip initialFlip = Flip.none;

  /// The box that limits the dragging and resizing of the [BoxTransform] inside
  /// its bounds.
  Rect clampingBox = Rect.largest;

  /// The constraints that limits the resizing of the [BoxTransform] inside its
  /// bounds.
  BoxConstraints constraints = const BoxConstraints.expand();

  /// Sets the current [box] of the [BoxTransform].
  void setRect(Rect box) {
    this.box = box;
    notifyListeners();
  }

  /// Sets the current [flip] of the [BoxTransform].
  void setFlip(Flip flip) {
    this.flip = flip;
    notifyListeners();
  }

  /// Sets the initial local position of the [BoxTransform].
  void setInitialLocalPosition(Offset initialLocalPosition) {
    this.initialLocalPosition = initialLocalPosition;
    notifyListeners();
  }

  /// Sets the initial [Rect] of the [BoxTransform].
  void setInitialRect(Rect initialRect) {
    this.initialRect = initialRect;
    notifyListeners();
  }

  /// Sets the initial [Flip] of the [BoxTransform].
  void setInitialFlip(Flip initialFlip) {
    this.initialFlip = initialFlip;
    notifyListeners();
  }

  /// Sets the current [clampingBox] of the [BoxTransform].
  void setClampingBox(Rect clampingBox, {bool notify = true}) {
    this.clampingBox = clampingBox;
    if (notify) notifyListeners();
  }

  /// Sets the current [constraints] of the [BoxTransform].
  void setConstraints(BoxConstraints constraints, {bool notify = true}) {
    this.constraints = constraints;
    if (notify) notifyListeners();
  }

  /// Called when dragging of the [BoxTransform] starts.
  ///
  /// [localPosition] is the position of the pointer relative to the
  ///               [BoxTransform] when the dragging starts.
  void onDragStart(Offset localPosition) {
    initialLocalPosition = localPosition;
    initialRect = box;
    offsetFromTopLeft = box.topLeft - localPosition;
  }

  /// Called when the [BoxTransform] is dragged.
  ///
  /// [localPosition] is the position of the pointer relative to the
  ///                [BoxTransform].
  ///
  /// [notify] is a boolean value that determines whether to notify the
  ///          listeners or not. It is set to `true` by default.
  ///          If you want to update the [BoxTransform] without notifying the
  ///          listeners, you can set it to `false`.
  UIMoveResult onDragUpdate(
    Offset localPosition, {
    bool notify = true,
  }) {
    final UIMoveResult result = UIBoxTransform.move(
      initialRect: initialRect,
      initialLocalPosition: initialLocalPosition,
      localPosition: localPosition,
      clampingBox: clampingBox,
    );

    box = result.newRect;

    if (notify) notifyListeners();

    return result;
  }

  /// Called when the dragging of the [BoxTransform] ends.
  void onDragEnd() {
    initialLocalPosition = Offset.zero;
    initialRect = Rect.zero;
    offsetFromTopLeft = Offset.zero;

    notifyListeners();
  }

  /// Called when the resizing starts on [BoxTransform].
  ///
  /// [localPosition] is the position of the pointer relative to the
  ///               [BoxTransform] when the resizing starts.
  void onResizeStart(Offset localPosition) {
    initialLocalPosition = localPosition;
    initialRect = box;
    initialFlip = flip;
  }

  /// Called when the [BoxTransform] is being resized.
  ///
  /// [localPosition] is the position of the pointer relative to the
  ///                 [BoxTransform] when the resizing starts.
  ///                 It is used to calculate the new [Rect] of the
  ///                 [BoxTransform].
  ///
  /// [handle] is the handle that is being dragged.
  ///
  /// [notify] is a boolean value that determines whether to notify the
  ///          listeners or not. It is set to `true` by default.
  ///          If you want to update the [BoxTransform] without notifying the
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
      clampingBox: clampingBox,
      constraints: constraints,
    );

    box = result.newRect;
    flip = result.flip;

    if (notify) notifyListeners();
    return result;
  }

  /// Called when the resizing ends on [BoxTransform].
  void onResizeEnd() {
    initialLocalPosition = Offset.zero;
    initialRect = Rect.zero;
    initialFlip = Flip.none;

    notifyListeners();
  }

  /// Recalculates the current state of this [box] to ensure the position is
  /// correct in case of extreme jumps of the [BoxTransform].
  void recalculateBox({bool notify = true}) {
    final UIMoveResult result = UIBoxTransform.move(
      initialRect: box,
      initialLocalPosition: initialLocalPosition,
      localPosition: initialLocalPosition,
      clampingBox: clampingBox,
    );

    box = result.newRect;

    if (notify) notifyListeners();
  }
}
