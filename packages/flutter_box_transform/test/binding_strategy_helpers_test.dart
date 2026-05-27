import 'dart:math' as math;

import 'package:flutter/widgets.dart';
import 'package:flutter_box_transform/flutter_box_transform.dart';
import 'package:flutter_test/flutter_test.dart';

void main() {
  group('RotatedLayout.computeEffectiveContainmentRect (pure function)', () {
    test('boundingBox returns the rotated AABB for rotated rects', () {
      const rect = Rect.fromLTWH(0, 0, 100, 100);
      final ecr = RotatedLayout.computeEffectiveContainmentRect(
        rect: rect,
        rotation: math.pi / 4,
        bindingStrategy: BindingStrategy.boundingBox,
      );
      expect(ecr.width, closeTo(100 * math.sqrt2, 1e-4));
      expect(ecr.height, closeTo(100 * math.sqrt2, 1e-4));
      // Centered at the same point as the unrotated rect.
      expect(ecr.center.dx, closeTo(50, 1e-9));
      expect(ecr.center.dy, closeTo(50, 1e-9));
    });

    test('originalBox returns the unrotated rect unchanged', () {
      const rect = Rect.fromLTWH(10, 20, 100, 80);
      final ecr = RotatedLayout.computeEffectiveContainmentRect(
        rect: rect,
        rotation: math.pi / 3,
        bindingStrategy: BindingStrategy.originalBox,
      );
      expect(ecr, rect);
    });

    test('theta=0 both strategies equal the rect', () {
      const rect = Rect.fromLTWH(5, 5, 80, 60);
      for (final s in BindingStrategy.values) {
        final ecr = RotatedLayout.computeEffectiveContainmentRect(
          rect: rect,
          rotation: 0.0,
          bindingStrategy: s,
        );
        expect(ecr, rect, reason: 'strategy $s at theta=0 must equal rect');
      }
    });
  });

  group('controller.effectiveContainmentRect', () {
    test('boundingBox controller returns rotated AABB', () {
      final c = TransformableBoxController(
        rect: const Rect.fromLTWH(0, 0, 100, 100),
        rotation: math.pi / 4,
        bindingStrategy: BindingStrategy.boundingBox,
      );
      expect(c.effectiveContainmentRect.width, closeTo(100 * math.sqrt2, 1e-4));
      // Same as boundingRect for this strategy.
      expect(c.effectiveContainmentRect, c.boundingRect);
    });

    test('originalBox controller returns unrotated rect', () {
      final c = TransformableBoxController(
        rect: const Rect.fromLTWH(10, 20, 100, 80),
        rotation: math.pi / 3,
        bindingStrategy: BindingStrategy.originalBox,
      );
      expect(c.effectiveContainmentRect, c.rect);
    });
  });

  group('setBindingStrategy reconciliation', () {
    test('reconciles position when switching to a tighter strategy', () {
      // Box at (0, 0, 100, 100), rotation pi/4. Clamp (-100, -100, 100, 100).
      // Under originalBox: rect corners at (0,0), (100,0), (100,100), (0,100)
      //   — last corner is outside clamp.right=100? (100, 100) is at the
      //   clamp boundary. For this geometry, originalBox is basically
      //   at the edge.
      // Under boundingBox: rotated bounding half-width = 70.71, center at
      //   (50, 50). Rotated right-extreme at 50 + 70.71 = 120.71, OUTSIDE
      //   clamp.right=100. So under boundingBox this config is infeasible
      //   — switching to boundingBox must translate the box left so the
      //   rotated bounding fits.
      //   Target center.x = 100 - 70.71 = 29.29, so rect.left = -20.71.
      //   By symmetry, center.y = 29.29, rect.top = -20.71.
      final c = TransformableBoxController(
        rect: const Rect.fromLTWH(0, 0, 100, 100),
        rotation: math.pi / 4,
        clampingRect: const Rect.fromLTRB(-100, -100, 100, 100),
        bindingStrategy: BindingStrategy.originalBox,
      );
      // Sanity: initial rect untouched.
      expect(c.rect.left, 0);
      expect(c.rect.top, 0);

      c.setBindingStrategy(BindingStrategy.boundingBox);

      // Translated to fit rotated bounding in clamp.
      expect(c.rect.left, lessThan(-1),
          reason: 'box must translate when switching to tighter strategy');
      // Size preserved (translate-only reconciliation, no shrink).
      expect(c.rect.width, closeTo(100, 1e-6));
      expect(c.rect.height, closeTo(100, 1e-6));
    });

    test('no-op when new strategy is already satisfied', () {
      // Generous clamp — rect is valid under either strategy; no change.
      final c = TransformableBoxController(
        rect: const Rect.fromLTWH(0, 0, 100, 100),
        rotation: math.pi / 4,
        clampingRect: const Rect.fromLTRB(-500, -500, 500, 500),
        bindingStrategy: BindingStrategy.originalBox,
      );
      final initialRect = c.rect;
      c.setBindingStrategy(BindingStrategy.boundingBox);
      expect(c.rect.left, initialRect.left);
      expect(c.rect.top, initialRect.top);
      expect(c.rect.width, initialRect.width);
      expect(c.rect.height, initialRect.height);
    });

    test('bindingStrategy field reflects the new value', () {
      final c = TransformableBoxController(
        rect: const Rect.fromLTWH(0, 0, 100, 100),
        bindingStrategy: BindingStrategy.originalBox,
      );
      expect(c.bindingStrategy, BindingStrategy.originalBox);
      c.setBindingStrategy(BindingStrategy.boundingBox);
      expect(c.bindingStrategy, BindingStrategy.boundingBox);
    });
  });
}
