import 'package:test/test.dart';
import 'package:vector_math/vector_math.dart';
import 'package:box_transform/box_transform.dart';
import 'utils.dart';

void main() {
  test('Clamped freeform resizing with bottom-right handle', () {
    var result = BoxTransformer.resize(
      resizeMode: ResizeMode.freeform,
      initialFlip: Flip.none,
      initialBox: Box.fromLTWH(298.29, 417.18, 260.02, 195.42),
      handle: HandlePosition.bottomRight,
      initialLocalPosition: Vector2(14.54, 14.68),
      allowFlipping: true,
      localPosition: Vector2(151.42, -7.91),
      clampingRect: Box.fromLTWH(66.74, 61.60, 589.63, 822.26),
    );

    expect(result.flip, Flip.none);
    expect(result.rect,
        withTolerance(Box.fromLTWH(298.29, 417.18, 358.09, 172.83)));
    expect(result.resizeMode, ResizeMode.freeform);

    result = BoxTransformer.resize(
      resizeMode: ResizeMode.freeform,
      initialFlip: Flip.none,
      initialBox: Box.fromLTWH(298.29, 417.18, 358.09, 172.83),
      handle: HandlePosition.bottomRight,
      initialLocalPosition: Vector2(14.75, 9.36),
      allowFlipping: true,
      localPosition: Vector2(-159.68, 330.75),
      clampingRect: Box.fromLTWH(66.74, 61.60, 589.63, 822.26),
    );

    expect(result.flip, Flip.none);
    expect(result.rect,
        withTolerance(Box.fromLTWH(298.29, 417.18, 183.67, 466.68)));
    expect(result.resizeMode, ResizeMode.freeform);

    result = BoxTransformer.resize(
      resizeMode: ResizeMode.freeform,
      initialFlip: Flip.none,
      initialBox: Box.fromLTWH(298.29, 417.18, 183.67, 466.68),
      handle: HandlePosition.bottomRight,
      initialLocalPosition: Vector2(15.71, 14.14),
      allowFlipping: true,
      localPosition: Vector2(229.66, 56.56),
      clampingRect: Box.fromLTWH(66.74, 61.60, 589.63, 822.26),
    );

    expect(result.flip, Flip.none);
    expect(result.rect,
        withTolerance(Box.fromLTWH(298.29, 417.18, 358.09, 466.68)));
    expect(result.resizeMode, ResizeMode.freeform);

    result = BoxTransformer.resize(
      resizeMode: ResizeMode.freeform,
      initialFlip: Flip.none,
      initialBox: Box.fromLTWH(298.29, 417.18, 358.09, 466.68),
      handle: HandlePosition.bottomRight,
      initialLocalPosition: Vector2(11.88, 13.91),
      allowFlipping: true,
      localPosition: Vector2(-636.64, -305.30),
      clampingRect: Box.fromLTWH(66.74, 61.60, 589.63, 822.26),
    );

    expect(result.flip, Flip.horizontal);
    expect(result.rect,
        withTolerance(Box.fromLTWH(66.74, 417.18, 231.54, 147.46)));
    expect(result.resizeMode, ResizeMode.freeform);

    result = BoxTransformer.resize(
      resizeMode: ResizeMode.freeform,
      initialFlip: Flip.horizontal,
      initialBox: Box.fromLTWH(66.74, 417.18, 231.54, 147.46),
      handle: HandlePosition.bottomLeft,
      initialLocalPosition: Vector2(11.25, 7.43),
      allowFlipping: true,
      localPosition: Vector2(-55.91, 366.04),
      clampingRect: Box.fromLTWH(66.74, 61.60, 589.63, 822.26),
    );

    expect(result.flip, Flip.horizontal);
    expect(result.rect,
        withTolerance(Box.fromLTWH(66.74, 417.18, 231.54, 466.68)));
    expect(result.resizeMode, ResizeMode.freeform);

    result = BoxTransformer.resize(
      resizeMode: ResizeMode.freeform,
      initialFlip: Flip.horizontal,
      initialBox: Box.fromLTWH(66.74, 417.18, 231.54, 466.68),
      handle: HandlePosition.bottomLeft,
      initialLocalPosition: Vector2(7.83, 10.76),
      allowFlipping: true,
      localPosition: Vector2(-129.00, -628.84),
      clampingRect: Box.fromLTWH(66.74, 61.60, 589.63, 822.26),
    );

    expect(result.flip, Flip.diagonal);
    expect(result.rect,
        withTolerance(Box.fromLTWH(66.74, 244.27, 231.54, 172.92)));
    expect(result.resizeMode, ResizeMode.freeform);

    result = BoxTransformer.resize(
      resizeMode: ResizeMode.freeform,
      initialFlip: Flip.diagonal,
      initialBox: Box.fromLTWH(66.74, 244.27, 231.54, 172.92),
      handle: HandlePosition.topLeft,
      initialLocalPosition: Vector2(13.51, 11.70),
      allowFlipping: true,
      localPosition: Vector2(-21.42, -273.60),
      clampingRect: Box.fromLTWH(66.74, 61.60, 589.63, 822.26),
    );

    expect(result.flip, Flip.diagonal);
    expect(
        result.rect, withTolerance(Box.fromLTWH(66.74, 61.60, 231.54, 355.58)));
    expect(result.resizeMode, ResizeMode.freeform);

    result = BoxTransformer.resize(
      resizeMode: ResizeMode.freeform,
      initialFlip: Flip.diagonal,
      initialBox: Box.fromLTWH(66.74, 61.60, 231.54, 355.58),
      handle: HandlePosition.topLeft,
      initialLocalPosition: Vector2(12.41, 12.98),
      allowFlipping: true,
      localPosition: Vector2(135.44, -32.93),
      clampingRect: Box.fromLTWH(66.74, 61.60, 589.63, 822.26),
    );

    expect(result.flip, Flip.diagonal);
    expect(result.rect,
        withTolerance(Box.fromLTWH(189.77, 61.60, 108.52, 355.58)));
    expect(result.resizeMode, ResizeMode.freeform);

    result = BoxTransformer.resize(
      resizeMode: ResizeMode.freeform,
      initialFlip: Flip.diagonal,
      initialBox: Box.fromLTWH(189.77, 61.60, 108.52, 355.58),
      handle: HandlePosition.topLeft,
      initialLocalPosition: Vector2(11.40, 10.14),
      allowFlipping: true,
      localPosition: Vector2(533.77, 243.96),
      clampingRect: Box.fromLTWH(66.74, 61.60, 589.63, 822.26),
    );

    expect(result.flip, Flip.vertical);
    expect(result.rect,
        withTolerance(Box.fromLTWH(298.29, 295.42, 358.09, 121.76)));
    expect(result.resizeMode, ResizeMode.freeform);

    result = BoxTransformer.resize(
      resizeMode: ResizeMode.freeform,
      initialFlip: Flip.vertical,
      initialBox: Box.fromLTWH(298.29, 295.42, 358.09, 121.76),
      handle: HandlePosition.topRight,
      initialLocalPosition: Vector2(17.70, 11.94),
      allowFlipping: true,
      localPosition: Vector2(-160.68, -289.17),
      clampingRect: Box.fromLTWH(66.74, 61.60, 589.63, 822.26),
    );

    expect(result.flip, Flip.vertical);
    expect(result.rect,
        withTolerance(Box.fromLTWH(298.29, 61.60, 179.71, 355.58)));
    expect(result.resizeMode, ResizeMode.freeform);

    result = BoxTransformer.resize(
      resizeMode: ResizeMode.freeform,
      initialFlip: Flip.vertical,
      initialBox: Box.fromLTWH(298.29, 61.60, 179.71, 355.58),
      handle: HandlePosition.topRight,
      initialLocalPosition: Vector2(12.88, 11.45),
      allowFlipping: true,
      localPosition: Vector2(240.92, -56.66),
      clampingRect: Box.fromLTWH(66.74, 61.60, 589.63, 822.26),
    );

    expect(result.flip, Flip.vertical);
    expect(result.rect,
        withTolerance(Box.fromLTWH(298.29, 61.60, 358.09, 355.58)));
    expect(result.resizeMode, ResizeMode.freeform);

    result = BoxTransformer.resize(
      resizeMode: ResizeMode.freeform,
      initialFlip: Flip.vertical,
      initialBox: Box.fromLTWH(298.29, 61.60, 358.09, 355.58),
      handle: HandlePosition.topRight,
      initialLocalPosition: Vector2(18.24, 8.62),
      allowFlipping: true,
      localPosition: Vector2(-631.33, 901.16),
      clampingRect: Box.fromLTWH(66.74, 61.60, 589.63, 822.26),
    );

    expect(result.flip, Flip.horizontal);
    expect(result.rect,
        withTolerance(Box.fromLTWH(66.74, 417.18, 231.54, 466.68)));
    expect(result.resizeMode, ResizeMode.freeform);

    result = BoxTransformer.resize(
      resizeMode: ResizeMode.freeform,
      initialFlip: Flip.horizontal,
      initialBox: Box.fromLTWH(66.74, 417.18, 231.54, 466.68),
      handle: HandlePosition.bottomLeft,
      initialLocalPosition: Vector2(12.38, 10.43),
      allowFlipping: true,
      localPosition: Vector2(492.74, -257.20),
      clampingRect: Box.fromLTWH(66.74, 61.60, 589.63, 822.26),
    );

    expect(result.flip, Flip.none);
    expect(result.rect,
        withTolerance(Box.fromLTWH(298.29, 417.18, 248.82, 199.04)));
    expect(result.resizeMode, ResizeMode.freeform);
  });

  test('Clamped freeform resizing with top-left handle', () {
    var result = BoxTransformer.resize(
      resizeMode: ResizeMode.freeform,
      initialFlip: Flip.none,
      initialBox: Box.fromLTWH(171.97, 330.60, 248.82, 199.04),
      handle: HandlePosition.topLeft,
      initialLocalPosition: Vector2(13.26, 9.38),
      allowFlipping: true,
      localPosition: Vector2(-123.51, 39.91),
      clampingRect: Box.fromLTWH(66.74, 61.60, 589.63, 822.26),
    );

    expect(result.flip, Flip.none);
    expect(result.rect,
        withTolerance(Box.fromLTWH(66.74, 361.13, 354.04, 168.51)));
    expect(result.resizeMode, ResizeMode.freeform);

    result = BoxTransformer.resize(
      resizeMode: ResizeMode.freeform,
      initialFlip: Flip.none,
      initialBox: Box.fromLTWH(66.74, 361.13, 354.04, 168.51),
      handle: HandlePosition.topLeft,
      initialLocalPosition: Vector2(13.11, 16.25),
      allowFlipping: true,
      localPosition: Vector2(170.17, -304.77),
      clampingRect: Box.fromLTWH(66.74, 61.60, 589.63, 822.26),
    );

    expect(result.flip, Flip.none);
    expect(result.rect,
        withTolerance(Box.fromLTWH(223.80, 61.60, 196.98, 468.04)));
    expect(result.resizeMode, ResizeMode.freeform);

    result = BoxTransformer.resize(
      resizeMode: ResizeMode.freeform,
      initialFlip: Flip.none,
      initialBox: Box.fromLTWH(223.80, 61.60, 196.98, 468.04),
      handle: HandlePosition.topLeft,
      initialLocalPosition: Vector2(14.24, 14.17),
      allowFlipping: true,
      localPosition: Vector2(-193.22, -26.66),
      clampingRect: Box.fromLTWH(66.74, 61.60, 589.63, 822.26),
    );

    expect(result.flip, Flip.none);
    expect(
        result.rect, withTolerance(Box.fromLTWH(66.74, 61.60, 354.04, 468.04)));
    expect(result.resizeMode, ResizeMode.freeform);

    result = BoxTransformer.resize(
      resizeMode: ResizeMode.freeform,
      initialFlip: Flip.none,
      initialBox: Box.fromLTWH(66.74, 61.60, 354.04, 468.04),
      handle: HandlePosition.topLeft,
      initialLocalPosition: Vector2(14.38, 12.90),
      allowFlipping: true,
      localPosition: Vector2(652.26, 305.69),
      clampingRect: Box.fromLTWH(66.74, 61.60, 589.63, 822.26),
    );

    expect(result.flip, Flip.horizontal);
    expect(result.rect,
        withTolerance(Box.fromLTWH(420.79, 354.39, 235.59, 175.25)));
    expect(result.resizeMode, ResizeMode.freeform);

    result = BoxTransformer.resize(
      resizeMode: ResizeMode.freeform,
      initialFlip: Flip.horizontal,
      initialBox: Box.fromLTWH(420.79, 354.39, 235.59, 175.25),
      handle: HandlePosition.topRight,
      initialLocalPosition: Vector2(12.80, 12.01),
      allowFlipping: true,
      localPosition: Vector2(-159.09, -331.84),
      clampingRect: Box.fromLTWH(66.74, 61.60, 589.63, 822.26),
    );

    expect(result.flip, Flip.horizontal);
    expect(
        result.rect, withTolerance(Box.fromLTWH(420.79, 61.60, 63.70, 468.04)));
    expect(result.resizeMode, ResizeMode.freeform);

    result = BoxTransformer.resize(
      resizeMode: ResizeMode.freeform,
      initialFlip: Flip.horizontal,
      initialBox: Box.fromLTWH(420.79, 61.60, 63.70, 468.04),
      handle: HandlePosition.topRight,
      initialLocalPosition: Vector2(13.67, 10.88),
      allowFlipping: true,
      localPosition: Vector2(263.28, -44.16),
      clampingRect: Box.fromLTWH(66.74, 61.60, 589.63, 822.26),
    );

    expect(result.flip, Flip.horizontal);
    expect(result.rect,
        withTolerance(Box.fromLTWH(420.79, 61.60, 235.59, 468.04)));
    expect(result.resizeMode, ResizeMode.freeform);

    result = BoxTransformer.resize(
      resizeMode: ResizeMode.freeform,
      initialFlip: Flip.horizontal,
      initialBox: Box.fromLTWH(420.79, 61.60, 235.59, 468.04),
      handle: HandlePosition.topRight,
      initialLocalPosition: Vector2(11.19, 14.10),
      allowFlipping: true,
      localPosition: Vector2(100.03, 627.28),
      clampingRect: Box.fromLTWH(66.74, 61.60, 589.63, 822.26),
    );

    expect(result.flip, Flip.diagonal);
    expect(result.rect,
        withTolerance(Box.fromLTWH(420.79, 529.64, 235.59, 145.14)));
    expect(result.resizeMode, ResizeMode.freeform);

    result = BoxTransformer.resize(
      resizeMode: ResizeMode.freeform,
      initialFlip: Flip.diagonal,
      initialBox: Box.fromLTWH(420.79, 529.64, 235.59, 145.14),
      handle: HandlePosition.bottomRight,
      initialLocalPosition: Vector2(14.14, 11.57),
      allowFlipping: true,
      localPosition: Vector2(-91.24, 248.60),
      clampingRect: Box.fromLTWH(66.74, 61.60, 589.63, 822.26),
    );

    expect(result.flip, Flip.diagonal);
    expect(result.rect,
        withTolerance(Box.fromLTWH(420.79, 529.64, 130.21, 354.22)));
    expect(result.resizeMode, ResizeMode.freeform);

    result = BoxTransformer.resize(
      resizeMode: ResizeMode.freeform,
      initialFlip: Flip.diagonal,
      initialBox: Box.fromLTWH(420.79, 529.64, 130.21, 354.22),
      handle: HandlePosition.bottomRight,
      initialLocalPosition: Vector2(11.20, 10.45),
      allowFlipping: true,
      localPosition: Vector2(182.84, 44.43),
      clampingRect: Box.fromLTWH(66.74, 61.60, 589.63, 822.26),
    );

    expect(result.flip, Flip.diagonal);
    expect(result.rect,
        withTolerance(Box.fromLTWH(420.79, 529.64, 235.59, 354.22)));
    expect(result.resizeMode, ResizeMode.freeform);

    result = BoxTransformer.resize(
      resizeMode: ResizeMode.freeform,
      initialFlip: Flip.diagonal,
      initialBox: Box.fromLTWH(420.79, 529.64, 235.59, 354.22),
      handle: HandlePosition.bottomRight,
      initialLocalPosition: Vector2(12.76, 13.06),
      allowFlipping: true,
      localPosition: Vector2(-630.00, -202.58),
      clampingRect: Box.fromLTWH(66.74, 61.60, 589.63, 822.26),
    );

    expect(result.flip, Flip.vertical);
    expect(result.rect,
        withTolerance(Box.fromLTWH(66.74, 529.64, 354.04, 138.58)));
    expect(result.resizeMode, ResizeMode.freeform);

    result = BoxTransformer.resize(
      resizeMode: ResizeMode.freeform,
      initialFlip: Flip.vertical,
      initialBox: Box.fromLTWH(66.74, 529.64, 354.04, 138.58),
      handle: HandlePosition.bottomLeft,
      initialLocalPosition: Vector2(10.68, 13.95),
      allowFlipping: true,
      localPosition: Vector2(194.34, 253.36),
      clampingRect: Box.fromLTWH(66.74, 61.60, 589.63, 822.26),
    );

    expect(result.flip, Flip.vertical);
    expect(result.rect,
        withTolerance(Box.fromLTWH(250.40, 529.64, 170.38, 354.22)));
    expect(result.resizeMode, ResizeMode.freeform);

    result = BoxTransformer.resize(
      resizeMode: ResizeMode.freeform,
      initialFlip: Flip.vertical,
      initialBox: Box.fromLTWH(250.40, 529.64, 170.38, 354.22),
      handle: HandlePosition.bottomLeft,
      initialLocalPosition: Vector2(10.87, 10.10),
      allowFlipping: true,
      localPosition: Vector2(-267.18, 62.10),
      clampingRect: Box.fromLTWH(66.74, 61.60, 589.63, 822.26),
    );

    expect(result.flip, Flip.vertical);
    expect(result.rect,
        withTolerance(Box.fromLTWH(66.74, 529.64, 354.04, 354.22)));
    expect(result.resizeMode, ResizeMode.freeform);

    result = BoxTransformer.resize(
      resizeMode: ResizeMode.freeform,
      initialFlip: Flip.vertical,
      initialBox: Box.fromLTWH(66.74, 529.64, 354.04, 354.22),
      handle: HandlePosition.bottomLeft,
      initialLocalPosition: Vector2(13.14, 14.05),
      allowFlipping: true,
      localPosition: Vector2(73.96, -570.18),
      clampingRect: Box.fromLTWH(66.74, 61.60, 589.63, 822.26),
    );

    expect(result.flip, Flip.none);
    expect(result.rect,
        withTolerance(Box.fromLTWH(127.56, 299.63, 293.23, 230.01)));
    expect(result.resizeMode, ResizeMode.freeform);
  });

  test('Clamped freeform resizing with top-right handle', () {
    var result = BoxTransformer.resize(
      resizeMode: ResizeMode.freeform,
      initialFlip: Flip.none,
      initialBox: Box.fromLTWH(292.55, 293.28, 293.23, 230.01),
      handle: HandlePosition.topRight,
      initialLocalPosition: Vector2(12.82, 9.70),
      allowFlipping: true,
      localPosition: Vector2(114.30, 97.20),
      clampingRect: Box.fromLTWH(66.74, 61.60, 589.63, 822.26),
    );

    expect(result.flip, Flip.none);
    expect(result.rect,
        withTolerance(Box.fromLTWH(292.55, 380.78, 363.82, 142.51)));
    expect(result.resizeMode, ResizeMode.freeform);

    result = BoxTransformer.resize(
      resizeMode: ResizeMode.freeform,
      initialFlip: Flip.none,
      initialBox: Box.fromLTWH(292.55, 380.78, 363.82, 142.51),
      handle: HandlePosition.topRight,
      initialLocalPosition: Vector2(14.40, 13.21),
      allowFlipping: true,
      localPosition: Vector2(-178.32, -333.59),
      clampingRect: Box.fromLTWH(66.74, 61.60, 589.63, 822.26),
    );

    expect(result.flip, Flip.none);
    expect(result.rect,
        withTolerance(Box.fromLTWH(292.55, 61.60, 171.11, 461.69)));
    expect(result.resizeMode, ResizeMode.freeform);

    result = BoxTransformer.resize(
      resizeMode: ResizeMode.freeform,
      initialFlip: Flip.none,
      initialBox: Box.fromLTWH(292.55, 61.60, 171.11, 461.69),
      handle: HandlePosition.topRight,
      initialLocalPosition: Vector2(13.68, 12.31),
      allowFlipping: true,
      localPosition: Vector2(244.32, -26.40),
      clampingRect: Box.fromLTWH(66.74, 61.60, 589.63, 822.26),
    );

    expect(result.flip, Flip.none);
    expect(result.rect,
        withTolerance(Box.fromLTWH(292.55, 61.60, 363.82, 461.69)));
    expect(result.resizeMode, ResizeMode.freeform);

    result = BoxTransformer.resize(
      resizeMode: ResizeMode.freeform,
      initialFlip: Flip.none,
      initialBox: Box.fromLTWH(292.55, 61.60, 363.82, 461.69),
      handle: HandlePosition.topRight,
      initialLocalPosition: Vector2(13.24, 14.37),
      allowFlipping: true,
      localPosition: Vector2(-646.88, 314.61),
      clampingRect: Box.fromLTWH(66.74, 61.60, 589.63, 822.26),
    );

    expect(result.flip, Flip.horizontal);
    expect(result.rect,
        withTolerance(Box.fromLTWH(66.74, 361.84, 225.81, 161.45)));
    expect(result.resizeMode, ResizeMode.freeform);

    result = BoxTransformer.resize(
      resizeMode: ResizeMode.freeform,
      initialFlip: Flip.horizontal,
      initialBox: Box.fromLTWH(66.74, 361.84, 225.81, 161.45),
      handle: HandlePosition.topLeft,
      initialLocalPosition: Vector2(12.30, 14.51),
      allowFlipping: true,
      localPosition: Vector2(118.00, -332.05),
      clampingRect: Box.fromLTWH(66.74, 61.60, 589.63, 822.26),
    );

    expect(result.flip, Flip.horizontal);
    expect(result.rect,
        withTolerance(Box.fromLTWH(172.44, 61.60, 120.11, 461.69)));
    expect(result.resizeMode, ResizeMode.freeform);

    result = BoxTransformer.resize(
      resizeMode: ResizeMode.freeform,
      initialFlip: Flip.horizontal,
      initialBox: Box.fromLTWH(172.44, 61.60, 120.11, 461.69),
      handle: HandlePosition.topLeft,
      initialLocalPosition: Vector2(12.91, 13.43),
      allowFlipping: true,
      localPosition: Vector2(-155.58, -36.87),
      clampingRect: Box.fromLTWH(66.74, 61.60, 589.63, 822.26),
    );

    expect(result.flip, Flip.horizontal);
    expect(
        result.rect, withTolerance(Box.fromLTWH(66.74, 61.60, 225.81, 461.69)));
    expect(result.resizeMode, ResizeMode.freeform);

    result = BoxTransformer.resize(
      resizeMode: ResizeMode.freeform,
      initialFlip: Flip.horizontal,
      initialBox: Box.fromLTWH(66.74, 61.60, 225.81, 461.69),
      handle: HandlePosition.topLeft,
      initialLocalPosition: Vector2(15.62, 14.21),
      allowFlipping: true,
      localPosition: Vector2(-28.21, 633.84),
      clampingRect: Box.fromLTWH(66.74, 61.60, 589.63, 822.26),
    );

    expect(result.flip, Flip.diagonal);
    expect(result.rect,
        withTolerance(Box.fromLTWH(66.74, 523.29, 225.81, 157.94)));
    expect(result.resizeMode, ResizeMode.freeform);

    result = BoxTransformer.resize(
      resizeMode: ResizeMode.freeform,
      initialFlip: Flip.diagonal,
      initialBox: Box.fromLTWH(66.74, 523.29, 225.81, 157.94),
      handle: HandlePosition.bottomLeft,
      initialLocalPosition: Vector2(14.91, 13.43),
      allowFlipping: true,
      localPosition: Vector2(137.26, 238.87),
      clampingRect: Box.fromLTWH(66.74, 61.60, 589.63, 822.26),
    );

    expect(result.flip, Flip.diagonal);
    expect(result.rect,
        withTolerance(Box.fromLTWH(189.09, 523.29, 103.46, 360.57)));
    expect(result.resizeMode, ResizeMode.freeform);

    result = BoxTransformer.resize(
      resizeMode: ResizeMode.freeform,
      initialFlip: Flip.diagonal,
      initialBox: Box.fromLTWH(189.09, 523.29, 103.46, 360.57),
      handle: HandlePosition.bottomLeft,
      initialLocalPosition: Vector2(12.48, 12.17),
      allowFlipping: true,
      localPosition: Vector2(-197.88, 43.96),
      clampingRect: Box.fromLTWH(66.74, 61.60, 589.63, 822.26),
    );

    expect(result.flip, Flip.diagonal);
    expect(result.rect,
        withTolerance(Box.fromLTWH(66.74, 523.29, 225.81, 360.57)));
    expect(result.resizeMode, ResizeMode.freeform);

    result = BoxTransformer.resize(
      resizeMode: ResizeMode.freeform,
      initialFlip: Flip.diagonal,
      initialBox: Box.fromLTWH(66.74, 523.29, 225.81, 360.57),
      handle: HandlePosition.bottomLeft,
      initialLocalPosition: Vector2(12.70, 13.47),
      allowFlipping: true,
      localPosition: Vector2(652.32, -185.12),
      clampingRect: Box.fromLTWH(66.74, 61.60, 589.63, 822.26),
    );

    expect(result.flip, Flip.vertical);
    expect(result.rect,
        withTolerance(Box.fromLTWH(292.55, 523.29, 363.82, 161.98)));
    expect(result.resizeMode, ResizeMode.freeform);

    result = BoxTransformer.resize(
      resizeMode: ResizeMode.freeform,
      initialFlip: Flip.vertical,
      initialBox: Box.fromLTWH(292.55, 523.29, 363.82, 161.98),
      handle: HandlePosition.bottomRight,
      initialLocalPosition: Vector2(14.77, 10.94),
      allowFlipping: true,
      localPosition: Vector2(-161.97, 252.32),
      clampingRect: Box.fromLTWH(66.74, 61.60, 589.63, 822.26),
    );

    expect(result.flip, Flip.vertical);
    expect(result.rect,
        withTolerance(Box.fromLTWH(292.55, 523.29, 187.09, 360.57)));
    expect(result.resizeMode, ResizeMode.freeform);

    result = BoxTransformer.resize(
      resizeMode: ResizeMode.freeform,
      initialFlip: Flip.vertical,
      initialBox: Box.fromLTWH(292.55, 523.29, 187.09, 360.57),
      handle: HandlePosition.bottomRight,
      initialLocalPosition: Vector2(17.53, 13.96),
      allowFlipping: true,
      localPosition: Vector2(242.22, 54.01),
      clampingRect: Box.fromLTWH(66.74, 61.60, 589.63, 822.26),
    );

    expect(result.flip, Flip.vertical);
    expect(result.rect,
        withTolerance(Box.fromLTWH(292.55, 523.29, 363.82, 360.57)));
    expect(result.resizeMode, ResizeMode.freeform);

    result = BoxTransformer.resize(
      resizeMode: ResizeMode.freeform,
      initialFlip: Flip.vertical,
      initialBox: Box.fromLTWH(292.55, 523.29, 363.82, 360.57),
      handle: HandlePosition.bottomRight,
      initialLocalPosition: Vector2(12.59, 12.32),
      allowFlipping: true,
      localPosition: Vector2(-57.46, -568.96),
      clampingRect: Box.fromLTWH(66.74, 61.60, 589.63, 822.26),
    );

    expect(result.flip, Flip.none);
    expect(result.rect,
        withTolerance(Box.fromLTWH(292.55, 302.58, 293.77, 220.71)));
    expect(result.resizeMode, ResizeMode.freeform);
  });

  test('Clamped freeform resizing with bottom-left handle', () {
    var result = BoxTransformer.resize(
      resizeMode: ResizeMode.freeform,
      initialFlip: Flip.none,
      initialBox: Box.fromLTWH(129.84, 443.50, 293.77, 220.71),
      handle: HandlePosition.bottomLeft,
      initialLocalPosition: Vector2(12.79, 15.13),
      allowFlipping: true,
      localPosition: Vector2(-93.40, -62.46),
      clampingRect: Box.fromLTWH(66.74, 61.60, 589.63, 822.26),
    );

    expect(result.flip, Flip.none);
    expect(result.rect,
        withTolerance(Box.fromLTWH(66.74, 443.50, 356.87, 143.11)));
    expect(result.resizeMode, ResizeMode.freeform);

    result = BoxTransformer.resize(
      resizeMode: ResizeMode.freeform,
      initialFlip: Flip.none,
      initialBox: Box.fromLTWH(66.74, 443.50, 356.87, 143.11),
      handle: HandlePosition.bottomLeft,
      initialLocalPosition: Vector2(12.11, 14.53),
      allowFlipping: true,
      localPosition: Vector2(205.23, 355.81),
      clampingRect: Box.fromLTWH(66.74, 61.60, 589.63, 822.26),
    );

    expect(result.flip, Flip.none);
    expect(result.rect,
        withTolerance(Box.fromLTWH(259.86, 443.50, 163.75, 440.37)));
    expect(result.resizeMode, ResizeMode.freeform);

    result = BoxTransformer.resize(
      resizeMode: ResizeMode.freeform,
      initialFlip: Flip.none,
      initialBox: Box.fromLTWH(259.86, 443.50, 163.75, 440.37),
      handle: HandlePosition.bottomLeft,
      initialLocalPosition: Vector2(13.20, 13.39),
      allowFlipping: true,
      localPosition: Vector2(-251.07, 45.98),
      clampingRect: Box.fromLTWH(66.74, 61.60, 589.63, 822.26),
    );

    expect(result.flip, Flip.none);
    expect(result.rect,
        withTolerance(Box.fromLTWH(66.74, 443.50, 356.87, 440.37)));
    expect(result.resizeMode, ResizeMode.freeform);

    result = BoxTransformer.resize(
      resizeMode: ResizeMode.freeform,
      initialFlip: Flip.none,
      initialBox: Box.fromLTWH(66.74, 443.50, 356.87, 440.37),
      handle: HandlePosition.bottomLeft,
      initialLocalPosition: Vector2(10.26, 11.98),
      allowFlipping: true,
      localPosition: Vector2(658.46, -273.71),
      clampingRect: Box.fromLTWH(66.74, 61.60, 589.63, 822.26),
    );

    expect(result.flip, Flip.horizontal);
    expect(result.rect,
        withTolerance(Box.fromLTWH(423.61, 443.50, 232.77, 154.68)));
    expect(result.resizeMode, ResizeMode.freeform);

    result = BoxTransformer.resize(
      resizeMode: ResizeMode.freeform,
      initialFlip: Flip.horizontal,
      initialBox: Box.fromLTWH(423.61, 443.50, 232.77, 154.68),
      handle: HandlePosition.bottomRight,
      initialLocalPosition: Vector2(11.80, 14.30),
      allowFlipping: true,
      localPosition: Vector2(-121.04, 325.16),
      clampingRect: Box.fromLTWH(66.74, 61.60, 589.63, 822.26),
    );

    expect(result.flip, Flip.horizontal);
    expect(result.rect,
        withTolerance(Box.fromLTWH(423.61, 443.50, 99.93, 440.37)));
    expect(result.resizeMode, ResizeMode.freeform);

    result = BoxTransformer.resize(
      resizeMode: ResizeMode.freeform,
      initialFlip: Flip.horizontal,
      initialBox: Box.fromLTWH(423.61, 443.50, 99.93, 440.37),
      handle: HandlePosition.bottomRight,
      initialLocalPosition: Vector2(10.58, 9.69),
      allowFlipping: true,
      localPosition: Vector2(186.32, 38.41),
      clampingRect: Box.fromLTWH(66.74, 61.60, 589.63, 822.26),
    );

    expect(result.flip, Flip.horizontal);
    expect(result.rect,
        withTolerance(Box.fromLTWH(423.61, 443.50, 232.77, 440.37)));
    expect(result.resizeMode, ResizeMode.freeform);

    result = BoxTransformer.resize(
      resizeMode: ResizeMode.freeform,
      initialFlip: Flip.horizontal,
      initialBox: Box.fromLTWH(423.61, 443.50, 232.77, 440.37),
      handle: HandlePosition.bottomRight,
      initialLocalPosition: Vector2(16.30, 15.20),
      allowFlipping: true,
      localPosition: Vector2(-616.56, -578.66),
      clampingRect: Box.fromLTWH(66.74, 61.60, 589.63, 822.26),
    );

    expect(result.flip, Flip.vertical);
    expect(result.rect,
        withTolerance(Box.fromLTWH(66.74, 290.01, 356.87, 153.49)));
    expect(result.resizeMode, ResizeMode.freeform);

    result = BoxTransformer.resize(
      resizeMode: ResizeMode.freeform,
      initialFlip: Flip.vertical,
      initialBox: Box.fromLTWH(66.74, 290.01, 356.87, 153.49),
      handle: HandlePosition.topLeft,
      initialLocalPosition: Vector2(14.68, 12.09),
      allowFlipping: true,
      localPosition: Vector2(142.16, -260.77),
      clampingRect: Box.fromLTWH(66.74, 61.60, 589.63, 822.26),
    );

    expect(result.flip, Flip.vertical);
    expect(result.rect,
        withTolerance(Box.fromLTWH(194.23, 61.60, 229.38, 381.89)));
    expect(result.resizeMode, ResizeMode.freeform);

    result = BoxTransformer.resize(
      resizeMode: ResizeMode.freeform,
      initialFlip: Flip.vertical,
      initialBox: Box.fromLTWH(194.23, 61.60, 229.38, 381.89),
      handle: HandlePosition.topLeft,
      initialLocalPosition: Vector2(15.25, 11.87),
      allowFlipping: true,
      localPosition: Vector2(-183.43, -20.02),
      clampingRect: Box.fromLTWH(66.74, 61.60, 589.63, 822.26),
    );

    expect(result.flip, Flip.vertical);
    expect(
        result.rect, withTolerance(Box.fromLTWH(66.74, 61.60, 356.87, 381.89)));
    expect(result.resizeMode, ResizeMode.freeform);

    result = BoxTransformer.resize(
      resizeMode: ResizeMode.freeform,
      initialFlip: Flip.vertical,
      initialBox: Box.fromLTWH(66.74, 61.60, 356.87, 381.89),
      handle: HandlePosition.topLeft,
      initialLocalPosition: Vector2(9.63, 9.23),
      allowFlipping: true,
      localPosition: Vector2(646.74, 264.87),
      clampingRect: Box.fromLTWH(66.74, 61.60, 589.63, 822.26),
    );

    expect(result.flip, Flip.diagonal);
    expect(result.rect,
        withTolerance(Box.fromLTWH(423.61, 317.25, 232.77, 126.25)));
    expect(result.resizeMode, ResizeMode.freeform);

    result = BoxTransformer.resize(
      resizeMode: ResizeMode.freeform,
      initialFlip: Flip.diagonal,
      initialBox: Box.fromLTWH(423.61, 317.25, 232.77, 126.25),
      handle: HandlePosition.topRight,
      initialLocalPosition: Vector2(10.97, 16.57),
      allowFlipping: true,
      localPosition: Vector2(-114.89, -276.88),
      clampingRect: Box.fromLTWH(66.74, 61.60, 589.63, 822.26),
    );

    expect(result.flip, Flip.diagonal);
    expect(result.rect,
        withTolerance(Box.fromLTWH(423.61, 61.60, 106.91, 381.89)));
    expect(result.resizeMode, ResizeMode.freeform);

    result = BoxTransformer.resize(
      resizeMode: ResizeMode.freeform,
      initialFlip: Flip.diagonal,
      initialBox: Box.fromLTWH(423.61, 61.60, 106.91, 381.89),
      handle: HandlePosition.topRight,
      initialLocalPosition: Vector2(12.73, 19.55),
      allowFlipping: true,
      localPosition: Vector2(170.85, -15.75),
      clampingRect: Box.fromLTWH(66.74, 61.60, 589.63, 822.26),
    );

    expect(result.flip, Flip.diagonal);
    expect(result.rect,
        withTolerance(Box.fromLTWH(423.61, 61.60, 232.77, 381.89)));
    expect(result.resizeMode, ResizeMode.freeform);

    result = BoxTransformer.resize(
      resizeMode: ResizeMode.freeform,
      initialFlip: Flip.diagonal,
      initialBox: Box.fromLTWH(423.61, 61.60, 232.77, 381.89),
      handle: HandlePosition.topRight,
      initialLocalPosition: Vector2(9.49, 15.42),
      allowFlipping: true,
      localPosition: Vector2(-487.14, 595.37),
      clampingRect: Box.fromLTWH(66.74, 61.60, 589.63, 822.26),
    );

    expect(result.flip, Flip.none);
    expect(result.rect,
        withTolerance(Box.fromLTWH(159.75, 443.50, 263.86, 198.05)));
    expect(result.resizeMode, ResizeMode.freeform);
  });

  test('Clamped freeform resizing with right handle', () {
    var result = BoxTransformer.resize(
      resizeMode: ResizeMode.freeform,
      initialFlip: Flip.none,
      initialBox: Box.fromLTWH(263.84, 374.23, 263.86, 198.05),
      handle: HandlePosition.right,
      initialLocalPosition: Vector2(15.27, 85.95),
      allowFlipping: true,
      localPosition: Vector2(194.81, 89.98),
      clampingRect: Box.fromLTWH(66.74, 61.60, 589.63, 822.26),
    );

    expect(result.flip, Flip.none);
    expect(result.rect,
        withTolerance(Box.fromLTWH(263.84, 374.23, 392.54, 198.05)));
    expect(result.resizeMode, ResizeMode.freeform);

    result = BoxTransformer.resize(
      resizeMode: ResizeMode.freeform,
      initialFlip: Flip.none,
      initialBox: Box.fromLTWH(263.84, 374.23, 392.54, 198.05),
      handle: HandlePosition.right,
      initialLocalPosition: Vector2(11.09, 89.93),
      allowFlipping: true,
      localPosition: Vector2(-185.55, 94.30),
      clampingRect: Box.fromLTWH(66.74, 61.60, 589.63, 822.26),
    );

    expect(result.flip, Flip.none);
    expect(result.rect,
        withTolerance(Box.fromLTWH(263.84, 374.23, 195.89, 198.05)));
    expect(result.resizeMode, ResizeMode.freeform);

    result = BoxTransformer.resize(
      resizeMode: ResizeMode.freeform,
      initialFlip: Flip.none,
      initialBox: Box.fromLTWH(263.84, 374.23, 195.89, 198.05),
      handle: HandlePosition.right,
      initialLocalPosition: Vector2(12.41, 89.04),
      allowFlipping: true,
      localPosition: Vector2(-289.27, 89.15),
      clampingRect: Box.fromLTWH(66.74, 61.60, 589.63, 822.26),
    );

    expect(result.flip, Flip.horizontal);
    expect(result.rect,
        withTolerance(Box.fromLTWH(158.05, 374.23, 105.79, 198.05)));
    expect(result.resizeMode, ResizeMode.freeform);

    result = BoxTransformer.resize(
      resizeMode: ResizeMode.freeform,
      initialFlip: Flip.horizontal,
      initialBox: Box.fromLTWH(158.05, 374.23, 105.79, 198.05),
      handle: HandlePosition.left,
      initialLocalPosition: Vector2(13.31, 90.88),
      allowFlipping: true,
      localPosition: Vector2(-120.98, 89.46),
      clampingRect: Box.fromLTWH(66.74, 61.60, 589.63, 822.26),
    );

    expect(result.flip, Flip.horizontal);
    expect(result.rect,
        withTolerance(Box.fromLTWH(66.74, 374.23, 197.10, 198.05)));
    expect(result.resizeMode, ResizeMode.freeform);

    result = BoxTransformer.resize(
      resizeMode: ResizeMode.freeform,
      initialFlip: Flip.horizontal,
      initialBox: Box.fromLTWH(66.74, 374.23, 197.10, 198.05),
      handle: HandlePosition.left,
      initialLocalPosition: Vector2(16.04, 91.33),
      allowFlipping: true,
      localPosition: Vector2(476.77, 82.18),
      clampingRect: Box.fromLTWH(66.74, 61.60, 589.63, 822.26),
    );

    expect(result.flip, Flip.none);
    expect(result.rect,
        withTolerance(Box.fromLTWH(263.84, 374.23, 263.63, 198.05)));
    expect(result.resizeMode, ResizeMode.freeform);
  });

  test('Clamped freeform resizing with left handle', () {
    var result = BoxTransformer.resize(
      resizeMode: ResizeMode.freeform,
      initialFlip: Flip.none,
      initialBox: Box.fromLTWH(179.49, 379.55, 263.63, 198.05),
      handle: HandlePosition.left,
      initialLocalPosition: Vector2(13.80, 86.86),
      allowFlipping: true,
      localPosition: Vector2(-185.55, 87.64),
      clampingRect: Box.fromLTWH(66.74, 61.60, 589.63, 822.26),
    );

    expect(result.flip, Flip.none);
    expect(result.rect,
        withTolerance(Box.fromLTWH(66.74, 379.55, 376.38, 198.05)));
    expect(result.resizeMode, ResizeMode.freeform);

    result = BoxTransformer.resize(
      resizeMode: ResizeMode.freeform,
      initialFlip: Flip.none,
      initialBox: Box.fromLTWH(66.74, 379.55, 376.38, 198.05),
      handle: HandlePosition.left,
      initialLocalPosition: Vector2(13.82, 89.09),
      allowFlipping: true,
      localPosition: Vector2(208.03, 90.32),
      clampingRect: Box.fromLTWH(66.74, 61.60, 589.63, 822.26),
    );

    expect(result.flip, Flip.none);
    expect(result.rect,
        withTolerance(Box.fromLTWH(260.95, 379.55, 182.16, 198.05)));
    expect(result.resizeMode, ResizeMode.freeform);

    result = BoxTransformer.resize(
      resizeMode: ResizeMode.freeform,
      initialFlip: Flip.none,
      initialBox: Box.fromLTWH(260.95, 379.55, 182.16, 198.05),
      handle: HandlePosition.left,
      initialLocalPosition: Vector2(14.46, 90.71),
      allowFlipping: true,
      localPosition: Vector2(307.84, 81.41),
      clampingRect: Box.fromLTWH(66.74, 61.60, 589.63, 822.26),
    );

    expect(result.flip, Flip.horizontal);
    expect(result.rect,
        withTolerance(Box.fromLTWH(443.12, 379.55, 111.21, 198.05)));
    expect(result.resizeMode, ResizeMode.freeform);

    result = BoxTransformer.resize(
      resizeMode: ResizeMode.freeform,
      initialFlip: Flip.horizontal,
      initialBox: Box.fromLTWH(443.12, 379.55, 111.21, 198.05),
      handle: HandlePosition.right,
      initialLocalPosition: Vector2(12.76, 89.88),
      allowFlipping: true,
      localPosition: Vector2(174.32, 98.87),
      clampingRect: Box.fromLTWH(66.74, 61.60, 589.63, 822.26),
    );

    expect(result.flip, Flip.horizontal);
    expect(result.rect,
        withTolerance(Box.fromLTWH(443.12, 379.55, 213.26, 198.05)));
    expect(result.resizeMode, ResizeMode.freeform);

    result = BoxTransformer.resize(
      resizeMode: ResizeMode.freeform,
      initialFlip: Flip.horizontal,
      initialBox: Box.fromLTWH(443.12, 379.55, 213.26, 198.05),
      handle: HandlePosition.right,
      initialLocalPosition: Vector2(12.96, 89.81),
      allowFlipping: true,
      localPosition: Vector2(-462.83, 99.48),
      clampingRect: Box.fromLTWH(66.74, 61.60, 589.63, 822.26),
    );

    expect(result.flip, Flip.none);
    expect(result.rect,
        withTolerance(Box.fromLTWH(180.59, 379.55, 262.53, 198.05)));
    expect(result.resizeMode, ResizeMode.freeform);
  });

  test('Clamped freeform resizing with top handle', () {
    var result = BoxTransformer.resize(
      resizeMode: ResizeMode.freeform,
      initialFlip: Flip.none,
      initialBox: Box.fromLTWH(180.59, 379.55, 262.53, 198.05),
      handle: HandlePosition.top,
      initialLocalPosition: Vector2(125.69, 12.95),
      allowFlipping: true,
      localPosition: Vector2(118.80, -360.12),
      clampingRect: Box.fromLTWH(66.74, 61.60, 589.63, 822.26),
    );

    expect(result.flip, Flip.none);
    expect(result.rect,
        withTolerance(Box.fromLTWH(180.59, 61.60, 262.53, 516.00)));
    expect(result.resizeMode, ResizeMode.freeform);

    result = BoxTransformer.resize(
      resizeMode: ResizeMode.freeform,
      initialFlip: Flip.none,
      initialBox: Box.fromLTWH(180.59, 61.60, 262.53, 516.00),
      handle: HandlePosition.top,
      initialLocalPosition: Vector2(121.71, 10.51),
      allowFlipping: true,
      localPosition: Vector2(114.55, 363.27),
      clampingRect: Box.fromLTWH(66.74, 61.60, 589.63, 822.26),
    );

    expect(result.flip, Flip.none);
    expect(result.rect,
        withTolerance(Box.fromLTWH(180.59, 414.36, 262.53, 163.25)));
    expect(result.resizeMode, ResizeMode.freeform);

    result = BoxTransformer.resize(
      resizeMode: ResizeMode.freeform,
      initialFlip: Flip.none,
      initialBox: Box.fromLTWH(180.59, 414.36, 262.53, 163.25),
      handle: HandlePosition.top,
      initialLocalPosition: Vector2(122.25, 9.82),
      allowFlipping: true,
      localPosition: Vector2(125.36, 302.58),
      clampingRect: Box.fromLTWH(66.74, 61.60, 589.63, 822.26),
    );

    expect(result.flip, Flip.vertical);
    expect(result.rect,
        withTolerance(Box.fromLTWH(180.59, 577.61, 262.53, 129.52)));
    expect(result.resizeMode, ResizeMode.freeform);

    result = BoxTransformer.resize(
      resizeMode: ResizeMode.freeform,
      initialFlip: Flip.vertical,
      initialBox: Box.fromLTWH(180.59, 577.61, 262.53, 129.52),
      handle: HandlePosition.bottom,
      initialLocalPosition: Vector2(124.56, 15.56),
      allowFlipping: true,
      localPosition: Vector2(122.70, 238.29),
      clampingRect: Box.fromLTWH(66.74, 61.60, 589.63, 822.26),
    );

    expect(result.flip, Flip.vertical);
    expect(result.rect,
        withTolerance(Box.fromLTWH(180.59, 577.61, 262.53, 306.26)));
    expect(result.resizeMode, ResizeMode.freeform);

    result = BoxTransformer.resize(
      resizeMode: ResizeMode.freeform,
      initialFlip: Flip.vertical,
      initialBox: Box.fromLTWH(180.59, 577.61, 262.53, 306.26),
      handle: HandlePosition.bottom,
      initialLocalPosition: Vector2(116.97, 14.84),
      allowFlipping: true,
      localPosition: Vector2(92.12, -487.95),
      clampingRect: Box.fromLTWH(66.74, 61.60, 589.63, 822.26),
    );

    expect(result.flip, Flip.none);
    expect(result.rect,
        withTolerance(Box.fromLTWH(180.59, 381.07, 262.53, 196.54)));
    expect(result.resizeMode, ResizeMode.freeform);
  });

  test('Clamped freeform resizing with bottom handle', () {
    var result = BoxTransformer.resize(
      resizeMode: ResizeMode.freeform,
      initialFlip: Flip.none,
      initialBox: Box.fromLTWH(180.59, 381.07, 262.53, 196.54),
      handle: HandlePosition.bottom,
      initialLocalPosition: Vector2(119.16, 12.05),
      allowFlipping: true,
      localPosition: Vector2(118.86, 361.12),
      clampingRect: Box.fromLTWH(66.74, 61.60, 589.63, 822.26),
    );

    expect(result.flip, Flip.none);
    expect(result.rect,
        withTolerance(Box.fromLTWH(180.59, 381.07, 262.53, 502.79)));
    expect(result.resizeMode, ResizeMode.freeform);

    result = BoxTransformer.resize(
      resizeMode: ResizeMode.freeform,
      initialFlip: Flip.none,
      initialBox: Box.fromLTWH(180.59, 381.07, 262.53, 502.79),
      handle: HandlePosition.bottom,
      initialLocalPosition: Vector2(120.02, 15.82),
      allowFlipping: true,
      localPosition: Vector2(122.64, -192.89),
      clampingRect: Box.fromLTWH(66.74, 61.60, 589.63, 822.26),
    );

    expect(result.flip, Flip.none);
    expect(result.rect,
        withTolerance(Box.fromLTWH(180.59, 381.07, 262.53, 294.09)));
    expect(result.resizeMode, ResizeMode.freeform);

    result = BoxTransformer.resize(
      resizeMode: ResizeMode.freeform,
      initialFlip: Flip.none,
      initialBox: Box.fromLTWH(180.59, 381.07, 262.53, 294.09),
      handle: HandlePosition.bottom,
      initialLocalPosition: Vector2(120.00, 11.59),
      allowFlipping: true,
      localPosition: Vector2(103.47, -433.26),
      clampingRect: Box.fromLTWH(66.74, 61.60, 589.63, 822.26),
    );

    expect(result.flip, Flip.vertical);
    expect(result.rect,
        withTolerance(Box.fromLTWH(180.59, 230.31, 262.53, 150.76)));
    expect(result.resizeMode, ResizeMode.freeform);

    result = BoxTransformer.resize(
      resizeMode: ResizeMode.freeform,
      initialFlip: Flip.vertical,
      initialBox: Box.fromLTWH(180.59, 230.31, 262.53, 150.76),
      handle: HandlePosition.top,
      initialLocalPosition: Vector2(117.76, 9.44),
      allowFlipping: true,
      localPosition: Vector2(99.38, -210.54),
      clampingRect: Box.fromLTWH(66.74, 61.60, 589.63, 822.26),
    );

    expect(result.flip, Flip.vertical);
    expect(result.rect,
        withTolerance(Box.fromLTWH(180.59, 61.60, 262.53, 319.47)));
    expect(result.resizeMode, ResizeMode.freeform);

    result = BoxTransformer.resize(
      resizeMode: ResizeMode.freeform,
      initialFlip: Flip.vertical,
      initialBox: Box.fromLTWH(180.59, 61.60, 262.53, 319.47),
      handle: HandlePosition.top,
      initialLocalPosition: Vector2(116.95, 9.96),
      allowFlipping: true,
      localPosition: Vector2(132.87, 526.71),
      clampingRect: Box.fromLTWH(66.74, 61.60, 589.63, 822.26),
    );

    expect(result.flip, Flip.none);
    expect(result.rect,
        withTolerance(Box.fromLTWH(180.59, 381.07, 262.53, 197.29)));
    expect(result.resizeMode, ResizeMode.freeform);
  });
}
