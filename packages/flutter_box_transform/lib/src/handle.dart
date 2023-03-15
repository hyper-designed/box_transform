import 'package:flutter/material.dart';

import '../flutter_box_transform.dart';

/// Default width of the border of the handles.
const kDefaultHandleBorderWidth = 1.5;

/// A circular handle in the corners of the box.
class DefaultCornerHandle extends StatelessWidget {
  /// The position of the corner handle.
  final HandlePosition handle;

  /// Decoration of the handle. Default decoration has
  /// [Theme.scaffoldBackgroundColor] as color, [BoxShape.circle] as shape and
  /// [Theme.colorScheme.primary] as border color with a width of 1.5.
  final Decoration? decoration;

  /// The size of the visible handle UI. This is different than
  /// [TransformableBox.handleSize] which is the size of the handle area
  /// that is used to detect the handle interaction.
  final double size;

  /// Creates a new circular corner handle.
  const DefaultCornerHandle({
    super.key,
    required this.handle,
    this.decoration,
    this.size = 12,
  });

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Container(
        width: size,
        height: size,
        decoration: decoration ?? defaultDecoration(context),
      ),
    );
  }

  /// Default decoration of the handle.
  static Decoration defaultDecoration(BuildContext context) {
    return BoxDecoration(
      color: Theme.of(context).scaffoldBackgroundColor,
      shape: BoxShape.circle,
      border: Border.all(
        color: Theme.of(context).colorScheme.primary,
        width: kDefaultHandleBorderWidth,
      ),
    );
  }
}

/// A rounded handle in the sides of the box.
class DefaultSideHandle extends StatelessWidget {
  /// The position of the side handle.
  final HandlePosition handle;

  /// Decoration of the handle. Default decoration has
  /// [Theme.scaffoldBackgroundColor] as color, [StadiumBorder] as shape and
  /// [Theme.colorScheme.primary] as border color with a width of 1.5.
  final Decoration? decoration;

  /// The length of the handle. This is width if the handle is horizontal and
  /// height if the handle is vertical.
  final double length;

  /// The thickness of the handle. This is height if the handle is horizontal
  /// and width if the handle is vertical.
  final double thickness;

  /// Creates a new rounded side handle.
  const DefaultSideHandle({
    super.key,
    required this.handle,
    this.decoration,
    this.length = 32,
    this.thickness = 10,
  });

  @override
  Widget build(BuildContext context) {
    return Center(
      child: LayoutBuilder(
        builder: (context, constraints) {
          final constrainedSide = handle.isHorizontal
              ? constraints.maxHeight
              : constraints.maxWidth;
          if (constrainedSide < length / 3) return const SizedBox.shrink();

          return Container(
            constraints: BoxConstraints(
              maxWidth: handle.isHorizontal ? thickness : length,
              maxHeight: handle.isHorizontal ? length : thickness,
            ),
            decoration: decoration ?? defaultDecoration(context),
          );
        },
      ),
    );
  }

  /// Default decoration of the handle.
  static Decoration defaultDecoration(BuildContext context) {
    return ShapeDecoration(
      color: Theme.of(context).scaffoldBackgroundColor,
      shape: StadiumBorder(
        side: BorderSide(
          color: Theme.of(context).colorScheme.primary,
          width: kDefaultHandleBorderWidth,
        ),
      ),
    );
  }
}
