import 'dart:math' as math;

import 'package:flutter/material.dart';
import 'package:flutter_box_transform/flutter_box_transform.dart';
import 'package:flutter_test/flutter_test.dart';

/// Regression: the drag GestureDetector is axis-aligned over the rotated
/// box's AABB. Before the RotatedHitGate, the four triangular wedges of
/// the AABB outside the rotated polygon registered drag/tap events —
/// visible as "draggable outside the rendered rotated pixels." These
/// tests assert the hit region matches the rotated polygon exactly.
void main() {
  Future<TransformableBoxController> pumpBox(
    WidgetTester tester, {
    required Rect rect,
    required double rotation,
    VoidCallback? onTap,
    double stageW = 800,
    double stageH = 600,
  }) async {
    final controller = TransformableBoxController(
      rect: rect,
      rotation: rotation,
    );
    await tester.pumpWidget(
      Directionality(
        textDirection: TextDirection.ltr,
        child: SizedBox(
          width: stageW,
          height: stageH,
          child: Stack(
            children: [
              TransformableBox(
                controller: controller,
                onTap: onTap,
                contentBuilder: (context, r, flip) =>
                    const ColoredBox(color: Color(0xFF4B9EF4)),
              ),
            ],
          ),
        ),
      ),
    );
    await tester.pump();
    return controller;
  }

  group('square @ pi/4 (center at 250,250)', () {
    testWidgets(
      'tap in AABB wedge (outside rotated polygon) does NOT fire onTap',
      (tester) async {
        int tapCount = 0;
        await pumpBox(
          tester,
          rect: const Rect.fromLTWH(200, 200, 100, 100),
          rotation: math.pi / 4,
          onTap: () => tapCount++,
        );
        // AABB ~ (179.3, 179.3, 320.7, 320.7). (180, 180) is in the
        // top-left wedge: rotated back by -pi/4 about (250,250), local
        // ~ (151, 250) — outside rect (200,200,300,300).
        await tester.tapAt(const Offset(180, 180));
        await tester.pump();
        expect(tapCount, 0, reason: 'tap in AABB wedge must not fire onTap');
      },
    );

    testWidgets(
      'tap at polygon center fires onTap',
      (tester) async {
        int tapCount = 0;
        await pumpBox(
          tester,
          rect: const Rect.fromLTWH(200, 200, 100, 100),
          rotation: math.pi / 4,
          onTap: () => tapCount++,
        );
        await tester.tapAt(const Offset(250, 250));
        await tester.pump();
        expect(tapCount, 1);
      },
    );

    testWidgets(
      'drag started in AABB wedge does NOT move the box',
      (tester) async {
        final c = await pumpBox(
          tester,
          rect: const Rect.fromLTWH(200, 200, 100, 100),
          rotation: math.pi / 4,
        );
        final Rect initial = c.rect;
        final gesture = await tester.startGesture(const Offset(180, 180));
        await tester.pump();
        await gesture.moveBy(const Offset(50, 50));
        await tester.pump();
        await gesture.up();
        await tester.pump();
        expect(c.rect, initial,
            reason: 'drag from AABB wedge must not move box');
      },
    );

    testWidgets(
      'drag started in polygon translates the box normally',
      (tester) async {
        final c = await pumpBox(
          tester,
          rect: const Rect.fromLTWH(200, 200, 100, 100),
          rotation: math.pi / 4,
        );
        final gesture = await tester.startGesture(const Offset(250, 250));
        await tester.pump();
        await gesture.moveBy(const Offset(-50, 0));
        await tester.pump();
        await gesture.up();
        await tester.pump();
        expect(c.rect.left, closeTo(150, 0.5));
        expect(c.rect.top, closeTo(200, 0.5));
      },
    );
  });

  testWidgets(
    'theta=0: interior tap fires (no regression)',
    (tester) async {
      int tapCount = 0;
      await pumpBox(
        tester,
        rect: const Rect.fromLTWH(200, 200, 100, 100),
        rotation: 0.0,
        onTap: () => tapCount++,
      );
      // Single interior tap. With no rotation the gate's unrotated check is
      // the identity, so any interior AABB point must pass through.
      await tester.tapAt(const Offset(250, 250));
      await tester.pump();
      expect(tapCount, 1);
    },
  );

  testWidgets(
    'non-square 160x80 @ pi/6: wedge tap rejected, center tap accepted',
    (tester) async {
      int tapCount = 0;
      await pumpBox(
        tester,
        rect: const Rect.fromLTWH(200, 200, 160, 80),
        rotation: math.pi / 6,
        onTap: () => tapCount++,
      );
      // Center of this rect is (280, 240). AABB ~ (190.7, 165.4, 369.3, 314.6).
      // (191, 166) is in the top-left wedge: rotated back, local ~ (165.9,
      // 220.4) — outside rect (200, 200, 360, 280).
      await tester.tapAt(const Offset(191, 166));
      await tester.pump();
      expect(tapCount, 0, reason: 'non-square @ pi/6 wedge tap must not fire');
      // Polygon center IS inside.
      await tester.tapAt(const Offset(280, 240));
      await tester.pump();
      expect(tapCount, 1);
    },
  );

  testWidgets(
    'far-translated box (center ~1000,1000): wedge vs polygon',
    (tester) async {
      // Default test surface is 800x600; enlarge so (1000,1000) is on-screen.
      tester.view.physicalSize = const Size(1200, 1200);
      tester.view.devicePixelRatio = 1.0;
      addTearDown(tester.view.resetPhysicalSize);
      addTearDown(tester.view.resetDevicePixelRatio);

      int tapCount = 0;
      await pumpBox(
        tester,
        rect: const Rect.fromLTWH(950, 950, 100, 100),
        rotation: math.pi / 4,
        onTap: () => tapCount++,
        stageW: 1200,
        stageH: 1200,
      );
      // AABB ~ (929.3, 929.3, 1070.7, 1070.7). (930, 930) is a wedge.
      await tester.tapAt(const Offset(930, 930));
      await tester.pump();
      expect(tapCount, 0);
      // Polygon center.
      await tester.tapAt(const Offset(1000, 1000));
      await tester.pump();
      expect(tapCount, 1);
    },
  );

  testWidgets(
    'drag started in polygon CONTINUES when pointer exits polygon '
    '(gesture arena caches the hit path at pointer-down)',
    (tester) async {
      final c = await pumpBox(
        tester,
        rect: const Rect.fromLTWH(200, 200, 100, 100),
        rotation: math.pi / 4,
      );
      final gesture = await tester.startGesture(const Offset(250, 250));
      await tester.pump();
      // Translate far enough that intermediate pointer positions are
      // well outside the ORIGINAL polygon centred at (250,250).
      await gesture.moveBy(const Offset(300, 0));
      await tester.pump();
      await gesture.up();
      await tester.pump();
      expect(c.rect.left, closeTo(500, 1.0),
          reason: 'gesture must continue once arena has recognized it');
    },
  );
}
