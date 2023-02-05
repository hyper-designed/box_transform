import 'package:flutter/material.dart';

import '../flutter_rect_resizer.dart';

typedef ResizeModeDecisionCallback = ResizeMode Function(
    ResizableBoxController controller);

ResizeMode _defaultResizeModeDecision(ResizableBoxController controller) {
  if (controller.isAltPressed && controller.isShiftPressed) {
    return ResizeMode.symmetricScale;
  } else if (controller.isAltPressed) {
    return ResizeMode.symmetric;
  } else if (controller.isShiftPressed) {
    return ResizeMode.scale;
  } else {
    return ResizeMode.freeform;
  }
}

class ResizableBoxController extends ChangeNotifier {
  final UIRectResizer resizer = UIRectResizer();

  final FocusScopeNode focusNode;
  final ResizeModeDecisionCallback? resizeModeDecider;

  ResizableBoxController({
    FocusScopeNode? focusNode,
    ResizeModeDecisionCallback? resizeModeDecisionCallback,
  })  : focusNode = focusNode ?? FocusScopeNode(),
        resizeModeDecider =
            resizeModeDecisionCallback ?? _defaultResizeModeDecision;

  /// Keep track of the keys that are currently pressed to change
  /// the resize mode.
  List<String> pressedKeys = [];

  bool get isAltPressed => pressedKeys.contains('ALT');

  bool get isShiftPressed => pressedKeys.contains('SHIFT');

  Rect box = Rect.zero;
  bool hasFocus = true;
  Flip flip = Flip.none;

  Offset initialLocalPosition = Offset.zero;
  Rect initialRect = Rect.zero;
  Flip initialFlip = Flip.none;

  void updateRect(Rect box) {
    this.box = box;
    notifyListeners();
  }

  void updateFlip(Flip flip) {
    this.flip = flip;
    notifyListeners();
  }

  void updateHasFocus(bool hasFocus) {
    this.hasFocus = hasFocus;
    notifyListeners();
  }

  void updateInitialLocalPosition(Offset initialLocalPosition) {
    this.initialLocalPosition = initialLocalPosition;
    notifyListeners();
  }

  void updateInitialRect(Rect initialRect) {
    this.initialRect = initialRect;
    notifyListeners();
  }

  void updateInitialFlip(Flip initialFlip) {
    this.initialFlip = initialFlip;
    notifyListeners();
  }

  void updatePressedKeys(List<String> pressedKeys) {
    this.pressedKeys = pressedKeys;
    notifyListeners();
  }

  void onDragUpdate(details) {
    // TODO: implement dragging feature in the package.
    box = box.shift(details.delta);
    notifyListeners();
  }

  void onResizeStart(DragStartDetails details) {
    initialLocalPosition = details.localPosition;
    initialRect = box;
    initialFlip = flip;
  }

  void onResizeUpdate(DragUpdateDetails details, HandlePosition handle) {
    final UIResizeResult result = resizer.resize(
      initialRect: initialRect,
      initialLocalPosition: initialLocalPosition,
      localPosition: details.localPosition,
      handle: handle,
      resizeMode: resizeModeDecider!(this),
      initialFlip: initialFlip,
    );

    box = result.newRect;
    flip = result.flip;

    notifyListeners();
  }

  void onResizeEnd(DragEndDetails details) {
    initialLocalPosition = Offset.zero;
    initialRect = Rect.zero;
    initialFlip = Flip.none;

    notifyListeners();
  }

  KeyEventResult onKeyEvent(FocusNode node, RawKeyEvent event) {
    bool changed = false;
    bool handled = false;

    // SHIFT
    if (!pressedKeys.contains('SHIFT') &&
        event.isShiftPressed &&
        focusNode.hasPrimaryFocus) {
      pressedKeys.insert(0, 'SHIFT');
      changed = true;
      handled = true;
    } else if (!event.isShiftPressed && pressedKeys.contains('SHIFT')) {
      pressedKeys.remove('SHIFT');
      changed = true;
      handled = true;
    } else if (event.isShiftPressed && pressedKeys.contains('SHIFT')) {
      handled = true;
    }

    // ALT
    if (!pressedKeys.contains('ALT') &&
        event.isAltPressed &&
        focusNode.hasPrimaryFocus) {
      pressedKeys.add('ALT');
      changed = true;
      handled = true;
    } else if (!event.isAltPressed && pressedKeys.contains('ALT')) {
      pressedKeys.remove('ALT');
      changed = true;
      handled = true;
    } else if (event.isAltPressed && pressedKeys.contains('ALT')) {
      handled = true;
    }

    if (changed) notifyListeners();

    return handled && focusNode.hasPrimaryFocus
        ? KeyEventResult.handled
        : KeyEventResult.ignored;
  }
}
