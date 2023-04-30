import 'package:box_transform/box_transform.dart';
import 'package:test/test.dart';
import 'package:vector_math/vector_math.dart';

void main() {
  group('Dimension tests', () {
    test('Dimension constructor tests', () {
      final dimension = Dimension(300, 200);
      expect(dimension.width, 300);
      expect(dimension.height, 200);

      final copied = Dimension.copy(dimension);
      expect(copied.width, dimension.width);
      expect(copied.height, dimension.height);

      expect(Dimension.square(400).width, 400);
      expect(Dimension.square(400).height, 400);

      expect(Dimension.fromWidth(400).width, 400);
      expect(Dimension.fromWidth(400).height, double.infinity);

      expect(Dimension.fromHeight(400).height, 400);
      expect(Dimension.fromHeight(400).width, double.infinity);

      expect(Dimension.fromRadius(500).width, 1000);
      expect(Dimension.fromRadius(500).height, 1000);

      expect(Dimension.zero.width, 0);
      expect(Dimension.zero.height, 0);

      expect(Dimension.infinite.width, double.infinity);
      expect(Dimension.infinite.height, double.infinity);
    });

    test('Dimension equality tests', () {
      expect(Dimension(0, 0), Dimension.zero);
      expect(Dimension(500, 700), Dimension(500, 700));
      expect(Dimension(500, 700) == Dimension(500, 700), isTrue);
      expect(Dimension(500, 700) == Dimension(400, 700), isFalse);
      expect(Dimension(500, 700), isNot(Vector2(400, 700)));
      expect(Dimension(500, 700).hashCode, Dimension(500, 700).hashCode);
      expect(Dimension(500, 700).toString(), Dimension(500, 700).toString());
    });

    test('Dimension.aspectRatio tests', () {
      expect(Dimension(400, 300).aspectRatio, 4 / 3);
      expect(Dimension(300, 400).aspectRatio, 3 / 4);
      expect(Dimension(0, 300).aspectRatio, 0);
      expect(Dimension(300, 0).aspectRatio, double.infinity);
      expect(Dimension(-300, 0).aspectRatio, double.negativeInfinity);
      expect(Dimension.square(500).aspectRatio, 1);
    });

    test('Dimension.shortestSide tests', () {
      expect(Dimension(400, 300).shortestSide, 300);
      expect(Dimension(300, 400).shortestSide, 300);
      expect(Dimension.square(500).shortestSide, 500);
    });

    test('Dimension.longestSide tests', () {
      expect(Dimension(400, 300).longestSide, 400);
      expect(Dimension(300, 400).longestSide, 400);
      expect(Dimension.square(500).longestSide, 500);
    });

    test('Dimension - operation tests', () {
      expect(Dimension(400, 300) - Dimension(100, 200), Dimension(300, 100));
      expect(Dimension(0, 0) - Dimension(100, 200), Dimension(-100, -200));
      expect(Dimension(400, 300) - Dimension(0, 0), Dimension(400, 300));
      expect(Dimension(0, 0) - Dimension(0, 0), Dimension.zero);
    });

    test('Dimension + operation tests', () {
      expect(Dimension(400, 300) + Dimension(100, 200), Dimension(500, 500));
      expect(Dimension(0, 0) + Dimension(100, 200), Dimension(100, 200));
      expect(Dimension(400, 300) + Dimension(0, 0), Dimension(400, 300));
      expect(Dimension(0, 0) + Dimension(0, 0), Dimension.zero);
    });

    test('Dimension * operation tests', () {
      expect(Dimension(400, 300) * 2, Dimension(800, 600));
      expect(Dimension(0, 0) * 2, Dimension.zero);
      expect(Dimension(400, 300) * 0, Dimension.zero);
      expect(Dimension(400, 300) * -2, Dimension(-800, -600));
    });

    test('Dimension / operation tests', () {
      expect(Dimension(400, 300) / 2, Dimension(200, 150));
      expect(Dimension(0, 0) / 2, Dimension.zero);
      expect(Dimension(400, 300) / 0, Dimension.infinite);
      expect(Dimension(400, 300) / -2, Dimension(-200, -150));
    });

    test('Dimension ~/ operation tests', () {
      expect(Dimension(401, 301) ~/ 2, Dimension(200, 150));
      expect(Dimension(0, 0) ~/ 2, Dimension.zero);
      expect(() => Dimension(401, 301) ~/ 0, throwsUnsupportedError);
      expect(Dimension(401, 301) ~/ -2, Dimension(-200, -150));
    });

    test('Dimension % operation tests', () {
      expect(Dimension(401, 301) % 2, Dimension(1, 1));
      expect(Dimension(0, 0) % 2, Dimension.zero);
      expect((Dimension(401, 301) % 0).width.isNaN, isTrue);
      expect((Dimension(401, 301) % 0).height.isNaN, isTrue);
      expect(Dimension(401, 301) % -2, Dimension(1, 1));
    });

    test('Dimension.flipped tests', () {
      expect(Dimension(400, 300).flipped, Dimension(300, 400));
      expect(Dimension(300, 400).flipped, Dimension(400, 300));
      expect(Dimension.square(500).flipped, Dimension.square(500));
    });

    test('Dimension.ceil tests', () {
      expect(Dimension(400.1, 300.1).ceil(), Dimension(401, 301));
      expect(Dimension(300.9, 400.9).ceil(), Dimension(301, 401));
      expect(Dimension.square(500.5).ceil(), Dimension.square(501));
    });

    test('Dimension.floor tests', () {
      expect(Dimension(400.1, 300.1).floor(), Dimension(400, 300));
      expect(Dimension(300.9, 400.9).floor(), Dimension(300, 400));
      expect(Dimension.square(500.5).floor(), Dimension.square(500));
    });

    test('Dimension.topLeft tests', () {
      expect(Dimension(400, 300).topLeft(Vector2(100, 100)), Vector2(100, 100));
      expect(Dimension(300, 400).topLeft(Vector2(100, 100)), Vector2(100, 100));
      expect(
          Dimension.square(500).topLeft(Vector2(100, 100)), Vector2(100, 100));
    });

    test('Dimension.topCenter tests', () {
      expect(
          Dimension(400, 300).topCenter(Vector2(100, 100)), Vector2(300, 100));
      expect(
          Dimension(300, 400).topCenter(Vector2(100, 100)), Vector2(250, 100));
      expect(Dimension.square(500).topCenter(Vector2(100, 100)),
          Vector2(350, 100));
    });

    test('Dimension.topRight tests', () {
      expect(
          Dimension(400, 300).topRight(Vector2(100, 100)), Vector2(500, 100));
      expect(
          Dimension(300, 400).topRight(Vector2(100, 100)), Vector2(400, 100));
      expect(
          Dimension.square(500).topRight(Vector2(100, 100)), Vector2(600, 100));
    });

    test('Dimension.centerLeft tests', () {
      expect(
          Dimension(400, 300).centerLeft(Vector2(100, 100)), Vector2(100, 250));
      expect(
          Dimension(300, 400).centerLeft(Vector2(100, 100)), Vector2(100, 300));
      expect(Dimension.square(500).centerLeft(Vector2(100, 100)),
          Vector2(100, 350));
    });

    test('Dimension.center tests', () {
      expect(Dimension(400, 300).center(Vector2(100, 100)), Vector2(300, 250));
      expect(Dimension(300, 400).center(Vector2(100, 100)), Vector2(250, 300));
      expect(
          Dimension.square(500).center(Vector2(100, 100)), Vector2(350, 350));
    });

    test('Dimension.centerRight tests', () {
      expect(Dimension(400, 300).centerRight(Vector2(100, 100)),
          Vector2(500, 250));
      expect(Dimension(300, 400).centerRight(Vector2(100, 100)),
          Vector2(400, 300));
      expect(Dimension.square(500).centerRight(Vector2(100, 100)),
          Vector2(600, 350));
    });

    test('Dimension.bottomLeft tests', () {
      expect(
          Dimension(400, 300).bottomLeft(Vector2(100, 100)), Vector2(100, 400));
      expect(
          Dimension(300, 400).bottomLeft(Vector2(100, 100)), Vector2(100, 500));
      expect(Dimension.square(500).bottomLeft(Vector2(100, 100)),
          Vector2(100, 600));
    });

    test('Dimension.bottomCenter tests', () {
      expect(Dimension(400, 300).bottomCenter(Vector2(100, 100)),
          Vector2(300, 400));
      expect(Dimension(300, 400).bottomCenter(Vector2(100, 100)),
          Vector2(250, 500));
      expect(Dimension.square(500).bottomCenter(Vector2(100, 100)),
          Vector2(350, 600));
    });

    test('Dimension.bottomRight tests', () {
      expect(Dimension(400, 300).bottomRight(Vector2(100, 100)),
          Vector2(500, 400));
      expect(Dimension(300, 400).bottomRight(Vector2(100, 100)),
          Vector2(400, 500));
      expect(Dimension.square(500).bottomRight(Vector2(100, 100)),
          Vector2(600, 600));
    });

    test('Dimension.contains tests', () {
      expect(Dimension(400, 300).contains(Vector2(100, 100)), isTrue);
      expect(Dimension(400, 300).contains(Vector2(400, 300)), isFalse);
      expect(Dimension(400, 300).contains(Vector2(0, 0)), isTrue);
      expect(Dimension(400, 300).contains(Vector2(401, 300)), isFalse);
      expect(Dimension(400, 300).contains(Vector2(400, 301)), isFalse);
      expect(Dimension(400, 300).contains(Vector2(-1, 0)), isFalse);
      expect(Dimension(400, 300).contains(Vector2(0, -1)), isFalse);
      expect(Dimension(-400, -300).contains(Vector2(-500, -400)), isFalse);
    });

    test('Dimension.constrainBy tests', () {
      expect(Dimension(400, 300).constrainBy(Constraints.unconstrained()),
          Dimension(400, 300));
      expect(
          Dimension(400, 300)
              .constrainBy(Constraints(maxWidth: 200, maxHeight: 200)),
          Dimension(200, 200));
      expect(
          Dimension(400, 300).constrainBy(Constraints(
              maxWidth: 200, maxHeight: 200, minWidth: 100, minHeight: 100)),
          Dimension(200, 200));
      expect(
          Dimension(400, 300).constrainBy(Constraints(
              maxWidth: 500, maxHeight: 500, minWidth: 200, minHeight: 200)),
          Dimension(400, 300));
    });

    test('Dimension.lerp tests', () {
      expect(Dimension.lerp(Dimension(400, 300), Dimension(500, 400), 0.5),
          Dimension(450, 350));
      expect(Dimension.lerp(Dimension(400, 300), Dimension(500, 400), 0.0),
          Dimension(400, 300));
      expect(Dimension.lerp(Dimension(400, 300), Dimension(500, 400), 1.0),
          Dimension(500, 400));

      expect(Dimension.lerp(Dimension(400, 300), null, 1.0), Dimension(0, 0));
      expect(Dimension.lerp(Dimension(400, 300), null, 0), Dimension(400, 300));
      expect(
          Dimension.lerp(Dimension(400, 300), null, 0.5), Dimension(200, 150));
      expect(
          Dimension.lerp(null, Dimension(500, 400), 1.0), Dimension(500, 400));
      expect(Dimension.lerp(null, Dimension(500, 400), 0), Dimension(0, 0));
      expect(
          Dimension.lerp(null, Dimension(500, 400), 0.5), Dimension(250, 200));
      expect(Dimension.lerp(null, null, 1), null);
      expect(Dimension.lerp(null, null, 0), null);
      expect(Dimension.lerp(null, null, 0.5), null);

      expect(Dimension.lerp(Dimension(400, 300), Dimension(500, 400), -0.5),
          Dimension(350, 250));
      expect(Dimension.lerp(Dimension(400, 300), Dimension(500, 400), 1.5),
          Dimension(550, 450));
    });
  });

  group('Box tests', () {
    test('Box constructor tests', () {
      Box box = Box.fromLTRB(100, 100, 500, 400);
      expect(box.left, 100);
      expect(box.top, 100);
      expect(box.right, 500);
      expect(box.bottom, 400);

      box = Box.fromLTWH(100, 100, 400, 300);
      expect(box.left, 100);
      expect(box.top, 100);
      expect(box.right, 500);
      expect(box.bottom, 400);

      box = Box.fromCircle(center: Vector2(500, 500), radius: 100);
      expect(box.left, 400);
      expect(box.top, 400);
      expect(box.right, 600);
      expect(box.bottom, 600);

      box = Box.fromCenter(center: Vector2(500, 500), width: 400, height: 300);
      expect(box.left, 300);
      expect(box.top, 350);
      expect(box.right, 700);
      expect(box.bottom, 650);

      box = Box.fromPoints(Vector2(100, 100), Vector2(500, 400));
      expect(box.left, 100);
      expect(box.top, 100);
      expect(box.right, 500);
      expect(box.bottom, 400);
    });

    test('Box equality tests', () {
      Box box1 = Box.fromLTRB(100, 100, 500, 400);
      Box box2 = Box.fromLTRB(100, 100, 500, 400);

      expect(box1, box2);
      expect(box1, Box.fromLTWH(100, 100, 400, 300));
      expect(box1.toString(), box2.toString());
      expect(box1.hashCode, box2.hashCode);
      expect(Box.fromLTRB(0, 0, 0, 0), Box.zero);
    });

    test('Box.fromHandle tests', () {
      expect(
        Box.fromHandle(Vector2(100, 100), HandlePosition.bottomRight, 400, 300),
        Box.fromLTRB(100, 100, 500, 400),
      );

      expect(
        Box.fromHandle(Vector2(100, 100), HandlePosition.topLeft, 400, 300),
        Box.fromLTRB(-300, -200, 100, 100),
      );

      expect(
        Box.fromHandle(Vector2(100, 100), HandlePosition.topRight, 400, 300),
        Box.fromLTRB(100, -200, 500, 100),
      );

      expect(
        Box.fromHandle(Vector2(100, 100), HandlePosition.bottomLeft, 400, 300),
        Box.fromLTRB(-300, 100, 100, 400),
      );

      expect(
        Box.fromHandle(Vector2(300, 100), HandlePosition.bottom, 400, 300),
        Box.fromLTRB(100, 100, 500, 400),
      );

      expect(
        Box.fromHandle(Vector2(300, 100), HandlePosition.top, 400, 300),
        Box.fromLTRB(100, -200, 500, 100),
      );

      expect(
        Box.fromHandle(Vector2(500, 250), HandlePosition.left, 400, 300),
        Box.fromLTRB(100, 100, 500, 400),
      );

      expect(
        Box.fromHandle(Vector2(100, 250), HandlePosition.right, 400, 300),
        Box.fromLTRB(100, 100, 500, 400),
      );
    });

    test('Box.hasNaN tests', () {
      expect(Box.fromLTRB(100, 100, 500, 400).hasNaN, isFalse);
      expect(Box.fromLTRB(100, 100, 500, double.nan).hasNaN, isTrue);
      expect(Box.fromLTRB(100, 100, double.nan, 400).hasNaN, isTrue);
      expect(Box.fromLTRB(100, double.nan, 500, 400).hasNaN, isTrue);
      expect(Box.fromLTRB(double.nan, 100, 500, 400).hasNaN, isTrue);
      expect(Box.fromLTRB(100, double.nan, double.nan, 400).hasNaN, isTrue);
    });

    test('Box.isInfinite tests', () {
      expect(Box.fromLTRB(100, 100, 500, 400).isInfinite, isFalse);
      expect(Box.fromLTRB(100, 100, 500, double.infinity).isInfinite, isTrue);
      expect(Box.fromLTRB(100, 100, double.infinity, 400).isInfinite, isTrue);
      expect(Box.fromLTRB(100, double.infinity, 500, 400).isInfinite, isTrue);
      expect(Box.fromLTRB(double.infinity, 100, 500, 400).isInfinite, isTrue);
      expect(
          Box.fromLTRB(100, double.infinity, double.infinity, 400).isInfinite,
          isTrue);
    });

    test('Box.isFinite tests', () {
      expect(Box.fromLTRB(100, 100, 500, 400).isFinite, isTrue);
      expect(Box.fromLTRB(100, 100, 500, double.infinity).isFinite, isFalse);
      expect(Box.fromLTRB(100, 100, double.infinity, 400).isFinite, isFalse);
      expect(Box.fromLTRB(100, double.infinity, 500, 400).isFinite, isFalse);
      expect(Box.fromLTRB(double.infinity, 100, 500, 400).isFinite, isFalse);
      expect(Box.fromLTRB(100, double.infinity, double.infinity, 400).isFinite,
          isFalse);
    });

    test('Box.isEmpty tests', () {
      expect(Box.fromLTRB(100, 100, 500, 400).isEmpty, isFalse);
      expect(Box.fromLTRB(100, 100, 500, 100).isEmpty, isTrue);
      expect(Box.fromLTRB(100, 100, 100, 400).isEmpty, isTrue);
      expect(Box.fromLTRB(100, 400, 500, 400).isEmpty, isTrue);
      expect(Box.fromLTRB(500, 100, 500, 400).isEmpty, isTrue);
    });

    test('Box.shift tests', () {
      expect(Box.fromLTRB(100, 100, 500, 400).shift(Vector2(100, 100)),
          Box.fromLTRB(200, 200, 600, 500));
      expect(Box.fromLTRB(100, 100, 500, 400).shift(Vector2(-100, -100)),
          Box.fromLTRB(0, 0, 400, 300));
    });

    test('Box.translate tests', () {
      expect(Box.fromLTRB(100, 100, 500, 400).translate(100, 100),
          Box.fromLTRB(200, 200, 600, 500));
      expect(Box.fromLTRB(100, 100, 500, 400).translate(-100, -100),
          Box.fromLTRB(0, 0, 400, 300));
    });

    test('Box.inflate tests', () {
      expect(Box.fromLTRB(100, 100, 500, 400).inflate(100),
          Box.fromLTRB(0, 0, 600, 500));
      expect(Box.fromLTRB(100, 100, 500, 400).inflate(-100),
          Box.fromLTRB(200, 200, 400, 300));
    });

    test('Box.deflate tests', () {
      expect(Box.fromLTRB(100, 100, 500, 400).deflate(100),
          Box.fromLTRB(200, 200, 400, 300));
      expect(Box.fromLTRB(100, 100, 500, 400).deflate(-100),
          Box.fromLTRB(0, 0, 600, 500));
    });

    test('Box.intersect tests', () {
      expect(
          Box.fromLTRB(100, 100, 500, 400)
              .intersect(Box.fromLTRB(200, 200, 600, 500)),
          Box.fromLTRB(200, 200, 500, 400));
      expect(
          Box.fromLTRB(100, 100, 500, 400)
              .intersect(Box.fromLTRB(0, 0, 400, 300)),
          Box.fromLTRB(100, 100, 400, 300));
      expect(
          Box.fromLTRB(100, 100, 500, 400)
              .intersect(Box.fromLTRB(0, 0, 600, 500)),
          Box.fromLTRB(100, 100, 500, 400));
      expect(
          Box.fromLTRB(100, 100, 500, 400)
              .intersect(Box.fromLTRB(200, 200, 400, 300)),
          Box.fromLTRB(200, 200, 400, 300));
    });

    test('Box.expandToInclude tests', () {
      expect(
          Box.fromLTRB(100, 100, 500, 400)
              .expandToInclude(Box.fromLTRB(200, 200, 600, 500)),
          Box.fromLTRB(100, 100, 600, 500));
      expect(
          Box.fromLTRB(100, 100, 500, 400)
              .expandToInclude(Box.fromLTRB(0, 0, 400, 300)),
          Box.fromLTRB(0, 0, 500, 400));
      expect(
          Box.fromLTRB(100, 100, 500, 400)
              .expandToInclude(Box.fromLTRB(0, 0, 600, 500)),
          Box.fromLTRB(0, 0, 600, 500));
      expect(
          Box.fromLTRB(100, 100, 500, 400)
              .expandToInclude(Box.fromLTRB(200, 200, 400, 300)),
          Box.fromLTRB(100, 100, 500, 400));
    });

    test('Box.overlaps tests', () {
      expect(
          Box.fromLTRB(100, 100, 500, 400)
              .overlaps(Box.fromLTRB(200, 200, 600, 500)),
          isTrue);
      expect(
          Box.fromLTRB(100, 100, 500, 400)
              .overlaps(Box.fromLTRB(0, 0, 400, 300)),
          isTrue);
      expect(
          Box.fromLTRB(100, 100, 500, 400)
              .overlaps(Box.fromLTRB(0, 0, 600, 500)),
          isTrue);
      expect(
          Box.fromLTRB(100, 100, 500, 400)
              .overlaps(Box.fromLTRB(200, 200, 400, 300)),
          isTrue);
      expect(
          Box.fromLTRB(100, 100, 500, 400)
              .overlaps(Box.fromLTRB(0, 0, 100, 100)),
          isFalse);
      expect(
          Box.fromLTRB(100, 100, 500, 400)
              .overlaps(Box.fromLTRB(500, 400, 600, 500)),
          isFalse);
    });

    test('Box.shortestSide tests', () {
      expect(Box.fromLTRB(100, 100, 500, 400).shortestSide, 300);
      expect(Box.fromLTRB(100, 100, 500, 500).shortestSide, 400);
      expect(Box.fromLTRB(100, 100, 400, 500).shortestSide, 300);
      expect(Box.fromLTRB(100, 100, 400, 400).shortestSide, 300);
      expect(Box.fromLTRB(100, 100, 300, 400).shortestSide, 200);
      expect(Box.fromLTRB(100, 100, 300, 300).shortestSide, 200);
      expect(Box.fromLTRB(100, 100, 200, 300).shortestSide, 100);
      expect(Box.fromLTRB(100, 100, 200, 200).shortestSide, 100);
      expect(Box.fromLTRB(100, 100, 100, 200).shortestSide, 0);
      expect(Box.fromLTRB(100, 100, 100, 100).shortestSide, 0);
    });

    test('Box.longestSide tests', () {
      expect(Box.fromLTRB(100, 100, 500, 400).longestSide, 400);
      expect(Box.fromLTRB(100, 100, 500, 500).longestSide, 400);
      expect(Box.fromLTRB(100, 100, 400, 500).longestSide, 400);
      expect(Box.fromLTRB(100, 100, 400, 400).longestSide, 300);
      expect(Box.fromLTRB(100, 100, 300, 400).longestSide, 300);
      expect(Box.fromLTRB(100, 100, 300, 300).longestSide, 200);
      expect(Box.fromLTRB(100, 100, 200, 300).longestSide, 200);
      expect(Box.fromLTRB(100, 100, 200, 200).longestSide, 100);
      expect(Box.fromLTRB(100, 100, 100, 200).longestSide, 100);
      expect(Box.fromLTRB(100, 100, 100, 100).longestSide, 0);
    });

    test('Box handle tests', () {
      final box = Box.fromLTRB(100, 100, 500, 400);

      expect(box.topLeft, Vector2(100, 100));
      expect(box.topCenter, Vector2(300, 100));
      expect(box.topRight, Vector2(500, 100));
      expect(box.centerLeft, Vector2(100, 250));
      expect(box.center, Vector2(300, 250));
      expect(box.centerRight, Vector2(500, 250));
      expect(box.bottomLeft, Vector2(100, 400));
      expect(box.bottomCenter, Vector2(300, 400));
      expect(box.bottomRight, Vector2(500, 400));
    });

    test('Box.aspectRatio tests', () {
      expect(Box.fromLTRB(100, 100, 500, 400).aspectRatio, 4 / 3);
      expect(Box.fromLTRB(100, 100, 500, 500).aspectRatio, 1);
      expect(Box.fromLTRB(100, 100, 400, 500).aspectRatio, 3 / 4);

      expect(Box.fromLTRB(100, 100, 100, 400).aspectRatio, 0);
      expect(Box.fromLTRB(100, 100, 400, 100).aspectRatio, double.infinity);

      expect(Box.fromLTRB(100, 100, 400, -100).aspectRatio, -1.5);
    });

    test('Box.contains tests', () {
      expect(
          Box.fromLTRB(100, 100, 500, 400).contains(Vector2(100, 100)), isTrue);
      expect(Box.fromLTRB(100, 100, 500, 400).contains(Vector2(500, 400)),
          isFalse);
      expect(
          Box.fromLTRB(100, 100, 500, 400).contains(Vector2(300, 250)), isTrue);
      expect(Box.fromLTRB(100, 100, 500, 400).contains(Vector2(0, 0)), isFalse);
      expect(Box.fromLTRB(100, 100, 500, 400).contains(Vector2(600, 500)),
          isFalse);
      expect(
          Box.fromLTRB(100, 100, 500, 400).contains(Vector2(200, 200)), isTrue);
      expect(
          Box.fromLTRB(100, 100, 500, 400).contains(Vector2(400, 300)), isTrue);
      expect(
          Box.fromLTRB(100, 100, 500, 400).contains(Vector2(200, 300)), isTrue);
      expect(
          Box.fromLTRB(100, 100, 500, 400).contains(Vector2(400, 200)), isTrue);
      expect(Box.fromLTRB(100, 100, 500, 400).contains(Vector2(200, 400)),
          isFalse);
      expect(
          Box.fromLTRB(100, 100, 500, 400).contains(Vector2(400, 100)), isTrue);
      expect(Box.fromLTRB(100, 100, 500, 400).contains(Vector2(100, 400)),
          isFalse);
      expect(Box.fromLTRB(100, 100, 500, 400).contains(Vector2(100, 500)),
          isFalse);
      expect(Box.fromLTRB(100, 100, 500, 400).contains(Vector2(500, 100)),
          isFalse);
    });

    test('Box.constrainBy tests', () {
      expect(
          Box.fromLTRB(100, 100, 500, 400)
              .constrainBy(Constraints.unconstrained()),
          Box.fromLTRB(100, 100, 500, 400));
      expect(
          Box.fromLTRB(100, 100, 500, 400)
              .constrainBy(Constraints(maxWidth: 200, maxHeight: 200)),
          Box.fromLTRB(100, 100, 300, 300));
      expect(
          Box.fromLTRB(100, 100, 500, 400).constrainBy(
              Constraints(maxWidth: 300, maxHeight: 300, minHeight: 200)),
          Box.fromLTRB(100, 100, 400, 400));
      expect(
          Box.fromLTRB(100, 100, 500, 400).constrainBy(
              Constraints(maxWidth: 300, maxHeight: 300, minWidth: 200)),
          Box.fromLTRB(100, 100, 400, 400));
      expect(
          Box.fromLTRB(100, 100, 500, 400).constrainBy(Constraints(
              maxWidth: 300, maxHeight: 300, minWidth: 200, minHeight: 200)),
          Box.fromLTRB(100, 100, 400, 400));
    });

    test('Box.isOverflowing tests', () {
      expect(
          Box.fromLTRB(100, 100, 500, 400)
              .isOverflowing(Box.fromLTRB(100, 100, 500, 400)),
          isFalse);
      expect(
          Box.fromLTRB(100, 100, 500, 400)
              .isOverflowing(Box.fromLTRB(100, 100, 400, 400)),
          isFalse);
      expect(
          Box.fromLTRB(100, 100, 500, 400)
              .isOverflowing(Box.fromLTRB(100, 100, 500, 300)),
          isFalse);
      expect(
          Box.fromLTRB(100, 100, 500, 400)
              .isOverflowing(Box.fromLTRB(100, 100, 400, 300)),
          isFalse);
      expect(
          Box.fromLTRB(100, 100, 500, 400)
              .isOverflowing(Box.fromLTRB(100, 100, 600, 500)),
          isTrue);
      expect(
          Box.fromLTRB(100, 100, 500, 400)
              .isOverflowing(Box.fromLTRB(100, 100, 600, 400)),
          isTrue);
      expect(
          Box.fromLTRB(100, 100, 500, 400)
              .isOverflowing(Box.fromLTRB(100, 100, 500, 500)),
          isTrue);
      expect(
          Box.fromLTRB(100, 100, 500, 400)
              .isOverflowing(Box.fromLTRB(100, 100, 400, 500)),
          isTrue);
    });

    test('Box.ceil tests', () {
      expect(Box.fromLTRB(100, 100, 500, 400).ceil(),
          Box.fromLTRB(100, 100, 500, 400));
      expect(Box.fromLTRB(100, 100, 500, 400.5).ceil(),
          Box.fromLTRB(100, 100, 500, 401));
      expect(Box.fromLTRB(100, 100, 500.5, 400).ceil(),
          Box.fromLTRB(100, 100, 501, 400));
      expect(Box.fromLTRB(100, 100, 500.5, 400.5).ceil(),
          Box.fromLTRB(100, 100, 501, 401));
    });

    test('Box.floor tests', () {
      expect(Box.fromLTRB(100, 100, 500, 400).floor(),
          Box.fromLTRB(100, 100, 500, 400));
      expect(Box.fromLTRB(100, 100, 500, 400.5).floor(),
          Box.fromLTRB(100, 100, 500, 400));
      expect(Box.fromLTRB(100, 100, 500.5, 400).floor(),
          Box.fromLTRB(100, 100, 500, 400));
      expect(Box.fromLTRB(100, 100, 500.5, 400.5).floor(),
          Box.fromLTRB(100, 100, 500, 400));
    });

    test('Box.lerp tests', () {
      expect(
          Box.lerp(Box.fromLTRB(100, 100, 500, 400),
              Box.fromLTRB(200, 200, 600, 500), 0.5),
          Box.fromLTRB(150, 150, 550, 450));
      expect(
          Box.lerp(Box.fromLTRB(100, 100, 500, 400),
              Box.fromLTRB(200, 200, 600, 500), 0.0),
          Box.fromLTRB(100, 100, 500, 400));
      expect(
          Box.lerp(Box.fromLTRB(100, 100, 500, 400),
              Box.fromLTRB(200, 200, 600, 500), 1.0),
          Box.fromLTRB(200, 200, 600, 500));

      expect(
          Box.lerp(Box.fromLTRB(100, 100, 500, 400),
              Box.fromLTRB(200, 200, 600, 500), -0.5),
          Box.fromLTRB(50, 50, 450, 350));
      expect(
          Box.lerp(Box.fromLTRB(100, 100, 500, 400),
              Box.fromLTRB(200, 200, 600, 500), 1.5),
          Box.fromLTRB(250, 250, 650, 550));

      expect(Box.lerp(Box.fromLTRB(100, 100, 500, 400), null, 1), Box.zero);
      expect(Box.lerp(Box.fromLTRB(100, 100, 500, 400), null, 0),
          Box.fromLTRB(100, 100, 500, 400));
      expect(Box.lerp(null, Box.fromLTRB(100, 100, 500, 400), 0), Box.zero);
      expect(Box.lerp(null, Box.fromLTRB(100, 100, 500, 400), 1),
          Box.fromLTRB(100, 100, 500, 400));
      expect(Box.lerp(null, null, 1), null);
      expect(Box.lerp(null, null, 0), null);
      expect(Box.lerp(null, null, 0.5), null);
    });

    test('Box.clampThisInsideParent tests', () {
      expect(
          Box.fromLTRB(100, 100, 500, 400)
              .clampThisInsideParent(Box.fromLTRB(100, 100, 500, 400)),
          Box.fromLTRB(100, 100, 500, 400));
      expect(
          Box.fromLTRB(100, 100, 500, 400)
              .clampThisInsideParent(Box.fromLTRB(100, 100, 400, 400)),
          Box.fromLTRB(100, 100, 400, 400));
      expect(
          Box.fromLTRB(100, 100, 500, 400)
              .clampThisInsideParent(Box.fromLTRB(100, 100, 500, 300)),
          Box.fromLTRB(100, 100, 500, 300));
      expect(
          Box.fromLTRB(100, 100, 500, 400)
              .clampThisInsideParent(Box.fromLTRB(100, 100, 400, 300)),
          Box.fromLTRB(100, 100, 400, 300));
      expect(
          Box.fromLTRB(100, 100, 500, 400)
              .clampThisInsideParent(Box.fromLTRB(100, 100, 600, 500)),
          Box.fromLTRB(100, 100, 500, 400));
      expect(
          Box.fromLTRB(100, 100, 500, 400)
              .clampThisInsideParent(Box.fromLTRB(100, 100, 600, 400)),
          Box.fromLTRB(100, 100, 500, 400));
      expect(
          Box.fromLTRB(100, 100, 500, 400)
              .clampThisInsideParent(Box.fromLTRB(100, 100, 500, 500)),
          Box.fromLTRB(100, 100, 500, 400));
      expect(
          Box.fromLTRB(100, 100, 500, 400)
              .clampThisInsideParent(Box.fromLTRB(100, 100, 400, 500)),
          Box.fromLTRB(100, 100, 400, 400));
    });
  });

  group('Constraints tests', () {
    test('Constraints constructor tests', () {
      Constraints constraints = Constraints();
      expect(constraints.minWidth, 0);
      expect(constraints.maxWidth, double.infinity);
      expect(constraints.minHeight, 0);
      expect(constraints.maxHeight, double.infinity);

      constraints = Constraints.unconstrained();
      expect(constraints.minWidth, double.infinity);
      expect(constraints.maxWidth, double.infinity);
      expect(constraints.minHeight, double.infinity);
      expect(constraints.maxHeight, double.infinity);

      expect(() => Constraints(minWidth: 300, maxWidth: 200),
          throwsA(isA<AssertionError>()));
    });

    test('Constraints equality tests', () {
      Constraints constraints1 = Constraints();
      Constraints constraints2 = Constraints();

      expect(constraints1, constraints2);
      expect(constraints1.hashCode, constraints2.hashCode);
      expect(constraints1 == constraints2, isTrue);
      expect(constraints1.toString(), constraints2.toString());

      expect(Constraints.unconstrained(), Constraints.unconstrained());
    });

    test('Constraints.goesToZero tests', () {
      expect(Constraints().goesToZero, isTrue);
      expect(Constraints(minWidth: 0, maxWidth: 0).goesToZero, isTrue);
      expect(Constraints(minWidth: 0, maxWidth: 100).goesToZero, isTrue);
      expect(Constraints(minWidth: 100, maxWidth: 100).goesToZero, isFalse);
      expect(Constraints(minWidth: 100, maxWidth: 200).goesToZero, isFalse);
      expect(Constraints(minWidth: 100, maxWidth: double.infinity).goesToZero,
          isFalse);
      expect(Constraints(minWidth: 0, maxWidth: double.infinity).goesToZero,
          isTrue);
      expect(Constraints(minWidth: 0, maxWidth: double.infinity).goesToZero,
          isTrue);
      expect(Constraints(minWidth: 0, maxWidth: double.infinity).goesToZero,
          isTrue);
      expect(Constraints.unconstrained().goesToZero, isFalse);
    });

    test('Constraints.isUnconstrained tests', () {
      expect(Constraints().isUnconstrained, isFalse);
      expect(Constraints(minWidth: 0, maxWidth: 0).isUnconstrained, isFalse);
      expect(Constraints(minWidth: 0, maxWidth: 100).isUnconstrained, isFalse);
      expect(
          Constraints(minWidth: 100, maxWidth: 100).isUnconstrained, isFalse);
      expect(
          Constraints(minWidth: 100, maxWidth: 200).isUnconstrained, isFalse);
      expect(
          Constraints(minWidth: 100, maxWidth: double.infinity).isUnconstrained,
          isFalse);
      expect(
          Constraints(minWidth: 0, maxWidth: double.infinity).isUnconstrained,
          isFalse);
      expect(
          Constraints(minWidth: 0, maxWidth: double.infinity).isUnconstrained,
          isFalse);
      expect(
          Constraints(minWidth: 0, maxWidth: double.infinity).isUnconstrained,
          isFalse);
      expect(Constraints.unconstrained().isUnconstrained, isTrue);
    });

    test('Constraints.constrainDimension tests', () {
      expect(Constraints().constrainDimension(Dimension(400, 300)),
          Dimension(400, 300));
      expect(
          Constraints(minWidth: 0, maxWidth: 0)
              .constrainDimension(Dimension(400, 300)),
          Dimension(0, 300));
      expect(
          Constraints(minWidth: 0, maxWidth: 100)
              .constrainDimension(Dimension(400, 300)),
          Dimension(100, 300));
      expect(
          Constraints(minWidth: 100, maxWidth: 100)
              .constrainDimension(Dimension(400, 300)),
          Dimension(100, 300));
      expect(
          Constraints(minWidth: 100, maxWidth: 200)
              .constrainDimension(Dimension(400, 300)),
          Dimension(200, 300));
      expect(
          Constraints(minWidth: 100, maxWidth: double.infinity)
              .constrainDimension(Dimension(400, 300)),
          Dimension(400, 300));
      expect(
          Constraints(minWidth: 0, maxWidth: double.infinity)
              .constrainDimension(Dimension(400, 300)),
          Dimension(400, 300));
      expect(
          Constraints(minWidth: 0, maxWidth: double.infinity)
              .constrainDimension(Dimension(400, 300)),
          Dimension(400, 300));
      expect(
          Constraints(minWidth: 0, maxWidth: double.infinity)
              .constrainDimension(Dimension(400, 300)),
          Dimension(400, 300));
      expect(
          Constraints.unconstrained().constrainDimension(Dimension(400, 300)),
          Dimension(400, 300));
    });

    test('Constraints.constrainBox tests', () {
      expect(Constraints().constrainBox(Box.fromLTRB(100, 100, 400, 300)),
          Box.fromLTRB(100, 100, 400, 300));
      expect(
          Constraints(minWidth: 0, maxWidth: 0)
              .constrainBox(Box.fromLTRB(100, 100, 400, 300)),
          Box.fromLTRB(100, 100, 100, 300));
      expect(
          Constraints(minWidth: 0, maxWidth: 100)
              .constrainBox(Box.fromLTRB(100, 100, 400, 300)),
          Box.fromLTRB(100, 100, 200, 300));
      expect(
          Constraints(minWidth: 100, maxWidth: 100)
              .constrainBox(Box.fromLTRB(100, 100, 400, 300)),
          Box.fromLTRB(100, 100, 200, 300));
      expect(
          Constraints(minWidth: 100, maxWidth: 200)
              .constrainBox(Box.fromLTRB(100, 100, 400, 300)),
          Box.fromLTRB(100, 100, 300, 300));
      expect(
          Constraints(minWidth: 100, maxWidth: double.infinity)
              .constrainBox(Box.fromLTRB(100, 100, 400, 300)),
          Box.fromLTRB(100, 100, 400, 300));
      expect(
          Constraints(minWidth: 0, maxWidth: double.infinity)
              .constrainBox(Box.fromLTRB(100, 100, 400, 300)),
          Box.fromLTRB(100, 100, 400, 300));
      expect(
          Constraints(minWidth: 0, maxWidth: double.infinity)
              .constrainBox(Box.fromLTRB(100, 100, 400, 300)),
          Box.fromLTRB(100, 100, 400, 300));
      expect(
          Constraints(minWidth: 0, maxWidth: double.infinity)
              .constrainBox(Box.fromLTRB(100, 100, 400, 300)),
          Box.fromLTRB(100, 100, 400, 300));
      expect(
          Constraints.unconstrained()
              .constrainBox(Box.fromLTRB(100, 100, 400, 300)),
          Box.fromLTRB(100, 100, 400, 300));
    });
  });
}
