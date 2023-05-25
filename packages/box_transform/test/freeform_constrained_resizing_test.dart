import 'package:test/test.dart';
import 'package:vector_math/vector_math.dart';
import 'package:box_transform/box_transform.dart';
import 'utils.dart';

void main() {
  test('Freeform constrained resizing with corner handles', () {
    var result = BoxTransformer.resize(
      resizeMode: ResizeMode.freeform,
      initialFlip: Flip.none,
      initialBox: Box.fromLTWH(150.43, 297.52, 457.52, 331.43),
      handle: HandlePosition.bottomRight,
      initialLocalPosition: Vector2(12.31, 12.76),
      flipRect: true,
      localPosition: Vector2(131.38, -52.01),
      clampingRect: Box.fromLTWH(88.62, 79.06, 592.66, 782.53),
      constraints: Constraints(
          minWidth: 100.00,
          minHeight: 100.00,
          maxWidth: 500.00,
          maxHeight: 500.00),
    );

    expect(result.flip, Flip.none);
    expect(result.rect,
        withTolerance(Box.fromLTWH(150.43, 297.52, 500.00, 266.66)));
    expect(result.resizeMode, ResizeMode.freeform);

    result = BoxTransformer.resize(
      resizeMode: ResizeMode.freeform,
      initialFlip: Flip.none,
      initialBox: Box.fromLTWH(150.43, 297.52, 500.00, 266.66),
      handle: HandlePosition.bottomRight,
      initialLocalPosition: Vector2(13.11, 13.69),
      flipRect: true,
      localPosition: Vector2(-143.01, 363.48),
      clampingRect: Box.fromLTWH(88.62, 79.06, 592.66, 782.53),
      constraints: Constraints(
          minWidth: 100.00,
          minHeight: 100.00,
          maxWidth: 500.00,
          maxHeight: 500.00),
    );

    expect(result.flip, Flip.none);
    expect(result.rect,
        withTolerance(Box.fromLTWH(150.43, 297.52, 343.88, 500.00)));
    expect(result.resizeMode, ResizeMode.freeform);

    result = BoxTransformer.resize(
      resizeMode: ResizeMode.freeform,
      initialFlip: Flip.none,
      initialBox: Box.fromLTWH(150.43, 297.52, 343.88, 500.00),
      handle: HandlePosition.bottomRight,
      initialLocalPosition: Vector2(14.03, 11.87),
      flipRect: true,
      localPosition: Vector2(245.73, 127.43),
      clampingRect: Box.fromLTWH(88.62, 79.06, 592.66, 782.53),
      constraints: Constraints(
          minWidth: 100.00,
          minHeight: 100.00,
          maxWidth: 500.00,
          maxHeight: 500.00),
    );

    expect(result.flip, Flip.none);
    expect(result.rect,
        withTolerance(Box.fromLTWH(150.43, 297.52, 500.00, 500.00)));
    expect(result.resizeMode, ResizeMode.freeform);

    result = BoxTransformer.resize(
      resizeMode: ResizeMode.freeform,
      initialFlip: Flip.none,
      initialBox: Box.fromLTWH(150.43, 297.52, 500.00, 500.00),
      handle: HandlePosition.bottomRight,
      initialLocalPosition: Vector2(12.61, 12.15),
      flipRect: true,
      localPosition: Vector2(-45.70, -452.54),
      clampingRect: Box.fromLTWH(88.62, 79.06, 592.66, 782.53),
      constraints: Constraints(
          minWidth: 100.00,
          minHeight: 100.00,
          maxWidth: 500.00,
          maxHeight: 500.00),
    );

    expect(result.flip, Flip.none);
    expect(result.rect,
        withTolerance(Box.fromLTWH(150.43, 297.52, 441.69, 100.00)));
    expect(result.resizeMode, ResizeMode.freeform);

    result = BoxTransformer.resize(
      resizeMode: ResizeMode.freeform,
      initialFlip: Flip.none,
      initialBox: Box.fromLTWH(150.43, 297.52, 441.69, 100.00),
      handle: HandlePosition.bottomRight,
      initialLocalPosition: Vector2(11.96, 13.45),
      flipRect: true,
      localPosition: Vector2(-338.23, 276.27),
      clampingRect: Box.fromLTWH(88.62, 79.06, 592.66, 782.53),
      constraints: Constraints(
          minWidth: 100.00,
          minHeight: 100.00,
          maxWidth: 500.00,
          maxHeight: 500.00),
    );

    expect(result.flip, Flip.none);
    expect(result.rect,
        withTolerance(Box.fromLTWH(150.43, 297.52, 100.00, 362.82)));
    expect(result.resizeMode, ResizeMode.freeform);

    result = BoxTransformer.resize(
      resizeMode: ResizeMode.freeform,
      initialFlip: Flip.none,
      initialBox: Box.fromLTWH(150.43, 297.52, 100.00, 362.82),
      handle: HandlePosition.bottomRight,
      initialLocalPosition: Vector2(14.56, 11.36),
      flipRect: true,
      localPosition: Vector2(-18.22, -280.23),
      clampingRect: Box.fromLTWH(88.62, 79.06, 592.66, 782.53),
      constraints: Constraints(
          minWidth: 100.00,
          minHeight: 100.00,
          maxWidth: 500.00,
          maxHeight: 500.00),
    );

    expect(result.flip, Flip.none);
    expect(result.rect,
        withTolerance(Box.fromLTWH(150.43, 297.52, 100.00, 100.00)));
    expect(result.resizeMode, ResizeMode.freeform);

    result = BoxTransformer.resize(
      resizeMode: ResizeMode.freeform,
      initialFlip: Flip.none,
      initialBox: Box.fromLTWH(150.43, 297.52, 100.00, 100.00),
      handle: HandlePosition.topRight,
      initialLocalPosition: Vector2(10.77, 9.25),
      flipRect: true,
      localPosition: Vector2(-61.82, 390.55),
      clampingRect: Box.fromLTWH(88.62, 79.06, 592.66, 782.53),
      constraints: Constraints(
          minWidth: 100.00,
          minHeight: 100.00,
          maxWidth: 500.00,
          maxHeight: 500.00),
    );

    expect(result.flip, Flip.vertical);
    expect(result.rect,
        withTolerance(Box.fromLTWH(150.43, 397.52, 100.00, 281.30)));
    expect(result.resizeMode, ResizeMode.freeform);

    result = BoxTransformer.resize(
      resizeMode: ResizeMode.freeform,
      initialFlip: Flip.vertical,
      initialBox: Box.fromLTWH(150.43, 397.52, 100.00, 281.30),
      handle: HandlePosition.topLeft,
      initialLocalPosition: Vector2(14.52, 11.78),
      flipRect: true,
      localPosition: Vector2(365.99, 450.73),
      clampingRect: Box.fromLTWH(88.62, 79.06, 592.66, 782.53),
      constraints: Constraints(
          minWidth: 100.00,
          minHeight: 100.00,
          maxWidth: 500.00,
          maxHeight: 500.00),
    );

    expect(result.flip, Flip.horizontal);
    expect(result.rect,
        withTolerance(Box.fromLTWH(250.43, 678.82, 251.47, 157.66)));
    expect(result.resizeMode, ResizeMode.freeform);

    result = BoxTransformer.resize(
      resizeMode: ResizeMode.freeform,
      initialFlip: Flip.horizontal,
      initialBox: Box.fromLTWH(250.43, 678.82, 251.47, 157.66),
      handle: HandlePosition.bottomRight,
      initialLocalPosition: Vector2(16.35, 11.54),
      flipRect: true,
      localPosition: Vector2(-285.39, -483.04),
      clampingRect: Box.fromLTWH(88.62, 79.06, 592.66, 782.53),
      constraints: Constraints(
          minWidth: 100.00,
          minHeight: 100.00,
          maxWidth: 500.00,
          maxHeight: 500.00),
    );

    expect(result.flip, Flip.vertical);
    expect(result.rect,
        withTolerance(Box.fromLTWH(150.43, 341.90, 100.00, 336.92)));
    expect(result.resizeMode, ResizeMode.freeform);

    result = BoxTransformer.resize(
      resizeMode: ResizeMode.freeform,
      initialFlip: Flip.vertical,
      initialBox: Box.fromLTWH(150.43, 341.90, 100.00, 336.92),
      handle: HandlePosition.bottomLeft,
      initialLocalPosition: Vector2(9.86, 15.74),
      flipRect: true,
      localPosition: Vector2(441.95, -548.59),
      clampingRect: Box.fromLTWH(88.62, 79.06, 592.66, 782.53),
      constraints: Constraints(
          minWidth: 100.00,
          minHeight: 100.00,
          maxWidth: 500.00,
          maxHeight: 500.00),
    );

    expect(result.flip, Flip.horizontal);
    expect(result.rect,
        withTolerance(Box.fromLTWH(250.43, 114.48, 332.09, 227.42)));
    expect(result.resizeMode, ResizeMode.freeform);

    result = BoxTransformer.resize(
      resizeMode: ResizeMode.freeform,
      initialFlip: Flip.horizontal,
      initialBox: Box.fromLTWH(119.59, 268.87, 332.09, 227.42),
      handle: HandlePosition.bottomRight,
      initialLocalPosition: Vector2(12.18, 9.49),
      flipRect: true,
      localPosition: Vector2(-418.89, -321.56),
      clampingRect: Box.fromLTWH(88.62, 79.06, 592.66, 782.53),
      constraints: Constraints(
          minWidth: 100.00,
          minHeight: 100.00,
          maxWidth: 500.00,
          maxHeight: 500.00),
    );

    expect(result.flip, Flip.vertical);
    expect(result.rect,
        withTolerance(Box.fromLTWH(119.59, 268.87, 100.00, 100.00)));
    expect(result.resizeMode, ResizeMode.freeform);

    result = BoxTransformer.resize(
      resizeMode: ResizeMode.freeform,
      initialFlip: Flip.vertical,
      initialBox: Box.fromLTWH(119.59, 268.87, 100.00, 100.00),
      handle: HandlePosition.topLeft,
      initialLocalPosition: Vector2(11.72, 13.88),
      flipRect: true,
      localPosition: Vector2(405.30, 347.98),
      clampingRect: Box.fromLTWH(88.62, 79.06, 592.66, 782.53),
      constraints: Constraints(
          minWidth: 100.00,
          minHeight: 100.00,
          maxWidth: 500.00,
          maxHeight: 500.00),
    );

    expect(result.flip, Flip.horizontal);
    expect(result.rect,
        withTolerance(Box.fromLTWH(219.59, 368.87, 293.59, 234.11)));
    expect(result.resizeMode, ResizeMode.freeform);

    result = BoxTransformer.resize(
      resizeMode: ResizeMode.freeform,
      initialFlip: Flip.horizontal,
      initialBox: Box.fromLTWH(219.59, 368.87, 293.59, 234.11),
      handle: HandlePosition.bottomRight,
      initialLocalPosition: Vector2(15.45, 9.83),
      flipRect: true,
      localPosition: Vector2(-340.80, -173.88),
      clampingRect: Box.fromLTWH(88.62, 79.06, 592.66, 782.53),
      constraints: Constraints(
          minWidth: 100.00,
          minHeight: 100.00,
          maxWidth: 500.00,
          maxHeight: 500.00),
    );

    expect(result.flip, Flip.none);
    expect(result.rect,
        withTolerance(Box.fromLTWH(119.59, 368.87, 100.00, 100.00)));
    expect(result.resizeMode, ResizeMode.freeform);

    result = BoxTransformer.resize(
      resizeMode: ResizeMode.freeform,
      initialFlip: Flip.none,
      initialBox: Box.fromLTWH(119.59, 368.87, 100.00, 100.00),
      handle: HandlePosition.topLeft,
      initialLocalPosition: Vector2(12.68, 12.66),
      flipRect: true,
      localPosition: Vector2(400.97, -90.68),
      clampingRect: Box.fromLTWH(88.62, 79.06, 592.66, 782.53),
      constraints: Constraints(
          minWidth: 100.00,
          minHeight: 100.00,
          maxWidth: 500.00,
          maxHeight: 500.00),
    );

    expect(result.flip, Flip.horizontal);
    expect(result.rect,
        withTolerance(Box.fromLTWH(219.59, 265.53, 288.29, 203.34)));
    expect(result.resizeMode, ResizeMode.freeform);
  });

  test('Freeform constrainted resizing with side handles', () {
    var result = BoxTransformer.resize(
      resizeMode: ResizeMode.freeform,
      initialFlip: Flip.none,
      initialBox: Box.fromLTWH(132.50, 307.95, 313.47, 203.34),
      handle: HandlePosition.right,
      initialLocalPosition: Vector2(13.15, 93.88),
      flipRect: true,
      localPosition: Vector2(297.18, 95.77),
      clampingRect: Box.fromLTWH(88.62, 79.06, 592.66, 782.53),
      constraints: Constraints(
          minWidth: 100.00,
          minHeight: 100.00,
          maxWidth: 500.00,
          maxHeight: 500.00),
    );

    expect(result.flip, Flip.none);
    expect(result.rect,
        withTolerance(Box.fromLTWH(132.50, 307.95, 500.00, 203.34)));
    expect(result.resizeMode, ResizeMode.freeform);

    result = BoxTransformer.resize(
      resizeMode: ResizeMode.freeform,
      initialFlip: Flip.none,
      initialBox: Box.fromLTWH(132.50, 307.95, 500.00, 203.34),
      handle: HandlePosition.right,
      initialLocalPosition: Vector2(14.79, 91.78),
      flipRect: true,
      localPosition: Vector2(-432.92, 90.16),
      clampingRect: Box.fromLTWH(88.62, 79.06, 592.66, 782.53),
      constraints: Constraints(
          minWidth: 100.00,
          minHeight: 100.00,
          maxWidth: 500.00,
          maxHeight: 500.00),
    );

    expect(result.flip, Flip.none);
    expect(result.rect,
        withTolerance(Box.fromLTWH(132.50, 307.95, 100.00, 203.34)));
    expect(result.resizeMode, ResizeMode.freeform);

    result = BoxTransformer.resize(
      resizeMode: ResizeMode.freeform,
      initialFlip: Flip.none,
      initialBox: Box.fromLTWH(132.50, 307.95, 100.00, 203.34),
      handle: HandlePosition.left,
      initialLocalPosition: Vector2(12.09, 92.46),
      flipRect: true,
      localPosition: Vector2(486.31, 86.16),
      clampingRect: Box.fromLTWH(88.62, 79.06, 592.66, 782.53),
      constraints: Constraints(
          minWidth: 100.00,
          minHeight: 100.00,
          maxWidth: 500.00,
          maxHeight: 500.00),
    );

    expect(result.flip, Flip.horizontal);
    expect(result.rect,
        withTolerance(Box.fromLTWH(232.50, 307.95, 374.22, 203.34)));
    expect(result.resizeMode, ResizeMode.freeform);

    result = BoxTransformer.resize(
      resizeMode: ResizeMode.freeform,
      initialFlip: Flip.none,
      initialBox: Box.fromLTWH(232.50, 307.95, 374.22, 203.34),
      handle: HandlePosition.top,
      initialLocalPosition: Vector2(182.83, 10.70),
      flipRect: true,
      localPosition: Vector2(169.91, 153.07),
      clampingRect: Box.fromLTWH(88.62, 79.06, 592.66, 782.53),
      constraints: Constraints(
          minWidth: 100.00,
          minHeight: 100.00,
          maxWidth: 500.00,
          maxHeight: 500.00),
    );

    expect(result.flip, Flip.none);
    expect(result.rect,
        withTolerance(Box.fromLTWH(232.50, 411.29, 374.22, 100.00)));
    expect(result.resizeMode, ResizeMode.freeform);

    result = BoxTransformer.resize(
      resizeMode: ResizeMode.freeform,
      initialFlip: Flip.none,
      initialBox: Box.fromLTWH(232.50, 411.29, 374.22, 100.00),
      handle: HandlePosition.bottom,
      initialLocalPosition: Vector2(169.66, 13.94),
      flipRect: true,
      localPosition: Vector2(157.40, -166.69),
      clampingRect: Box.fromLTWH(88.62, 79.06, 592.66, 782.53),
      constraints: Constraints(
          minWidth: 100.00,
          minHeight: 100.00,
          maxWidth: 500.00,
          maxHeight: 500.00),
    );

    expect(result.flip, Flip.vertical);
    expect(result.rect,
        withTolerance(Box.fromLTWH(232.50, 311.29, 374.22, 100.00)));
    expect(result.resizeMode, ResizeMode.freeform);

    result = BoxTransformer.resize(
      resizeMode: ResizeMode.freeform,
      initialFlip: Flip.none,
      initialBox: Box.fromLTWH(232.50, 311.29, 374.22, 100.00),
      handle: HandlePosition.bottom,
      initialLocalPosition: Vector2(181.15, 13.81),
      flipRect: true,
      localPosition: Vector2(168.57, 492.88),
      clampingRect: Box.fromLTWH(88.62, 79.06, 592.66, 782.53),
      constraints: Constraints(
          minWidth: 100.00,
          minHeight: 100.00,
          maxWidth: 500.00,
          maxHeight: 500.00),
    );

    expect(result.flip, Flip.none);
    expect(result.rect,
        withTolerance(Box.fromLTWH(232.50, 311.29, 374.22, 500.00)));
    expect(result.resizeMode, ResizeMode.freeform);

    result = BoxTransformer.resize(
      resizeMode: ResizeMode.freeform,
      initialFlip: Flip.none,
      initialBox: Box.fromLTWH(136.68, 295.09, 374.22, 500.00),
      handle: HandlePosition.right,
      initialLocalPosition: Vector2(11.80, 240.04),
      flipRect: true,
      localPosition: Vector2(-461.75, 249.55),
      clampingRect: Box.fromLTWH(88.62, 79.06, 592.66, 782.53),
      constraints: Constraints(
          minWidth: 100.00,
          minHeight: 100.00,
          maxWidth: 500.00,
          maxHeight: 500.00),
    );

    expect(result.flip, Flip.horizontal);
    expect(result.rect,
        withTolerance(Box.fromLTWH(136.68, 295.09, 100.00, 500.00)));
    expect(result.resizeMode, ResizeMode.freeform);

    result = BoxTransformer.resize(
      resizeMode: ResizeMode.freeform,
      initialFlip: Flip.horizontal,
      initialBox: Box.fromLTWH(136.68, 295.09, 100.00, 500.00),
      handle: HandlePosition.left,
      initialLocalPosition: Vector2(9.52, 240.84),
      flipRect: true,
      localPosition: Vector2(479.64, 234.45),
      clampingRect: Box.fromLTWH(88.62, 79.06, 592.66, 782.53),
      constraints: Constraints(
          minWidth: 100.00,
          minHeight: 100.00,
          maxWidth: 500.00,
          maxHeight: 500.00),
    );

    expect(result.flip, Flip.none);
    expect(result.rect,
        withTolerance(Box.fromLTWH(236.68, 295.09, 370.13, 500.00)));
    expect(result.resizeMode, ResizeMode.freeform);

    result = BoxTransformer.resize(
      resizeMode: ResizeMode.freeform,
      initialFlip: Flip.none,
      initialBox: Box.fromLTWH(236.68, 295.09, 370.13, 500.00),
      handle: HandlePosition.left,
      initialLocalPosition: Vector2(11.91, 241.91),
      flipRect: true,
      localPosition: Vector2(506.47, 234.78),
      clampingRect: Box.fromLTWH(88.62, 79.06, 592.66, 782.53),
      constraints: Constraints(
          minWidth: 100.00,
          minHeight: 100.00,
          maxWidth: 500.00,
          maxHeight: 500.00),
    );

    expect(result.flip, Flip.horizontal);
    expect(result.rect,
        withTolerance(Box.fromLTWH(506.80, 295.09, 100.00, 500.00)));
    expect(result.resizeMode, ResizeMode.freeform);

    result = BoxTransformer.resize(
      resizeMode: ResizeMode.freeform,
      initialFlip: Flip.horizontal,
      initialBox: Box.fromLTWH(506.80, 295.09, 100.00, 500.00),
      handle: HandlePosition.bottom,
      initialLocalPosition: Vector2(38.08, 15.07),
      flipRect: true,
      localPosition: Vector2(38.16, -438.99),
      clampingRect: Box.fromLTWH(88.62, 79.06, 592.66, 782.53),
      constraints: Constraints(
          minWidth: 100.00,
          minHeight: 100.00,
          maxWidth: 500.00,
          maxHeight: 500.00),
    );

    expect(result.flip, Flip.horizontal);
    expect(result.rect,
        withTolerance(Box.fromLTWH(506.80, 295.09, 100.00, 100.00)));
    expect(result.resizeMode, ResizeMode.freeform);
  });
}
