import 'package:box_transform/box_transform.dart';
import 'package:test/test.dart';
import 'package:vector_math/vector_math_64.dart';

void main() {
  test('RawTransformResult equality tests', () {
    final result1 = RawTransformResult(
      rect: Box.fromLTRB(100, 100, 500, 400),
      handle: HandlePosition.bottomRight,
      flip: Flip.none,
      maxHeightReached: false,
      maxWidthReached: false,
      minHeightReached: false,
      minWidthReached: false,
      oldRect: Box.fromLTRB(100, 100, 300, 200),
      resizeMode: ResizeMode.freeform,
      largestRect: Box.fromLTRB(100, 100, 1000, 1000),
      rawSize: Dimension(400, 300),
      delta: Vector2(200, 200),
    );

    final result2 = RawTransformResult(
      rect: Box.fromLTRB(100, 100, 500, 400),
      handle: HandlePosition.bottomRight,
      flip: Flip.none,
      maxHeightReached: false,
      maxWidthReached: false,
      minHeightReached: false,
      minWidthReached: false,
      oldRect: Box.fromLTRB(100, 100, 300, 200),
      resizeMode: ResizeMode.freeform,
      largestRect: Box.fromLTRB(100, 100, 1000, 1000),
      rawSize: Dimension(400, 300),
      delta: Vector2(200, 200),
    );

    expect(result1, result2);
    expect(result1.toString(), result2.toString());
    expect(result1.hashCode, result2.hashCode);
    expect(result1 == result2, isTrue);
  });

  test('RawResizeResult equality tests', () {
    final result1 = RawResizeResult(
      rect: Box.fromLTRB(100, 100, 500, 400),
      handle: HandlePosition.bottomRight,
      flip: Flip.none,
      maxHeightReached: false,
      maxWidthReached: false,
      minHeightReached: false,
      minWidthReached: false,
      oldRect: Box.fromLTRB(100, 100, 300, 200),
      resizeMode: ResizeMode.freeform,
      largestRect: Box.fromLTRB(100, 100, 1000, 1000),
      rawSize: Dimension(400, 300),
      delta: Vector2(200, 200),
    );

    final result2 = RawResizeResult(
      rect: Box.fromLTRB(100, 100, 500, 400),
      handle: HandlePosition.bottomRight,
      flip: Flip.none,
      maxHeightReached: false,
      maxWidthReached: false,
      minHeightReached: false,
      minWidthReached: false,
      oldRect: Box.fromLTRB(100, 100, 300, 200),
      resizeMode: ResizeMode.freeform,
      largestRect: Box.fromLTRB(100, 100, 1000, 1000),
      rawSize: Dimension(400, 300),
      delta: Vector2(200, 200),
    );

    expect(result1, result2);
    expect(result1.toString(), result2.toString());
    expect(result1.hashCode, result2.hashCode);
    expect(result1 == result2, isTrue);
  });

  test('RawMoveResult equality tests', () {
    final result1 = RawMoveResult(
      rect: Box.fromLTRB(100, 100, 500, 400),
      oldRect: Box.fromLTRB(100, 100, 300, 200),
      largestRect: Box.fromLTRB(100, 100, 1000, 1000),
      rawSize: Dimension(400, 300),
      delta: Vector2(200, 200),
    );

    final result2 = RawMoveResult(
      rect: Box.fromLTRB(100, 100, 500, 400),
      oldRect: Box.fromLTRB(100, 100, 300, 200),
      largestRect: Box.fromLTRB(100, 100, 1000, 1000),
      rawSize: Dimension(400, 300),
      delta: Vector2(200, 200),
    );

    expect(result1, result2);
    expect(result1.toString(), result2.toString());
    expect(result1.hashCode, result2.hashCode);
    expect(result1 == result2, isTrue);
  });

  test('InternalResizeResult equality tests', () {
    final result1 = (
      Box.fromLTRB(100, 100, 500, 400),
      Box.fromLTRB(100, 100, 1000, 1000),
      true,
    );

    final result2 = (
      Box.fromLTRB(100, 100, 500, 400),
      Box.fromLTRB(100, 100, 1000, 1000),
      true,
    );

    expect(result1, result2);
    expect(result1.toString(), result2.toString());
    expect(result1.hashCode, result2.hashCode);
    expect(result1 == result2, isTrue);
  });

  group('TransformResult rotation/boundingRect fields', () {
    test('default rotation is 0.0 and boundingRect equals rect for theta=0',
        () {
      final r = Box.fromLTWH(0, 0, 100, 100);
      final result = ResizeResult<Box, Vector2, Dimension>(
        rect: r,
        oldRect: r,
        delta: Vector2.zero(),
        flip: Flip.none,
        resizeMode: ResizeMode.freeform,
        rawSize: Dimension(100, 100),
        minWidthReached: false,
        maxWidthReached: false,
        minHeightReached: false,
        maxHeightReached: false,
        largestRect: r,
        handle: HandlePosition.bottomRight,
      );
      expect(result.rotation, 0.0);
      expect(result.boundingRect, equals(r));
      expect(result.oldBoundingRect, equals(r));
    });

    test('boundingRect is exposed when explicitly provided', () {
      final r = Box.fromLTWH(0, 0, 100, 100, rotation: 0.5);
      final bounding = Box.fromLTWH(-10, -10, 120, 120);
      final result = ResizeResult<Box, Vector2, Dimension>(
        rect: r,
        oldRect: r,
        delta: Vector2.zero(),
        flip: Flip.none,
        resizeMode: ResizeMode.freeform,
        rawSize: Dimension(100, 100),
        minWidthReached: false,
        maxWidthReached: false,
        minHeightReached: false,
        maxHeightReached: false,
        largestRect: r,
        handle: HandlePosition.bottomRight,
        rotation: 0.5,
        boundingRect: bounding,
        oldBoundingRect: bounding,
      );
      expect(result.rotation, 0.5);
      expect(result.boundingRect, equals(bounding));
    });
  });
}
