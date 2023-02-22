import 'dart:ui' as ui;

import 'package:flutter/rendering.dart' as widgets;
import 'package:rect_resizer/rect_resizer.dart' as resizer;

import 'extensions.dart';
import 'ui_resize_result.dart';

/// A Flutter translation of [resizer.RectResizer].
class UIRectResizer {

  /// A private constructor to prevent instantiation.
  const UIRectResizer._();

  /// The Flutter wrapper for [resizer.RectResizer.resize].
  static UIResizeResult resize({
    required ui.Rect initialRect,
    required ui.Offset initialLocalPosition,
    required ui.Offset localPosition,
    required resizer.HandlePosition handle,
    required resizer.ResizeMode resizeMode,
    required resizer.Flip initialFlip,
    ui.Rect clampingBox = ui.Rect.largest,
    widgets.BoxConstraints constraints = const widgets.BoxConstraints(),
  }) =>
      resizer.RectResizer.resize(
        initialBox: initialRect.toResizerBox(),
        initialLocalPosition: initialLocalPosition.toResizerVector2(),
        localPosition: localPosition.toResizerVector2(),
        handle: handle,
        resizeMode: resizeMode,
        initialFlip: initialFlip,
        clampingBox: clampingBox.toResizerBox(),
        constraints: constraints.toResizerConstraints(),
      ).toFlutterResizeResult();

  /// The Flutter wrapper for [resizer.RectResizer.move].
  static UIMoveResult move({
    required ui.Rect initialRect,
    required ui.Offset initialLocalPosition,
    required ui.Offset localPosition,
    ui.Rect clampingBox = ui.Rect.largest,
  }) =>
      resizer.RectResizer.move(
        initialBox: initialRect.toResizerBox(),
        initialLocalPosition: initialLocalPosition.toResizerVector2(),
        localPosition: localPosition.toResizerVector2(),
        clampingBox: clampingBox.toResizerBox(),
      ).toFlutterMoveResult();
}
