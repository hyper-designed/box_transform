## Unreleased

- **[BREAKING]** `defaultResizeModeResolver()` is now `TransformableBoxController.defaultResizeModeResolver()`. The top-level function has been removed; consumers that referenced it directly (e.g. as a default for `resizeModeResolver`) must update to the qualified static.
- **[BREAKING]** Top-level rotated-layout helpers are now static methods on `RotatedLayout`:
  - `rotateOffsetAround(...)` → `RotatedLayout.rotateOffsetAround(...)`
  - `handleCornerInParent(...)` → `RotatedLayout.handleCornerInParent(...)`
  - `rotatedCornerInWorld(...)` → `RotatedLayout.rotatedCornerInWorld(...)`
  - `anchorInHandle(...)` → `RotatedLayout.anchorInHandle(...)`
  - `handleTopLeftInWorld(...)` → `RotatedLayout.handleTopLeftInWorld(...)`
  - `sideHandleRectInWorld(...)` → `RotatedLayout.sideHandleRectInWorld(...)`
  - `computeEffectiveContainmentRect(...)` (formerly in `extensions.dart`) → `RotatedLayout.computeEffectiveContainmentRect(...)`
- **[BREAKING]** Default handle builders moved from file-private functions to public statics on `HandleBuilders`. Use `HandleBuilders.defaultCorner` / `HandleBuilders.defaultSide` if you need to reference them explicitly.
- Add `rotation`, `rotatable`, and `bindingStrategy` parameters on `TransformableBox`.
- **[BREAKING]** Default `bindingStrategy` flipped from `originalBox` to `boundingBox` on `TransformableBox`, `TransformableBoxController`, and `UIBoxTransform.move/resize/rotate`. Existing apps that relied on the unrotated-logical-rect semantic must pass `BindingStrategy.originalBox` explicitly.
- Add per-corner rotation gesture: an outer ring around each corner-handle captures rotation when `rotatable: true`. Size via `rotationHandleGestureSize` (default 64 px). New rotation callbacks: `onRotationStart` / `onRotationUpdate` / `onRotationEnd` / `onRotationCancel`.
- `TransformableBoxController` adds `rotation`, `initialRotation`, `bindingStrategy`, and rotation lifecycle methods (`onRotateStart` / `onRotateUpdate` / `onRotateEnd` / `onRotateCancel`).
- `onResizeUpdate` and `onRotateUpdate` skip state writes when `result.feasible == false` and override `result.rect` / `result.rotation` to the controller's last feasible value. Consumers binding their visible state via callbacks (`box.rect = result.rect`) now stay clamp-pinned at the last feasible position rather than snapping back to gesture-start when a gesture exceeds what clamp + constraints permit.
- Side handles render rotated under non-zero rotation; gesture coordinates are translated into the box's un-rotated frame so resize tracks the cursor visually.
- Hit-testing gates corner taps to the rotated polygon (not the AABB) so rotated boxes don't capture clicks in their AABB wedges.
- Playground gains a rotation slider, a `bindingStrategy` toggle, debug overlays for rotated/unrotated bounds, and a tick-by-tick test recorder that captures full gesture sequences (rotation + bindingStrategy aware) for regression replay.
- Bumps `box_transform` dependency to the rotation-aware release.
- **[BREAKING]** The rotated-clamping LP entry points re-exported from `box_transform` were relocated into `RotatedClampingSolver` (static surface). Apps that called these directly must qualify the names:
  - `buildCornerIneqsInto(...)` → `RotatedClampingSolver.buildCornerIneqsInto(...)`
  - `buildSideHandleIneqsInto(...)` → `RotatedClampingSolver.buildSideHandleIneqsInto(...)`
  - `buildCenterIneqsInto(...)` → `RotatedClampingSolver.buildCenterIneqsInto(...)`
  - `projectOntoFeasibleRegionFlat(...)` → `RotatedClampingSolver.projectOntoFeasibleRegionFlat(...)`
- **[BREAKING]** Re-exported clamp/handle/flip/line-geometry helpers from `box_transform` are now `static` members of `ClampHelpers` instead of top-level functions. See the `box_transform` CHANGELOG for the full rename list. Migration is mechanical: prepend `ClampHelpers.` to each call (e.g. `flipRect(...)` → `ClampHelpers.flipRect(...)`).

## 0.4.7
- Fix taps should pass through when onTap is not set. [Issue#31](https://github.com/hyper-designed/box_transform/issues/31)

## 0.4.6

- Fix child positioning offset bug. [Issue#27](https://github.com/hyper-designed/box_transform/issues/27)

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
