import 'package:test/test.dart';
import 'package:vector_math/vector_math.dart';
import 'package:box_transform/box_transform.dart';
import 'utils.dart';

void main() {
  test('No flip tests for constrained freeform resizing', () {
    var result = BoxTransformer.resize(
      resizeMode: ResizeMode.scale,
      initialFlip: Flip.none,
      initialBox: Box.fromLTWH(450.95, 371.58, 328.86, 252.52),
      handle: HandlePosition.bottomRight,
      initialLocalPosition: Vector2(16.10, 12.83),
      flipRect: false,
      localPosition: Vector2(-396.77, -298.25),
      constraints: Constraints(
          minWidth: 100.00,
          minHeight: 100.00,
          maxWidth: 500.00,
          maxHeight: 500.00),
    );

    expect(result.flip, Flip.none);
    expect(result.rect,
        withTolerance(Box.fromLTWH(450.95, 371.58, 130.23, 100.00)));
    expect(result.resizeMode, ResizeMode.scale);

    result = BoxTransformer.resize(
      resizeMode: ResizeMode.scale,
      initialFlip: Flip.none,
      initialBox: Box.fromLTWH(450.95, 371.58, 130.23, 100.00),
      handle: HandlePosition.topLeft,
      initialLocalPosition: Vector2(10.69, 10.06),
      flipRect: false,
      localPosition: Vector2(-154.92, -94.88),
      constraints: Constraints(
          minWidth: 100.00,
          minHeight: 100.00,
          maxWidth: 500.00,
          maxHeight: 500.00),
    );

    expect(result.flip, Flip.none);
    expect(result.rect,
        withTolerance(Box.fromLTWH(285.35, 244.41, 295.84, 227.17)));
    expect(result.resizeMode, ResizeMode.scale);

    result = BoxTransformer.resize(
      resizeMode: ResizeMode.scale,
      initialFlip: Flip.none,
      initialBox: Box.fromLTWH(285.35, 244.41, 295.84, 227.17),
      handle: HandlePosition.topLeft,
      initialLocalPosition: Vector2(10.57, 13.09),
      flipRect: false,
      localPosition: Vector2(509.97, 324.71),
      constraints: Constraints(
          minWidth: 100.00,
          minHeight: 100.00,
          maxWidth: 500.00,
          maxHeight: 500.00),
    );

    expect(result.flip, Flip.none);
    expect(result.rect,
        withTolerance(Box.fromLTWH(450.95, 371.58, 130.23, 100.00)));
    expect(result.resizeMode, ResizeMode.scale);

    result = BoxTransformer.resize(
      resizeMode: ResizeMode.scale,
      initialFlip: Flip.none,
      initialBox: Box.fromLTWH(450.95, 371.58, 130.23, 100.00),
      handle: HandlePosition.right,
      initialLocalPosition: Vector2(15.19, 38.29),
      flipRect: false,
      localPosition: Vector2(248.03, 62.89),
      constraints: Constraints(
          minWidth: 100.00,
          minHeight: 100.00,
          maxWidth: 500.00,
          maxHeight: 500.00),
    );

    expect(result.flip, Flip.none);
    expect(result.rect,
        withTolerance(Box.fromLTWH(450.95, 282.19, 363.07, 278.79)));
    expect(result.resizeMode, ResizeMode.scale);

    result = BoxTransformer.resize(
      resizeMode: ResizeMode.scale,
      initialFlip: Flip.none,
      initialBox: Box.fromLTWH(450.95, 282.19, 363.07, 278.79),
      handle: HandlePosition.left,
      initialLocalPosition: Vector2(9.52, 125.38),
      flipRect: false,
      localPosition: Vector2(466.00, 139.43),
      constraints: Constraints(
          minWidth: 100.00,
          minHeight: 100.00,
          maxWidth: 500.00,
          maxHeight: 500.00),
    );

    expect(result.flip, Flip.none);
    expect(result.rect,
        withTolerance(Box.fromLTWH(683.79, 371.58, 130.23, 100.00)));
    expect(result.resizeMode, ResizeMode.scale);

    result = BoxTransformer.resize(
      resizeMode: ResizeMode.scale,
      initialFlip: Flip.none,
      initialBox: Box.fromLTWH(683.79, 371.58, 130.23, 100.00),
      handle: HandlePosition.bottom,
      initialLocalPosition: Vector2(56.42, 8.01),
      flipRect: false,
      localPosition: Vector2(55.86, 188.19),
      constraints: Constraints(
          minWidth: 100.00,
          minHeight: 100.00,
          maxWidth: 500.00,
          maxHeight: 500.00),
    );

    expect(result.flip, Flip.none);
    expect(result.rect,
        withTolerance(Box.fromLTWH(566.47, 371.58, 364.88, 280.18)));
    expect(result.resizeMode, ResizeMode.scale);

    result = BoxTransformer.resize(
      resizeMode: ResizeMode.scale,
      initialFlip: Flip.none,
      initialBox: Box.fromLTWH(566.47, 371.58, 364.88, 280.18),
      handle: HandlePosition.top,
      initialLocalPosition: Vector2(174.22, 11.41),
      flipRect: false,
      localPosition: Vector2(182.28, 289.15),
      constraints: Constraints(
          minWidth: 100.00,
          minHeight: 100.00,
          maxWidth: 500.00,
          maxHeight: 500.00),
    );

    expect(result.flip, Flip.none);
    expect(result.rect,
        withTolerance(Box.fromLTWH(683.79, 551.77, 130.23, 100.00)));
    expect(result.resizeMode, ResizeMode.scale);

    result = BoxTransformer.resize(
      resizeMode: ResizeMode.scale,
      initialFlip: Flip.none,
      initialBox: Box.fromLTWH(683.79, 551.77, 130.23, 100.00),
      handle: HandlePosition.topRight,
      initialLocalPosition: Vector2(11.36, 13.17),
      flipRect: false,
      localPosition: Vector2(172.38, -94.54),
      constraints: Constraints(
          minWidth: 100.00,
          minHeight: 100.00,
          maxWidth: 500.00,
          maxHeight: 500.00),
    );

    expect(result.flip, Flip.none);
    expect(result.rect,
        withTolerance(Box.fromLTWH(683.79, 428.12, 291.25, 223.64)));
    expect(result.resizeMode, ResizeMode.scale);

    result = BoxTransformer.resize(
      resizeMode: ResizeMode.scale,
      initialFlip: Flip.none,
      initialBox: Box.fromLTWH(683.79, 428.12, 291.25, 223.64),
      handle: HandlePosition.bottomLeft,
      initialLocalPosition: Vector2(7.92, 11.60),
      flipRect: false,
      localPosition: Vector2(359.37, -248.38),
      constraints: Constraints(
          minWidth: 100.00,
          minHeight: 100.00,
          maxWidth: 500.00,
          maxHeight: 500.00),
    );

    expect(result.flip, Flip.none);
    expect(result.rect,
        withTolerance(Box.fromLTWH(844.81, 428.12, 130.23, 100.00)));
    expect(result.resizeMode, ResizeMode.scale);
  });

  test('No flip tests for constrained symmetric resizing', () {
    var result = BoxTransformer.resize(
      resizeMode: ResizeMode.symmetric,
      initialFlip: Flip.none,
      initialBox: Box.fromLTWH(431.46, 362.78, 345.25, 245.42),
      handle: HandlePosition.bottomRight,
      initialLocalPosition: Vector2(12.18, 12.49),
      flipRect: false,
      localPosition: Vector2(-257.60, -212.82),
      constraints: Constraints(
          minWidth: 100.00,
          minHeight: 100.00,
          maxWidth: 500.00,
          maxHeight: 500.00),
    );

    expect(result.flip, Flip.none);
    expect(result.rect,
        withTolerance(Box.fromLTWH(554.09, 435.49, 100.00, 100.00)));
    expect(result.resizeMode, ResizeMode.symmetric);

    result = BoxTransformer.resize(
      resizeMode: ResizeMode.symmetric,
      initialFlip: Flip.none,
      initialBox: Box.fromLTWH(554.09, 435.49, 100.00, 100.00),
      handle: HandlePosition.bottomLeft,
      initialLocalPosition: Vector2(13.90, 12.66),
      flipRect: false,
      localPosition: Vector2(-137.29, 112.18),
      constraints: Constraints(
          minWidth: 100.00,
          minHeight: 100.00,
          maxWidth: 500.00,
          maxHeight: 500.00),
    );

    expect(result.flip, Flip.none);
    expect(result.rect,
        withTolerance(Box.fromLTWH(402.90, 335.97, 402.38, 299.05)));
    expect(result.resizeMode, ResizeMode.symmetric);

    result = BoxTransformer.resize(
      resizeMode: ResizeMode.symmetric,
      initialFlip: Flip.none,
      initialBox: Box.fromLTWH(402.90, 335.97, 402.38, 299.05),
      handle: HandlePosition.topLeft,
      initialLocalPosition: Vector2(12.45, 11.09),
      flipRect: false,
      localPosition: Vector2(335.10, 202.77),
      constraints: Constraints(
          minWidth: 100.00,
          minHeight: 100.00,
          maxWidth: 500.00,
          maxHeight: 500.00),
    );

    expect(result.flip, Flip.none);
    expect(result.rect,
        withTolerance(Box.fromLTWH(554.09, 435.49, 100.00, 100.00)));
    expect(result.resizeMode, ResizeMode.symmetric);

    result = BoxTransformer.resize(
      resizeMode: ResizeMode.symmetric,
      initialFlip: Flip.none,
      initialBox: Box.fromLTWH(554.09, 435.49, 100.00, 100.00),
      handle: HandlePosition.right,
      initialLocalPosition: Vector2(16.83, 38.65),
      flipRect: false,
      localPosition: Vector2(304.54, 50.13),
      constraints: Constraints(
          minWidth: 100.00,
          minHeight: 100.00,
          maxWidth: 500.00,
          maxHeight: 500.00),
    );

    expect(result.flip, Flip.none);
    expect(result.rect,
        withTolerance(Box.fromLTWH(354.09, 435.49, 500.00, 100.00)));
    expect(result.resizeMode, ResizeMode.symmetric);

    result = BoxTransformer.resize(
      resizeMode: ResizeMode.symmetric,
      initialFlip: Flip.none,
      initialBox: Box.fromLTWH(354.09, 435.49, 500.00, 100.00),
      handle: HandlePosition.left,
      initialLocalPosition: Vector2(14.72, 34.89),
      flipRect: false,
      localPosition: Vector2(367.50, 46.66),
      constraints: Constraints(
          minWidth: 100.00,
          minHeight: 100.00,
          maxWidth: 500.00,
          maxHeight: 500.00),
    );

    expect(result.flip, Flip.none);
    expect(result.rect,
        withTolerance(Box.fromLTWH(554.09, 435.49, 100.00, 100.00)));
    expect(result.resizeMode, ResizeMode.symmetric);

    result = BoxTransformer.resize(
      resizeMode: ResizeMode.symmetric,
      initialFlip: Flip.none,
      initialBox: Box.fromLTWH(554.09, 435.49, 100.00, 100.00),
      handle: HandlePosition.topRight,
      initialLocalPosition: Vector2(12.82, 11.79),
      flipRect: false,
      localPosition: Vector2(171.85, -99.64),
      constraints: Constraints(
          minWidth: 100.00,
          minHeight: 100.00,
          maxWidth: 500.00,
          maxHeight: 500.00),
    );

    expect(result.flip, Flip.none);
    expect(result.rect,
        withTolerance(Box.fromLTWH(395.05, 324.07, 418.07, 322.84)));
    expect(result.resizeMode, ResizeMode.symmetric);

    result = BoxTransformer.resize(
      resizeMode: ResizeMode.symmetric,
      initialFlip: Flip.none,
      initialBox: Box.fromLTWH(395.05, 324.07, 418.07, 322.84),
      handle: HandlePosition.top,
      initialLocalPosition: Vector2(196.68, 12.56),
      flipRect: false,
      localPosition: Vector2(199.23, 345.63),
      constraints: Constraints(
          minWidth: 100.00,
          minHeight: 100.00,
          maxWidth: 500.00,
          maxHeight: 500.00),
    );

    expect(result.flip, Flip.none);
    expect(result.rect,
        withTolerance(Box.fromLTWH(395.05, 435.49, 418.07, 100.00)));
    expect(result.resizeMode, ResizeMode.symmetric);

    result = BoxTransformer.resize(
      resizeMode: ResizeMode.symmetric,
      initialFlip: Flip.none,
      initialBox: Box.fromLTWH(395.05, 435.49, 418.07, 100.00),
      handle: HandlePosition.bottom,
      initialLocalPosition: Vector2(196.66, 16.49),
      flipRect: false,
      localPosition: Vector2(191.33, 120.80),
      constraints: Constraints(
          minWidth: 100.00,
          minHeight: 100.00,
          maxWidth: 500.00,
          maxHeight: 500.00),
    );

    expect(result.flip, Flip.none);
    expect(result.rect,
        withTolerance(Box.fromLTWH(395.05, 331.19, 418.07, 308.61)));
    expect(result.resizeMode, ResizeMode.symmetric);

    result = BoxTransformer.resize(
      resizeMode: ResizeMode.symmetric,
      initialFlip: Flip.none,
      initialBox: Box.fromLTWH(395.05, 331.19, 418.07, 308.61),
      handle: HandlePosition.bottomLeft,
      initialLocalPosition: Vector2(10.48, 11.39),
      flipRect: false,
      localPosition: Vector2(306.63, -211.95),
      constraints: Constraints(
          minWidth: 100.00,
          minHeight: 100.00,
          maxWidth: 500.00,
          maxHeight: 500.00),
    );

    expect(result.flip, Flip.none);
    expect(result.rect,
        withTolerance(Box.fromLTWH(554.09, 435.49, 100.00, 100.00)));
    expect(result.resizeMode, ResizeMode.symmetric);

    result = BoxTransformer.resize(
      resizeMode: ResizeMode.symmetric,
      initialFlip: Flip.none,
      initialBox: Box.fromLTWH(554.09, 435.49, 100.00, 100.00),
      handle: HandlePosition.right,
      initialLocalPosition: Vector2(15.35, 45.34),
      flipRect: false,
      localPosition: Vector2(117.42, 42.26),
      constraints: Constraints(
          minWidth: 100.00,
          minHeight: 100.00,
          maxWidth: 500.00,
          maxHeight: 500.00),
    );

    expect(result.flip, Flip.none);
    expect(result.rect,
        withTolerance(Box.fromLTWH(452.01, 435.49, 304.15, 100.00)));
    expect(result.resizeMode, ResizeMode.symmetric);
  });

  test('No flip tests for constrained scaled resizing', () {
    var result = BoxTransformer.resize(
      resizeMode: ResizeMode.scale,
      initialFlip: Flip.none,
      initialBox: Box.fromLTWH(389.22, 318.86, 358.98, 256.83),
      handle: HandlePosition.bottomRight,
      initialLocalPosition: Vector2(14.00, 16.04),
      flipRect: false,
      localPosition: Vector2(-409.46, -296.29),
      constraints: Constraints(
          minWidth: 100.00,
          minHeight: 100.00,
          maxWidth: 500.00,
          maxHeight: 500.00),
    );

    expect(result.flip, Flip.none);
    expect(result.rect,
        withTolerance(Box.fromLTWH(389.22, 318.86, 139.77, 100.00)));
    expect(result.resizeMode, ResizeMode.scale);

    result = BoxTransformer.resize(
      resizeMode: ResizeMode.scale,
      initialFlip: Flip.none,
      initialBox: Box.fromLTWH(389.22, 318.86, 139.77, 100.00),
      handle: HandlePosition.bottomLeft,
      initialLocalPosition: Vector2(9.74, 12.86),
      flipRect: false,
      localPosition: Vector2(-115.60, 165.11),
      constraints: Constraints(
          minWidth: 100.00,
          minHeight: 100.00,
          maxWidth: 500.00,
          maxHeight: 500.00),
    );

    expect(result.flip, Flip.none);
    expect(result.rect,
        withTolerance(Box.fromLTWH(176.41, 318.86, 352.59, 252.25)));
    expect(result.resizeMode, ResizeMode.scale);

    result = BoxTransformer.resize(
      resizeMode: ResizeMode.scale,
      initialFlip: Flip.none,
      initialBox: Box.fromLTWH(176.41, 318.86, 352.59, 252.25),
      handle: HandlePosition.left,
      initialLocalPosition: Vector2(12.24, 116.04),
      flipRect: false,
      localPosition: Vector2(433.31, 100.20),
      constraints: Constraints(
          minWidth: 100.00,
          minHeight: 100.00,
          maxWidth: 500.00,
          maxHeight: 500.00),
    );

    expect(result.flip, Flip.none);
    expect(result.rect,
        withTolerance(Box.fromLTWH(389.22, 394.99, 139.77, 100.00)));
    expect(result.resizeMode, ResizeMode.scale);

    result = BoxTransformer.resize(
      resizeMode: ResizeMode.scale,
      initialFlip: Flip.none,
      initialBox: Box.fromLTWH(389.22, 394.99, 139.77, 100.00),
      handle: HandlePosition.topRight,
      initialLocalPosition: Vector2(15.98, 12.31),
      flipRect: false,
      localPosition: Vector2(205.61, -167.20),
      constraints: Constraints(
          minWidth: 100.00,
          minHeight: 100.00,
          maxWidth: 500.00,
          maxHeight: 500.00),
    );

    expect(result.flip, Flip.none);
    expect(result.rect,
        withTolerance(Box.fromLTWH(389.22, 215.47, 390.69, 279.52)));
    expect(result.resizeMode, ResizeMode.scale);

    result = BoxTransformer.resize(
      resizeMode: ResizeMode.scale,
      initialFlip: Flip.none,
      initialBox: Box.fromLTWH(389.22, 215.47, 390.69, 279.52),
      handle: HandlePosition.top,
      initialLocalPosition: Vector2(185.01, 9.94),
      flipRect: false,
      localPosition: Vector2(185.05, 366.56),
      constraints: Constraints(
          minWidth: 100.00,
          minHeight: 100.00,
          maxWidth: 500.00,
          maxHeight: 500.00),
    );

    expect(result.flip, Flip.none);
    expect(result.rect,
        withTolerance(Box.fromLTWH(514.68, 394.99, 139.77, 100.00)));
    expect(result.resizeMode, ResizeMode.scale);

    result = BoxTransformer.resize(
      resizeMode: ResizeMode.scale,
      initialFlip: Flip.none,
      initialBox: Box.fromLTWH(514.68, 394.99, 139.77, 100.00),
      handle: HandlePosition.bottom,
      initialLocalPosition: Vector2(51.65, 14.78),
      flipRect: false,
      localPosition: Vector2(78.07, 194.17),
      constraints: Constraints(
          minWidth: 100.00,
          minHeight: 100.00,
          maxWidth: 500.00,
          maxHeight: 500.00),
    );

    expect(result.flip, Flip.none);
    expect(result.rect,
        withTolerance(Box.fromLTWH(389.31, 394.99, 390.52, 279.39)));
    expect(result.resizeMode, ResizeMode.scale);

    result = BoxTransformer.resize(
      resizeMode: ResizeMode.scale,
      initialFlip: Flip.none,
      initialBox: Box.fromLTWH(389.31, 394.99, 390.52, 279.39),
      handle: HandlePosition.topLeft,
      initialLocalPosition: Vector2(9.53, 8.76),
      flipRect: false,
      localPosition: Vector2(440.08, 307.97),
      constraints: Constraints(
          minWidth: 100.00,
          minHeight: 100.00,
          maxWidth: 500.00,
          maxHeight: 500.00),
    );

    expect(result.flip, Flip.none);
    expect(result.rect,
        withTolerance(Box.fromLTWH(640.05, 574.38, 139.77, 100.00)));
    expect(result.resizeMode, ResizeMode.scale);

    result = BoxTransformer.resize(
      resizeMode: ResizeMode.scale,
      initialFlip: Flip.none,
      initialBox: Box.fromLTWH(640.05, 574.38, 139.77, 100.00),
      handle: HandlePosition.topLeft,
      initialLocalPosition: Vector2(9.28, 12.86),
      flipRect: false,
      localPosition: Vector2(-199.71, -152.07),
      constraints: Constraints(
          minWidth: 100.00,
          minHeight: 100.00,
          maxWidth: 500.00,
          maxHeight: 500.00),
    );

    expect(result.flip, Flip.none);
    expect(result.rect,
        withTolerance(Box.fromLTWH(409.53, 409.45, 370.30, 264.93)));
    expect(result.resizeMode, ResizeMode.scale);

    result = BoxTransformer.resize(
      resizeMode: ResizeMode.scale,
      initialFlip: Flip.none,
      initialBox: Box.fromLTWH(409.53, 409.45, 370.30, 264.93),
      handle: HandlePosition.right,
      initialLocalPosition: Vector2(16.72, 123.00),
      flipRect: false,
      localPosition: Vector2(-402.62, 125.30),
      constraints: Constraints(
          minWidth: 100.00,
          minHeight: 100.00,
          maxWidth: 500.00,
          maxHeight: 500.00),
    );

    expect(result.flip, Flip.none);
    expect(result.rect,
        withTolerance(Box.fromLTWH(409.53, 491.92, 139.77, 100.00)));
    expect(result.resizeMode, ResizeMode.scale);
  });

  test('No flip tests for constrained symmetrically scaled resizing', () {
    var result = BoxTransformer.resize(
      resizeMode: ResizeMode.symmetricScale,
      initialFlip: Flip.none,
      initialBox: Box.fromLTWH(406.06, 355.07, 382.37, 275.12),
      handle: HandlePosition.bottomRight,
      initialLocalPosition: Vector2(14.67, 10.52),
      flipRect: false,
      localPosition: Vector2(-293.40, -222.36),
      constraints: Constraints(
          minWidth: 100.00,
          minHeight: 100.00,
          maxWidth: 500.00,
          maxHeight: 500.00),
    );

    expect(result.flip, Flip.none);
    expect(result.rect,
        withTolerance(Box.fromLTWH(527.75, 442.63, 138.98, 100.00)));
    expect(result.resizeMode, ResizeMode.symmetricScale);

    result = BoxTransformer.resize(
      resizeMode: ResizeMode.symmetricScale,
      initialFlip: Flip.none,
      initialBox: Box.fromLTWH(527.75, 442.63, 138.98, 100.00),
      handle: HandlePosition.topLeft,
      initialLocalPosition: Vector2(13.68, 10.00),
      flipRect: false,
      localPosition: Vector2(-127.64, -80.70),
      constraints: Constraints(
          minWidth: 100.00,
          minHeight: 100.00,
          maxWidth: 500.00,
          maxHeight: 500.00),
    );

    expect(result.flip, Flip.none);
    expect(result.rect,
        withTolerance(Box.fromLTWH(386.43, 340.95, 421.62, 303.36)));
    expect(result.resizeMode, ResizeMode.symmetricScale);

    result = BoxTransformer.resize(
      resizeMode: ResizeMode.symmetricScale,
      initialFlip: Flip.none,
      initialBox: Box.fromLTWH(386.43, 340.95, 421.62, 303.36),
      handle: HandlePosition.left,
      initialLocalPosition: Vector2(14.45, 135.09),
      flipRect: false,
      localPosition: Vector2(366.75, 142.13),
      constraints: Constraints(
          minWidth: 100.00,
          minHeight: 100.00,
          maxWidth: 500.00,
          maxHeight: 500.00),
    );

    expect(result.flip, Flip.none);
    expect(result.rect,
        withTolerance(Box.fromLTWH(527.75, 442.63, 138.98, 100.00)));
    expect(result.resizeMode, ResizeMode.symmetricScale);

    result = BoxTransformer.resize(
      resizeMode: ResizeMode.symmetricScale,
      initialFlip: Flip.none,
      initialBox: Box.fromLTWH(527.75, 442.63, 138.98, 100.00),
      handle: HandlePosition.right,
      initialLocalPosition: Vector2(13.52, 34.92),
      flipRect: false,
      localPosition: Vector2(198.14, 41.06),
      constraints: Constraints(
          minWidth: 100.00,
          minHeight: 100.00,
          maxWidth: 500.00,
          maxHeight: 500.00),
    );

    expect(result.flip, Flip.none);
    expect(result.rect,
        withTolerance(Box.fromLTWH(347.24, 312.76, 500.00, 359.75)));
    expect(result.resizeMode, ResizeMode.symmetricScale);

    result = BoxTransformer.resize(
      resizeMode: ResizeMode.symmetricScale,
      initialFlip: Flip.none,
      initialBox: Box.fromLTWH(347.24, 312.76, 500.00, 359.75),
      handle: HandlePosition.top,
      initialLocalPosition: Vector2(236.52, 7.31),
      flipRect: false,
      localPosition: Vector2(231.80, 361.49),
      constraints: Constraints(
          minWidth: 100.00,
          minHeight: 100.00,
          maxWidth: 500.00,
          maxHeight: 500.00),
    );

    expect(result.flip, Flip.none);
    expect(result.rect,
        withTolerance(Box.fromLTWH(527.75, 442.63, 138.98, 100.00)));
    expect(result.resizeMode, ResizeMode.symmetricScale);

    result = BoxTransformer.resize(
      resizeMode: ResizeMode.symmetricScale,
      initialFlip: Flip.none,
      initialBox: Box.fromLTWH(527.75, 442.63, 138.98, 100.00),
      handle: HandlePosition.bottom,
      initialLocalPosition: Vector2(60.19, 14.60),
      flipRect: false,
      localPosition: Vector2(69.24, 137.14),
      constraints: Constraints(
          minWidth: 100.00,
          minHeight: 100.00,
          maxWidth: 500.00,
          maxHeight: 500.00),
    );

    expect(result.flip, Flip.none);
    expect(result.rect,
        withTolerance(Box.fromLTWH(357.43, 320.09, 479.62, 345.09)));
    expect(result.resizeMode, ResizeMode.symmetricScale);

    result = BoxTransformer.resize(
      resizeMode: ResizeMode.symmetricScale,
      initialFlip: Flip.none,
      initialBox: Box.fromLTWH(357.43, 320.09, 479.62, 345.09),
      handle: HandlePosition.topLeft,
      initialLocalPosition: Vector2(12.52, 11.43),
      flipRect: false,
      localPosition: Vector2(424.21, 296.07),
      constraints: Constraints(
          minWidth: 100.00,
          minHeight: 100.00,
          maxWidth: 500.00,
          maxHeight: 500.00),
    );

    expect(result.flip, Flip.none);
    expect(result.rect,
        withTolerance(Box.fromLTWH(527.75, 442.63, 138.98, 100.00)));
    expect(result.resizeMode, ResizeMode.symmetricScale);

    result = BoxTransformer.resize(
      resizeMode: ResizeMode.symmetricScale,
      initialFlip: Flip.none,
      initialBox: Box.fromLTWH(527.75, 442.63, 138.98, 100.00),
      handle: HandlePosition.topRight,
      initialLocalPosition: Vector2(13.13, 13.41),
      flipRect: false,
      localPosition: Vector2(134.51, -52.87),
      constraints: Constraints(
          minWidth: 100.00,
          minHeight: 100.00,
          maxWidth: 500.00,
          maxHeight: 500.00),
    );

    expect(result.flip, Flip.none);
    expect(result.rect,
        withTolerance(Box.fromLTWH(406.37, 355.30, 381.74, 274.67)));
    expect(result.resizeMode, ResizeMode.symmetricScale);

    result = BoxTransformer.resize(
      resizeMode: ResizeMode.symmetricScale,
      initialFlip: Flip.none,
      initialBox: Box.fromLTWH(406.37, 355.30, 381.74, 274.67),
      handle: HandlePosition.bottomLeft,
      initialLocalPosition: Vector2(13.34, 10.62),
      flipRect: false,
      localPosition: Vector2(312.48, -210.69),
      constraints: Constraints(
          minWidth: 100.00,
          minHeight: 100.00,
          maxWidth: 500.00,
          maxHeight: 500.00),
    );

    expect(result.flip, Flip.none);
    expect(result.rect,
        withTolerance(Box.fromLTWH(527.75, 442.63, 138.98, 100.00)));
    expect(result.resizeMode, ResizeMode.symmetricScale);
  });
}
