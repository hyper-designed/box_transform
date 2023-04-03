
## Resizing a Box

```dart
final Box rect = Box.fromLTWH(50, 50, 100, 100);
  
  final ResizeResult result = BoxTransformer.resize(
    handle: HandlePosition.bottomRight, // handle that is being dragged
    initialRect: rect,
    initialLocalPosition: Vector2.zero(),
    localPosition: Vector2.zero(),
    resizeMode: ResizeMode.freeform,
    initialFlip: Flip.none,
  );
  
  result.rect; // the new rect
```

## Moving a box.

```dart title="Moving a box"
  final Box rect = Box.fromLTWH(50, 50, 100, 100);
  final MoveResult result = BoxTransformer.move(
    initialRect: rect,
    initialLocalPosition: Vector2.zero(),
    localPosition: Vector2.zero(),
  );
  
  result.position; // the new position of the box
```