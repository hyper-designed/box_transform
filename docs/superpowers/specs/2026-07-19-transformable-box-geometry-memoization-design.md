# TransformableBox Geometry Memoization — Design

**Date:** 2026-07-19
**Status:** Approved (design), pending implementation plan
**Scope:** `packages/flutter_box_transform/lib/src/transformable_box.dart`

## Problem

`_TransformableBoxState.build()` recomputes the full handle/paint geometry on
every call: the paint-rect union, per-corner world anchors (each via
`RotatedLayout.handleTopLeftInWorld`, which evaluates `cos`/`sin`), side-strip
rects and rotated centers, and the top-rotation-handle center/top-left/line
anchor. All of it is a **pure function** of the controller's `rect` /
`rotation` / `boundingRect` and a fixed set of static widget config values.

`build()` runs on more than just relevant state changes. `onControllerUpdate`
already guards `setState` to relevant controller fields, but Flutter still calls
`build()` on any ancestor rebuild — parent `setState`, `InheritedWidget` /
`MediaQuery` / theme changes. On those, none of the geometry inputs have
changed, yet every value is recomputed from scratch.

## Goal

Memoize the geometry computation so it recomputes **only when its inputs
actually change**. Scope is deliberately limited to the geometry math — widget
construction (the `Stack` of `Positioned` + `GestureDetector` + handle widgets)
is unchanged. No widget-subtree splitting, no `RepaintBoundary`.

## Approach: compute-and-compare in `build()`

Chosen over invalidate-on-change (dirtying a cache flag in `didUpdateWidget` /
`onControllerUpdate`) because:

- The hottest geometry inputs (`rect`, `rotation`, `boundingRect`) change
  through the **controller** during live gestures — the path is
  `controller mutate → notifyListeners → onControllerUpdate → setState →
  build`, which never fires `didUpdateWidget`. Invalidate-on-change is only
  correct if it dirties the cache in *both* `didUpdateWidget` and
  `onControllerUpdate`, enumerating every input in each with no enforcement
  they stay in sync with what the compute step reads. `onControllerUpdate`'s
  existing comparisons don't even track `boundingRect`, which `paintRect`
  depends on — a latent stale-layout gap.
- Compute-and-compare is correct regardless of which path triggered `build()`.
  Its per-build cost is one record `==` over the input list — negligible next
  to the trig it guards.

## Design

### 1. `_TransformableBoxLayout` — immutable geometry value object

A private class in `transformable_box.dart` holding every geometry output that
`build()` currently derives:

- `Offset origin`
- `Rect paintRect`
- `double outerHandleSize`
- `double rotationHandleSize`
- corner anchors:
  `Map<HandlePosition, ({Offset outer, Offset inner})>` (four corners)
- side strips:
  `Map<HandlePosition, ({Rect sideRect, Offset stripCenter, Size stripSize, Offset topLeft})>`
  (four sides)
- top rotation handle (nullable, present only when the top-handle mode is
  active): `Offset? topCenter`, `Offset? topTopLeft`, `Rect? topRect`,
  `Offset? topLineAnchor`

It exposes:

```dart
static _TransformableBoxLayout compute({
  required Rect rect,
  required double rotation,
  required Rect boundingRect,
  required double handleTapSize,
  required double rotationHandleGestureSize,
  required bool rotatable,
  required RotationHandleMode rotationHandleMode,
  required double rotationHandleOffset,
  required HandleAlignment handleAlignment,
})
```

**Invariant:** `compute()` reads *only* its parameters — never `widget` or
`controller` directly. This makes it impossible for a geometry input to exist
outside the key: adding an input forces a new parameter, which forces a new
key field (below). The body is a mechanical move of the existing geometry
lines out of `build()`, corner/side loops included.

`useCornerRotationRing` and `useTopRotationHandle` are derived *inside*
`compute()` from `rotatable` + `rotationHandleMode`, exactly as `build()` does
today.

### 2. Memo key

A Dart record mirroring `compute()`'s parameters, in the same order:

```dart
(rect, rotation, boundingRect, handleTapSize, rotationHandleGestureSize,
 rotatable, rotationHandleMode, rotationHandleOffset, handleAlignment)
```

Every field has structural equality (`Rect`, `double`, `bool`, and the two
enums), so the record's `==` is a correct, allocation-cheap validity check.

**Excluded inputs and why:**

- `flip` — never affects geometry; it only drives the content's
  `Transform.scale`. Excluding it means a flip-only change reuses cached
  geometry. `build()` continues to read `controller.flip` live for
  `visualContent`.
- `resizable` / `visibleHandles` / `enabledHandles` — gate whether handle
  *widgets* are built, not the geometry values. `build()` keeps applying them
  when constructing widgets from the (always-computed) layout.
- Debug-overlay state (`initialLocalPosition`, `_rotationArrowPointer`,
  `debugShow*`) — overlays are rebuilt live outside the memo.

### 3. State wiring

Two new fields on `_TransformableBoxState`:

```dart
Object? _lastLayoutKey;
_TransformableBoxLayout? _cachedLayout;
```

`build()` opens by assembling the key, refreshing the cache on mismatch, then
reading all positions from `layout.*`:

```dart
final layoutKey = (/* the 9 inputs above */);
if (layoutKey != _lastLayoutKey || _cachedLayout == null) {
  _lastLayoutKey = layoutKey;
  _cachedLayout = _TransformableBoxLayout.compute(/* same inputs */);
}
final layout = _cachedLayout!;
```

The widget-building portion of `build()` (Stack/Positioned/handles/overlays)
is rewritten to source geometry from `layout` instead of local recomputation,
with no structural change to the emitted tree.

## Correctness / risk

- **No missed invalidation:** the key is compared live every `build()`, so any
  input change — via gesture, `didUpdateWidget`, or a bare `InheritedWidget`
  rebuild — is caught. The compute-reads-only-params invariant guarantees the
  key covers every input.
- **Behavioral parity:** this is a pure extract-and-cache. The emitted widget
  tree must be byte-for-byte identical to the current output for equal inputs.
  Existing widget tests over `TransformableBox` (handles, rotation, drag,
  clamping) are the regression net; they must stay green with no changes.

## Out of scope

- Splitting handles into separately-rebuilding child widgets.
- `RepaintBoundary` / paint-level optimization.
- Any change to `RotatedLayout`, the controller, or gesture handlers.
