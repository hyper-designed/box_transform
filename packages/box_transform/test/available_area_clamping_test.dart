import 'package:test/test.dart';
import 'package:vector_math/vector_math.dart';
import 'package:box_transform/box_transform.dart';
import 'utils.dart';

void main() {
  test('Initial rect clamping with bottom handle', () {
    var result = BoxTransformer.resize(
      resizeMode: ResizeMode.scale,
      initialFlip: Flip.none,
      initialBox: Box.fromLTWH(139.05, 247.32, 447.52, 332.15),
      handle: HandlePosition.bottom,
      initialLocalPosition: Vector2(214.65, 14.77),
      flipRect: true,
      localPosition: Vector2(215.94, -567.18),
      clampingRect: Box.fromLTWH(66.74, 61.60, 589.63, 822.26),
    );

    expect(result.flip, Flip.vertical);
    expect(result.rect,
        withTolerance(Box.fromLTWH(237.69, 61.60, 250.22, 185.72)));
    expect(result.resizeMode, ResizeMode.scale);

    result = BoxTransformer.resize(
      resizeMode: ResizeMode.scale,
      initialFlip: Flip.vertical,
      initialBox: Box.fromLTWH(237.69, 61.60, 250.22, 185.72),
      handle: HandlePosition.top,
      initialLocalPosition: Vector2(113.00, 11.86),
      flipRect: true,
      localPosition: Vector2(116.45, 474.48),
      clampingRect: Box.fromLTWH(66.74, 61.60, 589.63, 822.26),
    );

    expect(result.flip, Flip.none);
    expect(result.rect,
        withTolerance(Box.fromLTWH(176.27, 247.32, 373.08, 276.90)));
    expect(result.resizeMode, ResizeMode.scale);
  });

  test('Initial rect clamping with top handle', () {
    var result = BoxTransformer.resize(
      resizeMode: ResizeMode.scale,
      initialFlip: Flip.none,
      initialBox: Box.fromLTWH(120.09, 320.14, 479.09, 355.58),
      handle: HandlePosition.top,
      initialLocalPosition: Vector2(228.24, 11.79),
      flipRect: true,
      localPosition: Vector2(225.36, 625.18),
      clampingRect: Box.fromLTWH(66.74, 61.60, 589.63, 822.26),
    );

    expect(result.flip, Flip.vertical);
    expect(result.rect,
        withTolerance(Box.fromLTWH(219.42, 675.73, 280.43, 208.14)));
    expect(result.resizeMode, ResizeMode.scale);

    result = BoxTransformer.resize(
      resizeMode: ResizeMode.scale,
      initialFlip: Flip.vertical,
      initialBox: Box.fromLTWH(219.42, 675.73, 280.43, 208.14),
      handle: HandlePosition.bottom,
      initialLocalPosition: Vector2(126.47, 15.48),
      flipRect: true,
      localPosition: Vector2(99.76, -486.38),
      clampingRect: Box.fromLTWH(66.74, 61.60, 589.63, 822.26),
    );

    expect(result.flip, Flip.none);
    expect(result.rect,
        withTolerance(Box.fromLTWH(161.77, 382.01, 395.74, 293.72)));
    expect(result.resizeMode, ResizeMode.scale);
  });

  test('Initial rect clamping with right handle', () {
    var result = BoxTransformer.resize(
      resizeMode: ResizeMode.scale,
      initialFlip: Flip.none,
      initialBox: Box.fromLTWH(239.95, 330.43, 352.88, 261.91),
      handle: HandlePosition.right,
      initialLocalPosition: Vector2(12.56, 119.41),
      flipRect: true,
      localPosition: Vector2(-564.79, 117.79),
      clampingRect: Box.fromLTWH(66.74, 61.60, 589.63, 822.26),
    );

    expect(result.flip, Flip.horizontal);
    expect(result.rect,
        withTolerance(Box.fromLTWH(66.74, 397.11, 173.21, 128.56)));
    expect(result.resizeMode, ResizeMode.scale);

    result = BoxTransformer.resize(
      resizeMode: ResizeMode.scale,
      initialFlip: Flip.horizontal,
      initialBox: Box.fromLTWH(66.74, 397.11, 173.21, 128.56),
      handle: HandlePosition.left,
      initialLocalPosition: Vector2(14.10, 58.58),
      flipRect: true,
      localPosition: Vector2(506.66, 34.08),
      clampingRect: Box.fromLTWH(66.74, 61.60, 589.63, 822.26),
    );

    expect(result.flip, Flip.none);
    expect(result.rect,
        withTolerance(Box.fromLTWH(239.95, 342.87, 319.35, 237.02)));
    expect(result.resizeMode, ResizeMode.scale);
  });

  test('Initial rect clamping with left handle', () {
    var result = BoxTransformer.resize(
      resizeMode: ResizeMode.scale,
      initialFlip: Flip.none,
      initialBox: Box.fromLTWH(135.70, 326.62, 377.01, 279.82),
      handle: HandlePosition.left,
      initialLocalPosition: Vector2(12.83, 130.37),
      flipRect: true,
      localPosition: Vector2(581.46, 120.94),
      clampingRect: Box.fromLTWH(66.74, 61.60, 589.63, 822.26),
    );

    expect(result.flip, Flip.horizontal);
    expect(result.rect,
        withTolerance(Box.fromLTWH(512.71, 413.21, 143.66, 106.63)));
    expect(result.resizeMode, ResizeMode.scale);

    result = BoxTransformer.resize(
      resizeMode: ResizeMode.scale,
      initialFlip: Flip.horizontal,
      initialBox: Box.fromLTWH(512.71, 413.21, 143.66, 106.63),
      handle: HandlePosition.right,
      initialLocalPosition: Vector2(15.55, 38.53),
      flipRect: true,
      localPosition: Vector2(-451.93, 55.67),
      clampingRect: Box.fromLTWH(66.74, 61.60, 589.63, 822.26),
    );

    expect(result.flip, Flip.none);
    expect(result.rect,
        withTolerance(Box.fromLTWH(188.89, 346.36, 323.82, 240.34)));
    expect(result.resizeMode, ResizeMode.scale);
  });
}
