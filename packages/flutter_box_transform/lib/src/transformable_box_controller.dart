import 'package:box_transform/box_transform.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

import 'extensions.dart';
import 'rotated_layout.dart';
import 'ui_box_transform.dart';
import 'ui_result.dart';

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
    double rotation = 0.0,
    BindingStrategy bindingStrategy = BindingStrategy.boundingBox,
  })  : _rect = rect ?? Rect.zero,
        _flip = flip ?? Flip.none,
        _clampingRect = clampingRect ?? Rect.largest,
        _constraints = constraints ?? const BoxConstraints(),
        _resizeModeResolver = resizeModeResolver ?? defaultResizeModeResolver,
        _allowFlippingWhileResizing = allowFlippingWhileResizing,
        _rotation = rotation,
        _bindingStrategy = bindingStrategy {
    _boundingRect = ClampHelpers.calculateBoundingRect(
      (rect ?? Rect.zero).toBox(rotation: rotation),
    ).toRect();
  }

  /// Default [ResizeModeResolver] implementation. This implementation
  /// doesn't rely on the focus system. It resolves the [ResizeMode] based on
  /// the pressed keys on the keyboard from the
  /// [WidgetsBinding.keyboard.logicalKeysPressed] hence it only works on
  /// hardware keyboards.
  ///
  /// If you want to use it on soft keyboards, you can
  /// implement your own [ResizeModeResolver] and pass it to the
  /// [TransformableBoxController] constructor.
  static ResizeMode defaultResizeModeResolver() {
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

  /// The current rotation (radians) of the [TransformableBox], clockwise around
  /// the box center.
  double _rotation = 0.0;

  /// The current rotation (radians) of the [TransformableBox].
  double get rotation => _rotation;

  /// The initial rotation (radians) of the [TransformableBox] when a gesture
  /// starts. Used as the base for additive rotation updates.
  double _initialRotation = 0.0;

  /// The initial rotation captured at the start of a rotation gesture.
  double get initialRotation => _initialRotation;

  /// The current axis-aligned bounding rect of the rotated box. Equals [rect]
  /// when [rotation] is 0.
  Rect _boundingRect = Rect.zero;

  /// The axis-aligned bounding rect of the rotated [rect]. Read-only.
  Rect get boundingRect => _boundingRect;

  /// The [BindingStrategy] controlling whether size constraints and clamping
  /// apply to the unrotated [rect] or the rendered [boundingRect].
  BindingStrategy _bindingStrategy = BindingStrategy.boundingBox;

  /// The current [BindingStrategy].
  BindingStrategy get bindingStrategy => _bindingStrategy;

  /// The rect that the solver enforces against [clampingRect] under the
  /// current [bindingStrategy]. For [BindingStrategy.boundingBox] this
  /// equals [boundingRect]; for [BindingStrategy.originalBox] it equals
  /// [rect] (rotated corners may extend outside the clamp).
  Rect get effectiveContainmentRect =>
      RotatedLayout.computeEffectiveContainmentRect(
        rect: rect,
        rotation: rotation,
        bindingStrategy: bindingStrategy,
      );

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

  /// Sets the current [rotation] (radians). Also refreshes [boundingRect].
  void setRotation(double rotation, {bool notify = true}) {
    _rotation = rotation;
    _boundingRect =
        ClampHelpers.calculateBoundingRect(_rect.toBox(rotation: _rotation))
            .toRect();
    if (notify) notifyListeners();
  }

  /// Sets the initial [rotation] captured at the start of a gesture.
  void setInitialRotation(double initialRotation, {bool notify = true}) {
    _initialRotation = initialRotation;
    if (notify) notifyListeners();
  }

  /// Sets the [BindingStrategy] used for rotated clamping/constraints.
  ///
  /// After the assignment, runs [recalculatePosition] (translate-only,
  /// `notify: false`) so the box is reconciled against the new strategy's
  /// clamp semantics. This handles the case where the box was valid under
  /// the previous strategy but violates the new one (e.g. switching from
  /// `originalBox` to `boundingBox` with the rotated bounding extending
  /// outside the clamp). We intentionally do NOT run `recalculateSize` -
  /// translation-only keeps size invariant; users can resize manually if
  /// they want the box to shrink to fit.
  void setBindingStrategy(BindingStrategy bindingStrategy,
      {bool notify = true}) {
    if (_bindingStrategy == bindingStrategy) {
      if (notify) notifyListeners();
      return;
    }
    _bindingStrategy = bindingStrategy;
    recalculatePosition(notify: false);
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
  ///
  /// [recalculate] controls whether the controller immediately reconciles
  /// the box against the new clamp by running both [recalculatePosition]
  /// and [recalculateSize]. The default is `true` for backwards-compat;
  /// it is rarely what you want when updating the clamp in a tight loop.
  ///
  /// WARNING for external-controller users: when a rotated box is near
  /// saturation against the clamp, the internal [recalculateSize] (zero-
  /// delta, [ResizeMode.scale]) picks the largest (w, h) that fits the
  /// new clamp — strictly smaller than the current box by a sliver. Call
  /// it per tick while the clamp shrinks and the slivers accumulate into
  /// a visible shrink + off-edge flick. Pass `recalculate: false` and
  /// then explicitly call [recalculatePosition] (translation-only) when
  /// driving clamp updates from a parent/model re-injection loop.
  ///
  /// `TransformableBox.didUpdateWidget` does exactly that for the
  /// internal-controller path.
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
      rotation: _rotation,
      bindingStrategy: _bindingStrategy,
    );

    _rect = result.rect;
    _boundingRect = result.boundingRect;

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
  /// [TransformableBox] when the resizing starts.
  /// It is used to calculate the new [Rect] of the [TransformableBox].
  ///
  /// [handle] is the handle that is being dragged.
  ///
  /// [notify] is a boolean value that determines whether to notify the
  /// listeners or not. It is set to `true` by default.
  ///
  /// [resizeModeResolver] is a callback function that is used to resolve the
  /// [ResizeMode] based on the pressed keys on the keyboard. It can be
  /// optionally passed to override the default [resizeModeResolver] of this
  /// [TransformableBoxController].
  UIResizeResult onResizeUpdate(
    Offset localPosition,
    HandlePosition handle, {
    bool notify = true,
    ValueGetter<ResizeMode>? resizeModeResolver,
  }) {
    // Calculate the new rect based on the initial rect, initial local position,
    final UIResizeResult result = UIBoxTransform.resize(
      localPosition: localPosition,
      handle: handle,
      initialRect: initialRect,
      initialLocalPosition: initialLocalPosition,
      resizeMode: resizeModeResolver?.call() ?? this.resizeModeResolver(),
      initialFlip: initialFlip,
      clampingRect: clampingRect,
      constraints: constraints,
      allowFlipping: allowFlippingWhileResizing,
      rotation: _rotation,
      bindingStrategy: _bindingStrategy,
    );

    // Hold last-feasible state on infeasible ticks. The engine is
    // stateless and returns initialRect (gesture-start) as a sentinel
    // when it can't satisfy clamp + constraints — but consumers that
    // bind their UI to result.rect (e.g. flutter widgets in onChanged
    // callbacks) would visibly snap the rect back to gesture-start on
    // every infeasible tick. To make the freeze visible all the way to
    // the renderer, we override the result with the controller's
    // current (last feasible) state before returning. Future ticks
    // still recompute from initialRect (gesture-start) so reversing the
    // drag direction unfreezes naturally.
    if (result.feasible) {
      _rect = result.rect;
      _flip = result.flip;
      _boundingRect = result.boundingRect;
      if (notify) notifyListeners();
      return result;
    }

    final frozen = UIResizeResult(
      rect: _rect,
      oldRect: result.oldRect,
      flip: _flip,
      resizeMode: result.resizeMode,
      delta: result.delta,
      rawSize: Size(_rect.width, _rect.height),
      minWidthReached: result.minWidthReached,
      minHeightReached: result.minHeightReached,
      maxWidthReached: result.maxWidthReached,
      maxHeightReached: result.maxHeightReached,
      largestRect: result.largestRect,
      handle: result.handle,
      rotation: result.rotation,
      boundingRect: _boundingRect,
      oldBoundingRect: result.oldBoundingRect,
      feasible: false,
    );
    if (notify) notifyListeners();
    return frozen;
  }

  /// Called when the resizing ends on [TransformableBox].
  void onResizeEnd({bool notify = true}) {
    _initialLocalPosition = Offset.zero;
    _initialRect = Rect.zero;
    _initialFlip = Flip.none;

    if (notify) notifyListeners();
  }

  /// Called when a rotation gesture starts.
  ///
  /// [localPosition] is the position of the pointer relative to the
  /// [TransformableBox]. Captures the current [rotation] as [initialRotation].
  void onRotateStart(Offset localPosition) {
    _initialLocalPosition = localPosition;
    _initialRect = rect;
    _initialRotation = rotation;
  }

  /// Called during a rotation gesture.
  ///
  /// [localPosition] is the current pointer position (same coord space as
  /// [onRotateStart]). [handle] identifies which corner is being dragged.
  UIRotateResult onRotateUpdate(
    Offset localPosition,
    HandlePosition handle, {
    bool notify = true,
  }) {
    final UIRotateResult result = UIBoxTransform.rotate(
      initialRect: initialRect,
      initialLocalPosition: initialLocalPosition,
      localPosition: localPosition,
      initialRotation: initialRotation,
      clampingRect: clampingRect,
      bindingStrategy: bindingStrategy,
    );
    // Freeze on infeasible: leave _rotation/_rect at their last feasible
    // values AND override result.rect/result.rotation so consumers binding
    // their UI to the callback (e.g. `box.rotation = result.rotation`) see
    // last-feasible too instead of the engine's gesture-start sentinel.
    if (!result.feasible) {
      return UIRotateResult(
        rect: _rect,
        oldRect: result.oldRect,
        delta: result.delta,
        rawSize: Size(_rect.width, _rect.height),
        largestRect: result.largestRect,
        rotation: _rotation,
        boundingRect: _boundingRect,
        oldBoundingRect: result.oldBoundingRect,
        feasible: false,
      );
    }
    _rotation = result.rotation;
    _rect = result.rect;
    _boundingRect = result.boundingRect;
    if (notify) notifyListeners();
    return result;
  }

  /// Called when a rotation gesture ends.
  void onRotateEnd({bool notify = true}) {
    _initialLocalPosition = Offset.zero;
    _initialRect = Rect.zero;
    _initialRotation = 0.0;
    if (notify) notifyListeners();
  }

  /// Called when a rotation gesture is cancelled.
  void onRotateCancel({bool notify = true}) => onRotateEnd(notify: notify);

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
      rotation: _rotation,
      bindingStrategy: _bindingStrategy,
    );

    _rect = result.rect;
    _boundingRect = result.boundingRect;

    if (notify) notifyListeners();
  }

  /// Recalculates the current state of this [rect] to ensure the position is
  /// correct in case of extreme jumps of the [TransformableBox].
  void recalculateSize({bool notify = true}) {
    final UIResizeResult result = UIBoxTransform.resize(
      initialRect: rect,
      initialLocalPosition: initialLocalPosition,
      localPosition: initialLocalPosition,
      clampingRect: clampingRect,
      handle: HandlePosition.bottomRight,
      resizeMode: ResizeMode.scale,
      initialFlip: initialFlip,
      constraints: constraints,
      allowFlipping: allowFlippingWhileResizing,
      rotation: _rotation,
      bindingStrategy: _bindingStrategy,
    );

    _rect = result.rect;
    _boundingRect = result.boundingRect;

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
