import 'package:test/test.dart';
import 'package:vector_math/vector_math.dart';
import 'package:box_transform/box_transform.dart';
import 'utils.dart';

void main() {
  test('Scaled resizing with bottom right handle', () {
    var result = BoxTransformer.resize(
      resizeMode: ResizeMode.scale,
      initialFlip: Flip.none,
      initialRect: Box.fromLTWH(201.37, 379.05, 321.96, 191.97),
      handle: HandlePosition.bottomRight,
      initialLocalPosition: Vector2(12.39, 13.23),
      allowFlipping: true,
      localPosition: Vector2(153.75, 87.34),
    );

    expect(result.flip, Flip.none);
    expect(result.rect,
        withTolerance(Box.fromLTWH(201.37, 379.05, 463.32, 276.25)));
    expect(result.resizeMode, ResizeMode.scale);

    result = BoxTransformer.resize(
      resizeMode: ResizeMode.scale,
      initialFlip: Flip.none,
      initialRect: Box.fromLTWH(201.37, 379.05, 463.32, 276.25),
      handle: HandlePosition.bottomRight,
      initialLocalPosition: Vector2(12.86, 13.14),
      allowFlipping: true,
      localPosition: Vector2(-244.73, -161.30),
    );

    expect(result.flip, Flip.none);
    expect(result.rect,
        withTolerance(Box.fromLTWH(201.37, 379.05, 205.73, 122.67)));
    expect(result.resizeMode, ResizeMode.scale);

    result = BoxTransformer.resize(
      resizeMode: ResizeMode.scale,
      initialFlip: Flip.none,
      initialRect: Box.fromLTWH(201.37, 379.05, 205.73, 122.67),
      handle: HandlePosition.bottomRight,
      initialLocalPosition: Vector2(13.20, 14.07),
      allowFlipping: true,
      localPosition: Vector2(-341.86, -196.89),
    );

    expect(result.flip, Flip.diagonal);
    expect(
        result.rect, withTolerance(Box.fromLTWH(52.05, 290.01, 149.32, 89.03)));
    expect(result.resizeMode, ResizeMode.scale);

    result = BoxTransformer.resize(
      resizeMode: ResizeMode.scale,
      initialFlip: Flip.diagonal,
      initialRect: Box.fromLTWH(52.05, 290.01, 149.32, 89.03),
      handle: HandlePosition.topLeft,
      initialLocalPosition: Vector2(12.72, 14.58),
      allowFlipping: true,
      localPosition: Vector2(627.89, -177.33),
    );

    expect(result.flip, Flip.vertical);
    expect(result.rect,
        withTolerance(Box.fromLTWH(201.37, 98.10, 471.19, 280.94)));
    expect(result.resizeMode, ResizeMode.scale);

    result = BoxTransformer.resize(
      resizeMode: ResizeMode.scale,
      initialFlip: Flip.vertical,
      initialRect: Box.fromLTWH(201.37, 98.10, 471.19, 280.94),
      handle: HandlePosition.topRight,
      initialLocalPosition: Vector2(13.70, 13.62),
      allowFlipping: true,
      localPosition: Vector2(-645.52, 397.26),
    );

    expect(result.flip, Flip.horizontal);
    expect(result.rect,
        withTolerance(Box.fromLTWH(13.34, 379.05, 188.03, 112.11)));
    expect(result.resizeMode, ResizeMode.scale);

    result = BoxTransformer.resize(
      resizeMode: ResizeMode.scale,
      initialFlip: Flip.horizontal,
      initialRect: Box.fromLTWH(13.34, 379.05, 188.03, 112.11),
      handle: HandlePosition.bottomLeft,
      initialLocalPosition: Vector2(11.32, 11.93),
      allowFlipping: true,
      localPosition: Vector2(392.20, 62.39),
    );

    expect(result.flip, Flip.none);
    expect(result.rect,
        withTolerance(Box.fromLTWH(201.37, 379.05, 272.65, 162.57)));
    expect(result.resizeMode, ResizeMode.scale);

    result = BoxTransformer.resize(
      resizeMode: ResizeMode.scale,
      initialFlip: Flip.none,
      initialRect: Box.fromLTWH(201.37, 379.05, 272.65, 162.57),
      handle: HandlePosition.bottomRight,
      initialLocalPosition: Vector2(16.83, 15.96),
      allowFlipping: true,
      localPosition: Vector2(144.18, -38.35),
    );

    expect(result.flip, Flip.none);
    expect(result.rect,
        withTolerance(Box.fromLTWH(201.37, 379.05, 400.00, 238.50)));
    expect(result.resizeMode, ResizeMode.scale);

    result = BoxTransformer.resize(
      resizeMode: ResizeMode.scale,
      initialFlip: Flip.none,
      initialRect: Box.fromLTWH(201.37, 379.05, 400.00, 238.50),
      handle: HandlePosition.bottomRight,
      initialLocalPosition: Vector2(13.75, 9.08),
      allowFlipping: true,
      localPosition: Vector2(-269.03, -294.69),
    );

    expect(result.flip, Flip.vertical);
    expect(result.rect,
        withTolerance(Box.fromLTWH(201.37, 309.16, 117.21, 69.89)));
    expect(result.resizeMode, ResizeMode.scale);

    result = BoxTransformer.resize(
      resizeMode: ResizeMode.scale,
      initialFlip: Flip.vertical,
      initialRect: Box.fromLTWH(201.37, 309.16, 117.21, 69.89),
      handle: HandlePosition.topRight,
      initialLocalPosition: Vector2(13.99, 11.29),
      allowFlipping: true,
      localPosition: Vector2(190.26, 259.14),
    );

    expect(result.flip, Flip.none);
    expect(result.rect,
        withTolerance(Box.fromLTWH(201.37, 379.05, 298.47, 177.96)));
    expect(result.resizeMode, ResizeMode.scale);
  });

  test('Scaled resizing with top-left handle', () {
    var result = BoxTransformer.resize(
      resizeMode: ResizeMode.scale,
      initialFlip: Flip.none,
      initialRect: Box.fromLTWH(244.96, 365.46, 248.19, 192.53),
      handle: HandlePosition.topLeft,
      initialLocalPosition: Vector2(13.91, 12.04),
      allowFlipping: true,
      localPosition: Vector2(-158.30, -115.53),
    );

    expect(result.flip, Flip.none);
    expect(result.rect,
        withTolerance(Box.fromLTWH(72.75, 231.87, 420.40, 326.12)));
    expect(result.resizeMode, ResizeMode.scale);

    result = BoxTransformer.resize(
      resizeMode: ResizeMode.scale,
      initialFlip: Flip.none,
      initialRect: Box.fromLTWH(72.75, 231.87, 420.40, 326.12),
      handle: HandlePosition.topLeft,
      initialLocalPosition: Vector2(11.05, 13.78),
      allowFlipping: true,
      localPosition: Vector2(300.30, 239.62),
    );

    expect(result.flip, Flip.none);
    expect(result.rect,
        withTolerance(Box.fromLTWH(361.99, 456.25, 131.15, 101.74)));
    expect(result.resizeMode, ResizeMode.scale);

    result = BoxTransformer.resize(
      resizeMode: ResizeMode.scale,
      initialFlip: Flip.none,
      initialRect: Box.fromLTWH(361.99, 456.25, 131.15, 101.74),
      handle: HandlePosition.topLeft,
      initialLocalPosition: Vector2(11.29, 11.43),
      allowFlipping: true,
      localPosition: Vector2(253.29, 202.90),
    );

    expect(result.flip, Flip.diagonal);
    expect(result.rect,
        withTolerance(Box.fromLTWH(493.14, 558.00, 115.67, 89.73)));
    expect(result.resizeMode, ResizeMode.scale);

    result = BoxTransformer.resize(
      resizeMode: ResizeMode.scale,
      initialFlip: Flip.diagonal,
      initialRect: Box.fromLTWH(493.14, 558.00, 115.67, 89.73),
      handle: HandlePosition.bottomRight,
      initialLocalPosition: Vector2(11.15, 11.19),
      allowFlipping: true,
      localPosition: Vector2(93.74, 70.19),
    );

    expect(result.flip, Flip.diagonal);
    expect(result.rect,
        withTolerance(Box.fromLTWH(493.14, 558.00, 198.26, 153.80)));
    expect(result.resizeMode, ResizeMode.scale);

    result = BoxTransformer.resize(
      resizeMode: ResizeMode.scale,
      initialFlip: Flip.diagonal,
      initialRect: Box.fromLTWH(493.14, 558.00, 198.26, 153.80),
      handle: HandlePosition.bottomRight,
      initialLocalPosition: Vector2(14.90, 13.15),
      allowFlipping: true,
      localPosition: Vector2(-541.07, 52.39),
    );

    expect(result.flip, Flip.vertical);
    expect(result.rect,
        withTolerance(Box.fromLTWH(135.44, 558.00, 357.71, 277.49)));
    expect(result.resizeMode, ResizeMode.scale);

    result = BoxTransformer.resize(
      resizeMode: ResizeMode.scale,
      initialFlip: Flip.vertical,
      initialRect: Box.fromLTWH(135.44, 558.00, 357.71, 277.49),
      handle: HandlePosition.bottomLeft,
      initialLocalPosition: Vector2(11.13, 14.28),
      allowFlipping: true,
      localPosition: Vector2(270.56, -186.98),
    );

    expect(result.flip, Flip.vertical);
    expect(
        result.rect, withTolerance(Box.fromLTWH(394.87, 558.00, 98.27, 76.23)));
    expect(result.resizeMode, ResizeMode.scale);

    result = BoxTransformer.resize(
      resizeMode: ResizeMode.scale,
      initialFlip: Flip.vertical,
      initialRect: Box.fromLTWH(394.87, 558.00, 98.27, 76.23),
      handle: HandlePosition.bottomLeft,
      initialLocalPosition: Vector2(12.07, 11.90),
      allowFlipping: true,
      localPosition: Vector2(249.13, -167.48),
    );

    expect(result.flip, Flip.horizontal);
    expect(result.rect,
        withTolerance(Box.fromLTWH(493.14, 450.33, 138.79, 107.67)));
    expect(result.resizeMode, ResizeMode.scale);

    result = BoxTransformer.resize(
      resizeMode: ResizeMode.scale,
      initialFlip: Flip.horizontal,
      initialRect: Box.fromLTWH(493.14, 450.33, 138.79, 107.67),
      handle: HandlePosition.topRight,
      initialLocalPosition: Vector2(11.83, 16.18),
      allowFlipping: true,
      localPosition: Vector2(86.07, -44.28),
    );

    expect(result.flip, Flip.horizontal);
    expect(result.rect,
        withTolerance(Box.fromLTWH(493.14, 389.87, 216.72, 168.13)));
    expect(result.resizeMode, ResizeMode.scale);

    result = BoxTransformer.resize(
      resizeMode: ResizeMode.scale,
      initialFlip: Flip.horizontal,
      initialRect: Box.fromLTWH(493.14, 389.87, 216.72, 168.13),
      handle: HandlePosition.topRight,
      initialLocalPosition: Vector2(11.88, 13.56),
      allowFlipping: true,
      localPosition: Vector2(-584.57, -114.09),
    );

    expect(result.flip, Flip.none);
    expect(result.rect,
        withTolerance(Box.fromLTWH(111.86, 262.22, 381.28, 295.78)));
    expect(result.resizeMode, ResizeMode.scale);

    result = BoxTransformer.resize(
      resizeMode: ResizeMode.scale,
      initialFlip: Flip.none,
      initialRect: Box.fromLTWH(111.86, 262.22, 381.28, 295.78),
      handle: HandlePosition.topLeft,
      initialLocalPosition: Vector2(12.21, 15.82),
      allowFlipping: true,
      localPosition: Vector2(153.78, 182.39),
    );

    expect(result.flip, Flip.none);
    expect(result.rect,
        withTolerance(Box.fromLTWH(253.43, 372.04, 239.71, 185.95)));
    expect(result.resizeMode, ResizeMode.scale);
  });

  test('Scaled resizing with top-right handle', () {
    var result = BoxTransformer.resize(
      resizeMode: ResizeMode.scale,
      initialFlip: Flip.none,
      initialRect: Box.fromLTWH(253.43, 372.04, 239.71, 185.95),
      handle: HandlePosition.topRight,
      initialLocalPosition: Vector2(15.34, 15.06),
      allowFlipping: true,
      localPosition: Vector2(-95.67, 106.87),
    );

    expect(result.flip, Flip.none);
    expect(result.rect,
        withTolerance(Box.fromLTWH(253.43, 458.16, 128.70, 99.84)));
    expect(result.resizeMode, ResizeMode.scale);

    result = BoxTransformer.resize(
      resizeMode: ResizeMode.scale,
      initialFlip: Flip.none,
      initialRect: Box.fromLTWH(253.43, 458.16, 128.70, 99.84),
      handle: HandlePosition.topRight,
      initialLocalPosition: Vector2(14.86, 15.52),
      allowFlipping: true,
      localPosition: Vector2(254.53, -173.03),
    );

    expect(result.flip, Flip.none);
    expect(result.rect,
        withTolerance(Box.fromLTWH(253.43, 269.61, 371.75, 288.39)));
    expect(result.resizeMode, ResizeMode.scale);

    result = BoxTransformer.resize(
      resizeMode: ResizeMode.scale,
      initialFlip: Flip.none,
      initialRect: Box.fromLTWH(253.43, 269.61, 371.75, 288.39),
      handle: HandlePosition.topRight,
      initialLocalPosition: Vector2(14.76, 12.89),
      allowFlipping: true,
      localPosition: Vector2(-459.75, 233.17),
    );

    expect(result.flip, Flip.horizontal);
    expect(result.rect,
        withTolerance(Box.fromLTWH(150.67, 478.27, 102.77, 79.72)));
    expect(result.resizeMode, ResizeMode.scale);

    result = BoxTransformer.resize(
      resizeMode: ResizeMode.scale,
      initialFlip: Flip.horizontal,
      initialRect: Box.fromLTWH(150.67, 478.27, 102.77, 79.72),
      handle: HandlePosition.topLeft,
      initialLocalPosition: Vector2(10.47, 12.12),
      allowFlipping: true,
      localPosition: Vector2(-120.71, -84.63),
    );

    expect(result.flip, Flip.horizontal);
    expect(result.rect,
        withTolerance(Box.fromLTWH(19.49, 376.51, 233.95, 181.48)));
    expect(result.resizeMode, ResizeMode.scale);

    result = BoxTransformer.resize(
      resizeMode: ResizeMode.scale,
      initialFlip: Flip.horizontal,
      initialRect: Box.fromLTWH(19.49, 376.51, 233.95, 181.48),
      handle: HandlePosition.topLeft,
      initialLocalPosition: Vector2(10.71, 14.27),
      allowFlipping: true,
      localPosition: Vector2(14.96, 374.38),
    );

    expect(result.flip, Flip.diagonal);
    expect(result.rect,
        withTolerance(Box.fromLTWH(23.17, 558.00, 230.26, 178.63)));
    expect(result.resizeMode, ResizeMode.scale);

    result = BoxTransformer.resize(
      resizeMode: ResizeMode.scale,
      initialFlip: Flip.diagonal,
      initialRect: Box.fromLTWH(23.17, 558.00, 230.26, 178.63),
      handle: HandlePosition.bottomLeft,
      initialLocalPosition: Vector2(11.82, 11.92),
      allowFlipping: true,
      localPosition: Vector2(163.48, -94.05),
    );

    expect(result.flip, Flip.diagonal);
    expect(
        result.rect, withTolerance(Box.fromLTWH(159.78, 558.00, 93.66, 72.66)));
    expect(result.resizeMode, ResizeMode.scale);

    result = BoxTransformer.resize(
      resizeMode: ResizeMode.scale,
      initialFlip: Flip.diagonal,
      initialRect: Box.fromLTWH(159.78, 558.00, 93.66, 72.66),
      handle: HandlePosition.bottomLeft,
      initialLocalPosition: Vector2(13.06, 12.53),
      allowFlipping: true,
      localPosition: Vector2(505.85, 240.73),
    );

    expect(result.flip, Flip.vertical);
    expect(result.rect,
        withTolerance(Box.fromLTWH(253.43, 558.00, 399.13, 309.63)));
    expect(result.resizeMode, ResizeMode.scale);

    result = BoxTransformer.resize(
      resizeMode: ResizeMode.scale,
      initialFlip: Flip.vertical,
      initialRect: Box.fromLTWH(253.43, 558.00, 399.13, 309.63),
      handle: HandlePosition.bottomRight,
      initialLocalPosition: Vector2(12.81, 8.21),
      allowFlipping: true,
      localPosition: Vector2(-199.65, -231.76),
    );

    expect(result.flip, Flip.vertical);
    expect(result.rect,
        withTolerance(Box.fromLTWH(253.43, 558.00, 186.67, 144.81)));
    expect(result.resizeMode, ResizeMode.scale);

    result = BoxTransformer.resize(
      resizeMode: ResizeMode.scale,
      initialFlip: Flip.vertical,
      initialRect: Box.fromLTWH(253.43, 558.00, 186.67, 144.81),
      handle: HandlePosition.bottomRight,
      initialLocalPosition: Vector2(13.77, 14.75),
      allowFlipping: true,
      localPosition: Vector2(-43.29, -228.21),
    );

    expect(result.flip, Flip.none);
    expect(result.rect,
        withTolerance(Box.fromLTWH(253.43, 457.45, 129.61, 100.55)));
    expect(result.resizeMode, ResizeMode.scale);

    result = BoxTransformer.resize(
      resizeMode: ResizeMode.scale,
      initialFlip: Flip.none,
      initialRect: Box.fromLTWH(253.43, 457.45, 129.61, 100.55),
      handle: HandlePosition.topRight,
      initialLocalPosition: Vector2(14.71, 14.28),
      allowFlipping: true,
      localPosition: Vector2(140.03, -60.20),
    );

    expect(result.flip, Flip.none);
    expect(result.rect,
        withTolerance(Box.fromLTWH(253.43, 360.23, 254.93, 197.77)));
    expect(result.resizeMode, ResizeMode.scale);
  });

  test('Scaled resizing with bottom-left handle', () {
    var result = BoxTransformer.resize(
      resizeMode: ResizeMode.scale,
      initialFlip: Flip.none,
      initialRect: Box.fromLTWH(253.43, 360.23, 254.93, 197.77),
      handle: HandlePosition.bottomLeft,
      initialLocalPosition: Vector2(12.28, 10.66),
      allowFlipping: true,
      localPosition: Vector2(-181.67, 162.12),
    );

    expect(result.flip, Flip.none);
    expect(result.rect,
        withTolerance(Box.fromLTWH(58.19, 360.23, 450.18, 349.23)));
    expect(result.resizeMode, ResizeMode.scale);

    result = BoxTransformer.resize(
      resizeMode: ResizeMode.scale,
      initialFlip: Flip.none,
      initialRect: Box.fromLTWH(58.19, 360.23, 450.18, 349.23),
      handle: HandlePosition.bottomLeft,
      initialLocalPosition: Vector2(11.18, 12.95),
      allowFlipping: true,
      localPosition: Vector2(247.19, -170.27),
    );

    expect(result.flip, Flip.none);
    expect(result.rect,
        withTolerance(Box.fromLTWH(294.20, 360.23, 214.17, 166.14)));
    expect(result.resizeMode, ResizeMode.scale);

    result = BoxTransformer.resize(
      resizeMode: ResizeMode.scale,
      initialFlip: Flip.none,
      initialRect: Box.fromLTWH(294.20, 360.23, 214.17, 166.14),
      handle: HandlePosition.bottomLeft,
      initialLocalPosition: Vector2(13.76, 11.14),
      allowFlipping: true,
      localPosition: Vector2(330.04, -220.01),
    );

    expect(result.flip, Flip.diagonal);
    expect(result.rect,
        withTolerance(Box.fromLTWH(508.37, 281.02, 102.11, 79.21)));
    expect(result.resizeMode, ResizeMode.scale);

    result = BoxTransformer.resize(
      resizeMode: ResizeMode.scale,
      initialFlip: Flip.diagonal,
      initialRect: Box.fromLTWH(508.37, 281.02, 102.11, 79.21),
      handle: HandlePosition.topRight,
      initialLocalPosition: Vector2(15.87, 17.00),
      allowFlipping: true,
      localPosition: Vector2(75.00, -56.98),
    );

    expect(result.flip, Flip.diagonal);
    expect(result.rect,
        withTolerance(Box.fromLTWH(508.37, 207.03, 197.48, 153.20)));
    expect(result.resizeMode, ResizeMode.scale);

    result = BoxTransformer.resize(
      resizeMode: ResizeMode.scale,
      initialFlip: Flip.diagonal,
      initialRect: Box.fromLTWH(508.37, 207.03, 197.48, 153.20),
      handle: HandlePosition.topRight,
      initialLocalPosition: Vector2(13.34, 10.95),
      allowFlipping: true,
      localPosition: Vector2(-353.66, 44.14),
    );

    expect(result.flip, Flip.vertical);
    expect(result.rect,
        withTolerance(Box.fromLTWH(338.85, 228.72, 169.52, 131.51)));
    expect(result.resizeMode, ResizeMode.scale);

    result = BoxTransformer.resize(
      resizeMode: ResizeMode.scale,
      initialFlip: Flip.vertical,
      initialRect: Box.fromLTWH(338.85, 228.72, 169.52, 131.51),
      handle: HandlePosition.topLeft,
      initialLocalPosition: Vector2(11.67, 14.11),
      allowFlipping: true,
      localPosition: Vector2(-237.15, -175.87),
    );

    expect(result.flip, Flip.vertical);
    expect(
        result.rect, withTolerance(Box.fromLTWH(90.03, 35.70, 418.34, 324.53)));
    expect(result.resizeMode, ResizeMode.scale);

    result = BoxTransformer.resize(
      resizeMode: ResizeMode.scale,
      initialFlip: Flip.vertical,
      initialRect: Box.fromLTWH(90.03, 35.70, 418.34, 324.53),
      handle: HandlePosition.topLeft,
      initialLocalPosition: Vector2(11.91, 14.30),
      allowFlipping: true,
      localPosition: Vector2(542.32, 440.81),
    );

    expect(result.flip, Flip.horizontal);
    expect(result.rect,
        withTolerance(Box.fromLTWH(508.37, 360.23, 131.46, 101.98)));
    expect(result.resizeMode, ResizeMode.scale);

    result = BoxTransformer.resize(
      resizeMode: ResizeMode.scale,
      initialFlip: Flip.horizontal,
      initialRect: Box.fromLTWH(508.37, 360.23, 131.46, 101.98),
      handle: HandlePosition.bottomRight,
      initialLocalPosition: Vector2(15.72, 12.61),
      allowFlipping: true,
      localPosition: Vector2(68.92, 39.36),
    );

    expect(result.flip, Flip.horizontal);
    expect(result.rect,
        withTolerance(Box.fromLTWH(508.37, 360.23, 184.67, 143.25)));
    expect(result.resizeMode, ResizeMode.scale);

    result = BoxTransformer.resize(
      resizeMode: ResizeMode.scale,
      initialFlip: Flip.horizontal,
      initialRect: Box.fromLTWH(508.37, 360.23, 184.67, 143.25),
      handle: HandlePosition.bottomRight,
      initialLocalPosition: Vector2(14.52, 10.74),
      allowFlipping: true,
      localPosition: Vector2(-602.81, 70.34),
    );

    expect(result.flip, Flip.none);
    expect(result.rect,
        withTolerance(Box.fromLTWH(75.71, 360.23, 432.66, 335.64)));
    expect(result.resizeMode, ResizeMode.scale);

    result = BoxTransformer.resize(
      resizeMode: ResizeMode.scale,
      initialFlip: Flip.none,
      initialRect: Box.fromLTWH(75.71, 360.23, 432.66, 335.64),
      handle: HandlePosition.bottomLeft,
      initialLocalPosition: Vector2(9.44, 14.40),
      allowFlipping: true,
      localPosition: Vector2(313.89, -146.61),
    );

    expect(result.flip, Flip.none);
    expect(result.rect,
        withTolerance(Box.fromLTWH(283.25, 360.23, 225.12, 174.64)));
    expect(result.resizeMode, ResizeMode.scale);
  });

  test('Scaled resizing with right handle', () {
    var result = BoxTransformer.resize(
      resizeMode: ResizeMode.scale,
      initialFlip: Flip.none,
      initialRect: Box.fromLTWH(283.25, 360.23, 225.12, 174.64),
      handle: HandlePosition.right,
      initialLocalPosition: Vector2(12.55, 80.94),
      allowFlipping: true,
      localPosition: Vector2(184.70, 70.22),
    );

    expect(result.flip, Flip.none);
    expect(result.rect,
        withTolerance(Box.fromLTWH(283.25, 293.45, 397.27, 308.19)));
    expect(result.resizeMode, ResizeMode.scale);

    result = BoxTransformer.resize(
      resizeMode: ResizeMode.scale,
      initialFlip: Flip.none,
      initialRect: Box.fromLTWH(283.25, 293.45, 397.27, 308.19),
      handle: HandlePosition.right,
      initialLocalPosition: Vector2(11.36, 142.15),
      allowFlipping: true,
      localPosition: Vector2(-239.24, 156.17),
    );

    expect(result.flip, Flip.none);
    expect(result.rect,
        withTolerance(Box.fromLTWH(283.25, 390.65, 146.68, 113.78)));
    expect(result.resizeMode, ResizeMode.scale);

    result = BoxTransformer.resize(
      resizeMode: ResizeMode.scale,
      initialFlip: Flip.none,
      initialRect: Box.fromLTWH(283.25, 390.65, 146.68, 113.78),
      handle: HandlePosition.right,
      initialLocalPosition: Vector2(14.87, 53.01),
      allowFlipping: true,
      localPosition: Vector2(-275.64, 51.99),
    );

    expect(result.flip, Flip.horizontal);
    expect(result.rect,
        withTolerance(Box.fromLTWH(139.41, 391.76, 143.84, 111.58)));
    expect(result.resizeMode, ResizeMode.scale);

    result = BoxTransformer.resize(
      resizeMode: ResizeMode.scale,
      initialFlip: Flip.horizontal,
      initialRect: Box.fromLTWH(139.41, 391.76, 143.84, 111.58),
      handle: HandlePosition.left,
      initialLocalPosition: Vector2(11.53, 47.08),
      allowFlipping: true,
      localPosition: Vector2(-118.32, 43.82),
    );

    expect(result.flip, Flip.horizontal);
    expect(
        result.rect, withTolerance(Box.fromLTWH(9.56, 341.39, 273.69, 212.32)));
    expect(result.resizeMode, ResizeMode.scale);

    result = BoxTransformer.resize(
      resizeMode: ResizeMode.scale,
      initialFlip: Flip.horizontal,
      initialRect: Box.fromLTWH(9.56, 341.39, 273.69, 212.32),
      handle: HandlePosition.left,
      initialLocalPosition: Vector2(11.53, 94.18),
      allowFlipping: true,
      localPosition: Vector2(370.97, 95.63),
    );

    expect(result.flip, Flip.none);
    expect(
        result.rect, withTolerance(Box.fromLTWH(283.25, 414.29, 85.74, 66.52)));
    expect(result.resizeMode, ResizeMode.scale);

    result = BoxTransformer.resize(
      resizeMode: ResizeMode.scale,
      initialFlip: Flip.none,
      initialRect: Box.fromLTWH(283.25, 414.29, 85.74, 66.52),
      handle: HandlePosition.right,
      initialLocalPosition: Vector2(11.53, 22.73),
      allowFlipping: true,
      localPosition: Vector2(245.83, 21.33),
    );

    expect(result.flip, Flip.none);
    expect(result.rect,
        withTolerance(Box.fromLTWH(283.25, 323.41, 320.04, 248.27)));
    expect(result.resizeMode, ResizeMode.scale);

    result = BoxTransformer.resize(
      resizeMode: ResizeMode.scale,
      initialFlip: Flip.none,
      initialRect: Box.fromLTWH(283.25, 323.41, 320.04, 248.27),
      handle: HandlePosition.right,
      initialLocalPosition: Vector2(13.64, 114.56),
      allowFlipping: true,
      localPosition: Vector2(-9.39, -136.52),
    );

    expect(result.flip, Flip.vertical);
    expect(result.rect,
        withTolerance(Box.fromLTWH(283.25, 332.34, 297.01, 230.41)));
    expect(result.resizeMode, ResizeMode.scale);

    result = BoxTransformer.resize(
      resizeMode: ResizeMode.scale,
      initialFlip: Flip.vertical,
      initialRect: Box.fromLTWH(283.25, 332.34, 297.01, 230.41),
      handle: HandlePosition.right,
      initialLocalPosition: Vector2(13.73, 112.48),
      allowFlipping: true,
      localPosition: Vector2(-83.34, -121.55),
    );

    expect(result.flip, Flip.none);
    expect(result.rect,
        withTolerance(Box.fromLTWH(283.25, 370.00, 199.94, 155.10)));
    expect(result.resizeMode, ResizeMode.scale);
  });

  test('Scaled resizing with left handle', () {
    var result = BoxTransformer.resize(
      resizeMode: ResizeMode.scale,
      initialFlip: Flip.none,
      initialRect: Box.fromLTWH(283.25, 370.00, 199.94, 155.10),
      handle: HandlePosition.left,
      initialLocalPosition: Vector2(15.24, 68.28),
      allowFlipping: true,
      localPosition: Vector2(-218.24, 64.69),
    );

    expect(result.flip, Flip.none);
    expect(result.rect,
        withTolerance(Box.fromLTWH(49.77, 279.43, 433.42, 336.23)));
    expect(result.resizeMode, ResizeMode.scale);

    result = BoxTransformer.resize(
      resizeMode: ResizeMode.scale,
      initialFlip: Flip.none,
      initialRect: Box.fromLTWH(49.77, 279.43, 433.42, 336.23),
      handle: HandlePosition.left,
      initialLocalPosition: Vector2(10.67, 160.17),
      allowFlipping: true,
      localPosition: Vector2(238.86, 152.39),
    );

    expect(result.flip, Flip.none);
    expect(result.rect,
        withTolerance(Box.fromLTWH(277.97, 367.95, 205.22, 159.20)));
    expect(result.resizeMode, ResizeMode.scale);

    result = BoxTransformer.resize(
      resizeMode: ResizeMode.scale,
      initialFlip: Flip.none,
      initialRect: Box.fromLTWH(277.97, 367.95, 205.22, 159.20),
      handle: HandlePosition.left,
      initialLocalPosition: Vector2(9.47, 69.97),
      allowFlipping: true,
      localPosition: Vector2(308.09, 58.95),
    );

    expect(result.flip, Flip.horizontal);
    expect(
        result.rect, withTolerance(Box.fromLTWH(483.19, 411.32, 93.39, 72.45)));
    expect(result.resizeMode, ResizeMode.scale);

    result = BoxTransformer.resize(
      resizeMode: ResizeMode.scale,
      initialFlip: Flip.horizontal,
      initialRect: Box.fromLTWH(483.19, 411.32, 93.39, 72.45),
      handle: HandlePosition.right,
      initialLocalPosition: Vector2(16.51, 28.69),
      allowFlipping: true,
      localPosition: Vector2(136.63, 23.25),
    );

    expect(result.flip, Flip.horizontal);
    expect(result.rect,
        withTolerance(Box.fromLTWH(483.19, 364.73, 213.52, 165.64)));
    expect(result.resizeMode, ResizeMode.scale);

    result = BoxTransformer.resize(
      resizeMode: ResizeMode.scale,
      initialFlip: Flip.horizontal,
      initialRect: Box.fromLTWH(483.19, 364.73, 213.52, 165.64),
      handle: HandlePosition.right,
      initialLocalPosition: Vector2(13.41, 71.72),
      allowFlipping: true,
      localPosition: Vector2(-371.43, 74.01),
    );

    expect(result.flip, Flip.none);
    expect(result.rect,
        withTolerance(Box.fromLTWH(311.88, 381.10, 171.31, 132.90)));
    expect(result.resizeMode, ResizeMode.scale);

    result = BoxTransformer.resize(
      resizeMode: ResizeMode.scale,
      initialFlip: Flip.none,
      initialRect: Box.fromLTWH(311.88, 381.10, 171.31, 132.90),
      handle: HandlePosition.left,
      initialLocalPosition: Vector2(14.35, 55.50),
      allowFlipping: true,
      localPosition: Vector2(-219.75, 66.05),
    );

    expect(result.flip, Flip.none);
    expect(result.rect,
        withTolerance(Box.fromLTWH(77.78, 290.30, 405.41, 314.50)));
    expect(result.resizeMode, ResizeMode.scale);

    result = BoxTransformer.resize(
      resizeMode: ResizeMode.scale,
      initialFlip: Flip.none,
      initialRect: Box.fromLTWH(77.78, 290.30, 405.41, 314.50),
      handle: HandlePosition.left,
      initialLocalPosition: Vector2(12.44, 151.84),
      allowFlipping: true,
      localPosition: Vector2(131.30, -185.00),
    );

    expect(result.flip, Flip.vertical);
    expect(result.rect,
        withTolerance(Box.fromLTWH(196.64, 336.40, 286.55, 222.29)));
    expect(result.resizeMode, ResizeMode.scale);

    result = BoxTransformer.resize(
      resizeMode: ResizeMode.scale,
      initialFlip: Flip.vertical,
      initialRect: Box.fromLTWH(196.64, 336.40, 286.55, 222.29),
      handle: HandlePosition.left,
      initialLocalPosition: Vector2(15.03, 103.59),
      allowFlipping: true,
      localPosition: Vector2(184.48, -164.85),
    );

    expect(result.flip, Flip.none);
    expect(result.rect,
        withTolerance(Box.fromLTWH(366.10, 402.13, 117.09, 90.83)));
    expect(result.resizeMode, ResizeMode.scale);

    result = BoxTransformer.resize(
      resizeMode: ResizeMode.scale,
      initialFlip: Flip.none,
      initialRect: Box.fromLTWH(366.10, 402.13, 117.09, 90.83),
      handle: HandlePosition.left,
      initialLocalPosition: Vector2(18.70, 31.93),
      allowFlipping: true,
      localPosition: Vector2(-116.03, 51.62),
    );

    expect(result.flip, Flip.none);
    expect(result.rect,
        withTolerance(Box.fromLTWH(231.37, 349.87, 251.82, 195.35)));
    expect(result.resizeMode, ResizeMode.scale);
  });

  test('Scaled resizing with top handle', () {
    var result = BoxTransformer.resize(
      resizeMode: ResizeMode.scale,
      initialFlip: Flip.none,
      initialRect: Box.fromLTWH(231.37, 349.87, 251.82, 195.35),
      handle: HandlePosition.top,
      initialLocalPosition: Vector2(109.53, 12.10),
      allowFlipping: true,
      localPosition: Vector2(104.92, 131.05),
    );

    expect(result.flip, Flip.none);
    expect(
        result.rect, withTolerance(Box.fromLTWH(308.04, 468.83, 98.48, 76.39)));
    expect(result.resizeMode, ResizeMode.scale);

    result = BoxTransformer.resize(
      resizeMode: ResizeMode.scale,
      initialFlip: Flip.none,
      initialRect: Box.fromLTWH(308.04, 468.83, 98.48, 76.39),
      handle: HandlePosition.top,
      initialLocalPosition: Vector2(39.49, 13.87),
      allowFlipping: true,
      localPosition: Vector2(45.72, -292.45),
    );

    expect(result.flip, Flip.none);
    expect(result.rect,
        withTolerance(Box.fromLTWH(110.61, 162.51, 493.34, 382.71)));
    expect(result.resizeMode, ResizeMode.scale);

    result = BoxTransformer.resize(
      resizeMode: ResizeMode.scale,
      initialFlip: Flip.none,
      initialRect: Box.fromLTWH(110.61, 162.51, 493.34, 382.71),
      handle: HandlePosition.top,
      initialLocalPosition: Vector2(239.10, 10.53),
      allowFlipping: true,
      localPosition: Vector2(231.56, 676.07),
    );

    expect(result.flip, Flip.vertical);
    expect(result.rect,
        withTolerance(Box.fromLTWH(174.99, 545.22, 364.58, 282.82)));
    expect(result.resizeMode, ResizeMode.scale);

    result = BoxTransformer.resize(
      resizeMode: ResizeMode.scale,
      initialFlip: Flip.vertical,
      initialRect: Box.fromLTWH(174.99, 545.22, 364.58, 282.82),
      handle: HandlePosition.bottom,
      initialLocalPosition: Vector2(169.29, 16.16),
      allowFlipping: true,
      localPosition: Vector2(166.38, -151.32),
    );

    expect(result.flip, Flip.vertical);
    expect(result.rect,
        withTolerance(Box.fromLTWH(282.94, 545.22, 148.69, 115.34)));
    expect(result.resizeMode, ResizeMode.scale);

    result = BoxTransformer.resize(
      resizeMode: ResizeMode.scale,
      initialFlip: Flip.vertical,
      initialRect: Box.fromLTWH(282.94, 545.22, 148.69, 115.34),
      handle: HandlePosition.bottom,
      initialLocalPosition: Vector2(65.23, 13.14),
      allowFlipping: true,
      localPosition: Vector2(46.25, -277.81),
    );

    expect(result.flip, Flip.none);
    expect(result.rect,
        withTolerance(Box.fromLTWH(244.09, 369.61, 226.37, 175.61)));
    expect(result.resizeMode, ResizeMode.scale);

    result = BoxTransformer.resize(
      resizeMode: ResizeMode.scale,
      initialFlip: Flip.none,
      initialRect: Box.fromLTWH(244.09, 369.61, 226.37, 175.61),
      handle: HandlePosition.top,
      initialLocalPosition: Vector2(102.90, 10.04),
      allowFlipping: true,
      localPosition: Vector2(101.20, 19.27),
    );

    expect(result.flip, Flip.none);
    expect(result.rect,
        withTolerance(Box.fromLTWH(250.04, 378.84, 214.47, 166.38)));
    expect(result.resizeMode, ResizeMode.scale);

    result = BoxTransformer.resize(
      resizeMode: ResizeMode.scale,
      initialFlip: Flip.none,
      initialRect: Box.fromLTWH(250.04, 378.84, 214.47, 166.38),
      handle: HandlePosition.top,
      initialLocalPosition: Vector2(96.86, 11.41),
      allowFlipping: true,
      localPosition: Vector2(-142.20, 10.37),
    );

    expect(result.flip, Flip.horizontal);
    expect(result.rect,
        withTolerance(Box.fromLTWH(249.37, 377.80, 215.81, 167.42)));
    expect(result.resizeMode, ResizeMode.scale);

    result = BoxTransformer.resize(
      resizeMode: ResizeMode.scale,
      initialFlip: Flip.horizontal,
      initialRect: Box.fromLTWH(249.37, 377.80, 215.81, 167.42),
      handle: HandlePosition.top,
      initialLocalPosition: Vector2(98.28, 12.26),
      allowFlipping: true,
      localPosition: Vector2(-164.09, -120.05),
    );

    expect(result.flip, Flip.none);
    expect(result.rect,
        withTolerance(Box.fromLTWH(164.09, 245.49, 386.38, 299.73)));
    expect(result.resizeMode, ResizeMode.scale);
  });

  test('Scaled resizing with bottom handle', () {
    var result = BoxTransformer.resize(
      resizeMode: ResizeMode.scale,
      initialFlip: Flip.none,
      initialRect: Box.fromLTWH(164.09, 245.49, 386.38, 299.73),
      handle: HandlePosition.bottom,
      initialLocalPosition: Vector2(184.20, 14.20),
      allowFlipping: true,
      localPosition: Vector2(185.65, -134.12),
    );

    expect(result.flip, Flip.none);
    expect(result.rect,
        withTolerance(Box.fromLTWH(259.69, 245.49, 195.18, 151.41)));
    expect(result.resizeMode, ResizeMode.scale);

    result = BoxTransformer.resize(
      resizeMode: ResizeMode.scale,
      initialFlip: Flip.none,
      initialRect: Box.fromLTWH(259.69, 245.49, 195.18, 151.41),
      handle: HandlePosition.bottom,
      initialLocalPosition: Vector2(90.53, 12.53),
      allowFlipping: true,
      localPosition: Vector2(112.51, 315.76),
    );

    expect(result.flip, Flip.none);
    expect(result.rect,
        withTolerance(Box.fromLTWH(64.25, 245.49, 586.07, 454.64)));
    expect(result.resizeMode, ResizeMode.scale);

    result = BoxTransformer.resize(
      resizeMode: ResizeMode.scale,
      initialFlip: Flip.none,
      initialRect: Box.fromLTWH(64.25, 245.49, 586.07, 454.64),
      handle: HandlePosition.bottom,
      initialLocalPosition: Vector2(286.27, 15.30),
      allowFlipping: true,
      localPosition: Vector2(269.39, -572.43),
    );

    expect(result.flip, Flip.vertical);
    expect(result.rect,
        withTolerance(Box.fromLTWH(271.50, 112.40, 171.56, 133.09)));
    expect(result.resizeMode, ResizeMode.scale);

    result = BoxTransformer.resize(
      resizeMode: ResizeMode.scale,
      initialFlip: Flip.vertical,
      initialRect: Box.fromLTWH(271.50, 112.40, 171.56, 133.09),
      handle: HandlePosition.top,
      initialLocalPosition: Vector2(67.53, 14.83),
      allowFlipping: true,
      localPosition: Vector2(71.51, -73.23),
    );

    expect(result.flip, Flip.vertical);
    expect(result.rect,
        withTolerance(Box.fromLTWH(214.75, 24.35, 285.07, 221.14)));
    expect(result.resizeMode, ResizeMode.scale);

    result = BoxTransformer.resize(
      resizeMode: ResizeMode.scale,
      initialFlip: Flip.vertical,
      initialRect: Box.fromLTWH(214.75, 24.35, 285.07, 221.14),
      handle: HandlePosition.top,
      initialLocalPosition: Vector2(132.25, 8.39),
      allowFlipping: true,
      localPosition: Vector2(125.79, 454.03),
    );

    expect(result.flip, Flip.none);
    expect(result.rect,
        withTolerance(Box.fromLTWH(212.58, 245.49, 289.40, 224.50)));
    expect(result.resizeMode, ResizeMode.scale);

    result = BoxTransformer.resize(
      resizeMode: ResizeMode.scale,
      initialFlip: Flip.none,
      initialRect: Box.fromLTWH(212.58, 245.49, 289.40, 224.50),
      handle: HandlePosition.bottom,
      initialLocalPosition: Vector2(134.05, 10.40),
      allowFlipping: true,
      localPosition: Vector2(-194.99, 91.72),
    );

    expect(result.flip, Flip.horizontal);
    expect(result.rect,
        withTolerance(Box.fromLTWH(160.17, 245.49, 394.23, 305.82)));
    expect(result.resizeMode, ResizeMode.scale);

    result = BoxTransformer.resize(
      resizeMode: ResizeMode.scale,
      initialFlip: Flip.horizontal,
      initialRect: Box.fromLTWH(160.17, 245.49, 394.23, 305.82),
      handle: HandlePosition.bottom,
      initialLocalPosition: Vector2(188.92, 13.90),
      allowFlipping: true,
      localPosition: Vector2(-367.06, -124.41),
    );

    expect(result.flip, Flip.none);
    expect(result.rect,
        withTolerance(Box.fromLTWH(249.31, 245.49, 215.94, 167.52)));
    expect(result.resizeMode, ResizeMode.scale);

    result = BoxTransformer.resize(
      resizeMode: ResizeMode.scale,
      initialFlip: Flip.none,
      initialRect: Box.fromLTWH(249.31, 245.49, 215.94, 167.52),
      handle: HandlePosition.bottom,
      initialLocalPosition: Vector2(98.54, 13.45),
      allowFlipping: true,
      localPosition: Vector2(104.86, 141.42),
    );

    expect(result.flip, Flip.none);
    expect(result.rect,
        withTolerance(Box.fromLTWH(166.83, 245.49, 380.90, 295.48)));
    expect(result.resizeMode, ResizeMode.scale);
  });
}
