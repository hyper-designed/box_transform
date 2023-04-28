import 'package:test/test.dart';
import 'package:vector_math/vector_math.dart';
import 'package:box_transform/box_transform.dart';
import 'utils.dart';

void main() {
  test('Clamped symmetric resizing with bottom-right handle', () {
    var result = BoxTransformer.resize(
      resizeMode: ResizeMode.symmetric,
      initialFlip: Flip.none,
      initialBox: Box.fromLTWH(153.32, 167.88, 266.82, 211.12),
      handle: HandlePosition.bottomRight,
      initialLocalPosition: Vector2(15.25, 13.79),
      flipRect: true,
      localPosition: Vector2(170.02, 28.05),
      clampingRect: Box.fromLTWH(66.74, 61.60, 589.63, 822.26),
    );

    expect(result.flip, Flip.none);
    expect(result.rect,
        withTolerance(Box.fromLTWH(66.74, 153.62, 439.97, 239.65)));
    expect(result.resizeMode, ResizeMode.symmetric);

    result = BoxTransformer.resize(
      resizeMode: ResizeMode.symmetric,
      initialFlip: Flip.none,
      initialBox: Box.fromLTWH(66.74, 153.62, 439.97, 239.65),
      handle: HandlePosition.bottomRight,
      initialLocalPosition: Vector2(14.75, 13.23),
      flipRect: true,
      localPosition: Vector2(-92.02, 162.29),
      clampingRect: Box.fromLTWH(66.74, 61.60, 589.63, 822.26),
    );

    expect(result.flip, Flip.none);
    expect(result.rect,
        withTolerance(Box.fromLTWH(173.51, 61.60, 226.43, 423.68)));
    expect(result.resizeMode, ResizeMode.symmetric);

    result = BoxTransformer.resize(
      resizeMode: ResizeMode.symmetric,
      initialFlip: Flip.none,
      initialBox: Box.fromLTWH(173.51, 61.60, 226.43, 423.68),
      handle: HandlePosition.bottomRight,
      initialLocalPosition: Vector2(14.00, 14.09),
      flipRect: true,
      localPosition: Vector2(187.84, 56.41),
      clampingRect: Box.fromLTWH(66.74, 61.60, 589.63, 822.26),
    );

    expect(result.flip, Flip.none);
    expect(
        result.rect, withTolerance(Box.fromLTWH(66.74, 61.60, 439.97, 423.68)));
    expect(result.resizeMode, ResizeMode.symmetric);

    result = BoxTransformer.resize(
      resizeMode: ResizeMode.symmetric,
      initialFlip: Flip.none,
      initialBox: Box.fromLTWH(66.74, 61.60, 439.97, 423.68),
      handle: HandlePosition.bottomRight,
      initialLocalPosition: Vector2(14.93, 15.66),
      flipRect: true,
      localPosition: Vector2(-324.76, -292.07),
      clampingRect: Box.fromLTWH(66.74, 61.60, 589.63, 822.26),
    );

    expect(result.flip, Flip.diagonal);
    expect(result.rect,
        withTolerance(Box.fromLTWH(167.02, 177.55, 239.42, 191.79)));
    expect(result.resizeMode, ResizeMode.symmetric);

    result = BoxTransformer.resize(
      resizeMode: ResizeMode.symmetric,
      initialFlip: Flip.diagonal,
      initialBox: Box.fromLTWH(167.02, 177.55, 239.42, 191.79),
      handle: HandlePosition.topLeft,
      initialLocalPosition: Vector2(12.99, 11.80),
      flipRect: true,
      localPosition: Vector2(-157.85, -10.91),
      clampingRect: Box.fromLTWH(66.74, 61.60, 589.63, 822.26),
    );

    expect(result.flip, Flip.diagonal);
    expect(result.rect,
        withTolerance(Box.fromLTWH(66.74, 154.85, 439.97, 237.19)));
    expect(result.resizeMode, ResizeMode.symmetric);

    result = BoxTransformer.resize(
      resizeMode: ResizeMode.symmetric,
      initialFlip: Flip.diagonal,
      initialBox: Box.fromLTWH(66.74, 154.85, 439.97, 237.19),
      handle: HandlePosition.topLeft,
      initialLocalPosition: Vector2(13.44, 12.41),
      flipRect: true,
      localPosition: Vector2(107.69, -134.64),
      clampingRect: Box.fromLTWH(66.74, 61.60, 589.63, 822.26),
    );

    expect(result.flip, Flip.diagonal);
    expect(result.rect,
        withTolerance(Box.fromLTWH(160.99, 61.60, 251.48, 423.68)));
    expect(result.resizeMode, ResizeMode.symmetric);

    result = BoxTransformer.resize(
      resizeMode: ResizeMode.symmetric,
      initialFlip: Flip.diagonal,
      initialBox: Box.fromLTWH(160.99, 61.60, 251.48, 423.68),
      handle: HandlePosition.topLeft,
      initialLocalPosition: Vector2(12.77, 12.64),
      flipRect: true,
      localPosition: Vector2(-146.53, -41.53),
      clampingRect: Box.fromLTWH(66.74, 61.60, 589.63, 822.26),
    );

    expect(result.flip, Flip.diagonal);
    expect(
        result.rect, withTolerance(Box.fromLTWH(66.74, 61.60, 439.97, 423.68)));
    expect(result.resizeMode, ResizeMode.symmetric);

    result = BoxTransformer.resize(
      resizeMode: ResizeMode.symmetric,
      initialFlip: Flip.diagonal,
      initialBox: Box.fromLTWH(66.74, 61.60, 439.97, 423.68),
      handle: HandlePosition.topLeft,
      initialLocalPosition: Vector2(18.50, 10.37),
      flipRect: true,
      localPosition: Vector2(404.23, -13.07),
      clampingRect: Box.fromLTWH(66.74, 61.60, 589.63, 822.26),
    );

    expect(result.flip, Flip.vertical);
    expect(result.rect,
        withTolerance(Box.fromLTWH(120.97, 61.60, 331.51, 423.68)));
    expect(result.resizeMode, ResizeMode.symmetric);

    result = BoxTransformer.resize(
      resizeMode: ResizeMode.symmetric,
      initialFlip: Flip.vertical,
      initialBox: Box.fromLTWH(120.97, 61.60, 331.51, 423.68),
      handle: HandlePosition.topRight,
      initialLocalPosition: Vector2(9.20, 7.32),
      flipRect: true,
      localPosition: Vector2(16.84, 337.07),
      clampingRect: Box.fromLTWH(66.74, 61.60, 589.63, 822.26),
    );

    expect(result.flip, Flip.none);
    expect(result.rect,
        withTolerance(Box.fromLTWH(113.34, 155.54, 346.78, 235.81)));
    expect(result.resizeMode, ResizeMode.symmetric);
  });

  test('Clamped symmetric resizing with top-left handle', () {
    var result = BoxTransformer.resize(
      resizeMode: ResizeMode.symmetric,
      initialFlip: Flip.none,
      initialBox: Box.fromLTWH(216.30, 479.82, 346.78, 235.81),
      handle: HandlePosition.topLeft,
      initialLocalPosition: Vector2(14.47, 10.51),
      flipRect: true,
      localPosition: Vector2(-108.14, 23.03),
      clampingRect: Box.fromLTWH(66.74, 61.60, 589.63, 822.26),
    );

    expect(result.flip, Flip.none);
    expect(result.rect,
        withTolerance(Box.fromLTWH(123.00, 492.34, 533.38, 210.77)));
    expect(result.resizeMode, ResizeMode.symmetric);

    result = BoxTransformer.resize(
      resizeMode: ResizeMode.symmetric,
      initialFlip: Flip.none,
      initialBox: Box.fromLTWH(123.00, 492.34, 533.38, 210.77),
      handle: HandlePosition.topLeft,
      initialLocalPosition: Vector2(13.05, 8.56),
      flipRect: true,
      localPosition: Vector2(139.61, -223.48),
      clampingRect: Box.fromLTWH(66.74, 61.60, 589.63, 822.26),
    );

    expect(result.flip, Flip.none);
    expect(result.rect,
        withTolerance(Box.fromLTWH(249.56, 311.59, 280.25, 572.28)));
    expect(result.resizeMode, ResizeMode.symmetric);

    result = BoxTransformer.resize(
      resizeMode: ResizeMode.symmetric,
      initialFlip: Flip.none,
      initialBox: Box.fromLTWH(249.56, 311.59, 280.25, 572.28),
      handle: HandlePosition.topLeft,
      initialLocalPosition: Vector2(11.30, 14.93),
      flipRect: true,
      localPosition: Vector2(-177.04, -86.58),
      clampingRect: Box.fromLTWH(66.74, 61.60, 589.63, 822.26),
    );

    expect(result.flip, Flip.none);
    expect(result.rect,
        withTolerance(Box.fromLTWH(123.00, 311.59, 533.38, 572.28)));
    expect(result.resizeMode, ResizeMode.symmetric);

    result = BoxTransformer.resize(
      resizeMode: ResizeMode.symmetric,
      initialFlip: Flip.none,
      initialBox: Box.fromLTWH(123.00, 311.59, 533.38, 572.28),
      handle: HandlePosition.topLeft,
      initialLocalPosition: Vector2(16.61, 14.02),
      flipRect: true,
      localPosition: Vector2(595.12, 214.14),
      clampingRect: Box.fromLTWH(66.74, 61.60, 589.63, 822.26),
    );

    expect(result.flip, Flip.horizontal);
    expect(result.rect,
        withTolerance(Box.fromLTWH(123.00, 511.70, 533.38, 172.05)));
    expect(result.resizeMode, ResizeMode.symmetric);

    result = BoxTransformer.resize(
      resizeMode: ResizeMode.symmetric,
      initialFlip: Flip.horizontal,
      initialBox: Box.fromLTWH(123.00, 511.70, 533.38, 172.05),
      handle: HandlePosition.topRight,
      initialLocalPosition: Vector2(11.24, 13.28),
      flipRect: true,
      localPosition: Vector2(-142.27, 414.73),
      clampingRect: Box.fromLTWH(66.74, 61.60, 589.63, 822.26),
    );

    expect(result.flip, Flip.diagonal);
    expect(result.rect,
        withTolerance(Box.fromLTWH(276.52, 311.59, 226.34, 572.28)));
    expect(result.resizeMode, ResizeMode.symmetric);

    result = BoxTransformer.resize(
      resizeMode: ResizeMode.symmetric,
      initialFlip: Flip.diagonal,
      initialBox: Box.fromLTWH(276.52, 311.59, 226.34, 572.28),
      handle: HandlePosition.bottomRight,
      initialLocalPosition: Vector2(13.69, 12.06),
      flipRect: true,
      localPosition: Vector2(226.97, 41.57),
      clampingRect: Box.fromLTWH(66.74, 61.60, 589.63, 822.26),
    );

    expect(result.flip, Flip.diagonal);
    expect(result.rect,
        withTolerance(Box.fromLTWH(123.00, 311.59, 533.38, 572.28)));
    expect(result.resizeMode, ResizeMode.symmetric);

    result = BoxTransformer.resize(
      resizeMode: ResizeMode.symmetric,
      initialFlip: Flip.diagonal,
      initialBox: Box.fromLTWH(123.00, 311.59, 533.38, 572.28),
      handle: HandlePosition.bottomRight,
      initialLocalPosition: Vector2(12.75, 10.59),
      flipRect: true,
      localPosition: Vector2(-421.80, 48.59),
      clampingRect: Box.fromLTWH(66.74, 61.60, 589.63, 822.26),
    );

    expect(result.flip, Flip.vertical);
    expect(result.rect,
        withTolerance(Box.fromLTWH(221.82, 311.59, 335.73, 572.28)));
    expect(result.resizeMode, ResizeMode.symmetric);

    result = BoxTransformer.resize(
      resizeMode: ResizeMode.symmetric,
      initialFlip: Flip.vertical,
      initialBox: Box.fromLTWH(221.82, 311.59, 335.73, 572.28),
      handle: HandlePosition.bottomLeft,
      initialLocalPosition: Vector2(11.01, 10.48),
      flipRect: true,
      localPosition: Vector2(502.30, -432.57),
      clampingRect: Box.fromLTWH(66.74, 61.60, 589.63, 822.26),
    );

    expect(result.flip, Flip.horizontal);
    expect(result.rect,
        withTolerance(Box.fromLTWH(123.00, 440.82, 533.38, 313.82)));
    expect(result.resizeMode, ResizeMode.symmetric);

    result = BoxTransformer.resize(
      resizeMode: ResizeMode.symmetric,
      initialFlip: Flip.horizontal,
      initialBox: Box.fromLTWH(123.00, 440.82, 533.38, 313.82),
      handle: HandlePosition.topRight,
      initialLocalPosition: Vector2(15.46, 13.69),
      flipRect: true,
      localPosition: Vector2(-400.21, 56.04),
      clampingRect: Box.fromLTWH(66.74, 61.60, 589.63, 822.26),
    );

    expect(result.flip, Flip.none);
    expect(result.rect,
        withTolerance(Box.fromLTWH(240.71, 483.16, 297.95, 229.12)));
    expect(result.resizeMode, ResizeMode.symmetric);
  });

  test('Clamped symmetric resizing with top-right handle', () {
    var result = BoxTransformer.resize(
      resizeMode: ResizeMode.symmetric,
      initialFlip: Flip.none,
      initialBox: Box.fromLTWH(265.98, 201.13, 297.95, 229.12),
      handle: HandlePosition.topRight,
      initialLocalPosition: Vector2(15.48, 12.73),
      flipRect: true,
      localPosition: Vector2(164.67, 38.25),
      clampingRect: Box.fromLTWH(66.74, 61.60, 589.63, 822.26),
    );

    expect(result.flip, Flip.none);
    expect(result.rect,
        withTolerance(Box.fromLTWH(173.55, 226.64, 482.83, 178.09)));
    expect(result.resizeMode, ResizeMode.symmetric);

    result = BoxTransformer.resize(
      resizeMode: ResizeMode.symmetric,
      initialFlip: Flip.none,
      initialBox: Box.fromLTWH(173.55, 226.64, 482.83, 178.09),
      handle: HandlePosition.topRight,
      initialLocalPosition: Vector2(16.14, 11.05),
      flipRect: true,
      localPosition: Vector2(-103.98, -193.86),
      clampingRect: Box.fromLTWH(66.74, 61.60, 589.63, 822.26),
    );

    expect(result.flip, Flip.none);
    expect(result.rect,
        withTolerance(Box.fromLTWH(293.66, 61.60, 242.59, 508.18)));
    expect(result.resizeMode, ResizeMode.symmetric);

    result = BoxTransformer.resize(
      resizeMode: ResizeMode.symmetric,
      initialFlip: Flip.none,
      initialBox: Box.fromLTWH(293.66, 61.60, 242.59, 508.18),
      handle: HandlePosition.topRight,
      initialLocalPosition: Vector2(13.03, 14.30),
      flipRect: true,
      localPosition: Vector2(186.38, -29.18),
      clampingRect: Box.fromLTWH(66.74, 61.60, 589.63, 822.26),
    );

    expect(result.flip, Flip.none);
    expect(result.rect,
        withTolerance(Box.fromLTWH(173.55, 61.60, 482.83, 508.18)));
    expect(result.resizeMode, ResizeMode.symmetric);

    result = BoxTransformer.resize(
      resizeMode: ResizeMode.symmetric,
      initialFlip: Flip.none,
      initialBox: Box.fromLTWH(173.55, 61.60, 482.83, 508.18),
      handle: HandlePosition.topRight,
      initialLocalPosition: Vector2(10.29, 14.02),
      flipRect: true,
      localPosition: Vector2(-567.04, 360.91),
      clampingRect: Box.fromLTWH(66.74, 61.60, 589.63, 822.26),
    );

    expect(result.flip, Flip.diagonal);
    expect(result.rect,
        withTolerance(Box.fromLTWH(173.55, 222.89, 482.83, 185.61)));
    expect(result.resizeMode, ResizeMode.symmetric);

    result = BoxTransformer.resize(
      resizeMode: ResizeMode.symmetric,
      initialFlip: Flip.diagonal,
      initialBox: Box.fromLTWH(173.55, 222.89, 482.83, 185.61),
      handle: HandlePosition.bottomLeft,
      initialLocalPosition: Vector2(7.43, 12.63),
      flipRect: true,
      localPosition: Vector2(186.22, 226.75),
      clampingRect: Box.fromLTWH(66.74, 61.60, 589.63, 822.26),
    );

    expect(result.flip, Flip.diagonal);
    expect(result.rect,
        withTolerance(Box.fromLTWH(352.34, 61.60, 125.25, 508.18)));
    expect(result.resizeMode, ResizeMode.symmetric);

    result = BoxTransformer.resize(
      resizeMode: ResizeMode.symmetric,
      initialFlip: Flip.diagonal,
      initialBox: Box.fromLTWH(352.34, 61.60, 125.25, 508.18),
      handle: HandlePosition.bottomLeft,
      initialLocalPosition: Vector2(10.92, 15.93),
      flipRect: true,
      localPosition: Vector2(-259.01, 22.57),
      clampingRect: Box.fromLTWH(66.74, 61.60, 589.63, 822.26),
    );

    expect(result.flip, Flip.diagonal);
    expect(result.rect,
        withTolerance(Box.fromLTWH(173.55, 61.60, 482.83, 508.18)));
    expect(result.resizeMode, ResizeMode.symmetric);

    result = BoxTransformer.resize(
      resizeMode: ResizeMode.symmetric,
      initialFlip: Flip.diagonal,
      initialBox: Box.fromLTWH(173.55, 61.60, 482.83, 508.18),
      handle: HandlePosition.bottomLeft,
      initialLocalPosition: Vector2(13.04, 10.01),
      flipRect: true,
      localPosition: Vector2(530.01, -321.76),
      clampingRect: Box.fromLTWH(66.74, 61.60, 589.63, 822.26),
    );

    expect(result.flip, Flip.none);
    expect(result.rect,
        withTolerance(Box.fromLTWH(173.55, 238.01, 482.83, 155.36)));
    expect(result.resizeMode, ResizeMode.symmetric);

    result = BoxTransformer.resize(
      resizeMode: ResizeMode.symmetric,
      initialFlip: Flip.none,
      initialBox: Box.fromLTWH(173.55, 238.01, 482.83, 155.36),
      handle: HandlePosition.topRight,
      initialLocalPosition: Vector2(7.39, 12.54),
      flipRect: true,
      localPosition: Vector2(-79.46, -27.04),
      clampingRect: Box.fromLTWH(66.74, 61.60, 589.63, 822.26),
    );

    expect(result.flip, Flip.none);
    expect(result.rect,
        withTolerance(Box.fromLTWH(260.40, 198.44, 309.12, 234.50)));
    expect(result.resizeMode, ResizeMode.symmetric);
  });

  test('Clamped symmetric resizing with bottom-left handle', () {
    var result = BoxTransformer.resize(
      resizeMode: ResizeMode.symmetric,
      initialFlip: Flip.none,
      initialBox: Box.fromLTWH(239.69, 317.91, 309.12, 234.50),
      handle: HandlePosition.bottomLeft,
      initialLocalPosition: Vector2(14.23, 15.99),
      flipRect: true,
      localPosition: Vector2(-204.93, -9.05),
      clampingRect: Box.fromLTWH(66.74, 61.60, 589.63, 822.26),
    );

    expect(result.flip, Flip.none);
    expect(result.rect,
        withTolerance(Box.fromLTWH(132.12, 342.95, 524.26, 184.43)));
    expect(result.resizeMode, ResizeMode.symmetric);

    result = BoxTransformer.resize(
      resizeMode: ResizeMode.symmetric,
      initialFlip: Flip.none,
      initialBox: Box.fromLTWH(132.12, 342.95, 524.26, 184.43),
      handle: HandlePosition.bottomLeft,
      initialLocalPosition: Vector2(12.92, 11.14),
      flipRect: true,
      localPosition: Vector2(106.51, 321.16),
      clampingRect: Box.fromLTWH(66.74, 61.60, 589.63, 822.26),
    );

    expect(result.flip, Flip.none);
    expect(result.rect,
        withTolerance(Box.fromLTWH(225.71, 61.60, 337.08, 747.12)));
    expect(result.resizeMode, ResizeMode.symmetric);

    result = BoxTransformer.resize(
      resizeMode: ResizeMode.symmetric,
      initialFlip: Flip.none,
      initialBox: Box.fromLTWH(225.71, 61.60, 337.08, 747.12),
      handle: HandlePosition.bottomLeft,
      initialLocalPosition: Vector2(10.30, 13.84),
      flipRect: true,
      localPosition: Vector2(-191.82, 57.55),
      clampingRect: Box.fromLTWH(66.74, 61.60, 589.63, 822.26),
    );

    expect(result.flip, Flip.none);
    expect(result.rect,
        withTolerance(Box.fromLTWH(132.12, 61.60, 524.26, 747.12)));
    expect(result.resizeMode, ResizeMode.symmetric);

    result = BoxTransformer.resize(
      resizeMode: ResizeMode.symmetric,
      initialFlip: Flip.none,
      initialBox: Box.fromLTWH(132.12, 61.60, 524.26, 747.12),
      handle: HandlePosition.bottomLeft,
      initialLocalPosition: Vector2(13.25, 12.84),
      flipRect: true,
      localPosition: Vector2(597.91, -277.70),
      clampingRect: Box.fromLTWH(66.74, 61.60, 589.63, 822.26),
    );

    expect(result.flip, Flip.horizontal);
    expect(result.rect,
        withTolerance(Box.fromLTWH(132.12, 352.15, 524.26, 166.03)));
    expect(result.resizeMode, ResizeMode.symmetric);

    result = BoxTransformer.resize(
      resizeMode: ResizeMode.symmetric,
      initialFlip: Flip.horizontal,
      initialBox: Box.fromLTWH(132.12, 352.15, 524.26, 166.03),
      handle: HandlePosition.bottomRight,
      initialLocalPosition: Vector2(11.85, 12.27),
      flipRect: true,
      localPosition: Vector2(-123.18, -472.31),
      clampingRect: Box.fromLTWH(66.74, 61.60, 589.63, 822.26),
    );

    expect(result.flip, Flip.diagonal);
    expect(result.rect,
        withTolerance(Box.fromLTWH(267.14, 61.60, 254.20, 747.12)));
    expect(result.resizeMode, ResizeMode.symmetric);

    result = BoxTransformer.resize(
      resizeMode: ResizeMode.symmetric,
      initialFlip: Flip.diagonal,
      initialBox: Box.fromLTWH(267.14, 61.60, 254.20, 747.12),
      handle: HandlePosition.topRight,
      initialLocalPosition: Vector2(10.61, 13.56),
      flipRect: true,
      localPosition: Vector2(197.66, -30.91),
      clampingRect: Box.fromLTWH(66.74, 61.60, 589.63, 822.26),
    );

    expect(result.flip, Flip.diagonal);
    expect(result.rect,
        withTolerance(Box.fromLTWH(132.12, 61.60, 524.26, 747.12)));
    expect(result.resizeMode, ResizeMode.symmetric);

    result = BoxTransformer.resize(
      resizeMode: ResizeMode.symmetric,
      initialFlip: Flip.diagonal,
      initialBox: Box.fromLTWH(132.12, 61.60, 524.26, 747.12),
      handle: HandlePosition.topRight,
      initialLocalPosition: Vector2(9.77, 13.38),
      flipRect: true,
      localPosition: Vector2(-417.43, 500.80),
      clampingRect: Box.fromLTWH(66.74, 61.60, 589.63, 822.26),
    );

    expect(result.flip, Flip.none);
    expect(result.rect,
        withTolerance(Box.fromLTWH(229.17, 321.31, 330.15, 227.71)));
    expect(result.resizeMode, ResizeMode.symmetric);
  });

  test('Clamped symmetric resizing with right handle', () {
    var result = BoxTransformer.resize(
      resizeMode: ResizeMode.symmetric,
      initialFlip: Flip.none,
      initialBox: Box.fromLTWH(240.89, 407.69, 330.15, 227.71),
      handle: HandlePosition.right,
      initialLocalPosition: Vector2(14.37, 104.29),
      flipRect: true,
      localPosition: Vector2(202.06, 104.01),
      clampingRect: Box.fromLTWH(66.74, 61.60, 589.63, 822.26),
    );

    expect(result.flip, Flip.none);
    expect(result.rect,
        withTolerance(Box.fromLTWH(155.55, 407.69, 500.83, 227.71)));
    expect(result.resizeMode, ResizeMode.symmetric);

    result = BoxTransformer.resize(
      resizeMode: ResizeMode.symmetric,
      initialFlip: Flip.none,
      initialBox: Box.fromLTWH(155.55, 407.69, 500.83, 227.71),
      handle: HandlePosition.right,
      initialLocalPosition: Vector2(12.74, 103.01),
      flipRect: true,
      localPosition: Vector2(-123.51, 110.15),
      clampingRect: Box.fromLTWH(66.74, 61.60, 589.63, 822.26),
    );

    expect(result.flip, Flip.none);
    expect(result.rect,
        withTolerance(Box.fromLTWH(291.80, 407.69, 228.32, 227.71)));
    expect(result.resizeMode, ResizeMode.symmetric);

    result = BoxTransformer.resize(
      resizeMode: ResizeMode.symmetric,
      initialFlip: Flip.none,
      initialBox: Box.fromLTWH(291.80, 407.69, 228.32, 227.71),
      handle: HandlePosition.right,
      initialLocalPosition: Vector2(12.97, 110.14),
      flipRect: true,
      localPosition: Vector2(-252.09, 125.04),
      clampingRect: Box.fromLTWH(66.74, 61.60, 589.63, 822.26),
    );

    expect(result.flip, Flip.horizontal);
    expect(result.rect,
        withTolerance(Box.fromLTWH(255.06, 407.69, 301.80, 227.71)));
    expect(result.resizeMode, ResizeMode.symmetric);

    result = BoxTransformer.resize(
      resizeMode: ResizeMode.symmetric,
      initialFlip: Flip.horizontal,
      initialBox: Box.fromLTWH(255.06, 407.69, 301.80, 227.71),
      handle: HandlePosition.left,
      initialLocalPosition: Vector2(7.39, 108.12),
      flipRect: true,
      localPosition: Vector2(-208.88, 85.29),
      clampingRect: Box.fromLTWH(66.74, 61.60, 589.63, 822.26),
    );

    expect(result.flip, Flip.horizontal);
    expect(result.rect,
        withTolerance(Box.fromLTWH(155.55, 407.69, 500.83, 227.71)));
    expect(result.resizeMode, ResizeMode.symmetric);

    result = BoxTransformer.resize(
      resizeMode: ResizeMode.symmetric,
      initialFlip: Flip.horizontal,
      initialBox: Box.fromLTWH(155.55, 407.69, 500.83, 227.71),
      handle: HandlePosition.left,
      initialLocalPosition: Vector2(11.19, 95.69),
      flipRect: true,
      localPosition: Vector2(164.83, -100.11),
      clampingRect: Box.fromLTWH(66.74, 61.60, 589.63, 822.26),
    );

    expect(result.flip, Flip.diagonal);
    expect(result.rect,
        withTolerance(Box.fromLTWH(309.18, 407.69, 193.55, 227.71)));
    expect(result.resizeMode, ResizeMode.symmetric);

    result = BoxTransformer.resize(
      resizeMode: ResizeMode.symmetric,
      initialFlip: Flip.diagonal,
      initialBox: Box.fromLTWH(309.18, 407.69, 193.55, 227.71),
      handle: HandlePosition.left,
      initialLocalPosition: Vector2(13.94, 98.85),
      flipRect: true,
      localPosition: Vector2(254.52, -60.01),
      clampingRect: Box.fromLTWH(66.74, 61.60, 589.63, 822.26),
    );

    expect(result.flip, Flip.none);
    expect(result.rect,
        withTolerance(Box.fromLTWH(262.16, 407.69, 287.59, 227.71)));
    expect(result.resizeMode, ResizeMode.symmetric);
  });

  test('Clamped symmetric resizing with left handle', () {
    var result = BoxTransformer.resize(
      resizeMode: ResizeMode.symmetric,
      initialFlip: Flip.none,
      initialBox: Box.fromLTWH(262.16, 407.69, 287.59, 227.71),
      handle: HandlePosition.left,
      initialLocalPosition: Vector2(11.68, 102.12),
      flipRect: true,
      localPosition: Vector2(-228.21, 95.77),
      clampingRect: Box.fromLTWH(66.74, 61.60, 589.63, 822.26),
    );

    expect(result.flip, Flip.none);
    expect(result.rect,
        withTolerance(Box.fromLTWH(155.55, 407.69, 500.83, 227.71)));
    expect(result.resizeMode, ResizeMode.symmetric);

    result = BoxTransformer.resize(
      resizeMode: ResizeMode.symmetric,
      initialFlip: Flip.none,
      initialBox: Box.fromLTWH(155.55, 407.69, 500.83, 227.71),
      handle: HandlePosition.left,
      initialLocalPosition: Vector2(12.07, 98.00),
      flipRect: true,
      localPosition: Vector2(161.73, 98.90),
      clampingRect: Box.fromLTWH(66.74, 61.60, 589.63, 822.26),
    );

    expect(result.flip, Flip.none);
    expect(result.rect,
        withTolerance(Box.fromLTWH(305.21, 407.69, 201.51, 227.71)));
    expect(result.resizeMode, ResizeMode.symmetric);

    result = BoxTransformer.resize(
      resizeMode: ResizeMode.symmetric,
      initialFlip: Flip.none,
      initialBox: Box.fromLTWH(305.21, 407.69, 201.51, 227.71),
      handle: HandlePosition.left,
      initialLocalPosition: Vector2(16.29, 106.59),
      flipRect: true,
      localPosition: Vector2(241.55, 99.34),
      clampingRect: Box.fromLTWH(66.74, 61.60, 589.63, 822.26),
    );

    expect(result.flip, Flip.horizontal);
    expect(result.rect,
        withTolerance(Box.fromLTWH(281.46, 407.69, 249.00, 227.71)));
    expect(result.resizeMode, ResizeMode.symmetric);

    result = BoxTransformer.resize(
      resizeMode: ResizeMode.symmetric,
      initialFlip: Flip.horizontal,
      initialBox: Box.fromLTWH(281.46, 407.69, 249.00, 227.71),
      handle: HandlePosition.right,
      initialLocalPosition: Vector2(14.39, 99.57),
      flipRect: true,
      localPosition: Vector2(213.96, 95.17),
      clampingRect: Box.fromLTWH(66.74, 61.60, 589.63, 822.26),
    );

    expect(result.flip, Flip.horizontal);
    expect(result.rect,
        withTolerance(Box.fromLTWH(155.55, 407.69, 500.83, 227.71)));
    expect(result.resizeMode, ResizeMode.symmetric);

    result = BoxTransformer.resize(
      resizeMode: ResizeMode.symmetric,
      initialFlip: Flip.horizontal,
      initialBox: Box.fromLTWH(155.55, 407.69, 500.83, 227.71),
      handle: HandlePosition.right,
      initialLocalPosition: Vector2(12.77, 102.41),
      flipRect: true,
      localPosition: Vector2(-392.91, 119.10),
      clampingRect: Box.fromLTWH(66.74, 61.60, 589.63, 822.26),
    );

    expect(result.flip, Flip.none);
    expect(result.rect,
        withTolerance(Box.fromLTWH(250.70, 407.69, 310.52, 227.71)));
    expect(result.resizeMode, ResizeMode.symmetric);

    result = BoxTransformer.resize(
      resizeMode: ResizeMode.symmetric,
      initialFlip: Flip.none,
      initialBox: Box.fromLTWH(250.70, 407.69, 310.52, 227.71),
      handle: HandlePosition.left,
      initialLocalPosition: Vector2(11.33, 113.84),
      flipRect: true,
      localPosition: Vector2(-188.21, -83.64),
      clampingRect: Box.fromLTWH(66.74, 61.60, 589.63, 822.26),
    );

    expect(result.flip, Flip.vertical);
    expect(result.rect,
        withTolerance(Box.fromLTWH(155.55, 407.69, 500.83, 227.71)));
    expect(result.resizeMode, ResizeMode.symmetric);

    result = BoxTransformer.resize(
      resizeMode: ResizeMode.symmetric,
      initialFlip: Flip.vertical,
      initialBox: Box.fromLTWH(155.55, 407.69, 500.83, 227.71),
      handle: HandlePosition.left,
      initialLocalPosition: Vector2(14.28, 101.54),
      flipRect: true,
      localPosition: Vector2(409.29, -78.94),
      clampingRect: Box.fromLTWH(66.74, 61.60, 589.63, 822.26),
    );

    expect(result.flip, Flip.horizontal);
    expect(result.rect,
        withTolerance(Box.fromLTWH(261.36, 407.69, 289.20, 227.71)));
    expect(result.resizeMode, ResizeMode.symmetric);

    result = BoxTransformer.resize(
      resizeMode: ResizeMode.symmetric,
      initialFlip: Flip.horizontal,
      initialBox: Box.fromLTWH(261.36, 407.69, 289.20, 227.71),
      handle: HandlePosition.right,
      initialLocalPosition: Vector2(16.23, 102.30),
      flipRect: true,
      localPosition: Vector2(-278.24, 109.30),
      clampingRect: Box.fromLTWH(66.74, 61.60, 589.63, 822.26),
    );

    expect(result.flip, Flip.none);
    expect(result.rect,
        withTolerance(Box.fromLTWH(256.09, 407.69, 299.73, 227.71)));
    expect(result.resizeMode, ResizeMode.symmetric);
  });

  test('Clamped symmetric resizing with top handle', () {
    var result = BoxTransformer.resize(
      resizeMode: ResizeMode.symmetric,
      initialFlip: Flip.none,
      initialBox: Box.fromLTWH(256.09, 407.69, 299.73, 227.71),
      handle: HandlePosition.top,
      initialLocalPosition: Vector2(137.51, 12.85),
      flipRect: true,
      localPosition: Vector2(124.89, -313.61),
      clampingRect: Box.fromLTWH(66.74, 61.60, 589.63, 822.26),
    );

    expect(result.flip, Flip.none);
    expect(result.rect,
        withTolerance(Box.fromLTWH(256.09, 159.22, 299.73, 724.64)));
    expect(result.resizeMode, ResizeMode.symmetric);

    result = BoxTransformer.resize(
      resizeMode: ResizeMode.symmetric,
      initialFlip: Flip.none,
      initialBox: Box.fromLTWH(256.09, 159.22, 299.73, 724.64),
      handle: HandlePosition.top,
      initialLocalPosition: Vector2(136.35, 11.73),
      flipRect: true,
      localPosition: Vector2(149.56, 265.35),
      clampingRect: Box.fromLTWH(66.74, 61.60, 589.63, 822.26),
    );

    expect(result.flip, Flip.none);
    expect(result.rect,
        withTolerance(Box.fromLTWH(256.09, 412.84, 299.73, 217.41)));
    expect(result.resizeMode, ResizeMode.symmetric);

    result = BoxTransformer.resize(
      resizeMode: ResizeMode.symmetric,
      initialFlip: Flip.none,
      initialBox: Box.fromLTWH(256.09, 412.84, 299.73, 217.41),
      handle: HandlePosition.top,
      initialLocalPosition: Vector2(138.60, 10.98),
      flipRect: true,
      localPosition: Vector2(140.15, 239.89),
      clampingRect: Box.fromLTWH(66.74, 61.60, 589.63, 822.26),
    );

    expect(result.flip, Flip.vertical);
    expect(result.rect,
        withTolerance(Box.fromLTWH(256.09, 401.34, 299.73, 240.40)));
    expect(result.resizeMode, ResizeMode.symmetric);

    result = BoxTransformer.resize(
      resizeMode: ResizeMode.symmetric,
      initialFlip: Flip.vertical,
      initialBox: Box.fromLTWH(256.09, 401.34, 299.73, 240.40),
      handle: HandlePosition.bottom,
      initialLocalPosition: Vector2(140.60, 11.80),
      flipRect: true,
      localPosition: Vector2(130.77, 295.71),
      clampingRect: Box.fromLTWH(66.74, 61.60, 589.63, 822.26),
    );

    expect(result.flip, Flip.vertical);
    expect(result.rect,
        withTolerance(Box.fromLTWH(256.09, 159.22, 299.73, 724.64)));
    expect(result.resizeMode, ResizeMode.symmetric);

    result = BoxTransformer.resize(
      resizeMode: ResizeMode.symmetric,
      initialFlip: Flip.vertical,
      initialBox: Box.fromLTWH(256.09, 159.22, 299.73, 724.64),
      handle: HandlePosition.bottom,
      initialLocalPosition: Vector2(138.04, 15.23),
      flipRect: true,
      localPosition: Vector2(75.71, -457.04),
      clampingRect: Box.fromLTWH(66.74, 61.60, 589.63, 822.26),
    );

    expect(result.flip, Flip.none);
    expect(result.rect,
        withTolerance(Box.fromLTWH(256.09, 411.59, 299.73, 219.90)));
    expect(result.resizeMode, ResizeMode.symmetric);

    result = BoxTransformer.resize(
      resizeMode: ResizeMode.symmetric,
      initialFlip: Flip.none,
      initialBox: Box.fromLTWH(256.09, 411.59, 299.73, 219.90),
      handle: HandlePosition.top,
      initialLocalPosition: Vector2(138.72, 8.02),
      flipRect: true,
      localPosition: Vector2(-136.90, -12.13),
      clampingRect: Box.fromLTWH(66.74, 61.60, 589.63, 822.26),
    );

    expect(result.flip, Flip.horizontal);
    expect(result.rect,
        withTolerance(Box.fromLTWH(256.09, 391.44, 299.73, 260.20)));
    expect(result.resizeMode, ResizeMode.symmetric);

    result = BoxTransformer.resize(
      resizeMode: ResizeMode.symmetric,
      initialFlip: Flip.horizontal,
      initialBox: Box.fromLTWH(256.09, 391.44, 299.73, 260.20),
      handle: HandlePosition.top,
      initialLocalPosition: Vector2(136.71, 10.43),
      flipRect: true,
      localPosition: Vector2(-76.41, 251.61),
      clampingRect: Box.fromLTWH(66.74, 61.60, 589.63, 822.26),
    );

    expect(result.flip, Flip.vertical);
    expect(result.rect,
        withTolerance(Box.fromLTWH(256.09, 410.46, 299.73, 222.16)));
    expect(result.resizeMode, ResizeMode.symmetric);

    result = BoxTransformer.resize(
      resizeMode: ResizeMode.symmetric,
      initialFlip: Flip.vertical,
      initialBox: Box.fromLTWH(256.09, 410.46, 299.73, 222.16),
      handle: HandlePosition.bottom,
      initialLocalPosition: Vector2(148.58, 13.90),
      flipRect: true,
      localPosition: Vector2(135.28, -208.85),
      clampingRect: Box.fromLTWH(66.74, 61.60, 589.63, 822.26),
    );

    expect(result.flip, Flip.none);
    expect(result.rect,
        withTolerance(Box.fromLTWH(256.09, 409.87, 299.73, 223.34)));
    expect(result.resizeMode, ResizeMode.symmetric);
  });

  test('Clamped symmetric resizing with bottom handle', () {
    var result = BoxTransformer.resize(
      resizeMode: ResizeMode.symmetric,
      initialFlip: Flip.none,
      initialBox: Box.fromLTWH(256.09, 409.87, 299.73, 223.34),
      handle: HandlePosition.bottom,
      initialLocalPosition: Vector2(133.98, 13.73),
      flipRect: true,
      localPosition: Vector2(128.88, 121.77),
      clampingRect: Box.fromLTWH(66.74, 61.60, 589.63, 822.26),
    );

    expect(result.flip, Flip.none);
    expect(result.rect,
        withTolerance(Box.fromLTWH(256.09, 301.82, 299.73, 439.43)));
    expect(result.resizeMode, ResizeMode.symmetric);

    result = BoxTransformer.resize(
      resizeMode: ResizeMode.symmetric,
      initialFlip: Flip.none,
      initialBox: Box.fromLTWH(256.09, 301.82, 299.73, 439.43),
      handle: HandlePosition.bottom,
      initialLocalPosition: Vector2(142.23, 14.34),
      flipRect: true,
      localPosition: Vector2(143.42, 192.92),
      clampingRect: Box.fromLTWH(66.74, 61.60, 589.63, 822.26),
    );

    expect(result.flip, Flip.none);
    expect(result.rect,
        withTolerance(Box.fromLTWH(256.09, 159.22, 299.73, 724.64)));
    expect(result.resizeMode, ResizeMode.symmetric);

    result = BoxTransformer.resize(
      resizeMode: ResizeMode.symmetric,
      initialFlip: Flip.none,
      initialBox: Box.fromLTWH(256.09, 159.22, 299.73, 724.64),
      handle: HandlePosition.bottom,
      initialLocalPosition: Vector2(141.94, 16.96),
      flipRect: true,
      localPosition: Vector2(137.67, -434.48),
      clampingRect: Box.fromLTWH(66.74, 61.60, 589.63, 822.26),
    );

    expect(result.flip, Flip.vertical);
    expect(result.rect,
        withTolerance(Box.fromLTWH(256.09, 432.43, 299.73, 178.23)));
    expect(result.resizeMode, ResizeMode.symmetric);

    result = BoxTransformer.resize(
      resizeMode: ResizeMode.symmetric,
      initialFlip: Flip.vertical,
      initialBox: Box.fromLTWH(256.09, 432.43, 299.73, 178.23),
      handle: HandlePosition.top,
      initialLocalPosition: Vector2(141.65, 12.67),
      flipRect: true,
      localPosition: Vector2(133.75, -376.21),
      clampingRect: Box.fromLTWH(66.74, 61.60, 589.63, 822.26),
    );

    expect(result.flip, Flip.vertical);
    expect(result.rect,
        withTolerance(Box.fromLTWH(256.09, 159.22, 299.73, 724.64)));
    expect(result.resizeMode, ResizeMode.symmetric);

    result = BoxTransformer.resize(
      resizeMode: ResizeMode.symmetric,
      initialFlip: Flip.vertical,
      initialBox: Box.fromLTWH(256.09, 159.22, 299.73, 724.64),
      handle: HandlePosition.top,
      initialLocalPosition: Vector2(140.29, 12.44),
      flipRect: true,
      localPosition: Vector2(136.98, 489.60),
      clampingRect: Box.fromLTWH(66.74, 61.60, 589.63, 822.26),
    );

    expect(result.flip, Flip.none);
    expect(result.rect,
        withTolerance(Box.fromLTWH(256.09, 406.70, 299.73, 229.68)));
    expect(result.resizeMode, ResizeMode.symmetric);

    result = BoxTransformer.resize(
      resizeMode: ResizeMode.symmetric,
      initialFlip: Flip.none,
      initialBox: Box.fromLTWH(256.09, 406.70, 299.73, 229.68),
      handle: HandlePosition.bottom,
      initialLocalPosition: Vector2(142.84, 14.31),
      flipRect: true,
      localPosition: Vector2(-122.88, 72.71),
      clampingRect: Box.fromLTWH(66.74, 61.60, 589.63, 822.26),
    );

    expect(result.flip, Flip.horizontal);
    expect(result.rect,
        withTolerance(Box.fromLTWH(256.09, 348.30, 299.73, 346.48)));
    expect(result.resizeMode, ResizeMode.symmetric);

    result = BoxTransformer.resize(
      resizeMode: ResizeMode.symmetric,
      initialFlip: Flip.horizontal,
      initialBox: Box.fromLTWH(256.09, 348.30, 299.73, 346.48),
      handle: HandlePosition.bottom,
      initialLocalPosition: Vector2(134.25, 14.20),
      flipRect: true,
      localPosition: Vector2(-93.64, -272.14),
      clampingRect: Box.fromLTWH(66.74, 61.60, 589.63, 822.26),
    );

    expect(result.flip, Flip.vertical);
    expect(result.rect,
        withTolerance(Box.fromLTWH(256.09, 408.45, 299.73, 226.19)));
    expect(result.resizeMode, ResizeMode.symmetric);

    result = BoxTransformer.resize(
      resizeMode: ResizeMode.symmetric,
      initialFlip: Flip.vertical,
      initialBox: Box.fromLTWH(256.09, 408.45, 299.73, 226.19),
      handle: HandlePosition.top,
      initialLocalPosition: Vector2(135.27, 10.43),
      flipRect: true,
      localPosition: Vector2(124.38, 231.42),
      clampingRect: Box.fromLTWH(66.74, 61.60, 589.63, 822.26),
    );

    expect(result.flip, Flip.none);
    expect(result.rect,
        withTolerance(Box.fromLTWH(256.09, 413.64, 299.73, 215.79)));
    expect(result.resizeMode, ResizeMode.symmetric);
  });
}
