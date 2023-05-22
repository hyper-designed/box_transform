import 'package:box_transform/box_transform.dart';
import 'package:test/test.dart';
import 'package:vector_math/vector_math.dart';

void main() {
  group('flipBox tests', () {
    test('flipBox test with bottom-right handle', () {
      final box = Box.fromLTWH(500, 500, 400, 300);

      Box flipped = flipBox(box, Flip.none, HandlePosition.bottomRight);
      expect(box, flipped);

      flipped = flipBox(box, Flip.horizontal, HandlePosition.bottomRight);
      expect(flipped.topLeft, Vector2(100, 500));

      flipped = flipBox(box, Flip.vertical, HandlePosition.bottomRight);
      expect(flipped.topLeft, Vector2(500, 200));

      flipped = flipBox(box, Flip.diagonal, HandlePosition.bottomRight);
      expect(flipped.topLeft, Vector2(100, 200));
    });

    test('flipBox test with top-right handle', () {
      final box = Box.fromLTWH(500, 500, 400, 300);

      Box flipped = flipBox(box, Flip.none, HandlePosition.topRight);
      expect(box, flipped);

      flipped = flipBox(box, Flip.horizontal, HandlePosition.topRight);
      expect(flipped.topLeft, Vector2(100, 500));

      flipped = flipBox(box, Flip.vertical, HandlePosition.topRight);
      expect(flipped.topLeft, Vector2(500, 800));

      flipped = flipBox(box, Flip.diagonal, HandlePosition.topRight);
      expect(flipped.topLeft, Vector2(100, 800));
    });

    test('flipBox test with top-left handle', () {
      final box = Box.fromLTWH(500, 500, 400, 300);

      Box flipped = flipBox(box, Flip.none, HandlePosition.topLeft);
      expect(box, flipped);

      flipped = flipBox(box, Flip.horizontal, HandlePosition.topLeft);
      expect(flipped.topLeft, Vector2(900, 500));

      flipped = flipBox(box, Flip.vertical, HandlePosition.topLeft);
      expect(flipped.topLeft, Vector2(500, 800));

      flipped = flipBox(box, Flip.diagonal, HandlePosition.topLeft);
      expect(flipped.topLeft, Vector2(900, 800));
    });

    test('flipBox test with bottom-left handle', () {
      final box = Box.fromLTWH(500, 500, 400, 300);

      Box flipped = flipBox(box, Flip.none, HandlePosition.bottomLeft);
      expect(box, flipped);

      flipped = flipBox(box, Flip.horizontal, HandlePosition.bottomLeft);
      expect(flipped.topLeft, Vector2(900, 500));

      flipped = flipBox(box, Flip.vertical, HandlePosition.bottomLeft);
      expect(flipped.topLeft, Vector2(500, 200));

      flipped = flipBox(box, Flip.diagonal, HandlePosition.bottomLeft);
      expect(flipped.topLeft, Vector2(900, 200));
    });
  });

  group('getFlipForBox tests', () {
    test('getFlipForBox test for bottom-right handle', () {
      final box = Box.fromLTWH(500, 500, 400, 300);

      Flip flip = getFlipForBox(
        box,
        Vector2(-500, -400),
        HandlePosition.bottomRight,
        ResizeMode.freeform,
      );
      expect(flip, Flip.diagonal);

      flip = getFlipForBox(
        box,
        Vector2(-500, 10),
        HandlePosition.bottomRight,
        ResizeMode.freeform,
      );
      expect(flip, Flip.horizontal);

      flip = getFlipForBox(
        box,
        Vector2(10, -400),
        HandlePosition.bottomRight,
        ResizeMode.freeform,
      );
      expect(flip, Flip.vertical);

      flip = getFlipForBox(
        box,
        Vector2(10, 10),
        HandlePosition.bottomRight,
        ResizeMode.freeform,
      );
      expect(flip, Flip.none);

      flip = getFlipForBox(
        box,
        Vector2(500, 500),
        HandlePosition.topLeft,
        ResizeMode.freeform,
      );
      expect(flip, Flip.diagonal);

      flip = getFlipForBox(
        box,
        Vector2(500, -10),
        HandlePosition.topLeft,
        ResizeMode.freeform,
      );
      expect(flip, Flip.horizontal);

      flip = getFlipForBox(
        box,
        Vector2(-10, 500),
        HandlePosition.topLeft,
        ResizeMode.freeform,
      );
      expect(flip, Flip.vertical);

      flip = getFlipForBox(
        box,
        Vector2(-10, -10),
        HandlePosition.topLeft,
        ResizeMode.freeform,
      );
      expect(flip, Flip.none);

      flip = getFlipForBox(
        box,
        Vector2(10, -10),
        HandlePosition.topRight,
        ResizeMode.freeform,
      );
      expect(flip, Flip.none);

      flip = getFlipForBox(
        box,
        Vector2(10, 500),
        HandlePosition.topRight,
        ResizeMode.freeform,
      );
      expect(flip, Flip.vertical);

      flip = getFlipForBox(
        box,
        Vector2(-500, 500),
        HandlePosition.topRight,
        ResizeMode.freeform,
      );
      expect(flip, Flip.diagonal);

      flip = getFlipForBox(
        box,
        Vector2(-500, -10),
        HandlePosition.topRight,
        ResizeMode.freeform,
      );
      expect(flip, Flip.horizontal);

      flip = getFlipForBox(
        box,
        Vector2(500, 10),
        HandlePosition.bottomLeft,
        ResizeMode.freeform,
      );
      expect(flip, Flip.horizontal);

      flip = getFlipForBox(
        box,
        Vector2(-10, 10),
        HandlePosition.bottomLeft,
        ResizeMode.freeform,
      );
      expect(flip, Flip.none);

      flip = getFlipForBox(
        box,
        Vector2(-10, -500),
        HandlePosition.bottomLeft,
        ResizeMode.freeform,
      );
      expect(flip, Flip.vertical);

      flip = getFlipForBox(
        box,
        Vector2(500, -500),
        HandlePosition.bottomLeft,
        ResizeMode.freeform,
      );
      expect(flip, Flip.diagonal);
    });

    test('getFlipForBox test for top-left handle', () {
      final box = Box.fromLTWH(0, 0, 400, 300);

      Flip flip = getFlipForBox(
        box,
        Vector2(500, 500),
        HandlePosition.topLeft,
        ResizeMode.freeform,
      );
      expect(flip, Flip.diagonal);

      flip = getFlipForBox(
        box,
        Vector2(500, -10),
        HandlePosition.topLeft,
        ResizeMode.freeform,
      );
      expect(flip, Flip.horizontal);

      flip = getFlipForBox(
        box,
        Vector2(-10, 500),
        HandlePosition.topLeft,
        ResizeMode.freeform,
      );
      expect(flip, Flip.vertical);

      flip = getFlipForBox(
        box,
        Vector2(-10, -10),
        HandlePosition.topLeft,
        ResizeMode.freeform,
      );
      expect(flip, Flip.none);

      flip = getFlipForBox(
        box,
        Vector2(-10, -10),
        HandlePosition.topLeft,
        ResizeMode.scale,
      );
      expect(flip, Flip.none);

      flip = getFlipForBox(
        box,
        Vector2(500, 500),
        HandlePosition.topLeft,
        ResizeMode.scale,
      );
      expect(flip, Flip.diagonal);

      flip = getFlipForBox(
        box,
        Vector2(500, -10),
        HandlePosition.topLeft,
        ResizeMode.scale,
      );
      expect(flip, Flip.horizontal);

      flip = getFlipForBox(
        box,
        Vector2(-10, 500),
        HandlePosition.topLeft,
        ResizeMode.scale,
      );
      expect(flip, Flip.vertical);

      flip = getFlipForBox(
        box,
        Vector2(-10, -10),
        HandlePosition.topLeft,
        ResizeMode.symmetric,
      );
      expect(flip, Flip.none);

      flip = getFlipForBox(
        box,
        Vector2(300, 200),
        HandlePosition.topLeft,
        ResizeMode.symmetric,
      );
      expect(flip, Flip.diagonal);

      flip = getFlipForBox(
        box,
        Vector2(800, -10),
        HandlePosition.topLeft,
        ResizeMode.symmetric,
      );
      expect(flip, Flip.horizontal);

      flip = getFlipForBox(
        box,
        Vector2(-10, 500),
        HandlePosition.topLeft,
        ResizeMode.symmetric,
      );
      expect(flip, Flip.vertical);

      flip = getFlipForBox(
        box,
        Vector2(-10, -10),
        HandlePosition.topLeft,
        ResizeMode.symmetricScale,
      );
      expect(flip, Flip.none);

      flip = getFlipForBox(
        box,
        Vector2(800, 500),
        HandlePosition.topLeft,
        ResizeMode.symmetricScale,
      );
      expect(flip, Flip.diagonal);

      flip = getFlipForBox(
        box,
        Vector2(300, 0),
        HandlePosition.topLeft,
        ResizeMode.symmetricScale,
      );
      expect(flip, Flip.horizontal);

      flip = getFlipForBox(
        box,
        Vector2(0, 200),
        HandlePosition.topLeft,
        ResizeMode.symmetricScale,
      );
      expect(flip, Flip.vertical);
    });

    test('getFlipForBox test for top-right handle', () {
      final box = Box.fromLTWH(0, 0, 400, 300);

      Flip flip = getFlipForBox(
        box,
        Vector2(500, 500),
        HandlePosition.topRight,
        ResizeMode.freeform,
      );
      expect(flip, Flip.vertical);

      flip = getFlipForBox(
        box,
        Vector2(-500, 500),
        HandlePosition.topRight,
        ResizeMode.freeform,
      );
      expect(flip, Flip.diagonal);

      flip = getFlipForBox(
        box,
        Vector2(-500, 0),
        HandlePosition.topRight,
        ResizeMode.freeform,
      );
      expect(flip, Flip.horizontal);

      flip = getFlipForBox(
        box,
        Vector2(-10, -10),
        HandlePosition.topRight,
        ResizeMode.freeform,
      );
      expect(flip, Flip.none);

      flip = getFlipForBox(
        box,
        Vector2(-10, -10),
        HandlePosition.topRight,
        ResizeMode.scale,
      );
      expect(flip, Flip.none);

      flip = getFlipForBox(
        box,
        Vector2(500, 500),
        HandlePosition.topRight,
        ResizeMode.scale,
      );
      expect(flip, Flip.vertical);

      flip = getFlipForBox(
        box,
        Vector2(-500, 500),
        HandlePosition.topRight,
        ResizeMode.scale,
      );
      expect(flip, Flip.diagonal);

      flip = getFlipForBox(
        box,
        Vector2(-500, 0),
        HandlePosition.topRight,
        ResizeMode.scale,
      );
      expect(flip, Flip.horizontal);

      flip = getFlipForBox(
        box,
        Vector2(-10, -10),
        HandlePosition.topRight,
        ResizeMode.symmetric,
      );
      expect(flip, Flip.none);

      flip = getFlipForBox(
        box,
        Vector2(100, 200),
        HandlePosition.topRight,
        ResizeMode.symmetric,
      );
      expect(flip, Flip.vertical);

      flip = getFlipForBox(
        box,
        Vector2(-300, 200),
        HandlePosition.topRight,
        ResizeMode.symmetric,
      );
      expect(flip, Flip.diagonal);

      flip = getFlipForBox(
        box,
        Vector2(-500, 0),
        HandlePosition.topRight,
        ResizeMode.symmetric,
      );
      expect(flip, Flip.horizontal);

      flip = getFlipForBox(
        box,
        Vector2(-10, -10),
        HandlePosition.topRight,
        ResizeMode.symmetricScale,
      );
      expect(flip, Flip.none);

      flip = getFlipForBox(
        box,
        Vector2(500, 500),
        HandlePosition.topRight,
        ResizeMode.symmetricScale,
      );
      expect(flip, Flip.vertical);

      flip = getFlipForBox(
        box,
        Vector2(-500, 0),
        HandlePosition.topRight,
        ResizeMode.symmetricScale,
      );
      expect(flip, Flip.horizontal);

      flip = getFlipForBox(
        box,
        Vector2(-20, 20),
        HandlePosition.topRight,
        ResizeMode.symmetricScale,
      );
      expect(flip, Flip.none);
    });

    test('getFlipForBox test for bottom-left handle', () {
      final box = Box.fromLTWH(0, 0, 400, 300);

      Flip flip = getFlipForBox(
        box,
        Vector2(500, -400),
        HandlePosition.bottomLeft,
        ResizeMode.freeform,
      );
      expect(flip, Flip.diagonal);

      flip = getFlipForBox(
        box,
        Vector2(500, 500),
        HandlePosition.bottomLeft,
        ResizeMode.freeform,
      );
      expect(flip, Flip.horizontal);

      flip = getFlipForBox(
        box,
        Vector2(0, -400),
        HandlePosition.bottomLeft,
        ResizeMode.freeform,
      );
      expect(flip, Flip.vertical);

      flip = getFlipForBox(
        box,
        Vector2(20, -20),
        HandlePosition.bottomLeft,
        ResizeMode.freeform,
      );
      expect(flip, Flip.none);

      flip = getFlipForBox(
        box,
        Vector2(20, -20),
        HandlePosition.bottomLeft,
        ResizeMode.scale,
      );
      expect(flip, Flip.none);

      flip = getFlipForBox(
        box,
        Vector2(500, -400),
        HandlePosition.bottomLeft,
        ResizeMode.scale,
      );
      expect(flip, Flip.diagonal);

      flip = getFlipForBox(
        box,
        Vector2(500, 500),
        HandlePosition.bottomLeft,
        ResizeMode.scale,
      );
      expect(flip, Flip.horizontal);

      flip = getFlipForBox(
        box,
        Vector2(0, -400),
        HandlePosition.bottomLeft,
        ResizeMode.scale,
      );
      expect(flip, Flip.vertical);

      flip = getFlipForBox(
        box,
        Vector2(20, -20),
        HandlePosition.bottomLeft,
        ResizeMode.symmetric,
      );
      expect(flip, Flip.none);

      flip = getFlipForBox(
        box,
        Vector2(300, -200),
        HandlePosition.bottomLeft,
        ResizeMode.symmetric,
      );
      expect(flip, Flip.diagonal);

      flip = getFlipForBox(
        box,
        Vector2(800, 500),
        HandlePosition.bottomLeft,
        ResizeMode.symmetric,
      );
      expect(flip, Flip.horizontal);

      flip = getFlipForBox(
        box,
        Vector2(0, -200),
        HandlePosition.bottomLeft,
        ResizeMode.symmetric,
      );
      expect(flip, Flip.vertical);

      flip = getFlipForBox(
        box,
        Vector2(20, -20),
        HandlePosition.bottomLeft,
        ResizeMode.symmetricScale,
      );
      expect(flip, Flip.none);

      flip = getFlipForBox(
        box,
        Vector2(300, -200),
        HandlePosition.bottomLeft,
        ResizeMode.symmetricScale,
      );
      expect(flip, Flip.diagonal);

      flip = getFlipForBox(
        box,
        Vector2(800, 500),
        HandlePosition.bottomLeft,
        ResizeMode.symmetricScale,
      );
      expect(flip, Flip.horizontal);

      flip = getFlipForBox(
        box,
        Vector2(0, -200),
        HandlePosition.bottomLeft,
        ResizeMode.symmetricScale,
      );
      expect(flip, Flip.vertical);
    });
  });

  test('getAvailableAreaForHandle tests', () {
    final Box clampingRect = Box.fromLTRB(100, 100, 1000, 1000);
    final Box rect = Box.fromLTRB(400, 600, 400, 300);

    expect(
      getAvailableAreaForHandle(
          rect: rect,
          clampingRect: clampingRect,
          handle: HandlePosition.bottomRight),
      Box.fromPoints(rect.topLeft, clampingRect.bottomRight),
    );

    expect(
      getAvailableAreaForHandle(
          rect: rect,
          clampingRect: clampingRect,
          handle: HandlePosition.topLeft),
      Box.fromPoints(clampingRect.topLeft, rect.bottomRight),
    );

    expect(
      getAvailableAreaForHandle(
          rect: rect,
          clampingRect: clampingRect,
          handle: HandlePosition.bottomLeft),
      Box.fromLTRB(
          clampingRect.left, rect.top, rect.right, clampingRect.bottom),
    );

    expect(
      getAvailableAreaForHandle(
          rect: rect,
          clampingRect: clampingRect,
          handle: HandlePosition.topRight),
      Box.fromLTRB(
          rect.left, clampingRect.top, clampingRect.right, rect.bottom),
    );

    expect(
      getAvailableAreaForHandle(
          rect: rect,
          clampingRect: clampingRect,
          handle: HandlePosition.bottom),
      Box.fromLTRB(
          clampingRect.left, rect.top, clampingRect.right, clampingRect.bottom),
    );

    expect(
      getAvailableAreaForHandle(
          rect: rect, clampingRect: clampingRect, handle: HandlePosition.right),
      Box.fromLTRB(
          rect.left, clampingRect.top, clampingRect.right, clampingRect.bottom),
    );

    expect(
      getAvailableAreaForHandle(
          rect: rect, clampingRect: clampingRect, handle: HandlePosition.left),
      Box.fromLTRB(
          clampingRect.left, clampingRect.top, rect.right, clampingRect.bottom),
    );
  });

  test('getClosestEdge tests', () {
    Box rect = Box.fromLTWH(200, 300, 400, 300);
    Box clampingRect = Box.fromLTWH(100, 100, 1000, 1000);

    expect(getClosestEdge(rect, clampingRect), HandlePosition.left);

    rect = Box.fromLTWH(200, 150, 400, 300);
    expect(getClosestEdge(rect, clampingRect), HandlePosition.top);

    rect = Box.fromLTWH(200, 900, 400, 300);
    expect(getClosestEdge(rect, clampingRect), HandlePosition.bottom);

    rect = Box.fromLTWH(900, 300, 400, 300);
    expect(getClosestEdge(rect, clampingRect), HandlePosition.right);

    rect = Box.fromLTWH(900, 900, 400, 300);
    expect(getClosestEdge(rect, clampingRect), HandlePosition.right);

    rect = Box.fromLTWH(900, 150, 400, 300);
    expect(getClosestEdge(rect, clampingRect), HandlePosition.right);
  });
}
