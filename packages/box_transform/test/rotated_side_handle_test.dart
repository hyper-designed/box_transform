// Tests for side-handle resize under rotation.
//
// Bug: side handles (top/right/bottom/left) are gated to rotation == 0 in
// the Flutter widget layer because the rotated resize methods' rect
// reconstruction assumes `anchorLocal` is a corner. For side handles the
// anchor is the midpoint of the opposite side, so the existing math
// produces a translated rect with the right dimensions on the wrong axis
// position.
//
// Required behavior under rotation, by handle:
//   - right: width grows/shrinks. Height unchanged. centerLeft (world)
//     preserved.
//   - left: width grows/shrinks from the other side. centerRight preserved.
//   - bottom: height grows/shrinks. Width unchanged. topCenter preserved.
//   - top: height grows/shrinks from the other side. bottomCenter preserved.
//
// All under any rotation. The handle's anchor (the midpoint of the opposite
// side) must hold its world-space position across the gesture, mirroring the
// corner-anchor invariant.

import 'dart:math' as math;

import 'package:box_transform/box_transform.dart';
import 'package:test/test.dart';
import 'package:vector_math/vector_math_64.dart';

void main() {
  const theta = math.pi / 6;

  group('Right side handle under rotation', () {
    test('drag outward: width grows, height fixed, centerLeft preserved', () {
      // 100×100 box at (200, 200), rotated π/6. Drag right handle 50 px
      // outward in the unrotated frame.
      final initial = Box.fromLTWH(200, 200, 100, 100, rotation: theta);
      final result = _resize(
        initial: initial,
        handle: HandlePosition.right,
        // initial pointer at the right-edge midpoint (in unrotated frame)
        initialUnrotated: Vector2(300, 250),
        // target pointer 50 px further along local +x
        targetUnrotated: Vector2(350, 250),
      );

      expect(result.rect.width, closeTo(150, 1e-9));
      expect(result.rect.height, closeTo(100, 1e-9));
      expect(result.rect.rotation, closeTo(theta, 1e-12));
      _expectAnchorPreserved(initial, result.rect, HandlePosition.right);
    });
  });

  group('Left side handle under rotation', () {
    test('drag outward: width grows, height fixed, centerRight preserved', () {
      final initial = Box.fromLTWH(200, 200, 100, 100, rotation: theta);
      final result = _resize(
        initial: initial,
        handle: HandlePosition.left,
        initialUnrotated: Vector2(200, 250),
        targetUnrotated: Vector2(150, 250),
      );

      expect(result.rect.width, closeTo(150, 1e-9));
      expect(result.rect.height, closeTo(100, 1e-9));
      expect(result.rect.rotation, closeTo(theta, 1e-12));
      _expectAnchorPreserved(initial, result.rect, HandlePosition.left);
    });
  });

  group('Bottom side handle under rotation', () {
    test('drag outward: height grows, width fixed, topCenter preserved', () {
      final initial = Box.fromLTWH(200, 200, 100, 100, rotation: theta);
      final result = _resize(
        initial: initial,
        handle: HandlePosition.bottom,
        initialUnrotated: Vector2(250, 300),
        targetUnrotated: Vector2(250, 350),
      );

      expect(result.rect.width, closeTo(100, 1e-9));
      expect(result.rect.height, closeTo(150, 1e-9));
      expect(result.rect.rotation, closeTo(theta, 1e-12));
      _expectAnchorPreserved(initial, result.rect, HandlePosition.bottom);
    });
  });

  group('Top side handle under rotation', () {
    test('drag outward: height grows, width fixed, bottomCenter preserved', () {
      final initial = Box.fromLTWH(200, 200, 100, 100, rotation: theta);
      final result = _resize(
        initial: initial,
        handle: HandlePosition.top,
        initialUnrotated: Vector2(250, 200),
        targetUnrotated: Vector2(250, 150),
      );

      expect(result.rect.width, closeTo(100, 1e-9));
      expect(result.rect.height, closeTo(150, 1e-9));
      expect(result.rect.rotation, closeTo(theta, 1e-12));
      _expectAnchorPreserved(initial, result.rect, HandlePosition.top);
    });
  });

  group('Right side handle under rotation — scale mode', () {
    test('aspect ratio preserved, anchor (centerLeft) world-fixed', () {
      // Aspect ratio is 1:1 here, so width and height grow equally.
      final initial = Box.fromLTWH(200, 200, 100, 100, rotation: theta);
      final result = _resize(
        initial: initial,
        handle: HandlePosition.right,
        initialUnrotated: Vector2(300, 250),
        targetUnrotated: Vector2(350, 250),
        mode: ResizeMode.scale,
      );

      expect(result.rect.width, closeTo(150, 1e-9));
      expect(result.rect.height, closeTo(150, 1e-9));
      _expectAnchorPreserved(initial, result.rect, HandlePosition.right);
    });
  });

  group('Right side handle under rotation — symmetric mode', () {
    test('width grows symmetrically about center, height fixed', () {
      final initial = Box.fromLTWH(200, 200, 100, 100, rotation: theta);
      final result = _resize(
        initial: initial,
        handle: HandlePosition.right,
        initialUnrotated: Vector2(300, 250),
        targetUnrotated: Vector2(325, 250),
        mode: ResizeMode.symmetric,
      );

      // Pointer moved 25 px outward → both sides extend 25 px → width 150.
      expect(result.rect.width, closeTo(150, 1e-9));
      expect(result.rect.height, closeTo(100, 1e-9));
      // Center stays at the rotated rect center (preserved across symmetric
      // resizes).
      final initCenter = Vector2(
        (initial.left + initial.right) / 2,
        (initial.top + initial.bottom) / 2,
      );
      final resCenter = Vector2(
        (result.rect.left + result.rect.right) / 2,
        (result.rect.top + result.rect.bottom) / 2,
      );
      expect(resCenter.x, closeTo(initCenter.x, 1e-6));
      expect(resCenter.y, closeTo(initCenter.y, 1e-6));
    });
  });

  group('Side handles respect clampingRect under rotation', () {
    test(
      'bottom handle drag past clamp: rotated AABB stays inside clamp',
      () {
        // Slight rotation, plenty of room above, very little below. Bottom
        // handle dragged way past the clamp's bottom edge: the rect must
        // grow only as far as the clamp allows; it must NOT extend past
        // the clamp on the opposite (top) side.
        const theta = math.pi / 12;
        final initial = Box.fromLTWH(150, 150, 100, 100, rotation: theta);
        final clamp = Box.fromLTRB(0, 0, 400, 400);
        final result = _resize(
          initial: initial,
          handle: HandlePosition.bottom,
          initialUnrotated: Vector2(200, 250),
          // Pointer dragged way down to attempt extreme growth.
          targetUnrotated: Vector2(200, 5000),
          mode: ResizeMode.freeform,
          bindingStrategy: BindingStrategy.boundingBox,
          clampingRect: clamp,
        );

        // Compute rotated AABB of result.rect.
        final res = result.rect;
        final aabb = ClampHelpers.calculateBoundingRect(res);
        expect(
          aabb.left,
          greaterThanOrEqualTo(clamp.left - 1e-6),
          reason: 'rect leaked past clamp.left',
        );
        expect(
          aabb.top,
          greaterThanOrEqualTo(clamp.top - 1e-6),
          reason: 'rect leaked past clamp.top',
        );
        expect(
          aabb.right,
          lessThanOrEqualTo(clamp.right + 1e-6),
          reason: 'rect leaked past clamp.right',
        );
        expect(
          aabb.bottom,
          lessThanOrEqualTo(clamp.bottom + 1e-6),
          reason: 'rect leaked past clamp.bottom',
        );
      },
    );
  });

  group('Corner handle: vertical cursor drag does not shrink width', () {
    test(
      'bottomRight handle, slight rotation: dragging cursor straight down '
      'past clamp.bottom keeps width = initial width',
      () {
        // User reports: bottomRight corner under slight rotation, dragging
        // cursor straight down past clamp.bottom — the rect's WIDTH changes
        // even though cursor only moves vertically.
        const theta = math.pi / 12;
        final initial = Box.fromLTWH(50, 50, 100, 100, rotation: theta);
        final clamp = Box.fromLTRB(0, 0, 400, 200);
        final center = Vector2(100, 100);
        // Pointer starts at the rotated bottomRight corner.
        final initialPointerWorld = ClampHelpers.rotatePointAround(
          Vector2(150, 150),
          center,
          theta,
        );
        // Sweep cursor straight down (in screen / world coords) past clamp.
        for (int i = 1; i <= 50; i++) {
          // Pure vertical screen motion.
          final targetPointerWorld = Vector2(
            initialPointerWorld.x,
            initialPointerWorld.y + i * 5.0,
          );
          final result = BoxTransformer.resize(
            initialRect: initial,
            initialLocalPosition: initialPointerWorld,
            localPosition: targetPointerWorld,
            handle: HandlePosition.bottomRight,
            resizeMode: ResizeMode.freeform,
            initialFlip: Flip.none,
            rotation: theta,
            bindingStrategy: BindingStrategy.boundingBox,
            clampingRect: clamp,
            allowFlipping: false,
          );
          // With pure vertical cursor motion, width should equal the
          // un-rotated cursor projection onto the box's local x-axis. For
          // bottomRight, that means width *can* grow (because the rotated
          // cursor delta has a positive box-local x component) — but it
          // must NOT shrink below the initial width.
          expect(
            result.rect.width,
            greaterThanOrEqualTo(initial.width - 1e-6),
            reason: 'tick $i: width shrank below initial '
                '(${result.rect.width} < ${initial.width})',
          );
        }
      },
    );
  });

  group('Corner handle: monotonic LP projection at constraint corner', () {
    test(
      'bottomRight cursor sweep past constraint corner — both axes stay '
      'monotonic (regression for the old two-step LP non-monotonicity)',
      () {
        const theta = math.pi / 12;
        final initial = Box.fromLTWH(50, 50, 100, 100, rotation: theta);
        final clamp = Box.fromLTRB(0, 0, 800, 200);
        final center = Vector2(100, 100);
        final initialPointerWorld = ClampHelpers.rotatePointAround(
          Vector2(150, 150),
          center,
          theta,
        );
        // Phase 1: cursor goes straight down past clamp.bottom.
        // Phase 2: cursor sweeps right (cursor still below clamp.bottom).
        final widths = <double>[];
        final heights = <double>[];
        for (int i = 0; i <= 60; i++) {
          // For i ≤ 30, drag straight down; for i > 30, drag right.
          final downPart = i <= 30 ? i * 5.0 : 150.0;
          final rightPart = i > 30 ? (i - 30) * 5.0 : 0.0;
          final targetPointerWorld = Vector2(
            initialPointerWorld.x + rightPart,
            initialPointerWorld.y + downPart,
          );
          final result = BoxTransformer.resize(
            initialRect: initial,
            initialLocalPosition: initialPointerWorld,
            localPosition: targetPointerWorld,
            handle: HandlePosition.bottomRight,
            resizeMode: ResizeMode.freeform,
            initialFlip: Flip.none,
            rotation: theta,
            bindingStrategy: BindingStrategy.boundingBox,
            clampingRect: clamp,
            allowFlipping: false,
          );
          widths.add(result.rect.width);
          heights.add(result.rect.height);
        }
        // Width must be monotonic non-decreasing across the whole sweep
        // (cursor never moves left). Tolerance accommodates float precision
        // along the L2 projection's constraint line.
        for (int i = 1; i < widths.length; i++) {
          expect(
            widths[i],
            greaterThanOrEqualTo(widths[i - 1] - 1e-6),
            reason: 'tick $i: width regressed '
                '(${widths[i - 1]} → ${widths[i]})',
          );
        }
        // Height during phase 1 (cursor going down) must be non-decreasing.
        for (int i = 1; i <= 30; i++) {
          expect(
            heights[i],
            greaterThanOrEqualTo(heights[i - 1] - 1e-6),
            reason: 'tick $i (phase 1): height regressed '
                '(${heights[i - 1]} → ${heights[i]})',
          );
        }
      },
    );
  });

  group('Side handle: tight clamp at every tick of a sweep', () {
    test(
      'right handle: rect close to clamp.bottom — drag tick-by-tick keeps '
      'all rotated corners inside clamp',
      () {
        // Position the box so the rotated bottom-right corner is already
        // close to clamp.bottom. Drag right handle outward in tiny ticks.
        // At every tick, all rotated corners must stay inside clamp.
        const theta = math.pi / 12;
        final initial = Box.fromLTWH(50, 200, 100, 100, rotation: theta);
        final clamp = Box.fromLTRB(0, 0, 400, 320);
        final center = Vector2(100, 250);
        final initialPointerWorld = ClampHelpers.rotatePointAround(
          Vector2(150, 250),
          center,
          theta,
        );

        for (int i = 0; i <= 60; i++) {
          // Tiny 0.5 px ticks.
          final targetUnrotated = Vector2(150 + i * 0.5, 250);
          final targetPointerWorld = ClampHelpers.rotatePointAround(
            targetUnrotated,
            center,
            theta,
          );
          final result = BoxTransformer.resize(
            initialRect: initial,
            initialLocalPosition: initialPointerWorld,
            localPosition: targetPointerWorld,
            handle: HandlePosition.right,
            resizeMode: ResizeMode.freeform,
            initialFlip: Flip.none,
            rotation: theta,
            bindingStrategy: BindingStrategy.boundingBox,
            clampingRect: clamp,
            allowFlipping: false,
          );
          final r = result.rect;
          final rcenter = Vector2(
            (r.left + r.right) / 2,
            (r.top + r.bottom) / 2,
          );
          final corners = [
            Vector2(r.left, r.top),
            Vector2(r.right, r.top),
            Vector2(r.right, r.bottom),
            Vector2(r.left, r.bottom),
          ]
              .map(
                  (p) => ClampHelpers.rotatePointAround(p, rcenter, r.rotation))
              .toList();
          for (int k = 0; k < 4; k++) {
            final c = corners[k];
            expect(
              c.x,
              greaterThanOrEqualTo(clamp.left - 1e-4),
              reason: 'tick $i corner $k: x=${c.x} leaked past clamp.left',
            );
            expect(
              c.y,
              greaterThanOrEqualTo(clamp.top - 1e-4),
              reason: 'tick $i corner $k: y=${c.y} leaked past clamp.top',
            );
            expect(
              c.x,
              lessThanOrEqualTo(clamp.right + 1e-4),
              reason: 'tick $i corner $k: x=${c.x} leaked past clamp.right',
            );
            expect(
              c.y,
              lessThanOrEqualTo(clamp.bottom + 1e-4),
              reason: 'tick $i corner $k: y=${c.y} leaked past clamp.bottom',
            );
          }
        }
      },
    );
  });

  group('Force-flip during rotated resize keeps rect inside clamp', () {
    test(
      'bottomRight handle: drag pointer past topLeft anchor and beyond '
      'clamp.left — rotated rect stays inside clamp',
      () {
        // User drags the bottomRight corner of a rotated rect past the
        // topLeft anchor (force-flipping the rect to the LEFT of anchor),
        // and continues dragging past the clamp's left edge.
        const theta = math.pi / 12;
        final initial = Box.fromLTWH(150, 100, 100, 100, rotation: theta);
        final clamp = Box.fromLTRB(0, 0, 400, 400);
        final center = Vector2(200, 150);
        final initialPointerWorld = ClampHelpers.rotatePointAround(
          Vector2(250, 200),
          center,
          theta,
        );
        // Drag pointer far to the left + down to force a horizontal flip
        // past the clamp.
        final targetUnrotated = Vector2(-200, 200);
        final targetPointerWorld = ClampHelpers.rotatePointAround(
          targetUnrotated,
          center,
          theta,
        );
        final result = BoxTransformer.resize(
          initialRect: initial,
          initialLocalPosition: initialPointerWorld,
          localPosition: targetPointerWorld,
          handle: HandlePosition.bottomRight,
          resizeMode: ResizeMode.freeform,
          initialFlip: Flip.none,
          rotation: theta,
          bindingStrategy: BindingStrategy.boundingBox,
          clampingRect: clamp,
          allowFlipping: true,
        );
        // The resulting rect's rotated AABB must stay entirely inside
        // the clamp despite the flip.
        final r = result.rect;
        final rcenter = Vector2(
          (r.left + r.right) / 2,
          (r.top + r.bottom) / 2,
        );
        final corners = [
          Vector2(r.left, r.top),
          Vector2(r.right, r.top),
          Vector2(r.right, r.bottom),
          Vector2(r.left, r.bottom),
        ]
            .map((p) => ClampHelpers.rotatePointAround(p, rcenter, r.rotation))
            .toList();
        for (int k = 0; k < 4; k++) {
          expect(corners[k].x, greaterThanOrEqualTo(clamp.left - 1e-4),
              reason: 'corner $k leaked past clamp.left');
          expect(corners[k].y, greaterThanOrEqualTo(clamp.top - 1e-4),
              reason: 'corner $k leaked past clamp.top');
          expect(corners[k].x, lessThanOrEqualTo(clamp.right + 1e-4),
              reason: 'corner $k leaked past clamp.right');
          expect(corners[k].y, lessThanOrEqualTo(clamp.bottom + 1e-4),
              reason: 'corner $k leaked past clamp.bottom');
        }
      },
    );
  });

  group('Force-flip multi-tick: clamp respected throughout', () {
    test(
      'sweep cursor across anchor and past clamp.left — every tick stays '
      'inside clamp',
      () {
        const theta = math.pi / 12;
        final initial = Box.fromLTWH(150, 100, 100, 100, rotation: theta);
        final clamp = Box.fromLTRB(0, 0, 400, 400);
        final center = Vector2(200, 150);
        final initialPointerWorld = ClampHelpers.rotatePointAround(
          Vector2(250, 200),
          center,
          theta,
        );
        // Sweep from right of anchor past anchor past clamp.left.
        for (int i = 0; i <= 80; i++) {
          // Cursor goes from x=250 to x=-200 in unrotated frame (across
          // anchor at x=150, then past clamp.left at x=0).
          final unrotatedX = 250.0 - i * 6.0;
          final targetUnrotated = Vector2(unrotatedX, 200);
          final targetPointerWorld = ClampHelpers.rotatePointAround(
            targetUnrotated,
            center,
            theta,
          );
          final result = BoxTransformer.resize(
            initialRect: initial,
            initialLocalPosition: initialPointerWorld,
            localPosition: targetPointerWorld,
            handle: HandlePosition.bottomRight,
            resizeMode: ResizeMode.freeform,
            initialFlip: Flip.none,
            rotation: theta,
            bindingStrategy: BindingStrategy.boundingBox,
            clampingRect: clamp,
            allowFlipping: true,
          );
          final r = result.rect;
          final rcenter = Vector2(
            (r.left + r.right) / 2,
            (r.top + r.bottom) / 2,
          );
          final corners = [
            Vector2(r.left, r.top),
            Vector2(r.right, r.top),
            Vector2(r.right, r.bottom),
            Vector2(r.left, r.bottom),
          ]
              .map(
                  (p) => ClampHelpers.rotatePointAround(p, rcenter, r.rotation))
              .toList();
          for (int k = 0; k < 4; k++) {
            expect(corners[k].x, greaterThanOrEqualTo(clamp.left - 1e-3),
                reason: 'tick $i corner $k: x=${corners[k].x} '
                    'leaked past clamp.left');
            expect(corners[k].y, greaterThanOrEqualTo(clamp.top - 1e-3),
                reason: 'tick $i corner $k: y=${corners[k].y} '
                    'leaked past clamp.top');
            expect(corners[k].x, lessThanOrEqualTo(clamp.right + 1e-3),
                reason: 'tick $i corner $k: x=${corners[k].x} '
                    'leaked past clamp.right');
            expect(corners[k].y, lessThanOrEqualTo(clamp.bottom + 1e-3),
                reason: 'tick $i corner $k: y=${corners[k].y} '
                    'leaked past clamp.bottom');
          }
        }
      },
    );
  });

  group('Force-flip at large rotation: clamp respected', () {
    test(
      'theta=π/4, drag past anchor in extreme amounts — no leak',
      () {
        const theta = math.pi / 4;
        final initial = Box.fromLTWH(150, 150, 100, 100, rotation: theta);
        final clamp = Box.fromLTRB(0, 0, 400, 400);
        final center = Vector2(200, 200);
        final initialPointerWorld = ClampHelpers.rotatePointAround(
          Vector2(250, 250),
          center,
          theta,
        );
        // Sweep cursor in many directions, including past anchor and past
        // clamp.
        for (final pair in const [
          [-300, 250], // far left
          [250, -300], // far up
          [-300, -300], // diagonal up-left (far)
          [600, 600], // diagonal far down-right
          [-100, 250], // mild left flip
          [50, 50], // past anchor diagonally, modest amount
          [50, 250], // past anchor x only
          [250, 50], // past anchor y only
        ]) {
          final targetUnrotated =
              Vector2(pair[0].toDouble(), pair[1].toDouble());
          final targetPointerWorld = ClampHelpers.rotatePointAround(
            targetUnrotated,
            center,
            theta,
          );
          final result = BoxTransformer.resize(
            initialRect: initial,
            initialLocalPosition: initialPointerWorld,
            localPosition: targetPointerWorld,
            handle: HandlePosition.bottomRight,
            resizeMode: ResizeMode.freeform,
            initialFlip: Flip.none,
            rotation: theta,
            bindingStrategy: BindingStrategy.boundingBox,
            clampingRect: clamp,
            allowFlipping: true,
          );
          final r = result.rect;
          final rcenter = Vector2(
            (r.left + r.right) / 2,
            (r.top + r.bottom) / 2,
          );
          final corners = [
            Vector2(r.left, r.top),
            Vector2(r.right, r.top),
            Vector2(r.right, r.bottom),
            Vector2(r.left, r.bottom),
          ]
              .map(
                  (p) => ClampHelpers.rotatePointAround(p, rcenter, r.rotation))
              .toList();
          for (int k = 0; k < 4; k++) {
            expect(corners[k].x, greaterThanOrEqualTo(clamp.left - 1e-3),
                reason: 'pair=$pair corner $k: leaked clamp.left '
                    '(x=${corners[k].x})');
            expect(corners[k].y, greaterThanOrEqualTo(clamp.top - 1e-3),
                reason: 'pair=$pair corner $k: leaked clamp.top '
                    '(y=${corners[k].y})');
            expect(corners[k].x, lessThanOrEqualTo(clamp.right + 1e-3),
                reason: 'pair=$pair corner $k: leaked clamp.right');
            expect(corners[k].y, lessThanOrEqualTo(clamp.bottom + 1e-3),
                reason: 'pair=$pair corner $k: leaked clamp.bottom');
          }
        }
      },
    );
  });

  group('Side-handle force-flip near clamp edge', () {
    test(
      'right handle, box near clamp.left: drag past anchor + past clamp '
      '— rotated polygon stays in clamp',
      () {
        // Box near clamp.left. anchor for right handle = centerLeft.
        // Drag pointer far to the left, past anchor (force x-flip) AND
        // past clamp.left=0. With widthSign aware of the flip, the LP
        // should constrain the actually-flipped rect's rendered polygon
        // to stay in clamp. Note: the unrotated stored bounds may extend
        // past the clamp on stretched/flipped geometries — that's
        // expected under boundingBox semantics ("rendered AABB stays
        // in the clamp"); the stored rect is invisible storage.
        const theta = math.pi / 12;
        final initial = Box.fromLTWH(40, 200, 100, 100, rotation: theta);
        final clamp = Box.fromLTRB(0, 0, 400, 400);
        final center = Vector2(90, 250);
        // Pointer starts at the rotated right-edge midpoint (centerRight).
        final initialPointerWorld = ClampHelpers.rotatePointAround(
          Vector2(140, 250),
          center,
          theta,
        );
        // Drag pointer way past anchor on the left, past clamp.left.
        final targetPointerWorld = ClampHelpers.rotatePointAround(
          Vector2(-200, 250),
          center,
          theta,
        );
        final result = BoxTransformer.resize(
          initialRect: initial,
          initialLocalPosition: initialPointerWorld,
          localPosition: targetPointerWorld,
          handle: HandlePosition.right,
          resizeMode: ResizeMode.freeform,
          initialFlip: Flip.none,
          rotation: theta,
          bindingStrategy: BindingStrategy.boundingBox,
          clampingRect: clamp,
          allowFlipping: true,
        );
        final r = result.rect;
        // Rotated polygon corners in clamp (the boundingBox contract).
        final rcenter = Vector2(
          (r.left + r.right) / 2,
          (r.top + r.bottom) / 2,
        );
        final corners = [
          Vector2(r.left, r.top),
          Vector2(r.right, r.top),
          Vector2(r.right, r.bottom),
          Vector2(r.left, r.bottom),
        ]
            .map((p) => ClampHelpers.rotatePointAround(p, rcenter, r.rotation))
            .toList();
        for (int k = 0; k < 4; k++) {
          expect(corners[k].x, greaterThanOrEqualTo(clamp.left - 1e-3),
              reason: 'rotated corner $k leaked clamp.left '
                  '(x=${corners[k].x})');
          expect(corners[k].x, lessThanOrEqualTo(clamp.right + 1e-3),
              reason: 'rotated corner $k leaked clamp.right '
                  '(x=${corners[k].x})');
          expect(corners[k].y, greaterThanOrEqualTo(clamp.top - 1e-3),
              reason: 'rotated corner $k leaked clamp.top '
                  '(y=${corners[k].y})');
          expect(corners[k].y, lessThanOrEqualTo(clamp.bottom + 1e-3),
              reason: 'rotated corner $k leaked clamp.bottom '
                  '(y=${corners[k].y})');
        }
      },
    );

    test(
      'top handle, box near clamp.bottom: drag past anchor + past clamp '
      '— rotated polygon stays in clamp',
      () {
        // Symmetric scenario for vertical-axis flip with top side handle.
        const theta = math.pi / 12;
        final initial = Box.fromLTWH(150, 280, 100, 100, rotation: theta);
        final clamp = Box.fromLTRB(0, 0, 400, 400);
        final center = Vector2(200, 330);
        // Initial pointer at rotated topCenter.
        final initialPointerWorld = ClampHelpers.rotatePointAround(
          Vector2(200, 280),
          center,
          theta,
        );
        // Drag pointer way down past anchor (bottomCenter at y=380) and
        // past clamp.bottom=400.
        final targetPointerWorld = ClampHelpers.rotatePointAround(
          Vector2(200, 600),
          center,
          theta,
        );
        final result = BoxTransformer.resize(
          initialRect: initial,
          initialLocalPosition: initialPointerWorld,
          localPosition: targetPointerWorld,
          handle: HandlePosition.top,
          resizeMode: ResizeMode.freeform,
          initialFlip: Flip.none,
          rotation: theta,
          bindingStrategy: BindingStrategy.boundingBox,
          clampingRect: clamp,
          allowFlipping: true,
        );
        final r = result.rect;
        final rcenter = Vector2(
          (r.left + r.right) / 2,
          (r.top + r.bottom) / 2,
        );
        final corners = [
          Vector2(r.left, r.top),
          Vector2(r.right, r.top),
          Vector2(r.right, r.bottom),
          Vector2(r.left, r.bottom),
        ]
            .map((p) => ClampHelpers.rotatePointAround(p, rcenter, r.rotation))
            .toList();
        for (int k = 0; k < 4; k++) {
          expect(corners[k].y, greaterThanOrEqualTo(clamp.top - 1e-3),
              reason: 'rotated corner $k leaked clamp.top');
          expect(corners[k].y, lessThanOrEqualTo(clamp.bottom + 1e-3),
              reason: 'rotated corner $k leaked clamp.bottom');
          expect(corners[k].x, greaterThanOrEqualTo(clamp.left - 1e-3));
          expect(corners[k].x, lessThanOrEqualTo(clamp.right + 1e-3));
        }
      },
    );
  });

  group('User screenshot: 45° box near top clamp, drag bottomRight up', () {
    test(
      'box rotated π/4 near clamp.top, drag bottomRight cursor far up past '
      'clamp.top — flipped rect must stay inside clamp',
      () {
        // Clamping rect ≈ a thin band at the top (matches the screenshot).
        // Box rotated 45° centered just below the clamp band. User grabs
        // the bottomRight corner and drags cursor far up past clamp.top.
        const theta = math.pi / 4;
        final initial = Box.fromLTWH(100, 50, 100, 100, rotation: theta);
        final clamp = Box.fromLTRB(0, 0, 400, 400);
        final center = Vector2(150, 100);
        // Initial pointer = rotated bottomRight in world.
        final initialPointerWorld = ClampHelpers.rotatePointAround(
          Vector2(200, 150),
          center,
          theta,
        );
        // Drag cursor far upward past clamp.top=0 — force diagonal flip
        // past topLeft anchor and past the clamping rect top edge.
        final targetPointerWorld = ClampHelpers.rotatePointAround(
          Vector2(50, -300),
          center,
          theta,
        );
        final result = BoxTransformer.resize(
          initialRect: initial,
          initialLocalPosition: initialPointerWorld,
          localPosition: targetPointerWorld,
          handle: HandlePosition.bottomRight,
          resizeMode: ResizeMode.freeform,
          initialFlip: Flip.none,
          rotation: theta,
          bindingStrategy: BindingStrategy.boundingBox,
          clampingRect: clamp,
          allowFlipping: true,
        );
        final r = result.rect;
        // ignore: avoid_print
        print('User scenario result rect: $r');
        // ignore: avoid_print
        print('User scenario result flip: ${result.flip}');
        // Rotated quad corners must be inside clamp (boundingBox contract).
        final rcenter = Vector2(
          (r.left + r.right) / 2,
          (r.top + r.bottom) / 2,
        );
        final corners = [
          Vector2(r.left, r.top),
          Vector2(r.right, r.top),
          Vector2(r.right, r.bottom),
          Vector2(r.left, r.bottom),
        ]
            .map((p) => ClampHelpers.rotatePointAround(p, rcenter, r.rotation))
            .toList();
        for (int k = 0; k < 4; k++) {
          // ignore: avoid_print
          print('Rotated corner $k: ${corners[k]}');
          expect(corners[k].x, greaterThanOrEqualTo(clamp.left - 1e-3),
              reason: 'rotated corner $k leaked clamp.left');
          expect(corners[k].y, greaterThanOrEqualTo(clamp.top - 1e-3),
              reason: 'rotated corner $k leaked clamp.top '
                  '(y=${corners[k].y})');
          expect(corners[k].x, lessThanOrEqualTo(clamp.right + 1e-3),
              reason: 'rotated corner $k leaked clamp.right');
          expect(corners[k].y, lessThanOrEqualTo(clamp.bottom + 1e-3),
              reason: 'rotated corner $k leaked clamp.bottom');
        }
      },
    );
  });

  group('User screenshot: harsh-delta force-flip outside clamp', () {
    // Sweep over many drag directions and corner handles, asserting that
    // every result keeps the box inside the clamp.
    test(
      'all 4 corner handles × 6 drag directions × 2 rotation angles — '
      'no leak',
      () {
        final clamp = Box.fromLTRB(0, 0, 400, 400);
        final dragsUnrotated = const <List<double>>[
          [-300, 250], // far left
          [250, -300], // far up
          [-300, -300], // far up-left (diagonal)
          [600, 250], // far right
          [250, 600], // far down
          [600, 600], // far down-right
        ];
        final corners = const [
          HandlePosition.topLeft,
          HandlePosition.topRight,
          HandlePosition.bottomLeft,
          HandlePosition.bottomRight,
        ];
        // Use a few rotation angles, including 45° (matches screenshot).
        final thetas = [math.pi / 12, math.pi / 4, -math.pi / 4];
        for (final theta in thetas) {
          // Position near various corners of clamp.
          final positions = const [
            [50, 50], // near top-left
            [250, 50], // near top-right
            [50, 250], // near bottom-left
            [250, 250], // near bottom-right
          ];
          for (final pos in positions) {
            final initial = Box.fromLTWH(
              pos[0].toDouble(),
              pos[1].toDouble(),
              100,
              100,
              rotation: theta,
            );
            final center = Vector2(pos[0] + 50, pos[1] + 50);
            for (final handle in corners) {
              final local = handle.anchor(initial); // OPPOSITE corner
              // The handle's position (in unrotated frame) is the corner
              // OPPOSITE the anchor.
              final initialPointerLocal = Vector2(
                local.x == initial.left ? initial.right : initial.left,
                local.y == initial.top ? initial.bottom : initial.top,
              );
              final initialPointerWorld = ClampHelpers.rotatePointAround(
                  initialPointerLocal, center, theta);
              for (final drag in dragsUnrotated) {
                final targetPointerWorld = ClampHelpers.rotatePointAround(
                  Vector2(drag[0], drag[1]),
                  center,
                  theta,
                );
                final result = BoxTransformer.resize(
                  initialRect: initial,
                  initialLocalPosition: initialPointerWorld,
                  localPosition: targetPointerWorld,
                  handle: handle,
                  resizeMode: ResizeMode.freeform,
                  initialFlip: Flip.none,
                  rotation: theta,
                  bindingStrategy: BindingStrategy.boundingBox,
                  clampingRect: clamp,
                  allowFlipping: true,
                );
                final r = result.rect;
                final scenario =
                    'theta=$theta pos=$pos handle=$handle drag=$drag';
                final rcenter =
                    Vector2((r.left + r.right) / 2, (r.top + r.bottom) / 2);
                final rotatedCorners = [
                  Vector2(r.left, r.top),
                  Vector2(r.right, r.top),
                  Vector2(r.right, r.bottom),
                  Vector2(r.left, r.bottom),
                ]
                    .map((p) =>
                        ClampHelpers.rotatePointAround(p, rcenter, r.rotation))
                    .toList();
                for (int k = 0; k < 4; k++) {
                  expect(rotatedCorners[k].x,
                      greaterThanOrEqualTo(clamp.left - 1e-3),
                      reason: '$scenario: rot corner $k.x leaked');
                  expect(rotatedCorners[k].y,
                      greaterThanOrEqualTo(clamp.top - 1e-3),
                      reason: '$scenario: rot corner $k.y leaked');
                  expect(rotatedCorners[k].x,
                      lessThanOrEqualTo(clamp.right + 1e-3),
                      reason: '$scenario: rot corner $k.x leaked');
                  expect(rotatedCorners[k].y,
                      lessThanOrEqualTo(clamp.bottom + 1e-3),
                      reason: '$scenario: rot corner $k.y leaked');
                }
              }
            }
          }
        }
      },
    );
  });

  group('Thin clamping rect: harsh-delta resize stays inside', () {
    // Mirrors the screenshot setup: clamping rect is a thin band, box
    // sitting partly inside it, user drags corner far outside.
    test(
      'thin horizontal clamp + various rotations + force-flip drags '
      '— rect stays inside clamp',
      () {
        final clamp = Box.fromLTRB(0, 0, 800, 150); // thin strip
        final thetas = [
          math.pi / 12,
          math.pi / 6, // ≈ 30°, matches screenshot
          math.pi / 4,
          -math.pi / 6,
        ];
        // Drag targets in the unrotated frame — far outside the strip.
        final targets = const <List<double>>[
          [400, -300], // far up
          [400, 600], // far down
          [-300, 75], // far left
          [1100, 75], // far right
          [-300, 600], // far down-left
          [1100, 600], // far down-right
          [-300, -300], // far up-left
          [1100, -300], // far up-right
        ];
        // Use a small box so its rotated AABB fits inside the thin clamp
        // for all tested rotations. 50×50 → max AABB 50*√2 ≈ 70.7 px.
        const boxSize = 50.0;
        final corners = const [
          HandlePosition.topLeft,
          HandlePosition.topRight,
          HandlePosition.bottomLeft,
          HandlePosition.bottomRight,
        ];
        for (final theta in thetas) {
          final rect = Box.fromLTWH(
            375,
            50,
            boxSize,
            boxSize,
            rotation: theta,
          );
          final center = Vector2(
            (rect.left + rect.right) / 2,
            (rect.top + rect.bottom) / 2,
          );
          for (final handle in corners) {
            final localCorner = handle.anchor(rect);
            // The dragged corner is OPPOSITE to the anchor.
            final draggedLocal = Vector2(
              localCorner.x == rect.left ? rect.right : rect.left,
              localCorner.y == rect.top ? rect.bottom : rect.top,
            );
            final initialPointerWorld = ClampHelpers.rotatePointAround(
              draggedLocal,
              center,
              theta,
            );
            for (final target in targets) {
              final targetPointerWorld = ClampHelpers.rotatePointAround(
                Vector2(target[0], target[1]),
                center,
                theta,
              );
              final result = BoxTransformer.resize(
                initialRect: rect,
                initialLocalPosition: initialPointerWorld,
                localPosition: targetPointerWorld,
                handle: handle,
                resizeMode: ResizeMode.freeform,
                initialFlip: Flip.none,
                rotation: theta,
                bindingStrategy: BindingStrategy.boundingBox,
                clampingRect: clamp,
                allowFlipping: true,
              );
              final r = result.rect;
              final scenario = 'theta=${theta.toStringAsFixed(4)} '
                  'handle=$handle target=$target';
              // Rotated polygon corners must stay inside clamp; the
              // unrotated stored bounds may extend past on stretched/
              // flipped geometries (boundingBox = "rendered AABB inside",
              // not "stored bounds inside").
              final rcenter = Vector2(
                (r.left + r.right) / 2,
                (r.top + r.bottom) / 2,
              );
              final corners = [
                Vector2(r.left, r.top),
                Vector2(r.right, r.top),
                Vector2(r.right, r.bottom),
                Vector2(r.left, r.bottom),
              ]
                  .map((p) =>
                      ClampHelpers.rotatePointAround(p, rcenter, r.rotation))
                  .toList();
              for (int k = 0; k < 4; k++) {
                expect(corners[k].x, greaterThanOrEqualTo(clamp.left - 1e-3),
                    reason: '$scenario: rotated corner $k leaked clamp.left');
                expect(corners[k].x, lessThanOrEqualTo(clamp.right + 1e-3),
                    reason: '$scenario: rotated corner $k leaked clamp.right');
                expect(corners[k].y, greaterThanOrEqualTo(clamp.top - 1e-3),
                    reason: '$scenario: rotated corner $k leaked clamp.top');
                expect(corners[k].y, lessThanOrEqualTo(clamp.bottom + 1e-3),
                    reason: '$scenario: rotated corner $k leaked clamp.bottom');
              }
            }
          }
        }
      },
    );
  });

  group('Force-flip via topLeft handle past bottomRight anchor', () {
    test(
      'box near clamp.right; drag topLeft cursor past bottomRight to '
      'force x-flip — rect extends past clamp.right?',
      () {
        // Box near clamp.right edge. Drag topLeft cursor far to the right
        // (past anchor at bottomRight, past clamp.right).
        const theta = math.pi / 12;
        final initial = Box.fromLTWH(250, 100, 100, 100, rotation: theta);
        final clamp = Box.fromLTRB(0, 0, 400, 400);
        final center = Vector2(300, 150);
        final initialPointerWorld = ClampHelpers.rotatePointAround(
          Vector2(250, 100),
          center,
          theta,
        );
        // Drag topLeft cursor far to right past bottomRight.
        final targetPointerWorld = ClampHelpers.rotatePointAround(
          Vector2(800, 100),
          center,
          theta,
        );
        final result = BoxTransformer.resize(
          initialRect: initial,
          initialLocalPosition: initialPointerWorld,
          localPosition: targetPointerWorld,
          handle: HandlePosition.topLeft,
          resizeMode: ResizeMode.freeform,
          initialFlip: Flip.none,
          rotation: theta,
          bindingStrategy: BindingStrategy.boundingBox,
          clampingRect: clamp,
          allowFlipping: true,
        );
        // ignore: avoid_print
        print('topLeft flip result rect: ${result.rect}');
        // ignore: avoid_print
        print('topLeft flip result flip: ${result.flip}');
        final r = result.rect;
        final rcenter = Vector2(
          (r.left + r.right) / 2,
          (r.top + r.bottom) / 2,
        );
        final corners = [
          Vector2(r.left, r.top),
          Vector2(r.right, r.top),
          Vector2(r.right, r.bottom),
          Vector2(r.left, r.bottom),
        ]
            .map((p) => ClampHelpers.rotatePointAround(p, rcenter, r.rotation))
            .toList();
        for (int k = 0; k < 4; k++) {
          // ignore: avoid_print
          print('Corner $k: ${corners[k]}');
        }
        for (int k = 0; k < 4; k++) {
          expect(corners[k].x, lessThanOrEqualTo(clamp.right + 1e-3),
              reason: 'corner $k leaked clamp.right (x=${corners[k].x})');
          expect(corners[k].y, greaterThanOrEqualTo(clamp.top - 1e-3),
              reason: 'corner $k leaked clamp.top (y=${corners[k].y})');
          expect(corners[k].y, lessThanOrEqualTo(clamp.bottom + 1e-3),
              reason: 'corner $k leaked clamp.bottom (y=${corners[k].y})');
          expect(corners[k].x, greaterThanOrEqualTo(clamp.left - 1e-3),
              reason: 'corner $k leaked clamp.left');
        }
      },
    );
  });

  group('Force-flip near clamp edge (user scenario)', () {
    test(
      'box near clamp.right; drag bottomRight outwards to right past '
      'clamp.right then flip — stays in clamp',
      () {
        // Box right edge is 20px from clamp.right. Drag bottomRight cursor
        // far to the right past clamp.right (no flip needed yet, just
        // clamping). Then continue dragging far enough to flip past anchor.
        const theta = math.pi / 12;
        final initial = Box.fromLTWH(280, 200, 100, 100, rotation: theta);
        final clamp = Box.fromLTRB(0, 0, 400, 400);
        final center = Vector2(330, 250);
        final initialPointerWorld = ClampHelpers.rotatePointAround(
          Vector2(380, 300),
          center,
          theta,
        );
        // Drag cursor far up-and-left to force diagonal flip.
        final targetPointerWorld = ClampHelpers.rotatePointAround(
          Vector2(-200, -200),
          center,
          theta,
        );
        final result = BoxTransformer.resize(
          initialRect: initial,
          initialLocalPosition: initialPointerWorld,
          localPosition: targetPointerWorld,
          handle: HandlePosition.bottomRight,
          resizeMode: ResizeMode.freeform,
          initialFlip: Flip.none,
          rotation: theta,
          bindingStrategy: BindingStrategy.boundingBox,
          clampingRect: clamp,
          allowFlipping: true,
        );
        // Print diagnostic
        // ignore: avoid_print
        print('Result rect: ${result.rect}');
        // ignore: avoid_print
        print('Result flip: ${result.flip}');
        final r = result.rect;
        final rcenter = Vector2(
          (r.left + r.right) / 2,
          (r.top + r.bottom) / 2,
        );
        final corners = [
          Vector2(r.left, r.top),
          Vector2(r.right, r.top),
          Vector2(r.right, r.bottom),
          Vector2(r.left, r.bottom),
        ]
            .map((p) => ClampHelpers.rotatePointAround(p, rcenter, r.rotation))
            .toList();
        // ignore: avoid_print
        for (int k = 0; k < 4; k++) {
          // ignore: avoid_print
          print('Corner $k: ${corners[k]}');
        }
        for (int k = 0; k < 4; k++) {
          expect(corners[k].x, greaterThanOrEqualTo(clamp.left - 1e-3),
              reason: 'corner $k leaked clamp.left');
          expect(corners[k].y, greaterThanOrEqualTo(clamp.top - 1e-3),
              reason: 'corner $k leaked clamp.top');
        }
      },
    );

    test(
      'box near clamp.left; drag bottomRight INNER corner outwards (right) '
      'far enough to flip past anchor on the right side',
      () {
        // Box near LEFT edge. inner-most corner from a left-near box is
        // the bottomRight (or topRight). User drags it AWAY from anchor
        // = far to the LEFT past the topLeft anchor. The flipped rect
        // would extend to the LEFT of anchor, possibly past clamp.left.
        const theta = math.pi / 12;
        final initial = Box.fromLTWH(20, 200, 100, 100, rotation: theta);
        final clamp = Box.fromLTRB(0, 0, 400, 400);
        final center = Vector2(70, 250);
        final initialPointerWorld = ClampHelpers.rotatePointAround(
          Vector2(120, 300),
          center,
          theta,
        );
        // Drag cursor far left (past anchor at x=20, past clamp.left=0).
        final targetPointerWorld = ClampHelpers.rotatePointAround(
          Vector2(-300, 250),
          center,
          theta,
        );
        final result = BoxTransformer.resize(
          initialRect: initial,
          initialLocalPosition: initialPointerWorld,
          localPosition: targetPointerWorld,
          handle: HandlePosition.bottomRight,
          resizeMode: ResizeMode.freeform,
          initialFlip: Flip.none,
          rotation: theta,
          bindingStrategy: BindingStrategy.boundingBox,
          clampingRect: clamp,
          allowFlipping: true,
        );
        // ignore: avoid_print
        print('Left-edge box result rect: ${result.rect}');
        // ignore: avoid_print
        print('Left-edge box result flip: ${result.flip}');
        final r = result.rect;
        final rcenter = Vector2(
          (r.left + r.right) / 2,
          (r.top + r.bottom) / 2,
        );
        final corners = [
          Vector2(r.left, r.top),
          Vector2(r.right, r.top),
          Vector2(r.right, r.bottom),
          Vector2(r.left, r.bottom),
        ]
            .map((p) => ClampHelpers.rotatePointAround(p, rcenter, r.rotation))
            .toList();
        for (int k = 0; k < 4; k++) {
          // ignore: avoid_print
          print('Corner $k: ${corners[k]}');
        }
        for (int k = 0; k < 4; k++) {
          expect(corners[k].x, greaterThanOrEqualTo(clamp.left - 1e-3),
              reason: 'corner $k leaked clamp.left');
        }
      },
    );
  });

  group('Force-flip with constraints: clamp respected', () {
    test(
      'diagonal flip with min/max constraints stays inside clamp',
      () {
        const theta = math.pi / 12;
        final initial = Box.fromLTWH(150, 150, 100, 100, rotation: theta);
        final clamp = Box.fromLTRB(0, 0, 400, 400);
        final center = Vector2(200, 200);
        final constraints = const Constraints(
          minWidth: 50,
          maxWidth: 400,
          minHeight: 50,
          maxHeight: 400,
        );
        final initialPointerWorld = ClampHelpers.rotatePointAround(
          Vector2(250, 250),
          center,
          theta,
        );
        // Drag bottomRight cursor past topLeft anchor on BOTH axes
        // (force diagonal flip), then keep dragging past clamp.left and
        // clamp.top.
        for (int i = 0; i <= 80; i++) {
          final ux = 250.0 - i * 7.0;
          final uy = 250.0 - i * 7.0;
          final targetPointerWorld = ClampHelpers.rotatePointAround(
            Vector2(ux, uy),
            center,
            theta,
          );
          final result = BoxTransformer.resize(
            initialRect: initial,
            initialLocalPosition: initialPointerWorld,
            localPosition: targetPointerWorld,
            handle: HandlePosition.bottomRight,
            resizeMode: ResizeMode.freeform,
            initialFlip: Flip.none,
            rotation: theta,
            bindingStrategy: BindingStrategy.boundingBox,
            clampingRect: clamp,
            constraints: constraints,
            allowFlipping: true,
          );
          final r = result.rect;
          final rcenter = Vector2(
            (r.left + r.right) / 2,
            (r.top + r.bottom) / 2,
          );
          final corners = [
            Vector2(r.left, r.top),
            Vector2(r.right, r.top),
            Vector2(r.right, r.bottom),
            Vector2(r.left, r.bottom),
          ]
              .map(
                  (p) => ClampHelpers.rotatePointAround(p, rcenter, r.rotation))
              .toList();
          for (int k = 0; k < 4; k++) {
            expect(corners[k].x, greaterThanOrEqualTo(clamp.left - 1e-3),
                reason: 'tick $i corner $k: leaked past clamp.left');
            expect(corners[k].y, greaterThanOrEqualTo(clamp.top - 1e-3),
                reason: 'tick $i corner $k: leaked past clamp.top');
            expect(corners[k].x, lessThanOrEqualTo(clamp.right + 1e-3),
                reason: 'tick $i corner $k: leaked past clamp.right');
            expect(corners[k].y, lessThanOrEqualTo(clamp.bottom + 1e-3),
                reason: 'tick $i corner $k: leaked past clamp.bottom');
          }
        }
      },
    );
  });

  group('Side handle clamp leak: monotonic projection at boundary', () {
    test(
      'right handle: tiny outward deltas near clamp give monotonic width',
      () {
        // The user reports: dragging the right side handle in tiny ticks,
        // when the rotated bottom-right corner intersects clamp.bottom,
        // the width briefly *decreases* (or grows backward) before
        // settling. Symptom of a non-monotonic projection at the
        // feasibility boundary.
        const theta = math.pi / 12;
        // Position the rect so the bottom-right corner is close to the
        // clamp's bottom edge at the initial size, ready to bind.
        final initial = Box.fromLTWH(150, 250, 100, 100, rotation: theta);
        final clamp = Box.fromLTRB(0, 0, 400, 400);
        final center = Vector2(200, 300);
        // Sweep pointer rightward in 5 px ticks past the cap.
        const startUnrotatedX = 250.0; // initial right edge midpoint.x
        final pointerYUnrotated = 300.0; // anchor.y in unrotated
        final widths = <double>[];
        for (int i = 0; i <= 20; i++) {
          final targetUnrotatedX = startUnrotatedX + i * 5.0;
          final targetUnrotated = Vector2(targetUnrotatedX, pointerYUnrotated);
          final initialUnrotated = Vector2(startUnrotatedX, pointerYUnrotated);
          final initialPointerWorld =
              ClampHelpers.rotatePointAround(initialUnrotated, center, theta);
          final targetPointerWorld =
              ClampHelpers.rotatePointAround(targetUnrotated, center, theta);
          final result = BoxTransformer.resize(
            initialRect: initial,
            initialLocalPosition: initialPointerWorld,
            localPosition: targetPointerWorld,
            handle: HandlePosition.right,
            resizeMode: ResizeMode.freeform,
            initialFlip: Flip.none,
            rotation: theta,
            bindingStrategy: BindingStrategy.boundingBox,
            clampingRect: clamp,
            allowFlipping: false,
          );
          widths.add(result.rect.width);
          // At every tick, the 4 rotated corners must stay in clamp.
          final r = result.rect;
          final rcx = (r.left + r.right) / 2;
          final rcy = (r.top + r.bottom) / 2;
          final rcenter = Vector2(rcx, rcy);
          final corners = [
            Vector2(r.left, r.top),
            Vector2(r.right, r.top),
            Vector2(r.right, r.bottom),
            Vector2(r.left, r.bottom),
          ]
              .map(
                  (p) => ClampHelpers.rotatePointAround(p, rcenter, r.rotation))
              .toList();
          for (final c in corners) {
            expect(
              c.x,
              greaterThanOrEqualTo(clamp.left - 1e-4),
              reason: 'tick $i: corner.x leaked left of clamp',
            );
            expect(
              c.y,
              greaterThanOrEqualTo(clamp.top - 1e-4),
              reason: 'tick $i: corner.y leaked above clamp',
            );
            expect(
              c.x,
              lessThanOrEqualTo(clamp.right + 1e-4),
              reason: 'tick $i: corner.x leaked right of clamp',
            );
            expect(
              c.y,
              lessThanOrEqualTo(clamp.bottom + 1e-4),
              reason: 'tick $i: corner.y leaked below clamp',
            );
          }
        }
        // Width must be non-decreasing across the sweep.
        for (int i = 1; i < widths.length; i++) {
          expect(
            widths[i],
            greaterThanOrEqualTo(widths[i - 1] - 1e-6),
            reason:
                'width regressed at tick $i: ${widths[i - 1]} → ${widths[i]}',
          );
        }
      },
    );
  });

  group('Right side handle under rotation — symmetricScale mode', () {
    test(
      'aspect ratio preserved + symmetric about center (both axes extend)',
      () {
        final initial = Box.fromLTWH(200, 200, 100, 100, rotation: theta);
        final result = _resize(
          initial: initial,
          handle: HandlePosition.right,
          initialUnrotated: Vector2(300, 250),
          targetUnrotated: Vector2(325, 250),
          mode: ResizeMode.symmetricScale,
        );

        // Width grew 50 → height also grew 50 (1:1 aspect) → 150×150.
        expect(result.rect.width, closeTo(150, 1e-9));
        expect(result.rect.height, closeTo(150, 1e-9));
      },
    );
  });
}

RawResizeResult _resize({
  required Box initial,
  required HandlePosition handle,
  required Vector2 initialUnrotated,
  required Vector2 targetUnrotated,
  ResizeMode mode = ResizeMode.freeform,
  BindingStrategy bindingStrategy = BindingStrategy.originalBox,
  Box? clampingRect,
}) {
  final center = Vector2(
    (initial.left + initial.right) / 2,
    (initial.top + initial.bottom) / 2,
  );
  final initialPointerWorld = ClampHelpers.rotatePointAround(
      initialUnrotated, center, initial.rotation);
  final targetPointerWorld =
      ClampHelpers.rotatePointAround(targetUnrotated, center, initial.rotation);

  return BoxTransformer.resize(
    initialRect: initial,
    initialLocalPosition: initialPointerWorld,
    localPosition: targetPointerWorld,
    handle: handle,
    resizeMode: mode,
    initialFlip: Flip.none,
    rotation: initial.rotation,
    bindingStrategy: bindingStrategy,
    clampingRect: clampingRect ?? Box.largest,
    allowFlipping: true,
  );
}

/// Asserts that [handle]'s anchor (midpoint of the OPPOSITE side) is at
/// the same world-space point in [initial] and [result].
void _expectAnchorPreserved(Box initial, Box result, HandlePosition handle) {
  final initCenter = Vector2(
    (initial.left + initial.right) / 2,
    (initial.top + initial.bottom) / 2,
  );
  final resCenter = Vector2(
    (result.left + result.right) / 2,
    (result.top + result.bottom) / 2,
  );
  final initialAnchorLocal = handle.anchor(initial);
  final resultAnchorLocal = handle.anchor(result);
  final initialAnchorWorld = ClampHelpers.rotatePointAround(
      initialAnchorLocal, initCenter, initial.rotation);
  final resultAnchorWorld = ClampHelpers.rotatePointAround(
      resultAnchorLocal, resCenter, result.rotation);
  expect(resultAnchorWorld.x, closeTo(initialAnchorWorld.x, 1e-6));
  expect(resultAnchorWorld.y, closeTo(initialAnchorWorld.y, 1e-6));
}
