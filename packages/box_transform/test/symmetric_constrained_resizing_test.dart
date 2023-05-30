import 'package:test/test.dart';
import 'package:vector_math/vector_math.dart';
import 'package:box_transform/box_transform.dart';
import 'utils.dart';

void main() {
  test('symmetric constrained resizing with corner handles', () {
    var result = BoxTransformer.resize(
      resizeMode: ResizeMode.symmetric,
      initialFlip: Flip.none,
      initialBox: Box.fromLTWH(225.26, 347.45, 308.27, 232.27),
      handle: HandlePosition.bottomRight,
      initialLocalPosition: Vector2(13.21, 13.53),
      allowBoxFlipping: true,
      localPosition: Vector2(204.80, 30.39),
      clampingRect: Box.fromLTWH(70.42, 87.23, 610.14, 784.32),
      constraints: Constraints(
          minWidth: 100.00,
          minHeight: 100.00,
          maxWidth: 500.00,
          maxHeight: 500.00),
    );

    expect(result.flip, Flip.none);
    expect(result.rect,
        withTolerance(Box.fromLTWH(129.39, 330.59, 500.00, 265.99)));
    expect(result.resizeMode, ResizeMode.symmetric);

    result = BoxTransformer.resize(
      resizeMode: ResizeMode.symmetric,
      initialFlip: Flip.none,
      initialBox: Box.fromLTWH(129.39, 330.59, 500.00, 265.99),
      handle: HandlePosition.bottomRight,
      initialLocalPosition: Vector2(11.27, 15.20),
      allowBoxFlipping: true,
      localPosition: Vector2(-117.45, 323.94),
      clampingRect: Box.fromLTWH(70.42, 87.23, 610.14, 784.32),
      constraints: Constraints(
          minWidth: 100.00,
          minHeight: 100.00,
          maxWidth: 500.00,
          maxHeight: 500.00),
    );

    expect(result.flip, Flip.none);
    expect(result.rect,
        withTolerance(Box.fromLTWH(258.11, 213.59, 242.56, 500.00)));
    expect(result.resizeMode, ResizeMode.symmetric);

    result = BoxTransformer.resize(
      resizeMode: ResizeMode.symmetric,
      initialFlip: Flip.none,
      initialBox: Box.fromLTWH(258.11, 213.59, 242.56, 500.00),
      handle: HandlePosition.bottomRight,
      initialLocalPosition: Vector2(11.38, 12.74),
      allowBoxFlipping: true,
      localPosition: Vector2(231.17, 190.23),
      clampingRect: Box.fromLTWH(70.42, 87.23, 610.14, 784.32),
      constraints: Constraints(
          minWidth: 100.00,
          minHeight: 100.00,
          maxWidth: 500.00,
          maxHeight: 500.00),
    );

    expect(result.flip, Flip.none);
    expect(result.rect,
        withTolerance(Box.fromLTWH(129.39, 213.59, 500.00, 500.00)));
    expect(result.resizeMode, ResizeMode.symmetric);

    result = BoxTransformer.resize(
      resizeMode: ResizeMode.symmetric,
      initialFlip: Flip.none,
      initialBox: Box.fromLTWH(129.39, 213.59, 500.00, 500.00),
      handle: HandlePosition.bottomRight,
      initialLocalPosition: Vector2(10.59, 14.82),
      allowBoxFlipping: true,
      localPosition: Vector2(-22.73, -226.34),
      clampingRect: Box.fromLTWH(70.42, 87.23, 610.14, 784.32),
      constraints: Constraints(
          minWidth: 100.00,
          minHeight: 100.00,
          maxWidth: 500.00,
          maxHeight: 500.00),
    );

    expect(result.flip, Flip.none);
    expect(result.rect,
        withTolerance(Box.fromLTWH(162.72, 413.59, 433.34, 100.00)));
    expect(result.resizeMode, ResizeMode.symmetric);

    result = BoxTransformer.resize(
      resizeMode: ResizeMode.symmetric,
      initialFlip: Flip.none,
      initialBox: Box.fromLTWH(162.72, 413.59, 433.34, 100.00),
      handle: HandlePosition.bottomRight,
      initialLocalPosition: Vector2(15.00, 14.76),
      allowBoxFlipping: true,
      localPosition: Vector2(-167.17, 289.90),
      clampingRect: Box.fromLTWH(70.42, 87.23, 610.14, 784.32),
      constraints: Constraints(
          minWidth: 100.00,
          minHeight: 100.00,
          maxWidth: 500.00,
          maxHeight: 500.00),
    );

    expect(result.flip, Flip.none);
    expect(result.rect,
        withTolerance(Box.fromLTWH(329.39, 213.59, 100.00, 500.00)));
    expect(result.resizeMode, ResizeMode.symmetric);

    result = BoxTransformer.resize(
      resizeMode: ResizeMode.symmetric,
      initialFlip: Flip.none,
      initialBox: Box.fromLTWH(329.39, 213.59, 100.00, 500.00),
      handle: HandlePosition.bottomRight,
      initialLocalPosition: Vector2(10.67, 13.30),
      allowBoxFlipping: true,
      localPosition: Vector2(-22.68, -225.58),
      clampingRect: Box.fromLTWH(70.42, 87.23, 610.14, 784.32),
      constraints: Constraints(
          minWidth: 100.00,
          minHeight: 100.00,
          maxWidth: 500.00,
          maxHeight: 500.00),
    );

    expect(result.flip, Flip.none);
    expect(result.rect,
        withTolerance(Box.fromLTWH(329.39, 413.59, 100.00, 100.00)));
    expect(result.resizeMode, ResizeMode.symmetric);

    result = BoxTransformer.resize(
      resizeMode: ResizeMode.symmetric,
      initialFlip: Flip.none,
      initialBox: Box.fromLTWH(329.39, 413.59, 100.00, 100.00),
      handle: HandlePosition.topLeft,
      initialLocalPosition: Vector2(12.60, 11.15),
      allowBoxFlipping: true,
      localPosition: Vector2(-277.93, 71.82),
      clampingRect: Box.fromLTWH(70.42, 87.23, 610.14, 784.32),
      constraints: Constraints(
          minWidth: 100.00,
          minHeight: 100.00,
          maxWidth: 500.00,
          maxHeight: 500.00),
    );

    expect(result.flip, Flip.vertical);
    expect(result.rect,
        withTolerance(Box.fromLTWH(129.39, 413.59, 500.00, 100.00)));
    expect(result.resizeMode, ResizeMode.symmetric);

    result = BoxTransformer.resize(
      resizeMode: ResizeMode.symmetric,
      initialFlip: Flip.vertical,
      initialBox: Box.fromLTWH(129.39, 413.59, 500.00, 100.00),
      handle: HandlePosition.topLeft,
      initialLocalPosition: Vector2(12.23, 12.50),
      allowBoxFlipping: true,
      localPosition: Vector2(607.39, -259.30),
      clampingRect: Box.fromLTWH(70.42, 87.23, 610.14, 784.32),
      constraints: Constraints(
          minWidth: 100.00,
          minHeight: 100.00,
          maxWidth: 500.00,
          maxHeight: 500.00),
    );

    expect(result.flip, Flip.diagonal);
    expect(result.rect,
        withTolerance(Box.fromLTWH(129.39, 213.59, 500.00, 500.00)));
    expect(result.resizeMode, ResizeMode.symmetric);

    result = BoxTransformer.resize(
      resizeMode: ResizeMode.symmetric,
      initialFlip: Flip.diagonal,
      initialBox: Box.fromLTWH(129.39, 213.59, 500.00, 500.00),
      handle: HandlePosition.topRight,
      initialLocalPosition: Vector2(11.48, 9.76),
      allowBoxFlipping: true,
      localPosition: Vector2(-595.91, 576.17),
      clampingRect: Box.fromLTWH(70.42, 87.23, 610.14, 784.32),
      constraints: Constraints(
          minWidth: 100.00,
          minHeight: 100.00,
          maxWidth: 500.00,
          maxHeight: 500.00),
    );

    expect(result.flip, Flip.none);
    expect(result.rect,
        withTolerance(Box.fromLTWH(129.39, 213.59, 500.00, 500.00)));
    expect(result.resizeMode, ResizeMode.symmetric);

    result = BoxTransformer.resize(
      resizeMode: ResizeMode.symmetric,
      initialFlip: Flip.none,
      initialBox: Box.fromLTWH(129.39, 213.59, 500.00, 500.00),
      handle: HandlePosition.topRight,
      initialLocalPosition: Vector2(15.19, 13.73),
      allowBoxFlipping: true,
      localPosition: Vector2(-211.99, 248.64),
      clampingRect: Box.fromLTWH(70.42, 87.23, 610.14, 784.32),
      constraints: Constraints(
          minWidth: 100.00,
          minHeight: 100.00,
          maxWidth: 500.00,
          maxHeight: 500.00),
    );

    expect(result.flip, Flip.none);
    expect(result.rect,
        withTolerance(Box.fromLTWH(329.39, 413.59, 100.00, 100.00)));
    expect(result.resizeMode, ResizeMode.symmetric);
  });

  test('symmetric constrained resizing with side handles', () {
    var result = BoxTransformer.resize(
      resizeMode: ResizeMode.symmetric,
      initialFlip: Flip.none,
      initialBox: Box.fromLTWH(329.39, 413.59, 100.00, 100.00),
      handle: HandlePosition.right,
      initialLocalPosition: Vector2(14.53, 41.65),
      allowBoxFlipping: true,
      localPosition: Vector2(303.98, 33.76),
      clampingRect: Box.fromLTWH(70.42, 87.23, 610.14, 784.32),
      constraints: Constraints(
          minWidth: 100.00,
          minHeight: 100.00,
          maxWidth: 500.00,
          maxHeight: 500.00),
    );

    expect(result.flip, Flip.none);
    expect(result.rect,
        withTolerance(Box.fromLTWH(129.39, 413.59, 500.00, 100.00)));
    expect(result.resizeMode, ResizeMode.symmetric);

    result = BoxTransformer.resize(
      resizeMode: ResizeMode.symmetric,
      initialFlip: Flip.none,
      initialBox: Box.fromLTWH(129.39, 413.59, 500.00, 100.00),
      handle: HandlePosition.bottom,
      initialLocalPosition: Vector2(240.86, 10.37),
      allowBoxFlipping: true,
      localPosition: Vector2(247.27, 298.89),
      clampingRect: Box.fromLTWH(70.42, 87.23, 610.14, 784.32),
      constraints: Constraints(
          minWidth: 100.00,
          minHeight: 100.00,
          maxWidth: 500.00,
          maxHeight: 500.00),
    );

    expect(result.flip, Flip.none);
    expect(result.rect,
        withTolerance(Box.fromLTWH(129.39, 213.59, 500.00, 500.00)));
    expect(result.resizeMode, ResizeMode.symmetric);

    result = BoxTransformer.resize(
      resizeMode: ResizeMode.symmetric,
      initialFlip: Flip.none,
      initialBox: Box.fromLTWH(129.39, 213.59, 500.00, 500.00),
      handle: HandlePosition.bottom,
      initialLocalPosition: Vector2(241.98, 13.46),
      allowBoxFlipping: true,
      localPosition: Vector2(237.52, -217.33),
      clampingRect: Box.fromLTWH(70.42, 87.23, 610.14, 784.32),
      constraints: Constraints(
          minWidth: 100.00,
          minHeight: 100.00,
          maxWidth: 500.00,
          maxHeight: 500.00),
    );

    expect(result.flip, Flip.none);
    expect(result.rect,
        withTolerance(Box.fromLTWH(129.39, 413.59, 500.00, 100.00)));
    expect(result.resizeMode, ResizeMode.symmetric);

    result = BoxTransformer.resize(
      resizeMode: ResizeMode.symmetric,
      initialFlip: Flip.none,
      initialBox: Box.fromLTWH(129.39, 413.59, 500.00, 100.00),
      handle: HandlePosition.left,
      initialLocalPosition: Vector2(13.95, 34.93),
      allowBoxFlipping: true,
      localPosition: Vector2(242.93, 45.24),
      clampingRect: Box.fromLTWH(70.42, 87.23, 610.14, 784.32),
      constraints: Constraints(
          minWidth: 100.00,
          minHeight: 100.00,
          maxWidth: 500.00,
          maxHeight: 500.00),
    );

    expect(result.flip, Flip.none);
    expect(result.rect,
        withTolerance(Box.fromLTWH(329.39, 413.59, 100.00, 100.00)));
    expect(result.resizeMode, ResizeMode.symmetric);

    result = BoxTransformer.resize(
      resizeMode: ResizeMode.symmetric,
      initialFlip: Flip.none,
      initialBox: Box.fromLTWH(329.39, 413.59, 100.00, 100.00),
      handle: HandlePosition.top,
      initialLocalPosition: Vector2(39.08, 11.90),
      allowBoxFlipping: true,
      localPosition: Vector2(23.88, -244.35),
      clampingRect: Box.fromLTWH(70.42, 87.23, 610.14, 784.32),
      constraints: Constraints(
          minWidth: 100.00,
          minHeight: 100.00,
          maxWidth: 500.00,
          maxHeight: 500.00),
    );

    expect(result.flip, Flip.none);
    expect(result.rect,
        withTolerance(Box.fromLTWH(329.39, 213.59, 100.00, 500.00)));
    expect(result.resizeMode, ResizeMode.symmetric);

    result = BoxTransformer.resize(
      resizeMode: ResizeMode.symmetric,
      initialFlip: Flip.none,
      initialBox: Box.fromLTWH(329.39, 213.59, 100.00, 500.00),
      handle: HandlePosition.right,
      initialLocalPosition: Vector2(12.82, 240.27),
      allowBoxFlipping: true,
      localPosition: Vector2(296.89, 236.39),
      clampingRect: Box.fromLTWH(70.42, 87.23, 610.14, 784.32),
      constraints: Constraints(
          minWidth: 100.00,
          minHeight: 100.00,
          maxWidth: 500.00,
          maxHeight: 500.00),
    );

    expect(result.flip, Flip.none);
    expect(result.rect,
        withTolerance(Box.fromLTWH(129.39, 213.59, 500.00, 500.00)));
    expect(result.resizeMode, ResizeMode.symmetric);

    result = BoxTransformer.resize(
      resizeMode: ResizeMode.symmetric,
      initialFlip: Flip.none,
      initialBox: Box.fromLTWH(129.39, 213.59, 500.00, 500.00),
      handle: HandlePosition.top,
      initialLocalPosition: Vector2(236.11, 8.22),
      allowBoxFlipping: true,
      localPosition: Vector2(241.74, 610.61),
      clampingRect: Box.fromLTWH(70.42, 87.23, 610.14, 784.32),
      constraints: Constraints(
          minWidth: 100.00,
          minHeight: 100.00,
          maxWidth: 500.00,
          maxHeight: 500.00),
    );

    expect(result.flip, Flip.vertical);
    expect(result.rect,
        withTolerance(Box.fromLTWH(129.39, 213.59, 500.00, 500.00)));
    expect(result.resizeMode, ResizeMode.symmetric);

    result = BoxTransformer.resize(
      resizeMode: ResizeMode.symmetric,
      initialFlip: Flip.vertical,
      initialBox: Box.fromLTWH(129.39, 213.59, 500.00, 500.00),
      handle: HandlePosition.bottom,
      initialLocalPosition: Vector2(240.48, 15.76),
      allowBoxFlipping: true,
      localPosition: Vector2(229.40, -650.23),
      clampingRect: Box.fromLTWH(70.42, 87.23, 610.14, 784.32),
      constraints: Constraints(
          minWidth: 100.00,
          minHeight: 100.00,
          maxWidth: 500.00,
          maxHeight: 500.00),
    );

    expect(result.flip, Flip.none);
    expect(result.rect,
        withTolerance(Box.fromLTWH(129.39, 213.59, 500.00, 500.00)));
    expect(result.resizeMode, ResizeMode.symmetric);

    result = BoxTransformer.resize(
      resizeMode: ResizeMode.symmetric,
      initialFlip: Flip.none,
      initialBox: Box.fromLTWH(129.39, 213.59, 500.00, 500.00),
      handle: HandlePosition.right,
      initialLocalPosition: Vector2(13.24, 234.55),
      allowBoxFlipping: true,
      localPosition: Vector2(-218.60, 244.59),
      clampingRect: Box.fromLTWH(70.42, 87.23, 610.14, 784.32),
      constraints: Constraints(
          minWidth: 100.00,
          minHeight: 100.00,
          maxWidth: 500.00,
          maxHeight: 500.00),
    );

    expect(result.flip, Flip.none);
    expect(result.rect,
        withTolerance(Box.fromLTWH(329.39, 213.59, 100.00, 500.00)));
    expect(result.resizeMode, ResizeMode.symmetric);

    result = BoxTransformer.resize(
      resizeMode: ResizeMode.symmetric,
      initialFlip: Flip.none,
      initialBox: Box.fromLTWH(329.39, 213.59, 100.00, 500.00),
      handle: HandlePosition.bottom,
      initialLocalPosition: Vector2(38.01, 13.56),
      allowBoxFlipping: true,
      localPosition: Vector2(29.11, -217.79),
      clampingRect: Box.fromLTWH(70.42, 87.23, 610.14, 784.32),
      constraints: Constraints(
          minWidth: 100.00,
          minHeight: 100.00,
          maxWidth: 500.00,
          maxHeight: 500.00),
    );

    expect(result.flip, Flip.none);
    expect(result.rect,
        withTolerance(Box.fromLTWH(329.39, 413.59, 100.00, 100.00)));
    expect(result.resizeMode, ResizeMode.symmetric);
  });
}
