import 'dart:math' as math;

import 'package:flutter/material.dart';
import 'package:flutter_box_transform/flutter_box_transform.dart';
import 'package:flutter_test/flutter_test.dart';

void main() {
  TestWidgetsFlutterBinding.ensureInitialized();
  group('TransformableBoxController rotation gestures', () {
    test('onRotateStart snapshots current rotation into initialRotation', () {
      final c = TransformableBoxController(
        rect: const Rect.fromLTWH(0, 0, 100, 100),
        rotation: 0.3,
      );
      c.onRotateStart(const Offset(100, 50));
      expect(c.initialRotation, closeTo(0.3, 1e-9));
      expect(c.initialLocalPosition, const Offset(100, 50));
    });

    test('onRotateUpdate advances rotation additively from initialRotation',
        () {
      final c = TransformableBoxController(
        rect: const Rect.fromLTWH(-50, -50, 100, 100),
        rotation: 0.0,
      );
      // Center is (0,0). Pointer goes from (+X) to (+Y) = +pi/2.
      c.onRotateStart(const Offset(100, 0));
      c.onRotateUpdate(const Offset(0, 100), HandlePosition.bottomRight);
      expect(c.rotation, closeTo(math.pi / 2, 1e-6));
    });

    test('onRotateEnd clears gesture state', () {
      final c = TransformableBoxController(
        rect: const Rect.fromLTWH(0, 0, 100, 100),
        rotation: 0.0,
      );
      c.onRotateStart(const Offset(100, 50));
      c.onRotateEnd();
      expect(c.initialRotation, 0.0);
      expect(c.initialRect, Rect.zero);
      expect(c.initialLocalPosition, Offset.zero);
    });

    test('onRotateUpdate freezes rotation when clamp cannot fit the angle', () {
      // 100×100 box exactly filling a 100×100 clamp. Any non-cardinal
      // rotation (here π/4) inflates the AABB beyond the clamp, and no
      // translation can rescue it.
      final c = TransformableBoxController(
        rect: const Rect.fromLTWH(0, 0, 100, 100),
        clampingRect: const Rect.fromLTRB(0, 0, 100, 100),
        rotation: 0.0,
        bindingStrategy: BindingStrategy.boundingBox,
      );
      // Center is (50, 50). Pointer goes from (+X) to angle π/4 of center.
      c.onRotateStart(const Offset(100, 50));
      final result = c.onRotateUpdate(
        Offset(
            50 + 50 * math.cos(math.pi / 4), 50 + 50 * math.sin(math.pi / 4)),
        HandlePosition.bottomRight,
      );
      expect(result.feasible, isFalse);
      expect(c.rotation, equals(0.0),
          reason: 'Controller must not update rotation on infeasible result.');
      expect(c.rect, equals(const Rect.fromLTWH(0, 0, 100, 100)),
          reason: 'Controller must not update rect on infeasible result.');
    });

    test(
      'multi-tick gesture: feasible → infeasible (frozen) → reverse '
      '(feasible again)',
      () {
        // R1: drag past the cap, gesture freezes at last feasible state;
        // reversing pointer direction unfreezes and resumes tracking.
        // Geometry: 100×100 centered in 130×130 clamp → AABB at π/12 fits
        // (122.5 < 130) but AABB at π/6 doesn't (136.6 > 130).
        final c = TransformableBoxController(
          rect: const Rect.fromLTWH(15, 15, 100, 100),
          clampingRect: const Rect.fromLTRB(0, 0, 130, 130),
          rotation: 0.0,
          bindingStrategy: BindingStrategy.boundingBox,
        );
        // Pointer rotates around the box center (65, 65).
        Offset pointerAt(double theta) =>
            Offset(65 + 50 * math.cos(theta), 65 + 50 * math.sin(theta));
        c.onRotateStart(pointerAt(0));

        // Tick 1: small rotation (feasible).
        const theta1 = math.pi / 12;
        final r1 = c.onRotateUpdate(
          pointerAt(theta1),
          HandlePosition.bottomRight,
        );
        expect(r1.feasible, isTrue);
        expect(c.rotation, closeTo(theta1, 1e-9));
        final frozenRotation = c.rotation;
        final frozenRect = c.rect;

        // Tick 2: rotation past the cap → infeasible.
        const theta2 = math.pi / 6;
        final r2 = c.onRotateUpdate(
          pointerAt(theta2),
          HandlePosition.bottomRight,
        );
        expect(r2.feasible, isFalse);
        expect(c.rotation, equals(frozenRotation),
            reason: 'Frozen at last feasible rotation.');
        expect(c.rect, equals(frozenRect),
            reason: 'Rect frozen at last feasible position.');

        // Tick 3: reverse direction back to a feasible rotation.
        const theta3 = math.pi / 24;
        final r3 = c.onRotateUpdate(
          pointerAt(theta3),
          HandlePosition.bottomRight,
        );
        expect(r3.feasible, isTrue);
        expect(c.rotation, closeTo(theta3, 1e-9),
            reason: 'Reversal resumes tracking from gesture-start, not '
                'from the frozen rotation.');
      },
    );

    test(
      'side-handle resize tick-by-tick across clamp boundary stays clean',
      () {
        // Reproduces the user-reported symptom: dragging the right side
        // handle in tiny ticks, the box's bottom-right corner intersects
        // clamp.bottom, and the box appears to grow in the reverse
        // direction before clamping.
        const theta = math.pi / 12;
        final c = TransformableBoxController(
          rect: const Rect.fromLTWH(150, 250, 100, 100),
          clampingRect: const Rect.fromLTRB(0, 0, 400, 400),
          rotation: theta,
          bindingStrategy: BindingStrategy.boundingBox,
        );
        // World position of the rotated right edge midpoint (where the
        // strip sits visually under rotation).
        final rectCenter = const Offset(200, 300);
        final unrotatedRightMid = const Offset(250, 300);
        final dx = unrotatedRightMid.dx - rectCenter.dx;
        final dy = unrotatedRightMid.dy - rectCenter.dy;
        final cosT = math.cos(theta);
        final sinT = math.sin(theta);
        final rotatedRightMidWorld = Offset(
          rectCenter.dx + dx * cosT - dy * sinT,
          rectCenter.dy + dx * sinT + dy * cosT,
        );

        c.onResizeStart(rotatedRightMidWorld);
        // Drag tick-by-tick along the rotated +x direction (visually
        // outward from the right edge).
        const ticks = 30;
        const stepPx = 5.0;
        final widths = <double>[];
        for (int i = 1; i <= ticks; i++) {
          final stepWorld = Offset(
            rotatedRightMidWorld.dx + i * stepPx * cosT,
            rotatedRightMidWorld.dy + i * stepPx * sinT,
          );
          final result = c.onResizeUpdate(stepWorld, HandlePosition.right);
          widths.add(result.rect.width);
        }
        // Must be monotonic non-decreasing.
        for (int i = 1; i < widths.length; i++) {
          expect(
            widths[i],
            greaterThanOrEqualTo(widths[i - 1] - 1e-6),
            reason: 'tick $i: width regressed '
                '(${widths[i - 1]} → ${widths[i]})',
          );
        }
      },
    );

    test(
      'force-flip during rotated resize keeps rect in clamp',
      () {
        // User reports: dragging a corner past anchor (force-flip) under
        // rotation can leave the rect bleeding past clamp boundaries.
        const theta = math.pi / 12;
        final c = TransformableBoxController(
          rect: const Rect.fromLTWH(150, 150, 100, 100),
          clampingRect: const Rect.fromLTRB(0, 0, 400, 400),
          rotation: theta,
          bindingStrategy: BindingStrategy.boundingBox,
        );
        // World position of the rotated bottomRight corner.
        final centerWorld = const Offset(200, 200);
        final unrotatedBR = const Offset(250, 250);
        final cosT = math.cos(theta);
        final sinT = math.sin(theta);
        final dx = unrotatedBR.dx - centerWorld.dx;
        final dy = unrotatedBR.dy - centerWorld.dy;
        final initialBR = Offset(
          centerWorld.dx + dx * cosT - dy * sinT,
          centerWorld.dy + dx * sinT + dy * cosT,
        );
        c.onResizeStart(initialBR);
        // Drag past topLeft anchor and continue to clamp's far corner.
        for (int i = 0; i <= 60; i++) {
          // Cursor sweeps from BR toward upper-left in screen, eventually
          // past clamp.left and clamp.top.
          final targetWorld = Offset(
            initialBR.dx - i * 8.0,
            initialBR.dy - i * 8.0,
          );
          final result =
              c.onResizeUpdate(targetWorld, HandlePosition.bottomRight);
          // Verify the controller's rect's rotated corners stay in clamp.
          final r = result.rect;
          final rcx = r.center.dx;
          final rcy = r.center.dy;
          final rrot = c.rotation;
          final rcosT = math.cos(rrot);
          final rsinT = math.sin(rrot);
          final corners = [
            r.topLeft,
            r.topRight,
            r.bottomRight,
            r.bottomLeft,
          ].map((p) {
            final ddx = p.dx - rcx;
            final ddy = p.dy - rcy;
            return Offset(
              rcx + ddx * rcosT - ddy * rsinT,
              rcy + ddx * rsinT + ddy * rcosT,
            );
          }).toList();
          for (int k = 0; k < 4; k++) {
            expect(
                corners[k].dx, greaterThanOrEqualTo(c.clampingRect.left - 1e-3),
                reason: 'tick $i corner $k leaked left');
            expect(
                corners[k].dy, greaterThanOrEqualTo(c.clampingRect.top - 1e-3),
                reason: 'tick $i corner $k leaked top');
            expect(
                corners[k].dx, lessThanOrEqualTo(c.clampingRect.right + 1e-3),
                reason: 'tick $i corner $k leaked right');
            expect(
                corners[k].dy, lessThanOrEqualTo(c.clampingRect.bottom + 1e-3),
                reason: 'tick $i corner $k leaked bottom');
          }
        }
      },
    );

    test('onRotateUpdate slides rect into clamp when slack room exists', () {
      // 100×100 box flush against top-left of a 200×200 clamp. Rotating
      // by π/12 inflates the AABB by ~11 px on each axis; the box must
      // slide into the clamp so the AABB fits.
      final c = TransformableBoxController(
        rect: const Rect.fromLTWH(0, 0, 100, 100),
        clampingRect: const Rect.fromLTRB(0, 0, 200, 200),
        rotation: 0.0,
        bindingStrategy: BindingStrategy.boundingBox,
      );
      const theta = math.pi / 12;
      c.onRotateStart(const Offset(100, 50));
      final result = c.onRotateUpdate(
        Offset(50 + 50 * math.cos(theta), 50 + 50 * math.sin(theta)),
        HandlePosition.bottomRight,
      );
      expect(result.feasible, isTrue);
      expect(c.rotation, closeTo(theta, 1e-9));
      // Rect should have moved (not still at 0,0).
      expect(c.rect.left, greaterThan(0.0));
      expect(c.rect.top, greaterThan(0.0));
    });
  });
}
