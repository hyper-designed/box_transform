import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

import '../flutter_rect_resizer.dart';

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
/// [ResizableBoxController] constructor.
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

/// A controller class that is used to control the [ResizableBox] widget.
class ResizableBoxController extends ChangeNotifier {
  /// The [UIRectResizer] instance that is used to resize the [Rect] of the
  /// [ResizableBox].
  final UIRectResizer resizer = UIRectResizer();

  /// The callback function that is used to resolve the [ResizeMode] based on
  /// the pressed keys on the keyboard.
  final ResolveResizeModeCallback? resolveResizeModeCallback;

  /// Creates a [ResizableBoxController] instance.
  ResizableBoxController({
    this.resolveResizeModeCallback = defaultResolveResizeModeCallback,
  });

  /// The current [Rect] of the [ResizableBox].
  Rect box = Rect.zero;

  /// The current [Flip] of the [ResizableBox].
  Flip flip = Flip.none;

  /// The initial [Offset] of the [ResizableBox] when the resizing starts.
  Offset initialLocalPosition = Offset.zero;

  /// The initial [Rect] of the [ResizableBox] when the resizing starts.
  Rect initialRect = Rect.zero;

  /// The initial [Flip] of the [ResizableBox] when the resizing starts.
  Flip initialFlip = Flip.none;

  /// Sets the current [box] of the [ResizableBox].
  void setRect(Rect box) {
    this.box = box;
    notifyListeners();
  }

  /// Sets the current [flip] of the [ResizableBox].
  void setFlip(Flip flip) {
    this.flip = flip;
    notifyListeners();
  }

  /// Sets the initial local position of the [ResizableBox].
  void setInitialLocalPosition(Offset initialLocalPosition) {
    this.initialLocalPosition = initialLocalPosition;
    notifyListeners();
  }

  /// Sets the initial [Rect] of the [ResizableBox].
  void setInitialRect(Rect initialRect) {
    this.initialRect = initialRect;
    notifyListeners();
  }

  /// Sets the initial [Flip] of the [ResizableBox].
  void setInitialFlip(Flip initialFlip) {
    this.initialFlip = initialFlip;
    notifyListeners();
  }

  /// Called when the [ResizableBox] is dragged.
  Rect onDragUpdate(details, {bool notify = true}) {
    // TODO: implement dragging feature in the package.
    box = box.shift(details.delta);
    if (notify) notifyListeners();
    return box;
  }

  /// Called when the resizing starts on [ResizableBox].
  void onResizeStart(DragStartDetails details) {
    initialLocalPosition = details.localPosition;
    initialRect = box;
    initialFlip = flip;
  }

  /// Called when the [ResizableBox] is being resized.
  UIResizeResult onResizeUpdate(
    DragUpdateDetails details,
    HandlePosition handle, {
    bool notify = true,
  }) {
    // Calculate the new rect based on the initial rect, initial local position,
    final UIResizeResult result = resizer.resize(
      initialRect: initialRect,
      initialLocalPosition: initialLocalPosition,
      localPosition: details.localPosition,
      handle: handle,
      resizeMode: resolveResizeModeCallback!(),
      initialFlip: initialFlip,
    );

    box = result.newRect;
    flip = result.flip;

    if (notify) notifyListeners();
    return result;
  }

  /// Called when the resizing ends on [ResizableBox].
  void onResizeEnd(DragEndDetails details) {
    initialLocalPosition = Offset.zero;
    initialRect = Rect.zero;
    initialFlip = Flip.none;

    notifyListeners();
  }
}
