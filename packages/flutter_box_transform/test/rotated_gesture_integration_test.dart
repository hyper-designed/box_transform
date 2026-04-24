import 'dart:math' as math;

import 'package:flutter/material.dart';
import 'package:flutter_box_transform/flutter_box_transform.dart';
import 'package:flutter_test/flutter_test.dart';

/// End-to-end widget tests that drive real pointer events through a
/// `TransformableBox` rotated at non-zero angle.
///
/// These are the tests that _should_ fail before the Option B refactor and
/// pass after. They prove the coord-system fix end-to-end.
void main() {
  /// Builds a minimally-sized harness hosting one `TransformableBox` at a
  /// known position, so test coordinates map directly to parent-frame coords.
  Future<TransformableBoxController> pumpBox(
    WidgetTester tester, {
    required double rotation,
    bool rotatable = false,
    Rect rect = const Rect.fromLTWH(200, 200, 100, 100),
    Rect? clampingRect,
    BoxConstraints? constraints,
    BindingStrategy bindingStrategy = BindingStrategy.originalBox,
  }) async {
    final controller = TransformableBoxController(
      rect: rect,
      rotation: rotation,
      clampingRect: clampingRect,
      constraints: constraints,
      bindingStrategy: bindingStrategy,
    );
    await tester.pumpWidget(
      Directionality(
        textDirection: TextDirection.ltr,
        child: SizedBox(
          width: 800,
          height: 600,
          child: Stack(
            children: [
              TransformableBox(
                controller: controller,
                rotatable: rotatable,
                contentBuilder: (context, rect, flip) => const ColoredBox(
                  color: Color(0xFF4B9EF4),
                ),
              ),
            ],
          ),
        ),
      ),
    );
    // Allow one frame for any post-frame callbacks.
    await tester.pump();
    return controller;
  }

  group('Tap behaviour (contentBuilder onTap must fire)', () {
    testWidgets('tap inside box fires contentBuilder onTap', (tester) async {
      int tapCount = 0;
      final controller = TransformableBoxController(
        rect: const Rect.fromLTWH(200, 200, 100, 100),
      );
      await tester.pumpWidget(
        Directionality(
          textDirection: TextDirection.ltr,
          child: SizedBox(
            width: 800,
            height: 600,
            child: Stack(
              children: [
                TransformableBox(
                  controller: controller,
                  contentBuilder: (context, rect, flip) => GestureDetector(
                    behavior: HitTestBehavior.translucent,
                    onTap: () => tapCount++,
                    child: Container(color: const Color(0xFF4B9EF4)),
                  ),
                ),
              ],
            ),
          ),
        ),
      );
      await tester.pump();
      await tester.tapAt(const Offset(250, 250));
      await tester.pump();
      expect(tapCount, 1,
          reason: 'contentBuilder onTap must fire on tap inside box');
    });

    testWidgets('tap on rotated box still fires contentBuilder onTap',
        (tester) async {
      int tapCount = 0;
      final controller = TransformableBoxController(
        rect: const Rect.fromLTWH(200, 200, 100, 100),
        rotation: math.pi / 4,
      );
      await tester.pumpWidget(
        Directionality(
          textDirection: TextDirection.ltr,
          child: SizedBox(
            width: 800,
            height: 600,
            child: Stack(
              children: [
                TransformableBox(
                  controller: controller,
                  contentBuilder: (context, rect, flip) => GestureDetector(
                    behavior: HitTestBehavior.translucent,
                    onTap: () => tapCount++,
                    child: Container(color: const Color(0xFF4B9EF4)),
                  ),
                ),
              ],
            ),
          ),
        ),
      );
      await tester.pump();
      // Tap the centre of the box (250, 250). Under rotation the centre is
      // unchanged, so this must still hit the rotated content.
      await tester.tapAt(const Offset(250, 250));
      await tester.pump();
      expect(tapCount, 1, reason: 'rotated content onTap must still fire');
    });
  });

  group('Rotated drag tracks cursor', () {
    testWidgets('theta=0: drag by (50, 0) moves rect by (50, 0)',
        (tester) async {
      final c = await pumpBox(tester, rotation: 0);
      // Start drag at box centre (250, 250) in screen = (250, 250) here.
      final gesture = await tester.startGesture(const Offset(250, 250));
      await tester.pump();
      await gesture.moveBy(const Offset(50, 0));
      await tester.pump();
      await gesture.up();
      await tester.pump();
      expect(c.rect.left, closeTo(250, 1.0));
      expect(c.rect.top, closeTo(200, 1.0));
    });

    testWidgets('theta=pi/4: drag by (50, 0) moves rect by (50, 0) in parent',
        (tester) async {
      final c = await pumpBox(tester, rotation: math.pi / 4);
      // The box is visually rotated 45°; its centre is still (250, 250).
      // Dragging by (50, 0) on screen should translate the unrotated rect
      // by (50, 0) in the parent frame.
      final gesture = await tester.startGesture(const Offset(250, 250));
      await tester.pump();
      await gesture.moveBy(const Offset(50, 0));
      await tester.pump();
      await gesture.up();
      await tester.pump();
      expect(c.rect.left, closeTo(250, 1.0));
      expect(c.rect.top, closeTo(200, 1.0));
      expect(c.rotation, closeTo(math.pi / 4, 1e-9));
    });
  });

  group('Continuous drag (multi-step, catches accumulation bugs)', () {
    testWidgets('theta=0: 5 moves of 10px right total 50px rect shift',
        (tester) async {
      final c = await pumpBox(tester, rotation: 0);
      final gesture = await tester.startGesture(const Offset(250, 250));
      await tester.pump();
      for (int i = 0; i < 5; i++) {
        await gesture.moveBy(const Offset(10, 0));
        await tester.pump();
        // Per-step pointer tracking: box.left should increase by exactly
        // 10px each step (1:1 cursor tracking, not accumulating).
        expect(c.rect.left, closeTo(200 + (i + 1) * 10, 0.01),
            reason: 'step $i: drift from 1:1 tracking');
      }
      await gesture.up();
      await tester.pump();
      expect(c.rect.left, closeTo(250, 0.01));
      expect(c.rect.top, closeTo(200, 0.01));
    });

    testWidgets('theta=pi/4: 5 moves of 10px right total 50px rect shift',
        (tester) async {
      final c = await pumpBox(tester, rotation: math.pi / 4);
      final gesture = await tester.startGesture(const Offset(250, 250));
      await tester.pump();
      for (int i = 0; i < 5; i++) {
        await gesture.moveBy(const Offset(10, 0));
        await tester.pump();
        expect(c.rect.left, closeTo(200 + (i + 1) * 10, 0.01),
            reason: 'step $i under rotation: drift from 1:1 tracking');
      }
      await gesture.up();
      await tester.pump();
      expect(c.rect.left, closeTo(250, 0.01));
      expect(c.rect.top, closeTo(200, 0.01));
    });
  });

  group('Multi-step resize tracks cursor 1:1', () {
    // Box 200x200, rotation=0. Grab bottomRight at (300,300), drag it in
    // 5 steps of (10, 0) each. After each step, width should grow by 10
    // exactly. Height should remain 100.
    testWidgets('theta=0: multi-step resize on bottomRight grows width 1:1',
        (tester) async {
      final c = await pumpBox(tester, rotation: 0);
      final gesture = await tester.startGesture(const Offset(300, 300));
      await tester.pump();
      for (int i = 0; i < 5; i++) {
        await gesture.moveBy(const Offset(10, 0));
        await tester.pump();
        expect(c.rect.width, closeTo(100 + (i + 1) * 10, 0.01),
            reason: 'step $i: width drift');
        expect(c.rect.height, closeTo(100, 0.01),
            reason: 'step $i: height drift (should be unchanged)');
        expect(c.rect.left, closeTo(200, 0.01),
            reason: 'step $i: left drift (anchor must stay)');
      }
      await gesture.up();
      await tester.pump();
    });

    // Same box, rotation=pi/2 (CCW). The visual bottomRight is at
    // ClampHelpers.rotatePointAround((300,300), (250,250), pi/2) = (200, 300). Grab there;
    // drag (10, 0) in world each step. New dimensions follow
    // delta (in local frame) = (10 * cos(-pi/2), 10 * sin(-pi/2)) = (0, -10),
    // i.e. the box visually grows left, which in local frame reduces height
    // by 10 per step (since the local "bottom" edge moves up). Let's just
    // assert bounding rect tracks cursor 1:1 for the dragged corner.
    testWidgets('theta=pi/2: multi-step resize keeps visual anchor fixed',
        (tester) async {
      // Anchor (visual topLeft) for bottomRight-handle resize is
      // ClampHelpers.rotatePointAround(rect.topLeft, rect.center, rotation).
      final c = await pumpBox(tester, rotation: math.pi / 2);
      // rect = (200,200,300,300). Visual bottomRight @ pi/2 = (200, 300).
      final gesture = await tester.startGesture(const Offset(200, 300));
      await tester.pump();
      for (int i = 0; i < 5; i++) {
        await gesture.moveBy(const Offset(-10, 0)); // further left
        await tester.pump();
        // Visual topLeft (anchor) in world should be stable.
        // topLeft unrotated = (200, 200). Rotated pi/2 around center (250,250).
        // dx=-50, dy=-50, cos=0, sin=1: x' = 250 + 50 = 300, y' = 250 - 50 = 200.
        // So visual anchor = (300, 200).
        final cx = (c.rect.left + c.rect.right) / 2;
        final cy = (c.rect.top + c.rect.bottom) / 2;
        final anchorUnrot = Offset(c.rect.left, c.rect.top);
        final anchorVisual = RotatedLayout.rotateOffsetAround(
            anchorUnrot, Offset(cx, cy), c.rotation);
        expect(anchorVisual.dx, closeTo(300, 0.1),
            reason: 'step $i: visual anchor drifted');
        expect(anchorVisual.dy, closeTo(200, 0.1),
            reason: 'step $i: visual anchor drifted');
      }
      await gesture.up();
      await tester.pump();
    });
  });

  group('Rotated box clamp: no shrinking under bounded movement/resize', () {
    // Scenario: rotated box entirely inside a generous clamp. Drag the box
    // toward a clamp edge. Expect translation to stop at the wall, with no
    // change in box dimensions at any step.
    testWidgets('theta=pi/6: drag into clamp wall preserves size',
        (tester) async {
      final c = await pumpBox(
        tester,
        rotation: math.pi / 6,
        rect: const Rect.fromLTWH(200, 200, 100, 100),
        clampingRect: const Rect.fromLTRB(100, 100, 500, 500),
      );
      final initialSize = c.rect.size;
      // Drag far to the left, into the clamp.
      final gesture = await tester.startGesture(const Offset(250, 250));
      await tester.pump();
      for (int i = 0; i < 10; i++) {
        await gesture.moveBy(const Offset(-20, 0));
        await tester.pump();
        expect(c.rect.width, closeTo(initialSize.width, 0.01),
            reason: 'width must not change during drag (step $i)');
        expect(c.rect.height, closeTo(initialSize.height, 0.01),
            reason: 'height must not change during drag (step $i)');
      }
      await gesture.up();
      await tester.pump();
    });

    // Resize a rotated corner handle outward past the clamp. Box should
    // grow, then stop. Neither dimension should ever decrease during the
    // gesture.
    testWidgets('theta=pi/6: resize into clamp wall does not shrink',
        (tester) async {
      // Box 100x100 at rotation pi/6. Clamp barely bigger.
      // Rotated-box AABB ≈ 100*(cos(pi/6)+sin(pi/6)) = 100 * (0.866+0.5) = 136.6.
      // Place clamp so resizing outward eventually hits a corner.
      final c = await pumpBox(
        tester,
        rotation: math.pi / 6,
        rect: const Rect.fromLTWH(200, 200, 100, 100),
        clampingRect: const Rect.fromLTRB(100, 100, 400, 400),
      );
      final initialW = c.rect.width;
      final initialH = c.rect.height;
      // Visual bottomRight under rotation pi/6 around centre (250, 250).
      final handleWorld = RotatedLayout.rotateOffsetAround(
          const Offset(300, 300), const Offset(250, 250), math.pi / 6);
      final gesture = await tester.startGesture(handleWorld);
      await tester.pump();
      for (int i = 0; i < 10; i++) {
        await gesture.moveBy(const Offset(20, 20));
        await tester.pump();
        expect(c.rect.width, greaterThanOrEqualTo(initialW - 0.01),
            reason: 'width must not shrink during resize-outward (step $i)');
        expect(c.rect.height, greaterThanOrEqualTo(initialH - 0.01),
            reason: 'height must not shrink during resize-outward (step $i)');
      }
      await gesture.up();
      await tester.pump();
    });
  });

  group('Non-bottomRight handles under rotation', () {
    // Default playground-like setup: 100x100 box rotated ~30°, clamp big
    // (plenty of room), constraints 100/500 on both axes.
    Future<TransformableBoxController> setup(WidgetTester tester) => pumpBox(
          tester,
          rotation: math.pi / 6,
          rect: const Rect.fromLTWH(200, 200, 100, 100),
          clampingRect: const Rect.fromLTRB(0, 0, 950, 600),
          constraints: const BoxConstraints(
            minWidth: 100,
            minHeight: 100,
            maxWidth: 500,
            maxHeight: 500,
          ),
        );

    // User drags visual topRight corner horizontally right. Both w and h
    // should grow monotonically, never shrink. 15 steps of 20px → S=300,
    // which crosses the threshold (~S=225) where the pre-fix math starts
    // shrinking h via bogus mirror-corner inequalities.
    testWidgets('topRight handle: drag right 15x20px grows w+h monotonically',
        (tester) async {
      final c = await setup(tester);
      final handleWorld = RotatedLayout.rotateOffsetAround(
          const Offset(300, 200), const Offset(250, 250), math.pi / 6);
      final gesture = await tester.startGesture(handleWorld);
      await tester.pump();
      double lastW = c.rect.width;
      double lastH = c.rect.height;
      for (int i = 0; i < 15; i++) {
        await gesture.moveBy(const Offset(20, 0));
        await tester.pump();
        expect(c.rect.width, greaterThanOrEqualTo(lastW - 0.01),
            reason: 'step $i: width must not shrink');
        expect(c.rect.height, greaterThanOrEqualTo(lastH - 0.01),
            reason: 'step $i: height must not shrink');
        lastW = c.rect.width;
        lastH = c.rect.height;
      }
      await gesture.up();
      await tester.pump();
    });

    // Playground-like geometry: 100x100 box centred in 950x600 clamp,
    // rotation pi/6. Grab topLeft and drag outward by (-300, -300). Pre-fix
    // math collapses width to ~100 (minWidth). Correct math keeps width
    // substantially above min.
    testWidgets('topLeft handle: centred box, big outward drag keeps shape',
        (tester) async {
      final c = await pumpBox(
        tester,
        rotation: math.pi / 6,
        rect: const Rect.fromLTWH(425, 250, 100, 100),
        clampingRect: const Rect.fromLTRB(0, 0, 950, 600),
        constraints: const BoxConstraints(
          minWidth: 100,
          minHeight: 100,
          maxWidth: 500,
          maxHeight: 500,
        ),
      );
      final handleWorld = RotatedLayout.rotateOffsetAround(
          const Offset(425, 250), const Offset(475, 300), math.pi / 6);
      final gesture = await tester.startGesture(handleWorld);
      await tester.pump();
      await gesture.moveBy(const Offset(-300, -300));
      await tester.pump();
      expect(c.rect.width, greaterThan(200.0),
          reason: 'topLeft big outward drag: width collapsed to ~min');
      expect(c.rect.height, greaterThan(200.0),
          reason: 'topLeft big outward drag: height collapsed to ~min');
      await gesture.up();
      await tester.pump();
    });

    // Bottom-left handle: 7 steps of (-20, 0) → S=140. Stays inside the
    // clamp so the rotated corner doesn't legitimately exit; any shrink
    // here would be a bogus mirror-polygon artefact.
    testWidgets('bottomLeft handle: drag left 7x20px grows w+h monotonically',
        (tester) async {
      final c = await setup(tester);
      final handleWorld = RotatedLayout.rotateOffsetAround(
          const Offset(200, 300), const Offset(250, 250), math.pi / 6);
      final gesture = await tester.startGesture(handleWorld);
      await tester.pump();
      double lastW = c.rect.width;
      double lastH = c.rect.height;
      for (int i = 0; i < 7; i++) {
        await gesture.moveBy(const Offset(-20, 0));
        await tester.pump();
        expect(c.rect.width, greaterThanOrEqualTo(lastW - 0.01),
            reason: 'step $i: width must not shrink');
        expect(c.rect.height, greaterThanOrEqualTo(lastH - 0.01),
            reason: 'step $i: height must not shrink');
        lastW = c.rect.width;
        lastH = c.rect.height;
      }
      await gesture.up();
      await tester.pump();
    });
  });

  group('Rotation tracks gesture angle exactly', () {
    // Box centered at (250, 250), rotatable=true, initial rotation=0.
    // Place the pointer just beyond the bottomRight corner at (312, 312)
    // (vector from centre = (62, 62), screen angle = atan2(62, 62) = pi/4).
    // Drag to (188, 312), vector (-62, 62), angle atan2(62, -62) = 3*pi/4.
    // Expected net rotation delta = 3*pi/4 - pi/4 = pi/2 exactly.
    testWidgets('quarter-turn pointer sweep produces exactly pi/2 rotation',
        (tester) async {
      final c = await pumpBox(tester, rotation: 0, rotatable: true);
      final gesture = await tester.startGesture(const Offset(312, 312));
      await tester.pump();
      await gesture.moveBy(const Offset(-124, 0));
      await tester.pump();
      await gesture.up();
      await tester.pump();
      expect(c.rotation, closeTo(math.pi / 2, 1e-3),
          reason: 'rotation should track pointer angle delta 1:1');
    });

    // Same setup; smaller, intermediate rotation.
    testWidgets('one-eighth turn produces exactly pi/4 rotation',
        (tester) async {
      final c = await pumpBox(tester, rotation: 0, rotatable: true);
      final gesture = await tester.startGesture(const Offset(312, 312));
      await tester.pump();
      // Target the angle pi/2 (vector (0, 87.68) from centre).
      // That's a pi/4 delta from start (pi/4 → pi/2).
      await gesture.moveBy(const Offset(-62, 25.68));
      await tester.pump();
      await gesture.up();
      await tester.pump();
      expect(c.rotation, closeTo(math.pi / 4, 0.02),
          reason: 'rotation should track pointer angle delta 1:1');
    });
  });

  group('Rotated resize tracks cursor', () {
    testWidgets(
        'theta=pi/2: dragging the visual bottomRight handle grows the box',
        (tester) async {
      final c = await pumpBox(
        tester,
        rotation: math.pi / 2,
        rect: const Rect.fromLTWH(200, 200, 100, 100),
      );
      // At rotation pi/2 (90° CCW), the unrotated bottomRight (300, 300)
      // is visually at (200, 300). Grab the visual handle there.
      final initialArea = c.rect.width * c.rect.height;
      final gesture = await tester.startGesture(const Offset(200, 300));
      await tester.pump();
      // Drag outward (further from centre).
      await gesture.moveBy(const Offset(-30, 30));
      await tester.pump();
      await gesture.up();
      await tester.pump();
      // Resize must make the box _larger_, not smaller or jump elsewhere.
      expect(c.rect.width * c.rect.height, greaterThan(initialArea),
          reason: 'dragging outward should grow the box');
      // Box centre should remain close to the original (250, 250).
      final newCentre = c.rect.center;
      expect(newCentre.dx, closeTo(250, 25));
      expect(newCentre.dy, closeTo(250, 25));
    });
  });

  group('rotatable=true resize uses correct absolute pointer', () {
    testWidgets(
        'resize click at box corner stores world-space initialLocalPosition, not inner-padding-local',
        (tester) async {
      final c = await pumpBox(
        tester,
        rotation: 0,
        rotatable: true,
      );
      // Box's unrotated bottomRight is at (300, 300). rotatable=true means
      // the handle is a 64x64 zone centered on that corner, with the 24x24
      // resize gesture in the middle. Tap at the exact corner (inside the
      // resize zone).
      final gesture = await tester.startGesture(const Offset(300, 300));
      await tester.pump();
      // Commit the pan recognizer with a tiny move past touch slop.
      await gesture.moveBy(const Offset(10, 10));
      await tester.pump();
      // controller.initialLocalPosition captured at onResizeStart should be
      // the world click point (300, 300), not offset by the Padding gap.
      expect(c.initialLocalPosition.dx, closeTo(300, 1.0));
      expect(c.initialLocalPosition.dy, closeTo(300, 1.0));
      await gesture.up();
      await tester.pump();
    });
  });

  group('rotatable=true combined with rotation!=0', () {
    testWidgets(
        'rotation=pi/4 + rotatable: resize via inner zone tracks world cursor',
        (tester) async {
      final c = await pumpBox(
        tester,
        rotation: math.pi / 4,
        rotatable: true,
      );
      // Unrotated bottomRight (300, 300), rotated around centre (250, 250)
      // by pi/4:
      //   dx=50, dy=50, cos=sin=sqrt(2)/2 -> (250 + 0, 250 + 50*sqrt2).
      //   ~= (250.0, 250 + 70.71) = (250.0, 320.71).
      const visualBR = Offset(250.0, 320.71);
      final gesture = await tester.startGesture(visualBR);
      await tester.pump();
      await gesture.moveBy(const Offset(10, 10));
      await tester.pump();
      // initialLocalPosition should be approximately the visual BR.
      expect(c.initialLocalPosition.dx, closeTo(visualBR.dx, 2.0));
      expect(c.initialLocalPosition.dy, closeTo(visualBR.dy, 2.0));
      await gesture.up();
      await tester.pump();
    });
  });

  group('Rotate via handle', () {
    testWidgets('dragging outside a corner rotates the box', (tester) async {
      final c = await pumpBox(
        tester,
        rotation: 0,
        rotatable: true,
      );
      // Rotation outer ring is 64px; visible visual handle is 24px at the
      // corner. Grab the outer ring just past the bottomRight corner.
      final start = Offset(300 + 12, 300 + 12);
      final gesture = await tester.startGesture(start);
      await tester.pump();
      // Arc the pointer a quarter-turn around the centre (250, 250).
      // Start vector from centre: (62, 62). Quarter-turn CCW target vector:
      // (-62, 62) → absolute point (188, 312).
      await gesture.moveTo(const Offset(188, 312));
      await tester.pump();
      await gesture.up();
      await tester.pump();
      // Expect roughly pi/2 rotation (tolerance: trackpad quantisation).
      expect(c.rotation.abs(), greaterThan(math.pi / 4),
          reason: 'rotation should have significantly changed');
    });
  });
}
