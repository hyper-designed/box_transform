import 'dart:math' as math;

import 'package:flutter/widgets.dart';
import 'package:flutter_box_transform/flutter_box_transform.dart';
import 'package:flutter_test/flutter_test.dart';

void main() {
  group('RotatedLayout.rotateOffsetAround', () {
    test('identity at theta=0', () {
      const p = Offset(10, 5);
      final r = RotatedLayout.rotateOffsetAround(p, const Offset(2, 2), 0.0);
      expect(r.dx, closeTo(10, 1e-9));
      expect(r.dy, closeTo(5, 1e-9));
    });

    test('rotates pi/2 around origin maps (1,0) -> (0,1)', () {
      final r = RotatedLayout.rotateOffsetAround(
          const Offset(1, 0), Offset.zero, math.pi / 2);
      expect(r.dx, closeTo(0, 1e-9));
      expect(r.dy, closeTo(1, 1e-9));
    });

    test('round-trip with negated angle', () {
      const p = Offset(42, -3);
      const pivot = Offset(5, 7);
      final there = RotatedLayout.rotateOffsetAround(p, pivot, 0.6435);
      final back = RotatedLayout.rotateOffsetAround(there, pivot, -0.6435);
      expect(back.dx, closeTo(42, 1e-9));
      expect(back.dy, closeTo(-3, 1e-9));
    });
  });

  group('RotatedLayout.handleCornerInParent', () {
    final r = const Rect.fromLTWH(100, 200, 50, 40);

    test('topLeft', () {
      expect(RotatedLayout.handleCornerInParent(r, HandlePosition.topLeft),
          const Offset(100, 200));
    });
    test('bottomRight', () {
      expect(RotatedLayout.handleCornerInParent(r, HandlePosition.bottomRight),
          const Offset(150, 240));
    });
    test('top centre', () {
      expect(RotatedLayout.handleCornerInParent(r, HandlePosition.top),
          const Offset(125, 200));
    });
    test('right centre', () {
      expect(RotatedLayout.handleCornerInParent(r, HandlePosition.right),
          const Offset(150, 220));
    });
  });

  group('RotatedLayout.rotatedCornerInWorld', () {
    final r = const Rect.fromLTWH(0, 0, 100, 100);

    test('theta=0 equals unrotated corner', () {
      expect(RotatedLayout.rotatedCornerInWorld(r, HandlePosition.topLeft, 0.0),
          const Offset(0, 0));
    });
    test('pi/2 around center (50,50) maps topLeft -> topRight visual', () {
      // Rotate (0,0) by pi/2 around (50,50):
      //   dx=-50, dy=-50 -> cos=0, sin=1 -> (50 + 0 - (-50), 50 + (-50) + 0) = (100, 0)
      final c = RotatedLayout.rotatedCornerInWorld(
          r, HandlePosition.topLeft, math.pi / 2);
      expect(c.dx, closeTo(100, 1e-9));
      expect(c.dy, closeTo(0, 1e-9));
    });
  });

  group('RotatedLayout.anchorInHandle', () {
    const size = 64.0;

    test('center alignment always returns centre', () {
      for (final h in const [
        HandlePosition.topLeft,
        HandlePosition.topRight,
        HandlePosition.bottomLeft,
        HandlePosition.bottomRight,
      ]) {
        expect(RotatedLayout.anchorInHandle(h, size, HandleAlignment.center),
            const Offset(32, 32),
            reason: 'center alignment, handle=$h');
      }
    });

    test('inside alignment puts anchor at handle corner nearest box corner',
        () {
      expect(
          RotatedLayout.anchorInHandle(
              HandlePosition.topLeft, size, HandleAlignment.inside),
          const Offset(0, 0));
      expect(
          RotatedLayout.anchorInHandle(
              HandlePosition.topRight, size, HandleAlignment.inside),
          const Offset(64, 0));
      expect(
          RotatedLayout.anchorInHandle(
              HandlePosition.bottomLeft, size, HandleAlignment.inside),
          const Offset(0, 64));
      expect(
          RotatedLayout.anchorInHandle(
              HandlePosition.bottomRight, size, HandleAlignment.inside),
          const Offset(64, 64));
    });

    test('outside alignment is the mirror of inside', () {
      expect(
          RotatedLayout.anchorInHandle(
              HandlePosition.topLeft, size, HandleAlignment.outside),
          const Offset(64, 64));
      expect(
          RotatedLayout.anchorInHandle(
              HandlePosition.bottomRight, size, HandleAlignment.outside),
          const Offset(0, 0));
    });
  });

  group('RotatedLayout.handleTopLeftInWorld', () {
    const size = 64.0;
    final r = const Rect.fromLTWH(100, 100, 200, 200);

    test('rotation=0, center alignment, topLeft', () {
      // Corner in world: (100, 100). Anchor inside handle = (32, 32).
      // handleTopLeftWorld = (100, 100) - (32, 32) = (68, 68).
      final p = RotatedLayout.handleTopLeftInWorld(
        rect: r,
        handle: HandlePosition.topLeft,
        rotation: 0,
        handleSize: size,
        alignment: HandleAlignment.center,
      );
      expect(p.dx, closeTo(68, 1e-9));
      expect(p.dy, closeTo(68, 1e-9));
    });

    test('rotation=pi/2, topLeft corner visually moves to top-right', () {
      // Unrotated topLeft (100, 100). Center (200, 200).
      // Rotated by pi/2: (100,100) -> (300, 100).
      // Anchor inside handle still (32, 32). handleTopLeftWorld = (268, 68).
      final p = RotatedLayout.handleTopLeftInWorld(
        rect: r,
        handle: HandlePosition.topLeft,
        rotation: math.pi / 2,
        handleSize: size,
        alignment: HandleAlignment.center,
      );
      expect(p.dx, closeTo(268, 1e-9));
      expect(p.dy, closeTo(68, 1e-9));
    });
  });

  group('RotatedLayout.sideHandleRectInWorld', () {
    final r = const Rect.fromLTWH(100, 200, 80, 60);
    const tap = 24.0;

    test('top handle (center): horizontal strip inset from corners', () {
      final rect = RotatedLayout.sideHandleRectInWorld(
        r,
        HandlePosition.top,
        handleTapSize: tap,
        alignment: HandleAlignment.center,
      );
      // Top handle centred on rect.top, inset 12 from each corner-handle edge.
      expect(rect.left, closeTo(100 + tap / 2, 1e-9));
      expect(rect.right, closeTo(180 - tap / 2, 1e-9));
      expect(rect.top, closeTo(200 - tap / 2, 1e-9));
      expect(rect.bottom, closeTo(200 + tap / 2, 1e-9));
    });

    test('left handle (inside): vertical strip inside box', () {
      final rect = RotatedLayout.sideHandleRectInWorld(
        r,
        HandlePosition.left,
        handleTapSize: tap,
        alignment: HandleAlignment.inside,
      );
      expect(rect.left, closeTo(100, 1e-9));
      expect(rect.width, closeTo(tap, 1e-9));
      expect(rect.top, closeTo(200 + tap, 1e-9));
      expect(rect.bottom, closeTo(260 - tap, 1e-9));
    });

    test('right handle (outside): vertical strip outside right edge', () {
      final rect = RotatedLayout.sideHandleRectInWorld(
        r,
        HandlePosition.right,
        handleTapSize: tap,
        alignment: HandleAlignment.outside,
      );
      expect(rect.left, closeTo(180, 1e-9));
      expect(rect.width, closeTo(tap, 1e-9));
    });
  });
}
