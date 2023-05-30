import 'package:test/test.dart';
import 'package:vector_math/vector_math.dart';
import 'package:box_transform/box_transform.dart';
import 'utils.dart';

void main() {
  test('symmetric scaled constrained resizing with corner handles', () {
    var result = BoxTransformer.resize(
      resizeMode: ResizeMode.symmetricScale,
      initialFlip: Flip.none,
      initialBox: Box.fromLTWH(199.08, 357.66, 327.82, 220.10),
      handle: HandlePosition.bottomRight,
      initialLocalPosition: Vector2(13.33, 10.62),
      allowFlipping: true,
      localPosition: Vector2(201.75, 120.72),
      clampingRect: Box.fromLTWH(66.08, 97.05, 604.30, 743.06),
      constraints: Constraints(
          minWidth: 100.00,
          minHeight: 100.00,
          maxWidth: 500.00,
          maxHeight: 500.00),
    );

    expect(result.flip, Flip.none);
    expect(result.rect,
        withTolerance(Box.fromLTWH(112.99, 299.86, 500.00, 335.71)));
    expect(result.resizeMode, ResizeMode.symmetricScale);

    result = BoxTransformer.resize(
      resizeMode: ResizeMode.symmetricScale,
      initialFlip: Flip.none,
      initialBox: Box.fromLTWH(112.99, 299.86, 500.00, 335.71),
      handle: HandlePosition.bottomRight,
      initialLocalPosition: Vector2(14.18, 13.81),
      allowFlipping: true,
      localPosition: Vector2(-237.82, -148.67),
      clampingRect: Box.fromLTWH(66.08, 97.05, 604.30, 743.06),
      constraints: Constraints(
          minWidth: 100.00,
          minHeight: 100.00,
          maxWidth: 500.00,
          maxHeight: 500.00),
    );

    expect(result.flip, Flip.horizontal);
    expect(result.rect,
        withTolerance(Box.fromLTWH(288.52, 417.72, 148.94, 100.00)));
    expect(result.resizeMode, ResizeMode.symmetricScale);

    result = BoxTransformer.resize(
      resizeMode: ResizeMode.symmetricScale,
      initialFlip: Flip.none,
      initialBox: Box.fromLTWH(288.52, 417.72, 148.94, 100.00),
      handle: HandlePosition.bottomRight,
      initialLocalPosition: Vector2(13.09, 13.56),
      allowFlipping: true,
      localPosition: Vector2(267.89, 205.86),
      clampingRect: Box.fromLTWH(66.08, 97.05, 604.30, 743.06),
      constraints: Constraints(
          minWidth: 100.00,
          minHeight: 100.00,
          maxWidth: 500.00,
          maxHeight: 500.00),
    );

    expect(result.flip, Flip.none);
    expect(result.rect,
        withTolerance(Box.fromLTWH(112.99, 299.86, 500.00, 335.71)));
    expect(result.resizeMode, ResizeMode.symmetricScale);

    result = BoxTransformer.resize(
      resizeMode: ResizeMode.symmetricScale,
      initialFlip: Flip.none,
      initialBox: Box.fromLTWH(112.99, 299.86, 500.00, 335.71),
      handle: HandlePosition.bottomRight,
      initialLocalPosition: Vector2(11.00, 13.72),
      allowFlipping: true,
      localPosition: Vector2(-201.40, -128.14),
      clampingRect: Box.fromLTWH(66.08, 97.05, 604.30, 743.06),
      constraints: Constraints(
          minWidth: 100.00,
          minHeight: 100.00,
          maxWidth: 500.00,
          maxHeight: 500.00),
    );

    expect(result.flip, Flip.none);
    expect(result.rect,
        withTolerance(Box.fromLTWH(288.52, 417.72, 148.94, 100.00)));
    expect(result.resizeMode, ResizeMode.symmetricScale);

    result = BoxTransformer.resize(
      resizeMode: ResizeMode.symmetricScale,
      initialFlip: Flip.none,
      initialBox: Box.fromLTWH(288.52, 417.72, 148.94, 100.00),
      handle: HandlePosition.bottomRight,
      initialLocalPosition: Vector2(11.90, 13.45),
      allowFlipping: true,
      localPosition: Vector2(-552.49, -374.38),
      clampingRect: Box.fromLTWH(66.08, 97.05, 604.30, 743.06),
      constraints: Constraints(
          minWidth: 100.00,
          minHeight: 100.00,
          maxWidth: 500.00,
          maxHeight: 500.00),
    );

    expect(result.flip, Flip.diagonal);
    expect(result.rect,
        withTolerance(Box.fromLTWH(112.99, 299.86, 500.00, 335.71)));
    expect(result.resizeMode, ResizeMode.symmetricScale);

    result = BoxTransformer.resize(
      resizeMode: ResizeMode.symmetricScale,
      initialFlip: Flip.diagonal,
      initialBox: Box.fromLTWH(112.99, 299.86, 500.00, 335.71),
      handle: HandlePosition.topLeft,
      initialLocalPosition: Vector2(12.08, 10.76),
      allowFlipping: true,
      localPosition: Vector2(109.89, 582.17),
      clampingRect: Box.fromLTWH(66.08, 97.05, 604.30, 743.06),
      constraints: Constraints(
          minWidth: 100.00,
          minHeight: 100.00,
          maxWidth: 500.00,
          maxHeight: 500.00),
    );

    expect(result.flip, Flip.horizontal);
    expect(result.rect,
        withTolerance(Box.fromLTWH(112.99, 299.86, 500.00, 335.71)));
    expect(result.resizeMode, ResizeMode.symmetricScale);

    result = BoxTransformer.resize(
      resizeMode: ResizeMode.symmetricScale,
      initialFlip: Flip.horizontal,
      initialBox: Box.fromLTWH(112.99, 299.86, 500.00, 335.71),
      handle: HandlePosition.bottomLeft,
      initialLocalPosition: Vector2(8.42, 15.72),
      allowFlipping: true,
      localPosition: Vector2(605.93, -442.34),
      clampingRect: Box.fromLTWH(66.08, 97.05, 604.30, 743.06),
      constraints: Constraints(
          minWidth: 100.00,
          minHeight: 100.00,
          maxWidth: 500.00,
          maxHeight: 500.00),
    );

    expect(result.flip, Flip.vertical);
    expect(result.rect,
        withTolerance(Box.fromLTWH(112.99, 299.86, 500.00, 335.71)));
    expect(result.resizeMode, ResizeMode.symmetricScale);

    result = BoxTransformer.resize(
      resizeMode: ResizeMode.symmetricScale,
      initialFlip: Flip.vertical,
      initialBox: Box.fromLTWH(112.99, 299.86, 500.00, 335.71),
      handle: HandlePosition.topRight,
      initialLocalPosition: Vector2(13.89, 13.42),
      allowFlipping: true,
      localPosition: Vector2(-191.73, 214.45),
      clampingRect: Box.fromLTWH(66.08, 97.05, 604.30, 743.06),
      constraints: Constraints(
          minWidth: 100.00,
          minHeight: 100.00,
          maxWidth: 500.00,
          maxHeight: 500.00),
    );

    expect(result.flip, Flip.none);
    expect(result.rect,
        withTolerance(Box.fromLTWH(288.52, 417.72, 148.94, 100.00)));
    expect(result.resizeMode, ResizeMode.symmetricScale);
  });

  test('symmetric scaled constrained resizing with side handles', () {
    var result = BoxTransformer.resize(
      resizeMode: ResizeMode.symmetricScale,
      initialFlip: Flip.none,
      initialBox: Box.fromLTWH(288.52, 417.72, 148.94, 100.00),
      handle: HandlePosition.right,
      initialLocalPosition: Vector2(16.45, 35.45),
      allowFlipping: true,
      localPosition: Vector2(303.20, 35.41),
      clampingRect: Box.fromLTWH(66.08, 97.05, 604.30, 743.06),
      constraints: Constraints(
          minWidth: 100.00,
          minHeight: 100.00,
          maxWidth: 500.00,
          maxHeight: 500.00),
    );

    expect(result.flip, Flip.none);
    expect(result.rect,
        withTolerance(Box.fromLTWH(112.99, 299.86, 500.00, 335.71)));
    expect(result.resizeMode, ResizeMode.symmetricScale);

    result = BoxTransformer.resize(
      resizeMode: ResizeMode.symmetricScale,
      initialFlip: Flip.none,
      initialBox: Box.fromLTWH(112.99, 299.86, 500.00, 335.71),
      handle: HandlePosition.right,
      initialLocalPosition: Vector2(17.52, 160.59),
      allowFlipping: true,
      localPosition: Vector2(-215.09, 160.87),
      clampingRect: Box.fromLTWH(66.08, 97.05, 604.30, 743.06),
      constraints: Constraints(
          minWidth: 100.00,
          minHeight: 100.00,
          maxWidth: 500.00,
          maxHeight: 500.00),
    );

    expect(result.flip, Flip.none);
    expect(result.rect,
        withTolerance(Box.fromLTWH(288.52, 417.72, 148.94, 100.00)));
    expect(result.resizeMode, ResizeMode.symmetricScale);

    result = BoxTransformer.resize(
      resizeMode: ResizeMode.symmetricScale,
      initialFlip: Flip.none,
      initialBox: Box.fromLTWH(288.52, 417.72, 148.94, 100.00),
      handle: HandlePosition.left,
      initialLocalPosition: Vector2(12.47, 42.90),
      allowFlipping: true,
      localPosition: Vector2(-265.37, 30.85),
      clampingRect: Box.fromLTWH(66.08, 97.05, 604.30, 743.06),
      constraints: Constraints(
          minWidth: 100.00,
          minHeight: 100.00,
          maxWidth: 500.00,
          maxHeight: 500.00),
    );

    expect(result.flip, Flip.none);
    expect(result.rect,
        withTolerance(Box.fromLTWH(112.99, 299.86, 500.00, 335.71)));
    expect(result.resizeMode, ResizeMode.symmetricScale);

    result = BoxTransformer.resize(
      resizeMode: ResizeMode.symmetricScale,
      initialFlip: Flip.none,
      initialBox: Box.fromLTWH(112.99, 299.86, 500.00, 335.71),
      handle: HandlePosition.left,
      initialLocalPosition: Vector2(12.82, 161.11),
      allowFlipping: true,
      localPosition: Vector2(633.14, 153.91),
      clampingRect: Box.fromLTWH(66.08, 97.05, 604.30, 743.06),
      constraints: Constraints(
          minWidth: 100.00,
          minHeight: 100.00,
          maxWidth: 500.00,
          maxHeight: 500.00),
    );

    expect(result.flip, Flip.horizontal);
    expect(result.rect,
        withTolerance(Box.fromLTWH(112.99, 299.86, 500.00, 335.71)));
    expect(result.resizeMode, ResizeMode.symmetricScale);

    result = BoxTransformer.resize(
      resizeMode: ResizeMode.symmetricScale,
      initialFlip: Flip.horizontal,
      initialBox: Box.fromLTWH(112.99, 299.86, 500.00, 335.71),
      handle: HandlePosition.top,
      initialLocalPosition: Vector2(233.21, 13.01),
      allowFlipping: true,
      localPosition: Vector2(238.98, 475.07),
      clampingRect: Box.fromLTWH(66.08, 97.05, 604.30, 743.06),
      constraints: Constraints(
          minWidth: 100.00,
          minHeight: 100.00,
          maxWidth: 500.00,
          maxHeight: 500.00),
    );

    expect(result.flip, Flip.diagonal);
    expect(result.rect,
        withTolerance(Box.fromLTWH(112.99, 299.86, 500.00, 335.71)));
    expect(result.resizeMode, ResizeMode.symmetricScale);

    result = BoxTransformer.resize(
      resizeMode: ResizeMode.symmetricScale,
      initialFlip: Flip.diagonal,
      initialBox: Box.fromLTWH(112.99, 299.86, 500.00, 335.71),
      handle: HandlePosition.bottom,
      initialLocalPosition: Vector2(236.69, 14.92),
      allowFlipping: true,
      localPosition: Vector2(242.08, -183.48),
      clampingRect: Box.fromLTWH(66.08, 97.05, 604.30, 743.06),
      constraints: Constraints(
          minWidth: 100.00,
          minHeight: 100.00,
          maxWidth: 500.00,
          maxHeight: 500.00),
    );

    expect(result.flip, Flip.horizontal);
    expect(result.rect,
        withTolerance(Box.fromLTWH(288.52, 417.72, 148.94, 100.00)));
    expect(result.resizeMode, ResizeMode.symmetricScale);

    result = BoxTransformer.resize(
      resizeMode: ResizeMode.symmetricScale,
      initialFlip: Flip.horizontal,
      initialBox: Box.fromLTWH(288.52, 417.72, 148.94, 100.00),
      handle: HandlePosition.left,
      initialLocalPosition: Vector2(13.18, 33.17),
      allowFlipping: true,
      localPosition: Vector2(267.12, 44.93),
      clampingRect: Box.fromLTWH(66.08, 97.05, 604.30, 743.06),
      constraints: Constraints(
          minWidth: 100.00,
          minHeight: 100.00,
          maxWidth: 500.00,
          maxHeight: 500.00),
    );

    expect(result.flip, Flip.none);
    expect(result.rect,
        withTolerance(Box.fromLTWH(183.51, 347.21, 358.95, 241.01)));
    expect(result.resizeMode, ResizeMode.symmetricScale);

    result = BoxTransformer.resize(
      resizeMode: ResizeMode.symmetricScale,
      initialFlip: Flip.none,
      initialBox: Box.fromLTWH(183.51, 347.21, 358.95, 241.01),
      handle: HandlePosition.right,
      initialLocalPosition: Vector2(12.03, 108.52),
      allowFlipping: true,
      localPosition: Vector2(-156.84, 105.89),
      clampingRect: Box.fromLTWH(66.08, 97.05, 604.30, 743.06),
      constraints: Constraints(
          minWidth: 100.00,
          minHeight: 100.00,
          maxWidth: 500.00,
          maxHeight: 500.00),
    );

    expect(result.flip, Flip.none);
    expect(result.rect,
        withTolerance(Box.fromLTWH(288.52, 417.72, 148.94, 100.00)));
    expect(result.resizeMode, ResizeMode.symmetricScale);
  });
}
