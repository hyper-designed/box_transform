import 'dart:ui' as ui;

import 'package:box_transform/box_transform.dart' as transform;
import 'package:flutter/rendering.dart' as widgets;

import '../flutter_box_transform.dart';

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
    ui.Rect clampingRect = ui.Rect.largest,
    widgets.BoxConstraints constraints = const widgets.BoxConstraints(),
    bool flipRect = true,
  }) =>
      transform.BoxTransformer.resize(
        initialBox: initialRect.toBox(),
        initialLocalPosition: initialLocalPosition.toVector2(),
        localPosition: localPosition.toVector2(),
        handle: handle,
        resizeMode: resizeMode,
        initialFlip: initialFlip,
        clampingRect: clampingRect.toBox(),
        constraints: constraints.toConstraints(),
        allowFlipping: flipRect,
      ).toUI();

  /// The Flutter wrapper for [transform.BoxTransformer.move].
  static UIMoveResult move({
    required ui.Rect initialRect,
    required ui.Offset initialLocalPosition,
    required ui.Offset localPosition,
    ui.Rect clampingRect = ui.Rect.largest,
  }) =>
      transform.BoxTransformer.move(
        initialBox: initialRect.toBox(),
        initialLocalPosition: initialLocalPosition.toVector2(),
        localPosition: localPosition.toVector2(),
        clampingRect: clampingRect.toBox(),
      ).toUI();
}
