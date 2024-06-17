# Change Log

All notable changes to this project will be documented in this file.
See [Conventional Commits](https://conventionalcommits.org) for commit guidelines.

## 2024-06-17

---

Packages with breaking changes:

- There are no breaking changes in this release.

Packages with other changes:

- [`flutter_box_transform` - `v0.4.4`](#flutter_box_transform---v044)
- [`box_transform` - `v0.4.4`](#box_transform---v044)

---

#### `flutter_box_transform` - `v0.4.4`

- Update root pubspec.yaml name from box_transform to melos_box_transform.
- Fix repository & homepage url in pubspec.yaml

#### `box_transform` - `v0.4.4`

- Update root pubspec.yaml name from box_transform to melos_box_transform.
- Fix repository & homepage url in pubspec.yaml

## 2024-06-17

---

Packages with breaking changes:

- There are no breaking changes in this release.

Packages with other changes:

- [`flutter_box_transform` - `v0.4.3`](#flutter_box_transform---v043)
- [`box_transform` - `v0.4.3`](#box_transform---v043)

---

#### `flutter_box_transform` - `v0.4.3`

- Update dependencies & resolve deprecation warnings.
- Added onTap event to BoxTransformController. (PR #23 by @joakimunge)
- Deny different transform operations when a box is already undergoing.
- Add optional `resizeModeResolver` override to `onResizeUpdate` in `TransformableBoxController`.

#### `box_transform` - `v0.4.3`

- Update dependencies & resolve deprecation warnings.
- Fix a bug where terminal resize events triggered on the incorrect axis.

## 2023-06-07

### Changes

---

Packages with breaking changes:

- There are no breaking changes in this release.

Packages with other changes:

- [`flutter_box_transform` - `v0.4.2`](#flutter_box_transform---v042)

---

#### `flutter_box_transform` - `v0.4.2`

- Fix an issue where visibleHandles disabled the handles instead of hiding them but keeping them enabled.

## 2023-06-06

### Changes

---

Packages with breaking changes:

- There are no breaking changes in this release.

Packages with other changes:

- [`box_transform` - `v0.4.1`](#box_transform---v041)
- [`flutter_box_transform` - `v0.4.1`](#flutter_box_transform---v041)

---

#### `box_transform` - `v0.4.1`

- Remove `DoubleExt` from package exports.

#### `flutter_box_transform` - `v0.4.1`

- Deny trackpad pointer devices to prevent erratic drag events when interacting with TransformableBox.
- Inherit `handleAlignment` from `TransformableBox` for `AngularHandle`.
- Add `debugPaintHandleBounds` param for painting handle bounds.

## 2023-06-04

### Changes

---

Packages with breaking changes:

- [`box_transform` - `v0.4.0`](#box_transform---v040)
- [`flutter_box_transform` - `v0.4.0`](#flutter_box_transform---v040)

Packages with other changes:

- There are no breaking changes in this release.

---

#### `box_transform` - `v0.4.0`

- Fix stack overflow error when the clamping rect is smaller than the box rect.

#### `flutter_box_transform` - `v0.4.0`

- [BREAKING]: Replace `hideHandlesWhenNotResizable` with `enabledHandles` and `visibleHandles`.
- Replace the usage of Listener widgets with GestureDetectors in the TransformableBox.
- Add new controls to the playground to reflect the new handle parameters.
- Bump up **box_transform** version to `0.4.0`.

## 2023-06-02

### Changes

---

Packages with breaking changes:

- There are no breaking changes in this release.

Packages with other changes:

- [`flutter_box_transform` - `v0.3.2`](#flutter_box_transform---v030)

---

#### `flutter_box_transform` - `v0.3.2`

- Fix controller pattern not updating the UI when the controller is updated.
- Change null resizeModeResolver pattern to a non-null pattern to fix a crash.
- Correct two broken doc pages.

## 2023-06-01

### Changes

---

Packages with breaking changes:

- There are no breaking changes in this release.

Packages with other changes:

- [`flutter_box_transform` - `v0.3.1`](#flutter_box_transform---v030)

---

#### `flutter_box_transform` - `v0.3.1`

- Bump up box_transform version to `0.3.0`.

## 2023-06-01

### Changes

---

Packages with breaking changes:

- [`box_transform` - `v0.3.0`](#box_transform---v030)
- [`flutter_box_transform` - `v0.3.0`](#flutter_box_transform---v030)

Packages with other changes:

- There are no breaking changes in this release.

---

#### `box_transform` - `v0.3.0`

- Refactored the core logic to make it more readable, cleaner and easier to maintain.
- Fix issues with resizing, constraints, clamping and flipping.
- [BREAKING]: Replace `flipRect` with `allowFlipping`.
- [BREAKING]: Rename `initialBox` to `initialRect` in `BoxTransformer.move` and `BoxTransformer.resize` methods.
- `ResizeResult` now exposes `laregest` rect and `handle` used.
- Refactored code and performed some cleanup.
- Bump up Dart sdk constraints to `3.0.0`.
- Update all documentation to reflect the new changes.
- Fix broken links in docs.
- Add tests for resizing features.

#### `flutter_box_transform` - `v0.3.0`

- Bump up Dart sdk constraints to `3.0.0`.
- Bump up box_transform version to `0.3.0`.
- [BREAKING]: Replace `onResized` with `onResizeUpdate`.
- [BREAKING]: Replace `flipWhileResizing` with `allowFlippingWhileResizing`.
- [BREAKING]: Replace `onMoved` with `onDragUpdate`.
- [BREAKING]: Rename `resolveResizeModeCallback` to `resizeModeResolver`.
- [BREAKING]: `onChanged` callback now has two parameters: `UITransformResult` and `PointerMoveEvent`.
- [BREAKING]: `onTerminalSizeReached` callback now also exposes underlying `PointerEvent`.
- Add `onResizeStart` and `onResizeEnd` callbacks.
- Add `onDragStart` and `onDragEnd` callbacks for move operation.
- Add simple example alongside an advanced playground example.

## 2023-04-07

### Changes

---

Packages with breaking changes:

- There are no breaking changes in this release.

Packages with other changes:

- [`box_transform` - `v0.2.1`](#box_transform---v021)
- [`flutter_box_transform` - `v0.2.1`](#flutter_box_transform---v021)

---

#### `box_transform` - `v0.2.1`

- Update license to Apache 2.0.
- Update docs and fix broken links.

#### `flutter_box_transform` - `v0.2.1`

- Update license to Apache 2.0.
- Update playground to use unified clamping rect.
- Update docs and fix broken links.

## 2023-04-07

### Changes

---

Packages with breaking changes:

- [`flutter_box_transform` - `v0.2.0`](#flutter_box_transform---v020)

Packages with other changes:

- [`box_transform` - `v0.2.0`](#box_transform---v020)

---

#### `box_transform` - `v0.2.0`

- Fix scaling of rect not matching cursor position.

#### `flutter_box_transform` - `v0.2.0`

- Add `hideHandlesWhenNotResizable` flag to hide handles when the box is not
  resizable by @timmaffett.
- BREAKING CHANGE: `TransformableBox.childBuilder` is now `TransformableBox.contentBuilder`.
- More advanced example with multiple boxes.

## 2023-04-04

### Changes

---

Packages with breaking changes:

- There are no breaking changes in this release.

Packages with other changes:

- [`box_transform` - `v0.1.1`](#box_transform---v011)
- [`flutter_box_transform` - `v0.1.1`](#flutter_box_transform---v011)

---

#### `box_transform` - `v0.1.1`

- Add example.

#### `flutter_box_transform` - `v0.1.1`

- Bump "flutter_box_transform" to `0.1.1`.

## 2023-04-03

### Changes

---

Packages with breaking changes:

- There are no breaking changes in this release.

Packages with other changes:

- [`box_transform` - `v0.1.0`](#box_transform---v010)
- [`flutter_box_transform` - `v0.1.0`](#flutter_box_transform---v010)

---

#### `box_transform` - `v0.1.0`

- Bump "box_transform" to `0.1.0`.

#### `flutter_box_transform` - `v0.1.0`

- Bump "flutter_box_transform" to `0.1.0`.

