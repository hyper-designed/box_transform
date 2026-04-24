import 'dart:math' as math;

import 'package:flutter/material.dart';
import 'package:flutter_box_transform/flutter_box_transform.dart';
import 'package:flutter_test/flutter_test.dart';

/// Reproduces the user report: slowly dragging the playground's clamping
/// rect's right edge toward the box via "aggressive tiny deltas" causes
/// the box to visibly "flick" to an odd offset at the moment the clamp
/// reaches its minimum width (= rotated bounding rect of the box).
///
/// Root cause: each parent repump with a tighter clamp used to trigger
/// `setClampingRect(..., recalculate: true)` in `didUpdateWidget`, which
/// runs a zero-delta `recalculateSize` under `ResizeMode.scale`. For a
/// rotated box against a tight clamp the scale solver picks the largest
/// (w, h) that fits — strictly smaller than the current box by a sliver.
/// Accumulated over many ticks, the slivers manifest as a visible shrink
/// + off-edge flick.
///
/// This first test bypasses the widget layer and directly calls
/// `controller.setClampingRect(...)` per tick with `recalculate: true`.
/// It does NOT reproduce the bug on its own (see test 2 for the widget-
/// level reproduction that does). It's retained as a lower-level sanity
/// guard — any regression that leaks into the controller path would
/// flick here too.
void main() {
  test(
    'shrinking clamp from the right in 1 px ticks must produce continuous '
    'box motion — no flicks at the last tick before saturation',
    () {
      const theta = math.pi / 6;
      final c = TransformableBoxController(
        rect: const Rect.fromLTWH(200, 200, 100, 100),
        rotation: theta,
        clampingRect: const Rect.fromLTRB(50, 50, 500, 500),
        bindingStrategy: BindingStrategy.boundingBox,
      );
      final double initialBoundingW = c.boundingRect.width;
      final double initialBoundingH = c.boundingRect.height;
      final double minClampRight = 50 + initialBoundingW;

      double prevLeft = c.rect.left;
      double prevTop = c.rect.top;
      const double tick = 1.0;

      // Shrink until (and including) clamp.width == boundingW (saturation).
      // We do NOT over-shrink beyond saturation — the clamp's own controller
      // in the playground refuses to shrink below minWidth, so we honour
      // that boundary here.
      double right = 500.0;
      int stepIdx = 0;
      while (right > minClampRight + tick * 0.5) {
        right -= tick;
        c.setClampingRect(Rect.fromLTRB(50, 50, right, 500));
        final dLeft = (c.rect.left - prevLeft).abs();
        final dTop = (c.rect.top - prevTop).abs();
        expect(
          dLeft,
          lessThanOrEqualTo(tick + 0.01),
          reason: 'step $stepIdx (right=$right): box.left jumped by $dLeft '
              '(>tick=$tick) — flick bug',
        );
        expect(
          dTop,
          lessThanOrEqualTo(tick + 0.01),
          reason: 'step $stepIdx (right=$right): box.top jumped by $dTop '
              '(>tick=$tick) — flick bug',
        );
        prevLeft = c.rect.left;
        prevTop = c.rect.top;
        stepIdx++;
      }

      // Final saturation tick exactly at boundingW.
      c.setClampingRect(Rect.fromLTRB(50, 50, minClampRight, 500));
      final dSatLeft = (c.rect.left - prevLeft).abs();
      final dSatTop = (c.rect.top - prevTop).abs();
      expect(
        dSatLeft,
        lessThanOrEqualTo(tick + 0.01),
        reason: 'saturation tick: box.left flicked by $dSatLeft',
      );
      expect(
        dSatTop,
        lessThanOrEqualTo(tick + 0.01),
        reason: 'saturation tick: box.top flicked by $dSatTop',
      );

      // Sanity: size preserved throughout (pure translation).
      expect(c.rect.width, closeTo(100, 1e-6));
      expect(c.rect.height, closeTo(100, 1e-6));
      expect(c.boundingRect.width, closeTo(initialBoundingW, 1e-6));
      expect(c.boundingRect.height, closeTo(initialBoundingH, 1e-6));
    },
  );

  testWidgets(
    'WIDGET (user scenario): 396x428 box, rotation ~15°, aggressive shrink',
    (tester) async {
      // Mirror the playground screenshot: box at (269, 165, 396, 428),
      // rotation ~15° (0.26 rad), clampingRect starts wide and shrinks from
      // the right. The playground's ClampingRect widget computes minWidth
      // from the box's bounding rect, but at each tick the clamp feeds back
      // a new rect, so we simulate the exact widget pump.
      const theta = 0.26;
      const double boxW = 396;
      const double boxH = 428;
      final boundingW =
          boxW * math.cos(theta).abs() + boxH * math.sin(theta).abs();

      final key = GlobalKey<State<TransformableBox>>();
      Future<void> pumpWithClamp(Rect clamp) async {
        await tester.pumpWidget(
          MaterialApp(
            home: Scaffold(
              body: SizedBox(
                width: 1400,
                height: 1200,
                child: Stack(
                  children: [
                    TransformableBox(
                      key: key,
                      rect: const Rect.fromLTWH(269, 165, boxW, boxH),
                      rotation: theta,
                      clampingRect: clamp,
                      bindingStrategy: BindingStrategy.boundingBox,
                      contentBuilder: (_, __, ___) =>
                          const ColoredBox(color: Color(0xFF4B9EF4)),
                    ),
                  ],
                ),
              ),
            ),
          ),
        );
      }

      TransformableBoxController readC() =>
          // ignore: avoid_dynamic_calls
          (key.currentState! as dynamic).controller
              as TransformableBoxController;

      // Initial clamp spans the whole stage.
      await pumpWithClamp(const Rect.fromLTRB(0, 0, 1400, 1200));
      final initW = readC().rect.width;
      final initH = readC().rect.height;
      double prevLeft = readC().rect.left;
      double prevTop = readC().rect.top;
      const double tick = 1.0;

      int idx = 0;
      // Shrink clamp.right aggressively, going through saturation and beyond.
      // Clamp minWidth stop is ~boundingW; test drives it all the way.
      for (double right = 1400 - tick; right >= boundingW - 50; right -= tick) {
        await pumpWithClamp(Rect.fromLTRB(0, 0, right, 1200));
        final c = readC();
        final dLeft = (c.rect.left - prevLeft).abs();
        final dTop = (c.rect.top - prevTop).abs();
        final dW = (c.rect.width - initW).abs();
        final dH = (c.rect.height - initH).abs();
        expect(dLeft, lessThanOrEqualTo(tick + 0.01),
            reason: 'step $idx (right=$right): box.left flicked $dLeft');
        expect(dTop, lessThanOrEqualTo(tick + 0.01),
            reason: 'step $idx (right=$right): box.top flicked $dTop');
        expect(dW, lessThanOrEqualTo(0.01),
            reason: 'step $idx (right=$right): box.width shrank by $dW '
                '(should be pure translation, no size change)');
        expect(dH, lessThanOrEqualTo(0.01),
            reason: 'step $idx (right=$right): box.height shrank by $dH');
        prevLeft = c.rect.left;
        prevTop = c.rect.top;
        idx++;
      }
    },
  );

  testWidgets(
    'WIDGET: progressive clampingRect shrink via pumpWidget — no flick',
    (tester) async {
      // True widget-level reproduction using the playground's pattern:
      // NO external controller — `clampingRect` is passed as a widget arg,
      // so each re-pump triggers didUpdateWidget → setClampingRect(...)
      // (internal recalc) + recalculatePosition + recalculateSize.
      const theta = math.pi / 6;
      // Keep a reference to the internal controller via a Global key so we
      // can read its rect between pumps.
      final key = GlobalKey<State<TransformableBox>>();

      Future<void> pumpWithClamp(Rect clamp) async {
        await tester.pumpWidget(
          MaterialApp(
            home: Scaffold(
              body: SizedBox(
                width: 800,
                height: 600,
                child: Stack(
                  children: [
                    TransformableBox(
                      key: key,
                      rect: const Rect.fromLTWH(200, 200, 100, 100),
                      rotation: theta,
                      clampingRect: clamp,
                      bindingStrategy: BindingStrategy.boundingBox,
                      contentBuilder: (_, __, ___) =>
                          const ColoredBox(color: Color(0xFF4B9EF4)),
                    ),
                  ],
                ),
              ),
            ),
          ),
        );
      }

      // Read the internal controller via reflection on the State's field.
      TransformableBoxController readController() {
        // ignore: avoid_dynamic_calls
        return (key.currentState! as dynamic).controller
            as TransformableBoxController;
      }

      await pumpWithClamp(const Rect.fromLTRB(50, 50, 500, 500));
      double prevLeft = readController().rect.left;
      double prevTop = readController().rect.top;
      const double tick = 1.0;

      int idx = 0;
      for (double right = 500 - tick; right >= 100; right -= tick) {
        await pumpWithClamp(Rect.fromLTRB(50, 50, right, 500));
        final c = readController();
        final dLeft = (c.rect.left - prevLeft).abs();
        final dTop = (c.rect.top - prevTop).abs();
        expect(
          dLeft,
          lessThanOrEqualTo(tick + 0.01),
          reason: 'widget step $idx (right=$right): box.left '
              'jumped by $dLeft (>tick=$tick) — FLICK',
        );
        expect(
          dTop,
          lessThanOrEqualTo(tick + 0.01),
          reason: 'widget step $idx (right=$right): box.top '
              'jumped by $dTop (>tick=$tick) — FLICK',
        );
        prevLeft = c.rect.left;
        prevTop = c.rect.top;
        idx++;
      }
    },
  );

  test(
    'widget-style double recalc path: shrink clamp in 1 px ticks, no flick',
    () {
      // Mirror the exact sequence `TransformableBox.didUpdateWidget` runs
      // when the parent passes a new clampingRect:
      //   1. controller.setClampingRect(new, notify: false)
      //        → internally calls recalculate() = recalculatePosition
      //          + recalculateSize (both zero-delta).
      //   2. controller.recalculatePosition(notify: false)  (explicit)
      //   3. controller.recalculateSize(notify: false)      (explicit)
      // My earlier direct-controller test only ran step 1's recalc; this
      // test runs all three per tick, matching what the playground actually
      // invokes.
      const theta = math.pi / 6;
      final c = TransformableBoxController(
        rect: const Rect.fromLTWH(200, 200, 100, 100),
        rotation: theta,
        clampingRect: const Rect.fromLTRB(50, 50, 500, 500),
        bindingStrategy: BindingStrategy.boundingBox,
      );

      double right = 500.0;
      const double tick = 1.0;
      double prevLeft = c.rect.left;
      double prevTop = c.rect.top;

      int stepIdx = 0;
      // Drive clamp.right down to and through saturation in 1 px steps.
      while (right > 50 + 100) {
        right -= tick;
        c.setClampingRect(Rect.fromLTRB(50, 50, right, 500));
        c.recalculatePosition(notify: false);
        c.recalculateSize(notify: false);
        final dLeft = (c.rect.left - prevLeft).abs();
        final dTop = (c.rect.top - prevTop).abs();
        expect(
          dLeft,
          lessThanOrEqualTo(tick + 0.01),
          reason: 'step $stepIdx (right=$right): box.left jumped by $dLeft',
        );
        expect(
          dTop,
          lessThanOrEqualTo(tick + 0.01),
          reason: 'step $stepIdx (right=$right): box.top jumped by $dTop',
        );
        prevLeft = c.rect.left;
        prevTop = c.rect.top;
        stepIdx++;
      }
    },
  );

  testWidgets(
    'E2E (both widgets in tree): dragging ClampingRect\'s right handle '
    'translates the rotated inner box without shrinking it',
    (tester) async {
      // Faithful reproduction of the playground's controlled-component loop:
      //   outer ClampingRect emits onChanged → setState → outer rebuilds with
      //   new rect AND inner rebuilds with new clampingRect. The inner's
      //   widget.rect is intentionally held constant across pumps: in the
      //   playground, ImageBox's widget.rect comes from PlaygroundModel and
      //   is ONLY updated by direct image gestures via onChanged. Clamp-
      //   driven internal translations via recalculatePosition(notify:false)
      //   never propagate back to the model, so the playground's
      //   widget.rect is stale across the entire clamp drag — exactly what
      //   a constant widget.rect here simulates. Saturation (clamp stops
      //   changing while parent keeps rebuilding) is the frame where the
      //   didUpdateWidget rect-sync branch must not snap the controller
      //   back to widget.rect without re-applying clamp translation.
      const theta = math.pi / 6;
      const Rect initialImg = Rect.fromLTWH(200, 200, 100, 100);
      Rect clamp = const Rect.fromLTRB(50, 50, 700, 550);

      final imgKey = GlobalKey<State<TransformableBox>>();
      TransformableBoxController readInner() =>
          // ignore: avoid_dynamic_calls
          (imgKey.currentState! as dynamic).controller
              as TransformableBoxController;

      await tester.pumpWidget(
        Directionality(
          textDirection: TextDirection.ltr,
          child: SizedBox(
            width: 800,
            height: 600,
            child: StatefulBuilder(
              builder: (context, setState) {
                // Mirror playground/main.dart:828 — minWidth/minHeight for
                // the clamp widget are derived from the inner box's rotated
                // bounding rect. Inner shouldn't shrink, so this is stable.
                final innerBounding = ClampHelpers.calculateBoundingRect(
                  initialImg.toBox(rotation: theta),
                );
                return Stack(
                  children: [
                    TransformableBox(
                      rect: clamp,
                      flip: Flip.none,
                      clampingRect: const Rect.fromLTRB(0, 0, 800, 600),
                      allowFlippingWhileResizing: false,
                      constraints: BoxConstraints(
                        minWidth: innerBounding.width,
                        minHeight: innerBounding.height,
                      ),
                      onChanged: (result, _) => setState(() {
                        clamp = result.rect;
                      }),
                      contentBuilder: (_, __, ___) =>
                          const ColoredBox(color: Color(0x22FF0000)),
                    ),
                    TransformableBox(
                      key: imgKey,
                      rect: initialImg,
                      rotation: theta,
                      clampingRect: clamp,
                      bindingStrategy: BindingStrategy.boundingBox,
                      contentBuilder: (_, __, ___) =>
                          const ColoredBox(color: Color(0xFF4B9EF4)),
                    ),
                  ],
                );
              },
            ),
          ),
        ),
      );

      // Outer clamp is unrotated; right-middle handle sits at (700, 300).
      final gesture = await tester.startGesture(const Offset(700, 300));
      await tester.pump();

      final double initW = readInner().rect.width;
      final double initH = readInner().rect.height;
      double prevLeft = readInner().rect.left;
      double prevTop = readInner().rect.top;
      const double stepPx = 1.0;

      // Drag inward ~600 px. clamp.right goes 700 → ~100. Saturation for the
      // inner 100x100 @ pi/6 happens near 50 + bounding.width ≈ 50 + 137.
      // We over-drive past saturation to prove the clamp bottoms out cleanly.
      for (int i = 0; i < 600; i++) {
        await gesture.moveBy(const Offset(-stepPx, 0));
        await tester.pump();

        final c = readInner();
        final dLeft = (c.rect.left - prevLeft).abs();
        final dTop = (c.rect.top - prevTop).abs();
        final dW = (c.rect.width - initW).abs();
        final dH = (c.rect.height - initH).abs();

        expect(dLeft, lessThanOrEqualTo(stepPx + 0.05),
            reason: 'step $i: inner.left flicked $dLeft');
        expect(dTop, lessThanOrEqualTo(stepPx + 0.05),
            reason: 'step $i: inner.top flicked $dTop');
        expect(dW, lessThanOrEqualTo(0.05),
            reason: 'step $i: inner.width drifted $dW (not pure translation)');
        expect(dH, lessThanOrEqualTo(0.05),
            reason: 'step $i: inner.height drifted $dH');

        prevLeft = c.rect.left;
        prevTop = c.rect.top;
      }

      await gesture.up();
      await tester.pump();
    },
  );
}
