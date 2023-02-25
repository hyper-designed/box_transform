import 'dart:ui' as ui;

import 'package:flutter/rendering.dart' as widgets;
import 'package:box_transform/box_transform.dart' as transform;

import 'extensions.dart';
import 'ui_transform_result.dart';

/// A Flutter translation of [transform.BoxTransformer].
class UIBoxTransform {
  /// A private constructor to prevent instantiation.
  const UIBoxTransform._();

  /// The Flutter wrapper for [transform.BoxTransformer.resize].
  static UIResizeResult resize({
    required ui.Rect initialRect,
    required ui.Offset initialLocalPosition,
    required ui.Offset localPosition,
    required transform.HandlePosition handle,
    required transform.ResizeMode resizeMode,
    required transform.Flip initialFlip,
    ui.Rect clampingBox = ui.Rect.largest,
    widgets.BoxConstraints constraints = const widgets.BoxConstraints(),
  }) =>
      transform.BoxTransformer.resize(
        initialBox: initialRect.toBox(),
        initialLocalPosition: initialLocalPosition.toVector2(),
        localPosition: localPosition.toVector2(),
        handle: handle,
        resizeMode: resizeMode,
        initialFlip: initialFlip,
        clampingBox: clampingBox.toBox(),
        constraints: constraints.toConstraints(),
      ).toUI();

  /// The Flutter wrapper for [transform.BoxTransformer.move].
  static UIMoveResult move({
    required ui.Rect initialRect,
    required ui.Offset initialLocalPosition,
    required ui.Offset localPosition,
    ui.Rect clampingBox = ui.Rect.largest,
  }) =>
      transform.BoxTransformer.move(
        initialBox: initialRect.toBox(),
        initialLocalPosition: initialLocalPosition.toVector2(),
        localPosition: localPosition.toVector2(),
        clampingBox: clampingBox.toBox(),
      ).toUI();
}
