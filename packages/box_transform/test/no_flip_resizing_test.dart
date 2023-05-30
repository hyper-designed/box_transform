import 'package:box_transform/box_transform.dart';
import 'package:test/test.dart';
import 'package:vector_math/vector_math.dart';

import 'utils.dart';

void main() {
  test('No flip tests for freeform resizing', () {
    var result = BoxTransformer.resize(
      resizeMode: ResizeMode.freeform,
      initialFlip: Flip.none,
      initialBox: Box.fromLTWH(191.86, 369.35, 333.35, 203.70),
      handle: HandlePosition.bottomRight,
      initialLocalPosition: Vector2(12.71, 12.24),
      allowFlipping: false,
      localPosition: Vector2(-431.96, 38.28),
    );

    expect(result.flip, Flip.none);
    expect(
        result.rect, withTolerance(Box.fromLTWH(191.86, 369.35, 0.00, 229.74)));
    expect(result.resizeMode, ResizeMode.freeform);

    result = BoxTransformer.resize(
      resizeMode: ResizeMode.freeform,
      initialFlip: Flip.none,
      initialBox: Box.fromLTWH(191.86, 369.35, 0.00, 229.74),
      handle: HandlePosition.bottomRight,
      initialLocalPosition: Vector2(11.90, 16.13),
      allowFlipping: false,
      localPosition: Vector2(299.02, -283.48),
    );

    expect(result.flip, Flip.none);
    expect(
        result.rect, withTolerance(Box.fromLTWH(191.86, 369.35, 287.12, 0.00)));
    expect(result.resizeMode, ResizeMode.freeform);

    result = BoxTransformer.resize(
      resizeMode: ResizeMode.freeform,
      initialFlip: Flip.none,
      initialBox: Box.fromLTWH(191.86, 369.35, 287.12, 0.00),
      handle: HandlePosition.bottomRight,
      initialLocalPosition: Vector2(14.87, 12.88),
      allowFlipping: false,
      localPosition: Vector2(60.57, 231.28),
    );

    expect(result.flip, Flip.none);
    expect(result.rect,
        withTolerance(Box.fromLTWH(191.86, 369.35, 332.82, 218.40)));
    expect(result.resizeMode, ResizeMode.freeform);

    result = BoxTransformer.resize(
      resizeMode: ResizeMode.freeform,
      initialFlip: Flip.none,
      initialBox: Box.fromLTWH(191.86, 369.35, 332.82, 218.40),
      handle: HandlePosition.bottomRight,
      initialLocalPosition: Vector2(13.45, 12.38),
      allowFlipping: false,
      localPosition: Vector2(-483.10, -369.68),
    );

    expect(result.flip, Flip.none);
    expect(
        result.rect, withTolerance(Box.fromLTWH(191.86, 369.35, 0.00, 0.00)));
    expect(result.resizeMode, ResizeMode.freeform);

    result = BoxTransformer.resize(
      resizeMode: ResizeMode.freeform,
      initialFlip: Flip.none,
      initialBox: Box.fromLTWH(191.86, 369.35, 0.00, 0.00),
      handle: HandlePosition.bottomRight,
      initialLocalPosition: Vector2(15.27, 12.39),
      allowFlipping: false,
      localPosition: Vector2(334.23, 228.87),
    );

    expect(result.flip, Flip.none);
    expect(result.rect,
        withTolerance(Box.fromLTWH(191.86, 369.35, 318.96, 216.48)));
    expect(result.resizeMode, ResizeMode.freeform);

    result = BoxTransformer.resize(
      resizeMode: ResizeMode.freeform,
      initialFlip: Flip.none,
      initialBox: Box.fromLTWH(191.86, 369.35, 318.96, 216.48),
      handle: HandlePosition.top,
      initialLocalPosition: Vector2(152.82, 10.13),
      allowFlipping: false,
      localPosition: Vector2(141.57, 308.93),
    );

    expect(result.flip, Flip.none);
    expect(
        result.rect, withTolerance(Box.fromLTWH(191.86, 585.83, 318.96, 0.00)));
    expect(result.resizeMode, ResizeMode.freeform);

    result = BoxTransformer.resize(
      resizeMode: ResizeMode.freeform,
      initialFlip: Flip.none,
      initialBox: Box.fromLTWH(191.86, 585.83, 318.96, 0.00),
      handle: HandlePosition.bottom,
      initialLocalPosition: Vector2(148.96, 13.57),
      allowFlipping: false,
      localPosition: Vector2(157.45, 217.64),
    );

    expect(result.flip, Flip.none);
    expect(result.rect,
        withTolerance(Box.fromLTWH(191.86, 585.83, 318.96, 204.07)));
    expect(result.resizeMode, ResizeMode.freeform);

    result = BoxTransformer.resize(
      resizeMode: ResizeMode.freeform,
      initialFlip: Flip.none,
      initialBox: Box.fromLTWH(192.24, 353.63, 318.96, 204.07),
      handle: HandlePosition.left,
      initialLocalPosition: Vector2(15.44, 90.50),
      allowFlipping: false,
      localPosition: Vector2(425.32, 97.42),
    );

    expect(result.flip, Flip.none);
    expect(
        result.rect, withTolerance(Box.fromLTWH(511.20, 353.63, 0.00, 204.07)));
    expect(result.resizeMode, ResizeMode.freeform);

    result = BoxTransformer.resize(
      resizeMode: ResizeMode.freeform,
      initialFlip: Flip.none,
      initialBox: Box.fromLTWH(511.20, 353.63, 0.00, 204.07),
      handle: HandlePosition.right,
      initialLocalPosition: Vector2(12.30, 87.23),
      allowFlipping: false,
      localPosition: Vector2(261.18, 81.54),
    );

    expect(result.flip, Flip.none);
    expect(result.rect,
        withTolerance(Box.fromLTWH(511.20, 353.63, 248.88, 204.07)));
    expect(result.resizeMode, ResizeMode.freeform);

    result = BoxTransformer.resize(
      resizeMode: ResizeMode.freeform,
      initialFlip: Flip.none,
      initialBox: Box.fromLTWH(227.20, 345.42, 248.88, 204.07),
      handle: HandlePosition.topRight,
      initialLocalPosition: Vector2(17.11, 12.79),
      allowFlipping: false,
      localPosition: Vector2(-302.69, 289.81),
    );

    expect(result.flip, Flip.none);
    expect(
        result.rect, withTolerance(Box.fromLTWH(227.20, 549.49, 0.00, 0.00)));
    expect(result.resizeMode, ResizeMode.freeform);

    result = BoxTransformer.resize(
      resizeMode: ResizeMode.freeform,
      initialFlip: Flip.none,
      initialBox: Box.fromLTWH(227.20, 549.49, 0.00, 0.00),
      handle: HandlePosition.bottomRight,
      initialLocalPosition: Vector2(9.75, 14.14),
      allowFlipping: false,
      localPosition: Vector2(339.75, 271.20),
    );

    expect(result.flip, Flip.none);
    expect(result.rect,
        withTolerance(Box.fromLTWH(227.20, 549.49, 330.00, 257.06)));
    expect(result.resizeMode, ResizeMode.freeform);

    result = BoxTransformer.resize(
      resizeMode: ResizeMode.freeform,
      initialFlip: Flip.none,
      initialBox: Box.fromLTWH(186.50, 326.25, 330.00, 257.06),
      handle: HandlePosition.bottomLeft,
      initialLocalPosition: Vector2(12.16, 8.70),
      allowFlipping: false,
      localPosition: Vector2(-22.17, -332.89),
    );

    expect(result.flip, Flip.none);
    expect(
        result.rect, withTolerance(Box.fromLTWH(152.16, 326.25, 364.34, 0.00)));
    expect(result.resizeMode, ResizeMode.freeform);

    result = BoxTransformer.resize(
      resizeMode: ResizeMode.freeform,
      initialFlip: Flip.none,
      initialBox: Box.fromLTWH(152.16, 326.25, 364.34, 0.00),
      handle: HandlePosition.bottomLeft,
      initialLocalPosition: Vector2(9.91, 10.17),
      allowFlipping: false,
      localPosition: Vector2(488.41, -76.32),
    );

    expect(result.flip, Flip.none);
    expect(
        result.rect, withTolerance(Box.fromLTWH(516.50, 326.25, 0.00, 0.00)));
    expect(result.resizeMode, ResizeMode.freeform);

    result = BoxTransformer.resize(
      resizeMode: ResizeMode.freeform,
      initialFlip: Flip.none,
      initialBox: Box.fromLTWH(516.50, 326.25, 0.00, 0.00),
      handle: HandlePosition.bottomRight,
      initialLocalPosition: Vector2(16.08, 13.00),
      allowFlipping: false,
      localPosition: Vector2(320.53, 245.75),
    );

    expect(result.flip, Flip.none);
    expect(result.rect,
        withTolerance(Box.fromLTWH(516.50, 326.25, 304.45, 232.75)));
    expect(result.resizeMode, ResizeMode.freeform);
  });

  test('No flip tests for symmetric resizing', () {
    var result = BoxTransformer.resize(
      resizeMode: ResizeMode.symmetric,
      initialFlip: Flip.none,
      initialBox: Box.fromLTWH(277.75, 323.47, 304.45, 232.75),
      handle: HandlePosition.bottomRight,
      initialLocalPosition: Vector2(16.14, 15.57),
      allowFlipping: false,
      localPosition: Vector2(-187.98, 28.76),
    );

    expect(result.flip, Flip.none);
    expect(
        result.rect, withTolerance(Box.fromLTWH(429.98, 310.28, 0.00, 259.13)));
    expect(result.resizeMode, ResizeMode.symmetric);

    result = BoxTransformer.resize(
      resizeMode: ResizeMode.symmetric,
      initialFlip: Flip.none,
      initialBox: Box.fromLTWH(429.98, 310.28, 0.00, 259.13),
      handle: HandlePosition.bottomRight,
      initialLocalPosition: Vector2(12.44, 13.20),
      allowFlipping: false,
      localPosition: Vector2(167.19, -11.75),
    );

    expect(result.flip, Flip.none);
    expect(result.rect,
        withTolerance(Box.fromLTWH(275.23, 335.24, 309.50, 209.21)));
    expect(result.resizeMode, ResizeMode.symmetric);

    result = BoxTransformer.resize(
      resizeMode: ResizeMode.symmetric,
      initialFlip: Flip.none,
      initialBox: Box.fromLTWH(275.23, 335.24, 309.50, 209.21),
      handle: HandlePosition.bottomRight,
      initialLocalPosition: Vector2(15.92, 9.88),
      allowFlipping: false,
      localPosition: Vector2(-8.62, -169.04),
    );

    expect(result.flip, Flip.none);
    expect(
        result.rect, withTolerance(Box.fromLTWH(299.76, 439.84, 260.44, 0.00)));
    expect(result.resizeMode, ResizeMode.symmetric);

    result = BoxTransformer.resize(
      resizeMode: ResizeMode.symmetric,
      initialFlip: Flip.none,
      initialBox: Box.fromLTWH(299.76, 439.84, 260.44, 0.00),
      handle: HandlePosition.bottomRight,
      initialLocalPosition: Vector2(10.62, 10.51),
      allowFlipping: false,
      localPosition: Vector2(50.88, 124.58),
    );

    expect(result.flip, Flip.none);
    expect(result.rect,
        withTolerance(Box.fromLTWH(259.50, 325.77, 340.95, 228.14)));
    expect(result.resizeMode, ResizeMode.symmetric);

    result = BoxTransformer.resize(
      resizeMode: ResizeMode.symmetric,
      initialFlip: Flip.none,
      initialBox: Box.fromLTWH(259.50, 325.77, 340.95, 228.14),
      handle: HandlePosition.left,
      initialLocalPosition: Vector2(12.42, 101.02),
      allowFlipping: false,
      localPosition: Vector2(390.85, 96.93),
    );

    expect(result.flip, Flip.none);
    expect(
        result.rect, withTolerance(Box.fromLTWH(429.98, 325.77, 0.00, 228.14)));
    expect(result.resizeMode, ResizeMode.symmetric);

    result = BoxTransformer.resize(
      resizeMode: ResizeMode.symmetric,
      initialFlip: Flip.none,
      initialBox: Box.fromLTWH(429.98, 325.77, 0.00, 228.14),
      handle: HandlePosition.right,
      initialLocalPosition: Vector2(9.64, 103.90),
      allowFlipping: false,
      localPosition: Vector2(167.88, 95.38),
    );

    expect(result.flip, Flip.none);
    expect(result.rect,
        withTolerance(Box.fromLTWH(271.74, 325.77, 316.48, 228.14)));
    expect(result.resizeMode, ResizeMode.symmetric);

    result = BoxTransformer.resize(
      resizeMode: ResizeMode.symmetric,
      initialFlip: Flip.none,
      initialBox: Box.fromLTWH(271.74, 325.77, 316.48, 228.14),
      handle: HandlePosition.top,
      initialLocalPosition: Vector2(150.12, 13.07),
      allowFlipping: false,
      localPosition: Vector2(132.15, 258.98),
    );

    expect(result.flip, Flip.none);
    expect(
        result.rect, withTolerance(Box.fromLTWH(271.74, 439.84, 316.48, 0.00)));
    expect(result.resizeMode, ResizeMode.symmetric);

    result = BoxTransformer.resize(
      resizeMode: ResizeMode.symmetric,
      initialFlip: Flip.none,
      initialBox: Box.fromLTWH(271.74, 439.84, 316.48, 0.00),
      handle: HandlePosition.bottom,
      initialLocalPosition: Vector2(144.15, 13.80),
      allowFlipping: false,
      localPosition: Vector2(148.02, 113.79),
    );

    expect(result.flip, Flip.none);
    expect(result.rect,
        withTolerance(Box.fromLTWH(271.74, 339.85, 316.48, 199.98)));
    expect(result.resizeMode, ResizeMode.symmetric);

    result = BoxTransformer.resize(
      resizeMode: ResizeMode.symmetric,
      initialFlip: Flip.none,
      initialBox: Box.fromLTWH(271.74, 339.85, 316.48, 199.98),
      handle: HandlePosition.topLeft,
      initialLocalPosition: Vector2(12.63, 11.93),
      allowFlipping: false,
      localPosition: Vector2(320.51, 225.45),
    );

    expect(result.flip, Flip.none);
    expect(
        result.rect, withTolerance(Box.fromLTWH(429.98, 439.84, 0.00, 0.00)));
    expect(result.resizeMode, ResizeMode.symmetric);

    result = BoxTransformer.resize(
      resizeMode: ResizeMode.symmetric,
      initialFlip: Flip.none,
      initialBox: Box.fromLTWH(429.98, 439.84, 0.00, 0.00),
      handle: HandlePosition.bottomRight,
      initialLocalPosition: Vector2(12.16, 12.91),
      allowFlipping: false,
      localPosition: Vector2(159.50, 127.55),
    );

    expect(result.flip, Flip.none);
    expect(result.rect,
        withTolerance(Box.fromLTWH(282.63, 325.20, 294.69, 229.28)));
    expect(result.resizeMode, ResizeMode.symmetric);

    result = BoxTransformer.resize(
      resizeMode: ResizeMode.symmetric,
      initialFlip: Flip.none,
      initialBox: Box.fromLTWH(282.63, 325.20, 294.69, 229.28),
      handle: HandlePosition.bottomLeft,
      initialLocalPosition: Vector2(15.00, 11.79),
      allowFlipping: false,
      localPosition: Vector2(344.14, -214.78),
    );

    expect(result.flip, Flip.none);
    expect(
        result.rect, withTolerance(Box.fromLTWH(429.98, 439.84, 0.00, 0.00)));
    expect(result.resizeMode, ResizeMode.symmetric);

    result = BoxTransformer.resize(
      resizeMode: ResizeMode.symmetric,
      initialFlip: Flip.none,
      initialBox: Box.fromLTWH(429.98, 439.84, 0.00, 0.00),
      handle: HandlePosition.bottomRight,
      initialLocalPosition: Vector2(10.41, 12.78),
      allowFlipping: false,
      localPosition: Vector2(205.84, 152.43),
    );

    expect(result.flip, Flip.none);
    expect(result.rect,
        withTolerance(Box.fromLTWH(234.55, 300.20, 390.85, 279.30)));
    expect(result.resizeMode, ResizeMode.symmetric);

    result = BoxTransformer.resize(
      resizeMode: ResizeMode.symmetric,
      initialFlip: Flip.none,
      initialBox: Box.fromLTWH(234.55, 300.20, 390.85, 279.30),
      handle: HandlePosition.right,
      initialLocalPosition: Vector2(11.31, 128.30),
      allowFlipping: false,
      localPosition: Vector2(-337.16, 141.05),
    );

    expect(result.flip, Flip.none);
    expect(
        result.rect, withTolerance(Box.fromLTWH(429.98, 300.20, 0.00, 279.30)));
    expect(result.resizeMode, ResizeMode.symmetric);

    result = BoxTransformer.resize(
      resizeMode: ResizeMode.symmetric,
      initialFlip: Flip.none,
      initialBox: Box.fromLTWH(429.98, 300.20, 0.00, 279.30),
      handle: HandlePosition.right,
      initialLocalPosition: Vector2(15.08, 128.25),
      allowFlipping: false,
      localPosition: Vector2(190.30, 127.53),
    );

    expect(result.flip, Flip.none);
    expect(result.rect,
        withTolerance(Box.fromLTWH(254.76, 300.20, 350.45, 279.30)));
    expect(result.resizeMode, ResizeMode.symmetric);

    result = BoxTransformer.resize(
      resizeMode: ResizeMode.symmetric,
      initialFlip: Flip.none,
      initialBox: Box.fromLTWH(254.76, 300.20, 350.45, 279.30),
      handle: HandlePosition.bottom,
      initialLocalPosition: Vector2(157.43, 14.39),
      allowFlipping: false,
      localPosition: Vector2(150.15, -272.57),
    );

    expect(result.flip, Flip.none);
    expect(
        result.rect, withTolerance(Box.fromLTWH(254.76, 439.84, 350.45, 0.00)));
    expect(result.resizeMode, ResizeMode.symmetric);

    result = BoxTransformer.resize(
      resizeMode: ResizeMode.symmetric,
      initialFlip: Flip.none,
      initialBox: Box.fromLTWH(254.76, 439.84, 350.45, 0.00),
      handle: HandlePosition.bottom,
      initialLocalPosition: Vector2(160.46, 13.05),
      allowFlipping: false,
      localPosition: Vector2(171.78, 132.14),
    );

    expect(result.flip, Flip.none);
    expect(result.rect,
        withTolerance(Box.fromLTWH(254.76, 320.75, 350.45, 238.19)));
    expect(result.resizeMode, ResizeMode.symmetric);
  });

  test('No flip tests for scaled resizing', () {
    var result = BoxTransformer.resize(
      resizeMode: ResizeMode.scale,
      initialFlip: Flip.none,
      initialBox: Box.fromLTWH(254.76, 320.75, 350.45, 238.19),
      handle: HandlePosition.bottomRight,
      initialLocalPosition: Vector2(16.20, 13.38),
      allowFlipping: false,
      localPosition: Vector2(-442.89, -297.97),
    );

    expect(result.flip, Flip.none);
    expect(
        result.rect, withTolerance(Box.fromLTWH(254.76, 320.75, 0.00, 0.00)));
    expect(result.resizeMode, ResizeMode.scale);

    result = BoxTransformer.resize(
      resizeMode: ResizeMode.scale,
      initialFlip: Flip.none,
      initialBox: Box.fromLTWH(254.76, 320.75, 0.00, 0.00),
      handle: HandlePosition.bottomRight,
      initialLocalPosition: Vector2(12.99, 11.19),
      allowFlipping: false,
      localPosition: Vector2(277.13, 269.23),
    );

    expect(result.flip, Flip.none);
    expect(result.rect,
        withTolerance(Box.fromLTWH(254.76, 320.75, 264.14, 264.14)));
    expect(result.resizeMode, ResizeMode.scale);

    result = BoxTransformer.resize(
      resizeMode: ResizeMode.freeform,
      initialFlip: Flip.none,
      initialBox: Box.fromLTWH(254.76, 320.75, 264.14, 264.14),
      handle: HandlePosition.bottomRight,
      initialLocalPosition: Vector2(14.08, 10.97),
      allowFlipping: false,
      localPosition: Vector2(75.25, -18.92),
    );

    expect(result.flip, Flip.none);
    expect(result.rect,
        withTolerance(Box.fromLTWH(254.76, 320.75, 325.31, 234.25)));
    expect(result.resizeMode, ResizeMode.freeform);

    result = BoxTransformer.resize(
      resizeMode: ResizeMode.scale,
      initialFlip: Flip.none,
      initialBox: Box.fromLTWH(254.76, 320.75, 325.31, 234.25),
      handle: HandlePosition.right,
      initialLocalPosition: Vector2(14.49, 98.64),
      allowFlipping: false,
      localPosition: Vector2(-403.04, 107.56),
    );

    expect(result.flip, Flip.none);
    expect(
        result.rect, withTolerance(Box.fromLTWH(254.76, 437.87, 0.00, 0.00)));
    expect(result.resizeMode, ResizeMode.scale);

    result = BoxTransformer.resize(
      resizeMode: ResizeMode.freeform,
      initialFlip: Flip.none,
      initialBox: Box.fromLTWH(254.76, 437.87, 0.00, 0.00),
      handle: HandlePosition.bottomRight,
      initialLocalPosition: Vector2(14.37, 11.01),
      allowFlipping: false,
      localPosition: Vector2(327.98, 247.33),
    );

    expect(result.flip, Flip.none);
    expect(result.rect,
        withTolerance(Box.fromLTWH(254.76, 437.87, 313.61, 236.32)));
    expect(result.resizeMode, ResizeMode.freeform);

    result = BoxTransformer.resize(
      resizeMode: ResizeMode.scale,
      initialFlip: Flip.none,
      initialBox: Box.fromLTWH(254.76, 437.87, 313.61, 236.32),
      handle: HandlePosition.topRight,
      initialLocalPosition: Vector2(11.13, 13.42),
      allowFlipping: false,
      localPosition: Vector2(-445.21, 336.41),
    );

    expect(result.flip, Flip.none);
    expect(
        result.rect, withTolerance(Box.fromLTWH(254.76, 674.20, 0.00, 0.00)));
    expect(result.resizeMode, ResizeMode.scale);

    result = BoxTransformer.resize(
      resizeMode: ResizeMode.freeform,
      initialFlip: Flip.none,
      initialBox: Box.fromLTWH(254.76, 674.20, 0.00, 0.00),
      handle: HandlePosition.bottomRight,
      initialLocalPosition: Vector2(14.79, 11.97),
      allowFlipping: false,
      localPosition: Vector2(209.86, 248.12),
    );

    expect(result.flip, Flip.none);
    expect(result.rect,
        withTolerance(Box.fromLTWH(254.76, 674.20, 195.07, 236.16)));
    expect(result.resizeMode, ResizeMode.freeform);

    result = BoxTransformer.resize(
      resizeMode: ResizeMode.scale,
      initialFlip: Flip.none,
      initialBox: Box.fromLTWH(300.40, 382.95, 195.07, 236.16),
      handle: HandlePosition.bottomLeft,
      initialLocalPosition: Vector2(16.83, 13.10),
      allowFlipping: false,
      localPosition: Vector2(292.40, -363.47),
    );

    expect(result.flip, Flip.none);
    expect(
        result.rect, withTolerance(Box.fromLTWH(495.46, 382.95, 0.00, 0.00)));
    expect(result.resizeMode, ResizeMode.scale);

    result = BoxTransformer.resize(
      resizeMode: ResizeMode.scale,
      initialFlip: Flip.none,
      initialBox: Box.fromLTWH(495.46, 382.95, 0.00, 0.00),
      handle: HandlePosition.bottomRight,
      initialLocalPosition: Vector2(13.63, 9.05),
      allowFlipping: false,
      localPosition: Vector2(-11.01, 31.72),
    );

    expect(result.flip, Flip.none);
    expect(
        result.rect, withTolerance(Box.fromLTWH(495.46, 382.95, 0.00, 0.00)));
    expect(result.resizeMode, ResizeMode.scale);

    result = BoxTransformer.resize(
      resizeMode: ResizeMode.freeform,
      initialFlip: Flip.none,
      initialBox: Box.fromLTWH(495.46, 382.95, 0.00, 0.00),
      handle: HandlePosition.bottomRight,
      initialLocalPosition: Vector2(13.11, 12.12),
      allowFlipping: false,
      localPosition: Vector2(296.26, 221.99),
    );

    expect(result.flip, Flip.none);
    expect(result.rect,
        withTolerance(Box.fromLTWH(495.46, 382.95, 283.15, 209.88)));
    expect(result.resizeMode, ResizeMode.freeform);

    result = BoxTransformer.resize(
      resizeMode: ResizeMode.scale,
      initialFlip: Flip.none,
      initialBox: Box.fromLTWH(252.52, 367.93, 283.15, 209.88),
      handle: HandlePosition.left,
      initialLocalPosition: Vector2(11.67, 93.18),
      allowFlipping: false,
      localPosition: Vector2(423.35, 88.10),
    );

    expect(result.flip, Flip.none);
    expect(
        result.rect, withTolerance(Box.fromLTWH(535.67, 472.87, 0.00, 0.00)));
    expect(result.resizeMode, ResizeMode.scale);

    result = BoxTransformer.resize(
      resizeMode: ResizeMode.freeform,
      initialFlip: Flip.none,
      initialBox: Box.fromLTWH(535.67, 472.87, 0.00, 0.00),
      handle: HandlePosition.bottomRight,
      initialLocalPosition: Vector2(13.43, 16.75),
      allowFlipping: false,
      localPosition: Vector2(255.13, 192.30),
    );

    expect(result.flip, Flip.none);
    expect(result.rect,
        withTolerance(Box.fromLTWH(535.67, 472.87, 241.70, 175.55)));
    expect(result.resizeMode, ResizeMode.freeform);

    result = BoxTransformer.resize(
      resizeMode: ResizeMode.scale,
      initialFlip: Flip.none,
      initialBox: Box.fromLTWH(301.42, 364.07, 241.70, 175.55),
      handle: HandlePosition.top,
      initialLocalPosition: Vector2(111.19, 9.22),
      allowFlipping: false,
      localPosition: Vector2(105.59, 323.52),
    );

    expect(result.flip, Flip.none);
    expect(
        result.rect, withTolerance(Box.fromLTWH(422.27, 539.63, 0.00, 0.00)));
    expect(result.resizeMode, ResizeMode.scale);

    result = BoxTransformer.resize(
      resizeMode: ResizeMode.freeform,
      initialFlip: Flip.none,
      initialBox: Box.fromLTWH(422.27, 539.63, 0.00, 0.00),
      handle: HandlePosition.bottomRight,
      initialLocalPosition: Vector2(14.95, 9.98),
      allowFlipping: false,
      localPosition: Vector2(329.95, 237.07),
    );

    expect(result.flip, Flip.none);
    expect(result.rect,
        withTolerance(Box.fromLTWH(422.27, 539.63, 315.01, 227.08)));
    expect(result.resizeMode, ResizeMode.freeform);
  });

  test('No flip tests for symmetrically scaled resizing', () {
    var result = BoxTransformer.resize(
      resizeMode: ResizeMode.symmetricScale,
      initialFlip: Flip.none,
      initialBox: Box.fromLTWH(219.39, 340.88, 315.01, 227.08),
      handle: HandlePosition.bottomRight,
      initialLocalPosition: Vector2(13.77, 12.89),
      allowFlipping: false,
      localPosition: Vector2(-240.42, -193.05),
    );

    expect(result.flip, Flip.none);
    expect(
        result.rect, withTolerance(Box.fromLTWH(376.89, 454.42, 0.00, 0.00)));
    expect(result.resizeMode, ResizeMode.symmetricScale);

    result = BoxTransformer.resize(
      resizeMode: ResizeMode.symmetricScale,
      initialFlip: Flip.none,
      initialBox: Box.fromLTWH(376.89, 454.42, 0.00, 0.00),
      handle: HandlePosition.bottomRight,
      initialLocalPosition: Vector2(13.98, 12.77),
      allowFlipping: false,
      localPosition: Vector2(167.82, 161.57),
    );

    expect(result.flip, Flip.none);
    expect(result.rect,
        withTolerance(Box.fromLTWH(223.05, 300.58, 307.69, 307.69)));
    expect(result.resizeMode, ResizeMode.symmetricScale);

    result = BoxTransformer.resize(
      resizeMode: ResizeMode.freeform,
      initialFlip: Flip.none,
      initialBox: Box.fromLTWH(223.05, 300.58, 307.69, 307.69),
      handle: HandlePosition.bottomRight,
      initialLocalPosition: Vector2(12.26, 9.96),
      allowFlipping: false,
      localPosition: Vector2(66.13, -45.67),
    );

    expect(result.flip, Flip.none);
    expect(result.rect,
        withTolerance(Box.fromLTWH(223.05, 300.58, 361.55, 252.06)));
    expect(result.resizeMode, ResizeMode.freeform);

    result = BoxTransformer.resize(
      resizeMode: ResizeMode.symmetricScale,
      initialFlip: Flip.none,
      initialBox: Box.fromLTWH(210.42, 324.49, 361.55, 252.06),
      handle: HandlePosition.left,
      initialLocalPosition: Vector2(13.04, 112.51),
      allowFlipping: false,
      localPosition: Vector2(286.68, 114.21),
    );

    expect(result.flip, Flip.none);
    expect(
        result.rect, withTolerance(Box.fromLTWH(391.20, 450.52, 0.00, 0.00)));
    expect(result.resizeMode, ResizeMode.symmetricScale);

    result = BoxTransformer.resize(
      resizeMode: ResizeMode.symmetricScale,
      initialFlip: Flip.none,
      initialBox: Box.fromLTWH(391.20, 450.52, 0.00, 0.00),
      handle: HandlePosition.bottomRight,
      initialLocalPosition: Vector2(14.21, 12.03),
      allowFlipping: false,
      localPosition: Vector2(141.46, 28.64),
    );

    expect(result.flip, Flip.none);
    expect(result.rect,
        withTolerance(Box.fromLTWH(263.95, 323.27, 254.50, 254.50)));
    expect(result.resizeMode, ResizeMode.symmetricScale);

    result = BoxTransformer.resize(
      resizeMode: ResizeMode.symmetricScale,
      initialFlip: Flip.none,
      initialBox: Box.fromLTWH(263.95, 323.27, 254.50, 254.50),
      handle: HandlePosition.topRight,
      initialLocalPosition: Vector2(16.63, 12.96),
      allowFlipping: false,
      localPosition: Vector2(-197.14, 218.55),
    );

    expect(result.flip, Flip.none);
    expect(
        result.rect, withTolerance(Box.fromLTWH(391.20, 450.52, 0.00, 0.00)));
    expect(result.resizeMode, ResizeMode.symmetricScale);

    result = BoxTransformer.resize(
      resizeMode: ResizeMode.freeform,
      initialFlip: Flip.none,
      initialBox: Box.fromLTWH(391.20, 450.52, 0.00, 0.00),
      handle: HandlePosition.bottomRight,
      initialLocalPosition: Vector2(12.86, 14.01),
      allowFlipping: false,
      localPosition: Vector2(314.02, 269.02),
    );

    expect(result.flip, Flip.none);
    expect(result.rect,
        withTolerance(Box.fromLTWH(391.20, 450.52, 301.16, 255.02)));
    expect(result.resizeMode, ResizeMode.freeform);

    result = BoxTransformer.resize(
      resizeMode: ResizeMode.symmetricScale,
      initialFlip: Flip.none,
      initialBox: Box.fromLTWH(249.76, 341.37, 301.16, 255.02),
      handle: HandlePosition.top,
      initialLocalPosition: Vector2(136.39, 8.64),
      allowFlipping: false,
      localPosition: Vector2(148.17, 282.48),
    );

    expect(result.flip, Flip.none);
    expect(
        result.rect, withTolerance(Box.fromLTWH(400.34, 468.87, 0.00, 0.00)));
    expect(result.resizeMode, ResizeMode.symmetricScale);

    result = BoxTransformer.resize(
      resizeMode: ResizeMode.freeform,
      initialFlip: Flip.none,
      initialBox: Box.fromLTWH(400.34, 468.87, 0.00, 0.00),
      handle: HandlePosition.bottomRight,
      initialLocalPosition: Vector2(13.79, 9.70),
      allowFlipping: false,
      localPosition: Vector2(251.92, 306.01),
    );

    expect(result.flip, Flip.none);
    expect(result.rect,
        withTolerance(Box.fromLTWH(400.34, 468.87, 238.13, 296.31)));
    expect(result.resizeMode, ResizeMode.freeform);

    result = BoxTransformer.resize(
      resizeMode: ResizeMode.symmetricScale,
      initialFlip: Flip.none,
      initialBox: Box.fromLTWH(271.00, 301.45, 238.13, 296.31),
      handle: HandlePosition.bottomLeft,
      initialLocalPosition: Vector2(12.20, 7.32),
      allowFlipping: false,
      localPosition: Vector2(272.93, -279.30),
    );

    expect(result.flip, Flip.none);
    expect(
        result.rect, withTolerance(Box.fromLTWH(390.06, 449.60, 0.00, 0.00)));
    expect(result.resizeMode, ResizeMode.symmetricScale);

    result = BoxTransformer.resize(
      resizeMode: ResizeMode.freeform,
      initialFlip: Flip.none,
      initialBox: Box.fromLTWH(390.06, 449.60, 0.00, 0.00),
      handle: HandlePosition.bottomRight,
      initialLocalPosition: Vector2(13.79, 9.66),
      allowFlipping: false,
      localPosition: Vector2(294.48, 237.73),
    );

    expect(result.flip, Flip.none);
    expect(result.rect,
        withTolerance(Box.fromLTWH(390.06, 449.60, 280.69, 228.06)));
    expect(result.resizeMode, ResizeMode.freeform);

    result = BoxTransformer.resize(
      resizeMode: ResizeMode.symmetricScale,
      initialFlip: Flip.none,
      initialBox: Box.fromLTWH(281.93, 358.74, 280.69, 228.06),
      handle: HandlePosition.topLeft,
      initialLocalPosition: Vector2(11.10, 10.26),
      allowFlipping: false,
      localPosition: Vector2(278.82, 220.96),
    );

    expect(result.flip, Flip.none);
    expect(
        result.rect, withTolerance(Box.fromLTWH(422.28, 472.77, 0.00, 0.00)));
    expect(result.resizeMode, ResizeMode.symmetricScale);

    result = BoxTransformer.resize(
      resizeMode: ResizeMode.freeform,
      initialFlip: Flip.none,
      initialBox: Box.fromLTWH(422.28, 472.77, 0.00, 0.00),
      handle: HandlePosition.bottomRight,
      initialLocalPosition: Vector2(12.40, 12.16),
      allowFlipping: false,
      localPosition: Vector2(273.91, 202.04),
    );

    expect(result.flip, Flip.none);
    expect(result.rect,
        withTolerance(Box.fromLTWH(422.28, 472.77, 261.51, 189.87)));
    expect(result.resizeMode, ResizeMode.freeform);
  });
}
