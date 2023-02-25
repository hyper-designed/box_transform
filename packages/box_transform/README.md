# Box Transform
Box Transform is a pure-Dart base package that allows you to programmatically handle box resizing and dragging without
relying on Flutter. It provides highly flexible, programmatically resizable and draggable boxes that can be used in any
Dart project.

Detailed documentation: [https://docs.page/birjuvachhani/rect_resizer](https://docs.page/birjuvachhani/rect_resizer)

## Features

* 📏 Dimension Constraining: Set maximum and minimum constraints to keep boxes within specific boundaries while resizing.
* 🔁 Flipping Mechanics: Advanced positional-flipping when resizing hits extreme values with hard constraints.
* 🔒 Drag Clamping: Clamp boxes inside a parent box to contain them within a specific area.
* 🎨 Flexible Resizing Modes: Choose from four different resizing modes for more flexibility in how boxes are resized.
* 📍 Customizable Anchor Points: Define resizing corner-handles to anchor different parts of the box when resizing.
* 🚀 Easy Integration: Integrate Box Transform into your project with ease using stateless and static functions.

## Getting started

Box Transform offers a `resizer.dart` class that holds functions that take initial box states
and returns new box states with the desired actions.

Since this is a pure-Dart package, it offers a `Box` (as opposed to a `Rect`) class that holds
an x, y, width, and height. You will want to start by making a new `Box` as your initial point
of reference.

The `Box` class is very similar to Flutter's `Rect`, therefore you can easily reference the
Flutter documentation for implementation details.

```dart
import 'package:rect_resizer/rect_resizer.dart';

void main() {
  final box = Box.fromLTWH(0, 0, 100, 100);
}
```

## Resizing a Box

```dart
import 'package:rect_resizer/rect_resizer.dart';

void main() {
  Box box = Box.fromLTWH(0, 0, 100, 100);

  final ResizeResult result = RectResizer.resize(
    handle: HandlePosition.bottomRight,
    initialRect: box,
    initialLocalPosition: Vector2(100, 100),
    localPosition: Vector2(110, 120),
    resizeMode: ResizeMode.freeform,
    initialFlip: Flip.none,
  );

  // A new box instance is returned, but resized.
  box = result.newRect;
  flip = result.flip;

}
```

## Moving a Box

```dart
import 'package:rect_resizer/rect_resizer.dart';

void main() {
  Box box = Box.fromLTWH(0, 0, 100, 100);

  final MoveResult result = RectResizer.move(
    initialRect: box,
    initialLocalPosition: Vector2(50, 50),
    localPosition: Vector2(60, 50),
  );

  // A new box instance is returned, but moved 10px to the right.
  box = result.newRect;
}
```

## Additional information

For more detailed documentation, please visit the [documentation page](https://docs.page/birjuvachhani/rect_resizer) or
check our tests for complete usage coverage.

## Contributing

If you have any suggestions or find any bugs, please feel free to open an issue or a pull request.
