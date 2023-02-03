import 'dart:ui' as ui;

import 'extensions.dart';
import 'package:rect_resizer/rect_resizer.dart' as resizer;

import 'ui_resize_result.dart';

class UIRectResizer {
  final resizer.RectResizer _resizer = resizer.RectResizer();

  UIResizeResult resize({
    required ui.Rect initialRect,
    required ui.Offset initialLocalPosition,
    required ui.Offset localPosition,
    required resizer.HandlePosition handle,
    required resizer.ResizeMode resizeMode,
    required resizer.Flip initialFlip,
  }) =>
      _resizer
          .resize(
            initialRect: initialRect.toResizerRect(),
            initialLocalPosition: initialLocalPosition.toResizerOffset(),
            localPosition: localPosition.toResizerOffset(),
            handle: handle,
            resizeMode: resizeMode,
            initialFlip: initialFlip,
          )
          .toFlutterResizeResult();
}
