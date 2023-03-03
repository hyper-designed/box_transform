import 'package:box_transform/box_transform.dart';
import 'package:test/test.dart';
import 'package:vector_math/vector_math.dart';

void main() {
  test('Drag a box', () {
    final Box box = Box.fromLTWH(0, 0, 100, 100);

    expect(box.left, 0);
    expect(box.top, 0);
    expect(box.right, 100);
    expect(box.bottom, 100);

    // Move the box to the same position. Nothing should change.
    final MoveResult result1 = BoxTransformer.move(
      initialBox: box,
      initialLocalPosition: Vector2.zero(),
      localPosition: Vector2.zero(),
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
    expect(result1.box.left, 0);
    expect(result1.box.top, 0);
    expect(result1.box.right, 100);
    expect(result1.box.bottom, 100);

    // Move the box to the right by 10px to the right with a centered cursor.
    final MoveResult result2 = BoxTransformer.move(
      initialBox: box,
      initialLocalPosition: Vector2(50, 50),
      localPosition: Vector2(60, 50),
    );

    // Delta is 10px on the x axis.
    expect(result2.delta.x, 10);
    expect(result2.delta.y, 0);

    // Old Box is the same as the [box].
    expect(result2.oldBox.left, 0);
    expect(result2.oldBox.top, 0);
    expect(result2.oldBox.right, 100);
    expect(result2.oldBox.bottom, 100);

    // New Box is moved to the right by 10px.
    expect(result2.box.left, 10);
    expect(result2.box.top, 0);
    expect(result2.box.right, 110);
    expect(result2.box.bottom, 100);
  });

  test("Drag a clamped box", () {
    final Box box = Box.fromLTWH(50, 50, 100, 100);
    final Box clampingBox = Box.fromLTWH(0, 0, 200, 200);

    expect(box.left, 50);
    expect(box.top, 50);
    expect(box.right, 150);
    expect(box.bottom, 150);

    // Move the box to the same position. Nothing should change.
    final MoveResult result1 = BoxTransformer.move(
      initialBox: box,
      initialLocalPosition: Vector2.zero(),
      localPosition: Vector2.zero(),
      clampingBox: clampingBox,
    );

    // Delta is zero.
    expect(result1.delta.x, 0);
    expect(result1.delta.y, 0);

    // Old Box is the same as the [box].
    expect(result1.oldBox.left, 50);
    expect(result1.oldBox.top, 50);
    expect(result1.oldBox.right, 150);
    expect(result1.oldBox.bottom, 150);

    // New Box is the same as the [box].
    expect(result1.box.left, 50);
    expect(result1.box.top, 50);
    expect(result1.box.right, 150);
    expect(result1.box.bottom, 150);

    // Move the box to the right by 10px to the right with a centered cursor.
    final MoveResult result2 = BoxTransformer.move(
      initialBox: box,
      initialLocalPosition: Vector2(75, 75),
      localPosition: Vector2(85, 75),
      clampingBox: clampingBox,
    );

    // Delta is 10px on the x axis.
    expect(result2.delta.x, 10);
    expect(result2.delta.y, 0);

    // Old Box is the same as the [box].
    expect(result2.oldBox.left, 50);
    expect(result2.oldBox.top, 50);
    expect(result2.oldBox.right, 150);
    expect(result2.oldBox.bottom, 150);

    // New Box is moved to the right by 10px.
    expect(result2.box.left, 60);
    expect(result2.box.top, 50);
    expect(result2.box.right, 160);
    expect(result2.box.bottom, 150);

    // Move the box to the right by 200px to the bottom right with a centered
    // cursor.
    final MoveResult result3 = BoxTransformer.move(
      initialBox: box,
      initialLocalPosition: Vector2(50, 50),
      localPosition: Vector2(200, 200),
      clampingBox: clampingBox,
    );

    // The delta itself is not clamped.
    expect(result3.delta.x, 200 - 50);
    expect(result3.delta.y, 200 - 50);

    // Old Box is the same as the [box].
    expect(result3.oldBox.left, 50);
    expect(result3.oldBox.top, 50);
    expect(result3.oldBox.right, 150);
    expect(result3.oldBox.bottom, 150);

    // New Box is moved to the bottom right by 100px so as to stay in the
    // clamping box.
    expect(result3.box.left, 100);
    expect(result3.box.top, 100);
    expect(result3.box.right, 200);
    expect(result3.box.bottom, 200);
  });
}
