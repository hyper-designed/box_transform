import 'dart:ui' as ui;

import 'package:rect_resizer/rect_resizer.dart' as resizer;
import 'package:vector_math/vector_math.dart';

import 'ui_resize_result.dart';

extension ResizeResultExt on resizer.ResizeResult {
  /// Converts a `ResizeResult` from `rect_resizer` to a `UIResizeResult`
  UIResizeResult toFlutterResizeResult() {
    return UIResizeResult(
      /// Creates a new `UIResizeResult` instance with the converted data
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
  /// Converts a `Box` from `rect_resizer` to a `ui.Rect`
  ui.Rect toUiRect() => ui.Rect.fromLTWH(left, top, width, height);
}

extension UIRectExt on ui.Rect {
  /// Converts a `ui.Rect` to a `Box` from `rect_resizer`
  resizer.Box toResizerRect() =>
      resizer.Box.fromLTRB(left, top, right, bottom);
}

extension ResizerVector2Ext on Vector2 {
  /// Converts a `Vector2` from `vector_math` to a `ui.Offset`
  ui.Offset toUiVector2() => ui.Offset(x, y);
}

extension UIVector2Ext on ui.Offset {
  /// Converts a `ui.Offset` to a `Vector2` from `vector_math`
  Vector2 toResizerVector2() => Vector2(dx, dy);
}

extension ResizerSizeExt on resizer.Dimension {
  /// Converts a `Dimension` from `rect_resizer` to a `ui.Size`
  ui.Size toUiSize() => ui.Size(width, height);
}

extension UISizeExt on ui.Size {
  /// Converts a `ui.Size` to a `Dimension` from `rect_resizer`
  resizer.Dimension toResizerSize() => resizer.Dimension(width, height);
}
