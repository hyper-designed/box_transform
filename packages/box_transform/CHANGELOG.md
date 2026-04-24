## Unreleased

- Add first-class rotation support around a box's center via `Box.rotation` and a new `BoxTransformer.rotate(...)` entry point.
- Add `BindingStrategy` enum: `originalBox` keeps the unrotated logical rect inside the clamp; `boundingBox` keeps the rendered rotated polygon (and therefore its axis-aligned bounding box) fully inside.
- **[BREAKING]** Default `bindingStrategy` flipped from `originalBox` to `boundingBox` on `BoxTransformer.move/resize/rotate`. Pass `BindingStrategy.originalBox` explicitly to restore the previous behavior.
- **[BREAKING]** Removed the list-based LP inspection API: `LinearInequality`, `ProjectionResult`, `buildCornerInequalities`, `buildCenterInequalities`, `projectOntoFeasibleRegion`. These were thin allocating wrappers around the flat-buffer hot path with no `lib/` consumers. Use `IneqBuffer` + `RotatedClampingSolver.buildCornerIneqsInto` / `RotatedClampingSolver.buildSideHandleIneqsInto` / `RotatedClampingSolver.buildCenterIneqsInto` and `FlatProjection` + `RotatedClampingSolver.projectOntoFeasibleRegionFlat` directly. Test inspection helpers live in the package's `test/lp_inspect.dart`.
- **[BREAKING]** Relocated the rotated-clamping LP entry points into the `RotatedClampingSolver` static surface. The four functions are now class-scoped statics; existing callsites must be qualified:
  - `buildCornerIneqsInto(...)` → `RotatedClampingSolver.buildCornerIneqsInto(...)`
  - `buildSideHandleIneqsInto(...)` → `RotatedClampingSolver.buildSideHandleIneqsInto(...)`
  - `buildCenterIneqsInto(...)` → `RotatedClampingSolver.buildCenterIneqsInto(...)`
  - `projectOntoFeasibleRegionFlat(...)` → `RotatedClampingSolver.projectOntoFeasibleRegionFlat(...)`
  The scratch types `IneqBuffer` and `FlatProjection` are unchanged.
- `BoxTransformer.move()`, `.resize()`, `.rotate()` are all rotation-aware. Freeform, scale, symmetric, symmetricScale, side-handle, and force-flip resize paths each honor rotation under both binding strategies.
- Rotation gestures slide-then-freeze: when the requested angle would push the rect outside the clamp, the engine first tries to translate into available slack; if no translation rescues it, the rotation caps at the last feasible angle.
- Force-flip on a rotated rect falls back to natural direction when the flipped state can't fit clamp + constraints. The rect tracks the cursor by clamp-pinning at the natural wall instead of leaking the clamp or freezing.
- Add `feasible` field to `RotateResult` and `ResizeResult`. `false` means the engine could not honor the requested target without leaking; consumers use it to hold the last feasible state instead of snapping back to gesture-start.
- Solver: dedicated rotated-clamping LP with corner-, side-, and center-anchored inequality builders, an L2 projector with 1D fallback at saturation, and a unified violator-priority loop. `FlatProjection` now exposes `feasible` + `worstResidual` so callers can detect cap-exit residuals instead of consuming a leaky best-effort projection.
- Tests: extensive rotated-resize, rotated-move, rotated-flip, side-handle, scale, symmetric, and symmetricScale coverage. New `clamp_invariants_test.dart` asserts engine invariants (clamp containment, side-handle scope, constraint compliance) on recorded playground scenarios.
- **[BREAKING]** All clamp/handle/flip/line-geometry helpers in `lib/src/helpers.dart` are now `static` members of `abstract final class ClampHelpers` instead of top-level functions. Migration is mechanical: prepend `ClampHelpers.` to each call. Renames:
  - `flipRect(...)` → `ClampHelpers.flipRect(...)`
  - `getFlipForRect(...)` → `ClampHelpers.getFlipForRect(...)`
  - `scaledSymmetricClampingRect(...)` → `ClampHelpers.scaledSymmetricClampingRect(...)`
  - `getClosestEdge(...)` → `ClampHelpers.getClosestEdge(...)`
  - `getClampingRectForSideHandle(...)` → `ClampHelpers.getClampingRectForSideHandle(...)`
  - `intersectionBetweenTwoLines(...)` → `ClampHelpers.intersectionBetweenTwoLines(...)`
  - `extendLineToRect(...)` → `ClampHelpers.extendLineToRect(...)`
  - `extendLinePointsToRectPoints(...)` → `ClampHelpers.extendLinePointsToRectPoints(...)`
  - `intersectionBetweenRects(...)` → `ClampHelpers.intersectionBetweenRects(...)`
  - `findLineIntersection(...)` → `ClampHelpers.findLineIntersection(...)`
  - `getAvailableAreaForHandle(...)` → `ClampHelpers.getAvailableAreaForHandle(...)`
  - `getClampingRectForHandle(...)` → `ClampHelpers.getClampingRectForHandle(...)`
  - `getClampingRectForCornerHandle(...)` → `ClampHelpers.getClampingRectForCornerHandle(...)`
  - `constrainAvailableAreaForScaling(...)` → `ClampHelpers.constrainAvailableAreaForScaling(...)`
  - `getMinRectForScaling(...)` → `ClampHelpers.getMinRectForScaling(...)`
  - `isValidRect(...)` → `ClampHelpers.isValidRect(...)`
  - `calculateBoundingRect(...)` → `ClampHelpers.calculateBoundingRect(...)`
  - `rotatePointAround(...)` → `ClampHelpers.rotatePointAround(...)`
  - `worldToUnrotated(...)` → `ClampHelpers.worldToUnrotated(...)`
  - `unrotatedToWorld(...)` → `ClampHelpers.unrotatedToWorld(...)`

## 0.4.4

- Update root pubspec.yaml name from box_transform to melos_box_transform.
- Fix repository & homepage url in pubspec.yaml

## 0.4.3

- Update dependencies & resolve deprecation warnings.
- Fix a bug where terminal resize events triggered on the incorrect axis.

## 0.4.1

- Remove `DoubleExt` from package exports.

## 0.4.0

- Fix stack overflow error when the clamping rect is smaller than the box rect.

## 0.3.0

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

## 0.2.1

- Update license to Apache 2.0.
- Update docs and fix broken links.

## 0.2.0

- Fix scaling of rect not matching cursor position.

## 0.1.1

- Add example.

## 0.1.0

- Initial release.
