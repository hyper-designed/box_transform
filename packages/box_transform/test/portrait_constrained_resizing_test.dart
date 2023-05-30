import 'package:test/test.dart';
import 'package:vector_math/vector_math.dart';
import 'package:box_transform/box_transform.dart';
import 'utils.dart';

void main() {
  test('portrait scaled constrained resizing', () {
    var result = BoxTransformer.resize(
      resizeMode: ResizeMode.scale,
      initialFlip: Flip.horizontal,
      initialBox: Box.fromLTWH(252.31, 264.00, 248.79, 348.22),
      handle: HandlePosition.bottomRight,
      initialLocalPosition: Vector2(14.90, 10.29),
      allowFlipping: true,
      localPosition: Vector2(226.07, 203.89),
      clampingRect: Box.fromLTWH(88.62, 79.06, 592.66, 782.53),
      constraints: Constraints(
          minWidth: 100.00,
          minHeight: 100.00,
          maxWidth: 500.00,
          maxHeight: 500.00),
    );

    expect(result.flip, Flip.horizontal);
    expect(result.rect,
        withTolerance(Box.fromLTWH(252.31, 264.00, 357.24, 500.00)));
    expect(result.resizeMode, ResizeMode.scale);

    result = BoxTransformer.resize(
      resizeMode: ResizeMode.scale,
      initialFlip: Flip.horizontal,
      initialBox: Box.fromLTWH(252.31, 264.00, 357.24, 500.00),
      handle: HandlePosition.bottomRight,
      initialLocalPosition: Vector2(10.27, 14.68),
      allowFlipping: true,
      localPosition: Vector2(-278.97, -416.28),
      clampingRect: Box.fromLTWH(88.62, 79.06, 592.66, 782.53),
      constraints: Constraints(
          minWidth: 100.00,
          minHeight: 100.00,
          maxWidth: 500.00,
          maxHeight: 500.00),
    );

    expect(result.flip, Flip.horizontal);
    expect(result.rect,
        withTolerance(Box.fromLTWH(252.31, 264.00, 100.00, 139.96)));
    expect(result.resizeMode, ResizeMode.scale);

    result = BoxTransformer.resize(
      resizeMode: ResizeMode.scale,
      initialFlip: Flip.horizontal,
      initialBox: Box.fromLTWH(252.31, 264.00, 100.00, 139.96),
      handle: HandlePosition.right,
      initialLocalPosition: Vector2(14.59, 58.80),
      allowFlipping: true,
      localPosition: Vector2(216.63, 35.21),
      clampingRect: Box.fromLTWH(88.62, 79.06, 592.66, 782.53),
      constraints: Constraints(
          minWidth: 100.00,
          minHeight: 100.00,
          maxWidth: 500.00,
          maxHeight: 500.00),
    );

    expect(result.flip, Flip.horizontal);
    expect(result.rect,
        withTolerance(Box.fromLTWH(252.31, 122.62, 302.03, 422.73)));
    expect(result.resizeMode, ResizeMode.scale);

    result = BoxTransformer.resize(
      resizeMode: ResizeMode.scale,
      initialFlip: Flip.horizontal,
      initialBox: Box.fromLTWH(131.77, 245.67, 302.03, 422.73),
      handle: HandlePosition.bottomRight,
      initialLocalPosition: Vector2(10.60, 13.42),
      allowFlipping: true,
      localPosition: Vector2(-406.10, -550.22),
      clampingRect: Box.fromLTWH(88.62, 79.06, 592.66, 782.53),
      constraints: Constraints(
          minWidth: 100.00,
          minHeight: 100.00,
          maxWidth: 500.00,
          maxHeight: 500.00),
    );

    expect(result.flip, Flip.vertical);
    expect(result.rect,
        withTolerance(Box.fromLTWH(131.77, 245.67, 100.00, 139.96)));
    expect(result.resizeMode, ResizeMode.scale);

    result = BoxTransformer.resize(
      resizeMode: ResizeMode.scale,
      initialFlip: Flip.vertical,
      initialBox: Box.fromLTWH(131.77, 245.67, 100.00, 139.96),
      handle: HandlePosition.topLeft,
      initialLocalPosition: Vector2(11.25, 9.62),
      allowFlipping: true,
      localPosition: Vector2(189.89, 253.41),
      clampingRect: Box.fromLTWH(88.62, 79.06, 592.66, 782.53),
      constraints: Constraints(
          minWidth: 100.00,
          minHeight: 100.00,
          maxWidth: 500.00,
          maxHeight: 500.00),
    );

    expect(result.flip, Flip.horizontal);
    expect(result.rect,
        withTolerance(Box.fromLTWH(231.77, 385.63, 100.00, 139.96)));
    expect(result.resizeMode, ResizeMode.scale);

    result = BoxTransformer.resize(
      resizeMode: ResizeMode.scale,
      initialFlip: Flip.horizontal,
      initialBox: Box.fromLTWH(231.77, 385.63, 100.00, 139.96),
      handle: HandlePosition.right,
      initialLocalPosition: Vector2(14.57, 61.28),
      allowFlipping: true,
      localPosition: Vector2(316.86, 44.29),
      clampingRect: Box.fromLTWH(88.62, 79.06, 592.66, 782.53),
      constraints: Constraints(
          minWidth: 100.00,
          minHeight: 100.00,
          maxWidth: 500.00,
          maxHeight: 500.00),
    );

    expect(result.flip, Flip.horizontal);
    expect(result.rect,
        withTolerance(Box.fromLTWH(231.77, 205.61, 357.24, 500.00)));
    expect(result.resizeMode, ResizeMode.scale);

    result = BoxTransformer.resize(
      resizeMode: ResizeMode.scale,
      initialFlip: Flip.horizontal,
      initialBox: Box.fromLTWH(231.77, 205.61, 357.24, 500.00),
      handle: HandlePosition.left,
      initialLocalPosition: Vector2(13.48, 240.97),
      allowFlipping: true,
      localPosition: Vector2(313.37, 213.64),
      clampingRect: Box.fromLTWH(88.62, 79.06, 592.66, 782.53),
      constraints: Constraints(
          minWidth: 100.00,
          minHeight: 100.00,
          maxWidth: 500.00,
          maxHeight: 500.00),
    );

    expect(result.flip, Flip.horizontal);
    expect(result.rect,
        withTolerance(Box.fromLTWH(489.00, 385.63, 100.00, 139.96)));
    expect(result.resizeMode, ResizeMode.scale);

    result = BoxTransformer.resize(
      resizeMode: ResizeMode.scale,
      initialFlip: Flip.horizontal,
      initialBox: Box.fromLTWH(489.00, 385.63, 100.00, 139.96),
      handle: HandlePosition.top,
      initialLocalPosition: Vector2(37.51, 13.11),
      allowFlipping: true,
      localPosition: Vector2(43.67, 255.24),
      clampingRect: Box.fromLTWH(88.62, 79.06, 592.66, 782.53),
      constraints: Constraints(
          minWidth: 100.00,
          minHeight: 100.00,
          maxWidth: 500.00,
          maxHeight: 500.00),
    );

    expect(result.flip, Flip.diagonal);
    expect(result.rect,
        withTolerance(Box.fromLTWH(489.00, 525.59, 100.00, 139.96)));
    expect(result.resizeMode, ResizeMode.scale);

    result = BoxTransformer.resize(
      resizeMode: ResizeMode.scale,
      initialFlip: Flip.none,
      initialBox: Box.fromLTWH(489.00, 525.59, 100.00, 139.96),
      handle: HandlePosition.topLeft,
      initialLocalPosition: Vector2(13.60, 12.69),
      allowFlipping: true,
      localPosition: Vector2(-315.97, -374.79),
      clampingRect: Box.fromLTWH(88.62, 79.06, 592.66, 782.53),
      constraints: Constraints(
          minWidth: 100.00,
          minHeight: 100.00,
          maxWidth: 500.00,
          maxHeight: 500.00),
    );

    expect(result.flip, Flip.none);
    expect(result.rect,
        withTolerance(Box.fromLTWH(231.77, 165.56, 357.24, 500.00)));
    expect(result.resizeMode, ResizeMode.scale);

    result = BoxTransformer.resize(
      resizeMode: ResizeMode.scale,
      initialFlip: Flip.none,
      initialBox: Box.fromLTWH(231.77, 165.56, 357.24, 500.00),
      handle: HandlePosition.bottom,
      initialLocalPosition: Vector2(168.22, 19.08),
      allowFlipping: true,
      localPosition: Vector2(154.56, -423.01),
      clampingRect: Box.fromLTWH(88.62, 79.06, 592.66, 782.53),
      constraints: Constraints(
          minWidth: 100.00,
          minHeight: 100.00,
          maxWidth: 500.00,
          maxHeight: 500.00),
    );

    expect(result.flip, Flip.none);
    expect(result.rect,
        withTolerance(Box.fromLTWH(360.38, 165.56, 100.00, 139.96)));
    expect(result.resizeMode, ResizeMode.scale);
  });

  test('symmetrically scaled constrained resizing', () {
    var result = BoxTransformer.resize(
      resizeMode: ResizeMode.symmetricScale,
      initialFlip: Flip.none,
      initialBox: Box.fromLTWH(332.12, 367.06, 100.00, 139.96),
      handle: HandlePosition.bottomRight,
      initialLocalPosition: Vector2(11.58, 14.41),
      allowFlipping: true,
      localPosition: Vector2(210.83, 215.38),
      clampingRect: Box.fromLTWH(88.62, 79.06, 592.66, 782.53),
      constraints: Constraints(
          minWidth: 100.00,
          minHeight: 100.00,
          maxWidth: 500.00,
          maxHeight: 500.00),
    );

    expect(result.flip, Flip.none);
    expect(result.rect,
        withTolerance(Box.fromLTWH(203.50, 187.04, 357.24, 500.00)));
    expect(result.resizeMode, ResizeMode.symmetricScale);

    result = BoxTransformer.resize(
      resizeMode: ResizeMode.symmetricScale,
      initialFlip: Flip.none,
      initialBox: Box.fromLTWH(203.50, 187.04, 357.24, 500.00),
      handle: HandlePosition.bottomRight,
      initialLocalPosition: Vector2(11.36, 16.39),
      allowFlipping: true,
      localPosition: Vector2(-150.82, -197.25),
      clampingRect: Box.fromLTWH(88.62, 79.06, 592.66, 782.53),
      constraints: Constraints(
          minWidth: 100.00,
          minHeight: 100.00,
          maxWidth: 500.00,
          maxHeight: 500.00),
    );

    expect(result.flip, Flip.none);
    expect(result.rect,
        withTolerance(Box.fromLTWH(332.12, 367.06, 100.00, 139.96)));
    expect(result.resizeMode, ResizeMode.symmetricScale);

    result = BoxTransformer.resize(
      resizeMode: ResizeMode.symmetricScale,
      initialFlip: Flip.none,
      initialBox: Box.fromLTWH(332.12, 367.06, 100.00, 139.96),
      handle: HandlePosition.left,
      initialLocalPosition: Vector2(15.47, 62.06),
      allowFlipping: true,
      localPosition: Vector2(-190.75, 53.96),
      clampingRect: Box.fromLTWH(88.62, 79.06, 592.66, 782.53),
      constraints: Constraints(
          minWidth: 100.00,
          minHeight: 100.00,
          maxWidth: 500.00,
          maxHeight: 500.00),
    );

    expect(result.flip, Flip.none);
    expect(result.rect,
        withTolerance(Box.fromLTWH(203.50, 187.04, 357.24, 500.00)));
    expect(result.resizeMode, ResizeMode.symmetricScale);

    result = BoxTransformer.resize(
      resizeMode: ResizeMode.symmetricScale,
      initialFlip: Flip.none,
      initialBox: Box.fromLTWH(203.50, 187.04, 357.24, 500.00),
      handle: HandlePosition.left,
      initialLocalPosition: Vector2(11.43, 239.57),
      allowFlipping: true,
      localPosition: Vector2(444.97, 228.83),
      clampingRect: Box.fromLTWH(88.62, 79.06, 592.66, 782.53),
      constraints: Constraints(
          minWidth: 100.00,
          minHeight: 100.00,
          maxWidth: 500.00,
          maxHeight: 500.00),
    );

    expect(result.flip, Flip.horizontal);
    expect(result.rect,
        withTolerance(Box.fromLTWH(203.50, 187.04, 357.24, 500.00)));
    expect(result.resizeMode, ResizeMode.symmetricScale);

    result = BoxTransformer.resize(
      resizeMode: ResizeMode.symmetricScale,
      initialFlip: Flip.horizontal,
      initialBox: Box.fromLTWH(203.50, 187.04, 357.24, 500.00),
      handle: HandlePosition.top,
      initialLocalPosition: Vector2(157.06, 10.96),
      allowFlipping: true,
      localPosition: Vector2(159.41, 243.70),
      clampingRect: Box.fromLTWH(88.62, 79.06, 592.66, 782.53),
      constraints: Constraints(
          minWidth: 100.00,
          minHeight: 100.00,
          maxWidth: 500.00,
          maxHeight: 500.00),
    );

    expect(result.flip, Flip.horizontal);
    expect(result.rect,
        withTolerance(Box.fromLTWH(332.12, 367.06, 100.00, 139.96)));
    expect(result.resizeMode, ResizeMode.symmetricScale);

    result = BoxTransformer.resize(
      resizeMode: ResizeMode.symmetricScale,
      initialFlip: Flip.horizontal,
      initialBox: Box.fromLTWH(332.12, 367.06, 100.00, 139.96),
      handle: HandlePosition.bottom,
      initialLocalPosition: Vector2(38.89, 15.35),
      allowFlipping: true,
      localPosition: Vector2(40.69, 334.25),
      clampingRect: Box.fromLTWH(88.62, 79.06, 592.66, 782.53),
      constraints: Constraints(
          minWidth: 100.00,
          minHeight: 100.00,
          maxWidth: 500.00,
          maxHeight: 500.00),
    );

    expect(result.flip, Flip.horizontal);
    expect(result.rect,
        withTolerance(Box.fromLTWH(203.50, 187.04, 357.24, 500.00)));
    expect(result.resizeMode, ResizeMode.symmetricScale);

    result = BoxTransformer.resize(
      resizeMode: ResizeMode.symmetricScale,
      initialFlip: Flip.horizontal,
      initialBox: Box.fromLTWH(203.50, 187.04, 357.24, 500.00),
      handle: HandlePosition.topRight,
      initialLocalPosition: Vector2(16.12, 11.40),
      allowFlipping: true,
      localPosition: Vector2(-198.65, 304.19),
      clampingRect: Box.fromLTWH(88.62, 79.06, 592.66, 782.53),
      constraints: Constraints(
          minWidth: 100.00,
          minHeight: 100.00,
          maxWidth: 500.00,
          maxHeight: 500.00),
    );

    expect(result.flip, Flip.vertical);
    expect(result.rect,
        withTolerance(Box.fromLTWH(332.12, 367.06, 100.00, 139.96)));
    expect(result.resizeMode, ResizeMode.symmetricScale);

    result = BoxTransformer.resize(
      resizeMode: ResizeMode.symmetricScale,
      initialFlip: Flip.vertical,
      initialBox: Box.fromLTWH(332.12, 367.06, 100.00, 139.96),
      handle: HandlePosition.bottomLeft,
      initialLocalPosition: Vector2(15.79, 14.07),
      allowFlipping: true,
      localPosition: Vector2(254.63, -329.32),
      clampingRect: Box.fromLTWH(88.62, 79.06, 592.66, 782.53),
      constraints: Constraints(
          minWidth: 100.00,
          minHeight: 100.00,
          maxWidth: 500.00,
          maxHeight: 500.00),
    );

    expect(result.flip, Flip.horizontal);
    expect(result.rect,
        withTolerance(Box.fromLTWH(203.50, 187.04, 357.24, 500.00)));
    expect(result.resizeMode, ResizeMode.symmetricScale);
  });

  test('symmetric constrained resizing for portrait box', () {
    var result = BoxTransformer.resize(
      resizeMode: ResizeMode.symmetric,
      initialFlip: Flip.horizontal,
      initialBox: Box.fromLTWH(203.50, 187.04, 357.24, 500.00),
      handle: HandlePosition.bottom,
      initialLocalPosition: Vector2(163.41, 13.97),
      allowFlipping: true,
      localPosition: Vector2(175.30, -230.26),
      clampingRect: Box.fromLTWH(88.62, 79.06, 592.66, 782.53),
      constraints: Constraints(
          minWidth: 100.00,
          minHeight: 100.00,
          maxWidth: 500.00,
          maxHeight: 500.00),
    );

    expect(result.flip, Flip.horizontal);
    expect(result.rect,
        withTolerance(Box.fromLTWH(203.50, 387.04, 357.24, 100.00)));
    expect(result.resizeMode, ResizeMode.symmetric);

    result = BoxTransformer.resize(
      resizeMode: ResizeMode.symmetric,
      initialFlip: Flip.horizontal,
      initialBox: Box.fromLTWH(203.50, 387.04, 357.24, 100.00),
      handle: HandlePosition.right,
      initialLocalPosition: Vector2(16.79, 40.30),
      allowFlipping: true,
      localPosition: Vector2(-193.78, 38.26),
      clampingRect: Box.fromLTWH(88.62, 79.06, 592.66, 782.53),
      constraints: Constraints(
          minWidth: 100.00,
          minHeight: 100.00,
          maxWidth: 500.00,
          maxHeight: 500.00),
    );

    expect(result.flip, Flip.none);
    expect(result.rect,
        withTolerance(Box.fromLTWH(332.12, 387.04, 100.00, 100.00)));
    expect(result.resizeMode, ResizeMode.symmetric);

    result = BoxTransformer.resize(
      resizeMode: ResizeMode.symmetric,
      initialFlip: Flip.none,
      initialBox: Box.fromLTWH(332.12, 387.04, 100.00, 100.00),
      handle: HandlePosition.bottomRight,
      initialLocalPosition: Vector2(10.77, 13.87),
      allowFlipping: true,
      localPosition: Vector2(290.38, 276.00),
      clampingRect: Box.fromLTWH(88.62, 79.06, 592.66, 782.53),
      constraints: Constraints(
          minWidth: 100.00,
          minHeight: 100.00,
          maxWidth: 500.00,
          maxHeight: 500.00),
    );

    expect(result.flip, Flip.none);
    expect(result.rect,
        withTolerance(Box.fromLTWH(132.12, 187.04, 500.00, 500.00)));
    expect(result.resizeMode, ResizeMode.symmetric);

    result = BoxTransformer.resize(
      resizeMode: ResizeMode.symmetric,
      initialFlip: Flip.none,
      initialBox: Box.fromLTWH(132.12, 187.04, 500.00, 500.00),
      handle: HandlePosition.topLeft,
      initialLocalPosition: Vector2(12.12, 11.31),
      allowFlipping: true,
      localPosition: Vector2(-12.34, 247.62),
      clampingRect: Box.fromLTWH(88.62, 79.06, 592.66, 782.53),
      constraints: Constraints(
          minWidth: 100.00,
          minHeight: 100.00,
          maxWidth: 500.00,
          maxHeight: 500.00),
    );

    expect(result.flip, Flip.none);
    expect(result.rect,
        withTolerance(Box.fromLTWH(132.12, 387.04, 500.00, 100.00)));
    expect(result.resizeMode, ResizeMode.symmetric);

    result = BoxTransformer.resize(
      resizeMode: ResizeMode.symmetric,
      initialFlip: Flip.none,
      initialBox: Box.fromLTWH(132.12, 387.04, 500.00, 100.00),
      handle: HandlePosition.topRight,
      initialLocalPosition: Vector2(15.11, 10.84),
      allowFlipping: true,
      localPosition: Vector2(-231.38, 38.59),
      clampingRect: Box.fromLTWH(88.62, 79.06, 592.66, 782.53),
      constraints: Constraints(
          minWidth: 100.00,
          minHeight: 100.00,
          maxWidth: 500.00,
          maxHeight: 500.00),
    );

    expect(result.flip, Flip.none);
    expect(result.rect,
        withTolerance(Box.fromLTWH(332.12, 387.04, 100.00, 100.00)));
    expect(result.resizeMode, ResizeMode.symmetric);

    result = BoxTransformer.resize(
      resizeMode: ResizeMode.symmetric,
      initialFlip: Flip.none,
      initialBox: Box.fromLTWH(332.12, 387.04, 100.00, 100.00),
      handle: HandlePosition.bottomLeft,
      initialLocalPosition: Vector2(15.57, 14.55),
      allowFlipping: true,
      localPosition: Vector2(-196.97, 92.21),
      clampingRect: Box.fromLTWH(88.62, 79.06, 592.66, 782.53),
      constraints: Constraints(
          minWidth: 100.00,
          minHeight: 100.00,
          maxWidth: 500.00,
          maxHeight: 500.00),
    );

    expect(result.flip, Flip.none);
    expect(result.rect,
        withTolerance(Box.fromLTWH(132.12, 309.39, 500.00, 255.31)));
    expect(result.resizeMode, ResizeMode.symmetric);

    result = BoxTransformer.resize(
      resizeMode: ResizeMode.symmetric,
      initialFlip: Flip.none,
      initialBox: Box.fromLTWH(132.12, 309.39, 500.00, 255.31),
      handle: HandlePosition.bottom,
      initialLocalPosition: Vector2(233.06, 16.95),
      allowFlipping: true,
      localPosition: Vector2(224.21, 192.03),
      clampingRect: Box.fromLTWH(88.62, 79.06, 592.66, 782.53),
      constraints: Constraints(
          minWidth: 100.00,
          minHeight: 100.00,
          maxWidth: 500.00,
          maxHeight: 500.00),
    );

    expect(result.flip, Flip.none);
    expect(result.rect,
        withTolerance(Box.fromLTWH(132.12, 187.04, 500.00, 500.00)));
    expect(result.resizeMode, ResizeMode.symmetric);

    result = BoxTransformer.resize(
      resizeMode: ResizeMode.symmetric,
      initialFlip: Flip.none,
      initialBox: Box.fromLTWH(132.12, 187.04, 500.00, 500.00),
      handle: HandlePosition.top,
      initialLocalPosition: Vector2(239.59, 14.63),
      allowFlipping: true,
      localPosition: Vector2(237.49, 249.47),
      clampingRect: Box.fromLTWH(88.62, 79.06, 592.66, 782.53),
      constraints: Constraints(
          minWidth: 100.00,
          minHeight: 100.00,
          maxWidth: 500.00,
          maxHeight: 500.00),
    );

    expect(result.flip, Flip.none);
    expect(result.rect,
        withTolerance(Box.fromLTWH(132.12, 387.04, 500.00, 100.00)));
    expect(result.resizeMode, ResizeMode.symmetric);

    result = BoxTransformer.resize(
      resizeMode: ResizeMode.symmetric,
      initialFlip: Flip.none,
      initialBox: Box.fromLTWH(132.12, 387.04, 500.00, 100.00),
      handle: HandlePosition.left,
      initialLocalPosition: Vector2(17.41, 42.14),
      allowFlipping: true,
      localPosition: Vector2(233.57, 38.73),
      clampingRect: Box.fromLTWH(88.62, 79.06, 592.66, 782.53),
      constraints: Constraints(
          minWidth: 100.00,
          minHeight: 100.00,
          maxWidth: 500.00,
          maxHeight: 500.00),
    );

    expect(result.flip, Flip.none);
    expect(result.rect,
        withTolerance(Box.fromLTWH(332.12, 387.04, 100.00, 100.00)));
    expect(result.resizeMode, ResizeMode.symmetric);
  });

  test('portrait freeform constrained resizing', () {
    var result = BoxTransformer.resize(
      resizeMode: ResizeMode.freeform,
      initialFlip: Flip.none,
      initialBox: Box.fromLTWH(259.18, 328.85, 255.63, 212.97),
      handle: HandlePosition.bottomRight,
      initialLocalPosition: Vector2(12.80, 12.44),
      allowFlipping: true,
      localPosition: Vector2(34.38, -161.81),
      clampingRect: Box.fromLTWH(88.62, 79.06, 592.66, 782.53),
      constraints: Constraints(
          minWidth: 100.00,
          minHeight: 100.00,
          maxWidth: 500.00,
          maxHeight: 500.00),
    );

    expect(result.flip, Flip.none);
    expect(result.rect,
        withTolerance(Box.fromLTWH(259.18, 328.85, 277.20, 100.00)));
    expect(result.resizeMode, ResizeMode.freeform);

    result = BoxTransformer.resize(
      resizeMode: ResizeMode.freeform,
      initialFlip: Flip.none,
      initialBox: Box.fromLTWH(259.18, 328.85, 277.20, 100.00),
      handle: HandlePosition.topLeft,
      initialLocalPosition: Vector2(12.24, 8.96),
      allowFlipping: true,
      localPosition: Vector2(221.62, 90.96),
      clampingRect: Box.fromLTWH(88.62, 79.06, 592.66, 782.53),
      constraints: Constraints(
          minWidth: 100.00,
          minHeight: 100.00,
          maxWidth: 500.00,
          maxHeight: 500.00),
    );

    expect(result.flip, Flip.none);
    expect(result.rect,
        withTolerance(Box.fromLTWH(436.38, 328.85, 100.00, 100.00)));
    expect(result.resizeMode, ResizeMode.freeform);

    result = BoxTransformer.resize(
      resizeMode: ResizeMode.freeform,
      initialFlip: Flip.none,
      initialBox: Box.fromLTWH(223.01, 365.97, 100.00, 100.00),
      handle: HandlePosition.bottomRight,
      initialLocalPosition: Vector2(11.70, 9.93),
      allowFlipping: true,
      localPosition: Vector2(230.53, 141.65),
      clampingRect: Box.fromLTWH(88.62, 79.06, 592.66, 782.53),
      constraints: Constraints(
          minWidth: 100.00,
          minHeight: 100.00,
          maxWidth: 500.00,
          maxHeight: 500.00),
    );

    expect(result.flip, Flip.none);
    expect(result.rect,
        withTolerance(Box.fromLTWH(223.01, 365.97, 318.82, 231.72)));
    expect(result.resizeMode, ResizeMode.freeform);

    result = BoxTransformer.resize(
      resizeMode: ResizeMode.freeform,
      initialFlip: Flip.none,
      initialBox: Box.fromLTWH(152.04, 243.39, 318.82, 231.72),
      handle: HandlePosition.bottomRight,
      initialLocalPosition: Vector2(13.53, 10.83),
      allowFlipping: true,
      localPosition: Vector2(57.76, 352.53),
      clampingRect: Box.fromLTWH(88.62, 79.06, 592.66, 782.53),
      constraints: Constraints(
          minWidth: 100.00,
          minHeight: 100.00,
          maxWidth: 500.00,
          maxHeight: 500.00),
    );

    expect(result.flip, Flip.none);
    expect(result.rect,
        withTolerance(Box.fromLTWH(152.04, 243.39, 363.06, 500.00)));
    expect(result.resizeMode, ResizeMode.freeform);

    result = BoxTransformer.resize(
      resizeMode: ResizeMode.freeform,
      initialFlip: Flip.none,
      initialBox: Box.fromLTWH(152.04, 243.39, 363.06, 500.00),
      handle: HandlePosition.right,
      initialLocalPosition: Vector2(13.15, 245.50),
      allowFlipping: true,
      localPosition: Vector2(230.83, 232.60),
      clampingRect: Box.fromLTWH(88.62, 79.06, 592.66, 782.53),
      constraints: Constraints(
          minWidth: 100.00,
          minHeight: 100.00,
          maxWidth: 500.00,
          maxHeight: 500.00),
    );

    expect(result.flip, Flip.none);
    expect(result.rect,
        withTolerance(Box.fromLTWH(152.04, 243.39, 500.00, 500.00)));
    expect(result.resizeMode, ResizeMode.freeform);

    result = BoxTransformer.resize(
      resizeMode: ResizeMode.freeform,
      initialFlip: Flip.none,
      initialBox: Box.fromLTWH(152.04, 243.39, 500.00, 500.00),
      handle: HandlePosition.topRight,
      initialLocalPosition: Vector2(18.15, 9.38),
      allowFlipping: true,
      localPosition: Vector2(-48.91, 478.78),
      clampingRect: Box.fromLTWH(88.62, 79.06, 592.66, 782.53),
      constraints: Constraints(
          minWidth: 100.00,
          minHeight: 100.00,
          maxWidth: 500.00,
          maxHeight: 500.00),
    );

    expect(result.flip, Flip.none);
    expect(result.rect,
        withTolerance(Box.fromLTWH(152.04, 643.39, 432.94, 100.00)));
    expect(result.resizeMode, ResizeMode.freeform);

    result = BoxTransformer.resize(
      resizeMode: ResizeMode.freeform,
      initialFlip: Flip.none,
      initialBox: Box.fromLTWH(152.04, 643.39, 432.94, 100.00),
      handle: HandlePosition.left,
      initialLocalPosition: Vector2(16.13, 38.72),
      allowFlipping: true,
      localPosition: Vector2(392.22, 22.53),
      clampingRect: Box.fromLTWH(88.62, 79.06, 592.66, 782.53),
      constraints: Constraints(
          minWidth: 100.00,
          minHeight: 100.00,
          maxWidth: 500.00,
          maxHeight: 500.00),
    );

    expect(result.flip, Flip.none);
    expect(result.rect,
        withTolerance(Box.fromLTWH(484.97, 643.39, 100.00, 100.00)));
    expect(result.resizeMode, ResizeMode.freeform);

    result = BoxTransformer.resize(
      resizeMode: ResizeMode.freeform,
      initialFlip: Flip.none,
      initialBox: Box.fromLTWH(484.97, 643.39, 100.00, 100.00),
      handle: HandlePosition.top,
      initialLocalPosition: Vector2(34.52, 13.45),
      allowFlipping: true,
      localPosition: Vector2(16.67, -487.51),
      clampingRect: Box.fromLTWH(88.62, 79.06, 592.66, 782.53),
      constraints: Constraints(
          minWidth: 100.00,
          minHeight: 100.00,
          maxWidth: 500.00,
          maxHeight: 500.00),
    );

    expect(result.flip, Flip.none);
    expect(result.rect,
        withTolerance(Box.fromLTWH(484.97, 243.39, 100.00, 500.00)));
    expect(result.resizeMode, ResizeMode.freeform);

    result = BoxTransformer.resize(
      resizeMode: ResizeMode.freeform,
      initialFlip: Flip.none,
      initialBox: Box.fromLTWH(484.97, 243.39, 100.00, 500.00),
      handle: HandlePosition.bottom,
      initialLocalPosition: Vector2(45.93, 15.54),
      allowFlipping: true,
      localPosition: Vector2(28.90, -420.20),
      clampingRect: Box.fromLTWH(88.62, 79.06, 592.66, 782.53),
      constraints: Constraints(
          minWidth: 100.00,
          minHeight: 100.00,
          maxWidth: 500.00,
          maxHeight: 500.00),
    );

    expect(result.flip, Flip.none);
    expect(result.rect,
        withTolerance(Box.fromLTWH(484.97, 243.39, 100.00, 100.00)));
    expect(result.resizeMode, ResizeMode.freeform);
  });
}
