import 'dart:ui' as ui;

import 'package:flutter/rendering.dart' as widgets;
import 'package:box_transform/box_transform.dart' as transform;
import 'package:vector_math/vector_math.dart';

import 'ui_transform_result.dart';

extension ResizeResultExt on transform.ResizeResult {
  /// Converts a `ResizeResult` from `rect_resizer` to a `UIResizeResult`
  UIResizeResult toUI() {
    return UIResizeResult(
      /// Creates a new `UIResizeResult` instance with the converted data
      newRect: newBox.toRect(),
      oldRect: oldBox.toRect(),
      flip: flip,
      resizeMode: resizeMode,
      delta: delta.toOffset(),
      newSize: newSize.toSize(),
      minWidthReached: minWidthReached,
      minHeightReached: minHeightReached,
      maxWidthReached: maxWidthReached,
      maxHeightReached: maxHeightReached,
    );
  }
}

extension MoveResultExt on transform.MoveResult {
  /// Converts a `MoveResult` from `rect_resizer` to a `UIMoveResult`
  UIMoveResult toUI() {
    return UIMoveResult(
      /// Creates a new `UIMoveResult` instance with the converted data
      newRect: newBox.toRect(),
      oldRect: oldBox.toRect(),
      delta: delta.toOffset(),
    );
  }
}

extension BoxExt on transform.Box {
  /// Converts a `Box` from `rect_resizer` to a `ui.Rect`
  ui.Rect toRect() => ui.Rect.fromLTWH(left, top, width, height);
}

extension RectExt on ui.Rect {
  /// Converts a `ui.Rect` to a `Box` from `rect_resizer`
  transform.Box toBox() => transform.Box.fromLTRB(left, top, right, bottom);
}

extension Vector2Ext on Vector2 {
  /// Converts a `Vector2` from `vector_math` to a `ui.Offset`
  ui.Offset toOffset() => ui.Offset(x, y);
}

extension UIVector2Ext on ui.Offset {
  /// Converts a `ui.Offset` to a `Vector2` from `vector_math`
  Vector2 toVector2() => Vector2(dx, dy);
}

extension DimensionExt on transform.Dimension {
  /// Converts a `Dimension` from `rect_resizer` to a `ui.Size`
  ui.Size toSize() => ui.Size(width, height);
}

extension SizeExt on ui.Size {
  /// Converts a `ui.Size` to a `Dimension` from `rect_resizer`
  transform.Dimension toDimension() => transform.Dimension(width, height);
}

extension BoxConstraitnsExt on widgets.BoxConstraints {
  /// Converts a `BoxConstraints` from `flutter/rendering` to a `Constraints` from `rect_resizer`
  transform.Constraints toConstraints() => transform.Constraints(
        minWidth: minWidth,
        maxWidth: maxWidth,
        minHeight: minHeight,
        maxHeight: maxHeight,
      );
}

extension ConstraintsExt on transform.Constraints {
  /// Converts a `Constraints` from `rect_resizer` to a `BoxConstraints` from `flutter/rendering`
  widgets.BoxConstraints toBoxConstraints() => widgets.BoxConstraints(
        minWidth: minWidth,
        maxWidth: maxWidth,
        minHeight: minHeight,
        maxHeight: maxHeight,
      );
}
