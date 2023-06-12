import 'package:box_transform/box_transform.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

import 'ui_box_transform.dart';
import 'ui_result.dart';

/// Default [ResizeModeResolver] implementation. This implementation
/// doesn't rely on the focus system .It resolves the [ResizeMode] based on
/// the pressed keys on the keyboard from the
/// [WidgetsBinding.keyboard.logicalKeysPressed] hence it only works on
/// hardware keyboards.
///
/// If you want to use it on soft keyboards, you can
/// implement your own [ResizeModeResolver] and pass it to the
/// [TransformableBoxController] constructor.
ResizeMode defaultResizeModeResolver() {
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
  /// Creates a [TransformableBoxController] instance.
  TransformableBoxController({
    Rect? rect,
    Flip? flip,
    Rect? clampingRect,
    BoxConstraints? constraints,
    ValueGetter<ResizeMode>? resizeModeResolver,
    bool allowFlippingWhileResizing = true,
  })  : _rect = rect ?? Rect.zero,
        _flip = flip ?? Flip.none,
        _clampingRect = clampingRect ?? Rect.largest,
        _constraints = constraints ?? const BoxConstraints(),
        _resizeModeResolver = resizeModeResolver ?? defaultResizeModeResolver,
        _allowFlippingWhileResizing = allowFlippingWhileResizing;

  /// The callback function that is used to resolve the [ResizeMode] based on
  /// the pressed keys on the keyboard.
  ValueGetter<ResizeMode> _resizeModeResolver;

  /// The callback function that is used to resolve the [ResizeMode] based on
  /// the pressed keys on the keyboard.
  ValueGetter<ResizeMode> get resizeModeResolver => _resizeModeResolver;

  /// The current [Rect] of the [TransformableBox].
  Rect _rect = Rect.zero;

  /// The current [Rect] of the [TransformableBox].
  Rect get rect => _rect;

  /// The current [Flip] of the [TransformableBox].
  Flip _flip = Flip.none;

  /// The current [Flip] of the [TransformableBox].
  Flip get flip => _flip;

  /// The initial [Offset] of the [TransformableBox] when the resizing starts.
  Offset _initialLocalPosition = Offset.zero;

  /// The initial [Offset] of the [TransformableBox] when the resizing starts.
  Offset get initialLocalPosition => _initialLocalPosition;

  /// The initial [Rect] of the [TransformableBox] when the resizing starts.
  Rect _initialRect = Rect.zero;

  /// The initial [Rect] of the [TransformableBox] when the resizing starts.
  Rect get initialRect => _initialRect;

  /// The initial [Flip] of the [TransformableBox] when the resizing starts.
  Flip _initialFlip = Flip.none;

  /// The initial [Flip] of the [TransformableBox] when the resizing starts.
  Flip get initialFlip => _initialFlip;

  /// The box that limits the dragging and resizing of the [TransformableBox] inside
  /// its bounds.
  Rect _clampingRect = Rect.largest;

  /// The box that limits the dragging and resizing of the [TransformableBox] inside
  /// its bounds.
  Rect get clampingRect => _clampingRect;

  /// Whether to allow flipping of the box while resizing. If this is set to
  /// true, the box will flip when the user drags the handles to opposite
  /// corners of the rect.
  bool _allowFlippingWhileResizing = false;

  /// Whether to allow flipping of the box while resizing. If this is set to
  /// true, the box will flip when the user drags the handles to opposite
  /// corners of the rect.
  bool get allowFlippingWhileResizing => _allowFlippingWhileResizing;

  /// The constraints that limits the resizing of the [TransformableBox] inside its
  /// bounds.
  BoxConstraints _constraints = const BoxConstraints.expand();

  /// The constraints that limits the resizing of the [TransformableBox] inside its
  /// bounds.
  BoxConstraints get constraints => _constraints;

  /// Sets the current [resizeModeResolver] of the [TransformableBox].
  void setResizeModeResolver(
    ValueGetter<ResizeMode> resizeModeResolver, {
    bool notify = true,
  }) {
    _resizeModeResolver = resizeModeResolver;

    if (notify) notifyListeners();
  }

  /// Sets the current [rect] of the [TransformableBox].
  void setRect(
    Rect rect, {
    bool notify = true,
    bool recalculate = true,
  }) {
    _rect = rect;

    if (recalculate) {
      this.recalculate(notify: false);
    }

    if (notify) notifyListeners();
  }

  /// Sets the current [flip] of the [TransformableBox].
  void setFlip(Flip flip, {bool notify = true}) {
    _flip = flip;

    if (notify) notifyListeners();
  }

  /// Sets the initial local position of the [TransformableBox].
  void setInitialLocalPosition(Offset initialLocalPosition,
      {bool notify = true}) {
    _initialLocalPosition = initialLocalPosition;

    if (notify) notifyListeners();
  }

  /// Sets the initial [Rect] of the [TransformableBox].
  void setInitialRect(Rect initialRect, {bool notify = true}) {
    _initialRect = initialRect;

    if (notify) notifyListeners();
  }

  /// Sets the initial [Flip] of the [TransformableBox].
  void setInitialFlip(Flip initialFlip, {bool notify = true}) {
    _initialFlip = initialFlip;

    if (notify) notifyListeners();
  }

  /// Sets the current [clampingRect] of the [TransformableBox].
  void setClampingRect(
    Rect clampingRect, {
    bool notify = true,
    bool recalculate = true,
  }) {
    _clampingRect = clampingRect;

    if (recalculate) {
      this.recalculate(notify: false);
    }

    if (notify) notifyListeners();
  }

  /// Sets the current [constraints] of the [TransformableBox].
  void setConstraints(BoxConstraints constraints, {bool notify = true}) {
    _constraints = constraints;

    if (notify) notifyListeners();
  }

  /// Whether to allow flipping of the box while resizing. If this is set to
  /// true, the box will flip when the user drags the handles to opposite
  /// corners of the rect.
  void setAllowFlippingWhileResizing(bool allowFlippingWhileResizing,
      {bool notify = true}) {
    _allowFlippingWhileResizing = allowFlippingWhileResizing;

    if (notify) notifyListeners();
  }

  /// Called when dragging of the [TransformableBox] starts.
  ///
  /// [localPosition] is the position of the pointer relative to the
  ///               [TransformableBox] when the dragging starts.
  void onDragStart(Offset localPosition) {
    _initialLocalPosition = localPosition;
    _initialRect = rect;
  }

  /// Called when the [TransformableBox] is dragged.
  ///
  /// [localPosition] is the position of the pointer relative to the
  ///                [TransformableBox].
  ///
  /// [notify] is a boolean value that determines whether to notify the
  ///          listeners or not. It is set to `true` by default.
  ///          If you want to update the [TransformableBox] without notifying
  ///          the listeners, you can set it to `false`.
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

    _rect = result.rect;

    if (notify) notifyListeners();

    return result;
  }

  /// Called when the dragging of the [TransformableBox] ends.
  void onDragEnd({bool notify = true}) {
    _initialLocalPosition = Offset.zero;
    _initialRect = Rect.zero;

    if (notify) notifyListeners();
  }

  /// Called when the dragging of the [TransformableBox] is cancelled.
  void onDragCancel({bool notify = true}) => onDragEnd(notify: notify);

  /// Called when the resizing starts on [TransformableBox].
  ///
  /// [localPosition] is the position of the pointer relative to the
  ///               [TransformableBox] when the resizing starts.
  void onResizeStart(Offset localPosition) {
    _initialLocalPosition = localPosition;
    _initialRect = rect;
    _initialFlip = flip;
  }

  /// Called when the [TransformableBox] is being resized.
  ///
  /// [localPosition] is the position of the pointer relative to the
  ///                 [TransformableBox] when the resizing starts.
  ///                 It is used to calculate the new [Rect] of the
  ///                 [TransformableBox].
  ///
  /// [handle] is the handle that is being dragged.
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
      resizeMode: resizeModeResolver(),
      initialFlip: initialFlip,
      clampingRect: clampingRect,
      constraints: constraints,
      allowFlipping: allowFlippingWhileResizing,
    );

    _rect = result.rect;
    _flip = result.flip;

    if (notify) notifyListeners();
    return result;
  }

  /// Called when the resizing ends on [TransformableBox].
  void onResizeEnd({bool notify = true}) {
    _initialLocalPosition = Offset.zero;
    _initialRect = Rect.zero;
    _initialFlip = Flip.none;

    if (notify) notifyListeners();
  }

  /// Called when the resizing of the [TransformableBox] is cancelled.
  void onResizeCancel({bool notify = true}) => onResizeEnd(notify: notify);

  /// Recalculates the current state of this [rect] to ensure the position is
  /// correct in case of extreme jumps of the [TransformableBox].
  void recalculatePosition({bool notify = true}) {
    final UIMoveResult result = UIBoxTransform.move(
      initialRect: rect,
      initialLocalPosition: initialLocalPosition,
      localPosition: initialLocalPosition,
      clampingRect: clampingRect,
    );

    _rect = result.rect;

    if (notify) notifyListeners();
  }

  /// Recalculates the current state of this [rect] to ensure the position is
  /// correct in case of extreme jumps of the [TransformableBox].
  void recalculateSize({
    bool notify = true,
    ResizeMode resizeMode = ResizeMode.freeform,
    HandlePosition handle = HandlePosition.bottomRight,
  }) {
    final UIResizeResult result = UIBoxTransform.resize(
      initialRect: rect,
      initialLocalPosition: initialLocalPosition,
      localPosition: initialLocalPosition,
      clampingRect: clampingRect,
      handle: handle,
      resizeMode: resizeMode,
      initialFlip: initialFlip,
      constraints: constraints,
      allowFlipping: allowFlippingWhileResizing,
    );

    _rect = result.rect;

    if (notify) notifyListeners();
  }

  /// Recalculates the current state of this [rect] to ensure the position and
  /// size are correct in case of extreme jumps of the [TransformableBox].
  /// This is a combination of [recalculatePosition] and [recalculateSize] for
  /// convenience.
  void recalculate({bool notify = true}) {
    recalculatePosition(notify: false);
    recalculateSize(notify: false);

    if (notify) notifyListeners();
  }

  /// Notifies the listeners of this [ChangeNotifier].
  void notify() {
    notifyListeners();
  }
}
