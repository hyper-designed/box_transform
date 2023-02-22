import 'package:rect_resizer/rect_resizer.dart';
import 'package:test/test.dart';
import 'package:vector_math/vector_math.dart';

void main() {
  group('Freeform resize', () {
    test('Bottom left box resize ', () {
      final Box box = Box.fromLTWH(0, 0, 100, 100);

      expect(box.left, 0);
      expect(box.top, 0);
      expect(box.right, 100);
      expect(box.bottom, 100);

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
      expect(result1.oldBox.left, 0);
      expect(result1.oldBox.top, 0);
      expect(result1.oldBox.right, 100);
      expect(result1.oldBox.bottom, 100);

      // New Box is the same as the [box].
      expect(result1.newBox.left, 0);
      expect(result1.newBox.top, 0);
      expect(result1.newBox.right, 100);
      expect(result1.newBox.bottom, 100);

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

      // Delta is 10px on the x axis.
      expect(result2.delta.x, 10);
      expect(result2.delta.y, 20);

      // Old Box is the same as the [box].
      expect(result2.oldBox.left, 0);
      expect(result2.oldBox.top, 0);
      expect(result2.oldBox.right, 100);
      expect(result2.oldBox.bottom, 100);

      // New Box is moved to the right by 10px.
      expect(result2.newBox.left, 0);
      expect(result2.newBox.top, 0);
      expect(result2.newBox.right, 110);
      expect(result2.newBox.bottom, 120);
    });
  });
}
