# Change Log

All notable changes to this project will be documented in this file.
See [Conventional Commits](https://conventionalcommits.org) for commit guidelines.

## Unreleased — Rotation support

---

Packages with breaking changes:

- [`box_transform` - `Unreleased`](#box_transform---unreleased): the default `bindingStrategy` on `BoxTransformer.move/resize/rotate` flips from `originalBox` to `boundingBox`. The old behavior is preserved for callers that pass the strategy explicitly. The list-based LP inspection API (`LinearInequality`, `ProjectionResult`, `buildCornerInequalities`, `buildCenterInequalities`, `projectOntoFeasibleRegion`) is removed; production callers go through the flat-buffer hot path (`IneqBuffer` + `*Into` builders + `projectOntoFeasibleRegionFlat`), and tests use a private test helper at `test/lp_inspect.dart`.
- [`flutter_box_transform` - `Unreleased`](#flutter_box_transform---unreleased): the default `bindingStrategy` on `TransformableBox`, `TransformableBoxController`, and `UIBoxTransform.*` flips from `originalBox` to `boundingBox`. Existing apps will see a behavior change at non-zero rotation: the rendered footprint is now the containment surface, not the unrotated logical rect. Top-level rotated-layout helpers (`rotateOffsetAround`, `handleCornerInParent`, `rotatedCornerInWorld`, `anchorInHandle`, `handleTopLeftInWorld`, `sideHandleRectInWorld`, `computeEffectiveContainmentRect`) are relocated as static methods on `RotatedLayout`; the file-private default handle builders are promoted to `HandleBuilders.defaultCorner` / `HandleBuilders.defaultSide`. The top-level `defaultResizeModeResolver()` is relocated to `TransformableBoxController.defaultResizeModeResolver()`.

Packages with other changes:

- [`box_transform` - `Unreleased`](#box_transform---unreleased)
- [`flutter_box_transform` - `Unreleased`](#flutter_box_transform---unreleased)

---

#### `box_transform` - `Unreleased`

- Add first-class rotation support around a box's center via `Box.rotation` and a new `BoxTransformer.rotate(...)` entry point.
- Add `BindingStrategy` enum: `originalBox` keeps the unrotated logical rect inside the clamp; `boundingBox` keeps the rendered rotated polygon (and therefore its axis-aligned bounding box) fully inside.
- **[BREAKING]** Default `bindingStrategy` flipped from `originalBox` to `boundingBox` on `BoxTransformer.move/resize/rotate`. Pass `BindingStrategy.originalBox` explicitly to restore the previous behavior.
- `BoxTransformer.move()`, `.resize()`, `.rotate()` are all rotation-aware. Freeform, scale, symmetric, symmetricScale, side-handle, and force-flip resize paths each honor rotation under both binding strategies.
- Rotation gestures slide-then-freeze: when the requested angle would push the rect outside the clamp, the engine first tries to translate into available slack; if no translation rescues it, the rotation caps at the last feasible angle.
- Force-flip on a rotated rect falls back to natural direction when the flipped state can't fit clamp + constraints. The rect tracks the cursor by clamp-pinning at the natural wall instead of leaking the clamp or freezing.
- Add `feasible` field to `RotateResult` and `ResizeResult`. `false` means the engine could not honor the requested target without leaking; consumers (controllers) use it to hold the last feasible state.
- Solver: dedicated rotated-clamping LP with corner-, side-, and center-anchored inequality builders, an L2 projector with 1D fallback at saturation, and a unified violator-priority loop. `FlatProjection` now exposes `feasible` + `worstResidual`.
- Tests: extensive rotated-resize, rotated-move, rotated-flip, side-handle, scale, symmetric, symmetricScale, and clamp-invariant coverage. New `clamp_invariants_test.dart` asserts engine invariants (clamp containment, side-handle scope, constraint compliance) on recorded playground scenarios.

#### `flutter_box_transform` - `Unreleased`

- **[BREAKING]** Top-level rotated-layout helpers are now static methods on `RotatedLayout` (`rotateOffsetAround`, `handleCornerInParent`, `rotatedCornerInWorld`, `anchorInHandle`, `handleTopLeftInWorld`, `sideHandleRectInWorld`, and `computeEffectiveContainmentRect`). The previous top-level forms are removed.
- **[BREAKING]** Default handle builders moved from file-private functions to public statics on `HandleBuilders` (`HandleBuilders.defaultCorner`, `HandleBuilders.defaultSide`).
- Add `rotation`, `rotatable`, and `bindingStrategy` parameters on `TransformableBox`.
- **[BREAKING]** Default `bindingStrategy` flipped from `originalBox` to `boundingBox` on `TransformableBox`, `TransformableBoxController`, and `UIBoxTransform.move/resize/rotate`. Existing apps that relied on the unrotated-logical-rect semantic must pass `BindingStrategy.originalBox` explicitly.
- Add per-corner rotation gesture: an outer ring around each corner-handle captures rotation when `rotatable: true`. Sized via `rotationHandleGestureSize` (default 64 px). Add rotation callbacks: `onRotationStart` / `onRotationUpdate` / `onRotationEnd` / `onRotationCancel`.
- `TransformableBoxController` adds `rotation`, `initialRotation`, `bindingStrategy`, `onRotateStart` / `onRotateUpdate` / `onRotateEnd` / `onRotateCancel`. `onResizeUpdate` and `onRotateUpdate` skip state writes on `result.feasible == false` and override `result.rect`/`result.rotation` to the controller's last feasible value, so consumers binding visible state via callbacks (`box.rect = result.rect`) stay clamp-pinned at the last feasible position rather than snapping back to gesture-start.
- Side handles render rotated under non-zero rotation and translate gesture coordinates into the box's un-rotated frame so resize tracks the cursor visually.
- Hit-testing gates corner taps to the rotated polygon (not the AABB) so rotated boxes don't capture clicks in their AABB wedges.
- Playground gains a rotation slider, `bindingStrategy` toggle, debug overlays for rotated/unrotated bounds, and a tick-by-tick test recorder that captures full gesture sequences (rotation + bindingStrategy aware) for regression replay.
- Tests: rotated controller gestures, rotated layout, rotated drag hit-gating, rotated gesture integration, clamp-shrink continuity under rotation, and a force-flip fallback regression test.
- **[BREAKING]** `defaultResizeModeResolver()` is now `TransformableBoxController.defaultResizeModeResolver()`. The top-level function has been removed; consumers that referenced it directly (e.g. as a default for `resizeModeResolver`) must update to the qualified static.

## 2025-03-26

---

Packages with changes:

- [`flutter_box_transform` - `v0.4.7`](#flutter_box_transform---v047)

#### `flutter_box_transform` - `v0.4.7`

- Fix taps should pass through when onTap is not set. [Issue#31](https://github.com/hyper-designed/box_transform/issues/31)

## 2024-09-14

---

Packages with changes:

- [`flutter_box_transform` - `v0.4.6`](#flutter_box_transform---v046)

#### `flutter_box_transform` - `v0.4.6`

- Fix child positioning offset bug. [Issue#27](https://github.com/hyper-designed/box_transform/issues/27)

## 2024-08-12

---

Packages with changes:

- [`flutter_box_transform` - `v0.4.5`](#flutter_box_transform---v045)

#### `flutter_box_transform` - `v0.4.5`

- Add parameters for supported devices. (PR #28 by @Gold872).
- Upgrade dependencies.

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

