library resize_handlers;

import 'dart:math';

import '../../box_transform.dart';

part 'freeform_resizing.dart';

part 'scale_resizing.dart';

part 'symmetric_resizing.dart';

part 'symmetric_scale_resizing.dart';

/// An abstract class the provides a common interface for all resize modes.
sealed class ResizeHandler {
  /// A default constructor for [ResizeHandler].
  const ResizeHandler();

  /// Creates a [ResizeHandler] from the given [mode].
  factory ResizeHandler.from(ResizeMode mode) => switch (mode) {
        ResizeMode.freeform => const FreeformResizeHandler(),
        ResizeMode.scale => const ScaleResizeHandler(),
        ResizeMode.symmetric => const SymmetricResizeHandler(),
        ResizeMode.symmetricScale => const SymmetricScaleResizeHandler(),
      };

  /// Resizes the given [explodedRect] to fit within the [clampingRect].
  ///
  /// Specifying the [handle] will determine how the [explodedRect] will be
  /// resized.
  ///
  /// The [initialRect] helps determine the initial state of the rectangle.
  ///
  /// The [clampingRect] is the box that the [explodedRect] is not allowed
  /// to go outside of when dragging or resizing.
  ///
  /// The [constraints] is the constraints that the [explodedRect] is not
  /// allowed to shrink or grow beyond.
  ({Box rect, Box largest, bool hasValidFlip}) resize({
    required Box initialRect,
    required Box explodedRect,
    required Box clampingRect,
    required HandlePosition handle,
    required Constraints constraints,
    required Flip flip,
  });
}
