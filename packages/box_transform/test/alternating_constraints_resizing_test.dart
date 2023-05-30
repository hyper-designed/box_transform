import 'package:test/test.dart';
import 'package:vector_math/vector_math.dart';
import 'package:box_transform/box_transform.dart';
import 'utils.dart';

void main() {
  test('No minimum constraints resizing', () {
    var result = BoxTransformer.resize(
      resizeMode: ResizeMode.freeform,
      initialFlip: Flip.none,
      initialBox: Box.fromLTWH(203.88, 324.76, 279.93, 231.05),
      handle: HandlePosition.bottomRight,
      initialLocalPosition: Vector2(14.41, 12.80),
      allowFlipping: true,
      localPosition: Vector2(-31.25, 304.11),
      clampingRect: Box.fromLTWH(49.45, 64.95, 629.23, 809.07),
      constraints: Constraints(
          minWidth: 0.00, minHeight: 0.00, maxWidth: 500.00, maxHeight: 500.00),
    );

    expect(result.flip, Flip.none);
    expect(result.rect,
        withTolerance(Box.fromLTWH(203.88, 324.76, 234.27, 500.00)));
    expect(result.resizeMode, ResizeMode.freeform);

    result = BoxTransformer.resize(
      resizeMode: ResizeMode.freeform,
      initialFlip: Flip.none,
      initialBox: Box.fromLTWH(131.21, 211.78, 234.27, 500.00),
      handle: HandlePosition.bottomRight,
      initialLocalPosition: Vector2(13.13, 11.73),
      allowFlipping: true,
      localPosition: Vector2(348.01, 88.01),
      clampingRect: Box.fromLTWH(49.45, 64.95, 629.23, 809.07),
      constraints: Constraints(
          minWidth: 0.00, minHeight: 0.00, maxWidth: 500.00, maxHeight: 500.00),
    );

    expect(result.flip, Flip.none);
    expect(result.rect,
        withTolerance(Box.fromLTWH(131.21, 211.78, 500.00, 500.00)));
    expect(result.resizeMode, ResizeMode.freeform);

    result = BoxTransformer.resize(
      resizeMode: ResizeMode.freeform,
      initialFlip: Flip.none,
      initialBox: Box.fromLTWH(131.21, 211.78, 500.00, 500.00),
      handle: HandlePosition.bottomRight,
      initialLocalPosition: Vector2(10.68, 13.07),
      allowFlipping: true,
      localPosition: Vector2(-191.14, -243.30),
      clampingRect: Box.fromLTWH(49.45, 64.95, 629.23, 809.07),
      constraints: Constraints(
          minWidth: 0.00, minHeight: 0.00, maxWidth: 500.00, maxHeight: 500.00),
    );

    expect(result.flip, Flip.none);
    expect(result.rect,
        withTolerance(Box.fromLTWH(131.21, 211.78, 298.18, 243.64)));
    expect(result.resizeMode, ResizeMode.freeform);

    result = BoxTransformer.resize(
      resizeMode: ResizeMode.freeform,
      initialFlip: Flip.none,
      initialBox: Box.fromLTWH(131.21, 211.78, 298.18, 243.64),
      handle: HandlePosition.bottomRight,
      initialLocalPosition: Vector2(13.42, 9.13),
      allowFlipping: true,
      localPosition: Vector2(-355.17, -346.76),
      clampingRect: Box.fromLTWH(49.45, 64.95, 629.23, 809.07),
      constraints: Constraints(
          minWidth: 0.00, minHeight: 0.00, maxWidth: 500.00, maxHeight: 500.00),
    );

    expect(result.flip, Flip.diagonal);
    expect(
        result.rect, withTolerance(Box.fromLTWH(60.80, 99.53, 70.41, 112.25)));
    expect(result.resizeMode, ResizeMode.freeform);

    result = BoxTransformer.resize(
      resizeMode: ResizeMode.freeform,
      initialFlip: Flip.diagonal,
      initialBox: Box.fromLTWH(60.80, 99.53, 70.41, 112.25),
      handle: HandlePosition.topLeft,
      initialLocalPosition: Vector2(13.70, 13.32),
      allowFlipping: true,
      localPosition: Vector2(447.61, 388.42),
      clampingRect: Box.fromLTWH(49.45, 64.95, 629.23, 809.07),
      constraints: Constraints(
          minWidth: 0.00, minHeight: 0.00, maxWidth: 500.00, maxHeight: 500.00),
    );

    expect(result.flip, Flip.none);
    expect(result.rect,
        withTolerance(Box.fromLTWH(131.21, 211.78, 363.50, 262.85)));
    expect(result.resizeMode, ResizeMode.freeform);

    result = BoxTransformer.resize(
      resizeMode: ResizeMode.scale,
      initialFlip: Flip.none,
      initialBox: Box.fromLTWH(131.21, 211.78, 363.50, 262.85),
      handle: HandlePosition.bottomRight,
      initialLocalPosition: Vector2(10.53, 12.87),
      allowFlipping: true,
      localPosition: Vector2(195.37, 160.40),
      clampingRect: Box.fromLTWH(49.45, 64.95, 629.23, 809.07),
      constraints: Constraints(
          minWidth: 0.00, minHeight: 0.00, maxWidth: 500.00, maxHeight: 500.00),
    );

    expect(result.flip, Flip.none);
    expect(result.rect,
        withTolerance(Box.fromLTWH(131.21, 211.78, 500.00, 361.55)));
    expect(result.resizeMode, ResizeMode.scale);

    result = BoxTransformer.resize(
      resizeMode: ResizeMode.scale,
      initialFlip: Flip.none,
      initialBox: Box.fromLTWH(131.21, 211.78, 500.00, 361.55),
      handle: HandlePosition.bottomRight,
      initialLocalPosition: Vector2(9.96, 8.98),
      allowFlipping: true,
      localPosition: Vector2(-247.68, -530.13),
      clampingRect: Box.fromLTWH(49.45, 64.95, 629.23, 809.07),
      constraints: Constraints(
          minWidth: 0.00, minHeight: 0.00, maxWidth: 500.00, maxHeight: 500.00),
    );

    expect(result.flip, Flip.vertical);
    expect(result.rect,
        withTolerance(Box.fromLTWH(131.21, 64.95, 203.06, 146.83)));
    expect(result.resizeMode, ResizeMode.scale);

    result = BoxTransformer.resize(
      resizeMode: ResizeMode.scale,
      initialFlip: Flip.vertical,
      initialBox: Box.fromLTWH(131.21, 64.95, 203.06, 146.83),
      handle: HandlePosition.topRight,
      initialLocalPosition: Vector2(12.28, 12.90),
      allowFlipping: true,
      localPosition: Vector2(92.99, 409.93),
      clampingRect: Box.fromLTWH(49.45, 64.95, 629.23, 809.07),
      constraints: Constraints(
          minWidth: 0.00, minHeight: 0.00, maxWidth: 500.00, maxHeight: 500.00),
    );

    expect(result.flip, Flip.none);
    expect(result.rect,
        withTolerance(Box.fromLTWH(131.21, 211.78, 346.01, 250.20)));
    expect(result.resizeMode, ResizeMode.scale);

    result = BoxTransformer.resize(
      resizeMode: ResizeMode.symmetric,
      initialFlip: Flip.none,
      initialBox: Box.fromLTWH(131.21, 211.78, 346.01, 250.20),
      handle: HandlePosition.bottom,
      initialLocalPosition: Vector2(161.04, 12.82),
      allowFlipping: true,
      localPosition: Vector2(171.63, 206.83),
      clampingRect: Box.fromLTWH(49.45, 64.95, 629.23, 809.07),
      constraints: Constraints(
          minWidth: 0.00, minHeight: 0.00, maxWidth: 500.00, maxHeight: 500.00),
    );

    expect(result.flip, Flip.none);
    expect(result.rect,
        withTolerance(Box.fromLTWH(131.21, 86.88, 346.01, 500.00)));
    expect(result.resizeMode, ResizeMode.symmetric);

    result = BoxTransformer.resize(
      resizeMode: ResizeMode.symmetric,
      initialFlip: Flip.none,
      initialBox: Box.fromLTWH(131.21, 86.88, 346.01, 500.00),
      handle: HandlePosition.bottom,
      initialLocalPosition: Vector2(162.79, 16.76),
      allowFlipping: true,
      localPosition: Vector2(164.05, -225.87),
      clampingRect: Box.fromLTWH(49.45, 64.95, 629.23, 809.07),
      constraints: Constraints(
          minWidth: 0.00, minHeight: 0.00, maxWidth: 500.00, maxHeight: 500.00),
    );

    expect(result.flip, Flip.none);
    expect(result.rect,
        withTolerance(Box.fromLTWH(131.21, 329.51, 346.01, 14.73)));
    expect(result.resizeMode, ResizeMode.symmetric);

    result = BoxTransformer.resize(
      resizeMode: ResizeMode.symmetric,
      initialFlip: Flip.none,
      initialBox: Box.fromLTWH(131.21, 329.51, 346.01, 14.73),
      handle: HandlePosition.top,
      initialLocalPosition: Vector2(164.98, 9.81),
      allowFlipping: true,
      localPosition: Vector2(169.32, 306.53),
      clampingRect: Box.fromLTWH(49.45, 64.95, 629.23, 809.07),
      constraints: Constraints(
          minWidth: 0.00, minHeight: 0.00, maxWidth: 500.00, maxHeight: 500.00),
    );

    expect(result.flip, Flip.vertical);
    expect(result.rect,
        withTolerance(Box.fromLTWH(131.21, 86.88, 346.01, 500.00)));
    expect(result.resizeMode, ResizeMode.symmetric);

    result = BoxTransformer.resize(
      resizeMode: ResizeMode.symmetric,
      initialFlip: Flip.vertical,
      initialBox: Box.fromLTWH(131.21, 86.88, 346.01, 500.00),
      handle: HandlePosition.right,
      initialLocalPosition: Vector2(14.43, 243.43),
      allowFlipping: true,
      localPosition: Vector2(-151.23, 239.08),
      clampingRect: Box.fromLTWH(49.45, 64.95, 629.23, 809.07),
      constraints: Constraints(
          minWidth: 0.00, minHeight: 0.00, maxWidth: 500.00, maxHeight: 500.00),
    );

    expect(result.flip, Flip.vertical);
    expect(
        result.rect, withTolerance(Box.fromLTWH(296.86, 86.88, 14.70, 500.00)));
    expect(result.resizeMode, ResizeMode.symmetric);
  });

  test('No maximum constraints resizing', () {
    var result = BoxTransformer.resize(
      resizeMode: ResizeMode.freeform,
      initialFlip: Flip.horizontal,
      initialBox: Box.fromLTWH(131.22, 237.64, 283.32, 218.74),
      handle: HandlePosition.bottomRight,
      initialLocalPosition: Vector2(15.15, 14.43),
      allowFlipping: true,
      localPosition: Vector2(347.37, 119.88),
      clampingRect: Box.fromLTWH(19.63, 50.26, 710.61, 823.75),
      constraints: Constraints(
          minWidth: 100.00,
          minHeight: 100.00,
          maxWidth: double.infinity,
          maxHeight: double.infinity),
    );

    expect(result.flip, Flip.horizontal);
    expect(result.rect,
        withTolerance(Box.fromLTWH(131.22, 237.64, 599.02, 324.18)));
    expect(result.resizeMode, ResizeMode.freeform);

    result = BoxTransformer.resize(
      resizeMode: ResizeMode.freeform,
      initialFlip: Flip.horizontal,
      initialBox: Box.fromLTWH(131.22, 237.64, 599.02, 324.18),
      handle: HandlePosition.bottomRight,
      initialLocalPosition: Vector2(14.01, 12.91),
      allowFlipping: true,
      localPosition: Vector2(30.30, 376.21),
      clampingRect: Box.fromLTWH(19.63, 50.26, 710.61, 823.75),
      constraints: Constraints(
          minWidth: 100.00,
          minHeight: 100.00,
          maxWidth: double.infinity,
          maxHeight: double.infinity),
    );

    expect(result.flip, Flip.horizontal);
    expect(result.rect,
        withTolerance(Box.fromLTWH(131.22, 237.64, 599.02, 636.38)));
    expect(result.resizeMode, ResizeMode.freeform);

    result = BoxTransformer.resize(
      resizeMode: ResizeMode.freeform,
      initialFlip: Flip.horizontal,
      initialBox: Box.fromLTWH(131.22, 237.64, 599.02, 636.38),
      handle: HandlePosition.bottomRight,
      initialLocalPosition: Vector2(16.07, 11.46),
      allowFlipping: true,
      localPosition: Vector2(-333.58, -566.04),
      clampingRect: Box.fromLTWH(19.63, 50.26, 710.61, 823.75),
      constraints: Constraints(
          minWidth: 100.00,
          minHeight: 100.00,
          maxWidth: double.infinity,
          maxHeight: double.infinity),
    );

    expect(result.flip, Flip.horizontal);
    expect(result.rect,
        withTolerance(Box.fromLTWH(131.22, 237.64, 249.37, 100.00)));
    expect(result.resizeMode, ResizeMode.freeform);

    result = BoxTransformer.resize(
      resizeMode: ResizeMode.freeform,
      initialFlip: Flip.horizontal,
      initialBox: Box.fromLTWH(131.22, 237.64, 249.37, 100.00),
      handle: HandlePosition.right,
      initialLocalPosition: Vector2(13.96, 33.22),
      allowFlipping: true,
      localPosition: Vector2(-192.62, 26.48),
      clampingRect: Box.fromLTWH(19.63, 50.26, 710.61, 823.75),
      constraints: Constraints(
          minWidth: 100.00,
          minHeight: 100.00,
          maxWidth: double.infinity,
          maxHeight: double.infinity),
    );

    expect(result.flip, Flip.horizontal);
    expect(result.rect,
        withTolerance(Box.fromLTWH(131.22, 237.64, 100.00, 100.00)));
    expect(result.resizeMode, ResizeMode.freeform);

    result = BoxTransformer.resize(
      resizeMode: ResizeMode.freeform,
      initialFlip: Flip.horizontal,
      initialBox: Box.fromLTWH(131.22, 237.64, 100.00, 100.00),
      handle: HandlePosition.bottomRight,
      initialLocalPosition: Vector2(15.59, 12.48),
      allowFlipping: true,
      localPosition: Vector2(-172.91, -183.30),
      clampingRect: Box.fromLTWH(19.63, 50.26, 710.61, 823.75),
      constraints: Constraints(
          minWidth: 100.00,
          minHeight: 100.00,
          maxWidth: double.infinity,
          maxHeight: double.infinity),
    );

    expect(result.flip, Flip.vertical);
    expect(result.rect,
        withTolerance(Box.fromLTWH(31.22, 137.64, 100.00, 100.00)));
    expect(result.resizeMode, ResizeMode.freeform);

    result = BoxTransformer.resize(
      resizeMode: ResizeMode.freeform,
      initialFlip: Flip.vertical,
      initialBox: Box.fromLTWH(31.22, 137.64, 100.00, 100.00),
      handle: HandlePosition.topLeft,
      initialLocalPosition: Vector2(14.98, 10.80),
      allowFlipping: true,
      localPosition: Vector2(138.90, 784.20),
      clampingRect: Box.fromLTWH(19.63, 50.26, 710.61, 823.75),
      constraints: Constraints(
          minWidth: 100.00,
          minHeight: 100.00,
          maxWidth: double.infinity,
          maxHeight: double.infinity),
    );

    expect(result.flip, Flip.horizontal);
    expect(result.rect,
        withTolerance(Box.fromLTWH(131.22, 237.64, 100.00, 636.38)));
    expect(result.resizeMode, ResizeMode.freeform);

    result = BoxTransformer.resize(
      resizeMode: ResizeMode.freeform,
      initialFlip: Flip.horizontal,
      initialBox: Box.fromLTWH(131.22, 237.64, 100.00, 636.38),
      handle: HandlePosition.bottomLeft,
      initialLocalPosition: Vector2(9.76, 12.04),
      allowFlipping: true,
      localPosition: Vector2(624.53, -578.96),
      clampingRect: Box.fromLTWH(19.63, 50.26, 710.61, 823.75),
      constraints: Constraints(
          minWidth: 100.00,
          minHeight: 100.00,
          maxWidth: double.infinity,
          maxHeight: double.infinity),
    );

    expect(result.flip, Flip.none);
    expect(result.rect,
        withTolerance(Box.fromLTWH(231.22, 237.64, 499.02, 100.00)));
    expect(result.resizeMode, ResizeMode.freeform);

    result = BoxTransformer.resize(
      resizeMode: ResizeMode.freeform,
      initialFlip: Flip.none,
      initialBox: Box.fromLTWH(231.22, 237.64, 499.02, 100.00),
      handle: HandlePosition.right,
      initialLocalPosition: Vector2(14.30, 39.93),
      allowFlipping: true,
      localPosition: Vector2(-420.96, 20.00),
      clampingRect: Box.fromLTWH(19.63, 50.26, 710.61, 823.75),
      constraints: Constraints(
          minWidth: 100.00,
          minHeight: 100.00,
          maxWidth: double.infinity,
          maxHeight: double.infinity),
    );

    expect(result.flip, Flip.none);
    expect(result.rect,
        withTolerance(Box.fromLTWH(231.22, 237.64, 100.00, 100.00)));
    expect(result.resizeMode, ResizeMode.freeform);

    result = BoxTransformer.resize(
      resizeMode: ResizeMode.freeform,
      initialFlip: Flip.none,
      initialBox: Box.fromLTWH(231.22, 237.64, 100.00, 100.00),
      handle: HandlePosition.left,
      initialLocalPosition: Vector2(14.23, 40.81),
      allowFlipping: true,
      localPosition: Vector2(-217.46, 46.11),
      clampingRect: Box.fromLTWH(19.63, 50.26, 710.61, 823.75),
      constraints: Constraints(
          minWidth: 100.00,
          minHeight: 100.00,
          maxWidth: double.infinity,
          maxHeight: double.infinity),
    );

    expect(result.flip, Flip.none);
    expect(result.rect,
        withTolerance(Box.fromLTWH(19.63, 237.64, 311.59, 100.00)));
    expect(result.resizeMode, ResizeMode.freeform);

    result = BoxTransformer.resize(
      resizeMode: ResizeMode.freeform,
      initialFlip: Flip.none,
      initialBox: Box.fromLTWH(19.63, 237.64, 311.59, 100.00),
      handle: HandlePosition.bottom,
      initialLocalPosition: Vector2(134.71, 12.45),
      allowFlipping: true,
      localPosition: Vector2(135.14, 119.74),
      clampingRect: Box.fromLTWH(19.63, 50.26, 710.61, 823.75),
      constraints: Constraints(
          minWidth: 100.00,
          minHeight: 100.00,
          maxWidth: double.infinity,
          maxHeight: double.infinity),
    );

    expect(result.flip, Flip.none);
    expect(result.rect,
        withTolerance(Box.fromLTWH(19.63, 237.64, 311.59, 207.29)));
    expect(result.resizeMode, ResizeMode.freeform);

    result = BoxTransformer.resize(
      resizeMode: ResizeMode.freeform,
      initialFlip: Flip.none,
      initialBox: Box.fromLTWH(19.63, 237.64, 311.59, 207.29),
      handle: HandlePosition.top,
      initialLocalPosition: Vector2(141.13, 12.66),
      allowFlipping: true,
      localPosition: Vector2(114.79, 170.97),
      clampingRect: Box.fromLTWH(19.63, 50.26, 710.61, 823.75),
      constraints: Constraints(
          minWidth: 100.00,
          minHeight: 100.00,
          maxWidth: double.infinity,
          maxHeight: double.infinity),
    );

    expect(result.flip, Flip.none);
    expect(result.rect,
        withTolerance(Box.fromLTWH(19.63, 344.92, 311.59, 100.00)));
    expect(result.resizeMode, ResizeMode.freeform);

    result = BoxTransformer.resize(
      resizeMode: ResizeMode.freeform,
      initialFlip: Flip.none,
      initialBox: Box.fromLTWH(19.63, 344.92, 311.59, 100.00),
      handle: HandlePosition.topRight,
      initialLocalPosition: Vector2(12.12, 13.11),
      allowFlipping: true,
      localPosition: Vector2(-235.58, 68.88),
      clampingRect: Box.fromLTWH(19.63, 50.26, 710.61, 823.75),
      constraints: Constraints(
          minWidth: 100.00,
          minHeight: 100.00,
          maxWidth: double.infinity,
          maxHeight: double.infinity),
    );

    expect(result.flip, Flip.none);
    expect(result.rect,
        withTolerance(Box.fromLTWH(19.63, 344.92, 100.00, 100.00)));
    expect(result.resizeMode, ResizeMode.freeform);
  });
}
