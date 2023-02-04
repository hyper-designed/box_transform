import 'dart:ui' as ui;

import 'package:rect_resizer/rect_resizer.dart' as resizer;
import 'package:vector_math/vector_math.dart';

import 'ui_resize_result.dart';

extension ResizeResultExt on resizer.ResizeResult {
  UIResizeResult toFlutterResizeResult() {
    return UIResizeResult(
      newRect: newRect.toUiRect(),
      oldRect: oldRect.toUiRect(),
      flip: flip,
      resizeMode: resizeMode,
      delta: delta.toUiVector2(),
      newSize: newSize.toUiSize(),
    );
  }
}

extension ResizerRectExt on resizer.Box {
  ui.Rect toUiRect() => ui.Rect.fromLTWH(left, top, width, height);
}

extension UIRectExt on ui.Rect {
  resizer.Box toResizerRect() =>
      resizer.Box.fromLTRB(left, top, right, bottom);
}

extension ResizerVector2Ext on Vector2 {
  ui.Offset toUiVector2() => ui.Offset(x, y);
}

extension UIVector2Ext on ui.Offset {
  Vector2 toResizerVector2() => Vector2(dx, dy);
}

extension ResizerSizeExt on resizer.Dimension {
  ui.Size toUiSize() => ui.Size(width, height);
}

extension UISizeExt on ui.Size {
  resizer.Dimension toResizerSize() => resizer.Dimension(width, height);
}
