import 'package:test/test.dart';
import 'package:vector_math/vector_math.dart';
import 'package:box_transform/box_transform.dart';
import 'utils.dart';

void main() {
  test('Clamped scaled resizing with bottom-right handle', () {
    var result = BoxTransformer.resize(
      resizeMode: ResizeMode.scale,
      initialFlip: Flip.none,
      initialBox: Box.fromLTWH(250.63, 416.23, 299.73, 215.79),
      handle: HandlePosition.bottomRight,
      initialLocalPosition: Vector2(13.09, 15.01),
      allowBoxFlipping: true,
      localPosition: Vector2(179.96, 129.38),
      clampingRect: Box.fromLTWH(66.74, 61.60, 589.63, 822.26),
    );

    expect(result.flip, Flip.none);
    expect(result.rect,
        withTolerance(Box.fromLTWH(250.63, 416.23, 405.74, 292.11)));
    expect(result.resizeMode, ResizeMode.scale);

    result = BoxTransformer.resize(
      resizeMode: ResizeMode.scale,
      initialFlip: Flip.none,
      initialBox: Box.fromLTWH(250.63, 416.23, 405.74, 292.11),
      handle: HandlePosition.bottomRight,
      initialLocalPosition: Vector2(16.54, 12.79),
      allowBoxFlipping: true,
      localPosition: Vector2(-157.89, -122.32),
      clampingRect: Box.fromLTWH(66.74, 61.60, 589.63, 822.26),
    );

    expect(result.flip, Flip.none);
    expect(result.rect,
        withTolerance(Box.fromLTWH(250.63, 416.23, 231.30, 166.53)));
    expect(result.resizeMode, ResizeMode.scale);

    result = BoxTransformer.resize(
      resizeMode: ResizeMode.scale,
      initialFlip: Flip.none,
      initialBox: Box.fromLTWH(250.63, 416.23, 231.30, 166.53),
      handle: HandlePosition.bottomRight,
      initialLocalPosition: Vector2(15.04, 11.64),
      allowBoxFlipping: true,
      localPosition: Vector2(-317.13, -75.57),
      clampingRect: Box.fromLTWH(66.74, 61.60, 589.63, 822.26),
    );

    expect(result.flip, Flip.horizontal);
    expect(result.rect,
        withTolerance(Box.fromLTWH(140.46, 416.23, 110.17, 79.32)));
    expect(result.resizeMode, ResizeMode.scale);

    result = BoxTransformer.resize(
      resizeMode: ResizeMode.scale,
      initialFlip: Flip.horizontal,
      initialBox: Box.fromLTWH(140.46, 416.23, 110.17, 79.32),
      handle: HandlePosition.bottomLeft,
      initialLocalPosition: Vector2(15.29, 11.00),
      allowBoxFlipping: true,
      localPosition: Vector2(-123.42, 87.82),
      clampingRect: Box.fromLTWH(66.74, 61.60, 589.63, 822.26),
    );

    expect(result.flip, Flip.horizontal);
    expect(result.rect,
        withTolerance(Box.fromLTWH(66.74, 416.23, 183.89, 132.39)));
    expect(result.resizeMode, ResizeMode.scale);

    result = BoxTransformer.resize(
      resizeMode: ResizeMode.scale,
      initialFlip: Flip.horizontal,
      initialBox: Box.fromLTWH(66.74, 416.23, 183.89, 132.39),
      handle: HandlePosition.bottomLeft,
      initialLocalPosition: Vector2(12.67, 9.61),
      allowBoxFlipping: true,
      localPosition: Vector2(81.44, -201.16),
      clampingRect: Box.fromLTWH(66.74, 61.60, 589.63, 822.26),
    );

    expect(result.flip, Flip.diagonal);
    expect(result.rect,
        withTolerance(Box.fromLTWH(135.51, 333.35, 115.12, 82.88)));
    expect(result.resizeMode, ResizeMode.scale);

    result = BoxTransformer.resize(
      resizeMode: ResizeMode.scale,
      initialFlip: Flip.diagonal,
      initialBox: Box.fromLTWH(135.51, 333.35, 115.12, 82.88),
      handle: HandlePosition.topLeft,
      initialLocalPosition: Vector2(12.65, 13.57),
      allowBoxFlipping: true,
      localPosition: Vector2(-95.72, -92.98),
      clampingRect: Box.fromLTWH(66.74, 61.60, 589.63, 822.26),
    );

    expect(result.flip, Flip.diagonal);
    expect(result.rect,
        withTolerance(Box.fromLTWH(66.74, 283.84, 183.89, 132.39)));
    expect(result.resizeMode, ResizeMode.scale);

    result = BoxTransformer.resize(
      resizeMode: ResizeMode.scale,
      initialFlip: Flip.diagonal,
      initialBox: Box.fromLTWH(66.74, 283.84, 183.89, 132.39),
      handle: HandlePosition.topLeft,
      initialLocalPosition: Vector2(13.01, 13.32),
      allowBoxFlipping: true,
      localPosition: Vector2(420.71, 18.48),
      clampingRect: Box.fromLTWH(66.74, 61.60, 589.63, 822.26),
    );

    expect(result.flip, Flip.vertical);
    expect(result.rect,
        withTolerance(Box.fromLTWH(250.63, 255.10, 223.81, 161.13)));
    expect(result.resizeMode, ResizeMode.scale);

    result = BoxTransformer.resize(
      resizeMode: ResizeMode.scale,
      initialFlip: Flip.vertical,
      initialBox: Box.fromLTWH(250.63, 255.10, 223.81, 161.13),
      handle: HandlePosition.topRight,
      initialLocalPosition: Vector2(12.22, 12.43),
      allowBoxFlipping: true,
      localPosition: Vector2(246.29, -160.64),
      clampingRect: Box.fromLTWH(66.74, 61.60, 589.63, 822.26),
    );

    expect(result.flip, Flip.vertical);
    expect(result.rect,
        withTolerance(Box.fromLTWH(250.63, 124.12, 405.74, 292.11)));
    expect(result.resizeMode, ResizeMode.scale);

    result = BoxTransformer.resize(
      resizeMode: ResizeMode.scale,
      initialFlip: Flip.vertical,
      initialBox: Box.fromLTWH(250.63, 124.12, 405.74, 292.11),
      handle: HandlePosition.topRight,
      initialLocalPosition: Vector2(11.42, 12.47),
      allowBoxFlipping: true,
      localPosition: Vector2(-144.29, 479.09),
      clampingRect: Box.fromLTWH(66.74, 61.60, 589.63, 822.26),
    );

    expect(result.flip, Flip.none);
    expect(result.rect,
        withTolerance(Box.fromLTWH(250.63, 416.23, 250.03, 180.01)));
    expect(result.resizeMode, ResizeMode.scale);
  });

  test('Clamped scaled resizing with top-left handle', () {
    var result = BoxTransformer.resize(
      resizeMode: ResizeMode.scale,
      initialFlip: Flip.none,
      initialBox: Box.fromLTWH(179.25, 325.55, 250.03, 180.01),
      handle: HandlePosition.topLeft,
      initialLocalPosition: Vector2(12.29, 11.47),
      allowBoxFlipping: true,
      localPosition: Vector2(-135.38, -77.25),
      clampingRect: Box.fromLTWH(66.74, 61.60, 589.63, 822.26),
    );

    expect(result.flip, Flip.none);
    expect(result.rect,
        withTolerance(Box.fromLTWH(66.74, 244.56, 362.54, 261.01)));
    expect(result.resizeMode, ResizeMode.scale);

    result = BoxTransformer.resize(
      resizeMode: ResizeMode.scale,
      initialFlip: Flip.none,
      initialBox: Box.fromLTWH(66.74, 244.56, 362.54, 261.01),
      handle: HandlePosition.topLeft,
      initialLocalPosition: Vector2(12.28, 14.62),
      allowBoxFlipping: true,
      localPosition: Vector2(204.66, 141.07),
      clampingRect: Box.fromLTWH(66.74, 61.60, 589.63, 822.26),
    );

    expect(result.flip, Flip.none);
    expect(result.rect,
        withTolerance(Box.fromLTWH(242.37, 371.00, 186.90, 134.56)));
    expect(result.resizeMode, ResizeMode.scale);

    result = BoxTransformer.resize(
      resizeMode: ResizeMode.scale,
      initialFlip: Flip.none,
      initialBox: Box.fromLTWH(242.37, 371.00, 186.90, 134.56),
      handle: HandlePosition.topLeft,
      initialLocalPosition: Vector2(11.88, 10.01),
      allowBoxFlipping: true,
      localPosition: Vector2(326.06, 52.38),
      clampingRect: Box.fromLTWH(66.74, 61.60, 589.63, 822.26),
    );

    expect(result.flip, Flip.horizontal);
    expect(result.rect,
        withTolerance(Box.fromLTWH(429.28, 413.37, 128.06, 92.20)));
    expect(result.resizeMode, ResizeMode.scale);

    result = BoxTransformer.resize(
      resizeMode: ResizeMode.scale,
      initialFlip: Flip.horizontal,
      initialBox: Box.fromLTWH(429.28, 413.37, 128.06, 92.20),
      handle: HandlePosition.topRight,
      initialLocalPosition: Vector2(12.95, 11.87),
      allowBoxFlipping: true,
      localPosition: Vector2(147.29, -100.86),
      clampingRect: Box.fromLTWH(66.74, 61.60, 589.63, 822.26),
    );

    expect(result.flip, Flip.horizontal);
    expect(result.rect,
        withTolerance(Box.fromLTWH(429.28, 342.07, 227.10, 163.50)));
    expect(result.resizeMode, ResizeMode.scale);

    result = BoxTransformer.resize(
      resizeMode: ResizeMode.scale,
      initialFlip: Flip.horizontal,
      initialBox: Box.fromLTWH(429.28, 342.07, 227.10, 163.50),
      handle: HandlePosition.topRight,
      initialLocalPosition: Vector2(11.24, 12.40),
      allowBoxFlipping: true,
      localPosition: Vector2(-96.15, 261.42),
      clampingRect: Box.fromLTWH(66.74, 61.60, 589.63, 822.26),
    );

    expect(result.flip, Flip.diagonal);
    expect(result.rect,
        withTolerance(Box.fromLTWH(429.28, 505.56, 119.71, 86.18)));
    expect(result.resizeMode, ResizeMode.scale);

    result = BoxTransformer.resize(
      resizeMode: ResizeMode.scale,
      initialFlip: Flip.diagonal,
      initialBox: Box.fromLTWH(429.28, 505.56, 119.71, 86.18),
      handle: HandlePosition.bottomRight,
      initialLocalPosition: Vector2(12.81, 13.53),
      allowBoxFlipping: true,
      localPosition: Vector2(167.50, 99.16),
      clampingRect: Box.fromLTWH(66.74, 61.60, 589.63, 822.26),
    );

    expect(result.flip, Flip.diagonal);
    expect(result.rect,
        withTolerance(Box.fromLTWH(429.28, 505.56, 227.10, 163.50)));
    expect(result.resizeMode, ResizeMode.scale);

    result = BoxTransformer.resize(
      resizeMode: ResizeMode.scale,
      initialFlip: Flip.diagonal,
      initialBox: Box.fromLTWH(429.28, 505.56, 227.10, 163.50),
      handle: HandlePosition.bottomRight,
      initialLocalPosition: Vector2(11.08, 13.02),
      allowBoxFlipping: true,
      localPosition: Vector2(-408.57, -22.08),
      clampingRect: Box.fromLTWH(66.74, 61.60, 589.63, 822.26),
    );

    expect(result.flip, Flip.vertical);
    expect(result.rect,
        withTolerance(Box.fromLTWH(236.73, 505.56, 192.55, 138.63)));
    expect(result.resizeMode, ResizeMode.scale);

    result = BoxTransformer.resize(
      resizeMode: ResizeMode.scale,
      initialFlip: Flip.vertical,
      initialBox: Box.fromLTWH(236.73, 505.56, 192.55, 138.63),
      handle: HandlePosition.bottomLeft,
      initialLocalPosition: Vector2(12.02, 11.23),
      allowBoxFlipping: true,
      localPosition: Vector2(-219.80, 140.14),
      clampingRect: Box.fromLTWH(66.74, 61.60, 589.63, 822.26),
    );

    expect(result.flip, Flip.vertical);
    expect(result.rect,
        withTolerance(Box.fromLTWH(66.74, 505.56, 362.54, 261.01)));
    expect(result.resizeMode, ResizeMode.scale);

    result = BoxTransformer.resize(
      resizeMode: ResizeMode.scale,
      initialFlip: Flip.vertical,
      initialBox: Box.fromLTWH(66.74, 505.56, 362.54, 261.01),
      handle: HandlePosition.bottomLeft,
      initialLocalPosition: Vector2(12.05, 12.51),
      allowBoxFlipping: true,
      localPosition: Vector2(132.57, -435.95),
      clampingRect: Box.fromLTWH(66.74, 61.60, 589.63, 822.26),
    );

    expect(result.flip, Flip.none);
    expect(result.rect,
        withTolerance(Box.fromLTWH(168.92, 318.12, 260.36, 187.45)));
    expect(result.resizeMode, ResizeMode.scale);
  });

  test('Clamped scaled resizing with top-right handle', () {
    var result = BoxTransformer.resize(
      resizeMode: ResizeMode.scale,
      initialFlip: Flip.none,
      initialBox: Box.fromLTWH(271.79, 308.04, 260.36, 187.45),
      handle: HandlePosition.topRight,
      initialLocalPosition: Vector2(15.40, 13.84),
      allowBoxFlipping: true,
      localPosition: Vector2(182.34, -93.30),
      clampingRect: Box.fromLTWH(66.74, 61.60, 589.63, 822.26),
    );

    expect(result.flip, Flip.none);
    expect(result.rect,
        withTolerance(Box.fromLTWH(271.79, 218.61, 384.58, 276.88)));
    expect(result.resizeMode, ResizeMode.scale);

    result = BoxTransformer.resize(
      resizeMode: ResizeMode.scale,
      initialFlip: Flip.none,
      initialBox: Box.fromLTWH(271.79, 218.61, 384.58, 276.88),
      handle: HandlePosition.topRight,
      initialLocalPosition: Vector2(14.77, 13.04),
      allowBoxFlipping: true,
      localPosition: Vector2(-153.29, 115.84),
      clampingRect: Box.fromLTWH(66.74, 61.60, 589.63, 822.26),
    );

    expect(result.flip, Flip.none);
    expect(result.rect,
        withTolerance(Box.fromLTWH(271.79, 321.41, 241.79, 174.08)));
    expect(result.resizeMode, ResizeMode.scale);

    result = BoxTransformer.resize(
      resizeMode: ResizeMode.scale,
      initialFlip: Flip.none,
      initialBox: Box.fromLTWH(271.79, 321.41, 241.79, 174.08),
      handle: HandlePosition.topRight,
      initialLocalPosition: Vector2(15.51, 10.79),
      allowBoxFlipping: true,
      localPosition: Vector2(-317.54, 78.83),
      clampingRect: Box.fromLTWH(66.74, 61.60, 589.63, 822.26),
    );

    expect(result.flip, Flip.horizontal);
    expect(result.rect,
        withTolerance(Box.fromLTWH(124.51, 389.46, 147.28, 106.03)));
    expect(result.resizeMode, ResizeMode.scale);

    result = BoxTransformer.resize(
      resizeMode: ResizeMode.scale,
      initialFlip: Flip.horizontal,
      initialBox: Box.fromLTWH(124.51, 389.46, 147.28, 106.03),
      handle: HandlePosition.topLeft,
      initialLocalPosition: Vector2(12.34, 13.60),
      allowBoxFlipping: true,
      localPosition: Vector2(-125.37, -51.49),
      clampingRect: Box.fromLTWH(66.74, 61.60, 589.63, 822.26),
    );

    expect(result.flip, Flip.horizontal);
    expect(result.rect,
        withTolerance(Box.fromLTWH(66.74, 347.86, 205.05, 147.63)));
    expect(result.resizeMode, ResizeMode.scale);

    result = BoxTransformer.resize(
      resizeMode: ResizeMode.scale,
      initialFlip: Flip.horizontal,
      initialBox: Box.fromLTWH(66.74, 347.86, 205.05, 147.63),
      handle: HandlePosition.topLeft,
      initialLocalPosition: Vector2(10.08, 11.41),
      allowBoxFlipping: true,
      localPosition: Vector2(97.45, 254.67),
      clampingRect: Box.fromLTWH(66.74, 61.60, 589.63, 822.26),
    );

    expect(result.flip, Flip.diagonal);
    expect(result.rect,
        withTolerance(Box.fromLTWH(138.96, 495.49, 132.83, 95.63)));
    expect(result.resizeMode, ResizeMode.scale);

    result = BoxTransformer.resize(
      resizeMode: ResizeMode.scale,
      initialFlip: Flip.diagonal,
      initialBox: Box.fromLTWH(138.96, 495.49, 132.83, 95.63),
      handle: HandlePosition.bottomLeft,
      initialLocalPosition: Vector2(13.32, 13.23),
      allowBoxFlipping: true,
      localPosition: Vector2(-129.19, 107.71),
      clampingRect: Box.fromLTWH(66.74, 61.60, 589.63, 822.26),
    );

    expect(result.flip, Flip.diagonal);
    expect(result.rect,
        withTolerance(Box.fromLTWH(66.74, 495.49, 205.05, 147.63)));
    expect(result.resizeMode, ResizeMode.scale);

    result = BoxTransformer.resize(
      resizeMode: ResizeMode.scale,
      initialFlip: Flip.diagonal,
      initialBox: Box.fromLTWH(66.74, 495.49, 205.05, 147.63),
      handle: HandlePosition.bottomLeft,
      initialLocalPosition: Vector2(11.70, 8.63),
      allowBoxFlipping: true,
      localPosition: Vector2(403.94, 4.74),
      clampingRect: Box.fromLTWH(66.74, 61.60, 589.63, 822.26),
    );

    expect(result.flip, Flip.vertical);
    expect(result.rect,
        withTolerance(Box.fromLTWH(271.79, 495.49, 199.65, 143.74)));
    expect(result.resizeMode, ResizeMode.scale);

    result = BoxTransformer.resize(
      resizeMode: ResizeMode.scale,
      initialFlip: Flip.vertical,
      initialBox: Box.fromLTWH(271.79, 495.49, 199.65, 143.74),
      handle: HandlePosition.bottomRight,
      initialLocalPosition: Vector2(11.81, 13.41),
      allowBoxFlipping: true,
      localPosition: Vector2(286.07, 130.40),
      clampingRect: Box.fromLTWH(66.74, 61.60, 589.63, 822.26),
    );

    expect(result.flip, Flip.vertical);
    expect(result.rect,
        withTolerance(Box.fromLTWH(271.79, 495.49, 384.58, 276.88)));
    expect(result.resizeMode, ResizeMode.scale);

    result = BoxTransformer.resize(
      resizeMode: ResizeMode.scale,
      initialFlip: Flip.vertical,
      initialBox: Box.fromLTWH(271.79, 495.49, 384.58, 276.88),
      handle: HandlePosition.bottomRight,
      initialLocalPosition: Vector2(13.67, 10.91),
      allowBoxFlipping: true,
      localPosition: Vector2(-100.63, -441.93),
      clampingRect: Box.fromLTWH(66.74, 61.60, 589.63, 822.26),
    );

    expect(result.flip, Flip.none);
    expect(result.rect,
        withTolerance(Box.fromLTWH(271.79, 300.91, 270.28, 194.58)));
    expect(result.resizeMode, ResizeMode.scale);
  });

  test('Clamped scaled resizing with bottom-left handle', () {
    var result = BoxTransformer.resize(
      resizeMode: ResizeMode.scale,
      initialFlip: Flip.none,
      initialBox: Box.fromLTWH(209.76, 411.58, 270.28, 194.58),
      handle: HandlePosition.bottomLeft,
      initialLocalPosition: Vector2(10.39, 7.69),
      allowBoxFlipping: true,
      localPosition: Vector2(-188.52, 129.05),
      clampingRect: Box.fromLTWH(66.74, 61.60, 589.63, 822.26),
    );

    expect(result.flip, Flip.none);
    expect(result.rect,
        withTolerance(Box.fromLTWH(66.74, 411.58, 413.30, 297.55)));
    expect(result.resizeMode, ResizeMode.scale);

    result = BoxTransformer.resize(
      resizeMode: ResizeMode.scale,
      initialFlip: Flip.none,
      initialBox: Box.fromLTWH(66.74, 411.58, 413.30, 297.55),
      handle: HandlePosition.bottomLeft,
      initialLocalPosition: Vector2(12.16, 12.07),
      allowBoxFlipping: true,
      localPosition: Vector2(166.30, -124.22),
      clampingRect: Box.fromLTWH(66.74, 61.60, 589.63, 822.26),
    );

    expect(result.flip, Flip.none);
    expect(result.rect,
        withTolerance(Box.fromLTWH(220.88, 411.58, 259.16, 186.58)));
    expect(result.resizeMode, ResizeMode.scale);

    result = BoxTransformer.resize(
      resizeMode: ResizeMode.scale,
      initialFlip: Flip.none,
      initialBox: Box.fromLTWH(220.88, 411.58, 259.16, 186.58),
      handle: HandlePosition.bottomLeft,
      initialLocalPosition: Vector2(13.02, 8.08),
      allowBoxFlipping: true,
      localPosition: Vector2(354.21, -120.11),
      clampingRect: Box.fromLTWH(66.74, 61.60, 589.63, 822.26),
    );

    expect(result.flip, Flip.horizontal);
    expect(
        result.rect, withTolerance(Box.fromLTWH(480.04, 411.58, 82.03, 59.06)));
    expect(result.resizeMode, ResizeMode.scale);

    result = BoxTransformer.resize(
      resizeMode: ResizeMode.scale,
      initialFlip: Flip.horizontal,
      initialBox: Box.fromLTWH(480.04, 411.58, 82.03, 59.06),
      handle: HandlePosition.bottomRight,
      initialLocalPosition: Vector2(13.01, 13.74),
      allowBoxFlipping: true,
      localPosition: Vector2(163.59, 105.08),
      clampingRect: Box.fromLTWH(66.74, 61.60, 589.63, 822.26),
    );

    expect(result.flip, Flip.horizontal);
    expect(result.rect,
        withTolerance(Box.fromLTWH(480.04, 411.58, 176.34, 126.95)));
    expect(result.resizeMode, ResizeMode.scale);

    result = BoxTransformer.resize(
      resizeMode: ResizeMode.scale,
      initialFlip: Flip.horizontal,
      initialBox: Box.fromLTWH(480.04, 411.58, 176.34, 126.95),
      handle: HandlePosition.bottomRight,
      initialLocalPosition: Vector2(17.69, 15.69),
      allowBoxFlipping: true,
      localPosition: Vector2(-76.23, -176.99),
      clampingRect: Box.fromLTWH(66.74, 61.60, 589.63, 822.26),
    );

    expect(result.flip, Flip.diagonal);
    expect(
        result.rect, withTolerance(Box.fromLTWH(480.04, 345.86, 91.29, 65.72)));
    expect(result.resizeMode, ResizeMode.scale);

    result = BoxTransformer.resize(
      resizeMode: ResizeMode.scale,
      initialFlip: Flip.diagonal,
      initialBox: Box.fromLTWH(480.04, 345.86, 91.29, 65.72),
      handle: HandlePosition.topRight,
      initialLocalPosition: Vector2(14.44, 13.26),
      allowBoxFlipping: true,
      localPosition: Vector2(176.47, -54.73),
      clampingRect: Box.fromLTWH(66.74, 61.60, 589.63, 822.26),
    );

    expect(result.flip, Flip.diagonal);
    expect(result.rect,
        withTolerance(Box.fromLTWH(480.04, 284.63, 176.34, 126.95)));
    expect(result.resizeMode, ResizeMode.scale);

    result = BoxTransformer.resize(
      resizeMode: ResizeMode.scale,
      initialFlip: Flip.diagonal,
      initialBox: Box.fromLTWH(480.04, 284.63, 176.34, 126.95),
      handle: HandlePosition.topRight,
      initialLocalPosition: Vector2(14.33, 13.63),
      allowBoxFlipping: true,
      localPosition: Vector2(-655.38, -187.11),
      clampingRect: Box.fromLTWH(66.74, 61.60, 589.63, 822.26),
    );

    expect(result.flip, Flip.vertical);
    expect(result.rect,
        withTolerance(Box.fromLTWH(66.74, 114.03, 413.30, 297.55)));
    expect(result.resizeMode, ResizeMode.scale);

    result = BoxTransformer.resize(
      resizeMode: ResizeMode.scale,
      initialFlip: Flip.vertical,
      initialBox: Box.fromLTWH(66.74, 114.03, 413.30, 297.55),
      handle: HandlePosition.topLeft,
      initialLocalPosition: Vector2(14.58, 9.69),
      allowBoxFlipping: true,
      localPosition: Vector2(164.98, 109.36),
      clampingRect: Box.fromLTWH(66.74, 61.60, 589.63, 822.26),
    );

    expect(result.flip, Flip.vertical);
    expect(result.rect,
        withTolerance(Box.fromLTWH(205.17, 213.70, 274.86, 197.89)));
    expect(result.resizeMode, ResizeMode.scale);

    result = BoxTransformer.resize(
      resizeMode: ResizeMode.scale,
      initialFlip: Flip.vertical,
      initialBox: Box.fromLTWH(205.17, 213.70, 274.86, 197.89),
      handle: HandlePosition.topLeft,
      initialLocalPosition: Vector2(13.92, 7.44),
      allowBoxFlipping: true,
      localPosition: Vector2(28.49, 361.53),
      clampingRect: Box.fromLTWH(66.74, 61.60, 589.63, 822.26),
    );

    expect(result.flip, Flip.none);
    expect(result.rect,
        withTolerance(Box.fromLTWH(219.75, 411.58, 260.29, 187.40)));
    expect(result.resizeMode, ResizeMode.scale);
  });

  test('Clamped scaled resizing with right handle', () {
    var result = BoxTransformer.resize(
      resizeMode: ResizeMode.scale,
      initialFlip: Flip.none,
      initialBox: Box.fromLTWH(274.11, 371.52, 260.29, 187.40),
      handle: HandlePosition.right,
      initialLocalPosition: Vector2(14.98, 84.11),
      allowBoxFlipping: true,
      localPosition: Vector2(189.01, 71.81),
      clampingRect: Box.fromLTWH(66.74, 61.60, 589.63, 822.26),
    );

    expect(result.flip, Flip.none);
    expect(result.rect,
        withTolerance(Box.fromLTWH(274.11, 327.62, 382.26, 275.21)));
    expect(result.resizeMode, ResizeMode.scale);

    result = BoxTransformer.resize(
      resizeMode: ResizeMode.scale,
      initialFlip: Flip.none,
      initialBox: Box.fromLTWH(274.11, 327.62, 382.26, 275.21),
      handle: HandlePosition.right,
      initialLocalPosition: Vector2(16.07, 123.44),
      allowBoxFlipping: true,
      localPosition: Vector2(-168.37, 121.45),
      clampingRect: Box.fromLTWH(66.74, 61.60, 589.63, 822.26),
    );

    expect(result.flip, Flip.none);
    expect(result.rect,
        withTolerance(Box.fromLTWH(274.11, 394.01, 197.82, 142.42)));
    expect(result.resizeMode, ResizeMode.scale);

    result = BoxTransformer.resize(
      resizeMode: ResizeMode.scale,
      initialFlip: Flip.none,
      initialBox: Box.fromLTWH(274.11, 394.01, 197.82, 142.42),
      handle: HandlePosition.right,
      initialLocalPosition: Vector2(13.69, 61.85),
      allowBoxFlipping: true,
      localPosition: Vector2(-309.38, 63.24),
      clampingRect: Box.fromLTWH(66.74, 61.60, 589.63, 822.26),
    );

    expect(result.flip, Flip.horizontal);
    expect(result.rect,
        withTolerance(Box.fromLTWH(148.87, 420.14, 125.24, 90.17)));
    expect(result.resizeMode, ResizeMode.scale);

    result = BoxTransformer.resize(
      resizeMode: ResizeMode.scale,
      initialFlip: Flip.horizontal,
      initialBox: Box.fromLTWH(148.87, 420.14, 125.24, 90.17),
      handle: HandlePosition.left,
      initialLocalPosition: Vector2(11.34, 30.22),
      allowBoxFlipping: true,
      localPosition: Vector2(-166.79, 35.06),
      clampingRect: Box.fromLTWH(66.74, 61.60, 589.63, 822.26),
    );

    expect(result.flip, Flip.horizontal);
    expect(result.rect,
        withTolerance(Box.fromLTWH(66.74, 390.57, 207.37, 149.30)));
    expect(result.resizeMode, ResizeMode.scale);

    result = BoxTransformer.resize(
      resizeMode: ResizeMode.scale,
      initialFlip: Flip.horizontal,
      initialBox: Box.fromLTWH(66.74, 390.57, 207.37, 149.30),
      handle: HandlePosition.left,
      initialLocalPosition: Vector2(12.36, 60.20),
      allowBoxFlipping: true,
      localPosition: Vector2(488.13, 54.73),
      clampingRect: Box.fromLTWH(66.74, 61.60, 589.63, 822.26),
    );

    expect(result.flip, Flip.none);
    expect(result.rect,
        withTolerance(Box.fromLTWH(274.11, 368.61, 268.39, 193.23)));
    expect(result.resizeMode, ResizeMode.scale);

    result = BoxTransformer.resize(
      resizeMode: ResizeMode.scale,
      initialFlip: Flip.none,
      initialBox: Box.fromLTWH(274.11, 368.61, 268.39, 193.23),
      handle: HandlePosition.right,
      initialLocalPosition: Vector2(15.07, 84.47),
      allowBoxFlipping: true,
      localPosition: Vector2(7.27, -168.68),
      clampingRect: Box.fromLTWH(66.74, 61.60, 589.63, 822.26),
    );

    expect(result.flip, Flip.vertical);
    expect(result.rect,
        withTolerance(Box.fromLTWH(274.11, 371.42, 260.59, 187.61)));
    expect(result.resizeMode, ResizeMode.scale);

    result = BoxTransformer.resize(
      resizeMode: ResizeMode.scale,
      initialFlip: Flip.vertical,
      initialBox: Box.fromLTWH(274.11, 371.42, 260.59, 187.61),
      handle: HandlePosition.right,
      initialLocalPosition: Vector2(14.39, 85.28),
      allowBoxFlipping: true,
      localPosition: Vector2(71.49, -162.01),
      clampingRect: Box.fromLTWH(66.74, 61.60, 589.63, 822.26),
    );

    expect(result.flip, Flip.none);
    expect(result.rect,
        withTolerance(Box.fromLTWH(274.11, 350.86, 317.69, 228.72)));
    expect(result.resizeMode, ResizeMode.scale);
  });

  test('Clamped scaled resizing with left handle', () {
    var result = BoxTransformer.resize(
      resizeMode: ResizeMode.scale,
      initialFlip: Flip.none,
      initialBox: Box.fromLTWH(182.65, 395.26, 253.38, 189.73),
      handle: HandlePosition.left,
      initialLocalPosition: Vector2(14.21, 83.97),
      allowBoxFlipping: true,
      localPosition: Vector2(-172.42, 80.38),
      clampingRect: Box.fromLTWH(66.74, 61.60, 589.63, 822.26),
    );

    expect(result.flip, Flip.none);
    expect(result.rect,
        withTolerance(Box.fromLTWH(66.74, 351.86, 369.29, 276.52)));
    expect(result.resizeMode, ResizeMode.scale);

    result = BoxTransformer.resize(
      resizeMode: ResizeMode.scale,
      initialFlip: Flip.none,
      initialBox: Box.fromLTWH(66.74, 351.86, 369.29, 276.52),
      handle: HandlePosition.left,
      initialLocalPosition: Vector2(12.58, 125.50),
      allowBoxFlipping: true,
      localPosition: Vector2(158.75, 122.80),
      clampingRect: Box.fromLTWH(66.74, 61.60, 589.63, 822.26),
    );

    expect(result.flip, Flip.none);
    expect(result.rect,
        withTolerance(Box.fromLTWH(212.92, 406.59, 223.11, 167.06)));
    expect(result.resizeMode, ResizeMode.scale);

    result = BoxTransformer.resize(
      resizeMode: ResizeMode.scale,
      initialFlip: Flip.none,
      initialBox: Box.fromLTWH(212.92, 406.59, 223.11, 167.06),
      handle: HandlePosition.left,
      initialLocalPosition: Vector2(11.35, 73.65),
      allowBoxFlipping: true,
      localPosition: Vector2(369.10, 71.34),
      clampingRect: Box.fromLTWH(66.74, 61.60, 589.63, 822.26),
    );

    expect(result.flip, Flip.horizontal);
    expect(result.rect,
        withTolerance(Box.fromLTWH(436.03, 439.71, 134.64, 100.82)));
    expect(result.resizeMode, ResizeMode.scale);

    result = BoxTransformer.resize(
      resizeMode: ResizeMode.scale,
      initialFlip: Flip.horizontal,
      initialBox: Box.fromLTWH(436.03, 439.71, 134.64, 100.82),
      handle: HandlePosition.right,
      initialLocalPosition: Vector2(12.46, 38.41),
      allowBoxFlipping: true,
      localPosition: Vector2(151.00, 37.05),
      clampingRect: Box.fromLTWH(66.74, 61.60, 589.63, 822.26),
    );

    expect(result.flip, Flip.horizontal);
    expect(result.rect,
        withTolerance(Box.fromLTWH(436.03, 407.62, 220.35, 165.00)));
    expect(result.resizeMode, ResizeMode.scale);

    result = BoxTransformer.resize(
      resizeMode: ResizeMode.scale,
      initialFlip: Flip.horizontal,
      initialBox: Box.fromLTWH(436.03, 407.62, 220.35, 165.00),
      handle: HandlePosition.right,
      initialLocalPosition: Vector2(10.96, 72.14),
      allowBoxFlipping: true,
      localPosition: Vector2(-466.61, 76.00),
      clampingRect: Box.fromLTWH(66.74, 61.60, 589.63, 822.26),
    );

    expect(result.flip, Flip.none);
    expect(result.rect,
        withTolerance(Box.fromLTWH(178.80, 393.82, 257.22, 192.61)));
    expect(result.resizeMode, ResizeMode.scale);

    result = BoxTransformer.resize(
      resizeMode: ResizeMode.scale,
      initialFlip: Flip.none,
      initialBox: Box.fromLTWH(178.80, 393.82, 257.22, 192.61),
      handle: HandlePosition.left,
      initialLocalPosition: Vector2(14.71, 90.51),
      allowBoxFlipping: true,
      localPosition: Vector2(5.14, -134.78),
      clampingRect: Box.fromLTWH(66.74, 61.60, 589.63, 822.26),
    );

    expect(result.flip, Flip.vertical);
    expect(result.rect,
        withTolerance(Box.fromLTWH(169.23, 390.24, 266.79, 199.77)));
    expect(result.resizeMode, ResizeMode.scale);

    result = BoxTransformer.resize(
      resizeMode: ResizeMode.scale,
      initialFlip: Flip.vertical,
      initialBox: Box.fromLTWH(169.23, 390.24, 266.79, 199.77),
      handle: HandlePosition.left,
      initialLocalPosition: Vector2(12.20, 90.87),
      allowBoxFlipping: true,
      localPosition: Vector2(-32.36, -146.47),
      clampingRect: Box.fromLTWH(66.74, 61.60, 589.63, 822.26),
    );

    expect(result.flip, Flip.none);
    expect(result.rect,
        withTolerance(Box.fromLTWH(124.67, 373.55, 311.36, 233.14)));
    expect(result.resizeMode, ResizeMode.scale);
  });

  test('Clamped scaled resizing with bottom handle', () {
    var result = BoxTransformer.resize(
      resizeMode: ResizeMode.scale,
      initialFlip: Flip.none,
      initialBox: Box.fromLTWH(252.60, 422.09, 311.36, 233.14),
      handle: HandlePosition.bottom,
      initialLocalPosition: Vector2(146.36, 12.27),
      allowBoxFlipping: true,
      localPosition: Vector2(187.55, 226.38),
      clampingRect: Box.fromLTWH(66.74, 61.60, 589.63, 822.26),
    );

    expect(result.flip, Flip.none);
    expect(result.rect,
        withTolerance(Box.fromLTWH(160.19, 422.09, 496.19, 371.54)));
    expect(result.resizeMode, ResizeMode.scale);

    result = BoxTransformer.resize(
      resizeMode: ResizeMode.scale,
      initialFlip: Flip.none,
      initialBox: Box.fromLTWH(160.19, 422.09, 496.19, 371.54),
      handle: HandlePosition.bottom,
      initialLocalPosition: Vector2(237.79, 14.45),
      allowBoxFlipping: true,
      localPosition: Vector2(241.93, -120.68),
      clampingRect: Box.fromLTWH(66.74, 61.60, 589.63, 822.26),
    );

    expect(result.flip, Flip.none);
    expect(result.rect,
        withTolerance(Box.fromLTWH(250.42, 422.09, 315.73, 236.41)));
    expect(result.resizeMode, ResizeMode.scale);

    result = BoxTransformer.resize(
      resizeMode: ResizeMode.scale,
      initialFlip: Flip.none,
      initialBox: Box.fromLTWH(250.42, 422.09, 315.73, 236.41),
      handle: HandlePosition.bottom,
      initialLocalPosition: Vector2(149.35, 12.50),
      allowBoxFlipping: true,
      localPosition: Vector2(130.52, -375.21),
      clampingRect: Box.fromLTWH(66.74, 61.60, 589.63, 822.26),
    );

    expect(result.flip, Flip.vertical);
    expect(result.rect,
        withTolerance(Box.fromLTWH(307.25, 270.79, 202.06, 151.30)));
    expect(result.resizeMode, ResizeMode.scale);

    result = BoxTransformer.resize(
      resizeMode: ResizeMode.scale,
      initialFlip: Flip.vertical,
      initialBox: Box.fromLTWH(307.25, 270.79, 202.06, 151.30),
      handle: HandlePosition.top,
      initialLocalPosition: Vector2(87.36, 14.66),
      allowBoxFlipping: true,
      localPosition: Vector2(105.83, -280.87),
      clampingRect: Box.fromLTWH(66.74, 61.60, 589.63, 822.26),
    );

    expect(result.flip, Flip.vertical);
    expect(result.rect,
        withTolerance(Box.fromLTWH(167.57, 61.60, 481.43, 360.49)));
    expect(result.resizeMode, ResizeMode.scale);

    result = BoxTransformer.resize(
      resizeMode: ResizeMode.scale,
      initialFlip: Flip.vertical,
      initialBox: Box.fromLTWH(167.57, 61.60, 481.43, 360.49),
      handle: HandlePosition.top,
      initialLocalPosition: Vector2(228.07, 11.00),
      allowBoxFlipping: true,
      localPosition: Vector2(10.72, 598.88),
      clampingRect: Box.fromLTWH(66.74, 61.60, 589.63, 822.26),
    );

    expect(result.flip, Flip.none);
    expect(result.rect,
        withTolerance(Box.fromLTWH(256.45, 422.09, 303.67, 227.38)));
    expect(result.resizeMode, ResizeMode.scale);

    result = BoxTransformer.resize(
      resizeMode: ResizeMode.scale,
      initialFlip: Flip.none,
      initialBox: Box.fromLTWH(256.45, 422.09, 303.67, 227.38),
      handle: HandlePosition.bottom,
      initialLocalPosition: Vector2(147.59, 13.77),
      allowBoxFlipping: true,
      localPosition: Vector2(-193.65, -2.93),
      clampingRect: Box.fromLTWH(66.74, 61.60, 589.63, 822.26),
    );

    expect(result.flip, Flip.horizontal);
    expect(result.rect,
        withTolerance(Box.fromLTWH(267.60, 422.09, 281.37, 210.69)));
    expect(result.resizeMode, ResizeMode.scale);

    result = BoxTransformer.resize(
      resizeMode: ResizeMode.scale,
      initialFlip: Flip.horizontal,
      initialBox: Box.fromLTWH(267.60, 422.09, 281.37, 210.69),
      handle: HandlePosition.bottom,
      initialLocalPosition: Vector2(132.08, 12.70),
      allowBoxFlipping: true,
      localPosition: Vector2(-178.58, -389.58),
      clampingRect: Box.fromLTWH(66.74, 61.60, 589.63, 822.26),
    );

    expect(result.flip, Flip.vertical);
    expect(result.rect,
        withTolerance(Box.fromLTWH(280.35, 230.50, 255.86, 191.59)));
    expect(result.resizeMode, ResizeMode.scale);

    result = BoxTransformer.resize(
      resizeMode: ResizeMode.scale,
      initialFlip: Flip.vertical,
      initialBox: Box.fromLTWH(280.35, 230.50, 255.86, 191.59),
      handle: HandlePosition.top,
      initialLocalPosition: Vector2(114.67, 17.61),
      allowBoxFlipping: true,
      localPosition: Vector2(121.81, 430.81),
      clampingRect: Box.fromLTWH(66.74, 61.60, 589.63, 822.26),
    );

    expect(result.flip, Flip.none);
    expect(result.rect,
        withTolerance(Box.fromLTWH(260.30, 422.09, 295.96, 221.61)));
    expect(result.resizeMode, ResizeMode.scale);
  });

  test('Clamped scaled resizing with top handle', () {
    var result = BoxTransformer.resize(
      resizeMode: ResizeMode.scale,
      initialFlip: Flip.none,
      initialBox: Box.fromLTWH(144.84, 211.57, 295.96, 221.61),
      handle: HandlePosition.top,
      initialLocalPosition: Vector2(138.40, 12.61),
      allowBoxFlipping: true,
      localPosition: Vector2(136.62, -178.50),
      clampingRect: Box.fromLTWH(66.74, 61.60, 589.63, 822.26),
    );

    expect(result.flip, Flip.none);
    expect(
        result.rect, withTolerance(Box.fromLTWH(66.74, 94.61, 452.16, 338.57)));
    expect(result.resizeMode, ResizeMode.scale);

    result = BoxTransformer.resize(
      resizeMode: ResizeMode.scale,
      initialFlip: Flip.none,
      initialBox: Box.fromLTWH(66.74, 94.61, 452.16, 338.57),
      handle: HandlePosition.top,
      initialLocalPosition: Vector2(214.17, 12.29),
      allowBoxFlipping: true,
      localPosition: Vector2(193.07, 187.70),
      clampingRect: Box.fromLTWH(66.74, 61.60, 589.63, 822.26),
    );

    expect(result.flip, Flip.none);
    expect(result.rect,
        withTolerance(Box.fromLTWH(183.87, 270.03, 217.90, 163.16)));
    expect(result.resizeMode, ResizeMode.scale);

    result = BoxTransformer.resize(
      resizeMode: ResizeMode.scale,
      initialFlip: Flip.none,
      initialBox: Box.fromLTWH(183.87, 270.03, 217.90, 163.16),
      handle: HandlePosition.top,
      initialLocalPosition: Vector2(97.50, 11.08),
      allowBoxFlipping: true,
      localPosition: Vector2(77.11, 375.31),
      clampingRect: Box.fromLTWH(66.74, 61.60, 589.63, 822.26),
    );

    expect(result.flip, Flip.vertical);
    expect(result.rect,
        withTolerance(Box.fromLTWH(158.56, 433.19, 268.52, 201.07)));
    expect(result.resizeMode, ResizeMode.scale);

    result = BoxTransformer.resize(
      resizeMode: ResizeMode.scale,
      initialFlip: Flip.vertical,
      initialBox: Box.fromLTWH(158.56, 433.19, 268.52, 201.07),
      handle: HandlePosition.bottom,
      initialLocalPosition: Vector2(122.12, 12.28),
      allowBoxFlipping: true,
      localPosition: Vector2(109.92, 247.78),
      clampingRect: Box.fromLTWH(66.74, 61.60, 589.63, 822.26),
    );

    expect(result.flip, Flip.vertical);
    expect(result.rect,
        withTolerance(Box.fromLTWH(66.74, 433.19, 452.16, 338.57)));
    expect(result.resizeMode, ResizeMode.scale);

    result = BoxTransformer.resize(
      resizeMode: ResizeMode.scale,
      initialFlip: Flip.vertical,
      initialBox: Box.fromLTWH(66.74, 433.19, 452.16, 338.57),
      handle: HandlePosition.bottom,
      initialLocalPosition: Vector2(214.54, 13.62),
      allowBoxFlipping: true,
      localPosition: Vector2(216.44, -551.99),
      clampingRect: Box.fromLTWH(66.74, 61.60, 589.63, 822.26),
    );

    expect(result.flip, Flip.none);
    expect(result.rect,
        withTolerance(Box.fromLTWH(141.21, 206.14, 303.21, 227.04)));
    expect(result.resizeMode, ResizeMode.scale);

    result = BoxTransformer.resize(
      resizeMode: ResizeMode.scale,
      initialFlip: Flip.none,
      initialBox: Box.fromLTWH(141.21, 206.14, 303.21, 227.04),
      handle: HandlePosition.top,
      initialLocalPosition: Vector2(141.45, 13.89),
      allowBoxFlipping: true,
      localPosition: Vector2(215.25, 34.89),
      clampingRect: Box.fromLTWH(66.74, 61.60, 589.63, 822.26),
    );

    expect(result.flip, Flip.none);
    expect(result.rect,
        withTolerance(Box.fromLTWH(155.24, 227.15, 275.16, 206.04)));
    expect(result.resizeMode, ResizeMode.scale);

    result = BoxTransformer.resize(
      resizeMode: ResizeMode.scale,
      initialFlip: Flip.none,
      initialBox: Box.fromLTWH(155.24, 227.15, 275.16, 206.04),
      handle: HandlePosition.top,
      initialLocalPosition: Vector2(118.29, 14.29),
      allowBoxFlipping: true,
      localPosition: Vector2(-228.06, 76.41),
      clampingRect: Box.fromLTWH(66.74, 61.60, 589.63, 822.26),
    );

    expect(result.flip, Flip.horizontal);
    expect(result.rect,
        withTolerance(Box.fromLTWH(196.72, 289.26, 192.21, 143.92)));
    expect(result.resizeMode, ResizeMode.scale);

    result = BoxTransformer.resize(
      resizeMode: ResizeMode.scale,
      initialFlip: Flip.horizontal,
      initialBox: Box.fromLTWH(196.72, 289.26, 192.21, 143.92),
      handle: HandlePosition.top,
      initialLocalPosition: Vector2(90.04, 11.57),
      allowBoxFlipping: true,
      localPosition: Vector2(-186.15, -105.27),
      clampingRect: Box.fromLTWH(66.74, 61.60, 589.63, 822.26),
    );

    expect(result.flip, Flip.none);
    expect(result.rect,
        withTolerance(Box.fromLTWH(118.70, 172.42, 348.25, 260.77)));
    expect(result.resizeMode, ResizeMode.scale);
  });
}
