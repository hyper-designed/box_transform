import 'package:test/test.dart';
import 'package:vector_math/vector_math.dart';
import 'package:box_transform/box_transform.dart';
import 'utils.dart';

void main() {
  test('Symmetrically scaled resizing with bottom-right handle', () {
    var result = BoxTransformer.resize(
      resizeMode: ResizeMode.symmetricScale,
      initialFlip: Flip.none,
      initialBox: Box.fromLTWH(235.46, 363.08, 270.06, 200.07),
      handle: HandlePosition.bottomRight,
      initialLocalPosition: Vector2(13.48, 14.26),
      allowFlipping: true,
      localPosition: Vector2(157.08, 116.62),
    );

    expect(result.flip, Flip.none);
    expect(result.rect,
        withTolerance(Box.fromLTWH(91.86, 256.70, 557.25, 412.83)));
    expect(result.resizeMode, ResizeMode.symmetricScale);

    result = BoxTransformer.resize(
      resizeMode: ResizeMode.symmetricScale,
      initialFlip: Flip.none,
      initialBox: Box.fromLTWH(91.86, 256.70, 557.25, 412.83),
      handle: HandlePosition.bottomRight,
      initialLocalPosition: Vector2(12.99, 13.19),
      allowFlipping: true,
      localPosition: Vector2(-143.22, -95.16),
    );

    expect(result.flip, Flip.none);
    expect(result.rect,
        withTolerance(Box.fromLTWH(238.12, 365.05, 264.74, 196.13)));
    expect(result.resizeMode, ResizeMode.symmetricScale);

    result = BoxTransformer.resize(
      resizeMode: ResizeMode.symmetricScale,
      initialFlip: Flip.none,
      initialBox: Box.fromLTWH(238.12, 365.05, 264.74, 196.13),
      handle: HandlePosition.bottomRight,
      initialLocalPosition: Vector2(15.46, 15.54),
      allowFlipping: true,
      localPosition: Vector2(-227.99, -156.73),
    );

    expect(result.flip, Flip.diagonal);
    expect(result.rect,
        withTolerance(Box.fromLTWH(259.41, 380.82, 222.16, 164.58)));
    expect(result.resizeMode, ResizeMode.symmetricScale);

    result = BoxTransformer.resize(
      resizeMode: ResizeMode.symmetricScale,
      initialFlip: Flip.diagonal,
      initialBox: Box.fromLTWH(259.41, 380.82, 222.16, 164.58),
      handle: HandlePosition.topLeft,
      initialLocalPosition: Vector2(14.73, 16.23),
      allowFlipping: true,
      localPosition: Vector2(-114.49, -75.48),
    );

    expect(result.flip, Flip.diagonal);
    expect(result.rect,
        withTolerance(Box.fromLTWH(130.19, 285.09, 480.60, 356.05)));
    expect(result.resizeMode, ResizeMode.symmetricScale);

    result = BoxTransformer.resize(
      resizeMode: ResizeMode.symmetricScale,
      initialFlip: Flip.diagonal,
      initialBox: Box.fromLTWH(130.19, 285.09, 480.60, 356.05),
      handle: HandlePosition.topLeft,
      initialLocalPosition: Vector2(11.15, 13.58),
      allowFlipping: true,
      localPosition: Vector2(357.92, 267.01),
    );

    expect(result.flip, Flip.none);
    expect(result.rect,
        withTolerance(Box.fromLTWH(264.02, 384.24, 212.93, 157.75)));
    expect(result.resizeMode, ResizeMode.symmetricScale);

    result = BoxTransformer.resize(
      resizeMode: ResizeMode.symmetricScale,
      initialFlip: Flip.none,
      initialBox: Box.fromLTWH(264.02, 384.24, 212.93, 157.75),
      handle: HandlePosition.bottomRight,
      initialLocalPosition: Vector2(12.22, 13.25),
      allowFlipping: true,
      localPosition: Vector2(102.94, 70.97),
    );

    expect(result.flip, Flip.none);
    expect(result.rect,
        withTolerance(Box.fromLTWH(173.31, 317.03, 394.36, 292.16)));
    expect(result.resizeMode, ResizeMode.symmetricScale);

    result = BoxTransformer.resize(
      resizeMode: ResizeMode.symmetricScale,
      initialFlip: Flip.none,
      initialBox: Box.fromLTWH(173.31, 317.03, 394.36, 292.16),
      handle: HandlePosition.bottomRight,
      initialLocalPosition: Vector2(14.80, 7.04),
      allowFlipping: true,
      localPosition: Vector2(-384.30, 9.49),
    );

    expect(result.flip, Flip.horizontal);
    expect(result.rect,
        withTolerance(Box.fromLTWH(168.57, 313.52, 403.84, 299.18)));
    expect(result.resizeMode, ResizeMode.symmetricScale);

    result = BoxTransformer.resize(
      resizeMode: ResizeMode.symmetricScale,
      initialFlip: Flip.horizontal,
      initialBox: Box.fromLTWH(168.57, 313.52, 403.84, 299.18),
      handle: HandlePosition.bottomLeft,
      initialLocalPosition: Vector2(13.61, 8.33),
      allowFlipping: true,
      localPosition: Vector2(411.27, -289.86),
    );

    expect(result.flip, Flip.vertical);
    expect(result.rect,
        withTolerance(Box.fromLTWH(169.91, 314.52, 401.16, 297.19)));
    expect(result.resizeMode, ResizeMode.symmetricScale);

    result = BoxTransformer.resize(
      resizeMode: ResizeMode.symmetricScale,
      initialFlip: Flip.vertical,
      initialBox: Box.fromLTWH(169.91, 314.52, 401.16, 297.19),
      handle: HandlePosition.topRight,
      initialLocalPosition: Vector2(10.41, 14.65),
      allowFlipping: true,
      localPosition: Vector2(-380.02, 265.20),
    );

    expect(result.flip, Flip.horizontal);
    expect(result.rect,
        withTolerance(Box.fromLTWH(180.63, 322.46, 379.71, 281.30)));
    expect(result.resizeMode, ResizeMode.symmetricScale);

    result = BoxTransformer.resize(
      resizeMode: ResizeMode.symmetricScale,
      initialFlip: Flip.horizontal,
      initialBox: Box.fromLTWH(180.63, 322.46, 379.71, 281.30),
      handle: HandlePosition.bottomLeft,
      initialLocalPosition: Vector2(9.32, 9.00),
      allowFlipping: true,
      localPosition: Vector2(336.50, -35.19),
    );

    expect(result.flip, Flip.none);
    expect(result.rect,
        withTolerance(Box.fromLTWH(233.16, 361.38, 274.66, 203.47)));
    expect(result.resizeMode, ResizeMode.symmetricScale);
  });

  test('Symmetrically scaled resizing with top-left handle', () {
    var result = BoxTransformer.resize(
      resizeMode: ResizeMode.symmetricScale,
      initialFlip: Flip.none,
      initialBox: Box.fromLTWH(284.95, 399.74, 171.08, 126.74),
      handle: HandlePosition.topLeft,
      initialLocalPosition: Vector2(14.19, 12.12),
      allowFlipping: true,
      localPosition: Vector2(-88.90, -60.66),
    );

    expect(result.flip, Flip.none);
    expect(result.rect,
        withTolerance(Box.fromLTWH(181.86, 323.37, 377.26, 279.49)));
    expect(result.resizeMode, ResizeMode.symmetricScale);

    result = BoxTransformer.resize(
      resizeMode: ResizeMode.symmetricScale,
      initialFlip: Flip.none,
      initialBox: Box.fromLTWH(181.86, 323.37, 377.26, 279.49),
      handle: HandlePosition.topLeft,
      initialLocalPosition: Vector2(12.05, 14.28),
      allowFlipping: true,
      localPosition: Vector2(107.63, 70.96),
    );

    expect(result.flip, Flip.none);
    expect(result.rect,
        withTolerance(Box.fromLTWH(258.37, 380.05, 224.24, 166.13)));
    expect(result.resizeMode, ResizeMode.symmetricScale);

    result = BoxTransformer.resize(
      resizeMode: ResizeMode.symmetricScale,
      initialFlip: Flip.none,
      initialBox: Box.fromLTWH(258.37, 380.05, 224.24, 166.13),
      handle: HandlePosition.topLeft,
      initialLocalPosition: Vector2(9.92, 14.45),
      allowFlipping: true,
      localPosition: Vector2(235.27, 173.31),
    );

    expect(result.flip, Flip.diagonal);
    expect(result.rect,
        withTolerance(Box.fromLTWH(257.26, 379.23, 226.45, 167.76)));
    expect(result.resizeMode, ResizeMode.symmetricScale);

    result = BoxTransformer.resize(
      resizeMode: ResizeMode.symmetricScale,
      initialFlip: Flip.diagonal,
      initialBox: Box.fromLTWH(257.26, 379.23, 226.45, 167.76),
      handle: HandlePosition.bottomRight,
      initialLocalPosition: Vector2(12.26, 8.94),
      allowFlipping: true,
      localPosition: Vector2(152.04, 90.83),
    );

    expect(result.flip, Flip.diagonal);
    expect(result.rect,
        withTolerance(Box.fromLTWH(117.48, 275.68, 506.01, 374.87)));
    expect(result.resizeMode, ResizeMode.symmetricScale);

    result = BoxTransformer.resize(
      resizeMode: ResizeMode.symmetricScale,
      initialFlip: Flip.diagonal,
      initialBox: Box.fromLTWH(117.48, 275.68, 506.01, 374.87),
      handle: HandlePosition.bottomRight,
      initialLocalPosition: Vector2(11.25, 9.22),
      allowFlipping: true,
      localPosition: Vector2(-334.31, -216.10),
    );

    expect(result.flip, Flip.none);
    expect(result.rect,
        withTolerance(Box.fromLTWH(277.93, 394.54, 185.12, 137.14)));
    expect(result.resizeMode, ResizeMode.symmetricScale);

    result = BoxTransformer.resize(
      resizeMode: ResizeMode.symmetricScale,
      initialFlip: Flip.none,
      initialBox: Box.fromLTWH(277.93, 394.54, 185.12, 137.14),
      handle: HandlePosition.topLeft,
      initialLocalPosition: Vector2(10.28, 14.17),
      allowFlipping: true,
      localPosition: Vector2(-73.89, -57.40),
    );

    expect(result.flip, Flip.none);
    expect(result.rect,
        withTolerance(Box.fromLTWH(181.32, 322.97, 378.34, 280.29)));
    expect(result.resizeMode, ResizeMode.symmetricScale);

    result = BoxTransformer.resize(
      resizeMode: ResizeMode.symmetricScale,
      initialFlip: Flip.none,
      initialBox: Box.fromLTWH(181.32, 322.97, 378.34, 280.29),
      handle: HandlePosition.topLeft,
      initialLocalPosition: Vector2(10.09, 11.77),
      allowFlipping: true,
      localPosition: Vector2(366.44, 31.94),
    );

    expect(result.flip, Flip.horizontal);
    expect(result.rect,
        withTolerance(Box.fromLTWH(203.31, 339.26, 334.35, 247.70)));
    expect(result.resizeMode, ResizeMode.symmetricScale);

    result = BoxTransformer.resize(
      resizeMode: ResizeMode.symmetricScale,
      initialFlip: Flip.horizontal,
      initialBox: Box.fromLTWH(203.31, 339.26, 334.35, 247.70),
      handle: HandlePosition.topRight,
      initialLocalPosition: Vector2(11.50, 14.21),
      allowFlipping: true,
      localPosition: Vector2(-314.85, 39.77),
    );

    expect(result.flip, Flip.none);
    expect(result.rect,
        withTolerance(Box.fromLTWH(211.32, 345.19, 318.34, 235.84)));
    expect(result.resizeMode, ResizeMode.symmetricScale);

    result = BoxTransformer.resize(
      resizeMode: ResizeMode.symmetricScale,
      initialFlip: Flip.none,
      initialBox: Box.fromLTWH(211.32, 345.19, 318.34, 235.84),
      handle: HandlePosition.topLeft,
      initialLocalPosition: Vector2(10.77, 12.39),
      allowFlipping: true,
      localPosition: Vector2(-37.81, 274.19),
    );

    expect(result.flip, Flip.vertical);
    expect(result.rect,
        withTolerance(Box.fromLTWH(162.73, 309.20, 415.51, 307.82)));
    expect(result.resizeMode, ResizeMode.symmetricScale);

    result = BoxTransformer.resize(
      resizeMode: ResizeMode.symmetricScale,
      initialFlip: Flip.vertical,
      initialBox: Box.fromLTWH(162.73, 309.20, 415.51, 307.82),
      handle: HandlePosition.bottomLeft,
      initialLocalPosition: Vector2(9.34, 7.75),
      allowFlipping: true,
      localPosition: Vector2(83.50, -244.31),
    );

    expect(result.flip, Flip.none);
    expect(result.rect,
        withTolerance(Box.fromLTWH(236.89, 364.14, 267.19, 197.94)));
    expect(result.resizeMode, ResizeMode.symmetricScale);
  });

  test('Symmetrically scaled resizing with top-right handle', () {
    var result = BoxTransformer.resize(
      resizeMode: ResizeMode.symmetricScale,
      initialFlip: Flip.none,
      initialBox: Box.fromLTWH(236.89, 364.14, 267.19, 197.94),
      handle: HandlePosition.topRight,
      initialLocalPosition: Vector2(13.89, 15.87),
      allowFlipping: true,
      localPosition: Vector2(-36.85, 62.98),
    );

    expect(result.flip, Flip.none);
    expect(result.rect,
        withTolerance(Box.fromLTWH(287.64, 401.74, 165.69, 122.75)));
    expect(result.resizeMode, ResizeMode.symmetricScale);

    result = BoxTransformer.resize(
      resizeMode: ResizeMode.symmetricScale,
      initialFlip: Flip.none,
      initialBox: Box.fromLTWH(287.64, 401.74, 165.69, 122.75),
      handle: HandlePosition.topRight,
      initialLocalPosition: Vector2(13.89, 15.61),
      allowFlipping: true,
      localPosition: Vector2(176.73, -108.87),
    );

    expect(result.flip, Flip.none);
    expect(result.rect,
        withTolerance(Box.fromLTWH(119.61, 277.25, 501.76, 371.72)));
    expect(result.resizeMode, ResizeMode.symmetricScale);

    result = BoxTransformer.resize(
      resizeMode: ResizeMode.symmetricScale,
      initialFlip: Flip.none,
      initialBox: Box.fromLTWH(119.61, 277.25, 501.76, 371.72),
      handle: HandlePosition.topRight,
      initialLocalPosition: Vector2(14.79, 15.14),
      allowFlipping: true,
      localPosition: Vector2(-342.37, 275.40),
    );

    expect(result.flip, Flip.diagonal);
    expect(result.rect,
        withTolerance(Box.fromLTWH(264.21, 384.38, 212.55, 157.47)));
    expect(result.resizeMode, ResizeMode.symmetricScale);

    result = BoxTransformer.resize(
      resizeMode: ResizeMode.symmetricScale,
      initialFlip: Flip.diagonal,
      initialBox: Box.fromLTWH(264.21, 384.38, 212.55, 157.47),
      handle: HandlePosition.bottomLeft,
      initialLocalPosition: Vector2(15.26, 13.15),
      allowFlipping: true,
      localPosition: Vector2(-136.99, 125.11),
    );

    expect(result.flip, Flip.diagonal);
    expect(result.rect,
        withTolerance(Box.fromLTWH(111.96, 271.59, 517.05, 383.05)));
    expect(result.resizeMode, ResizeMode.symmetricScale);

    result = BoxTransformer.resize(
      resizeMode: ResizeMode.symmetricScale,
      initialFlip: Flip.diagonal,
      initialBox: Box.fromLTWH(111.96, 271.59, 517.05, 383.05),
      handle: HandlePosition.bottomLeft,
      initialLocalPosition: Vector2(17.83, 11.60),
      allowFlipping: true,
      localPosition: Vector2(386.43, -267.91),
    );

    expect(result.flip, Flip.none);
    expect(result.rect,
        withTolerance(Box.fromLTWH(251.71, 375.12, 237.55, 175.98)));
    expect(result.resizeMode, ResizeMode.symmetricScale);

    result = BoxTransformer.resize(
      resizeMode: ResizeMode.symmetricScale,
      initialFlip: Flip.none,
      initialBox: Box.fromLTWH(251.71, 375.12, 237.55, 175.98),
      handle: HandlePosition.topRight,
      initialLocalPosition: Vector2(10.30, 12.07),
      allowFlipping: true,
      localPosition: Vector2(132.95, -81.57),
    );

    expect(result.flip, Flip.none);
    expect(result.rect,
        withTolerance(Box.fromLTWH(125.32, 281.48, 490.35, 363.26)));
    expect(result.resizeMode, ResizeMode.symmetricScale);

    result = BoxTransformer.resize(
      resizeMode: ResizeMode.symmetricScale,
      initialFlip: Flip.none,
      initialBox: Box.fromLTWH(125.32, 281.48, 490.35, 363.26),
      handle: HandlePosition.topRight,
      initialLocalPosition: Vector2(14.99, 13.25),
      allowFlipping: true,
      localPosition: Vector2(-443.29, 40.61),
    );

    expect(result.flip, Flip.horizontal);
    expect(result.rect,
        withTolerance(Box.fromLTWH(157.39, 305.24, 426.20, 315.74)));
    expect(result.resizeMode, ResizeMode.symmetricScale);

    result = BoxTransformer.resize(
      resizeMode: ResizeMode.symmetricScale,
      initialFlip: Flip.horizontal,
      initialBox: Box.fromLTWH(157.39, 305.24, 426.20, 315.74),
      handle: HandlePosition.topLeft,
      initialLocalPosition: Vector2(14.99, 16.85),
      allowFlipping: true,
      localPosition: Vector2(437.38, 331.34),
    );

    expect(result.flip, Flip.vertical);
    expect(result.rect,
        withTolerance(Box.fromLTWH(159.08, 306.50, 422.81, 313.23)));
    expect(result.resizeMode, ResizeMode.symmetricScale);

    result = BoxTransformer.resize(
      resizeMode: ResizeMode.symmetricScale,
      initialFlip: Flip.vertical,
      initialBox: Box.fromLTWH(159.08, 306.50, 422.81, 313.23),
      handle: HandlePosition.bottomRight,
      initialLocalPosition: Vector2(13.11, 16.37),
      allowFlipping: true,
      localPosition: Vector2(-42.21, -246.37),
    );

    expect(result.flip, Flip.none);
    expect(result.rect,
        withTolerance(Box.fromLTWH(214.40, 347.48, 312.18, 231.27)));
    expect(result.resizeMode, ResizeMode.symmetricScale);
  });

  test('Symmetrically scaled resizing with bottom-left handle', () {
    var result = BoxTransformer.resize(
      resizeMode: ResizeMode.symmetricScale,
      initialFlip: Flip.none,
      initialBox: Box.fromLTWH(214.40, 347.48, 312.18, 231.27),
      handle: HandlePosition.bottomLeft,
      initialLocalPosition: Vector2(13.23, 9.72),
      allowFlipping: true,
      localPosition: Vector2(135.02, -67.08),
    );

    expect(result.flip, Flip.none);
    expect(result.rect,
        withTolerance(Box.fromLTWH(318.06, 424.27, 104.85, 77.68)));
    expect(result.resizeMode, ResizeMode.symmetricScale);

    result = BoxTransformer.resize(
      resizeMode: ResizeMode.symmetricScale,
      initialFlip: Flip.none,
      initialBox: Box.fromLTWH(318.06, 424.27, 104.85, 77.68),
      handle: HandlePosition.bottomLeft,
      initialLocalPosition: Vector2(12.77, 14.39),
      allowFlipping: true,
      localPosition: Vector2(-156.70, 137.26),
    );

    expect(result.flip, Flip.none);
    expect(result.rect,
        withTolerance(Box.fromLTWH(148.59, 298.72, 443.81, 328.79)));
    expect(result.resizeMode, ResizeMode.symmetricScale);

    result = BoxTransformer.resize(
      resizeMode: ResizeMode.symmetricScale,
      initialFlip: Flip.none,
      initialBox: Box.fromLTWH(148.59, 298.72, 443.81, 328.79),
      handle: HandlePosition.bottomLeft,
      initialLocalPosition: Vector2(12.74, 10.69),
      allowFlipping: true,
      localPosition: Vector2(340.97, -237.88),
    );

    expect(result.flip, Flip.diagonal);
    expect(result.rect,
        withTolerance(Box.fromLTWH(256.86, 378.94, 227.25, 168.35)));
    expect(result.resizeMode, ResizeMode.symmetricScale);

    result = BoxTransformer.resize(
      resizeMode: ResizeMode.symmetricScale,
      initialFlip: Flip.diagonal,
      initialBox: Box.fromLTWH(256.86, 378.94, 227.25, 168.35),
      handle: HandlePosition.topRight,
      initialLocalPosition: Vector2(11.30, 13.04),
      allowFlipping: true,
      localPosition: Vector2(142.37, -78.15),
    );

    expect(result.flip, Flip.diagonal);
    expect(result.rect,
        withTolerance(Box.fromLTWH(125.79, 281.83, 489.39, 362.56)));
    expect(result.resizeMode, ResizeMode.symmetricScale);

    result = BoxTransformer.resize(
      resizeMode: ResizeMode.symmetricScale,
      initialFlip: Flip.diagonal,
      initialBox: Box.fromLTWH(125.79, 281.83, 489.39, 362.56),
      handle: HandlePosition.topRight,
      initialLocalPosition: Vector2(19.27, 14.42),
      allowFlipping: true,
      localPosition: Vector2(-337.80, 256.66),
    );

    expect(result.flip, Flip.none);
    expect(result.rect,
        withTolerance(Box.fromLTWH(258.12, 379.87, 224.74, 166.50)));
    expect(result.resizeMode, ResizeMode.symmetricScale);

    result = BoxTransformer.resize(
      resizeMode: ResizeMode.symmetricScale,
      initialFlip: Flip.none,
      initialBox: Box.fromLTWH(258.12, 379.87, 224.74, 166.50),
      handle: HandlePosition.bottomLeft,
      initialLocalPosition: Vector2(12.83, 11.28),
      allowFlipping: true,
      localPosition: Vector2(-80.41, 63.34),
    );

    expect(result.flip, Flip.none);
    expect(result.rect,
        withTolerance(Box.fromLTWH(164.88, 310.79, 411.22, 304.64)));
    expect(result.resizeMode, ResizeMode.symmetricScale);

    result = BoxTransformer.resize(
      resizeMode: ResizeMode.symmetricScale,
      initialFlip: Flip.none,
      initialBox: Box.fromLTWH(164.88, 310.79, 411.22, 304.64),
      handle: HandlePosition.bottomLeft,
      initialLocalPosition: Vector2(14.23, 9.74),
      allowFlipping: true,
      localPosition: Vector2(453.86, 16.38),
    );

    expect(result.flip, Flip.horizontal);
    expect(result.rect,
        withTolerance(Box.fromLTWH(136.46, 289.74, 468.06, 346.75)));
    expect(result.resizeMode, ResizeMode.symmetricScale);

    result = BoxTransformer.resize(
      resizeMode: ResizeMode.symmetricScale,
      initialFlip: Flip.horizontal,
      initialBox: Box.fromLTWH(136.46, 289.74, 468.06, 346.75),
      handle: HandlePosition.bottomRight,
      initialLocalPosition: Vector2(16.28, 8.21),
      allowFlipping: true,
      localPosition: Vector2(-38.98, -289.72),
    );

    expect(result.flip, Flip.diagonal);
    expect(result.rect,
        withTolerance(Box.fromLTWH(191.71, 330.67, 357.55, 264.88)));
    expect(result.resizeMode, ResizeMode.symmetricScale);

    result = BoxTransformer.resize(
      resizeMode: ResizeMode.symmetricScale,
      initialFlip: Flip.diagonal,
      initialBox: Box.fromLTWH(191.71, 330.67, 357.55, 264.88),
      handle: HandlePosition.topRight,
      initialLocalPosition: Vector2(12.41, 13.25),
      allowFlipping: true,
      localPosition: Vector2(-301.94, 255.93),
    );

    expect(result.flip, Flip.none);
    expect(result.rect,
        withTolerance(Box.fromLTWH(221.69, 352.88, 297.60, 220.47)));
    expect(result.resizeMode, ResizeMode.symmetricScale);
  });

  test('Symmetrically scaled resizing with right handle', () {
    var result = BoxTransformer.resize(
      resizeMode: ResizeMode.symmetricScale,
      initialFlip: Flip.none,
      initialBox: Box.fromLTWH(221.69, 352.88, 297.60, 220.47),
      handle: HandlePosition.right,
      initialLocalPosition: Vector2(15.85, 103.64),
      allowFlipping: true,
      localPosition: Vector2(153.06, 97.78),
    );

    expect(result.flip, Flip.none);
    expect(result.rect,
        withTolerance(Box.fromLTWH(84.49, 251.23, 572.00, 423.76)));
    expect(result.resizeMode, ResizeMode.symmetricScale);

    result = BoxTransformer.resize(
      resizeMode: ResizeMode.symmetricScale,
      initialFlip: Flip.none,
      initialBox: Box.fromLTWH(84.49, 251.23, 572.00, 423.76),
      handle: HandlePosition.right,
      initialLocalPosition: Vector2(13.95, 199.18),
      allowFlipping: true,
      localPosition: Vector2(-159.72, 220.16),
    );

    expect(result.flip, Flip.none);
    expect(result.rect,
        withTolerance(Box.fromLTWH(258.16, 379.90, 224.66, 166.43)));
    expect(result.resizeMode, ResizeMode.symmetricScale);

    result = BoxTransformer.resize(
      resizeMode: ResizeMode.symmetricScale,
      initialFlip: Flip.none,
      initialBox: Box.fromLTWH(258.16, 379.90, 224.66, 166.43),
      handle: HandlePosition.right,
      initialLocalPosition: Vector2(16.28, 80.30),
      allowFlipping: true,
      localPosition: Vector2(-202.26, 74.67),
    );

    expect(result.flip, Flip.horizontal);
    expect(result.rect,
        withTolerance(Box.fromLTWH(264.29, 384.44, 212.40, 157.36)));
    expect(result.resizeMode, ResizeMode.symmetricScale);

    result = BoxTransformer.resize(
      resizeMode: ResizeMode.symmetricScale,
      initialFlip: Flip.horizontal,
      initialBox: Box.fromLTWH(264.29, 384.44, 212.40, 157.36),
      handle: HandlePosition.left,
      initialLocalPosition: Vector2(12.70, 68.47),
      allowFlipping: true,
      localPosition: Vector2(-193.76, 69.06),
    );

    expect(result.flip, Flip.horizontal);
    expect(result.rect,
        withTolerance(Box.fromLTWH(57.83, 231.48, 625.33, 463.26)));
    expect(result.resizeMode, ResizeMode.symmetricScale);

    result = BoxTransformer.resize(
      resizeMode: ResizeMode.symmetricScale,
      initialFlip: Flip.horizontal,
      initialBox: Box.fromLTWH(57.83, 231.48, 625.33, 463.26),
      handle: HandlePosition.left,
      initialLocalPosition: Vector2(12.70, 222.02),
      allowFlipping: true,
      localPosition: Vector2(441.93, 222.71),
    );

    expect(result.flip, Flip.none);
    expect(result.rect,
        withTolerance(Box.fromLTWH(253.92, 376.76, 233.13, 172.71)));
    expect(result.resizeMode, ResizeMode.symmetricScale);

    result = BoxTransformer.resize(
      resizeMode: ResizeMode.symmetricScale,
      initialFlip: Flip.none,
      initialBox: Box.fromLTWH(253.92, 376.76, 233.13, 172.71),
      handle: HandlePosition.right,
      initialLocalPosition: Vector2(15.75, 78.37),
      allowFlipping: true,
      localPosition: Vector2(125.95, 68.53),
    );

    expect(result.flip, Flip.none);
    expect(result.rect,
        withTolerance(Box.fromLTWH(143.73, 295.12, 453.53, 335.99)));
    expect(result.resizeMode, ResizeMode.symmetricScale);

    result = BoxTransformer.resize(
      resizeMode: ResizeMode.symmetricScale,
      initialFlip: Flip.none,
      initialBox: Box.fromLTWH(143.73, 295.12, 453.53, 335.99),
      handle: HandlePosition.right,
      initialLocalPosition: Vector2(15.75, 155.09),
      allowFlipping: true,
      localPosition: Vector2(21.92, -54.67),
    );

    expect(result.flip, Flip.vertical);
    expect(result.rect,
        withTolerance(Box.fromLTWH(137.55, 290.54, 465.88, 345.14)));
    expect(result.resizeMode, ResizeMode.symmetricScale);

    result = BoxTransformer.resize(
      resizeMode: ResizeMode.symmetricScale,
      initialFlip: Flip.vertical,
      initialBox: Box.fromLTWH(137.55, 290.54, 465.88, 345.14),
      handle: HandlePosition.right,
      initialLocalPosition: Vector2(11.39, 161.46),
      allowFlipping: true,
      localPosition: Vector2(-96.86, -42.27),
    );

    expect(result.flip, Flip.none);
    expect(result.rect,
        withTolerance(Box.fromLTWH(245.79, 370.73, 249.39, 184.76)));
    expect(result.resizeMode, ResizeMode.symmetricScale);
  });

  test('Symmetrically scaled resizing with bottom handle', () {
    var result = BoxTransformer.resize(
      resizeMode: ResizeMode.symmetricScale,
      initialFlip: Flip.none,
      initialBox: Box.fromLTWH(245.79, 370.73, 249.39, 184.76),
      handle: HandlePosition.bottom,
      initialLocalPosition: Vector2(115.65, 12.81),
      allowFlipping: true,
      localPosition: Vector2(120.79, 144.53),
    );

    expect(result.flip, Flip.none);
    expect(result.rect,
        withTolerance(Box.fromLTWH(67.99, 239.02, 604.99, 448.20)));
    expect(result.resizeMode, ResizeMode.symmetricScale);

    result = BoxTransformer.resize(
      resizeMode: ResizeMode.symmetricScale,
      initialFlip: Flip.none,
      initialBox: Box.fromLTWH(67.99, 239.02, 604.99, 448.20),
      handle: HandlePosition.bottom,
      initialLocalPosition: Vector2(293.57, 16.74),
      allowFlipping: true,
      localPosition: Vector2(292.50, -96.18),
    );

    expect(result.flip, Flip.none);
    expect(result.rect,
        withTolerance(Box.fromLTWH(220.42, 351.94, 300.14, 222.35)));
    expect(result.resizeMode, ResizeMode.symmetricScale);

    result = BoxTransformer.resize(
      resizeMode: ResizeMode.symmetricScale,
      initialFlip: Flip.none,
      initialBox: Box.fromLTWH(220.42, 351.94, 300.14, 222.35),
      handle: HandlePosition.bottom,
      initialLocalPosition: Vector2(140.07, 16.74),
      allowFlipping: true,
      localPosition: Vector2(137.13, -213.56),
    );

    expect(result.flip, Flip.vertical);
    expect(result.rect,
        withTolerance(Box.fromLTWH(209.69, 343.99, 321.60, 238.25)));
    expect(result.resizeMode, ResizeMode.symmetricScale);

    result = BoxTransformer.resize(
      resizeMode: ResizeMode.symmetricScale,
      initialFlip: Flip.vertical,
      initialBox: Box.fromLTWH(209.69, 343.99, 321.60, 238.25),
      handle: HandlePosition.top,
      initialLocalPosition: Vector2(147.86, 14.36),
      allowFlipping: true,
      localPosition: Vector2(135.33, -115.63),
    );

    expect(result.flip, Flip.vertical);
    expect(result.rect,
        withTolerance(Box.fromLTWH(34.22, 214.00, 672.53, 498.23)));
    expect(result.resizeMode, ResizeMode.symmetricScale);

    result = BoxTransformer.resize(
      resizeMode: ResizeMode.symmetricScale,
      initialFlip: Flip.vertical,
      initialBox: Box.fromLTWH(34.22, 214.00, 672.53, 498.23),
      handle: HandlePosition.top,
      initialLocalPosition: Vector2(316.89, 11.98),
      allowFlipping: true,
      localPosition: Vector2(326.73, 381.28),
    );

    expect(result.flip, Flip.none);
    expect(result.rect,
        withTolerance(Box.fromLTWH(208.26, 342.93, 324.46, 240.37)));
    expect(result.resizeMode, ResizeMode.symmetricScale);

    result = BoxTransformer.resize(
      resizeMode: ResizeMode.symmetricScale,
      initialFlip: Flip.none,
      initialBox: Box.fromLTWH(208.26, 342.93, 324.46, 240.37),
      handle: HandlePosition.bottom,
      initialLocalPosition: Vector2(155.51, 14.55),
      allowFlipping: true,
      localPosition: Vector2(-84.03, 18.62),
    );

    expect(result.flip, Flip.horizontal);
    expect(result.rect,
        withTolerance(Box.fromLTWH(202.78, 338.87, 335.42, 248.49)));
    expect(result.resizeMode, ResizeMode.symmetricScale);

    result = BoxTransformer.resize(
      resizeMode: ResizeMode.symmetricScale,
      initialFlip: Flip.horizontal,
      initialBox: Box.fromLTWH(202.78, 338.87, 335.42, 248.49),
      handle: HandlePosition.bottom,
      initialLocalPosition: Vector2(159.25, 13.81),
      allowFlipping: true,
      localPosition: Vector2(-122.61, 35.87),
    );

    expect(result.flip, Flip.none);
    expect(result.rect,
        withTolerance(Box.fromLTWH(173.00, 316.80, 394.98, 292.62)));
    expect(result.resizeMode, ResizeMode.symmetricScale);

    result = BoxTransformer.resize(
      resizeMode: ResizeMode.symmetricScale,
      initialFlip: Flip.none,
      initialBox: Box.fromLTWH(173.00, 316.80, 394.98, 292.62),
      handle: HandlePosition.bottom,
      initialLocalPosition: Vector2(185.96, 14.59),
      allowFlipping: true,
      localPosition: Vector2(187.03, -34.48),
    );

    expect(result.flip, Flip.none);
    expect(result.rect,
        withTolerance(Box.fromLTWH(239.23, 365.87, 262.51, 194.48)));
    expect(result.resizeMode, ResizeMode.symmetricScale);
  });

  test('Symmetrically scaled resizing with left handle', () {
    var result = BoxTransformer.resize(
      resizeMode: ResizeMode.symmetricScale,
      initialFlip: Flip.none,
      initialBox: Box.fromLTWH(239.23, 365.87, 262.51, 194.48),
      handle: HandlePosition.left,
      initialLocalPosition: Vector2(13.42, 90.20),
      allowFlipping: true,
      localPosition: Vector2(-113.03, 86.45),
    );

    expect(result.flip, Flip.none);
    expect(result.rect,
        withTolerance(Box.fromLTWH(112.78, 272.20, 515.41, 381.83)));
    expect(result.resizeMode, ResizeMode.symmetricScale);

    result = BoxTransformer.resize(
      resizeMode: ResizeMode.symmetricScale,
      initialFlip: Flip.none,
      initialBox: Box.fromLTWH(112.78, 272.20, 515.41, 381.83),
      handle: HandlePosition.left,
      initialLocalPosition: Vector2(13.42, 180.12),
      allowFlipping: true,
      localPosition: Vector2(167.57, 177.16),
    );

    expect(result.flip, Flip.none);
    expect(result.rect,
        withTolerance(Box.fromLTWH(266.94, 386.40, 207.11, 153.43)));
    expect(result.resizeMode, ResizeMode.symmetricScale);

    result = BoxTransformer.resize(
      resizeMode: ResizeMode.symmetricScale,
      initialFlip: Flip.none,
      initialBox: Box.fromLTWH(266.94, 386.40, 207.11, 153.43),
      handle: HandlePosition.left,
      initialLocalPosition: Vector2(12.47, 62.96),
      allowFlipping: true,
      localPosition: Vector2(215.97, 68.03),
    );

    expect(result.flip, Flip.horizontal);
    expect(result.rect,
        withTolerance(Box.fromLTWH(270.53, 389.06, 199.91, 148.10)));
    expect(result.resizeMode, ResizeMode.symmetricScale);

    result = BoxTransformer.resize(
      resizeMode: ResizeMode.symmetricScale,
      initialFlip: Flip.horizontal,
      initialBox: Box.fromLTWH(270.53, 389.06, 199.91, 148.10),
      handle: HandlePosition.right,
      initialLocalPosition: Vector2(14.81, 59.41),
      allowFlipping: true,
      localPosition: Vector2(154.47, 57.14),
    );

    expect(result.flip, Flip.horizontal);
    expect(result.rect,
        withTolerance(Box.fromLTWH(130.87, 285.60, 479.24, 355.04)));
    expect(result.resizeMode, ResizeMode.symmetricScale);

    result = BoxTransformer.resize(
      resizeMode: ResizeMode.symmetricScale,
      initialFlip: Flip.horizontal,
      initialBox: Box.fromLTWH(130.87, 285.60, 479.24, 355.04),
      handle: HandlePosition.right,
      initialLocalPosition: Vector2(12.19, 167.13),
      allowFlipping: true,
      localPosition: Vector2(-344.20, 177.98),
    );

    expect(result.flip, Flip.none);
    expect(result.rect,
        withTolerance(Box.fromLTWH(253.72, 376.61, 233.53, 173.01)));
    expect(result.resizeMode, ResizeMode.symmetricScale);

    result = BoxTransformer.resize(
      resizeMode: ResizeMode.symmetricScale,
      initialFlip: Flip.none,
      initialBox: Box.fromLTWH(253.72, 376.61, 233.53, 173.01),
      handle: HandlePosition.left,
      initialLocalPosition: Vector2(13.36, 78.15),
      allowFlipping: true,
      localPosition: Vector2(-131.79, 89.08),
    );

    expect(result.flip, Flip.none);
    expect(result.rect,
        withTolerance(Box.fromLTWH(108.58, 269.08, 523.82, 388.07)));
    expect(result.resizeMode, ResizeMode.symmetricScale);

    result = BoxTransformer.resize(
      resizeMode: ResizeMode.symmetricScale,
      initialFlip: Flip.none,
      initialBox: Box.fromLTWH(108.58, 269.08, 523.82, 388.07),
      handle: HandlePosition.left,
      initialLocalPosition: Vector2(10.26, 188.75),
      allowFlipping: true,
      localPosition: Vector2(93.74, -56.22),
    );

    expect(result.flip, Flip.vertical);
    expect(result.rect,
        withTolerance(Box.fromLTWH(192.06, 330.93, 356.86, 264.37)));
    expect(result.resizeMode, ResizeMode.symmetricScale);

    result = BoxTransformer.resize(
      resizeMode: ResizeMode.symmetricScale,
      initialFlip: Flip.vertical,
      initialBox: Box.fromLTWH(192.06, 330.93, 356.86, 264.37),
      handle: HandlePosition.left,
      initialLocalPosition: Vector2(12.73, 121.95),
      allowFlipping: true,
      localPosition: Vector2(87.89, -85.02),
    );

    expect(result.flip, Flip.none);
    expect(result.rect,
        withTolerance(Box.fromLTWH(267.22, 386.61, 206.53, 153.01)));
    expect(result.resizeMode, ResizeMode.symmetricScale);
  });

  test('Symmetrically scaled resizing with top handle', () {
    var result = BoxTransformer.resize(
      resizeMode: ResizeMode.symmetricScale,
      initialFlip: Flip.none,
      initialBox: Box.fromLTWH(267.22, 386.61, 206.53, 153.01),
      handle: HandlePosition.top,
      initialLocalPosition: Vector2(89.82, 12.97),
      allowFlipping: true,
      localPosition: Vector2(99.49, -126.73),
    );

    expect(result.flip, Flip.none);
    expect(result.rect,
        withTolerance(Box.fromLTWH(78.65, 246.91, 583.68, 432.41)));
    expect(result.resizeMode, ResizeMode.symmetricScale);

    result = BoxTransformer.resize(
      resizeMode: ResizeMode.symmetricScale,
      initialFlip: Flip.none,
      initialBox: Box.fromLTWH(78.65, 246.91, 583.68, 432.41),
      handle: HandlePosition.top,
      initialLocalPosition: Vector2(288.06, 12.97),
      allowFlipping: true,
      localPosition: Vector2(281.88, 347.74),
    );

    expect(result.flip, Flip.vertical);
    expect(result.rect,
        withTolerance(Box.fromLTWH(210.45, 344.55, 320.08, 237.13)));
    expect(result.resizeMode, ResizeMode.symmetricScale);

    result = BoxTransformer.resize(
      resizeMode: ResizeMode.symmetricScale,
      initialFlip: Flip.vertical,
      initialBox: Box.fromLTWH(210.45, 344.55, 320.08, 237.13),
      handle: HandlePosition.bottom,
      initialLocalPosition: Vector2(150.09, 15.79),
      allowFlipping: true,
      localPosition: Vector2(152.89, -247.90),
    );

    expect(result.flip, Flip.none);
    expect(result.rect,
        withTolerance(Box.fromLTWH(174.59, 317.99, 391.79, 290.25)));
    expect(result.resizeMode, ResizeMode.symmetricScale);

    result = BoxTransformer.resize(
      resizeMode: ResizeMode.symmetricScale,
      initialFlip: Flip.none,
      initialBox: Box.fromLTWH(174.59, 317.99, 391.79, 290.25),
      handle: HandlePosition.top,
      initialLocalPosition: Vector2(188.75, 15.79),
      allowFlipping: true,
      localPosition: Vector2(190.14, 66.88),
    );

    expect(result.flip, Flip.none);
    expect(result.rect,
        withTolerance(Box.fromLTWH(243.56, 369.08, 253.85, 188.06)));
    expect(result.resizeMode, ResizeMode.symmetricScale);

    result = BoxTransformer.resize(
      resizeMode: ResizeMode.symmetricScale,
      initialFlip: Flip.none,
      initialBox: Box.fromLTWH(243.56, 369.08, 253.85, 188.06),
      handle: HandlePosition.top,
      initialLocalPosition: Vector2(119.03, 14.36),
      allowFlipping: true,
      localPosition: Vector2(-113.89, -4.14),
    );

    expect(result.flip, Flip.horizontal);
    expect(result.rect,
        withTolerance(Box.fromLTWH(218.60, 350.59, 303.78, 225.05)));
    expect(result.resizeMode, ResizeMode.symmetricScale);

    result = BoxTransformer.resize(
      resizeMode: ResizeMode.symmetricScale,
      initialFlip: Flip.horizontal,
      initialBox: Box.fromLTWH(218.60, 350.59, 303.78, 225.05),
      handle: HandlePosition.top,
      initialLocalPosition: Vector2(142.47, 9.98),
      allowFlipping: true,
      localPosition: Vector2(-169.05, 40.63),
    );

    expect(result.flip, Flip.none);
    expect(result.rect,
        withTolerance(Box.fromLTWH(259.97, 381.24, 221.03, 163.75)));
    expect(result.resizeMode, ResizeMode.symmetricScale);

    result = BoxTransformer.resize(
      resizeMode: ResizeMode.symmetricScale,
      initialFlip: Flip.none,
      initialBox: Box.fromLTWH(259.97, 381.24, 221.03, 163.75),
      handle: HandlePosition.top,
      initialLocalPosition: Vector2(103.65, 12.74),
      allowFlipping: true,
      localPosition: Vector2(114.67, -45.63),
    );

    expect(result.flip, Flip.none);
    expect(result.rect,
        withTolerance(Box.fromLTWH(181.18, 322.87, 378.62, 280.49)));
    expect(result.resizeMode, ResizeMode.symmetricScale);
  });
}
