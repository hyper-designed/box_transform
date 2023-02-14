import 'dart:ui' as ui;
import 'package:flutter/rendering.dart' as widgets;

import 'package:rect_resizer/rect_resizer.dart' as resizer;
import 'package:vector_math/vector_math.dart';

import 'ui_resize_result.dart';

extension ResizeResultExt on resizer.ResizeResult {
  /// Converts a `ResizeResult` from `rect_resizer` to a `UIResizeResult`
  UIResizeResult toFlutterResizeResult() {
    return UIResizeResult(
      /// Creates a new `UIResizeResult` instance with the converted data
      newRect: newBox.toUiRect(),
      oldRect: oldBox.toUiRect(),
      flip: flip,
      resizeMode: resizeMode,
      delta: delta.toUiVector2(),
      newSize: newSize.toUiSize(),
    );
  }
}

extension MoveResultExt on resizer.MoveResult {
  /// Converts a `MoveResult` from `rect_resizer` to a `UIMoveResult`
  UIMoveResult toFlutterMoveResult() {
    return UIMoveResult(
      /// Creates a new `UIMoveResult` instance with the converted data
      newRect: newRect.toUiRect(),
      oldRect: oldRect.toUiRect(),
      delta: delta.toUiVector2(),
    );
  }
}

extension ResizerRectExt on resizer.Box {
  /// Converts a `Box` from `rect_resizer` to a `ui.Rect`
  ui.Rect toUiRect() => ui.Rect.fromLTWH(left, top, width, height);
}

extension UIRectExt on ui.Rect {
  /// Converts a `ui.Rect` to a `Box` from `rect_resizer`
  resizer.Box toResizerBox() => resizer.Box.fromLTRB(left, top, right, bottom);
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

extension UIConstraitnsExt on widgets.BoxConstraints {
  /// Converts a `BoxConstraints` from `flutter/rendering` to a `Constraints` from `rect_resizer`
  resizer.Constraints toResizerConstraints() =>
      resizer.Constraints(
        minWidth: minWidth,
        maxWidth: maxWidth,
        minHeight: minHeight,
        maxHeight: maxHeight,
      );
}

extension ResizerConstraintsExt on resizer.Constraints {
  /// Converts a `Constraints` from `rect_resizer` to a `BoxConstraints` from `flutter/rendering`
  widgets.BoxConstraints toUIBoxConstraints() =>
      widgets.BoxConstraints(
        minWidth: minWidth,
        maxWidth: maxWidth,
        minHeight: minHeight,
        maxHeight: maxHeight,
      );
}