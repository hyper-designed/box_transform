import 'dart:math' as math;

import 'package:flutter/rendering.dart';
import 'package:flutter/widgets.dart';

/// A render object that filters pointer hits to the rotated rectangle
/// defined by [unrotatedRectInWorld] rotated by [rotation] radians about
/// its center. Hits in this render box's layout bounds but outside the
/// rotated polygon are rejected; hits inside the polygon fall through to
/// [RenderProxyBox.hitTest] so the child's gesture tree handles them.
///
/// The render box itself is axis-aligned, so its child's gesture
/// coordinates are unaffected. [hitBoxTopLeftInWorld] converts the hit-test
/// local position into the world/parent frame for the containment check.
class RotatedHitGate extends SingleChildRenderObjectWidget {
  /// Creates a hit-gate that lets pointer hits through only when they fall
  /// inside the rotated rectangle defined by [unrotatedRectInWorld] and
  /// [rotation].
  const RotatedHitGate({
    super.key,
    required this.unrotatedRectInWorld,
    required this.rotation,
    required this.hitBoxTopLeftInWorld,
    required Widget super.child,
  });

  /// The unrotated rect in world/parent frame that defines the polygon
  /// when rotated by [rotation] about its center.
  final Rect unrotatedRectInWorld;

  /// Rotation angle in radians, clockwise about [unrotatedRectInWorld]'s
  /// center (matches the library's clockwise-positive convention).
  final double rotation;

  /// This render box's top-left in the world/parent frame. Used to convert
  /// the hit-test local position into world coords before containment.
  final Offset hitBoxTopLeftInWorld;

  @override
  RotatedHitGateRender createRenderObject(BuildContext context) {
    return RotatedHitGateRender(
      unrotatedRectInWorld: unrotatedRectInWorld,
      rotation: rotation,
      hitBoxTopLeftInWorld: hitBoxTopLeftInWorld,
    );
  }

  @override
  void updateRenderObject(
    BuildContext context,
    RotatedHitGateRender renderObject,
  ) {
    renderObject
      ..unrotatedRectInWorld = unrotatedRectInWorld
      ..rotation = rotation
      ..hitBoxTopLeftInWorld = hitBoxTopLeftInWorld;
  }
}

/// Render object backing [RotatedHitGate]. Library-visible so the widget's
/// `createRenderObject` / `updateRenderObject` overrides don't expose a
/// private type in their signatures; not re-exported from the package
/// umbrella, so external callers cannot observe it.
class RotatedHitGateRender extends RenderProxyBox {
  /// Creates a [RotatedHitGateRender].
  RotatedHitGateRender({
    required Rect unrotatedRectInWorld,
    required double rotation,
    required Offset hitBoxTopLeftInWorld,
  })  : _unrotatedRectInWorld = unrotatedRectInWorld,
        _rotation = rotation,
        _hitBoxTopLeftInWorld = hitBoxTopLeftInWorld;

  Rect _unrotatedRectInWorld;
  double _rotation;
  Offset _hitBoxTopLeftInWorld;

  set unrotatedRectInWorld(Rect value) {
    if (value == _unrotatedRectInWorld) return;
    _unrotatedRectInWorld = value;
  }

  set rotation(double value) {
    if (value == _rotation) return;
    _rotation = value;
  }

  set hitBoxTopLeftInWorld(Offset value) {
    if (value == _hitBoxTopLeftInWorld) return;
    _hitBoxTopLeftInWorld = value;
  }

  @override
  bool hitTest(BoxHitTestResult result, {required Offset position}) {
    final Offset worldPos = position + _hitBoxTopLeftInWorld;
    if (!_insideRotatedRect(worldPos)) return false;
    return super.hitTest(result, position: position);
  }

  bool _insideRotatedRect(Offset worldPos) {
    // Fast-path at zero rotation: cos(0)=1, sin(0)=0 makes the inverse-rotate
    // an identity, so the general formula reduces exactly to a rect contains.
    if (_rotation.abs() < 1e-9) {
      return _unrotatedRectInWorld.contains(worldPos);
    }
    final Offset center = _unrotatedRectInWorld.center;
    final double dx = worldPos.dx - center.dx;
    final double dy = worldPos.dy - center.dy;
    final double c = math.cos(-_rotation);
    final double s = math.sin(-_rotation);
    final double localX = c * dx - s * dy + center.dx;
    final double localY = s * dx + c * dy + center.dy;
    return _unrotatedRectInWorld.contains(Offset(localX, localY));
  }
}
