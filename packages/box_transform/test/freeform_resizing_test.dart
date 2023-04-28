import 'package:test/test.dart';
import 'package:vector_math/vector_math.dart';
import 'package:box_transform/box_transform.dart';
import 'utils.dart';

void main() {
  test('Freeform resizing with top-left handle', () {
    var result = BoxTransformer.resize(
      resizeMode: ResizeMode.freeform,
      initialFlip: Flip.none,
      initialBox: Box.fromLTWH(301, 351, 280, 160),
      handle: HandlePosition.topLeft,
      initialLocalPosition: Vector2(13, 14),
      flipRect: true,
      localPosition: Vector2(223, 24),
    );

    expect(result.flip, Flip.none);
    expect(result.rect.floor(), withTolerance(Box.fromLTWH(510, 361, 70, 150)));
    expect(result.resizeMode, ResizeMode.freeform);

    result = BoxTransformer.resize(
      resizeMode: ResizeMode.freeform,
      initialFlip: Flip.none,
      initialBox: Box.fromLTWH(510, 361, 70, 150),
      handle: HandlePosition.topLeft,
      initialLocalPosition: Vector2(13, 13),
      flipRect: true,
      localPosition: Vector2(-268, -82),
    );

    expect(result.flip, Flip.none);
    expect(
        result.rect.floor(), withTolerance(Box.fromLTWH(230, 266, 350, 245)));
    expect(result.resizeMode, ResizeMode.freeform);

    result = BoxTransformer.resize(
      resizeMode: ResizeMode.freeform,
      initialFlip: Flip.none,
      initialBox: Box.fromLTWH(230, 266, 350, 245),
      handle: HandlePosition.topLeft,
      initialLocalPosition: Vector2(14, 13),
      flipRect: true,
      localPosition: Vector2(482, 462),
    );

    expect(result.flip, Flip.diagonal);
    expect(
        result.rect.floor(), withTolerance(Box.fromLTWH(580, 511, 119, 205)));
    expect(result.resizeMode, ResizeMode.freeform);

    result = BoxTransformer.resize(
      resizeMode: ResizeMode.freeform,
      initialFlip: Flip.diagonal,
      initialBox: Box.fromLTWH(580, 511, 119, 205),
      handle: HandlePosition.bottomRight,
      initialLocalPosition: Vector2(14, 12),
      flipRect: true,
      localPosition: Vector2(-424, 57),
    );

    expect(result.flip, Flip.vertical);
    expect(
        result.rect.floor(), withTolerance(Box.fromLTWH(261, 511, 320, 250)));
    expect(result.resizeMode, ResizeMode.freeform);

    result = BoxTransformer.resize(
      resizeMode: ResizeMode.freeform,
      initialFlip: Flip.vertical,
      initialBox: Box.fromLTWH(261, 511, 320, 250),
      handle: HandlePosition.bottomLeft,
      initialLocalPosition: Vector2(16, 14),
      flipRect: true,
      localPosition: Vector2(463, -504),
    );

    expect(result.flip, Flip.horizontal);
    expect(
        result.rect.floor(), withTolerance(Box.fromLTWH(580, 243, 127, 268)));
    expect(result.resizeMode, ResizeMode.freeform);

    result = BoxTransformer.resize(
      resizeMode: ResizeMode.freeform,
      initialFlip: Flip.horizontal,
      initialBox: Box.fromLTWH(580, 243, 127, 268),
      handle: HandlePosition.topRight,
      initialLocalPosition: Vector2(16, 14),
      flipRect: true,
      localPosition: Vector2(-298, 395),
    );

    expect(result.flip, Flip.vertical);
    expect(
        result.rect.floor(), withTolerance(Box.fromLTWH(394, 511, 186, 113)));
    expect(result.resizeMode, ResizeMode.freeform);

    result = BoxTransformer.resize(
      resizeMode: ResizeMode.freeform,
      initialFlip: Flip.vertical,
      initialBox: Box.fromLTWH(394, 511, 186, 113),
      handle: HandlePosition.bottomLeft,
      initialLocalPosition: Vector2(6, 11),
      flipRect: true,
      localPosition: Vector2(320, -2),
    );

    expect(result.flip, Flip.diagonal);
    expect(
        result.rect.floor(), withTolerance(Box.fromLTWH(580, 511, 128, 100)));
    expect(result.resizeMode, ResizeMode.freeform);

    result = BoxTransformer.resize(
      resizeMode: ResizeMode.freeform,
      initialFlip: Flip.diagonal,
      initialBox: Box.fromLTWH(580, 511, 128, 100),
      handle: HandlePosition.bottomRight,
      initialLocalPosition: Vector2(5, 11),
      flipRect: true,
      localPosition: Vector2(-323, -224),
    );

    expect(result.flip, Flip.none);
    expect(
        result.rect.floor(), withTolerance(Box.fromLTWH(380, 375, 200, 136)));
    expect(result.resizeMode, ResizeMode.freeform);

    result = BoxTransformer.resize(
      resizeMode: ResizeMode.freeform,
      initialFlip: Flip.none,
      initialBox: Box.fromLTWH(380, 375, 200, 136),
      handle: HandlePosition.topLeft,
      initialLocalPosition: Vector2(12, 16),
      flipRect: true,
      localPosition: Vector2(-309, -235),
    );

    expect(result.flip, Flip.none);
    expect(result.rect.floor(), withTolerance(Box.fromLTWH(60, 125, 521, 386)));
    expect(result.resizeMode, ResizeMode.freeform);

    result = BoxTransformer.resize(
      resizeMode: ResizeMode.freeform,
      initialFlip: Flip.none,
      initialBox: Box.fromLTWH(60, 125, 521, 386),
      handle: HandlePosition.topLeft,
      initialLocalPosition: Vector2(10, 10),
      flipRect: true,
      localPosition: Vector2(618, 651),
    );

    expect(result.flip, Flip.diagonal);
    expect(result.rect.floor(), withTolerance(Box.fromLTWH(580, 511, 88, 255)));
    expect(result.resizeMode, ResizeMode.freeform);
  });

  test('Freeform resizing with top-right handle', () {
    var result = BoxTransformer.resize(
      resizeMode: ResizeMode.freeform,
      initialFlip: Flip.none,
      initialBox: Box.fromLTWH(327, 272, 283, 186),
      handle: HandlePosition.topRight,
      initialLocalPosition: Vector2(14, 11),
      flipRect: true,
      localPosition: Vector2(-185, 139),
    );

    expect(result.flip, Flip.none);
    expect(result.rect.floor(), withTolerance(Box.fromLTWH(327, 400, 84, 58)));
    expect(result.resizeMode, ResizeMode.freeform);

    result = BoxTransformer.resize(
      resizeMode: ResizeMode.freeform,
      initialFlip: Flip.none,
      initialBox: Box.fromLTWH(327, 400, 84, 58),
      handle: HandlePosition.topRight,
      initialLocalPosition: Vector2(13, 10),
      flipRect: true,
      localPosition: Vector2(273, -234),
    );

    expect(result.flip, Flip.none);
    expect(
        result.rect.floor(), withTolerance(Box.fromLTWH(327, 156, 344, 303)));
    expect(result.resizeMode, ResizeMode.freeform);

    result = BoxTransformer.resize(
      resizeMode: ResizeMode.freeform,
      initialFlip: Flip.none,
      initialBox: Box.fromLTWH(327, 156, 344, 303),
      handle: HandlePosition.topRight,
      initialLocalPosition: Vector2(16, 12),
      flipRect: true,
      localPosition: Vector2(-605, 144),
    );

    expect(result.flip, Flip.horizontal);
    expect(result.rect.floor(), withTolerance(Box.fromLTWH(51, 287, 277, 171)));
    expect(result.resizeMode, ResizeMode.freeform);

    result = BoxTransformer.resize(
      resizeMode: ResizeMode.freeform,
      initialFlip: Flip.horizontal,
      initialBox: Box.fromLTWH(51, 287, 277, 171),
      handle: HandlePosition.topLeft,
      initialLocalPosition: Vector2(15, 12),
      flipRect: true,
      localPosition: Vector2(201, 39),
    );

    expect(result.flip, Flip.horizontal);
    expect(result.rect.floor(), withTolerance(Box.fromLTWH(236, 313, 91, 145)));
    expect(result.resizeMode, ResizeMode.freeform);

    result = BoxTransformer.resize(
      resizeMode: ResizeMode.freeform,
      initialFlip: Flip.horizontal,
      initialBox: Box.fromLTWH(236, 313, 91, 145),
      handle: HandlePosition.topLeft,
      initialLocalPosition: Vector2(13, 12),
      flipRect: true,
      localPosition: Vector2(-172, 415),
    );

    expect(result.flip, Flip.diagonal);
    expect(result.rect.floor(), withTolerance(Box.fromLTWH(51, 459, 276, 258)));
    expect(result.resizeMode, ResizeMode.freeform);

    result = BoxTransformer.resize(
      resizeMode: ResizeMode.freeform,
      initialFlip: Flip.diagonal,
      initialBox: Box.fromLTWH(51, 459, 276, 258),
      handle: HandlePosition.bottomLeft,
      initialLocalPosition: Vector2(13, 13),
      flipRect: true,
      localPosition: Vector2(71, -139),
    );

    expect(result.flip, Flip.diagonal);
    expect(
        result.rect.floor(), withTolerance(Box.fromLTWH(109, 459, 218, 105)));
    expect(result.resizeMode, ResizeMode.freeform);

    result = BoxTransformer.resize(
      resizeMode: ResizeMode.freeform,
      initialFlip: Flip.diagonal,
      initialBox: Box.fromLTWH(109, 459, 218, 105),
      handle: HandlePosition.bottomLeft,
      initialLocalPosition: Vector2(12, 10),
      flipRect: true,
      localPosition: Vector2(586, 143),
    );

    expect(result.flip, Flip.vertical);
    expect(
        result.rect.floor(), withTolerance(Box.fromLTWH(327, 459, 356, 238)));
    expect(result.resizeMode, ResizeMode.freeform);

    result = BoxTransformer.resize(
      resizeMode: ResizeMode.freeform,
      initialFlip: Flip.vertical,
      initialBox: Box.fromLTWH(327, 459, 356, 238),
      handle: HandlePosition.bottomRight,
      initialLocalPosition: Vector2(11, 15),
      flipRect: true,
      localPosition: Vector2(-184, -119),
    );

    expect(result.flip, Flip.vertical);
    expect(
        result.rect.floor(), withTolerance(Box.fromLTWH(327, 459, 160, 103)));
    expect(result.resizeMode, ResizeMode.freeform);

    result = BoxTransformer.resize(
      resizeMode: ResizeMode.freeform,
      initialFlip: Flip.vertical,
      initialBox: Box.fromLTWH(327, 459, 160, 103),
      handle: HandlePosition.bottomRight,
      initialLocalPosition: Vector2(16, 17),
      flipRect: true,
      localPosition: Vector2(-10, -207),
    );

    expect(result.flip, Flip.none);
    expect(
        result.rect.floor(), withTolerance(Box.fromLTWH(327, 339, 134, 120)));
    expect(result.resizeMode, ResizeMode.freeform);

    result = BoxTransformer.resize(
      resizeMode: ResizeMode.freeform,
      initialFlip: Flip.none,
      initialBox: Box.fromLTWH(327, 339, 134, 120),
      handle: HandlePosition.topRight,
      initialLocalPosition: Vector2(16, 17),
      flipRect: true,
      localPosition: Vector2(206, -110),
    );

    expect(result.flip, Flip.none);
    expect(
        result.rect.floor(), withTolerance(Box.fromLTWH(327, 213, 324, 246)));
    expect(result.resizeMode, ResizeMode.freeform);
  });

  test('Freeform resizing with bottom-left handle', () {
    var result = BoxTransformer.resize(
      resizeMode: ResizeMode.freeform,
      initialFlip: Flip.none,
      initialBox: Box.fromLTWH(138, 431, 238, 166),
      handle: HandlePosition.bottomLeft,
      initialLocalPosition: Vector2(11, 13),
      flipRect: true,
      localPosition: Vector2(113, -66),
    );

    expect(result.flip, Flip.none);
    expect(result.rect.floor(), withTolerance(Box.fromLTWH(240, 431, 136, 88)));
    expect(result.resizeMode, ResizeMode.freeform);

    result = BoxTransformer.resize(
      resizeMode: ResizeMode.freeform,
      initialFlip: Flip.none,
      initialBox: Box.fromLTWH(240, 431, 136, 88),
      handle: HandlePosition.bottomLeft,
      initialLocalPosition: Vector2(13, 15),
      flipRect: true,
      localPosition: Vector2(-147, 166),
    );

    expect(result.flip, Flip.none);
    expect(result.rect.floor(), withTolerance(Box.fromLTWH(80, 431, 296, 239)));
    expect(result.resizeMode, ResizeMode.freeform);

    result = BoxTransformer.resize(
      resizeMode: ResizeMode.freeform,
      initialFlip: Flip.none,
      initialBox: Box.fromLTWH(80, 431, 296, 239),
      handle: HandlePosition.bottomLeft,
      initialLocalPosition: Vector2(10, 11),
      flipRect: true,
      localPosition: Vector2(-15, -534),
    );

    expect(result.flip, Flip.vertical);
    expect(result.rect.floor(), withTolerance(Box.fromLTWH(55, 126, 321, 305)));
    expect(result.resizeMode, ResizeMode.freeform);

    result = BoxTransformer.resize(
      resizeMode: ResizeMode.freeform,
      initialFlip: Flip.vertical,
      initialBox: Box.fromLTWH(55, 126, 321, 305),
      handle: HandlePosition.topLeft,
      initialLocalPosition: Vector2(13, 13),
      flipRect: true,
      localPosition: Vector2(170, 208),
    );

    expect(result.flip, Flip.vertical);
    expect(
        result.rect.floor(), withTolerance(Box.fromLTWH(213, 321, 163, 110)));
    expect(result.resizeMode, ResizeMode.freeform);

    result = BoxTransformer.resize(
      resizeMode: ResizeMode.freeform,
      initialFlip: Flip.vertical,
      initialBox: Box.fromLTWH(213, 321, 163, 110),
      handle: HandlePosition.topLeft,
      initialLocalPosition: Vector2(16, 15),
      flipRect: true,
      localPosition: Vector2(360, -4),
    );

    expect(result.flip, Flip.diagonal);
    expect(
        result.rect.floor(), withTolerance(Box.fromLTWH(376, 302, 181, 129)));
    expect(result.resizeMode, ResizeMode.freeform);

    result = BoxTransformer.resize(
      resizeMode: ResizeMode.freeform,
      initialFlip: Flip.diagonal,
      initialBox: Box.fromLTWH(376, 302, 181, 129),
      handle: HandlePosition.topRight,
      initialLocalPosition: Vector2(18, 13),
      flipRect: true,
      localPosition: Vector2(127, -172),
    );

    expect(result.flip, Flip.diagonal);
    expect(
        result.rect.floor(), withTolerance(Box.fromLTWH(376, 117, 290, 314)));
    expect(result.resizeMode, ResizeMode.freeform);

    result = BoxTransformer.resize(
      resizeMode: ResizeMode.freeform,
      initialFlip: Flip.diagonal,
      initialBox: Box.fromLTWH(376, 117, 290, 314),
      handle: HandlePosition.topRight,
      initialLocalPosition: Vector2(18, 13),
      flipRect: true,
      localPosition: Vector2(-105, 427),
    );

    expect(result.flip, Flip.horizontal);
    expect(result.rect.floor(), withTolerance(Box.fromLTWH(376, 431, 166, 99)));
    expect(result.resizeMode, ResizeMode.freeform);

    result = BoxTransformer.resize(
      resizeMode: ResizeMode.freeform,
      initialFlip: Flip.horizontal,
      initialBox: Box.fromLTWH(376, 431, 166, 99),
      handle: HandlePosition.bottomRight,
      initialLocalPosition: Vector2(12, 7),
      flipRect: true,
      localPosition: Vector2(143, 142),
    );

    expect(result.flip, Flip.horizontal);
    expect(
        result.rect.floor(), withTolerance(Box.fromLTWH(376, 431, 297, 234)));
    expect(result.resizeMode, ResizeMode.freeform);

    result = BoxTransformer.resize(
      resizeMode: ResizeMode.freeform,
      initialFlip: Flip.horizontal,
      initialBox: Box.fromLTWH(376, 431, 297, 234),
      handle: HandlePosition.bottomRight,
      initialLocalPosition: Vector2(11, 8),
      flipRect: true,
      localPosition: Vector2(-636, 62),
    );

    expect(result.flip, Flip.none);
    expect(result.rect.floor(), withTolerance(Box.fromLTWH(27, 431, 350, 288)));
    expect(result.resizeMode, ResizeMode.freeform);

    result = BoxTransformer.resize(
      resizeMode: ResizeMode.freeform,
      initialFlip: Flip.none,
      initialBox: Box.fromLTWH(27, 431, 350, 288),
      handle: HandlePosition.bottomLeft,
      initialLocalPosition: Vector2(13, 10),
      flipRect: true,
      localPosition: Vector2(243, -181),
    );

    expect(result.flip, Flip.none);
    expect(result.rect.floor(), withTolerance(Box.fromLTWH(257, 431, 120, 97)));
    expect(result.resizeMode, ResizeMode.freeform);
  });

  test('Freeform resizing with bottom-right handle', () {
    var result = BoxTransformer.resize(
      resizeMode: ResizeMode.freeform,
      initialFlip: Flip.none,
      initialBox: Box.fromLTWH(257, 431, 120, 97),
      handle: HandlePosition.bottomRight,
      initialLocalPosition: Vector2(14, 14),
      flipRect: true,
      localPosition: Vector2(272, 171),
    );

    expect(result.flip, Flip.none);
    expect(
        result.rect.floor(), withTolerance(Box.fromLTWH(257, 431, 377, 255)));
    expect(result.resizeMode, ResizeMode.freeform);

    result = BoxTransformer.resize(
      resizeMode: ResizeMode.freeform,
      initialFlip: Flip.none,
      initialBox: Box.fromLTWH(257, 431, 377, 255),
      handle: HandlePosition.bottomRight,
      initialLocalPosition: Vector2(14, 14),
      flipRect: true,
      localPosition: Vector2(-213, -127),
    );

    expect(result.flip, Flip.none);
    expect(
        result.rect.floor(), withTolerance(Box.fromLTWH(257, 431, 151, 114)));
    expect(result.resizeMode, ResizeMode.freeform);

    result = BoxTransformer.resize(
      resizeMode: ResizeMode.freeform,
      initialFlip: Flip.none,
      initialBox: Box.fromLTWH(257, 431, 151, 114),
      handle: HandlePosition.bottomRight,
      initialLocalPosition: Vector2(14, 14),
      flipRect: true,
      localPosition: Vector2(-373, 22),
    );

    expect(result.flip, Flip.horizontal);
    expect(result.rect.floor(), withTolerance(Box.fromLTWH(21, 431, 236, 123)));
    expect(result.resizeMode, ResizeMode.freeform);

    result = BoxTransformer.resize(
      resizeMode: ResizeMode.freeform,
      initialFlip: Flip.horizontal,
      initialBox: Box.fromLTWH(21, 431, 236, 123),
      handle: HandlePosition.bottomLeft,
      initialLocalPosition: Vector2(14, 14),
      flipRect: true,
      localPosition: Vector2(155, 6),
    );

    expect(result.flip, Flip.horizontal);
    expect(result.rect.floor(), withTolerance(Box.fromLTWH(162, 431, 94, 115)));
    expect(result.resizeMode, ResizeMode.freeform);

    result = BoxTransformer.resize(
      resizeMode: ResizeMode.freeform,
      initialFlip: Flip.horizontal,
      initialBox: Box.fromLTWH(162, 431, 94, 115),
      handle: HandlePosition.bottomLeft,
      initialLocalPosition: Vector2(14, 13),
      flipRect: true,
      localPosition: Vector2(10, -253),
    );

    expect(result.flip, Flip.diagonal);
    expect(result.rect.floor(), withTolerance(Box.fromLTWH(157, 281, 99, 151)));
    expect(result.resizeMode, ResizeMode.freeform);

    result = BoxTransformer.resize(
      resizeMode: ResizeMode.freeform,
      initialFlip: Flip.diagonal,
      initialBox: Box.fromLTWH(157, 281, 99, 151),
      handle: HandlePosition.topLeft,
      initialLocalPosition: Vector2(13, 13),
      flipRect: true,
      localPosition: Vector2(-118, -20),
    );

    expect(result.flip, Flip.diagonal);
    expect(result.rect.floor(), withTolerance(Box.fromLTWH(26, 248, 231, 183)));
    expect(result.resizeMode, ResizeMode.freeform);

    result = BoxTransformer.resize(
      resizeMode: ResizeMode.freeform,
      initialFlip: Flip.diagonal,
      initialBox: Box.fromLTWH(26, 248, 231, 183),
      handle: HandlePosition.topLeft,
      initialLocalPosition: Vector2(13, 12),
      flipRect: true,
      localPosition: Vector2(647, -64),
    );

    expect(result.flip, Flip.vertical);
    expect(
        result.rect.floor(), withTolerance(Box.fromLTWH(257, 172, 403, 259)));
    expect(result.resizeMode, ResizeMode.freeform);

    result = BoxTransformer.resize(
      resizeMode: ResizeMode.freeform,
      initialFlip: Flip.vertical,
      initialBox: Box.fromLTWH(257, 172, 403, 259),
      handle: HandlePosition.topRight,
      initialLocalPosition: Vector2(17, 9),
      flipRect: true,
      localPosition: Vector2(-248, 124),
    );

    expect(result.flip, Flip.vertical);
    expect(
        result.rect.floor(), withTolerance(Box.fromLTWH(257, 287, 138, 144)));
    expect(result.resizeMode, ResizeMode.freeform);

    result = BoxTransformer.resize(
      resizeMode: ResizeMode.freeform,
      initialFlip: Flip.vertical,
      initialBox: Box.fromLTWH(257, 287, 138, 144),
      handle: HandlePosition.topRight,
      initialLocalPosition: Vector2(17, 15),
      flipRect: true,
      localPosition: Vector2(27, 258),
    );

    expect(result.flip, Flip.none);
    expect(result.rect.floor(), withTolerance(Box.fromLTWH(257, 431, 148, 99)));
    expect(result.resizeMode, ResizeMode.freeform);

    result = BoxTransformer.resize(
      resizeMode: ResizeMode.freeform,
      initialFlip: Flip.none,
      initialBox: Box.fromLTWH(257, 431, 148, 99),
      handle: HandlePosition.bottomRight,
      initialLocalPosition: Vector2(15, 14),
      flipRect: true,
      localPosition: Vector2(197, 136),
    );

    expect(result.flip, Flip.none);
    expect(
        result.rect.floor(), withTolerance(Box.fromLTWH(257, 431, 330, 221)));
    expect(result.resizeMode, ResizeMode.freeform);
  });

  test('Freeform resizing with right handle', () {
    var result = BoxTransformer.resize(
      resizeMode: ResizeMode.freeform,
      initialFlip: Flip.none,
      initialBox: Box.fromLTWH(318, 373, 232, 165),
      handle: HandlePosition.right,
      initialLocalPosition: Vector2(15, 72),
      flipRect: true,
      localPosition: Vector2(-152, 71),
    );

    expect(result.flip, Flip.none);
    expect(result.rect.floor(), withTolerance(Box.fromLTWH(318, 373, 66, 165)));
    expect(result.resizeMode, ResizeMode.freeform);

    result = BoxTransformer.resize(
      resizeMode: ResizeMode.freeform,
      initialFlip: Flip.none,
      initialBox: Box.fromLTWH(318, 373, 66, 165),
      handle: HandlePosition.right,
      initialLocalPosition: Vector2(13, 73),
      flipRect: true,
      localPosition: Vector2(311, 57),
    );

    expect(result.flip, Flip.none);
    expect(
        result.rect.floor(), withTolerance(Box.fromLTWH(318, 373, 363, 165)));
    expect(result.resizeMode, ResizeMode.freeform);

    result = BoxTransformer.resize(
      resizeMode: ResizeMode.freeform,
      initialFlip: Flip.none,
      initialBox: Box.fromLTWH(318, 373, 363, 165),
      handle: HandlePosition.right,
      initialLocalPosition: Vector2(13, 71),
      flipRect: true,
      localPosition: Vector2(-626, 68),
    );

    expect(result.flip, Flip.horizontal);
    expect(result.rect.floor(), withTolerance(Box.fromLTWH(42, 373, 276, 165)));
    expect(result.resizeMode, ResizeMode.freeform);

    result = BoxTransformer.resize(
      resizeMode: ResizeMode.freeform,
      initialFlip: Flip.horizontal,
      initialBox: Box.fromLTWH(42, 373, 276, 165),
      handle: HandlePosition.left,
      initialLocalPosition: Vector2(11, 69),
      flipRect: true,
      localPosition: Vector2(180, 63),
    );

    expect(result.flip, Flip.horizontal);
    expect(
        result.rect.floor(), withTolerance(Box.fromLTWH(211, 373, 107, 165)));
    expect(result.resizeMode, ResizeMode.freeform);

    result = BoxTransformer.resize(
      resizeMode: ResizeMode.freeform,
      initialFlip: Flip.horizontal,
      initialBox: Box.fromLTWH(211, 373, 107, 165),
      handle: HandlePosition.left,
      initialLocalPosition: Vector2(12, 67),
      flipRect: true,
      localPosition: Vector2(238, 87),
    );

    expect(result.flip, Flip.none);
    expect(
        result.rect.floor(), withTolerance(Box.fromLTWH(318, 373, 119, 165)));
    expect(result.resizeMode, ResizeMode.freeform);

    result = BoxTransformer.resize(
      resizeMode: ResizeMode.freeform,
      initialFlip: Flip.none,
      initialBox: Box.fromLTWH(318, 373, 119, 165),
      handle: HandlePosition.right,
      initialLocalPosition: Vector2(8, 79),
      flipRect: true,
      localPosition: Vector2(194, 71),
    );

    expect(result.flip, Flip.none);
    expect(
        result.rect.floor(), withTolerance(Box.fromLTWH(318, 373, 304, 165)));
    expect(result.resizeMode, ResizeMode.freeform);
  });

  test('Freeform resizing with left handle', () {
    var result = BoxTransformer.resize(
      resizeMode: ResizeMode.freeform,
      initialFlip: Flip.none,
      initialBox: Box.fromLTWH(271, 398, 178, 126),
      handle: HandlePosition.left,
      initialLocalPosition: Vector2(12, 51),
      flipRect: true,
      localPosition: Vector2(-176, 39),
    );

    expect(result.flip, Flip.none);
    expect(result.rect.floor(), withTolerance(Box.fromLTWH(83, 398, 366, 126)));
    expect(result.resizeMode, ResizeMode.freeform);

    result = BoxTransformer.resize(
      resizeMode: ResizeMode.freeform,
      initialFlip: Flip.none,
      initialBox: Box.fromLTWH(83, 398, 366, 126),
      handle: HandlePosition.left,
      initialLocalPosition: Vector2(13, 49),
      flipRect: true,
      localPosition: Vector2(289, 42),
    );

    expect(result.flip, Flip.none);
    expect(result.rect.floor(), withTolerance(Box.fromLTWH(359, 398, 90, 126)));
    expect(result.resizeMode, ResizeMode.freeform);

    result = BoxTransformer.resize(
      resizeMode: ResizeMode.freeform,
      initialFlip: Flip.none,
      initialBox: Box.fromLTWH(359, 398, 90, 126),
      handle: HandlePosition.left,
      initialLocalPosition: Vector2(12, 50),
      flipRect: true,
      localPosition: Vector2(172, 54),
    );

    expect(result.flip, Flip.horizontal);
    expect(result.rect.floor(), withTolerance(Box.fromLTWH(450, 398, 69, 126)));
    expect(result.resizeMode, ResizeMode.freeform);

    result = BoxTransformer.resize(
      resizeMode: ResizeMode.freeform,
      initialFlip: Flip.horizontal,
      initialBox: Box.fromLTWH(450, 398, 69, 126),
      handle: HandlePosition.right,
      initialLocalPosition: Vector2(12, 53),
      flipRect: true,
      localPosition: Vector2(188, 43),
    );

    expect(result.flip, Flip.horizontal);
    expect(
        result.rect.floor(), withTolerance(Box.fromLTWH(450, 398, 245, 126)));
    expect(result.resizeMode, ResizeMode.freeform);

    result = BoxTransformer.resize(
      resizeMode: ResizeMode.freeform,
      initialFlip: Flip.horizontal,
      initialBox: Box.fromLTWH(450, 398, 245, 126),
      handle: HandlePosition.right,
      initialLocalPosition: Vector2(14, 53),
      flipRect: true,
      localPosition: Vector2(-577, 64),
    );

    expect(result.flip, Flip.none);
    expect(
        result.rect.floor(), withTolerance(Box.fromLTWH(105, 398, 345, 126)));
    expect(result.resizeMode, ResizeMode.freeform);

    result = BoxTransformer.resize(
      resizeMode: ResizeMode.freeform,
      initialFlip: Flip.none,
      initialBox: Box.fromLTWH(105, 398, 345, 126),
      handle: HandlePosition.left,
      initialLocalPosition: Vector2(12, 59),
      flipRect: true,
      localPosition: Vector2(183, 64),
    );

    expect(result.flip, Flip.none);
    expect(
        result.rect.floor(), withTolerance(Box.fromLTWH(275, 398, 174, 126)));
    expect(result.resizeMode, ResizeMode.freeform);
  });

  test('Freeform resizing with bottom handle', () {
    var result = BoxTransformer.resize(
      resizeMode: ResizeMode.freeform,
      initialFlip: Flip.none,
      initialBox: Box.fromLTWH(275, 398, 174, 126),
      handle: HandlePosition.bottom,
      initialLocalPosition: Vector2(78, 13),
      flipRect: true,
      localPosition: Vector2(77, 251),
    );

    expect(result.flip, Flip.none);
    expect(
        result.rect.floor(), withTolerance(Box.fromLTWH(275, 398, 174, 364)));
    expect(result.resizeMode, ResizeMode.freeform);

    result = BoxTransformer.resize(
      resizeMode: ResizeMode.freeform,
      initialFlip: Flip.none,
      initialBox: Box.fromLTWH(275, 398, 174, 364),
      handle: HandlePosition.bottom,
      initialLocalPosition: Vector2(80, 15),
      flipRect: true,
      localPosition: Vector2(63, -224),
    );

    expect(result.flip, Flip.none);
    expect(
        result.rect.floor(), withTolerance(Box.fromLTWH(275, 398, 174, 124)));
    expect(result.resizeMode, ResizeMode.freeform);

    result = BoxTransformer.resize(
      resizeMode: ResizeMode.freeform,
      initialFlip: Flip.none,
      initialBox: Box.fromLTWH(275, 398, 174, 124),
      handle: HandlePosition.bottom,
      initialLocalPosition: Vector2(79, 15),
      flipRect: true,
      localPosition: Vector2(72, -472),
    );

    expect(result.flip, Flip.vertical);
    expect(result.rect.floor(), withTolerance(Box.fromLTWH(275, 35, 174, 363)));
    expect(result.resizeMode, ResizeMode.freeform);

    result = BoxTransformer.resize(
      resizeMode: ResizeMode.freeform,
      initialFlip: Flip.vertical,
      initialBox: Box.fromLTWH(275, 35, 174, 363),
      handle: HandlePosition.top,
      initialLocalPosition: Vector2(74, 11),
      flipRect: true,
      localPosition: Vector2(68, 243),
    );

    expect(result.flip, Flip.vertical);
    expect(
        result.rect.floor(), withTolerance(Box.fromLTWH(275, 266, 174, 132)));
    expect(result.resizeMode, ResizeMode.freeform);

    result = BoxTransformer.resize(
      resizeMode: ResizeMode.freeform,
      initialFlip: Flip.vertical,
      initialBox: Box.fromLTWH(275, 266, 174, 132),
      handle: HandlePosition.top,
      initialLocalPosition: Vector2(77, 13),
      flipRect: true,
      localPosition: Vector2(49, 549),
    );

    expect(result.flip, Flip.none);
    expect(
        result.rect.floor(), withTolerance(Box.fromLTWH(275, 398, 174, 405)));
    expect(result.resizeMode, ResizeMode.freeform);

    result = BoxTransformer.resize(
      resizeMode: ResizeMode.freeform,
      initialFlip: Flip.none,
      initialBox: Box.fromLTWH(275, 398, 174, 405),
      handle: HandlePosition.bottom,
      initialLocalPosition: Vector2(71, 13),
      flipRect: true,
      localPosition: Vector2(66, -257),
    );

    expect(result.flip, Flip.none);
    expect(
        result.rect.floor(), withTolerance(Box.fromLTWH(275, 398, 174, 135)));
    expect(result.resizeMode, ResizeMode.freeform);
  });

  test('Freeform resizing with top handle', () {
    var result = BoxTransformer.resize(
      resizeMode: ResizeMode.freeform,
      initialFlip: Flip.none,
      initialBox: Box.fromLTWH(275, 398, 174, 135),
      handle: HandlePosition.top,
      initialLocalPosition: Vector2(78, 9),
      flipRect: true,
      localPosition: Vector2(94, -307),
    );

    expect(result.flip, Flip.none);
    expect(result.rect.floor(), withTolerance(Box.fromLTWH(275, 81, 174, 452)));
    expect(result.resizeMode, ResizeMode.freeform);

    result = BoxTransformer.resize(
      resizeMode: ResizeMode.freeform,
      initialFlip: Flip.none,
      initialBox: Box.fromLTWH(275, 81, 174, 452),
      handle: HandlePosition.top,
      initialLocalPosition: Vector2(82, 14),
      flipRect: true,
      localPosition: Vector2(78, 317),
    );

    expect(result.flip, Flip.none);
    expect(
        result.rect.floor(), withTolerance(Box.fromLTWH(275, 384, 174, 149)));
    expect(result.resizeMode, ResizeMode.freeform);

    result = BoxTransformer.resize(
      resizeMode: ResizeMode.freeform,
      initialFlip: Flip.none,
      initialBox: Box.fromLTWH(275, 384, 174, 149),
      handle: HandlePosition.top,
      initialLocalPosition: Vector2(82, 11),
      flipRect: true,
      localPosition: Vector2(78, 276),
    );

    expect(result.flip, Flip.vertical);
    expect(
        result.rect.floor(), withTolerance(Box.fromLTWH(275, 533, 174, 116)));
    expect(result.resizeMode, ResizeMode.freeform);

    result = BoxTransformer.resize(
      resizeMode: ResizeMode.freeform,
      initialFlip: Flip.vertical,
      initialBox: Box.fromLTWH(275, 533, 174, 116),
      handle: HandlePosition.bottom,
      initialLocalPosition: Vector2(78, 11),
      flipRect: true,
      localPosition: Vector2(74, 258),
    );

    expect(result.flip, Flip.vertical);
    expect(
        result.rect.floor(), withTolerance(Box.fromLTWH(275, 533, 174, 363)));
    expect(result.resizeMode, ResizeMode.freeform);

    result = BoxTransformer.resize(
      resizeMode: ResizeMode.freeform,
      initialFlip: Flip.vertical,
      initialBox: Box.fromLTWH(275, 533, 174, 363),
      handle: HandlePosition.bottom,
      initialLocalPosition: Vector2(76, 13),
      flipRect: true,
      localPosition: Vector2(89, -833),
    );

    expect(result.flip, Flip.none);
    expect(result.rect.floor(), withTolerance(Box.fromLTWH(275, 50, 174, 483)));
    expect(result.resizeMode, ResizeMode.freeform);

    result = BoxTransformer.resize(
      resizeMode: ResizeMode.freeform,
      initialFlip: Flip.none,
      initialBox: Box.fromLTWH(275, 50, 174, 483),
      handle: HandlePosition.top,
      initialLocalPosition: Vector2(77, 13),
      flipRect: true,
      localPosition: Vector2(86, 380),
    );

    expect(result.flip, Flip.none);
    expect(
        result.rect.floor(), withTolerance(Box.fromLTWH(275, 417, 174, 116)));
    expect(result.resizeMode, ResizeMode.freeform);
  });
}
