/// A pure Dart implementation of advanced 2D box transformation.
///
/// Provides primitives for moving, resizing, scaling, flipping, and rotating
/// rectangles, with support for clamping rects, constraints, and binding
/// strategies for rotated boxes.
library;

export 'src/enums.dart';
export 'src/extensions.dart' hide DoubleExt;
export 'src/geometry.dart';
export 'src/helpers.dart';
export 'src/result.dart';
export 'src/rotated_clamping_solver.dart';
export 'src/transformer.dart';
