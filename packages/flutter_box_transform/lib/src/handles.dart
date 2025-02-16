import 'dart:math';

import 'package:box_transform/box_transform.dart';
import 'package:flutter/material.dart';

import 'transformable_box.dart';

/// Default width of the border of the handles.
const kDefaultHandleBorderWidth = 1.5;

/// Alignment of the handle.
enum HandleAlignment {
  /// The handle is completely inside the box corner/side.
  inside,

  /// The handle is completely outside the box corner/side.
  outside,

  /// The handle is in the center of the box corner/side. This means that the
  /// center of the handle is at the center of the box corner/side.
  center;

  /// Whether handle align is inside or not.
  bool get isInside => this == HandleAlignment.inside;

  /// Whether handle align is outside or not.
  bool get isOutside => this == HandleAlignment.outside;

  /// Whether handle align is center or not.
  bool get isCenter => this == HandleAlignment.center;

  /// Returns offset of the handle from the box corner/side.
  double offset(double handleSize) {
    switch (this) {
      case HandleAlignment.inside:
        return 0;
      case HandleAlignment.outside:
        return handleSize;
      case HandleAlignment.center:
        return handleSize / 2;
    }
  }
}

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

/// A handle that looks like corner/side brackets on a box.
class AngularHandle extends StatelessWidget {
  /// The position of the corner handle.
  final HandlePosition handle;

  /// The color of the handle. Defaults to [Theme.colorScheme.primary].
  final Color? color;

  /// The length of the handle.
  final double length;

  /// The thickness of the handle.
  final double thickness;

  /// Whether the handle has a shadow.
  final bool hasShadow;

  /// Creates a new angular corner handle.
  const AngularHandle({
    super.key,
    required this.handle,
    this.length = 32,
    this.thickness = 5,
    this.color,
    this.hasShadow = true,
  });

  @override
  Widget build(BuildContext context) {
    final handleAlignment =
        TransformableBox.widgetOf(context)?.handleAlignment ??
            HandleAlignment.outside;
    return LayoutBuilder(
      builder: (context, constraints) {
        return Container(
          constraints: BoxConstraints(
            maxWidth: handle.isHorizontal ? thickness : length,
            maxHeight: handle.isHorizontal ? length : thickness,
          ),
          child: CustomPaint(
            painter: AngularHandlePainter(
              color: color ?? Theme.of(context).colorScheme.primary,
              thickness: thickness,
              handle: handle,
              hasShadow: hasShadow,
              handleAlign: handleAlignment,
              length: min(
                length,
                handle.isHorizontal
                    ? constraints.maxHeight
                    : constraints.maxWidth,
              ),
            ),
          ),
        );
      },
    );
  }
}

/// A painter for the [AngularHandle].
class AngularHandlePainter extends CustomPainter {
  /// The thickness of the handle.
  final double thickness;

  /// The color of the handle.
  final Color color;

  /// The position of the handle.
  final HandlePosition handle;

  /// The length of the handle.
  final double length;

  /// Whether the handle has a shadow.
  final bool hasShadow;

  /// Paint for the stroke of the handle.
  final Paint strokePaint;

  /// Paint for the shadow of the handle.
  final Paint shadowPaint;

  /// The alignment of the handle.
  final HandleAlignment handleAlign;

  /// Creates a new handle painter.
  AngularHandlePainter({
    this.thickness = 4,
    this.color = Colors.white,
    required this.handle,
    this.length = 32,
    this.hasShadow = true,
    this.handleAlign = HandleAlignment.inside,
  })  : strokePaint = Paint()
          ..color = color
          ..strokeWidth = thickness
          ..strokeJoin = StrokeJoin.miter
          ..strokeCap = StrokeCap.round
          ..style = PaintingStyle.stroke,
        shadowPaint = Paint()
          ..color = Colors.black.withValues(alpha: 0.15)
          ..strokeWidth = thickness + 1
          ..strokeJoin = StrokeJoin.miter
          ..strokeCap = StrokeCap.round
          ..maskFilter = const MaskFilter.blur(BlurStyle.normal, 1)
          ..style = PaintingStyle.stroke;

  @override
  void paint(Canvas canvas, Size size) {
    Path path = getPath(size);
    canvas.drawPath(path, strokePaint);
    if (!hasShadow) return;
    canvas.drawPath(path, shadowPaint);
  }

  /// Creates path for the handle based on the handle position.
  Path getPath(Size size) {
    final double length = this.length - thickness;
    final origin = getCenter(size, handle, handleAlign, thickness);

    Path path = Path()..moveTo(origin.dx, origin.dy);

    if (handle == HandlePosition.topLeft) {
      path
        ..relativeMoveTo(0, length)
        ..relativeLineTo(0, -length)
        ..relativeLineTo(length, 0);
    } else if (handle == HandlePosition.topRight) {
      path
        ..relativeMoveTo(size.width - length, 0)
        ..relativeLineTo(length, 0)
        ..relativeLineTo(0, length);
    } else if (handle == HandlePosition.bottomLeft) {
      path
        ..relativeMoveTo(0, size.height - length)
        ..relativeLineTo(0, length)
        ..relativeLineTo(length, 0);
    } else if (handle == HandlePosition.bottomRight) {
      path
        ..relativeMoveTo(size.width - length, size.height)
        ..relativeLineTo(length, 0)
        ..relativeLineTo(0, -length);
    } else if (handle == HandlePosition.right) {
      path
        ..relativeMoveTo(0, -length / 2)
        ..relativeLineTo(0, length);
    } else if (handle == HandlePosition.left) {
      path
        ..relativeMoveTo(0, -length / 2)
        ..relativeLineTo(0, length);
    } else if (handle == HandlePosition.top) {
      path
        ..relativeMoveTo(-length / 2, 0)
        ..relativeLineTo(length, 0);
    } else if (handle == HandlePosition.bottom) {
      path
        ..relativeMoveTo(-length / 2, 0)
        ..relativeLineTo(length, 0);
    }
    return path;
  }

  /// Gets the center point for given [handle] and [handleAlign] with given [size].
  Offset getCenter(
    Size size,
    HandlePosition handle,
    HandleAlignment handleAlign,
    double thickness,
  ) {
    final multiplier = handleAlign.isInside
        ? 1
        : handleAlign.isOutside
            ? -1
            : 0;
    Offset offset;
    switch (handle) {
      case HandlePosition.none:
        throw ArgumentError('HandlePosition.none is not supported!');
      case HandlePosition.topLeft:
      case HandlePosition.topRight:
      case HandlePosition.bottomLeft:
      case HandlePosition.bottomRight:
        Offset offset = Offset.zero.translate(
          handleAlign.offset(size.width),
          handleAlign.offset(size.height),
        );
        offset = offset.translate(
          thickness / 2 * multiplier,
          thickness / 2 * multiplier,
        );
        return offset.scale(
          handle.influencesRight ? -1 : 1,
          handle.influencesBottom ? -1 : 1,
        );
      case HandlePosition.top:
        offset = Offset(
          size.width / 2,
          handleAlign.offset(size.height),
        );
        return offset.translate(0, thickness / 2 * multiplier);
      case HandlePosition.bottom:
        offset = Offset(
          size.width / 2,
          size.height - handleAlign.offset(size.height),
        );
        return offset.translate(0, -thickness / 2 * multiplier);
      case HandlePosition.left:
        offset = Offset(
          handleAlign.offset(size.width),
          size.height / 2,
        );
        return offset.translate(thickness / 2 * multiplier, 0);
      case HandlePosition.right:
        offset = Offset(
          size.width - handleAlign.offset(size.width),
          size.height / 2,
        );
        return offset.translate(-thickness / 2 * multiplier, 0);
    }
  }

  @override
  bool shouldRepaint(covariant AngularHandlePainter oldDelegate) =>
      thickness != oldDelegate.thickness ||
      color != oldDelegate.color ||
      handle != oldDelegate.handle ||
      length != oldDelegate.length ||
      hasShadow != oldDelegate.hasShadow ||
      handleAlign != oldDelegate.handleAlign;
}
