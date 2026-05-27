import 'dart:math' as math;

import 'package:flutter/material.dart';
import 'package:flutter_box_transform/flutter_box_transform.dart';
import 'package:flutter_test/flutter_test.dart';

void main() {
  testWidgets('controller initialized with rotation reports boundingRect',
      (tester) async {
    final controller = TransformableBoxController(
      rect: const Rect.fromLTWH(0, 0, 100, 100),
      rotation: math.pi / 4,
    );
    final expectedBoundingSide = 100 * math.sqrt(2);
    expect(
      controller.boundingRect.width,
      closeTo(expectedBoundingSide, 1e-12),
    );
    expect(
      controller.boundingRect.height,
      closeTo(expectedBoundingSide, 1e-12),
    );
    expect(controller.rotation, closeTo(math.pi / 4, 1e-12));
  });

  test(
      'controller.onDragUpdate under rotation clamps corners into clampingRect',
      () {
    final c = TransformableBoxController(
      rect: const Rect.fromLTWH(0, 0, 100, 100),
      rotation: math.pi / 4,
      clampingRect: const Rect.fromLTRB(-100, -100, 200, 200),
      bindingStrategy: BindingStrategy.boundingBox,
    );
    c.onDragStart(const Offset(50, 50));
    final result = c.onDragUpdate(const Offset(300, 300));
    // BoundingRect tracks the rendered AABB. Must stay within clampingRect.
    expect(result.boundingRect.left, greaterThanOrEqualTo(-100 - 1e-4));
    expect(result.boundingRect.right, lessThanOrEqualTo(200 + 1e-4));
    expect(result.boundingRect.top, greaterThanOrEqualTo(-100 - 1e-4));
    expect(result.boundingRect.bottom, lessThanOrEqualTo(200 + 1e-4));
  });
}
