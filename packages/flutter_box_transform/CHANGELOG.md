## 0.3.2

- Fix controller pattern not updating the UI when the controller is updated.
- Change null resizeModeResolver pattern to a non-null pattern to fix a crash.
- Correct two broken doc pages.

## 0.3.1

- Bump up box_transform version to 0.3.0.

## 0.3.0

- Bump up Dart sdk constraints to `3.0.0`.
- [BREAKING]: Replace `onResized` with `onResizeUpdate`.
- [BREAKING]: Replace `flipWhileResizing` with `allowFlippingWhileResizing`.
- [BREAKING]: Replace `onMoved` with `onDragUpdate`.
- [BREAKING]: Rename `resolveResizeModeCallback` to `resizeModeResolver`.
- [BREAKING]: `onChanged` callback now has two parameters: `UITransformResult` and `PointerMoveEvent`.
- [BREAKING]: `onTerminalSizeReached` callback now also exposes underlying `PointerEvent`.
- Add `onResizeStart` and `onResizeEnd` callbacks.
- Add `onDragStart` and `onDragEnd` callbacks for move operation.
- Add simple example alongside an advanced playground example.

## 0.2.1

- Update license to Apache 2.0.
- Update playground to use unified clamping rect.
- Update docs and fix broken links.

## 0.2.0

- Add `hideHandlesWhenNotResizable` flag to hide handles when the box is not
  resizable by @timmaffett.
- BREAKING CHANGE: `TransformableBox.childBuilder` is now `TransformableBox.contentBuilder`.
- More advanced example with multiple boxes.

## 0.1.1

 - Bump "flutter_box_transform" to `0.1.1`.

## 0.1.0

- Initial release.
