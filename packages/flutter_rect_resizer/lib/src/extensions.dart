import 'dart:ui' as ui;

import 'package:rect_resizer/rect_resizer.dart' as resizer;

import 'ui_resize_result.dart';

extension ResizeResultExt on resizer.ResizeResult {
  UIResizeResult toFlutterResizeResult() {
    return UIResizeResult(
      newRect: newRect.toUiRect(),
      oldRect: oldRect.toUiRect(),
      flip: flip,
      resizeMode: resizeMode,
      delta: delta.toUiOffset(),
      newSize: newSize.toUiSize(),
    );
  }
}

extension ResizerRectExt on resizer.Rect {
  ui.Rect toUiRect() => ui.Rect.fromLTWH(left, top, width, height);
}

extension UIRectExt on ui.Rect {
  resizer.Rect toResizerRect() =>
      resizer.Rect.fromLTRB(left, top, right, bottom);
}

extension ResizerOffsetExt on resizer.Offset {
  ui.Offset toUiOffset() => ui.Offset(dx, dy);
}

extension UIOffsetExt on ui.Offset {
  resizer.Offset toResizerOffset() => resizer.Offset(dx, dy);
}

extension ResizerSizeExt on resizer.Size {
  ui.Size toUiSize() => ui.Size(width, height);
}

extension UISizeExt on ui.Size {
  resizer.Size toResizerSize() => resizer.Size(width, height);
}
