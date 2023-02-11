import 'dart:ui' as ui;

import 'package:flutter/rendering.dart' as widgets;
import 'package:rect_resizer/rect_resizer.dart' as resizer;

import 'extensions.dart';
import 'ui_resize_result.dart';

/// A Flutter translation of [resizer.RectResizer].
class UIRectResizer {
  final resizer.RectResizer _resizer = resizer.RectResizer();

  UIResizeResult resize({
    required ui.Rect initialRect,
    required ui.Offset initialLocalPosition,
    required ui.Offset localPosition,
    required resizer.HandlePosition handle,
    required resizer.ResizeMode resizeMode,
    required resizer.Flip initialFlip,
    ui.Rect clampingBox = ui.Rect.largest,
    widgets.BoxConstraints constraints = const widgets.BoxConstraints(),
  }) =>
      _resizer
          .resize(
            initialRect: initialRect.toResizerBox(),
            initialLocalPosition: initialLocalPosition.toResizerVector2(),
            localPosition: localPosition.toResizerVector2(),
            handle: handle,
            resizeMode: resizeMode,
            initialFlip: initialFlip,
            clampingBox: clampingBox.toResizerBox(),
            constraints: constraints.toResizerConstraints(),
          )
          .toFlutterResizeResult();

  UIMoveResult move({
    required ui.Rect initialRect,
    required ui.Offset initialLocalPosition,
    required ui.Offset localPosition,
    ui.Rect clampingBox = ui.Rect.largest,
  }) =>
      _resizer
          .move(
            initialRect: initialRect.toResizerBox(),
            initialLocalPosition: initialLocalPosition.toResizerVector2(),
            localPosition: localPosition.toResizerVector2(),
            clampingBox: clampingBox.toResizerBox(),
          )
          .toFlutterMoveResult();
}
