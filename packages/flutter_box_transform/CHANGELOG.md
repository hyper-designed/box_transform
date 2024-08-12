## 0.4.5

- Add parameters for supported devices. (PR #28 by @Gold872).
- Upgrade dependencies.

## 0.4.4

- Update root pubspec.yaml name from box_transform to melos_box_transform.
- Fix repository & homepage url in pubspec.yaml

## 0.4.3

- Update dependencies & resolve deprecation warnings.
- Added onTap event to BoxTransformController. (PR #23 by @joakimunge)
- Deny different transform operations when a box is already undergoing.
- Add optional `resizeModeResolver` override to `onResizeUpdate` in `TransformableBoxController`.

## 0.4.2

- Fix an issue where visibleHandles disabled the handles instead of hiding them but keeping them enabled.

## 0.4.1

- Deny trackpad pointer devices to prevent erratic drag events when interacting with TransformableBox.
- Inherit `handleAlignment` from `TransformableBox` for `AngularHandle`.
- Add `debugPaintHandleBounds` param for painting handle bounds.

## 0.4.0

- [BREAKING]: Replace `hideHandlesWhenNotResizable` with `enabledHandles` and `visibleHandles`.
- Replace the usage of Listener widgets with GestureDetectors in the TransformableBox.
- Add new controls to the playground to reflect the new handle parameters.
- Bump up **box_transform** version to `0.4.0`.

## 0.3.2

- Fix controller pattern not updating the UI when the controller is updated.
- Change null resizeModeResolver pattern to a non-null pattern to fix a crash.
- Correct two broken doc pages.

## 0.3.1

- Bump up **box_transform** version to `0.3.0`.

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
