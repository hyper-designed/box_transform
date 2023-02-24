import 'package:rect_resizer/rect_resizer.dart';
import 'package:test/test.dart';
import 'package:vector_math/vector_math.dart';

void main() {
  // THESE ARE ALL ONLY TESTING GROWING THE BOX, NOT SHRINKING IT.
  group('Freeform resize', () {
    test('unclamped resize', () {
      final Box box = Box.fromLTWH(50, 50, 100, 100);

      expect(box.left, 50);
      expect(box.top, 50);
      expect(box.right, 150);
      expect(box.bottom, 150);

      // Resize the box with no position movement. Nothing should change.
      final ResizeResult result1 = RectResizer.resize(
        handle: HandlePosition.bottomRight,
        initialBox: box,
        initialLocalPosition: Vector2.zero(),
        localPosition: Vector2.zero(),
        resizeMode: ResizeMode.freeform,
        initialFlip: Flip.none,
      );

      // Delta is zero.
      expect(result1.delta.x, 0);
      expect(result1.delta.y, 0);

      // Old Box is the same as the [box].
      expect(result1.oldBox, box);

      // New Box is the same as the [box].
      expect(result1.newBox, result1.oldBox);

      // Resize the box from the bottom right handle. The box should grow by
      // 10x20px.
      final ResizeResult result2 = RectResizer.resize(
        handle: HandlePosition.bottomRight,
        initialBox: box,
        initialLocalPosition: Vector2.zero(),
        localPosition: Vector2(10, 20),
        resizeMode: ResizeMode.freeform,
        initialFlip: Flip.none,
      );

      // Delta is 10x20px.
      expect(result2.delta.x, 10);
      expect(result2.delta.y, 20);

      // Old Box is the same as the [box].
      expect(result2.oldBox, box);

      // New Box is enlarged to the right by 10px and to the bottom by 20px.
      expect(result2.newBox.left, 50);
      expect(result2.newBox.top, 50);
      expect(result2.newBox.right, 160);
      expect(result2.newBox.bottom, 170);
    });

    test('clamped resize', () {
      final Box box = Box.fromLTWH(50, 50, 100, 100);
      final Box clampingBox = Box.fromLTWH(0, 0, 200, 200);

      expect(box.left, 50);
      expect(box.top, 50);
      expect(box.right, 150);
      expect(box.bottom, 150);

      expect(clampingBox.left, 0);
      expect(clampingBox.top, 0);
      expect(clampingBox.right, 200);
      expect(clampingBox.bottom, 200);

      // Resize the box from the bottom right handle. The box should grow by
      // 10x20px.
      final ResizeResult result2 = RectResizer.resize(
        handle: HandlePosition.bottomRight,
        initialBox: box,
        initialLocalPosition: Vector2.zero(),
        localPosition: Vector2(10, 20),
        resizeMode: ResizeMode.freeform,
        initialFlip: Flip.none,
        clampingBox: clampingBox,
      );

      // Delta is 10x20px.
      expect(result2.delta.x, 10);
      expect(result2.delta.y, 20);

      // Old Box is the same as the [box].
      expect(result2.oldBox, box);

      // New Box is moved to the right by 10px.
      expect(result2.newBox.left, 50);
      expect(result2.newBox.top, 50);
      expect(result2.newBox.right, 160);
      expect(result2.newBox.bottom, 170);

      // Resize the box from the bottom right handle to an extreme position.
      final ResizeResult result3 = RectResizer.resize(
        handle: HandlePosition.bottomRight,
        initialBox: box,
        initialLocalPosition: Vector2.zero(),
        localPosition: Vector2(75, 100),
        resizeMode: ResizeMode.freeform,
        initialFlip: Flip.none,
        clampingBox: clampingBox,
      );

      // Delta is 75x100px.
      expect(result3.delta.x, 75);
      expect(result3.delta.y, 100);

      // Old Box is the same as the [box].
      expect(result3.oldBox, box);

      // New Box is enlarged to the right by 75px and to the bottom by 100px.
      // The box resizing stops at 200, 200, but resizing continues due to
      // growth-overflow.
      expect(result3.newBox.left, 25);
      expect(result3.newBox.top, 0);
      expect(result3.newBox.right, 200);
      expect(result3.newBox.bottom, 200);
    });

    test('constrained resize', () {
      final Box box = Box.fromLTWH(50, 50, 100, 100);
      final Constraints constraints = Constraints(
        minWidth: 20,
        minHeight: 50,
        maxWidth: 150,
        maxHeight: 190,
      );
      expect(box.left, 50);
      expect(box.top, 50);
      expect(box.right, 150);
      expect(box.bottom, 150);

      expect(constraints.minWidth, 20);
      expect(constraints.minHeight, 50);
      expect(constraints.maxWidth, 150);
      expect(constraints.maxHeight, 190);

      // Resize the box from the bottom right handle. The box should grow by
      // 10x20px.
      final ResizeResult result2 = RectResizer.resize(
        handle: HandlePosition.bottomRight,
        initialBox: box,
        initialLocalPosition: Vector2.zero(),
        localPosition: Vector2(10, 20),
        resizeMode: ResizeMode.freeform,
        initialFlip: Flip.none,
        constraints: constraints,
      );

      // Delta is 10x20px.
      expect(result2.delta.x, 10);
      expect(result2.delta.y, 20);

      // Old Box is the same as the [box].
      expect(result2.oldBox, box);

      // New Box is moved to the right by 10px.
      expect(result2.newBox.left, 50);
      expect(result2.newBox.top, 50);
      expect(result2.newBox.right, 160);
      expect(result2.newBox.bottom, 170);

      // Resize the box from the bottom right handle to an extreme position.
      final ResizeResult result3 = RectResizer.resize(
        handle: HandlePosition.bottomRight,
        initialBox: box,
        initialLocalPosition: Vector2.zero(),
        localPosition: Vector2(75, 100),
        resizeMode: ResizeMode.freeform,
        initialFlip: Flip.none,
        constraints: constraints,
      );

      // Delta is 75x100px.
      expect(result3.delta.x, 75);
      expect(result3.delta.y, 100);

      // Old Box is the same as the [box].
      expect(result3.oldBox, box);

      // New Box's size is constrained to 150x190px. Overflow happens to a
      // limit.
      expect(result3.newBox.left, 50);
      expect(result3.newBox.top, 50);
      expect(result3.newBox.right, 200);
      expect(result3.newBox.bottom, 240);
    });

    test('constrained resize with clamping', () {
      final Box box = Box.fromLTWH(50, 50, 100, 100);
      final Constraints constraints = Constraints(
        minWidth: 20,
        minHeight: 50,
        maxWidth: 150,
        maxHeight: 190,
      );
      final Box clampingBox = Box.fromLTWH(0, 0, 200, 200);

      expect(box.left, 50);
      expect(box.top, 50);
      expect(box.right, 150);
      expect(box.bottom, 150);

      expect(constraints.minWidth, 20);
      expect(constraints.minHeight, 50);
      expect(constraints.maxWidth, 150);
      expect(constraints.maxHeight, 190);

      expect(clampingBox.left, 0);
      expect(clampingBox.top, 0);
      expect(clampingBox.right, 200);
      expect(clampingBox.bottom, 200);

      // Resize the box from the bottom right handle to an extreme position.
      final ResizeResult result = RectResizer.resize(
        handle: HandlePosition.bottomRight,
        initialBox: box,
        initialLocalPosition: Vector2.zero(),
        localPosition: Vector2(75, 100),
        resizeMode: ResizeMode.freeform,
        initialFlip: Flip.none,
        clampingBox: clampingBox,
        constraints: constraints,
      );

      // Delta is 75x100px.
      expect(result.delta.x, 75);
      expect(result.delta.y, 100);

      // Old Box is the same as the [box].
      expect(result.oldBox, box);

      // New Box is resized according to the constraints.
      // The box resizing stops at 150, 190 due to constraints and clamping.
      expect(result.newBox.left, 50);
      expect(result.newBox.top, 10);
      expect(result.newBox.right, 200);
      expect(result.newBox.bottom, 200);
    });
  });

  group('Symmetric resize', () {});

  group('scale resize', () {});
}
