import 'package:test/test.dart';
import 'package:vector_math/vector_math.dart';
import 'package:box_transform/box_transform.dart';
import 'utils.dart';

void main() {
  test('scaled constrained resizing with bottom right handle', () {
    var result = BoxTransformer.resize(
      resizeMode: ResizeMode.scale,
      initialFlip: Flip.none,
      initialBox: Box.fromLTWH(109.49, 392.15, 377.29, 250.72),
      handle: HandlePosition.bottomRight,
      initialLocalPosition: Vector2(13.79, 13.41),
      flipRect: true,
      localPosition: Vector2(170.68, 109.31),
      clampingRect: Box.fromLTWH(66.08, 97.05, 604.30, 743.06),
      constraints: Constraints(
          minWidth: 100.00,
          minHeight: 100.00,
          maxWidth: 500.00,
          maxHeight: 500.00),
    );

    expect(result.flip, Flip.none);
    expect(result.rect,
        withTolerance(Box.fromLTWH(109.49, 392.15, 500.00, 332.27)));
    expect(result.resizeMode, ResizeMode.scale);

    result = BoxTransformer.resize(
      resizeMode: ResizeMode.scale,
      initialFlip: Flip.none,
      initialBox: Box.fromLTWH(109.49, 392.15, 500.00, 332.27),
      handle: HandlePosition.bottomRight,
      initialLocalPosition: Vector2(11.28, 10.84),
      flipRect: true,
      localPosition: Vector2(-470.09, -298.10),
      clampingRect: Box.fromLTWH(66.08, 97.05, 604.30, 743.06),
      constraints: Constraints(
          minWidth: 100.00,
          minHeight: 100.00,
          maxWidth: 500.00,
          maxHeight: 500.00),
    );

    expect(result.flip, Flip.none);
    expect(result.rect,
        withTolerance(Box.fromLTWH(109.49, 392.15, 150.48, 100.00)));
    expect(result.resizeMode, ResizeMode.scale);

    result = BoxTransformer.resize(
      resizeMode: ResizeMode.scale,
      initialFlip: Flip.none,
      initialBox: Box.fromLTWH(109.49, 392.15, 150.48, 100.00),
      handle: HandlePosition.bottomRight,
      initialLocalPosition: Vector2(13.92, 15.01),
      flipRect: true,
      localPosition: Vector2(-110.34, -130.76),
      clampingRect: Box.fromLTWH(66.08, 97.05, 604.30, 743.06),
      constraints: Constraints(
          minWidth: 100.00,
          minHeight: 100.00,
          maxWidth: 500.00,
          maxHeight: 500.00),
    );

    expect(result.flip, Flip.vertical);
    expect(result.rect,
        withTolerance(Box.fromLTWH(109.49, 292.15, 150.48, 100.00)));
    expect(result.resizeMode, ResizeMode.scale);

    result = BoxTransformer.resize(
      resizeMode: ResizeMode.scale,
      initialFlip: Flip.vertical,
      initialBox: Box.fromLTWH(109.49, 292.15, 150.48, 100.00),
      handle: HandlePosition.topRight,
      initialLocalPosition: Vector2(14.35, 13.82),
      flipRect: true,
      localPosition: Vector2(158.61, 314.58),
      clampingRect: Box.fromLTWH(66.08, 97.05, 604.30, 743.06),
      constraints: Constraints(
          minWidth: 100.00,
          minHeight: 100.00,
          maxWidth: 500.00,
          maxHeight: 500.00),
    );

    expect(result.flip, Flip.none);
    expect(result.rect,
        withTolerance(Box.fromLTWH(109.49, 392.15, 302.10, 200.76)));
    expect(result.resizeMode, ResizeMode.scale);

    result = BoxTransformer.resize(
      resizeMode: ResizeMode.scale,
      initialFlip: Flip.none,
      initialBox: Box.fromLTWH(109.49, 392.15, 302.10, 200.76),
      handle: HandlePosition.bottomRight,
      initialLocalPosition: Vector2(13.82, 11.28),
      flipRect: true,
      localPosition: Vector2(-385.89, -292.03),
      clampingRect: Box.fromLTWH(66.08, 97.05, 604.30, 743.06),
      constraints: Constraints(
          minWidth: 100.00,
          minHeight: 100.00,
          maxWidth: 500.00,
          maxHeight: 500.00),
    );

    expect(result.flip, Flip.diagonal);
    expect(result.rect,
        withTolerance(Box.fromLTWH(109.49, 392.15, 150.48, 100.00)));
    expect(result.resizeMode, ResizeMode.scale);
  });

  test('scaled constrained resizing with top-left handle', () {
    var result = BoxTransformer.resize(
      resizeMode: ResizeMode.scale,
      initialFlip: Flip.none,
      initialBox: Box.fromLTWH(309.86, 237.36, 317.12, 213.91),
      handle: HandlePosition.topLeft,
      initialLocalPosition: Vector2(14.30, 15.56),
      flipRect: true,
      localPosition: Vector2(-237.11, -171.12),
      clampingRect: Box.fromLTWH(66.08, 97.05, 604.30, 743.06),
      constraints: Constraints(
          minWidth: 100.00,
          minHeight: 100.00,
          maxWidth: 500.00,
          maxHeight: 500.00),
    );

    expect(result.flip, Flip.none);
    expect(result.rect,
        withTolerance(Box.fromLTWH(126.98, 114.01, 500.00, 337.26)));
    expect(result.resizeMode, ResizeMode.scale);

    result = BoxTransformer.resize(
      resizeMode: ResizeMode.scale,
      initialFlip: Flip.none,
      initialBox: Box.fromLTWH(126.98, 114.01, 500.00, 337.26),
      handle: HandlePosition.topLeft,
      initialLocalPosition: Vector2(15.37, 13.55),
      flipRect: true,
      localPosition: Vector2(414.71, 301.99),
      clampingRect: Box.fromLTWH(66.08, 97.05, 604.30, 743.06),
      constraints: Constraints(
          minWidth: 100.00,
          minHeight: 100.00,
          maxWidth: 500.00,
          maxHeight: 500.00),
    );

    expect(result.flip, Flip.none);
    expect(result.rect,
        withTolerance(Box.fromLTWH(478.72, 351.27, 148.25, 100.00)));
    expect(result.resizeMode, ResizeMode.scale);

    result = BoxTransformer.resize(
      resizeMode: ResizeMode.scale,
      initialFlip: Flip.none,
      initialBox: Box.fromLTWH(478.72, 351.27, 148.25, 100.00),
      handle: HandlePosition.topLeft,
      initialLocalPosition: Vector2(12.30, 9.30),
      flipRect: true,
      localPosition: Vector2(101.60, 164.42),
      clampingRect: Box.fromLTWH(66.08, 97.05, 604.30, 743.06),
      constraints: Constraints(
          minWidth: 100.00,
          minHeight: 100.00,
          maxWidth: 500.00,
          maxHeight: 500.00),
    );

    expect(result.flip, Flip.vertical);
    expect(result.rect,
        withTolerance(Box.fromLTWH(478.72, 451.27, 148.25, 100.00)));
    expect(result.resizeMode, ResizeMode.scale);

    result = BoxTransformer.resize(
      resizeMode: ResizeMode.scale,
      initialFlip: Flip.vertical,
      initialBox: Box.fromLTWH(478.72, 451.27, 148.25, 100.00),
      handle: HandlePosition.bottomLeft,
      initialLocalPosition: Vector2(13.94, 12.45),
      flipRect: true,
      localPosition: Vector2(-391.77, 278.36),
      clampingRect: Box.fromLTWH(66.08, 97.05, 604.30, 743.06),
      constraints: Constraints(
          minWidth: 100.00,
          minHeight: 100.00,
          maxWidth: 500.00,
          maxHeight: 500.00),
    );

    expect(result.flip, Flip.vertical);
    expect(result.rect,
        withTolerance(Box.fromLTWH(126.98, 451.27, 500.00, 337.26)));
    expect(result.resizeMode, ResizeMode.scale);

    result = BoxTransformer.resize(
      resizeMode: ResizeMode.scale,
      initialFlip: Flip.vertical,
      initialBox: Box.fromLTWH(126.98, 451.27, 500.00, 337.26),
      handle: HandlePosition.bottomLeft,
      initialLocalPosition: Vector2(12.72, 12.67),
      flipRect: true,
      localPosition: Vector2(116.25, -568.74),
      clampingRect: Box.fromLTWH(66.08, 97.05, 604.30, 743.06),
      constraints: Constraints(
          minWidth: 100.00,
          minHeight: 100.00,
          maxWidth: 500.00,
          maxHeight: 500.00),
    );

    expect(result.flip, Flip.none);
    expect(result.rect,
        withTolerance(Box.fromLTWH(230.51, 183.84, 396.47, 267.43)));
    expect(result.resizeMode, ResizeMode.scale);

    result = BoxTransformer.resize(
      resizeMode: ResizeMode.scale,
      initialFlip: Flip.none,
      initialBox: Box.fromLTWH(230.51, 183.84, 396.47, 267.43),
      handle: HandlePosition.topLeft,
      initialLocalPosition: Vector2(13.55, 14.49),
      flipRect: true,
      localPosition: Vector2(504.42, 386.89),
      clampingRect: Box.fromLTWH(66.08, 97.05, 604.30, 743.06),
      constraints: Constraints(
          minWidth: 100.00,
          minHeight: 100.00,
          maxWidth: 500.00,
          maxHeight: 500.00),
    );

    expect(result.flip, Flip.diagonal);
    expect(result.rect,
        withTolerance(Box.fromLTWH(478.72, 351.27, 148.25, 100.00)));
    expect(result.resizeMode, ResizeMode.scale);

    result = BoxTransformer.resize(
      resizeMode: ResizeMode.scale,
      initialFlip: Flip.diagonal,
      initialBox: Box.fromLTWH(478.72, 351.27, 148.25, 100.00),
      handle: HandlePosition.topLeft,
      initialLocalPosition: Vector2(11.72, 16.35),
      flipRect: true,
      localPosition: Vector2(270.24, -12.09),
      clampingRect: Box.fromLTWH(66.08, 97.05, 604.30, 743.06),
      constraints: Constraints(
          minWidth: 100.00,
          minHeight: 100.00,
          maxWidth: 500.00,
          maxHeight: 500.00),
    );

    expect(result.flip, Flip.vertical);
    expect(result.rect,
        withTolerance(Box.fromLTWH(478.72, 351.27, 148.25, 100.00)));
    expect(result.resizeMode, ResizeMode.scale);
  });

  test('scaled constrained resizing with bottom-left handle', () {
    var result = BoxTransformer.resize(
      resizeMode: ResizeMode.scale,
      initialFlip: Flip.none,
      initialBox: Box.fromLTWH(271.51, 498.59, 354.03, 237.71),
      handle: HandlePosition.bottomLeft,
      initialLocalPosition: Vector2(13.87, 9.89),
      flipRect: true,
      localPosition: Vector2(295.75, -182.07),
      clampingRect: Box.fromLTWH(66.08, 97.05, 604.30, 743.06),
      constraints: Constraints(
          minWidth: 100.00,
          minHeight: 100.00,
          maxWidth: 500.00,
          maxHeight: 500.00),
    );

    expect(result.flip, Flip.none);
    expect(result.rect,
        withTolerance(Box.fromLTWH(476.61, 498.59, 148.94, 100.00)));
    expect(result.resizeMode, ResizeMode.scale);

    result = BoxTransformer.resize(
      resizeMode: ResizeMode.scale,
      initialFlip: Flip.none,
      initialBox: Box.fromLTWH(479.89, 470.95, 148.94, 100.00),
      handle: HandlePosition.bottomLeft,
      initialLocalPosition: Vector2(12.52, 13.53),
      flipRect: true,
      localPosition: Vector2(-368.45, 274.00),
      clampingRect: Box.fromLTWH(66.08, 97.05, 604.30, 743.06),
      constraints: Constraints(
          minWidth: 100.00,
          minHeight: 100.00,
          maxWidth: 500.00,
          maxHeight: 500.00),
    );

    expect(result.flip, Flip.none);
    expect(result.rect,
        withTolerance(Box.fromLTWH(128.83, 470.95, 500.00, 335.71)));
    expect(result.resizeMode, ResizeMode.scale);

    result = BoxTransformer.resize(
      resizeMode: ResizeMode.scale,
      initialFlip: Flip.none,
      initialBox: Box.fromLTWH(128.83, 470.95, 500.00, 335.71),
      handle: HandlePosition.bottomLeft,
      initialLocalPosition: Vector2(10.31, 11.36),
      flipRect: true,
      localPosition: Vector2(-53.57, -678.20),
      clampingRect: Box.fromLTWH(66.08, 97.05, 604.30, 743.06),
      constraints: Constraints(
          minWidth: 100.00,
          minHeight: 100.00,
          maxWidth: 500.00,
          maxHeight: 500.00),
    );

    expect(result.flip, Flip.vertical);
    expect(result.rect,
        withTolerance(Box.fromLTWH(128.83, 135.24, 500.00, 335.71)));
    expect(result.resizeMode, ResizeMode.scale);

    result = BoxTransformer.resize(
      resizeMode: ResizeMode.scale,
      initialFlip: Flip.vertical,
      initialBox: Box.fromLTWH(128.83, 135.24, 500.00, 335.71),
      handle: HandlePosition.topLeft,
      initialLocalPosition: Vector2(11.59, 11.74),
      flipRect: true,
      localPosition: Vector2(480.46, 316.31),
      clampingRect: Box.fromLTWH(66.08, 97.05, 604.30, 743.06),
      constraints: Constraints(
          minWidth: 100.00,
          minHeight: 100.00,
          maxWidth: 500.00,
          maxHeight: 500.00),
    );

    expect(result.flip, Flip.vertical);
    expect(result.rect,
        withTolerance(Box.fromLTWH(479.89, 370.95, 148.94, 100.00)));
    expect(result.resizeMode, ResizeMode.scale);

    result = BoxTransformer.resize(
      resizeMode: ResizeMode.scale,
      initialFlip: Flip.vertical,
      initialBox: Box.fromLTWH(479.89, 370.95, 148.94, 100.00),
      handle: HandlePosition.topLeft,
      initialLocalPosition: Vector2(14.56, 10.34),
      flipRect: true,
      localPosition: Vector2(-181.97, 362.52),
      clampingRect: Box.fromLTWH(66.08, 97.05, 604.30, 743.06),
      constraints: Constraints(
          minWidth: 100.00,
          minHeight: 100.00,
          maxWidth: 500.00,
          maxHeight: 500.00),
    );

    expect(result.flip, Flip.none);
    expect(result.rect,
        withTolerance(Box.fromLTWH(253.24, 470.95, 375.58, 252.18)));
    expect(result.resizeMode, ResizeMode.scale);

    result = BoxTransformer.resize(
      resizeMode: ResizeMode.scale,
      initialFlip: Flip.none,
      initialBox: Box.fromLTWH(253.24, 470.95, 375.58, 252.18),
      handle: HandlePosition.bottomLeft,
      initialLocalPosition: Vector2(13.22, 13.18),
      flipRect: true,
      localPosition: Vector2(491.17, -341.30),
      clampingRect: Box.fromLTWH(66.08, 97.05, 604.30, 743.06),
      constraints: Constraints(
          minWidth: 100.00,
          minHeight: 100.00,
          maxWidth: 500.00,
          maxHeight: 500.00),
    );

    expect(result.flip, Flip.diagonal);
    expect(result.rect,
        withTolerance(Box.fromLTWH(479.89, 470.95, 148.94, 100.00)));
    expect(result.resizeMode, ResizeMode.scale);

    result = BoxTransformer.resize(
      resizeMode: ResizeMode.scale,
      initialFlip: Flip.none,
      initialBox: Box.fromLTWH(479.89, 470.95, 148.94, 100.00),
      handle: HandlePosition.bottomLeft,
      initialLocalPosition: Vector2(10.12, 12.51),
      flipRect: true,
      localPosition: Vector2(263.84, -8.81),
      clampingRect: Box.fromLTWH(66.08, 97.05, 604.30, 743.06),
      constraints: Constraints(
          minWidth: 100.00,
          minHeight: 100.00,
          maxWidth: 500.00,
          maxHeight: 500.00),
    );

    expect(result.flip, Flip.horizontal);
    expect(result.rect,
        withTolerance(Box.fromLTWH(479.89, 470.95, 148.94, 100.00)));
    expect(result.resizeMode, ResizeMode.scale);
  });

  test('scaled constrained resizing with top-right handle', () {
    var result = BoxTransformer.resize(
      resizeMode: ResizeMode.scale,
      initialFlip: Flip.none,
      initialBox: Box.fromLTWH(116.17, 373.64, 326.85, 219.45),
      handle: HandlePosition.topRight,
      initialLocalPosition: Vector2(13.82, 10.49),
      flipRect: true,
      localPosition: Vector2(295.10, -189.04),
      clampingRect: Box.fromLTWH(66.08, 97.05, 604.30, 743.06),
      constraints: Constraints(
          minWidth: 100.00,
          minHeight: 100.00,
          maxWidth: 500.00,
          maxHeight: 500.00),
    );

    expect(result.flip, Flip.none);
    expect(result.rect,
        withTolerance(Box.fromLTWH(116.17, 257.38, 500.00, 335.71)));
    expect(result.resizeMode, ResizeMode.scale);

    result = BoxTransformer.resize(
      resizeMode: ResizeMode.scale,
      initialFlip: Flip.none,
      initialBox: Box.fromLTWH(116.17, 257.38, 500.00, 335.71),
      handle: HandlePosition.topRight,
      initialLocalPosition: Vector2(14.91, 12.97),
      flipRect: true,
      localPosition: Vector2(-436.10, 324.26),
      clampingRect: Box.fromLTWH(66.08, 97.05, 604.30, 743.06),
      constraints: Constraints(
          minWidth: 100.00,
          minHeight: 100.00,
          maxWidth: 500.00,
          maxHeight: 500.00),
    );

    expect(result.flip, Flip.none);
    expect(result.rect,
        withTolerance(Box.fromLTWH(116.17, 493.09, 148.94, 100.00)));
    expect(result.resizeMode, ResizeMode.scale);

    result = BoxTransformer.resize(
      resizeMode: ResizeMode.scale,
      initialFlip: Flip.none,
      initialBox: Box.fromLTWH(116.17, 493.09, 148.94, 100.00),
      handle: HandlePosition.topRight,
      initialLocalPosition: Vector2(11.85, 9.77),
      flipRect: true,
      localPosition: Vector2(-71.62, 169.34),
      clampingRect: Box.fromLTWH(66.08, 97.05, 604.30, 743.06),
      constraints: Constraints(
          minWidth: 100.00,
          minHeight: 100.00,
          maxWidth: 500.00,
          maxHeight: 500.00),
    );

    expect(result.flip, Flip.vertical);
    expect(result.rect,
        withTolerance(Box.fromLTWH(116.17, 593.09, 148.94, 100.00)));
    expect(result.resizeMode, ResizeMode.scale);

    result = BoxTransformer.resize(
      resizeMode: ResizeMode.scale,
      initialFlip: Flip.vertical,
      initialBox: Box.fromLTWH(116.17, 593.09, 148.94, 100.00),
      handle: HandlePosition.bottomRight,
      initialLocalPosition: Vector2(14.37, 13.95),
      flipRect: true,
      localPosition: Vector2(169.11, -276.37),
      clampingRect: Box.fromLTWH(66.08, 97.05, 604.30, 743.06),
      constraints: Constraints(
          minWidth: 100.00,
          minHeight: 100.00,
          maxWidth: 500.00,
          maxHeight: 500.00),
    );

    expect(result.flip, Flip.none);
    expect(result.rect,
        withTolerance(Box.fromLTWH(116.17, 389.20, 303.68, 203.90)));
    expect(result.resizeMode, ResizeMode.scale);

    result = BoxTransformer.resize(
      resizeMode: ResizeMode.scale,
      initialFlip: Flip.none,
      initialBox: Box.fromLTWH(116.17, 389.20, 303.68, 203.90),
      handle: HandlePosition.topRight,
      initialLocalPosition: Vector2(16.18, 13.93),
      flipRect: true,
      localPosition: Vector2(-527.82, 80.27),
      clampingRect: Box.fromLTWH(66.08, 97.05, 604.30, 743.06),
      constraints: Constraints(
          minWidth: 100.00,
          minHeight: 100.00,
          maxWidth: 500.00,
          maxHeight: 500.00),
    );

    expect(result.flip, Flip.horizontal);
    expect(result.rect,
        withTolerance(Box.fromLTWH(116.17, 493.09, 148.94, 100.00)));
    expect(result.resizeMode, ResizeMode.scale);

    result = BoxTransformer.resize(
      resizeMode: ResizeMode.scale,
      initialFlip: Flip.horizontal,
      initialBox: Box.fromLTWH(116.17, 493.09, 148.94, 100.00),
      handle: HandlePosition.topRight,
      initialLocalPosition: Vector2(17.43, 10.15),
      flipRect: true,
      localPosition: Vector2(226.05, -112.14),
      clampingRect: Box.fromLTWH(66.08, 97.05, 604.30, 743.06),
      constraints: Constraints(
          minWidth: 100.00,
          minHeight: 100.00,
          maxWidth: 500.00,
          maxHeight: 500.00),
    );

    expect(result.flip, Flip.horizontal);
    expect(result.rect,
        withTolerance(Box.fromLTWH(116.17, 353.02, 357.55, 240.07)));
    expect(result.resizeMode, ResizeMode.scale);

    result = BoxTransformer.resize(
      resizeMode: ResizeMode.scale,
      initialFlip: Flip.none,
      initialBox: Box.fromLTWH(116.17, 353.02, 357.55, 240.07),
      handle: HandlePosition.topRight,
      initialLocalPosition: Vector2(13.31, 12.37),
      flipRect: true,
      localPosition: Vector2(-452.64, 354.42),
      clampingRect: Box.fromLTWH(66.08, 97.05, 604.30, 743.06),
      constraints: Constraints(
          minWidth: 100.00,
          minHeight: 100.00,
          maxWidth: 500.00,
          maxHeight: 500.00),
    );

    expect(result.flip, Flip.diagonal);
    expect(result.rect,
        withTolerance(Box.fromLTWH(116.17, 493.09, 148.94, 100.00)));
    expect(result.resizeMode, ResizeMode.scale);
  });

  test('scaled constrained resizing with left handle', () {
    var result = BoxTransformer.resize(
      resizeMode: ResizeMode.scale,
      initialFlip: Flip.none,
      initialBox: Box.fromLTWH(305.52, 370.71, 315.37, 211.75),
      handle: HandlePosition.left,
      initialLocalPosition: Vector2(11.48, 94.82),
      flipRect: true,
      localPosition: Vector2(284.66, 89.80),
      clampingRect: Box.fromLTWH(66.08, 97.05, 604.30, 743.06),
      constraints: Constraints(
          minWidth: 100.00,
          minHeight: 100.00,
          maxWidth: 500.00,
          maxHeight: 500.00),
    );

    expect(result.flip, Flip.none);
    expect(result.rect,
        withTolerance(Box.fromLTWH(471.96, 426.58, 148.94, 100.00)));
    expect(result.resizeMode, ResizeMode.scale);

    result = BoxTransformer.resize(
      resizeMode: ResizeMode.scale,
      initialFlip: Flip.none,
      initialBox: Box.fromLTWH(471.96, 426.58, 148.94, 100.00),
      handle: HandlePosition.left,
      initialLocalPosition: Vector2(12.57, 40.48),
      flipRect: true,
      localPosition: Vector2(-641.35, -32.32),
      clampingRect: Box.fromLTWH(66.08, 97.05, 604.30, 743.06),
      constraints: Constraints(
          minWidth: 100.00,
          minHeight: 100.00,
          maxWidth: 500.00,
          maxHeight: 500.00),
    );

    expect(result.flip, Flip.none);
    expect(result.rect,
        withTolerance(Box.fromLTWH(120.90, 308.72, 500.00, 335.71)));
    expect(result.resizeMode, ResizeMode.scale);

    result = BoxTransformer.resize(
      resizeMode: ResizeMode.scale,
      initialFlip: Flip.none,
      initialBox: Box.fromLTWH(120.90, 308.72, 500.00, 335.71),
      handle: HandlePosition.left,
      initialLocalPosition: Vector2(9.08, 156.55),
      flipRect: true,
      localPosition: Vector2(234.66, 162.70),
      clampingRect: Box.fromLTWH(66.08, 97.05, 604.30, 743.06),
      constraints: Constraints(
          minWidth: 100.00,
          minHeight: 100.00,
          maxWidth: 500.00,
          maxHeight: 500.00),
    );

    expect(result.flip, Flip.none);
    expect(result.rect,
        withTolerance(Box.fromLTWH(346.47, 384.45, 274.43, 184.26)));
    expect(result.resizeMode, ResizeMode.scale);

    result = BoxTransformer.resize(
      resizeMode: ResizeMode.scale,
      initialFlip: Flip.none,
      initialBox: Box.fromLTWH(346.47, 384.45, 274.43, 184.26),
      handle: HandlePosition.left,
      initialLocalPosition: Vector2(13.51, 84.86),
      flipRect: true,
      localPosition: Vector2(386.15, 69.82),
      clampingRect: Box.fromLTWH(66.08, 97.05, 604.30, 743.06),
      constraints: Constraints(
          minWidth: 100.00,
          minHeight: 100.00,
          maxWidth: 500.00,
          maxHeight: 500.00),
    );

    expect(result.flip, Flip.horizontal);
    expect(result.rect,
        withTolerance(Box.fromLTWH(471.96, 426.58, 148.94, 100.00)));
    expect(result.resizeMode, ResizeMode.scale);
  });

  test('scaled constrained resizing with bottom handle', () {
    var result = BoxTransformer.resize(
      resizeMode: ResizeMode.scale,
      initialFlip: Flip.none,
      initialBox: Box.fromLTWH(209.84, 150.84, 316.52, 212.52),
      handle: HandlePosition.bottom,
      initialLocalPosition: Vector2(146.83, 7.72),
      flipRect: true,
      localPosition: Vector2(148.45, -179.09),
      clampingRect: Box.fromLTWH(66.08, 97.05, 604.30, 743.06),
      constraints: Constraints(
          minWidth: 100.00,
          minHeight: 100.00,
          maxWidth: 500.00,
          maxHeight: 500.00),
    );

    expect(result.flip, Flip.none);
    expect(result.rect,
        withTolerance(Box.fromLTWH(293.63, 150.84, 148.94, 100.00)));
    expect(result.resizeMode, ResizeMode.scale);

    result = BoxTransformer.resize(
      resizeMode: ResizeMode.scale,
      initialFlip: Flip.none,
      initialBox: Box.fromLTWH(293.63, 150.84, 148.94, 100.00),
      handle: HandlePosition.bottom,
      initialLocalPosition: Vector2(62.26, 14.53),
      flipRect: true,
      localPosition: Vector2(70.29, 326.59),
      clampingRect: Box.fromLTWH(66.08, 97.05, 604.30, 743.06),
      constraints: Constraints(
          minWidth: 100.00,
          minHeight: 100.00,
          maxWidth: 500.00,
          maxHeight: 500.00),
    );

    expect(result.flip, Flip.none);
    expect(result.rect,
        withTolerance(Box.fromLTWH(118.10, 150.84, 500.00, 335.71)));
    expect(result.resizeMode, ResizeMode.scale);

    result = BoxTransformer.resize(
      resizeMode: ResizeMode.scale,
      initialFlip: Flip.none,
      initialBox: Box.fromLTWH(118.10, 150.84, 500.00, 335.71),
      handle: HandlePosition.bottom,
      initialLocalPosition: Vector2(234.80, 13.43),
      flipRect: true,
      localPosition: Vector2(219.59, -444.37),
      clampingRect: Box.fromLTWH(66.08, 97.05, 604.30, 743.06),
      constraints: Constraints(
          minWidth: 100.00,
          minHeight: 100.00,
          maxWidth: 500.00,
          maxHeight: 500.00),
    );

    expect(result.flip, Flip.vertical);
    expect(result.rect,
        withTolerance(Box.fromLTWH(293.63, 150.84, 148.94, 100.00)));
    expect(result.resizeMode, ResizeMode.scale);
  });

  test('scaled constrained resizing with top handle', () {
    var result = BoxTransformer.resize(
      resizeMode: ResizeMode.scale,
      initialFlip: Flip.none,
      initialBox: Box.fromLTWH(195.28, 555.58, 347.13, 233.07),
      handle: HandlePosition.top,
      initialLocalPosition: Vector2(160.48, 12.62),
      flipRect: true,
      localPosition: Vector2(158.47, 203.95),
      clampingRect: Box.fromLTWH(66.08, 97.05, 604.30, 743.06),
      constraints: Constraints(
          minWidth: 100.00,
          minHeight: 100.00,
          maxWidth: 500.00,
          maxHeight: 500.00),
    );

    expect(result.flip, Flip.none);
    expect(result.rect,
        withTolerance(Box.fromLTWH(294.38, 688.65, 148.94, 100.00)));
    expect(result.resizeMode, ResizeMode.scale);

    result = BoxTransformer.resize(
      resizeMode: ResizeMode.scale,
      initialFlip: Flip.none,
      initialBox: Box.fromLTWH(294.38, 688.65, 148.94, 100.00),
      handle: HandlePosition.top,
      initialLocalPosition: Vector2(62.14, 11.35),
      flipRect: true,
      localPosition: Vector2(72.18, -479.90),
      clampingRect: Box.fromLTWH(66.08, 97.05, 604.30, 743.06),
      constraints: Constraints(
          minWidth: 100.00,
          minHeight: 100.00,
          maxWidth: 500.00,
          maxHeight: 500.00),
    );

    expect(result.flip, Flip.none);
    expect(result.rect,
        withTolerance(Box.fromLTWH(118.85, 452.94, 500.00, 335.71)));
    expect(result.resizeMode, ResizeMode.scale);

    result = BoxTransformer.resize(
      resizeMode: ResizeMode.scale,
      initialFlip: Flip.none,
      initialBox: Box.fromLTWH(118.85, 452.94, 500.00, 335.71),
      handle: HandlePosition.top,
      initialLocalPosition: Vector2(242.54, 12.41),
      flipRect: true,
      localPosition: Vector2(232.07, 178.43),
      clampingRect: Box.fromLTWH(66.08, 97.05, 604.30, 743.06),
      constraints: Constraints(
          minWidth: 100.00,
          minHeight: 100.00,
          maxWidth: 500.00,
          maxHeight: 500.00),
    );

    expect(result.flip, Flip.none);
    expect(result.rect,
        withTolerance(Box.fromLTWH(242.48, 618.97, 252.72, 169.69)));
    expect(result.resizeMode, ResizeMode.scale);

    result = BoxTransformer.resize(
      resizeMode: ResizeMode.scale,
      initialFlip: Flip.none,
      initialBox: Box.fromLTWH(242.48, 618.97, 252.72, 169.69),
      handle: HandlePosition.top,
      initialLocalPosition: Vector2(115.45, 11.86),
      flipRect: true,
      localPosition: Vector2(90.55, 313.73),
      clampingRect: Box.fromLTWH(66.08, 97.05, 604.30, 743.06),
      constraints: Constraints(
          minWidth: 100.00,
          minHeight: 100.00,
          maxWidth: 500.00,
          maxHeight: 500.00),
    );

    expect(result.flip, Flip.vertical);
    expect(result.rect,
        withTolerance(Box.fromLTWH(294.38, 688.65, 148.94, 100.00)));
    expect(result.resizeMode, ResizeMode.scale);
  });

  test('scaled constrained resizing with right handle', () {
    var result = BoxTransformer.resize(
      resizeMode: ResizeMode.scale,
      initialFlip: Flip.none,
      initialBox: Box.fromLTWH(116.59, 353.15, 333.94, 224.22),
      handle: HandlePosition.right,
      initialLocalPosition: Vector2(12.40, 97.75),
      flipRect: true,
      localPosition: Vector2(-255.67, 98.12),
      clampingRect: Box.fromLTWH(66.08, 97.05, 604.30, 743.06),
      constraints: Constraints(
          minWidth: 100.00,
          minHeight: 100.00,
          maxWidth: 500.00,
          maxHeight: 500.00),
    );

    expect(result.flip, Flip.none);
    expect(result.rect,
        withTolerance(Box.fromLTWH(116.59, 415.26, 148.94, 100.00)));
    expect(result.resizeMode, ResizeMode.scale);

    result = BoxTransformer.resize(
      resizeMode: ResizeMode.scale,
      initialFlip: Flip.none,
      initialBox: Box.fromLTWH(116.59, 415.26, 148.94, 100.00),
      handle: HandlePosition.right,
      initialLocalPosition: Vector2(13.86, 42.33),
      flipRect: true,
      localPosition: Vector2(466.11, 10.45),
      clampingRect: Box.fromLTWH(66.08, 97.05, 604.30, 743.06),
      constraints: Constraints(
          minWidth: 100.00,
          minHeight: 100.00,
          maxWidth: 500.00,
          maxHeight: 500.00),
    );

    expect(result.flip, Flip.none);
    expect(result.rect,
        withTolerance(Box.fromLTWH(116.59, 297.40, 500.00, 335.71)));
    expect(result.resizeMode, ResizeMode.scale);

    result = BoxTransformer.resize(
      resizeMode: ResizeMode.scale,
      initialFlip: Flip.none,
      initialBox: Box.fromLTWH(116.59, 297.40, 500.00, 335.71),
      handle: HandlePosition.right,
      initialLocalPosition: Vector2(9.77, 154.19),
      flipRect: true,
      localPosition: Vector2(-214.69, 168.03),
      clampingRect: Box.fromLTWH(66.08, 97.05, 604.30, 743.06),
      constraints: Constraints(
          minWidth: 100.00,
          minHeight: 100.00,
          maxWidth: 500.00,
          maxHeight: 500.00),
    );

    expect(result.flip, Flip.none);
    expect(result.rect,
        withTolerance(Box.fromLTWH(116.59, 372.76, 275.54, 185.00)));
    expect(result.resizeMode, ResizeMode.scale);

    result = BoxTransformer.resize(
      resizeMode: ResizeMode.scale,
      initialFlip: Flip.none,
      initialBox: Box.fromLTWH(116.59, 372.76, 275.54, 185.00),
      handle: HandlePosition.right,
      initialLocalPosition: Vector2(10.52, 86.69),
      flipRect: true,
      localPosition: Vector2(-440.50, 78.59),
      clampingRect: Box.fromLTWH(66.08, 97.05, 604.30, 743.06),
      constraints: Constraints(
          minWidth: 100.00,
          minHeight: 100.00,
          maxWidth: 500.00,
          maxHeight: 500.00),
    );

    expect(result.flip, Flip.horizontal);
    expect(result.rect,
        withTolerance(Box.fromLTWH(116.59, 415.26, 148.94, 100.00)));
    expect(result.resizeMode, ResizeMode.scale);
  });
}
