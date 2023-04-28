import 'package:box_transform/box_transform.dart';
import 'package:test/test.dart';

class BoxMatcher extends Matcher {
  BoxMatcher(this.box, {this.tolerance = 1});

  final Box box;

  final double tolerance;

  @override
  bool matches(dynamic item, Map matchState) {
    if (item is! Box) return false;
    final Box other = item;
    return (box.left - other.left).abs() <= tolerance &&
        (box.top - other.top).abs() <= tolerance &&
        (box.width - other.width).abs() <= tolerance &&
        (box.height - other.height).abs() <= tolerance;
  }

  @override
  Description describe(Description description) {
    return description.add('Box:<$box>');
  }
}

Matcher withTolerance(dynamic item, {double tolerance = 1}) {
  if (item is Box) return BoxMatcher(item, tolerance: tolerance);
  return equals(item);
}
