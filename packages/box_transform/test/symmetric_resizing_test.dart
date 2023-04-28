import 'package:test/test.dart';
import 'package:vector_math/vector_math.dart';
import 'package:box_transform/box_transform.dart';
import 'utils.dart';

void main() {
  test('Symmetric resizing with bottom right handle', () {
    var result = BoxTransformer.resize(
      resizeMode: ResizeMode.symmetric,
      initialFlip: Flip.none,
      initialBox: Box.fromLTWH(275.20, 417.11, 174.30, 115.84),
      handle: HandlePosition.bottomRight,
      initialLocalPosition: Vector2(13.41, 11.55),
      flipRect: true,
      localPosition: Vector2(131.71, 16.60),
    );

    expect(result.flip, Flip.none);
    expect(result.rect,
        withTolerance(Box.fromLTWH(156.89, 412.06, 410.91, 125.94)));
    expect(result.resizeMode, ResizeMode.symmetric);

    result = BoxTransformer.resize(
      resizeMode: ResizeMode.symmetric,
      initialFlip: Flip.none,
      initialBox: Box.fromLTWH(156.89, 412.06, 410.91, 125.94),
      handle: HandlePosition.bottomRight,
      initialLocalPosition: Vector2(11.98, 11.55),
      flipRect: true,
      localPosition: Vector2(49.16, 125.69),
    );

    expect(result.flip, Flip.none);
    expect(result.rect,
        withTolerance(Box.fromLTWH(119.71, 297.92, 485.29, 354.22)));
    expect(result.resizeMode, ResizeMode.symmetric);

    result = BoxTransformer.resize(
      resizeMode: ResizeMode.symmetric,
      initialFlip: Flip.none,
      initialBox: Box.fromLTWH(119.71, 297.92, 485.29, 354.22),
      handle: HandlePosition.bottomRight,
      initialLocalPosition: Vector2(12.91, 13.66),
      flipRect: true,
      localPosition: Vector2(-169.70, -3.41),
    );

    expect(result.flip, Flip.none);
    expect(result.rect,
        withTolerance(Box.fromLTWH(302.32, 314.99, 120.07, 320.08)));
    expect(result.resizeMode, ResizeMode.symmetric);

    result = BoxTransformer.resize(
      resizeMode: ResizeMode.symmetric,
      initialFlip: Flip.none,
      initialBox: Box.fromLTWH(302.32, 314.99, 120.07, 320.08),
      handle: HandlePosition.bottomRight,
      initialLocalPosition: Vector2(13.62, 16.94),
      flipRect: true,
      localPosition: Vector2(-321.02, -1.59),
    );

    expect(result.flip, Flip.horizontal);
    expect(result.rect,
        withTolerance(Box.fromLTWH(87.75, 333.52, 549.21, 283.02)));
    expect(result.resizeMode, ResizeMode.symmetric);

    result = BoxTransformer.resize(
      resizeMode: ResizeMode.symmetric,
      initialFlip: Flip.horizontal,
      initialBox: Box.fromLTWH(87.75, 333.52, 549.21, 283.02),
      handle: HandlePosition.bottomLeft,
      initialLocalPosition: Vector2(15.02, 13.13),
      flipRect: true,
      localPosition: Vector2(227.65, -7.52),
    );

    expect(result.flip, Flip.horizontal);
    expect(result.rect,
        withTolerance(Box.fromLTWH(300.38, 354.18, 123.95, 241.71)));
    expect(result.resizeMode, ResizeMode.symmetric);

    result = BoxTransformer.resize(
      resizeMode: ResizeMode.symmetric,
      initialFlip: Flip.horizontal,
      initialBox: Box.fromLTWH(300.38, 354.18, 123.95, 241.71),
      handle: HandlePosition.bottomLeft,
      initialLocalPosition: Vector2(11.69, 13.12),
      flipRect: true,
      localPosition: Vector2(2.39, -71.40),
    );

    expect(result.flip, Flip.horizontal);
    expect(result.rect,
        withTolerance(Box.fromLTWH(291.08, 438.70, 142.54, 72.67)));
    expect(result.resizeMode, ResizeMode.symmetric);

    result = BoxTransformer.resize(
      resizeMode: ResizeMode.symmetric,
      initialFlip: Flip.horizontal,
      initialBox: Box.fromLTWH(291.08, 438.70, 142.54, 72.67),
      handle: HandlePosition.bottomLeft,
      initialLocalPosition: Vector2(13.06, 14.45),
      flipRect: true,
      localPosition: Vector2(276.71, 50.13),
    );

    expect(result.flip, Flip.none);
    expect(result.rect,
        withTolerance(Box.fromLTWH(169.97, 403.01, 384.76, 144.04)));
    expect(result.resizeMode, ResizeMode.symmetric);

    result = BoxTransformer.resize(
      resizeMode: ResizeMode.symmetric,
      initialFlip: Flip.none,
      initialBox: Box.fromLTWH(169.97, 403.01, 384.76, 144.04),
      handle: HandlePosition.bottomRight,
      initialLocalPosition: Vector2(12.59, 14.45),
      flipRect: true,
      localPosition: Vector2(17.17, -143.94),
    );

    expect(result.flip, Flip.vertical);
    expect(result.rect,
        withTolerance(Box.fromLTWH(165.39, 388.67, 393.92, 172.73)));
    expect(result.resizeMode, ResizeMode.symmetric);

    result = BoxTransformer.resize(
      resizeMode: ResizeMode.symmetric,
      initialFlip: Flip.vertical,
      initialBox: Box.fromLTWH(165.39, 388.67, 393.92, 172.73),
      handle: HandlePosition.topRight,
      initialLocalPosition: Vector2(12.59, 14.45),
      flipRect: true,
      localPosition: Vector2(19.07, -174.06),
    );

    expect(result.flip, Flip.vertical);
    expect(result.rect,
        withTolerance(Box.fromLTWH(158.91, 200.16, 406.89, 549.74)));
    expect(result.resizeMode, ResizeMode.symmetric);

    result = BoxTransformer.resize(
      resizeMode: ResizeMode.symmetric,
      initialFlip: Flip.vertical,
      initialBox: Box.fromLTWH(158.91, 200.16, 406.89, 549.74),
      handle: HandlePosition.topRight,
      initialLocalPosition: Vector2(15.83, 16.07),
      flipRect: true,
      localPosition: Vector2(4.00, 397.12),
    );

    expect(result.flip, Flip.none);
    expect(result.rect,
        withTolerance(Box.fromLTWH(170.73, 368.86, 383.23, 212.35)));
    expect(result.resizeMode, ResizeMode.symmetric);
  });

  test('Symmetric resizing with top-left handle', () {
    var result = BoxTransformer.resize(
      resizeMode: ResizeMode.symmetric,
      initialFlip: Flip.none,
      initialBox: Box.fromLTWH(170.73, 368.86, 383.23, 212.35),
      handle: HandlePosition.topLeft,
      initialLocalPosition: Vector2(13.27, 11.12),
      flipRect: true,
      localPosition: Vector2(-94.73, 43.25),
    );

    expect(result.flip, Flip.none);
    expect(result.rect,
        withTolerance(Box.fromLTWH(62.73, 400.98, 599.25, 148.10)));
    expect(result.resizeMode, ResizeMode.symmetric);

    result = BoxTransformer.resize(
      resizeMode: ResizeMode.symmetric,
      initialFlip: Flip.none,
      initialBox: Box.fromLTWH(62.73, 400.98, 599.25, 148.10),
      handle: HandlePosition.topLeft,
      initialLocalPosition: Vector2(11.37, 10.17),
      flipRect: true,
      localPosition: Vector2(245.79, -43.29),
    );

    expect(result.flip, Flip.none);
    expect(result.rect,
        withTolerance(Box.fromLTWH(297.15, 347.53, 130.40, 255.01)));
    expect(result.resizeMode, ResizeMode.symmetric);

    result = BoxTransformer.resize(
      resizeMode: ResizeMode.symmetric,
      initialFlip: Flip.none,
      initialBox: Box.fromLTWH(297.15, 347.53, 130.40, 255.01),
      handle: HandlePosition.topLeft,
      initialLocalPosition: Vector2(11.37, 10.17),
      flipRect: true,
      localPosition: Vector2(255.95, 27.36),
    );

    expect(result.flip, Flip.horizontal);
    expect(result.rect,
        withTolerance(Box.fromLTWH(182.96, 364.72, 358.77, 220.62)));
    expect(result.resizeMode, ResizeMode.symmetric);

    result = BoxTransformer.resize(
      resizeMode: ResizeMode.symmetric,
      initialFlip: Flip.horizontal,
      initialBox: Box.fromLTWH(182.96, 364.72, 358.77, 220.62),
      handle: HandlePosition.topRight,
      initialLocalPosition: Vector2(11.37, 10.17),
      flipRect: true,
      localPosition: Vector2(151.67, -14.11),
    );

    expect(result.flip, Flip.horizontal);
    expect(result.rect,
        withTolerance(Box.fromLTWH(42.66, 340.45, 639.38, 269.17)));
    expect(result.resizeMode, ResizeMode.symmetric);

    result = BoxTransformer.resize(
      resizeMode: ResizeMode.symmetric,
      initialFlip: Flip.horizontal,
      initialBox: Box.fromLTWH(42.66, 340.45, 639.38, 269.17),
      handle: HandlePosition.topRight,
      initialLocalPosition: Vector2(11.37, 10.17),
      flipRect: true,
      localPosition: Vector2(-467.74, 64.16),
    );

    expect(result.flip, Flip.none);
    expect(result.rect,
        withTolerance(Box.fromLTWH(202.94, 394.43, 318.83, 161.20)));
    expect(result.resizeMode, ResizeMode.symmetric);

    result = BoxTransformer.resize(
      resizeMode: ResizeMode.symmetric,
      initialFlip: Flip.none,
      initialBox: Box.fromLTWH(202.94, 394.43, 318.83, 161.20),
      handle: HandlePosition.topLeft,
      initialLocalPosition: Vector2(13.95, 10.17),
      flipRect: true,
      localPosition: Vector2(8.23, 265.46),
    );

    expect(result.flip, Flip.vertical);
    expect(result.rect,
        withTolerance(Box.fromLTWH(197.23, 300.34, 330.25, 349.38)));
    expect(result.resizeMode, ResizeMode.symmetric);

    result = BoxTransformer.resize(
      resizeMode: ResizeMode.symmetric,
      initialFlip: Flip.vertical,
      initialBox: Box.fromLTWH(197.23, 300.34, 330.25, 349.38),
      handle: HandlePosition.bottomLeft,
      initialLocalPosition: Vector2(13.95, 11.57),
      flipRect: true,
      localPosition: Vector2(18.30, -440.76),
    );

    expect(result.flip, Flip.none);
    expect(result.rect,
        withTolerance(Box.fromLTWH(201.58, 197.39, 321.55, 555.29)));
    expect(result.resizeMode, ResizeMode.symmetric);

    result = BoxTransformer.resize(
      resizeMode: ResizeMode.symmetric,
      initialFlip: Flip.none,
      initialBox: Box.fromLTWH(201.58, 197.39, 321.55, 555.29),
      handle: HandlePosition.topLeft,
      initialLocalPosition: Vector2(8.94, 10.86),
      flipRect: true,
      localPosition: Vector2(356.97, 446.71),
    );

    expect(result.flip, Flip.diagonal);
    expect(result.rect,
        withTolerance(Box.fromLTWH(175.10, 316.82, 374.51, 316.41)));
    expect(result.resizeMode, ResizeMode.symmetric);

    result = BoxTransformer.resize(
      resizeMode: ResizeMode.symmetric,
      initialFlip: Flip.diagonal,
      initialBox: Box.fromLTWH(175.10, 316.82, 374.51, 316.41),
      handle: HandlePosition.bottomRight,
      initialLocalPosition: Vector2(8.94, 10.86),
      flipRect: true,
      localPosition: Vector2(-117.76, 12.79),
    );

    expect(result.flip, Flip.diagonal);
    expect(result.rect,
        withTolerance(Box.fromLTWH(301.80, 314.89, 121.11, 320.27)));
    expect(result.resizeMode, ResizeMode.symmetric);

    result = BoxTransformer.resize(
      resizeMode: ResizeMode.symmetric,
      initialFlip: Flip.diagonal,
      initialBox: Box.fromLTWH(301.80, 314.89, 121.11, 320.27),
      handle: HandlePosition.bottomRight,
      initialLocalPosition: Vector2(11.29, 11.56),
      flipRect: true,
      localPosition: Vector2(-197.37, -253.70),
    );

    expect(result.flip, Flip.none);
    expect(result.rect,
        withTolerance(Box.fromLTWH(214.25, 369.91, 296.20, 210.24)));
    expect(result.resizeMode, ResizeMode.symmetric);
  });

  test('Symmetric resizing with top-right handle', () {
    var result = BoxTransformer.resize(
      resizeMode: ResizeMode.symmetric,
      initialFlip: Flip.none,
      initialBox: Box.fromLTWH(214.25, 369.91, 296.20, 210.24),
      handle: HandlePosition.topRight,
      initialLocalPosition: Vector2(14.19, 15.20),
      flipRect: true,
      localPosition: Vector2(155.29, -55.46),
    );

    expect(result.flip, Flip.none);
    expect(result.rect,
        withTolerance(Box.fromLTWH(73.16, 299.25, 578.39, 351.57)));
    expect(result.resizeMode, ResizeMode.symmetric);

    result = BoxTransformer.resize(
      resizeMode: ResizeMode.symmetric,
      initialFlip: Flip.none,
      initialBox: Box.fromLTWH(73.16, 299.25, 578.39, 351.57),
      handle: HandlePosition.topRight,
      initialLocalPosition: Vector2(15.36, 14.01),
      flipRect: true,
      localPosition: Vector2(-61.26, 136.33),
    );

    expect(result.flip, Flip.none);
    expect(result.rect,
        withTolerance(Box.fromLTWH(149.78, 421.57, 425.14, 106.92)));
    expect(result.resizeMode, ResizeMode.symmetric);

    result = BoxTransformer.resize(
      resizeMode: ResizeMode.symmetric,
      initialFlip: Flip.none,
      initialBox: Box.fromLTWH(149.78, 421.57, 425.14, 106.92),
      handle: HandlePosition.topRight,
      initialLocalPosition: Vector2(16.30, 14.01),
      flipRect: true,
      localPosition: Vector2(-329.84, 12.46),
    );

    expect(result.flip, Flip.horizontal);
    expect(result.rect,
        withTolerance(Box.fromLTWH(228.78, 420.02, 267.15, 110.02)));
    expect(result.resizeMode, ResizeMode.symmetric);

    result = BoxTransformer.resize(
      resizeMode: ResizeMode.symmetric,
      initialFlip: Flip.horizontal,
      initialBox: Box.fromLTWH(228.78, 420.02, 267.15, 110.02),
      handle: HandlePosition.topLeft,
      initialLocalPosition: Vector2(16.28, 14.00),
      flipRect: true,
      localPosition: Vector2(-106.00, -106.76),
    );

    expect(result.flip, Flip.horizontal);
    expect(result.rect,
        withTolerance(Box.fromLTWH(106.50, 299.26, 511.71, 351.55)));
    expect(result.resizeMode, ResizeMode.symmetric);

    result = BoxTransformer.resize(
      resizeMode: ResizeMode.symmetric,
      initialFlip: Flip.horizontal,
      initialBox: Box.fromLTWH(106.50, 299.26, 511.71, 351.55),
      handle: HandlePosition.topLeft,
      initialLocalPosition: Vector2(16.28, 14.24),
      flipRect: true,
      localPosition: Vector2(29.74, 256.83),
    );

    expect(result.flip, Flip.diagonal);
    expect(result.rect,
        withTolerance(Box.fromLTWH(119.96, 408.21, 484.79, 133.63)));
    expect(result.resizeMode, ResizeMode.symmetric);

    result = BoxTransformer.resize(
      resizeMode: ResizeMode.symmetric,
      initialFlip: Flip.diagonal,
      initialBox: Box.fromLTWH(119.96, 408.21, 484.79, 133.63),
      handle: HandlePosition.bottomLeft,
      initialLocalPosition: Vector2(12.47, 12.81),
      flipRect: true,
      localPosition: Vector2(186.38, 141.73),
    );

    expect(result.flip, Flip.diagonal);
    expect(result.rect,
        withTolerance(Box.fromLTWH(293.86, 279.29, 136.98, 391.48)));
    expect(result.resizeMode, ResizeMode.symmetric);

    result = BoxTransformer.resize(
      resizeMode: ResizeMode.symmetric,
      initialFlip: Flip.diagonal,
      initialBox: Box.fromLTWH(293.86, 279.29, 136.98, 391.48),
      handle: HandlePosition.bottomLeft,
      initialLocalPosition: Vector2(12.47, 12.81),
      flipRect: true,
      localPosition: Vector2(-20.37, -266.42),
    );

    expect(result.flip, Flip.horizontal);
    expect(result.rect,
        withTolerance(Box.fromLTWH(261.03, 391.54, 202.65, 166.98)));
    expect(result.resizeMode, ResizeMode.symmetric);

    result = BoxTransformer.resize(
      resizeMode: ResizeMode.symmetric,
      initialFlip: Flip.horizontal,
      initialBox: Box.fromLTWH(261.03, 391.54, 202.65, 166.98),
      handle: HandlePosition.topLeft,
      initialLocalPosition: Vector2(12.47, 12.81),
      flipRect: true,
      localPosition: Vector2(-92.80, -58.33),
    );

    expect(result.flip, Flip.horizontal);
    expect(result.rect,
        withTolerance(Box.fromLTWH(155.76, 320.41, 413.19, 309.25)));
    expect(result.resizeMode, ResizeMode.symmetric);

    result = BoxTransformer.resize(
      resizeMode: ResizeMode.symmetric,
      initialFlip: Flip.horizontal,
      initialBox: Box.fromLTWH(155.76, 320.41, 413.19, 309.25),
      handle: HandlePosition.topLeft,
      initialLocalPosition: Vector2(12.47, 12.81),
      flipRect: true,
      localPosition: Vector2(462.51, 24.13),
    );

    expect(result.flip, Flip.none);
    expect(result.rect,
        withTolerance(Box.fromLTWH(118.90, 331.72, 486.90, 286.62)));
    expect(result.resizeMode, ResizeMode.symmetric);

    result = BoxTransformer.resize(
      resizeMode: ResizeMode.symmetric,
      initialFlip: Flip.none,
      initialBox: Box.fromLTWH(118.90, 331.72, 486.90, 286.62),
      handle: HandlePosition.topRight,
      initialLocalPosition: Vector2(14.58, 15.39),
      flipRect: true,
      localPosition: Vector2(-358.49, 68.65),
    );

    expect(result.flip, Flip.horizontal);
    expect(result.rect,
        withTolerance(Box.fromLTWH(232.73, 384.98, 259.23, 180.09)));
    expect(result.resizeMode, ResizeMode.symmetric);
  });

  test('Symmetric resizing with bottom-left handle', () {
    var result = BoxTransformer.resize(
      resizeMode: ResizeMode.symmetric,
      initialFlip: Flip.horizontal,
      initialBox: Box.fromLTWH(232.73, 384.98, 259.23, 180.09),
      handle: HandlePosition.bottomLeft,
      initialLocalPosition: Vector2(13.23, 16.31),
      flipRect: true,
      localPosition: Vector2(-6.55, -35.38),
    );

    expect(result.flip, Flip.horizontal);
    expect(result.rect,
        withTolerance(Box.fromLTWH(212.96, 436.68, 298.79, 76.71)));
    expect(result.resizeMode, ResizeMode.symmetric);

    result = BoxTransformer.resize(
      resizeMode: ResizeMode.symmetric,
      initialFlip: Flip.horizontal,
      initialBox: Box.fromLTWH(212.96, 436.68, 298.79, 76.71),
      handle: HandlePosition.bottomLeft,
      initialLocalPosition: Vector2(11.56, 14.40),
      flipRect: true,
      localPosition: Vector2(53.51, 217.14),
    );

    expect(result.flip, Flip.horizontal);
    expect(result.rect,
        withTolerance(Box.fromLTWH(254.91, 233.94, 214.89, 482.18)));
    expect(result.resizeMode, ResizeMode.symmetric);

    result = BoxTransformer.resize(
      resizeMode: ResizeMode.symmetric,
      initialFlip: Flip.horizontal,
      initialBox: Box.fromLTWH(254.91, 233.94, 214.89, 482.18),
      handle: HandlePosition.bottomLeft,
      initialLocalPosition: Vector2(13.20, 11.07),
      flipRect: true,
      localPosition: Vector2(237.81, -18.60),
    );

    expect(result.flip, Flip.none);
    expect(result.rect,
        withTolerance(Box.fromLTWH(245.19, 263.61, 234.33, 422.85)));
    expect(result.resizeMode, ResizeMode.symmetric);

    result = BoxTransformer.resize(
      resizeMode: ResizeMode.symmetric,
      initialFlip: Flip.none,
      initialBox: Box.fromLTWH(245.19, 263.61, 234.33, 422.85),
      handle: HandlePosition.bottomRight,
      initialLocalPosition: Vector2(11.52, 7.25),
      flipRect: true,
      localPosition: Vector2(115.84, -131.05),
    );

    expect(result.flip, Flip.none);
    expect(result.rect,
        withTolerance(Box.fromLTWH(140.87, 401.91, 442.96, 146.24)));
    expect(result.resizeMode, ResizeMode.symmetric);

    result = BoxTransformer.resize(
      resizeMode: ResizeMode.symmetric,
      initialFlip: Flip.none,
      initialBox: Box.fromLTWH(140.87, 401.91, 442.96, 146.24),
      handle: HandlePosition.bottomRight,
      initialLocalPosition: Vector2(11.52, 7.25),
      flipRect: true,
      localPosition: Vector2(-328.78, 7.14),
    );

    expect(result.flip, Flip.horizontal);
    expect(result.rect,
        withTolerance(Box.fromLTWH(243.53, 402.03, 237.65, 146.01)));
    expect(result.resizeMode, ResizeMode.symmetric);

    result = BoxTransformer.resize(
      resizeMode: ResizeMode.symmetric,
      initialFlip: Flip.horizontal,
      initialBox: Box.fromLTWH(243.53, 402.03, 237.65, 146.01),
      handle: HandlePosition.bottomLeft,
      initialLocalPosition: Vector2(11.76, 9.13),
      flipRect: true,
      localPosition: Vector2(-75.30, -174.52),
    );

    expect(result.flip, Flip.diagonal);
    expect(result.rect,
        withTolerance(Box.fromLTWH(156.46, 364.39, 411.77, 221.29)));
    expect(result.resizeMode, ResizeMode.symmetric);

    result = BoxTransformer.resize(
      resizeMode: ResizeMode.symmetric,
      initialFlip: Flip.diagonal,
      initialBox: Box.fromLTWH(156.46, 364.39, 411.77, 221.29),
      handle: HandlePosition.topLeft,
      initialLocalPosition: Vector2(11.99, 11.47),
      flipRect: true,
      localPosition: Vector2(115.54, -107.03),
    );

    expect(result.flip, Flip.diagonal);
    expect(result.rect,
        withTolerance(Box.fromLTWH(260.01, 245.88, 204.68, 458.30)));
    expect(result.resizeMode, ResizeMode.symmetric);

    result = BoxTransformer.resize(
      resizeMode: ResizeMode.symmetric,
      initialFlip: Flip.diagonal,
      initialBox: Box.fromLTWH(260.01, 245.88, 204.68, 458.30),
      handle: HandlePosition.topLeft,
      initialLocalPosition: Vector2(11.99, 11.47),
      flipRect: true,
      localPosition: Vector2(275.18, 332.33),
    );

    expect(result.flip, Flip.none);
    expect(result.rect,
        withTolerance(Box.fromLTWH(201.50, 383.32, 321.70, 183.42)));
    expect(result.resizeMode, ResizeMode.symmetric);

    result = BoxTransformer.resize(
      resizeMode: ResizeMode.symmetric,
      initialFlip: Flip.none,
      initialBox: Box.fromLTWH(201.50, 383.32, 321.70, 183.42),
      handle: HandlePosition.bottomRight,
      initialLocalPosition: Vector2(11.99, 11.47),
      flipRect: true,
      localPosition: Vector2(-323.57, 39.40),
    );

    expect(result.flip, Flip.horizontal);
    expect(result.rect,
        withTolerance(Box.fromLTWH(187.64, 355.39, 349.42, 239.27)));
    expect(result.resizeMode, ResizeMode.symmetric);

    result = BoxTransformer.resize(
      resizeMode: ResizeMode.symmetric,
      initialFlip: Flip.horizontal,
      initialBox: Box.fromLTWH(187.64, 355.39, 349.42, 239.27),
      handle: HandlePosition.bottomLeft,
      initialLocalPosition: Vector2(12.20, 11.23),
      flipRect: true,
      localPosition: Vector2(304.52, -27.84),
    );

    expect(result.flip, Flip.none);
    expect(result.rect,
        withTolerance(Box.fromLTWH(244.74, 394.46, 235.22, 161.13)));
    expect(result.resizeMode, ResizeMode.symmetric);
  });

  test('Symmetric resizing with right handle', () {
    var result = BoxTransformer.resize(
      resizeMode: ResizeMode.symmetric,
      initialFlip: Flip.none,
      initialBox: Box.fromLTWH(244.74, 394.46, 235.22, 161.13),
      handle: HandlePosition.right,
      initialLocalPosition: Vector2(14.28, 67.38),
      flipRect: true,
      localPosition: Vector2(150.76, 68.29),
    );

    expect(result.flip, Flip.none);
    expect(result.rect,
        withTolerance(Box.fromLTWH(108.26, 394.46, 508.18, 161.13)));
    expect(result.resizeMode, ResizeMode.symmetric);

    result = BoxTransformer.resize(
      resizeMode: ResizeMode.symmetric,
      initialFlip: Flip.none,
      initialBox: Box.fromLTWH(108.26, 394.46, 508.18, 161.13),
      handle: HandlePosition.right,
      initialLocalPosition: Vector2(14.28, 68.29),
      flipRect: true,
      localPosition: Vector2(-152.04, 70.84),
    );

    expect(result.flip, Flip.none);
    expect(result.rect,
        withTolerance(Box.fromLTWH(274.57, 394.46, 175.55, 161.13)));
    expect(result.resizeMode, ResizeMode.symmetric);

    result = BoxTransformer.resize(
      resizeMode: ResizeMode.symmetric,
      initialFlip: Flip.none,
      initialBox: Box.fromLTWH(274.57, 394.46, 175.55, 161.13),
      handle: HandlePosition.right,
      initialLocalPosition: Vector2(14.28, 70.84),
      flipRect: true,
      localPosition: Vector2(-360.46, 64.16),
    );

    expect(result.flip, Flip.horizontal);
    expect(result.rect,
        withTolerance(Box.fromLTWH(75.39, 394.46, 573.91, 161.13)));
    expect(result.resizeMode, ResizeMode.symmetric);

    result = BoxTransformer.resize(
      resizeMode: ResizeMode.symmetric,
      initialFlip: Flip.horizontal,
      initialBox: Box.fromLTWH(75.39, 394.46, 573.91, 161.13),
      handle: HandlePosition.left,
      initialLocalPosition: Vector2(9.99, 70.72),
      flipRect: true,
      localPosition: Vector2(208.97, 57.41),
    );

    expect(result.flip, Flip.horizontal);
    expect(result.rect,
        withTolerance(Box.fromLTWH(274.38, 394.46, 175.95, 161.13)));
    expect(result.resizeMode, ResizeMode.symmetric);

    result = BoxTransformer.resize(
      resizeMode: ResizeMode.symmetric,
      initialFlip: Flip.horizontal,
      initialBox: Box.fromLTWH(274.38, 394.46, 175.95, 161.13),
      handle: HandlePosition.left,
      initialLocalPosition: Vector2(12.80, 72.64),
      flipRect: true,
      localPosition: Vector2(8.22, -115.25),
    );

    expect(result.flip, Flip.diagonal);
    expect(result.rect,
        withTolerance(Box.fromLTWH(269.80, 394.46, 185.10, 161.13)));
    expect(result.resizeMode, ResizeMode.symmetric);

    result = BoxTransformer.resize(
      resizeMode: ResizeMode.symmetric,
      initialFlip: Flip.diagonal,
      initialBox: Box.fromLTWH(269.80, 394.46, 185.10, 161.13),
      handle: HandlePosition.left,
      initialLocalPosition: Vector2(14.48, 74.62),
      flipRect: true,
      localPosition: Vector2(247.27, 113.80),
    );

    expect(result.flip, Flip.vertical);
    expect(result.rect,
        withTolerance(Box.fromLTWH(222.11, 394.46, 280.49, 161.13)));
    expect(result.resizeMode, ResizeMode.symmetric);

    result = BoxTransformer.resize(
      resizeMode: ResizeMode.symmetric,
      initialFlip: Flip.vertical,
      initialBox: Box.fromLTWH(222.11, 394.46, 280.49, 161.13),
      handle: HandlePosition.right,
      initialLocalPosition: Vector2(13.29, 66.87),
      flipRect: true,
      localPosition: Vector2(127.18, -106.07),
    );

    expect(result.flip, Flip.none);
    expect(result.rect,
        withTolerance(Box.fromLTWH(108.21, 394.46, 508.28, 161.13)));
    expect(result.resizeMode, ResizeMode.symmetric);

    result = BoxTransformer.resize(
      resizeMode: ResizeMode.symmetric,
      initialFlip: Flip.none,
      initialBox: Box.fromLTWH(108.21, 394.46, 508.28, 161.13),
      handle: HandlePosition.right,
      initialLocalPosition: Vector2(14.24, 74.61),
      flipRect: true,
      localPosition: Vector2(-413.66, 68.88),
    );

    expect(result.flip, Flip.horizontal);
    expect(result.rect,
        withTolerance(Box.fromLTWH(188.60, 394.46, 347.51, 161.13)));
    expect(result.resizeMode, ResizeMode.symmetric);

    result = BoxTransformer.resize(
      resizeMode: ResizeMode.symmetric,
      initialFlip: Flip.horizontal,
      initialBox: Box.fromLTWH(188.60, 394.46, 347.51, 161.13),
      handle: HandlePosition.left,
      initialLocalPosition: Vector2(13.94, 69.33),
      flipRect: true,
      localPosition: Vector2(304.82, 73.01),
    );

    expect(result.flip, Flip.none);
    expect(result.rect,
        withTolerance(Box.fromLTWH(245.23, 394.46, 234.25, 161.13)));
    expect(result.resizeMode, ResizeMode.symmetric);
  });

  test('Symmetric resizing with left handle', () {
    var result = BoxTransformer.resize(
      resizeMode: ResizeMode.symmetric,
      initialFlip: Flip.none,
      initialBox: Box.fromLTWH(245.23, 394.46, 234.25, 161.13),
      handle: HandlePosition.left,
      initialLocalPosition: Vector2(15.00, 71.04),
      flipRect: true,
      localPosition: Vector2(-165.98, 64.64),
    );

    expect(result.flip, Flip.none);
    expect(result.rect,
        withTolerance(Box.fromLTWH(64.24, 394.46, 596.22, 161.13)));
    expect(result.resizeMode, ResizeMode.symmetric);

    result = BoxTransformer.resize(
      resizeMode: ResizeMode.symmetric,
      initialFlip: Flip.none,
      initialBox: Box.fromLTWH(64.24, 394.46, 596.22, 161.13),
      handle: HandlePosition.left,
      initialLocalPosition: Vector2(9.05, 67.22),
      flipRect: true,
      localPosition: Vector2(252.77, 61.78),
    );

    expect(result.flip, Flip.none);
    expect(result.rect,
        withTolerance(Box.fromLTWH(307.96, 394.46, 108.78, 161.13)));
    expect(result.resizeMode, ResizeMode.symmetric);

    result = BoxTransformer.resize(
      resizeMode: ResizeMode.symmetric,
      initialFlip: Flip.none,
      initialBox: Box.fromLTWH(307.96, 394.46, 108.78, 161.13),
      handle: HandlePosition.left,
      initialLocalPosition: Vector2(12.80, 65.76),
      flipRect: true,
      localPosition: Vector2(134.83, 62.82),
    );

    expect(result.flip, Flip.horizontal);
    expect(result.rect,
        withTolerance(Box.fromLTWH(294.71, 394.46, 135.28, 161.13)));
    expect(result.resizeMode, ResizeMode.symmetric);

    result = BoxTransformer.resize(
      resizeMode: ResizeMode.symmetric,
      initialFlip: Flip.horizontal,
      initialBox: Box.fromLTWH(294.71, 394.46, 135.28, 161.13),
      handle: HandlePosition.right,
      initialLocalPosition: Vector2(15.84, 70.09),
      flipRect: true,
      localPosition: Vector2(251.70, 59.60),
    );

    expect(result.flip, Flip.horizontal);
    expect(result.rect,
        withTolerance(Box.fromLTWH(58.86, 394.46, 606.98, 161.13)));
    expect(result.resizeMode, ResizeMode.symmetric);

    result = BoxTransformer.resize(
      resizeMode: ResizeMode.symmetric,
      initialFlip: Flip.horizontal,
      initialBox: Box.fromLTWH(58.86, 394.46, 606.98, 161.13),
      handle: HandlePosition.right,
      initialLocalPosition: Vector2(15.13, 70.61),
      flipRect: true,
      localPosition: Vector2(-371.54, 87.56),
    );

    expect(result.flip, Flip.none);
    expect(result.rect,
        withTolerance(Box.fromLTWH(279.18, 394.46, 166.34, 161.13)));
    expect(result.resizeMode, ResizeMode.symmetric);

    result = BoxTransformer.resize(
      resizeMode: ResizeMode.symmetric,
      initialFlip: Flip.none,
      initialBox: Box.fromLTWH(279.18, 394.46, 166.34, 161.13),
      handle: HandlePosition.left,
      initialLocalPosition: Vector2(13.20, 78.27),
      flipRect: true,
      localPosition: Vector2(-145.38, 71.50),
    );

    expect(result.flip, Flip.none);
    expect(result.rect,
        withTolerance(Box.fromLTWH(120.59, 394.46, 483.52, 161.13)));
    expect(result.resizeMode, ResizeMode.symmetric);

    result = BoxTransformer.resize(
      resizeMode: ResizeMode.symmetric,
      initialFlip: Flip.none,
      initialBox: Box.fromLTWH(120.59, 394.46, 483.52, 161.13),
      handle: HandlePosition.left,
      initialLocalPosition: Vector2(13.20, 71.50),
      flipRect: true,
      localPosition: Vector2(13.20, 71.50),
    );

    expect(result.flip, Flip.none);
    expect(result.rect,
        withTolerance(Box.fromLTWH(120.59, 394.46, 483.52, 161.13)));
    expect(result.resizeMode, ResizeMode.symmetric);

    result = BoxTransformer.resize(
      resizeMode: ResizeMode.symmetric,
      initialFlip: Flip.none,
      initialBox: Box.fromLTWH(120.59, 394.46, 483.52, 161.13),
      handle: HandlePosition.left,
      initialLocalPosition: Vector2(11.24, 70.41),
      flipRect: true,
      localPosition: Vector2(395.69, -145.36),
    );

    expect(result.flip, Flip.diagonal);
    expect(result.rect,
        withTolerance(Box.fromLTWH(219.66, 394.46, 285.38, 161.13)));
    expect(result.resizeMode, ResizeMode.symmetric);

    result = BoxTransformer.resize(
      resizeMode: ResizeMode.symmetric,
      initialFlip: Flip.diagonal,
      initialBox: Box.fromLTWH(219.66, 394.46, 285.38, 161.13),
      handle: HandlePosition.right,
      initialLocalPosition: Vector2(14.73, 74.41),
      flipRect: true,
      localPosition: Vector2(-288.94, -62.53),
    );

    expect(result.flip, Flip.none);
    expect(result.rect,
        withTolerance(Box.fromLTWH(201.37, 394.46, 321.96, 161.13)));
    expect(result.resizeMode, ResizeMode.symmetric);
  });

  test('Symmetric resizing with bottom handle', () {
    var result = BoxTransformer.resize(
      resizeMode: ResizeMode.symmetric,
      initialFlip: Flip.none,
      initialBox: Box.fromLTWH(201.37, 394.46, 321.96, 161.13),
      handle: HandlePosition.bottom,
      initialLocalPosition: Vector2(152.12, 12.86),
      flipRect: true,
      localPosition: Vector2(159.14, 153.61),
    );

    expect(result.flip, Flip.none);
    expect(result.rect,
        withTolerance(Box.fromLTWH(201.37, 253.71, 321.96, 442.63)));
    expect(result.resizeMode, ResizeMode.symmetric);

    result = BoxTransformer.resize(
      resizeMode: ResizeMode.symmetric,
      initialFlip: Flip.none,
      initialBox: Box.fromLTWH(201.37, 253.71, 321.96, 442.63),
      handle: HandlePosition.bottom,
      initialLocalPosition: Vector2(150.57, 14.26),
      flipRect: true,
      localPosition: Vector2(143.49, -273.00),
    );

    expect(result.flip, Flip.vertical);
    expect(result.rect,
        withTolerance(Box.fromLTWH(201.37, 409.09, 321.96, 131.88)));
    expect(result.resizeMode, ResizeMode.symmetric);

    result = BoxTransformer.resize(
      resizeMode: ResizeMode.symmetric,
      initialFlip: Flip.vertical,
      initialBox: Box.fromLTWH(201.37, 409.09, 321.96, 131.88),
      handle: HandlePosition.top,
      initialLocalPosition: Vector2(146.30, 14.96),
      flipRect: true,
      localPosition: Vector2(151.53, -125.92),
    );

    expect(result.flip, Flip.vertical);
    expect(result.rect,
        withTolerance(Box.fromLTWH(201.37, 268.21, 321.96, 413.65)));
    expect(result.resizeMode, ResizeMode.symmetric);

    result = BoxTransformer.resize(
      resizeMode: ResizeMode.symmetric,
      initialFlip: Flip.vertical,
      initialBox: Box.fromLTWH(201.37, 268.21, 321.96, 413.65),
      handle: HandlePosition.top,
      initialLocalPosition: Vector2(151.77, 10.44),
      flipRect: true,
      localPosition: Vector2(159.30, 454.08),
    );

    expect(result.flip, Flip.none);
    expect(result.rect,
        withTolerance(Box.fromLTWH(201.37, 238.21, 321.96, 473.63)));
    expect(result.resizeMode, ResizeMode.symmetric);

    result = BoxTransformer.resize(
      resizeMode: ResizeMode.symmetric,
      initialFlip: Flip.none,
      initialBox: Box.fromLTWH(201.37, 238.21, 321.96, 473.63),
      handle: HandlePosition.bottom,
      initialLocalPosition: Vector2(158.32, 12.31),
      flipRect: true,
      localPosition: Vector2(-79.52, -140.86),
    );

    expect(result.flip, Flip.horizontal);
    expect(result.rect,
        withTolerance(Box.fromLTWH(201.37, 391.39, 321.96, 167.29)));
    expect(result.resizeMode, ResizeMode.symmetric);

    result = BoxTransformer.resize(
      resizeMode: ResizeMode.symmetric,
      initialFlip: Flip.horizontal,
      initialBox: Box.fromLTWH(201.37, 391.39, 321.96, 167.29),
      handle: HandlePosition.bottom,
      initialLocalPosition: Vector2(160.06, 15.91),
      flipRect: true,
      localPosition: Vector2(-45.69, -210.04),
    );

    expect(result.flip, Flip.vertical);
    expect(result.rect,
        withTolerance(Box.fromLTWH(201.37, 332.73, 321.96, 284.60)));
    expect(result.resizeMode, ResizeMode.symmetric);

    result = BoxTransformer.resize(
      resizeMode: ResizeMode.symmetric,
      initialFlip: Flip.vertical,
      initialBox: Box.fromLTWH(201.37, 332.73, 321.96, 284.60),
      handle: HandlePosition.top,
      initialLocalPosition: Vector2(153.25, 12.08),
      flipRect: true,
      localPosition: Vector2(159.09, 219.20),
    );

    expect(result.flip, Flip.none);
    expect(result.rect,
        withTolerance(Box.fromLTWH(201.37, 410.21, 321.96, 129.63)));
    expect(result.resizeMode, ResizeMode.symmetric);

    result = BoxTransformer.resize(
      resizeMode: ResizeMode.symmetric,
      initialFlip: Flip.none,
      initialBox: Box.fromLTWH(201.37, 410.21, 321.96, 129.63),
      handle: HandlePosition.bottom,
      initialLocalPosition: Vector2(155.28, 14.13),
      flipRect: true,
      localPosition: Vector2(156.92, 57.25),
    );

    expect(result.flip, Flip.none);
    expect(result.rect,
        withTolerance(Box.fromLTWH(201.37, 367.09, 321.96, 215.88)));
    expect(result.resizeMode, ResizeMode.symmetric);
  });

  test('Symmetric resizing with top handle', () {
    var result = BoxTransformer.resize(
      resizeMode: ResizeMode.symmetric,
      initialFlip: Flip.none,
      initialBox: Box.fromLTWH(201.37, 367.09, 321.96, 215.88),
      handle: HandlePosition.top,
      initialLocalPosition: Vector2(151.86, 10.14),
      flipRect: true,
      localPosition: Vector2(160.80, -218.14),
    );

    expect(result.flip, Flip.none);
    expect(result.rect,
        withTolerance(Box.fromLTWH(201.37, 138.80, 321.96, 672.45)));
    expect(result.resizeMode, ResizeMode.symmetric);

    result = BoxTransformer.resize(
      resizeMode: ResizeMode.symmetric,
      initialFlip: Flip.none,
      initialBox: Box.fromLTWH(201.37, 138.80, 321.96, 672.45),
      handle: HandlePosition.top,
      initialLocalPosition: Vector2(156.04, 10.37),
      flipRect: true,
      localPosition: Vector2(139.21, 293.66),
    );

    expect(result.flip, Flip.none);
    expect(result.rect,
        withTolerance(Box.fromLTWH(201.37, 422.09, 321.96, 105.88)));
    expect(result.resizeMode, ResizeMode.symmetric);

    result = BoxTransformer.resize(
      resizeMode: ResizeMode.symmetric,
      initialFlip: Flip.none,
      initialBox: Box.fromLTWH(201.37, 422.09, 321.96, 105.88),
      handle: HandlePosition.top,
      initialLocalPosition: Vector2(145.07, 12.48),
      flipRect: true,
      localPosition: Vector2(141.66, 125.00),
    );

    expect(result.flip, Flip.vertical);
    expect(result.rect,
        withTolerance(Box.fromLTWH(201.37, 415.46, 321.96, 119.15)));
    expect(result.resizeMode, ResizeMode.symmetric);

    result = BoxTransformer.resize(
      resizeMode: ResizeMode.symmetric,
      initialFlip: Flip.vertical,
      initialBox: Box.fromLTWH(201.37, 415.46, 321.96, 119.15),
      handle: HandlePosition.bottom,
      initialLocalPosition: Vector2(148.22, 14.59),
      flipRect: true,
      localPosition: Vector2(154.45, 224.51),
    );

    expect(result.flip, Flip.vertical);
    expect(result.rect,
        withTolerance(Box.fromLTWH(201.37, 205.54, 321.96, 538.99)));
    expect(result.resizeMode, ResizeMode.symmetric);

    result = BoxTransformer.resize(
      resizeMode: ResizeMode.symmetric,
      initialFlip: Flip.vertical,
      initialBox: Box.fromLTWH(201.37, 205.54, 321.96, 538.99),
      handle: HandlePosition.bottom,
      initialLocalPosition: Vector2(154.92, 14.59),
      flipRect: true,
      localPosition: Vector2(127.29, -337.73),
    );

    expect(result.flip, Flip.none);
    expect(result.rect,
        withTolerance(Box.fromLTWH(201.37, 392.21, 321.96, 165.65)));
    expect(result.resizeMode, ResizeMode.symmetric);

    result = BoxTransformer.resize(
      resizeMode: ResizeMode.symmetric,
      initialFlip: Flip.none,
      initialBox: Box.fromLTWH(201.37, 392.21, 321.96, 165.65),
      handle: HandlePosition.top,
      initialLocalPosition: Vector2(145.10, 12.66),
      flipRect: true,
      localPosition: Vector2(143.14, -172.61),
    );

    expect(result.flip, Flip.none);
    expect(result.rect,
        withTolerance(Box.fromLTWH(201.37, 206.95, 321.96, 536.17)));
    expect(result.resizeMode, ResizeMode.symmetric);

    result = BoxTransformer.resize(
      resizeMode: ResizeMode.symmetric,
      initialFlip: Flip.none,
      initialBox: Box.fromLTWH(201.37, 206.95, 321.96, 536.17),
      handle: HandlePosition.top,
      initialLocalPosition: Vector2(145.72, 12.18),
      flipRect: true,
      localPosition: Vector2(-105.72, 198.96),
    );

    expect(result.flip, Flip.horizontal);
    expect(result.rect,
        withTolerance(Box.fromLTWH(201.37, 393.73, 321.96, 162.60)));
    expect(result.resizeMode, ResizeMode.symmetric);

    result = BoxTransformer.resize(
      resizeMode: ResizeMode.symmetric,
      initialFlip: Flip.horizontal,
      initialBox: Box.fromLTWH(201.37, 393.73, 321.96, 162.60),
      handle: HandlePosition.top,
      initialLocalPosition: Vector2(145.60, 10.23),
      flipRect: true,
      localPosition: Vector2(-101.52, 207.04),
    );

    expect(result.flip, Flip.vertical);
    expect(result.rect,
        withTolerance(Box.fromLTWH(201.37, 359.52, 321.96, 231.02)));
    expect(result.resizeMode, ResizeMode.symmetric);

    result = BoxTransformer.resize(
      resizeMode: ResizeMode.symmetric,
      initialFlip: Flip.vertical,
      initialBox: Box.fromLTWH(201.37, 359.52, 321.96, 231.02),
      handle: HandlePosition.bottom,
      initialLocalPosition: Vector2(146.75, 16.79),
      flipRect: true,
      localPosition: Vector2(138.89, -194.70),
    );

    expect(result.flip, Flip.none);
    expect(result.rect,
        withTolerance(Box.fromLTWH(201.37, 379.05, 321.96, 191.97)));
    expect(result.resizeMode, ResizeMode.symmetric);
  });
}
