import 'dart:math';

import 'package:box_transform/box_transform.dart';
import 'package:test/test.dart';
import 'package:vector_math/vector_math.dart';

void main() {
  group('HandlePosition tests', () {
    test('HandlePosition tests', () {
      expect(HandlePosition.none.isNone, isTrue);
      expect(HandlePosition.none.influencesLeft, isFalse);
      expect(HandlePosition.none.influencesTop, isFalse);
      expect(HandlePosition.none.influencesRight, isFalse);
      expect(HandlePosition.none.influencesBottom, isFalse);

      // Bottom right
      expect(HandlePosition.bottomRight.influencesLeft, isFalse);
      expect(HandlePosition.bottomRight.influencesTop, isFalse);
      expect(HandlePosition.bottomRight.influencesRight, isTrue);
      expect(HandlePosition.bottomRight.influencesBottom, isTrue);
      expect(HandlePosition.bottomRight.influencesBottomOrRight, isTrue);
      expect(HandlePosition.bottomRight.influencesBottomOrLeft, isFalse);
      expect(HandlePosition.bottomRight.influencesTopOrRight, isFalse);
      expect(HandlePosition.bottomRight.influencesTopOrLeft, isFalse);

      // Top left
      expect(HandlePosition.topLeft.influencesLeft, isTrue);
      expect(HandlePosition.topLeft.influencesTop, isTrue);
      expect(HandlePosition.topLeft.influencesRight, isFalse);
      expect(HandlePosition.topLeft.influencesBottom, isFalse);
      expect(HandlePosition.topLeft.influencesBottomOrRight, isFalse);
      expect(HandlePosition.topLeft.influencesBottomOrLeft, isFalse);
      expect(HandlePosition.topLeft.influencesTopOrRight, isFalse);
      expect(HandlePosition.topLeft.influencesTopOrLeft, isTrue);

      // Top right
      expect(HandlePosition.topRight.influencesLeft, isFalse);
      expect(HandlePosition.topRight.influencesTop, isTrue);
      expect(HandlePosition.topRight.influencesRight, isTrue);
      expect(HandlePosition.topRight.influencesBottom, isFalse);
      expect(HandlePosition.topRight.influencesBottomOrRight, isFalse);
      expect(HandlePosition.topRight.influencesBottomOrLeft, isFalse);
      expect(HandlePosition.topRight.influencesTopOrRight, isTrue);
      expect(HandlePosition.topRight.influencesTopOrLeft, isFalse);

      // Bottom left
      expect(HandlePosition.bottomLeft.influencesLeft, isTrue);
      expect(HandlePosition.bottomLeft.influencesTop, isFalse);
      expect(HandlePosition.bottomLeft.influencesRight, isFalse);
      expect(HandlePosition.bottomLeft.influencesBottom, isTrue);
      expect(HandlePosition.bottomLeft.influencesBottomOrRight, isFalse);
      expect(HandlePosition.bottomLeft.influencesBottomOrLeft, isTrue);
      expect(HandlePosition.bottomLeft.influencesTopOrRight, isFalse);
      expect(HandlePosition.bottomLeft.influencesTopOrLeft, isFalse);

      // Top
      expect(HandlePosition.top.influencesLeft, isFalse);
      expect(HandlePosition.top.influencesTop, isTrue);
      expect(HandlePosition.top.influencesRight, isFalse);
      expect(HandlePosition.top.influencesBottom, isFalse);
      expect(HandlePosition.top.influencesBottomOrRight, isFalse);
      expect(HandlePosition.top.influencesBottomOrLeft, isFalse);
      expect(HandlePosition.top.influencesTopOrRight, isTrue);
      expect(HandlePosition.top.influencesTopOrLeft, isTrue);

      // Bottom
      expect(HandlePosition.bottom.influencesLeft, isFalse);
      expect(HandlePosition.bottom.influencesTop, isFalse);
      expect(HandlePosition.bottom.influencesRight, isFalse);
      expect(HandlePosition.bottom.influencesBottom, isTrue);
      expect(HandlePosition.bottom.influencesBottomOrRight, isTrue);
      expect(HandlePosition.bottom.influencesBottomOrLeft, isTrue);
      expect(HandlePosition.bottom.influencesTopOrRight, isFalse);
      expect(HandlePosition.bottom.influencesTopOrLeft, isFalse);

      // Left
      expect(HandlePosition.left.influencesLeft, isTrue);
      expect(HandlePosition.left.influencesTop, isFalse);
      expect(HandlePosition.left.influencesRight, isFalse);
      expect(HandlePosition.left.influencesBottom, isFalse);
      expect(HandlePosition.left.influencesBottomOrRight, isFalse);
      expect(HandlePosition.left.influencesBottomOrLeft, isTrue);
      expect(HandlePosition.left.influencesTopOrRight, isFalse);
      expect(HandlePosition.left.influencesTopOrLeft, isTrue);

      // Right
      expect(HandlePosition.right.influencesLeft, isFalse);
      expect(HandlePosition.right.influencesTop, isFalse);
      expect(HandlePosition.right.influencesRight, isTrue);
      expect(HandlePosition.right.influencesBottom, isFalse);
      expect(HandlePosition.right.influencesBottomOrRight, isTrue);
      expect(HandlePosition.right.influencesBottomOrLeft, isFalse);
      expect(HandlePosition.right.influencesTopOrRight, isTrue);
      expect(HandlePosition.right.influencesTopOrLeft, isFalse);
    });

    test('HandlePosition.flip tests', () {
      expect(HandlePosition.bottomRight.flip(Flip.none),
          HandlePosition.bottomRight);
      expect(HandlePosition.bottomRight.flip(Flip.horizontal),
          HandlePosition.bottomLeft);
      expect(HandlePosition.bottomRight.flip(Flip.vertical),
          HandlePosition.topRight);
      expect(HandlePosition.bottomRight.flip(Flip.diagonal),
          HandlePosition.topLeft);

      expect(
          HandlePosition.bottomLeft.flip(Flip.none), HandlePosition.bottomLeft);
      expect(HandlePosition.bottomLeft.flip(Flip.horizontal),
          HandlePosition.bottomRight);
      expect(HandlePosition.bottomLeft.flip(Flip.vertical),
          HandlePosition.topLeft);
      expect(HandlePosition.bottomLeft.flip(Flip.diagonal),
          HandlePosition.topRight);

      expect(HandlePosition.topRight.flip(Flip.none), HandlePosition.topRight);
      expect(HandlePosition.topRight.flip(Flip.horizontal),
          HandlePosition.topLeft);
      expect(HandlePosition.topRight.flip(Flip.vertical),
          HandlePosition.bottomRight);
      expect(HandlePosition.topRight.flip(Flip.diagonal),
          HandlePosition.bottomLeft);

      expect(HandlePosition.topLeft.flip(Flip.none), HandlePosition.topLeft);
      expect(HandlePosition.topLeft.flip(Flip.horizontal),
          HandlePosition.topRight);
      expect(HandlePosition.topLeft.flip(Flip.vertical),
          HandlePosition.bottomLeft);
      expect(HandlePosition.topLeft.flip(Flip.diagonal),
          HandlePosition.bottomRight);

      expect(HandlePosition.top.flip(Flip.none), HandlePosition.top);
      expect(HandlePosition.top.flip(Flip.horizontal), HandlePosition.top);
      expect(HandlePosition.top.flip(Flip.vertical), HandlePosition.bottom);
      expect(HandlePosition.top.flip(Flip.diagonal), HandlePosition.bottom);

      expect(HandlePosition.bottom.flip(Flip.none), HandlePosition.bottom);
      expect(
          HandlePosition.bottom.flip(Flip.horizontal), HandlePosition.bottom);
      expect(HandlePosition.bottom.flip(Flip.vertical), HandlePosition.top);
      expect(HandlePosition.bottom.flip(Flip.diagonal), HandlePosition.top);

      expect(HandlePosition.left.flip(Flip.none), HandlePosition.left);
      expect(HandlePosition.left.flip(Flip.horizontal), HandlePosition.right);
      expect(HandlePosition.left.flip(Flip.vertical), HandlePosition.left);
      expect(HandlePosition.left.flip(Flip.diagonal), HandlePosition.right);

      expect(HandlePosition.right.flip(Flip.none), HandlePosition.right);
      expect(HandlePosition.right.flip(Flip.horizontal), HandlePosition.left);
      expect(HandlePosition.right.flip(Flip.vertical), HandlePosition.right);
      expect(HandlePosition.right.flip(Flip.diagonal), HandlePosition.left);
    });

    test('HandlePosition.opposite tests', () {
      expect(HandlePosition.bottomRight.opposite, HandlePosition.topLeft);
      expect(HandlePosition.bottomLeft.opposite, HandlePosition.topRight);
      expect(HandlePosition.topRight.opposite, HandlePosition.bottomLeft);
      expect(HandlePosition.topLeft.opposite, HandlePosition.bottomRight);
      expect(HandlePosition.top.opposite, HandlePosition.bottom);
      expect(HandlePosition.bottom.opposite, HandlePosition.top);
      expect(HandlePosition.left.opposite, HandlePosition.right);
      expect(HandlePosition.right.opposite, HandlePosition.left);
      expect(HandlePosition.none.opposite, HandlePosition.none);
    });

    test('HandlePosition.flipX tests', () {
      expect(HandlePosition.bottomRight.flipX(), HandlePosition.bottomLeft);
      expect(HandlePosition.bottomLeft.flipX(), HandlePosition.bottomRight);
      expect(HandlePosition.topRight.flipX(), HandlePosition.topLeft);
      expect(HandlePosition.topLeft.flipX(), HandlePosition.topRight);
      expect(HandlePosition.top.flipX(), HandlePosition.top);
      expect(HandlePosition.bottom.flipX(), HandlePosition.bottom);
      expect(HandlePosition.left.flipX(), HandlePosition.right);
      expect(HandlePosition.right.flipX(), HandlePosition.left);
      expect(HandlePosition.none.flipX(), HandlePosition.none);
    });

    test('HandlePosition.flipY tests', () {
      expect(HandlePosition.bottomRight.flipY(), HandlePosition.topRight);
      expect(HandlePosition.bottomLeft.flipY(), HandlePosition.topLeft);
      expect(HandlePosition.topRight.flipY(), HandlePosition.bottomRight);
      expect(HandlePosition.topLeft.flipY(), HandlePosition.bottomLeft);
      expect(HandlePosition.top.flipY(), HandlePosition.bottom);
      expect(HandlePosition.bottom.flipY(), HandlePosition.top);
      expect(HandlePosition.left.flipY(), HandlePosition.left);
      expect(HandlePosition.right.flipY(), HandlePosition.right);
      expect(HandlePosition.none.flipY(), HandlePosition.none);
    });

    test('HandlePosition.isHorizontal tests', () {
      expect(HandlePosition.bottomRight.isHorizontal, isFalse);
      expect(HandlePosition.bottomLeft.isHorizontal, isFalse);
      expect(HandlePosition.topRight.isHorizontal, isFalse);
      expect(HandlePosition.topLeft.isHorizontal, isFalse);
      expect(HandlePosition.top.isHorizontal, isFalse);
      expect(HandlePosition.bottom.isHorizontal, isFalse);
      expect(HandlePosition.left.isHorizontal, isTrue);
      expect(HandlePosition.right.isHorizontal, isTrue);
    });

    test('HandlePosition.isVertical tests', () {
      expect(HandlePosition.bottomRight.isVertical, isFalse);
      expect(HandlePosition.bottomLeft.isVertical, isFalse);
      expect(HandlePosition.topRight.isVertical, isFalse);
      expect(HandlePosition.topLeft.isVertical, isFalse);
      expect(HandlePosition.top.isVertical, isTrue);
      expect(HandlePosition.bottom.isVertical, isTrue);
      expect(HandlePosition.left.isVertical, isFalse);
      expect(HandlePosition.right.isVertical, isFalse);
    });

    test('HandlePosition.isDiagonal tests', () {
      expect(HandlePosition.bottomRight.isDiagonal, isTrue);
      expect(HandlePosition.bottomLeft.isDiagonal, isTrue);
      expect(HandlePosition.topRight.isDiagonal, isTrue);
      expect(HandlePosition.topLeft.isDiagonal, isTrue);
      expect(HandlePosition.top.isDiagonal, isFalse);
      expect(HandlePosition.bottom.isDiagonal, isFalse);
      expect(HandlePosition.left.isDiagonal, isFalse);
      expect(HandlePosition.right.isDiagonal, isFalse);
    });

    test('HandlePosition.isSide tests', () {
      expect(HandlePosition.bottomRight.isSide, isFalse);
      expect(HandlePosition.bottomLeft.isSide, isFalse);
      expect(HandlePosition.topRight.isSide, isFalse);
      expect(HandlePosition.topLeft.isSide, isFalse);
      expect(HandlePosition.top.isSide, isTrue);
      expect(HandlePosition.bottom.isSide, isTrue);
      expect(HandlePosition.left.isSide, isTrue);
      expect(HandlePosition.right.isSide, isTrue);
    });

    test('HandlePosition.corners tests', () {
      expect(
          HandlePosition.corners,
          containsAll(<HandlePosition>[
            HandlePosition.topLeft,
            HandlePosition.topRight,
            HandlePosition.bottomLeft,
            HandlePosition.bottomRight,
          ]));

      expect(
          HandlePosition.sides,
          containsAll(<HandlePosition>[
            HandlePosition.top,
            HandlePosition.bottom,
            HandlePosition.left,
            HandlePosition.right,
          ]));
    });

    test('HandlePosition.anchor tests', () {
      final rect = Box.fromLTRB(100, 100, 500, 500);
      expect(HandlePosition.bottomRight.anchor(rect), Vector2(100, 100));
      expect(HandlePosition.bottomLeft.anchor(rect), Vector2(500, 100));
      expect(HandlePosition.topRight.anchor(rect), Vector2(100, 500));
      expect(HandlePosition.topLeft.anchor(rect), Vector2(500, 500));
      expect(HandlePosition.top.anchor(rect), Vector2(300, 500));
      expect(HandlePosition.bottom.anchor(rect), Vector2(300, 100));
      expect(HandlePosition.left.anchor(rect), Vector2(500, 300));
      expect(HandlePosition.right.anchor(rect), Vector2(100, 300));
      // HandlePosition.none assumes bottom-right and returns top-left.
      expect(() => HandlePosition.none.anchor(rect), throwsArgumentError);
    });
  });

  group('Flip tests', () {
    test('Flip.fromValue tests', () {
      expect(Flip.fromValue(0, 0), Flip.none);
      expect(Flip.fromValue(-1, 0), Flip.horizontal);
      expect(Flip.fromValue(0, -1), Flip.vertical);
      expect(Flip.fromValue(-1, -1), Flip.diagonal);

      expect(Flip.fromValue(Random().nextInt(9999), Random().nextInt(9999)),
          Flip.none);
      expect(Flip.fromValue(-Random().nextInt(9999), Random().nextInt(9999)),
          Flip.horizontal);
      expect(Flip.fromValue(Random().nextInt(9999), -Random().nextInt(9999)),
          Flip.vertical);
      expect(Flip.fromValue(-Random().nextInt(9999), -Random().nextInt(9999)),
          Flip.diagonal);
    });

    test('Flip.isFlipped tests', () {
      expect(Flip.none.isFlipped, isFalse);
      expect(Flip.horizontal.isFlipped, isTrue);
      expect(Flip.vertical.isFlipped, isTrue);
      expect(Flip.diagonal.isFlipped, isTrue);
    });

    test('Flip.isNotFlipped tests', () {
      expect(Flip.none.isNotFlipped, isTrue);
      expect(Flip.horizontal.isNotFlipped, isFalse);
      expect(Flip.vertical.isNotFlipped, isFalse);
      expect(Flip.diagonal.isNotFlipped, isFalse);
    });

    test('Flip.isHorizontal tests', () {
      expect(Flip.none.isHorizontal, isFalse);
      expect(Flip.horizontal.isHorizontal, isTrue);
      expect(Flip.vertical.isHorizontal, isFalse);
      expect(Flip.diagonal.isHorizontal, isTrue);
    });

    test('Flip.isVertical tests', () {
      expect(Flip.none.isVertical, isFalse);
      expect(Flip.horizontal.isVertical, isFalse);
      expect(Flip.vertical.isVertical, isTrue);
      expect(Flip.diagonal.isVertical, isTrue);
    });

    test('Flip.isDiagonal tests', () {
      expect(Flip.none.isDiagonal, isFalse);
      expect(Flip.horizontal.isDiagonal, isFalse);
      expect(Flip.vertical.isDiagonal, isFalse);
      expect(Flip.diagonal.isDiagonal, isTrue);
    });

    test('Flip.isFlippingOnX tests', () {
      expect(Flip.none.isFlippingOnX, isFalse);
      expect(Flip.horizontal.isFlippingOnX, isTrue);
      expect(Flip.vertical.isFlippingOnX, isFalse);
      expect(Flip.diagonal.isFlippingOnX, isTrue);
    });

    test('Flip.isFlippingOnY tests', () {
      expect(Flip.none.isFlippingOnY, isFalse);
      expect(Flip.horizontal.isFlippingOnY, isFalse);
      expect(Flip.vertical.isFlippingOnY, isTrue);
      expect(Flip.diagonal.isFlippingOnY, isTrue);
    });

    test('Flip.horizontalValue tests', () {
      expect(Flip.none.horizontalValue, 1);
      expect(Flip.horizontal.horizontalValue, -1);
      expect(Flip.vertical.horizontalValue, 1);
      expect(Flip.diagonal.horizontalValue, -1);
    });

    test('Flip.verticalValue tests', () {
      expect(Flip.none.verticalValue, 1);
      expect(Flip.horizontal.verticalValue, 1);
      expect(Flip.vertical.verticalValue, -1);
      expect(Flip.diagonal.verticalValue, -1);
    });

    test('Flip * operator tests', () {
      expect(Flip.none * Flip.none, Flip.none);
      expect(Flip.none * Flip.horizontal, Flip.horizontal);
      expect(Flip.none * Flip.vertical, Flip.vertical);
      expect(Flip.none * Flip.diagonal, Flip.diagonal);

      expect(Flip.horizontal * Flip.none, Flip.horizontal);
      expect(Flip.horizontal * Flip.horizontal, Flip.none);
      expect(Flip.horizontal * Flip.vertical, Flip.diagonal);
      expect(Flip.horizontal * Flip.diagonal, Flip.vertical);

      expect(Flip.vertical * Flip.none, Flip.vertical);
      expect(Flip.vertical * Flip.horizontal, Flip.diagonal);
      expect(Flip.vertical * Flip.vertical, Flip.none);
      expect(Flip.vertical * Flip.diagonal, Flip.horizontal);

      expect(Flip.diagonal * Flip.none, Flip.diagonal);
      expect(Flip.diagonal * Flip.horizontal, Flip.vertical);
      expect(Flip.diagonal * Flip.vertical, Flip.horizontal);
      expect(Flip.diagonal * Flip.diagonal, Flip.none);
    });

    test('Flip.influencedBy operator tests', () {
      expect(Flip.none.influencedBy(Flip.none), Flip.none);
      expect(Flip.none.influencedBy(Flip.horizontal), Flip.horizontal);
      expect(Flip.none.influencedBy(Flip.vertical), Flip.vertical);
      expect(Flip.none.influencedBy(Flip.diagonal), Flip.diagonal);

      expect(Flip.horizontal.influencedBy(Flip.none), Flip.horizontal);
      expect(Flip.horizontal.influencedBy(Flip.horizontal), Flip.none);
      expect(Flip.horizontal.influencedBy(Flip.vertical), Flip.diagonal);
      expect(Flip.horizontal.influencedBy(Flip.diagonal), Flip.vertical);

      expect(Flip.vertical.influencedBy(Flip.none), Flip.vertical);
      expect(Flip.vertical.influencedBy(Flip.horizontal), Flip.diagonal);
      expect(Flip.vertical.influencedBy(Flip.vertical), Flip.none);
      expect(Flip.vertical.influencedBy(Flip.diagonal), Flip.horizontal);

      expect(Flip.diagonal.influencedBy(Flip.none), Flip.diagonal);
      expect(Flip.diagonal.influencedBy(Flip.horizontal), Flip.vertical);
      expect(Flip.diagonal.influencedBy(Flip.vertical), Flip.horizontal);
      expect(Flip.diagonal.influencedBy(Flip.diagonal), Flip.none);
    });

    test('Flip.prettify tests', () {
      expect(Flip.none.prettify, 'None');
      expect(Flip.horizontal.prettify, 'Horizontal');
      expect(Flip.vertical.prettify, 'Vertical');
      expect(Flip.diagonal.prettify, 'Diagonal');
    });
  });

  group('ResizeMode tests', () {
    test('ResizeMode.isFreeform tests', () {
      expect(ResizeMode.freeform.isFreeform, isTrue);
      expect(ResizeMode.symmetric.isFreeform, isFalse);
      expect(ResizeMode.scale.isFreeform, isFalse);
      expect(ResizeMode.symmetricScale.isFreeform, isFalse);
    });

    test('ResizeMode.isSymmetric tests', () {
      expect(ResizeMode.freeform.isSymmetric, isFalse);
      expect(ResizeMode.symmetric.isSymmetric, isTrue);
      expect(ResizeMode.scale.isSymmetric, isFalse);
      expect(ResizeMode.symmetricScale.isSymmetric, isFalse);
    });

    test('ResizeMode.isScale tests', () {
      expect(ResizeMode.freeform.isScale, isFalse);
      expect(ResizeMode.symmetric.isScale, isFalse);
      expect(ResizeMode.scale.isScale, isTrue);
      expect(ResizeMode.symmetricScale.isScale, isFalse);
    });

    test('ResizeMode.isSymmetricScale tests', () {
      expect(ResizeMode.freeform.isSymmetricScale, isFalse);
      expect(ResizeMode.symmetric.isSymmetricScale, isFalse);
      expect(ResizeMode.scale.isSymmetricScale, isFalse);
      expect(ResizeMode.symmetricScale.isSymmetricScale, isTrue);
    });

    test('ResizeMode.isScalable tests', () {
      expect(ResizeMode.freeform.isScalable, isFalse);
      expect(ResizeMode.symmetric.isScalable, isFalse);
      expect(ResizeMode.scale.isScalable, isTrue);
      expect(ResizeMode.symmetricScale.isScalable, isTrue);
    });

    test('ResizeMode.hasSymmetry tests', () {
      expect(ResizeMode.freeform.hasSymmetry, isFalse);
      expect(ResizeMode.symmetric.hasSymmetry, isTrue);
      expect(ResizeMode.scale.hasSymmetry, isFalse);
      expect(ResizeMode.symmetricScale.hasSymmetry, isTrue);
    });
  });
}
