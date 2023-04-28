import 'package:test/test.dart';
import 'package:vector_math/vector_math.dart';
import 'package:box_transform/box_transform.dart';
import 'utils.dart';

void main() {
  test('Clamped symmetrically scaled resizing with bottom-right handle', () {
    var result = BoxTransformer.resize(
      resizeMode: ResizeMode.symmetricScale,
      initialFlip: Flip.none,
      initialBox: Box.fromLTWH(268.45, 413.00, 283.19, 213.11),
      handle: HandlePosition.bottomRight,
      initialLocalPosition: Vector2(13.57, 14.22),
      flipRect: true,
      localPosition: Vector2(163.54, 117.02),
      clampingRect: Box.fromLTWH(66.74, 61.60, 589.63, 822.26),
    );

    expect(result.flip, Flip.none);
    expect(result.rect,
        withTolerance(Box.fromLTWH(163.71, 334.18, 492.67, 370.74)));
    expect(result.resizeMode, ResizeMode.symmetricScale);

    result = BoxTransformer.resize(
      resizeMode: ResizeMode.symmetricScale,
      initialFlip: Flip.none,
      initialBox: Box.fromLTWH(163.71, 334.18, 492.67, 370.74),
      handle: HandlePosition.bottomRight,
      initialLocalPosition: Vector2(14.15, 9.35),
      flipRect: true,
      localPosition: Vector2(-142.14, -93.79),
      clampingRect: Box.fromLTWH(66.74, 61.60, 589.63, 822.26),
    );

    expect(result.flip, Flip.none);
    expect(result.rect,
        withTolerance(Box.fromLTWH(300.77, 437.32, 218.55, 164.46)));
    expect(result.resizeMode, ResizeMode.symmetricScale);

    result = BoxTransformer.resize(
      resizeMode: ResizeMode.symmetricScale,
      initialFlip: Flip.none,
      initialBox: Box.fromLTWH(300.77, 437.32, 218.55, 164.46),
      handle: HandlePosition.bottomRight,
      initialLocalPosition: Vector2(14.54, 12.80),
      flipRect: true,
      localPosition: Vector2(-418.40, 10.99),
      clampingRect: Box.fromLTWH(66.74, 61.60, 589.63, 822.26),
    );

    expect(result.flip, Flip.horizontal);
    expect(result.rect,
        withTolerance(Box.fromLTWH(163.71, 334.18, 492.67, 370.74)));
    expect(result.resizeMode, ResizeMode.symmetricScale);

    result = BoxTransformer.resize(
      resizeMode: ResizeMode.symmetricScale,
      initialFlip: Flip.horizontal,
      initialBox: Box.fromLTWH(163.71, 334.18, 492.67, 370.74),
      handle: HandlePosition.bottomLeft,
      initialLocalPosition: Vector2(8.43, 10.45),
      flipRect: true,
      localPosition: Vector2(387.26, -67.50),
      clampingRect: Box.fromLTWH(66.74, 61.60, 589.63, 822.26),
    );

    expect(result.flip, Flip.none);
    expect(result.rect,
        withTolerance(Box.fromLTWH(267.29, 412.13, 285.50, 214.85)));
    expect(result.resizeMode, ResizeMode.symmetricScale);

    result = BoxTransformer.resize(
      resizeMode: ResizeMode.symmetricScale,
      initialFlip: Flip.none,
      initialBox: Box.fromLTWH(267.29, 412.13, 285.50, 214.85),
      handle: HandlePosition.bottomRight,
      initialLocalPosition: Vector2(11.77, 14.20),
      flipRect: true,
      localPosition: Vector2(-5.60, -214.49),
      clampingRect: Box.fromLTWH(66.74, 61.60, 589.63, 822.26),
    );

    expect(result.flip, Flip.vertical);
    expect(result.rect,
        withTolerance(Box.fromLTWH(248.90, 398.29, 322.28, 242.52)));
    expect(result.resizeMode, ResizeMode.symmetricScale);

    result = BoxTransformer.resize(
      resizeMode: ResizeMode.symmetricScale,
      initialFlip: Flip.vertical,
      initialBox: Box.fromLTWH(248.90, 398.29, 322.28, 242.52),
      handle: HandlePosition.topRight,
      initialLocalPosition: Vector2(14.45, 13.13),
      flipRect: true,
      localPosition: Vector2(-9.84, 247.51),
      clampingRect: Box.fromLTWH(66.74, 61.60, 589.63, 822.26),
    );

    expect(result.flip, Flip.none);
    expect(result.rect,
        withTolerance(Box.fromLTWH(259.73, 406.45, 300.62, 226.22)));
    expect(result.resizeMode, ResizeMode.symmetricScale);
  });

  test('Clamped symmetrically scaled resizing with top-left handle', () {
    var result = BoxTransformer.resize(
      resizeMode: ResizeMode.symmetricScale,
      initialFlip: Flip.none,
      initialBox: Box.fromLTWH(259.73, 406.45, 300.62, 226.22),
      handle: HandlePosition.topLeft,
      initialLocalPosition: Vector2(11.62, 13.72),
      flipRect: true,
      localPosition: Vector2(-133.40, -90.38),
      clampingRect: Box.fromLTWH(66.74, 61.60, 589.63, 822.26),
    );

    expect(result.flip, Flip.none);
    expect(result.rect,
        withTolerance(Box.fromLTWH(163.71, 334.18, 492.67, 370.74)));
    expect(result.resizeMode, ResizeMode.symmetricScale);

    result = BoxTransformer.resize(
      resizeMode: ResizeMode.symmetricScale,
      initialFlip: Flip.none,
      initialBox: Box.fromLTWH(163.71, 334.18, 492.67, 370.74),
      handle: HandlePosition.topLeft,
      initialLocalPosition: Vector2(13.66, 11.73),
      flipRect: true,
      localPosition: Vector2(163.00, 122.39),
      clampingRect: Box.fromLTWH(66.74, 61.60, 589.63, 822.26),
    );

    expect(result.flip, Flip.none);
    expect(result.rect,
        withTolerance(Box.fromLTWH(310.76, 444.85, 198.55, 149.42)));
    expect(result.resizeMode, ResizeMode.symmetricScale);

    result = BoxTransformer.resize(
      resizeMode: ResizeMode.symmetricScale,
      initialFlip: Flip.none,
      initialBox: Box.fromLTWH(310.76, 444.85, 198.55, 149.42),
      handle: HandlePosition.topLeft,
      initialLocalPosition: Vector2(11.42, 10.72),
      flipRect: true,
      localPosition: Vector2(423.24, 309.66),
      clampingRect: Box.fromLTWH(66.74, 61.60, 589.63, 822.26),
    );

    expect(result.flip, Flip.diagonal);
    expect(result.rect,
        withTolerance(Box.fromLTWH(163.71, 334.18, 492.67, 370.74)));
    expect(result.resizeMode, ResizeMode.symmetricScale);

    result = BoxTransformer.resize(
      resizeMode: ResizeMode.symmetricScale,
      initialFlip: Flip.diagonal,
      initialBox: Box.fromLTWH(163.71, 334.18, 492.67, 370.74),
      handle: HandlePosition.bottomRight,
      initialLocalPosition: Vector2(7.27, 11.96),
      flipRect: true,
      localPosition: Vector2(-164.78, -100.89),
      clampingRect: Box.fromLTWH(66.74, 61.60, 589.63, 822.26),
    );

    expect(result.flip, Flip.diagonal);
    expect(result.rect,
        withTolerance(Box.fromLTWH(313.66, 447.03, 192.76, 145.06)));
    expect(result.resizeMode, ResizeMode.symmetricScale);

    result = BoxTransformer.resize(
      resizeMode: ResizeMode.symmetricScale,
      initialFlip: Flip.diagonal,
      initialBox: Box.fromLTWH(313.66, 447.03, 192.76, 145.06),
      handle: HandlePosition.bottomRight,
      initialLocalPosition: Vector2(14.71, 15.47),
      flipRect: true,
      localPosition: Vector2(-200.51, 22.61),
      clampingRect: Box.fromLTWH(66.74, 61.60, 589.63, 822.26),
    );

    expect(result.flip, Flip.vertical);
    expect(result.rect,
        withTolerance(Box.fromLTWH(291.21, 430.13, 237.67, 178.85)));
    expect(result.resizeMode, ResizeMode.symmetricScale);

    result = BoxTransformer.resize(
      resizeMode: ResizeMode.symmetricScale,
      initialFlip: Flip.vertical,
      initialBox: Box.fromLTWH(291.21, 430.13, 237.67, 178.85),
      handle: HandlePosition.bottomLeft,
      initialLocalPosition: Vector2(13.52, 14.39),
      flipRect: true,
      localPosition: Vector2(250.11, -155.66),
      clampingRect: Box.fromLTWH(66.74, 61.60, 589.63, 822.26),
    );

    expect(result.flip, Flip.horizontal);
    expect(result.rect,
        withTolerance(Box.fromLTWH(292.28, 430.94, 235.53, 177.24)));
    expect(result.resizeMode, ResizeMode.symmetricScale);

    result = BoxTransformer.resize(
      resizeMode: ResizeMode.symmetricScale,
      initialFlip: Flip.horizontal,
      initialBox: Box.fromLTWH(292.28, 430.94, 235.53, 177.24),
      handle: HandlePosition.topRight,
      initialLocalPosition: Vector2(15.14, 11.66),
      flipRect: true,
      localPosition: Vector2(-252.01, -4.48),
      clampingRect: Box.fromLTWH(66.74, 61.60, 589.63, 822.26),
    );

    expect(result.flip, Flip.none);
    expect(result.rect,
        withTolerance(Box.fromLTWH(260.65, 407.13, 298.79, 224.84)));
    expect(result.resizeMode, ResizeMode.symmetricScale);
  });

  test('Clamped symmetrically scaled resizing with top-right handle', () {
    var result = BoxTransformer.resize(
      resizeMode: ResizeMode.symmetricScale,
      initialFlip: Flip.none,
      initialBox: Box.fromLTWH(260.65, 407.13, 298.79, 224.84),
      handle: HandlePosition.topRight,
      initialLocalPosition: Vector2(14.58, 16.87),
      flipRect: true,
      localPosition: Vector2(157.92, -79.86),
      clampingRect: Box.fromLTWH(66.74, 61.60, 589.63, 822.26),
    );

    expect(result.flip, Flip.none);
    expect(result.rect,
        withTolerance(Box.fromLTWH(163.71, 334.18, 492.67, 370.74)));
    expect(result.resizeMode, ResizeMode.symmetricScale);

    result = BoxTransformer.resize(
      resizeMode: ResizeMode.symmetricScale,
      initialFlip: Flip.none,
      initialBox: Box.fromLTWH(163.71, 334.18, 492.67, 370.74),
      handle: HandlePosition.topRight,
      initialLocalPosition: Vector2(12.65, 13.21),
      flipRect: true,
      localPosition: Vector2(-169.14, 138.32),
      clampingRect: Box.fromLTWH(66.74, 61.60, 589.63, 822.26),
    );

    expect(result.flip, Flip.none);
    expect(result.rect,
        withTolerance(Box.fromLTWH(329.97, 459.30, 160.14, 120.51)));
    expect(result.resizeMode, ResizeMode.symmetricScale);

    result = BoxTransformer.resize(
      resizeMode: ResizeMode.symmetricScale,
      initialFlip: Flip.none,
      initialBox: Box.fromLTWH(329.97, 459.30, 160.14, 120.51),
      handle: HandlePosition.topRight,
      initialLocalPosition: Vector2(14.00, 13.63),
      flipRect: true,
      localPosition: Vector2(-169.28, 149.57),
      clampingRect: Box.fromLTWH(66.74, 61.60, 589.63, 822.26),
    );

    expect(result.flip, Flip.diagonal);
    expect(result.rect,
        withTolerance(Box.fromLTWH(306.83, 441.88, 206.43, 155.34)));
    expect(result.resizeMode, ResizeMode.symmetricScale);

    result = BoxTransformer.resize(
      resizeMode: ResizeMode.symmetricScale,
      initialFlip: Flip.diagonal,
      initialBox: Box.fromLTWH(306.83, 441.88, 206.43, 155.34),
      handle: HandlePosition.bottomLeft,
      initialLocalPosition: Vector2(14.47, 11.88),
      flipRect: true,
      localPosition: Vector2(-197.61, 162.13),
      clampingRect: Box.fromLTWH(66.74, 61.60, 589.63, 822.26),
    );

    expect(result.flip, Flip.diagonal);
    expect(result.rect,
        withTolerance(Box.fromLTWH(163.71, 334.18, 492.67, 370.74)));
    expect(result.resizeMode, ResizeMode.symmetricScale);

    result = BoxTransformer.resize(
      resizeMode: ResizeMode.symmetricScale,
      initialFlip: Flip.diagonal,
      initialBox: Box.fromLTWH(163.71, 334.18, 492.67, 370.74),
      handle: HandlePosition.bottomLeft,
      initialLocalPosition: Vector2(11.51, 11.79),
      flipRect: true,
      localPosition: Vector2(131.25, -258.53),
      clampingRect: Box.fromLTWH(66.74, 61.60, 589.63, 822.26),
    );

    expect(result.flip, Flip.horizontal);
    expect(result.rect,
        withTolerance(Box.fromLTWH(283.45, 424.30, 253.18, 190.52)));
    expect(result.resizeMode, ResizeMode.symmetricScale);

    result = BoxTransformer.resize(
      resizeMode: ResizeMode.symmetricScale,
      initialFlip: Flip.horizontal,
      initialBox: Box.fromLTWH(283.45, 424.30, 253.18, 190.52),
      handle: HandlePosition.topLeft,
      initialLocalPosition: Vector2(10.79, 11.38),
      flipRect: true,
      localPosition: Vector2(292.34, 217.22),
      clampingRect: Box.fromLTWH(66.74, 61.60, 589.63, 822.26),
    );

    expect(result.flip, Flip.vertical);
    expect(result.rect,
        withTolerance(Box.fromLTWH(255.09, 402.95, 309.91, 233.21)));
    expect(result.resizeMode, ResizeMode.symmetricScale);

    result = BoxTransformer.resize(
      resizeMode: ResizeMode.symmetricScale,
      initialFlip: Flip.vertical,
      initialBox: Box.fromLTWH(255.09, 402.95, 309.91, 233.21),
      handle: HandlePosition.bottomRight,
      initialLocalPosition: Vector2(11.46, 6.25),
      flipRect: true,
      localPosition: Vector2(1.57, -201.41),
      clampingRect: Box.fromLTWH(66.74, 61.60, 589.63, 822.26),
    );

    expect(result.flip, Flip.none);
    expect(result.rect,
        withTolerance(Box.fromLTWH(264.98, 410.39, 290.13, 218.33)));
    expect(result.resizeMode, ResizeMode.symmetricScale);
  });

  test('Clamped symmetrically scaled resizing with bottom-left handle', () {
    var result = BoxTransformer.resize(
      resizeMode: ResizeMode.symmetricScale,
      initialFlip: Flip.none,
      initialBox: Box.fromLTWH(264.98, 410.39, 290.13, 218.33),
      handle: HandlePosition.bottomLeft,
      initialLocalPosition: Vector2(11.09, 13.19),
      flipRect: true,
      localPosition: Vector2(-143.27, 140.77),
      clampingRect: Box.fromLTWH(66.74, 61.60, 589.63, 822.26),
    );

    expect(result.flip, Flip.none);
    expect(result.rect,
        withTolerance(Box.fromLTWH(163.71, 334.18, 492.67, 370.74)));
    expect(result.resizeMode, ResizeMode.symmetricScale);

    result = BoxTransformer.resize(
      resizeMode: ResizeMode.symmetricScale,
      initialFlip: Flip.none,
      initialBox: Box.fromLTWH(163.71, 334.18, 492.67, 370.74),
      handle: HandlePosition.bottomLeft,
      initialLocalPosition: Vector2(10.03, 9.40),
      flipRect: true,
      localPosition: Vector2(143.36, -84.88),
      clampingRect: Box.fromLTWH(66.74, 61.60, 589.63, 822.26),
    );

    expect(result.flip, Flip.none);
    expect(result.rect,
        withTolerance(Box.fromLTWH(288.99, 428.46, 242.10, 182.19)));
    expect(result.resizeMode, ResizeMode.symmetricScale);

    result = BoxTransformer.resize(
      resizeMode: ResizeMode.symmetricScale,
      initialFlip: Flip.none,
      initialBox: Box.fromLTWH(288.99, 428.46, 242.10, 182.19),
      handle: HandlePosition.bottomLeft,
      initialLocalPosition: Vector2(14.51, 13.08),
      flipRect: true,
      localPosition: Vector2(257.82, 8.94),
      clampingRect: Box.fromLTWH(66.74, 61.60, 589.63, 822.26),
    );

    expect(result.flip, Flip.horizontal);
    expect(result.rect,
        withTolerance(Box.fromLTWH(287.78, 427.56, 244.51, 184.00)));
    expect(result.resizeMode, ResizeMode.symmetricScale);

    result = BoxTransformer.resize(
      resizeMode: ResizeMode.symmetricScale,
      initialFlip: Flip.horizontal,
      initialBox: Box.fromLTWH(287.78, 427.56, 244.51, 184.00),
      handle: HandlePosition.bottomRight,
      initialLocalPosition: Vector2(16.38, 13.43),
      flipRect: true,
      localPosition: Vector2(15.50, -176.78),
      clampingRect: Box.fromLTWH(66.74, 61.60, 589.63, 822.26),
    );

    expect(result.flip, Flip.diagonal);
    expect(result.rect,
        withTolerance(Box.fromLTWH(279.54, 421.35, 261.00, 196.40)));
    expect(result.resizeMode, ResizeMode.symmetricScale);

    result = BoxTransformer.resize(
      resizeMode: ResizeMode.symmetricScale,
      initialFlip: Flip.diagonal,
      initialBox: Box.fromLTWH(279.54, 421.35, 261.00, 196.40),
      handle: HandlePosition.topRight,
      initialLocalPosition: Vector2(12.64, 15.77),
      flipRect: true,
      localPosition: Vector2(189.11, -130.00),
      clampingRect: Box.fromLTWH(66.74, 61.60, 589.63, 822.26),
    );

    expect(result.flip, Flip.diagonal);
    expect(result.rect,
        withTolerance(Box.fromLTWH(163.71, 334.18, 492.67, 370.74)));
    expect(result.resizeMode, ResizeMode.symmetricScale);

    result = BoxTransformer.resize(
      resizeMode: ResizeMode.symmetricScale,
      initialFlip: Flip.diagonal,
      initialBox: Box.fromLTWH(163.71, 334.18, 492.67, 370.74),
      handle: HandlePosition.topRight,
      initialLocalPosition: Vector2(10.89, 12.64),
      flipRect: true,
      localPosition: Vector2(-377.41, 96.26),
      clampingRect: Box.fromLTWH(66.74, 61.60, 589.63, 822.26),
    );

    expect(result.flip, Flip.vertical);
    expect(result.rect,
        withTolerance(Box.fromLTWH(268.07, 412.72, 283.95, 213.68)));
    expect(result.resizeMode, ResizeMode.symmetricScale);

    result = BoxTransformer.resize(
      resizeMode: ResizeMode.symmetricScale,
      initialFlip: Flip.vertical,
      initialBox: Box.fromLTWH(268.07, 412.72, 283.95, 213.68),
      handle: HandlePosition.topLeft,
      initialLocalPosition: Vector2(15.11, 12.72),
      flipRect: true,
      localPosition: Vector2(47.14, 209.13),
      clampingRect: Box.fromLTWH(66.74, 61.60, 589.63, 822.26),
    );

    expect(result.flip, Flip.none);
    expect(result.rect,
        withTolerance(Box.fromLTWH(291.02, 429.99, 238.05, 179.13)));
    expect(result.resizeMode, ResizeMode.symmetricScale);
  });

  test('Clamped symmetrically scaled resizing with right handle', () {
    var result = BoxTransformer.resize(
      resizeMode: ResizeMode.symmetricScale,
      initialFlip: Flip.none,
      initialBox: Box.fromLTWH(291.02, 429.99, 238.05, 179.13),
      handle: HandlePosition.right,
      initialLocalPosition: Vector2(15.74, 83.05),
      flipRect: true,
      localPosition: Vector2(337.98, 67.87),
      clampingRect: Box.fromLTWH(66.74, 61.60, 589.63, 822.26),
    );

    expect(result.flip, Flip.none);
    expect(result.rect,
        withTolerance(Box.fromLTWH(163.71, 334.18, 492.67, 370.74)));
    expect(result.resizeMode, ResizeMode.symmetricScale);

    result = BoxTransformer.resize(
      resizeMode: ResizeMode.symmetricScale,
      initialFlip: Flip.none,
      initialBox: Box.fromLTWH(163.71, 334.18, 492.67, 370.74),
      handle: HandlePosition.right,
      initialLocalPosition: Vector2(15.34, 177.28),
      flipRect: true,
      localPosition: Vector2(-136.35, 193.80),
      clampingRect: Box.fromLTWH(66.74, 61.60, 589.63, 822.26),
    );

    expect(result.flip, Flip.none);
    expect(result.rect,
        withTolerance(Box.fromLTWH(315.40, 448.34, 189.28, 142.44)));
    expect(result.resizeMode, ResizeMode.symmetricScale);

    result = BoxTransformer.resize(
      resizeMode: ResizeMode.symmetricScale,
      initialFlip: Flip.none,
      initialBox: Box.fromLTWH(315.40, 448.34, 189.28, 142.44),
      handle: HandlePosition.right,
      initialLocalPosition: Vector2(13.91, 67.97),
      flipRect: true,
      localPosition: Vector2(-220.29, 43.88),
      clampingRect: Box.fromLTWH(66.74, 61.60, 589.63, 822.26),
    );

    expect(result.flip, Flip.horizontal);
    expect(result.rect,
        withTolerance(Box.fromLTWH(270.48, 414.53, 279.13, 210.05)));
    expect(result.resizeMode, ResizeMode.symmetricScale);

    result = BoxTransformer.resize(
      resizeMode: ResizeMode.symmetricScale,
      initialFlip: Flip.horizontal,
      initialBox: Box.fromLTWH(270.48, 414.53, 279.13, 210.05),
      handle: HandlePosition.left,
      initialLocalPosition: Vector2(11.05, 89.41),
      flipRect: true,
      localPosition: Vector2(-243.79, 99.14),
      clampingRect: Box.fromLTWH(66.74, 61.60, 589.63, 822.26),
    );

    expect(result.flip, Flip.horizontal);
    expect(result.rect,
        withTolerance(Box.fromLTWH(163.71, 334.18, 492.67, 370.74)));
    expect(result.resizeMode, ResizeMode.symmetricScale);

    result = BoxTransformer.resize(
      resizeMode: ResizeMode.symmetricScale,
      initialFlip: Flip.horizontal,
      initialBox: Box.fromLTWH(163.71, 334.18, 492.67, 370.74),
      handle: HandlePosition.left,
      initialLocalPosition: Vector2(9.96, 172.98),
      flipRect: true,
      localPosition: Vector2(384.78, 176.19),
      clampingRect: Box.fromLTWH(66.74, 61.60, 589.63, 822.26),
    );

    expect(result.flip, Flip.none);
    expect(result.rect,
        withTolerance(Box.fromLTWH(281.55, 422.87, 256.97, 193.38)));
    expect(result.resizeMode, ResizeMode.symmetricScale);

    result = BoxTransformer.resize(
      resizeMode: ResizeMode.symmetricScale,
      initialFlip: Flip.none,
      initialBox: Box.fromLTWH(281.55, 422.87, 256.97, 193.38),
      handle: HandlePosition.right,
      initialLocalPosition: Vector2(15.58, 89.15),
      flipRect: true,
      localPosition: Vector2(53.36, -152.78),
      clampingRect: Box.fromLTWH(66.74, 61.60, 589.63, 822.26),
    );

    expect(result.flip, Flip.vertical);
    expect(result.rect,
        withTolerance(Box.fromLTWH(243.78, 394.44, 332.52, 250.23)));
    expect(result.resizeMode, ResizeMode.symmetricScale);

    result = BoxTransformer.resize(
      resizeMode: ResizeMode.symmetricScale,
      initialFlip: Flip.vertical,
      initialBox: Box.fromLTWH(243.78, 394.44, 332.52, 250.23),
      handle: HandlePosition.right,
      initialLocalPosition: Vector2(14.26, 119.37),
      flipRect: true,
      localPosition: Vector2(20.52, -90.47),
      clampingRect: Box.fromLTWH(66.74, 61.60, 589.63, 822.26),
    );

    expect(result.flip, Flip.none);
    expect(result.rect,
        withTolerance(Box.fromLTWH(237.52, 389.73, 345.04, 259.65)));
    expect(result.resizeMode, ResizeMode.symmetricScale);
  });

  test('Clamped symmetrically scaled resizing with left handle', () {
    var result = BoxTransformer.resize(
      resizeMode: ResizeMode.symmetricScale,
      initialFlip: Flip.none,
      initialBox: Box.fromLTWH(237.52, 389.73, 345.04, 259.65),
      handle: HandlePosition.left,
      initialLocalPosition: Vector2(12.87, 120.87),
      flipRect: true,
      localPosition: Vector2(-249.10, 143.73),
      clampingRect: Box.fromLTWH(66.74, 61.60, 589.63, 822.26),
    );

    expect(result.flip, Flip.none);
    expect(result.rect,
        withTolerance(Box.fromLTWH(163.71, 334.18, 492.67, 370.74)));
    expect(result.resizeMode, ResizeMode.symmetricScale);

    result = BoxTransformer.resize(
      resizeMode: ResizeMode.symmetricScale,
      initialFlip: Flip.none,
      initialBox: Box.fromLTWH(163.71, 334.18, 492.67, 370.74),
      handle: HandlePosition.left,
      initialLocalPosition: Vector2(14.08, 173.36),
      flipRect: true,
      localPosition: Vector2(158.95, 166.88),
      clampingRect: Box.fromLTWH(66.74, 61.60, 589.63, 822.26),
    );

    expect(result.flip, Flip.none);
    expect(result.rect,
        withTolerance(Box.fromLTWH(308.57, 443.20, 202.93, 152.71)));
    expect(result.resizeMode, ResizeMode.symmetricScale);

    result = BoxTransformer.resize(
      resizeMode: ResizeMode.symmetricScale,
      initialFlip: Flip.none,
      initialBox: Box.fromLTWH(308.57, 443.20, 202.93, 152.71),
      handle: HandlePosition.left,
      initialLocalPosition: Vector2(11.46, 67.24),
      flipRect: true,
      localPosition: Vector2(245.91, 55.78),
      clampingRect: Box.fromLTWH(66.74, 61.60, 589.63, 822.26),
    );

    expect(result.flip, Flip.horizontal);
    expect(result.rect,
        withTolerance(Box.fromLTWH(277.06, 419.48, 265.96, 200.14)));
    expect(result.resizeMode, ResizeMode.symmetricScale);

    result = BoxTransformer.resize(
      resizeMode: ResizeMode.symmetricScale,
      initialFlip: Flip.horizontal,
      initialBox: Box.fromLTWH(277.06, 419.48, 265.96, 200.14),
      handle: HandlePosition.right,
      initialLocalPosition: Vector2(13.10, 89.81),
      flipRect: true,
      localPosition: Vector2(345.34, 67.01),
      clampingRect: Box.fromLTWH(66.74, 61.60, 589.63, 822.26),
    );

    expect(result.flip, Flip.horizontal);
    expect(result.rect,
        withTolerance(Box.fromLTWH(163.71, 334.18, 492.67, 370.74)));
    expect(result.resizeMode, ResizeMode.symmetricScale);

    result = BoxTransformer.resize(
      resizeMode: ResizeMode.symmetricScale,
      initialFlip: Flip.horizontal,
      initialBox: Box.fromLTWH(163.71, 334.18, 492.67, 370.74),
      handle: HandlePosition.right,
      initialLocalPosition: Vector2(9.89, 178.16),
      flipRect: true,
      localPosition: Vector2(-366.10, 186.67),
      clampingRect: Box.fromLTWH(66.74, 61.60, 589.63, 822.26),
    );

    expect(result.flip, Flip.none);
    expect(result.rect,
        withTolerance(Box.fromLTWH(280.38, 421.98, 259.32, 195.15)));
    expect(result.resizeMode, ResizeMode.symmetricScale);

    result = BoxTransformer.resize(
      resizeMode: ResizeMode.symmetricScale,
      initialFlip: Flip.none,
      initialBox: Box.fromLTWH(280.38, 421.98, 259.32, 195.15),
      handle: HandlePosition.left,
      initialLocalPosition: Vector2(15.48, 94.99),
      flipRect: true,
      localPosition: Vector2(8.44, -175.15),
      clampingRect: Box.fromLTWH(66.74, 61.60, 589.63, 822.26),
    );

    expect(result.flip, Flip.vertical);
    expect(result.rect,
        withTolerance(Box.fromLTWH(273.34, 416.69, 273.39, 205.74)));
    expect(result.resizeMode, ResizeMode.symmetricScale);

    result = BoxTransformer.resize(
      resizeMode: ResizeMode.symmetricScale,
      initialFlip: Flip.vertical,
      initialBox: Box.fromLTWH(273.34, 416.69, 273.39, 205.74),
      handle: HandlePosition.left,
      initialLocalPosition: Vector2(11.83, 97.39),
      flipRect: true,
      localPosition: Vector2(-49.34, -169.62),
      clampingRect: Box.fromLTWH(66.74, 61.60, 589.63, 822.26),
    );

    expect(result.flip, Flip.none);
    expect(result.rect,
        withTolerance(Box.fromLTWH(212.17, 370.65, 395.74, 297.80)));
    expect(result.resizeMode, ResizeMode.symmetricScale);

    result = BoxTransformer.resize(
      resizeMode: ResizeMode.symmetricScale,
      initialFlip: Flip.none,
      initialBox: Box.fromLTWH(212.17, 370.65, 395.74, 297.80),
      handle: HandlePosition.left,
      initialLocalPosition: Vector2(12.41, 134.62),
      flipRect: true,
      localPosition: Vector2(390.07, -72.34),
      clampingRect: Box.fromLTWH(66.74, 61.60, 589.63, 822.26),
    );

    expect(result.flip, Flip.diagonal);
    expect(result.rect,
        withTolerance(Box.fromLTWH(230.26, 384.26, 359.57, 270.58)));
    expect(result.resizeMode, ResizeMode.symmetricScale);

    result = BoxTransformer.resize(
      resizeMode: ResizeMode.symmetricScale,
      initialFlip: Flip.diagonal,
      initialBox: Box.fromLTWH(230.26, 384.26, 359.57, 270.58),
      handle: HandlePosition.right,
      initialLocalPosition: Vector2(17.21, 128.24),
      flipRect: true,
      localPosition: Vector2(-326.06, -88.66),
      clampingRect: Box.fromLTWH(66.74, 61.60, 589.63, 822.26),
    );

    expect(result.flip, Flip.none);
    expect(result.rect,
        withTolerance(Box.fromLTWH(246.55, 396.53, 326.97, 246.05)));
    expect(result.resizeMode, ResizeMode.symmetricScale);
  });

  test('Clamped symmetrically scaled resizing with bottom handle', () {
    var result = BoxTransformer.resize(
      resizeMode: ResizeMode.symmetricScale,
      initialFlip: Flip.none,
      initialBox: Box.fromLTWH(131.77, 394.39, 326.97, 246.05),
      handle: HandlePosition.bottom,
      initialLocalPosition: Vector2(153.37, 12.32),
      flipRect: true,
      localPosition: Vector2(145.63, 147.34),
      clampingRect: Box.fromLTWH(66.74, 61.60, 589.63, 822.26),
    );

    expect(result.flip, Flip.none);
    expect(result.rect,
        withTolerance(Box.fromLTWH(66.74, 345.46, 457.02, 343.92)));
    expect(result.resizeMode, ResizeMode.symmetricScale);

    result = BoxTransformer.resize(
      resizeMode: ResizeMode.symmetricScale,
      initialFlip: Flip.none,
      initialBox: Box.fromLTWH(66.74, 345.46, 457.02, 343.92),
      handle: HandlePosition.bottom,
      initialLocalPosition: Vector2(217.04, 14.31),
      flipRect: true,
      localPosition: Vector2(216.53, -101.53),
      clampingRect: Box.fromLTWH(66.74, 61.60, 589.63, 822.26),
    );

    expect(result.flip, Flip.none);
    expect(result.rect,
        withTolerance(Box.fromLTWH(220.68, 461.30, 149.15, 112.24)));
    expect(result.resizeMode, ResizeMode.symmetricScale);

    result = BoxTransformer.resize(
      resizeMode: ResizeMode.symmetricScale,
      initialFlip: Flip.none,
      initialBox: Box.fromLTWH(220.68, 461.30, 149.15, 112.24),
      handle: HandlePosition.bottom,
      initialLocalPosition: Vector2(65.88, 15.90),
      flipRect: true,
      localPosition: Vector2(53.16, -131.15),
      clampingRect: Box.fromLTWH(66.74, 61.60, 589.63, 822.26),
    );

    expect(result.flip, Flip.vertical);
    expect(result.rect,
        withTolerance(Box.fromLTWH(174.42, 426.49, 241.66, 181.86)));
    expect(result.resizeMode, ResizeMode.symmetricScale);

    result = BoxTransformer.resize(
      resizeMode: ResizeMode.symmetricScale,
      initialFlip: Flip.vertical,
      initialBox: Box.fromLTWH(174.42, 426.49, 241.66, 181.86),
      handle: HandlePosition.top,
      initialLocalPosition: Vector2(107.62, 13.98),
      flipRect: true,
      localPosition: Vector2(109.76, -179.95),
      clampingRect: Box.fromLTWH(66.74, 61.60, 589.63, 822.26),
    );

    expect(result.flip, Flip.vertical);
    expect(result.rect,
        withTolerance(Box.fromLTWH(66.74, 345.46, 457.02, 343.92)));
    expect(result.resizeMode, ResizeMode.symmetricScale);

    result = BoxTransformer.resize(
      resizeMode: ResizeMode.symmetricScale,
      initialFlip: Flip.vertical,
      initialBox: Box.fromLTWH(66.74, 345.46, 457.02, 343.92),
      handle: HandlePosition.top,
      initialLocalPosition: Vector2(216.86, 15.34),
      flipRect: true,
      localPosition: Vector2(197.84, 295.77),
      clampingRect: Box.fromLTWH(66.74, 61.60, 589.63, 822.26),
    );

    expect(result.flip, Flip.none);
    expect(result.rect,
        withTolerance(Box.fromLTWH(151.10, 408.94, 288.30, 216.95)));
    expect(result.resizeMode, ResizeMode.symmetricScale);

    result = BoxTransformer.resize(
      resizeMode: ResizeMode.symmetricScale,
      initialFlip: Flip.none,
      initialBox: Box.fromLTWH(151.10, 408.94, 288.30, 216.95),
      handle: HandlePosition.bottom,
      initialLocalPosition: Vector2(129.18, 14.30),
      flipRect: true,
      localPosition: Vector2(-137.90, 45.27),
      clampingRect: Box.fromLTWH(66.74, 61.60, 589.63, 822.26),
    );

    expect(result.flip, Flip.horizontal);
    expect(result.rect,
        withTolerance(Box.fromLTWH(109.96, 377.98, 370.59, 278.88)));
    expect(result.resizeMode, ResizeMode.symmetricScale);

    result = BoxTransformer.resize(
      resizeMode: ResizeMode.symmetricScale,
      initialFlip: Flip.horizontal,
      initialBox: Box.fromLTWH(109.96, 377.98, 370.59, 278.88),
      handle: HandlePosition.bottom,
      initialLocalPosition: Vector2(178.22, 15.48),
      flipRect: true,
      localPosition: Vector2(-50.20, -233.22),
      clampingRect: Box.fromLTWH(66.74, 61.60, 589.63, 822.26),
    );

    expect(result.flip, Flip.vertical);
    expect(result.rect,
        withTolerance(Box.fromLTWH(150.06, 408.15, 290.39, 218.53)));
    expect(result.resizeMode, ResizeMode.symmetricScale);

    result = BoxTransformer.resize(
      resizeMode: ResizeMode.symmetricScale,
      initialFlip: Flip.vertical,
      initialBox: Box.fromLTWH(150.06, 408.15, 290.39, 218.53),
      handle: HandlePosition.top,
      initialLocalPosition: Vector2(132.93, 13.72),
      flipRect: true,
      localPosition: Vector2(180.35, 234.57),
      clampingRect: Box.fromLTWH(66.74, 61.60, 589.63, 822.26),
    );

    expect(result.flip, Flip.none);
    expect(result.rect,
        withTolerance(Box.fromLTWH(146.96, 405.82, 296.58, 223.18)));
    expect(result.resizeMode, ResizeMode.symmetricScale);
  });

  test('Clamped symmetrically scaled resizing with top handle', () {
    var result = BoxTransformer.resize(
      resizeMode: ResizeMode.symmetricScale,
      initialFlip: Flip.none,
      initialBox: Box.fromLTWH(146.96, 405.82, 296.58, 223.18),
      handle: HandlePosition.top,
      initialLocalPosition: Vector2(137.92, 12.05),
      flipRect: true,
      localPosition: Vector2(142.48, -169.09),
      clampingRect: Box.fromLTWH(66.74, 61.60, 589.63, 822.26),
    );

    expect(result.flip, Flip.none);
    expect(result.rect,
        withTolerance(Box.fromLTWH(66.74, 345.46, 457.02, 343.92)));
    expect(result.resizeMode, ResizeMode.symmetricScale);

    result = BoxTransformer.resize(
      resizeMode: ResizeMode.symmetricScale,
      initialFlip: Flip.none,
      initialBox: Box.fromLTWH(66.74, 345.46, 457.02, 343.92),
      handle: HandlePosition.top,
      initialLocalPosition: Vector2(217.18, 10.95),
      flipRect: true,
      localPosition: Vector2(214.80, 99.31),
      clampingRect: Box.fromLTWH(66.74, 61.60, 589.63, 822.26),
    );

    expect(result.flip, Flip.none);
    expect(result.rect,
        withTolerance(Box.fromLTWH(184.16, 433.82, 222.18, 167.20)));
    expect(result.resizeMode, ResizeMode.symmetricScale);

    result = BoxTransformer.resize(
      resizeMode: ResizeMode.symmetricScale,
      initialFlip: Flip.none,
      initialBox: Box.fromLTWH(184.16, 433.82, 222.18, 167.20),
      handle: HandlePosition.top,
      initialLocalPosition: Vector2(102.51, 14.68),
      flipRect: true,
      localPosition: Vector2(108.56, 185.66),
      clampingRect: Box.fromLTWH(66.74, 61.60, 589.63, 822.26),
    );

    expect(result.flip, Flip.vertical);
    expect(result.rect,
        withTolerance(Box.fromLTWH(179.14, 430.04, 232.21, 174.75)));
    expect(result.resizeMode, ResizeMode.symmetricScale);

    result = BoxTransformer.resize(
      resizeMode: ResizeMode.symmetricScale,
      initialFlip: Flip.vertical,
      initialBox: Box.fromLTWH(179.14, 430.04, 232.21, 174.75),
      handle: HandlePosition.bottom,
      initialLocalPosition: Vector2(108.57, 12.68),
      flipRect: true,
      localPosition: Vector2(107.82, 163.00),
      clampingRect: Box.fromLTWH(66.74, 61.60, 589.63, 822.26),
    );

    expect(result.flip, Flip.vertical);
    expect(result.rect,
        withTolerance(Box.fromLTWH(66.74, 345.46, 457.02, 343.92)));
    expect(result.resizeMode, ResizeMode.symmetricScale);

    result = BoxTransformer.resize(
      resizeMode: ResizeMode.symmetricScale,
      initialFlip: Flip.vertical,
      initialBox: Box.fromLTWH(66.74, 345.46, 457.02, 343.92),
      handle: HandlePosition.bottom,
      initialLocalPosition: Vector2(215.20, 12.99),
      flipRect: true,
      localPosition: Vector2(198.04, -261.76),
      clampingRect: Box.fromLTWH(66.74, 61.60, 589.63, 822.26),
    );

    expect(result.flip, Flip.none);
    expect(result.rect,
        withTolerance(Box.fromLTWH(158.65, 414.62, 273.21, 205.60)));
    expect(result.resizeMode, ResizeMode.symmetricScale);

    result = BoxTransformer.resize(
      resizeMode: ResizeMode.symmetricScale,
      initialFlip: Flip.none,
      initialBox: Box.fromLTWH(158.65, 414.62, 273.21, 205.60),
      handle: HandlePosition.top,
      initialLocalPosition: Vector2(119.03, 11.31),
      flipRect: true,
      localPosition: Vector2(-108.86, -27.31),
      clampingRect: Box.fromLTWH(66.74, 61.60, 589.63, 822.26),
    );

    expect(result.flip, Flip.horizontal);
    expect(result.rect,
        withTolerance(Box.fromLTWH(107.33, 376.00, 375.85, 282.83)));
    expect(result.resizeMode, ResizeMode.symmetricScale);

    result = BoxTransformer.resize(
      resizeMode: ResizeMode.symmetricScale,
      initialFlip: Flip.horizontal,
      initialBox: Box.fromLTWH(107.33, 376.00, 375.85, 282.83),
      handle: HandlePosition.top,
      initialLocalPosition: Vector2(181.57, 16.56),
      flipRect: true,
      localPosition: Vector2(463.66, 270.61),
      clampingRect: Box.fromLTWH(66.74, 61.60, 589.63, 822.26),
    );

    expect(result.flip, Flip.diagonal);
    expect(result.rect,
        withTolerance(Box.fromLTWH(145.58, 404.78, 299.35, 225.27)));
    expect(result.resizeMode, ResizeMode.symmetricScale);

    result = BoxTransformer.resize(
      resizeMode: ResizeMode.symmetricScale,
      initialFlip: Flip.diagonal,
      initialBox: Box.fromLTWH(145.58, 404.78, 299.35, 225.27),
      handle: HandlePosition.bottom,
      initialLocalPosition: Vector2(140.92, 14.56),
      flipRect: true,
      localPosition: Vector2(-128.85, -234.86),
      clampingRect: Box.fromLTWH(66.74, 61.60, 589.63, 822.26),
    );

    expect(result.flip, Flip.none);
    expect(result.rect,
        withTolerance(Box.fromLTWH(113.48, 380.63, 363.54, 273.57)));
    expect(result.resizeMode, ResizeMode.symmetricScale);
  });
}
