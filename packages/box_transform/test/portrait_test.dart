import 'package:test/test.dart';
import 'package:vector_math/vector_math.dart';
import 'package:box_transform/box_transform.dart';
import 'utils.dart';

void main() {
  test('portrait tests', () {
    var result = BoxTransformer.resize(
      resizeMode: ResizeMode.freeform,
      initialFlip: Flip.none,
      initialBox: Box.fromLTWH(377.88, 300.08, 273.78, 341.91),
      handle: HandlePosition.bottomRight,
      initialLocalPosition: Vector2(13.66, 12.66),
      allowFlipping: true,
      localPosition: Vector2(21.19, 11.73),
      clampingRect: Box.fromLTWH(240.98, 39.17, 718.00, 840.12),
    );

    expect(result.flip, Flip.none);
    expect(result.rect,
        withTolerance(Box.fromLTWH(377.88, 300.08, 281.31, 340.98)));
    expect(result.resizeMode, ResizeMode.freeform);

    result = BoxTransformer.resize(
      resizeMode: ResizeMode.scale,
      initialFlip: Flip.none,
      initialBox: Box.fromLTWH(377.88, 300.08, 281.31, 340.98),
      handle: HandlePosition.bottomRight,
      initialLocalPosition: Vector2(12.51, 11.20),
      allowFlipping: true,
      localPosition: Vector2(250.29, 286.18),
      clampingRect: Box.fromLTWH(240.98, 39.17, 718.00, 840.12),
    );

    expect(result.flip, Flip.none);
    expect(result.rect,
        withTolerance(Box.fromLTWH(377.88, 300.08, 477.85, 579.21)));
    expect(result.resizeMode, ResizeMode.scale);

    result = BoxTransformer.resize(
      resizeMode: ResizeMode.scale,
      initialFlip: Flip.none,
      initialBox: Box.fromLTWH(377.88, 300.08, 477.85, 579.21),
      handle: HandlePosition.bottomRight,
      initialLocalPosition: Vector2(12.79, 10.84),
      allowFlipping: true,
      localPosition: Vector2(-611.26, -401.28),
      clampingRect: Box.fromLTWH(240.98, 39.17, 718.00, 840.12),
    );

    expect(result.flip, Flip.horizontal);
    expect(result.rect,
        withTolerance(Box.fromLTWH(240.98, 300.08, 136.89, 165.93)));
    expect(result.resizeMode, ResizeMode.scale);

    result = BoxTransformer.resize(
      resizeMode: ResizeMode.scale,
      initialFlip: Flip.horizontal,
      initialBox: Box.fromLTWH(240.98, 300.08, 136.89, 165.93),
      handle: HandlePosition.bottomLeft,
      initialLocalPosition: Vector2(7.51, 9.64),
      allowFlipping: true,
      localPosition: Vector2(396.74, -431.38),
      clampingRect: Box.fromLTWH(240.98, 39.17, 718.00, 840.12),
    );

    expect(result.flip, Flip.vertical);
    expect(result.rect,
        withTolerance(Box.fromLTWH(377.88, 39.17, 215.25, 260.91)));
    expect(result.resizeMode, ResizeMode.scale);

    result = BoxTransformer.resize(
      resizeMode: ResizeMode.scale,
      initialFlip: Flip.vertical,
      initialBox: Box.fromLTWH(377.88, 39.17, 215.25, 260.91),
      handle: HandlePosition.topRight,
      initialLocalPosition: Vector2(13.85, 10.42),
      allowFlipping: true,
      localPosition: Vector2(-346.86, 2.91),
      clampingRect: Box.fromLTWH(240.98, 39.17, 718.00, 840.12),
    );

    expect(result.flip, Flip.diagonal);
    expect(result.rect,
        withTolerance(Box.fromLTWH(240.98, 134.15, 136.89, 165.93)));
    expect(result.resizeMode, ResizeMode.scale);

    result = BoxTransformer.resize(
      resizeMode: ResizeMode.scale,
      initialFlip: Flip.diagonal,
      initialBox: Box.fromLTWH(240.98, 134.15, 136.89, 165.93),
      handle: HandlePosition.topLeft,
      initialLocalPosition: Vector2(14.56, 10.58),
      allowFlipping: true,
      localPosition: Vector2(439.82, 283.29),
      clampingRect: Box.fromLTWH(240.98, 39.17, 718.00, 840.12),
    );

    expect(result.flip, Flip.none);
    expect(result.rect,
        withTolerance(Box.fromLTWH(377.88, 300.08, 288.36, 349.53)));
    expect(result.resizeMode, ResizeMode.scale);

    result = BoxTransformer.resize(
      resizeMode: ResizeMode.scale,
      initialFlip: Flip.none,
      initialBox: Box.fromLTWH(377.88, 300.08, 288.36, 349.53),
      handle: HandlePosition.topRight,
      initialLocalPosition: Vector2(12.63, 10.08),
      allowFlipping: true,
      localPosition: Vector2(251.95, -283.08),
      clampingRect: Box.fromLTWH(240.98, 39.17, 718.00, 840.12),
    );

    expect(result.flip, Flip.none);
    expect(result.rect,
        withTolerance(Box.fromLTWH(377.88, 39.17, 503.62, 610.44)));
    expect(result.resizeMode, ResizeMode.scale);

    result = BoxTransformer.resize(
      resizeMode: ResizeMode.scale,
      initialFlip: Flip.none,
      initialBox: Box.fromLTWH(377.88, 39.17, 503.62, 610.44),
      handle: HandlePosition.topRight,
      initialLocalPosition: Vector2(11.86, 12.14),
      allowFlipping: true,
      localPosition: Vector2(-704.75, 743.01),
      clampingRect: Box.fromLTWH(240.98, 39.17, 718.00, 840.12),
    );

    expect(result.flip, Flip.diagonal);
    expect(result.rect,
        withTolerance(Box.fromLTWH(240.98, 649.61, 136.89, 165.93)));
    expect(result.resizeMode, ResizeMode.scale);

    result = BoxTransformer.resize(
      resizeMode: ResizeMode.scale,
      initialFlip: Flip.diagonal,
      initialBox: Box.fromLTWH(240.98, 649.61, 136.89, 165.93),
      handle: HandlePosition.bottomLeft,
      initialLocalPosition: Vector2(9.89, 12.66),
      allowFlipping: true,
      localPosition: Vector2(357.11, 106.71),
      clampingRect: Box.fromLTWH(240.98, 39.17, 718.00, 840.12),
    );

    expect(result.flip, Flip.vertical);
    expect(result.rect,
        withTolerance(Box.fromLTWH(377.88, 649.61, 189.49, 229.68)));
    expect(result.resizeMode, ResizeMode.scale);

    result = BoxTransformer.resize(
      resizeMode: ResizeMode.scale,
      initialFlip: Flip.vertical,
      initialBox: Box.fromLTWH(377.88, 649.61, 189.49, 229.68),
      handle: HandlePosition.bottomRight,
      initialLocalPosition: Vector2(17.46, 13.63),
      allowFlipping: true,
      localPosition: Vector2(-335.28, -438.57),
      clampingRect: Box.fromLTWH(240.98, 39.17, 718.00, 840.12),
    );

    expect(result.flip, Flip.horizontal);
    expect(result.rect,
        withTolerance(Box.fromLTWH(240.98, 483.68, 136.89, 165.93)));
    expect(result.resizeMode, ResizeMode.scale);

    result = BoxTransformer.resize(
      resizeMode: ResizeMode.scale,
      initialFlip: Flip.horizontal,
      initialBox: Box.fromLTWH(240.98, 483.68, 136.89, 165.93),
      handle: HandlePosition.topLeft,
      initialLocalPosition: Vector2(11.08, 10.95),
      allowFlipping: true,
      localPosition: Vector2(415.06, -157.05),
      clampingRect: Box.fromLTWH(240.98, 39.17, 718.00, 840.12),
    );

    expect(result.flip, Flip.none);
    expect(result.rect,
        withTolerance(Box.fromLTWH(377.88, 315.67, 275.50, 333.94)));
    expect(result.resizeMode, ResizeMode.scale);

    result = BoxTransformer.resize(
      resizeMode: ResizeMode.symmetricScale,
      initialFlip: Flip.none,
      initialBox: Box.fromLTWH(377.88, 315.67, 275.50, 333.94),
      handle: HandlePosition.bottomRight,
      initialLocalPosition: Vector2(11.27, 10.89),
      allowFlipping: true,
      localPosition: Vector2(188.70, 249.05),
      clampingRect: Box.fromLTWH(240.98, 39.17, 718.00, 840.12),
    );

    expect(result.flip, Flip.none);
    expect(result.rect,
        withTolerance(Box.fromLTWH(240.98, 149.74, 549.29, 665.80)));
    expect(result.resizeMode, ResizeMode.symmetricScale);

    result = BoxTransformer.resize(
      resizeMode: ResizeMode.symmetricScale,
      initialFlip: Flip.none,
      initialBox: Box.fromLTWH(240.98, 149.74, 549.29, 665.80),
      handle: HandlePosition.bottomRight,
      initialLocalPosition: Vector2(11.84, 9.66),
      allowFlipping: true,
      localPosition: Vector2(-550.62, -567.98),
      clampingRect: Box.fromLTWH(240.98, 39.17, 718.00, 840.12),
    );

    expect(result.flip, Flip.diagonal);
    expect(result.rect,
        withTolerance(Box.fromLTWH(240.98, 149.74, 549.29, 665.80)));
    expect(result.resizeMode, ResizeMode.symmetricScale);

    result = BoxTransformer.resize(
      resizeMode: ResizeMode.symmetricScale,
      initialFlip: Flip.diagonal,
      initialBox: Box.fromLTWH(240.98, 149.74, 549.29, 665.80),
      handle: HandlePosition.topLeft,
      initialLocalPosition: Vector2(10.02, 13.48),
      allowFlipping: true,
      localPosition: Vector2(418.00, 438.61),
      clampingRect: Box.fromLTWH(240.98, 39.17, 718.00, 840.12),
    );

    expect(result.flip, Flip.none);
    expect(result.rect,
        withTolerance(Box.fromLTWH(382.30, 321.03, 266.65, 323.21)));
    expect(result.resizeMode, ResizeMode.symmetricScale);
  });
}
