# BoxBehavior Plugin Architecture — v1.0 Design

**Status:** Approved for implementation planning
**Date:** 2026-04-27
**Branch context:** `rotation` (work happens on a fresh v1.0 branch)
**Breaking:** Yes — major version bump from `0.4.7` to `1.0.0`

---

## 1. Goals & non-goals

### Goals

1. Provide first-class touch UX support — pinch-to-scale, two-finger twist, tap-to-select, stem-mounted rotation handles, dimension readouts — without compromising the existing cursor experience.
2. Make all interaction concerns (visuals, gestures, transform constraints, side effects) **modular and swappable** by third parties.
3. Allow developers to **mix-and-match** patterns: pure-Instagram (touch only, no handles), Figma-like (handles + selection), Procreate-hybrid (handles + body multi-touch), or custom.
4. Configure interaction **per pointer device** — cursor and touch can have completely different behaviors on the same widget.
5. Preserve cursor behavior **byte-equivalent** to v0.4.7 when using the default `BoxBehaviorConfig.classic()` config.
6. Support snap, magnet, grid, and angle-snap as composable transform middleware.
7. Provide a **mechanical migration path** via a `dart fix` codemod.

### Non-goals (v1.0)

1. **Engine refactor.** The pure math in `ui_box_transform.dart` is left untouched in v1.0. Constraint logic stays inside the engine. Constraint application as a user-orderable policy is deferred to v1.x.
2. **Multi-object scene management.** This package owns one box. Selection coordination across multiple boxes is a caller concern.
3. **Stable third-party `BodyBehavior` contract.** The body coalition's recognizer-coalescing rules are a Flutter sharp edge; the `BodyBehavior` subclass contract is shipped `@experimental` in v1.0. Built-in `BodyDrag` and `BodyTransform` are stable.
4. **Custom recognizers beyond Pan/Scale/Tap/LongPress/DoubleTap.** Authors who need other recognizer types can write a `HandleBehavior` (with full `RawGestureDetector` control inside its own widget tree); body-coalition is restricted to the recognizer kinds we coalesce explicitly.
5. **Stream-based event API on the controller.** Typed events flow internally to `ObserverBehavior.onControllerEvent` callbacks. External code observes events by writing an `ObserverBehavior`.

---

## 2. Architecture overview

Three layers, each with one responsibility:

```
┌──────────────────────────────────────────────────────────────────┐
│  TransformableBox (widget)                                       │
│  Owns: render tree, hit-test layout, recognizer coalescing       │
│  Reads: BoxBehaviorConfig, controller                            │
└──────────────────────────────────────────────────────────────────┘
                ▲                                ▲
                │ behaviors                      │ controller
                │                                │
┌───────────────────────────────┐   ┌────────────────────────────────┐
│  Layer 1: BoxBehaviors        │   │  Layer 3: TransformableBox-    │
│  HandleBehavior               │   │           Controller (Listen.)│
│  BodyBehavior                 │   │  Owns: rect, rotation, flip,  │
│  ObserverBehavior             │   │        event stream           │
│  OverlayBehavior              │   │  Runs: policy chain on every  │
│                               │   │        delta before applying  │
│  Live in widget tree          │   │  Emits: typed events to       │
│  React to pointers, paint UI  │   │         observers/overlays    │
└───────────────────────────────┘   └────────────────────────────────┘
                                                ▲
                                                │ policies
                                                │
                                ┌─────────────────────────────────────┐
                                │  Layer 2: TransformPolicies         │
                                │  apply(TransformInput) → Output     │
                                │                                      │
                                │  Pure middleware on delta path      │
                                │  Snap, magnet, grid, angle-snap,    │
                                │  user-defined transforms             │
                                └─────────────────────────────────────┘
```

### Data flow on a single user gesture

1. Pointer hits widget → routed by spatial hit-test to the right zone (handle vs body).
2. The owning `HandleBehavior` (its own `GestureDetector`/`RawGestureDetector`) OR the body-coalition `RawGestureDetector` (composed from all active `BodyBehavior` recognizer factories) processes the gesture.
3. The behavior calls `controller.proposeResize*` / `proposeDrag*` / `proposeRotate*` / `proposeScale*`.
4. Controller runs **engine math (untouched)** producing a constraint-respecting proposed rect.
5. Controller runs the **user policy chain** in order; each policy sees the previous output.
6. Controller does a **safety re-clamp** (existing engine helper) catching any policy-induced violations.
7. Controller applies the final state, emits `TransformAppliedEvent` carrying the adjustments list.
8. `OverlayBehavior`s and `ObserverBehavior`s react (paint guides, fire haptics, log analytics).

### Critical guarantees

- Cursor behavior is byte-equivalent to v0.4.7 when `BoxBehaviorConfig.classic()` (the default) is used. The widget tree the user sees is identical; the existing test suite passes unmodified.
- Spatial-priority "bleed-out" still works for handle-shaped behaviors via the same Padding/inner-zone trick the package uses today. Each `HandleBehavior` owns its painted+gesture widget; Flutter's hit-test routing gives inner-overshadows-outer for free.
- Body-region multi-touch is exactly **one** `RawGestureDetector` whose recognizer team is the union of all active `BodyBehavior`s' recognizer factories — no arena fights, no surprise.

---

## 3. `BoxBehavior` contracts

### Base type

```dart
abstract class BoxBehavior {
  Set<PointerDeviceKind>? get devices; // null = all devices
  Object get behaviorKey => runtimeType;

  void attach(BoxBehaviorBindings bindings) {}
  void detach() {}
}
```

### `HandleBehavior` — visual + own gesture, spatial priority

```dart
abstract class HandleBehavior extends BoxBehavior {
  Anchor get anchor;
  Widget build(BuildContext context, HandleBuildContext ctx, BoxBehaviorBindings bindings);
}

class HandleBuildContext {
  final Rect boxRect;
  final double rotation;
  final bool selected;
  final bool hovered;
  final bool pressed;
  final HandleAlignment alignment;
  final double tapSize;
  final double visualSize;
}
```

#### Anchor

Open contract replacing the closed `HandlePosition` enum:

```dart
sealed class Anchor {
  Offset computeWorld(Rect rect, double rotation, Size handleSize, HandleAlignment alignment);

  const factory Anchor.corner(Corner c) = CornerAnchor;
  const factory Anchor.side(Side s) = SideAnchor;
  const factory Anchor.edgeStem({required Side from, required double distance}) = EdgeStemAnchor;
  const factory Anchor.custom(AnchorComputer compute) = CustomAnchor;
}
```

**TODO (v1.x):** richer anchors (content-aware pivots, anchored to bounding rect vs. unrotated rect). `HandleAlignment.center` callsites currently hardcoded throughout `RotatedLayout` and `CornerHandleWidget` are threaded through `HandleBuildContext.alignment` in v1.0.

#### Built-in handle helpers

Two shipped widget helpers encapsulate the gesture-detector boilerplate:

- `HandleHitFrame.simple({tapSize, visualSize, child, onPan, ...})` — current default corner/side handle
- `HandleHitFrame.withOuterRing({innerTapSize, outerTapSize, innerChild, onInnerPan, onOuterPan, ...})` — current rotatable corner with outer ring

Handle authors return one of these from their `build()` method instead of building raw `Stack`s.

### `BodyBehavior` — recognizer factories, body coalition

```dart
abstract class BodyBehavior extends BoxBehavior {
  List<RecognizerInterest> recognizers(BoxBehaviorBindings bindings);

  /// Pre-flight veto. Called per pointer-down before the body coalition's
  /// RawGestureDetector enters the gesture arena. The coalition claims the
  /// pointer if ANY active body behavior returns true; declines if ALL
  /// active body behaviors return false. Default: true (always claim).
  bool shouldClaim(PointerEvent down, BoxBehaviorBindings bindings) => true;
}
```

#### `RecognizerInterest` (sealed type hierarchy)

```dart
sealed class RecognizerInterest {}

class ScaleInterest extends RecognizerInterest {
  final ScaleContribution Function(ScaleStartDetails)? onStart;
  final ScaleContribution Function(ScaleUpdateDetails)? onUpdate;
  final ScaleContribution Function(ScaleEndDetails)? onEnd;
  const ScaleInterest({this.onStart, this.onUpdate, this.onEnd});
}

class PanInterest extends RecognizerInterest {
  final void Function(DragStartDetails)? onStart;
  final void Function(DragUpdateDetails)? onUpdate;
  final void Function(DragEndDetails)? onEnd;
  const PanInterest({this.onStart, this.onUpdate, this.onEnd});
}

class TapInterest extends RecognizerInterest { /* onTapDown, onTapUp, onTap, onTapCancel */ }
class LongPressInterest extends RecognizerInterest { /* onStart, onMoveUpdate, onEnd */ }
class DoubleTapInterest extends RecognizerInterest { /* onDoubleTap */ }
```

#### `ScaleContribution`

```dart
class ScaleContribution {
  final Offset? focalDelta;
  final double? scaleDelta;
  final double? rotationDelta;
  static const ScaleContribution none = ScaleContribution();

  ScaleContribution merge(ScaleContribution other) { /* sum each non-null axis */ }
}
```

Body-coalition merges per-frame contributions from all `ScaleInterest`s into ONE controller call. ONE engine pass, ONE policy chain run, ONE notification per frame.

#### Pan/Scale conflict — caught at construction

```dart
// In BoxBehaviorConfig constructor:
for (final device in allDevices) {
  final behaviors = activeForDevice(device);
  final hasPan = behaviors.any((b) => b is BodyBehavior && b.usesPanRecognizer);
  final hasScale = behaviors.any((b) => b is BodyBehavior && b.usesScaleRecognizer);
  assert(
    !(hasPan && hasScale),
    'Cannot mix BodyDrag (Pan) and BodyTransform (Scale) on $device — '
    'Flutter\'s gesture arena does not allow both. Pick one.',
  );
}
```

### `ObserverBehavior` — passive watcher, never claims

```dart
abstract class ObserverBehavior extends BoxBehavior {
  void onPointerEvent(PointerEvent event, BoxBehaviorBindings bindings) {}
  void onControllerEvent(ControllerEvent event, BoxBehaviorBindings bindings) {}
}
```

Either or both callbacks can be overridden. Pointer feed comes from a `Listener` at the box root that sees every pointer event before any `GestureDetector`.

### `OverlayBehavior` — pure paint

```dart
abstract class OverlayBehavior extends BoxBehavior {
  OverlayLayer get layer; // belowHandles | aboveHandles
  Widget build(BuildContext context, BoxBehaviorBindings bindings);
}
```

### `BoxBehaviorBindings`

```dart
abstract class BoxBehaviorBindings {
  TransformableBoxController get controller;
  PointerDeviceKind get activeDevice;
  ValueListenable<bool> get isEnabled; // promoted from static bool in v1.0
  ValueListenable<bool> get isHovered;
  Rect get clampingRect;
  TickerProvider get vsync;
  void requestRebuild();
}
```

Behaviors don't see other behaviors directly — they communicate through the controller. This keeps contracts isolated and testable.

### Built-in behaviors (v1.0)

| Class | Type | Notes |
|---|---|---|
| `CornerHandle` | `HandleBehavior` | 4 instances per box; supports optional outer rotation ring (`withRotationRing: true`) |
| `SideHandle` | `HandleBehavior` | 4 instances per box |
| `StemRotationHandle` | `HandleBehavior` | Stem-mounted rotation node anchored at edge midpoint with offset distance |
| `CornerRingRotateHandle` | `HandleBehavior` | Cursor-pattern rotation (outer ring of corner); preserved from v0.4.x semantics |
| `BodyDrag` | `BodyBehavior` | `PanInterest` only; cursor pattern; cannot coexist with `BodyTransform` |
| `BodyTransform` | `BodyBehavior` | `ScaleInterest`; flags `drag`/`pinch`/`twist`; touch pattern; cannot coexist with `BodyDrag` |
| `TapToSelect` | `BodyBehavior` | `TapInterest`; calls caller-provided `onSelectionChanged` callback |
| `HapticOnSnap` | `ObserverBehavior` | listens for `TransformAppliedEvent` with `SnapAdjustment`; fires `HapticFeedback.selectionClick()` |
| `SnapGuidesOverlay` | `OverlayBehavior` | reads `controller.lastAppliedTransform.adjustments`; paints guide lines |
| `DimensionReadout` | `OverlayBehavior` | live width/height/angle pill |

---

## 4. `TransformPolicy` contract

```dart
abstract class TransformPolicy {
  Object get policyKey => runtimeType;
  TransformOutput apply(TransformInput input);

  void attach(PolicyBindings bindings) {}
  void detach() {}
}
```

### `TransformInput`

```dart
class TransformInput {
  final TransformKind kind; // resize / drag / rotate / scale / programmatic

  // CONSTRAINT-RESPECTING — engine math has already enforced clamping/min/max.
  final Rect proposedRect;
  final double proposedRotation;
  final Flip proposedFlip;

  // State at the start of the gesture (NOT previous frame).
  final Rect gestureStartRect;
  final double gestureStartRotation;

  // Current applied state (last frame's output).
  final Rect currentRect;
  final double currentRotation;

  final Rect clampingRect;
  final BoxConstraints constraints;
  final HandlePosition? sourceHandle;
  final PointerDeviceKind? sourceDevice;
  final Object? gestureId;

  final List<TransformAdjustment> upstreamAdjustments;
}
```

### `TransformOutput`

```dart
class TransformOutput {
  final Rect rect;
  final double rotation;
  final Flip flip;
  final List<TransformAdjustment> adjustments;

  factory TransformOutput.passthrough(TransformInput i) => TransformOutput(
    rect: i.proposedRect,
    rotation: i.proposedRotation,
    flip: i.proposedFlip,
    adjustments: const [],
  );
}
```

### `TransformAdjustment` (sealed)

```dart
sealed class TransformAdjustment {
  Object get source;
}

class SnapAdjustment extends TransformAdjustment {
  final SnapAxis axis;            // x / y / rotation
  final SnapTarget target;        // canvasEdge / siblingEdge / center / angle / gridCell
  final double snappedFromValue;
  final double snappedToValue;
  final double targetCoordinate;
}

class MagnetAdjustment extends TransformAdjustment {
  final Offset magnetWorld;
  final double pullStrength;
  final double distance;
}

class ConstraintAdjustment extends TransformAdjustment {
  final ConstraintKind kind;      // userAspectRatio / customConstraint
}
```

**Note:** `ConstraintAdjustment` is informational only for user-defined constraint policies. The engine's hidden safety re-clamp does NOT emit adjustments.

### Pipeline composition rules

- Policies run in registration order on the controller.
- Each policy sees the previous output as its input.
- Policies must be **idempotent** on their own input (`apply(apply(x)) == apply(x)`). Built-ins enforce this; third-party docs require it.
- After all user policies, a hidden safety re-clamp uses the engine's existing `_clampToConstraints` helper to re-enforce `clampingRect` and `BoxConstraints`. This catches any user policy that pushes a rect outside constraints.

### Built-in policies (v1.0)

| Class | Purpose |
|---|---|
| `SnapToCanvasEdges` | snap rect edges to clampingRect edges within a threshold |
| `SnapToSiblings` | snap to provided sibling rects' edges/centers |
| `SnapToAngles` | snap rotation to a list of angles within a threshold |
| `SnapToGrid` | snap rect topLeft to a grid cell |
| `MagneticAttraction` | pull rect toward magnet points within a radius |

Constraint-related built-ins (`TerminalConstraint`, `AspectRatioConstraint`) are **not** v1.0 built-ins; constraint logic stays in the engine. v1.x roadmap: extract constraints as user-orderable policies.

---

## 5. Controller v1.0 changes

### Public surface

```dart
class TransformableBoxController extends ChangeNotifier {
  TransformableBoxController({
    required Rect rect,
    Flip flip = Flip.none,
    double rotation = 0.0,
    Rect clampingRect = Rect.largest,
    BoxConstraints constraints = const BoxConstraints.expand(),
    BindingStrategy bindingStrategy = BindingStrategy.boundingBox,
    ValueGetter<ResizeMode> resizeModeResolver = _defaultResizeModeResolver,
    bool allowFlippingWhileResizing = true,

    // NEW
    List<TransformPolicy>? policies,
  });

  // State (Listenable)
  Rect get rect;
  double get rotation;
  Flip get flip;
  Rect get clampingRect;
  BoxConstraints get constraints;
  BindingStrategy get bindingStrategy;

  // NEW
  TransformOutput? get lastAppliedTransform;
  TransformKind? get activeTransform;

  // Delta API — RENAMED on* → propose*
  void proposeResizeStart(Offset worldPos, {required HandlePosition handle});
  UIResizeResult proposeResizeUpdate(Offset worldPos, {required HandlePosition handle});
  void proposeResizeEnd();
  void proposeResizeCancel();

  void proposeDragStart(Offset worldPos);
  UIMoveResult proposeDragUpdate(Offset worldPos);
  void proposeDragEnd();
  void proposeDragCancel();

  void proposeRotateStart(Offset worldPos);
  UIRotateResult proposeRotateUpdate(Offset worldPos);
  void proposeRotateEnd();
  void proposeRotateCancel();

  // NEW — body coalition combined call
  void proposeScaleStart(Offset focalWorld);
  UIResizeResult proposeScaleUpdate({Offset? focalDelta, double? scaleDelta, double? rotationDelta});
  void proposeScaleEnd();

  // State setters
  void setRect(Rect rect, {bool runPolicies = true, bool notify = true});
  void setRotation(double rotation, {bool runPolicies = true, bool notify = true});
  void setFlip(Flip flip, {bool notify = true});
  void setClampingRect(Rect rect, {bool notify = true});
  void setConstraints(BoxConstraints constraints, {bool notify = true});
  void setBindingStrategy(BindingStrategy strategy, {bool notify = true});
  void setResizeModeResolver(ValueGetter<ResizeMode> resolver, {bool notify = true});
  void setAllowFlippingWhileResizing(bool allow, {bool notify = true});

  // NEW
  List<TransformPolicy> get policies;
  void setPolicies(List<TransformPolicy> policies);
  void addPolicy(TransformPolicy policy);
  void removePolicy(TransformPolicy policy);

  // Manual re-run (replaces v0 recalculate*)
  void runPoliciesNow();

  // recalculate / recalculatePosition / recalculateSize: behavior UNCHANGED.
  // Existing internal methods continue to work; they additionally pump the
  // policy chain after engine math.
}
```

### Pipeline shape (engine math untouched)

```
behavior calls          ┌──────────────────────────────┐
  controller.propose─▶  │ 1. Engine math (UNCHANGED):  │
                        │    ui_box_transform produces  │
                        │    constraint-respecting      │
                        │    proposed rect.             │
                        └──────────────┬───────────────┘
                                       │ TransformInput
                                       ▼
                        ┌──────────────────────────────┐
                        │ 2. Policy chain (NEW):       │
                        │    User policies run on the  │
                        │    already-constrained rect. │
                        │    Snap, magnet, grid, etc.  │
                        └──────────────┬───────────────┘
                                       │ TransformOutput
                                       ▼
                        ┌──────────────────────────────┐
                        │ 3. Safety re-clamp (NEW):    │
                        │    Reuses engine's existing  │
                        │    clamp helper. Catches     │
                        │    policy-induced violations.│
                        └──────────────┬───────────────┘
                                       │
                                       ▼
                        ┌──────────────────────────────┐
                        │ 4. Apply & notify             │
                        └──────────────────────────────┘
```

### Selection state

**Caller-owned.** The `enabled` flag is promoted from `bool` to `ValueListenable<bool>` so callers can flip enablement reactively (e.g. when a different box gains selection in a multi-box scene).

```dart
TransformableBox(
  rect: ...,
  contentBuilder: ...,
  enabled: myEnabledNotifier, // ValueListenable<bool>
  behaviors: BoxBehaviorConfig.instagram(selected: myEnabledNotifier),
);
```

`TapToSelect` calls a caller-provided `onSelectionChanged(bool)` callback; the caller writes to its notifier; the box rebuilds.

### `ControllerEvent` (sealed)

```dart
sealed class ControllerEvent {
  Object get source;
  DateTime get timestamp;
}

class TransformStartEvent   extends ControllerEvent { final TransformKind kind; final Rect rect; final double rotation; }
class TransformUpdateEvent  extends ControllerEvent { /* before-after rects, adjustments */ }
class TransformEndEvent     extends ControllerEvent { final TransformKind kind; }
class TransformCancelEvent  extends ControllerEvent { final TransformKind kind; }
class TransformAppliedEvent extends ControllerEvent { final TransformOutput output; }
class TerminalEdgeEvent     extends ControllerEvent { /* min/max width/height reached */ }
```

These flow internally to `ObserverBehavior.onControllerEvent`. Not a public stream.

---

## 6. Widget tree & hit-testing layout

```
Positioned.fromRect(paintRect):
  Stack(clipBehavior: Clip.none):
    [0] Listener (wraps everything for ObserverBehavior pointer feed)
        — empty if no observers; HitTestBehavior.translucent
    [1] visualContent (Transform.rotate + Transform.scale, no gestures)
    [2] OverlayBehavior(layer: belowHandles)... (Positioned per overlay)
    [3] Body coalition zone (Positioned over boundingRect)
        RawGestureDetector(gestures: <coalesced factories>, behavior: translucent)
        — SKIPPED entirely if no BodyBehaviors active
    [4] HandleBehavior widgets... (one Positioned per handle, registration order)
        — each owns its own GestureDetector / RawGestureDetector / Listener
        — spatial priority: child wins arena; outer ring on parent layer bleeds out
    [5] OverlayBehavior(layer: aboveHandles)...
    [6] Debug overlays (kDebugMode only)
```

### Why this order works

- Pointer at a point: Flutter walks the Stack top-down, collects every widget at that point with a hit, runs the gesture arena.
- Inside a handle widget [4]: handle's detector and body's detector both enter; handle is *deeper*, wins on first-to-enter-arena + child-priority semantics.
- On body but outside any handle: only body coalition is at the hit point; it wins.
- `Listener` at [0] sees pointer events regardless of arena outcome; never claims.
- Overlays [2] and [5] use `IgnorePointer`; paint-only.

The "rotation ring bleeds out" trick from existing code is preserved verbatim: a `CornerHandle(withRotationRing: true)` paints a 64×64 area with the resize zone as a 24×24 inner child via `Padding`. Same widget tree as today.

### Body coalition assembly

Per build:

```dart
Map<Type, GestureRecognizerFactory> coalesce(List<BodyBehavior> active, BoxBehaviorBindings b) {
  // Group RecognizerInterests by their runtimeType.
  final byType = <Type, List<(BodyBehavior, RecognizerInterest)>>{};
  for (final beh in active) {
    for (final interest in beh.recognizers(b)) {
      byType.putIfAbsent(interest.runtimeType, () => []).add((beh, interest));
    }
  }

  // For ScaleInterest specifically, also collect ScaleContributions per frame
  // and dispatch ONE proposeScaleUpdate call combining all of them.
  // For Pan/Tap/LongPress/DoubleTap, fan out callbacks in registration order.

  return _buildFactories(byType);
}
```

---

## 7. Defaults, convenience constructors, migration

### Default

```dart
const TransformableBox({
  super.key,
  required this.contentBuilder,
  this.behaviors = const _Classic(),  // const sentinel for BoxBehaviorConfig.classic()
  // ...
});
```

### Convenience constructors

```dart
class BoxBehaviorConfig {
  const BoxBehaviorConfig({
    this.shared = const [],
    this.perDevice = const {},
  });

  /// Today's behavior. Default. All device kinds get handles + body drag.
  factory BoxBehaviorConfig.classic({
    bool resizable = true,
    bool draggable = true,
    bool rotatable = false,
    Set<HandlePosition> visibleHandles = const {...HandlePosition.values},
    Set<HandlePosition> enabledHandles = const {...HandlePosition.values},
    HandleAlignment handleAlignment = HandleAlignment.center,
    double handleTapSize = 24,
    double rotationHandleGestureSize = 64,
    HandleBuilder cornerHandleBuilder = HandleBuilders.defaultCorner,
    HandleBuilder sideHandleBuilder = HandleBuilders.defaultSide,
  });

  /// Cursor: identical to .classic() — corner+side handles, BodyDrag,
  ///   optional CornerRingRotateHandle when rotatable.
  /// Touch: ALL of cursor's handles (corner+side, optionally with rotation
  ///   ring), PLUS BodyTransform(drag+pinch+twist), TapToSelect,
  ///   StemRotationHandle (when rotatable), and DimensionReadout overlay.
  /// Stylus: same as touch, minus pinch (stylus pinch is rare and ergonomically awkward).
  factory BoxBehaviorConfig.touchOptimized({
    required ValueListenable<bool> selected,
    void Function(bool)? onSelectionChanged,
    /* ...same handle/build customization knobs as .classic()... */
  });

  /// Pure-gesture sticker editor pattern. Touch only:
  /// TapToSelect + BodyTransform(drag+pinch+twist). NO handles.
  /// Cursor: empty (callers wanting cursor support hand-compose with .compose()).
  factory BoxBehaviorConfig.instagram({
    required ValueListenable<bool> selected,
    void Function(bool)? onSelectionChanged,
  });

  /// Empty start; compose freely.
  factory BoxBehaviorConfig.compose({
    List<BoxBehavior> shared = const [],
    Map<PointerDeviceKind, List<BoxBehavior>> perDevice = const {},
  }) = BoxBehaviorConfig;
}
```

`shared` and `perDevice` merge **additively** — every device gets `shared` plus its own `perDevice` entry (if any). To exclude a behavior from a specific device, use the behavior's own `devices: {...}` filter scoped narrower.

### Migration table (v0.4.x → v1.0)

| v0.4.x field on `TransformableBox` | v1.0 equivalent |
|---|---|
| `cornerHandleBuilder: ...` | `behaviors: BoxBehaviorConfig.classic(cornerHandleBuilder: ...)` |
| `sideHandleBuilder: ...` | `behaviors: BoxBehaviorConfig.classic(sideHandleBuilder: ...)` |
| `rotatable: true` | `behaviors: BoxBehaviorConfig.classic(rotatable: true)` |
| `rotationHandleGestureSize: 64` | `behaviors: BoxBehaviorConfig.classic(rotationHandleGestureSize: 64)` |
| `enabledHandles: {...}` | `behaviors: BoxBehaviorConfig.classic(enabledHandles: {...})` |
| `visibleHandles: {...}` | same |
| `handleAlignment: ...` | same |
| `handleTapSize: 24` | same |
| `resizable: false` | `behaviors: BoxBehaviorConfig.classic(resizable: false)` |
| `draggable: false` | `behaviors: BoxBehaviorConfig.classic(draggable: false)` |
| `supportedDragDevices: ...` | gone — use `perDevice:` keys to scope which devices get `BodyDrag()` |
| `supportedResizeDevices: ...` | gone — same idea, per-device keys scope which devices get handle behaviors |
| `cursorResolver: ...` | moved onto `CornerHandle`/`SideHandle` constructors |
| `bindingStrategy: ...` | unchanged on controller |
| `controller.onResizeStart(localPosition)` | `controller.proposeResizeStart(worldPos, handle: handle)` |
| `controller.onResizeUpdate(localPosition, handle)` | `controller.proposeResizeUpdate(worldPos, handle: handle)` |
| `controller.onDragStart(localPosition)` | `controller.proposeDragStart(worldPos)` |
| `controller.onDragUpdate(localPosition)` | `controller.proposeDragUpdate(worldPos)` |
| `controller.onRotateStart(localPosition)` | `controller.proposeRotateStart(worldPos)` |
| `controller.onRotateUpdate(localPosition, handle)` | `controller.proposeRotateUpdate(worldPos)` |
| `controller.recalculate()` | unchanged (now also runs policies) |
| All `onResize*`, `onDrag*`, `onRotate*`, `onTerminal*`, `onTap` | unchanged |
| All `debug*` flags | unchanged |
| `enabled: bool` | `enabled: ValueListenable<bool>` (promoted) |

A **`dart fix` codemod** ships alongside v1.0 to do mechanical migrations automatically. Manual review needed for: custom callers, custom controllers, anywhere `enabled: bool` is passed (wrap in `ValueNotifier` or migrate to listenable).

---

## 8. Testing strategy

TDD discipline — test first, then implement. Heavy bottom of the test pyramid because most logic is in pure functions.

### Pure unit (50% of effort)

- **`TransformPolicy.apply`**: feed `TransformInput`, assert `TransformOutput.rect` and `adjustments`. No widget tree, no controller mounting. Each built-in policy: snap matrix × idempotency × passthrough × edge cases.
- **`Anchor.computeWorld`**: parametric matrix over rect × rotation × alignment × handle. 100% coverage achievable.
- **Controller propose\* methods**: headless tests; instantiate controller, call propose*, assert state.
- **Policy chain composition**: `runChain(policies, input)` helper; assert ordering and idempotency.
- **`ScaleContribution.merge`**: pure function tests.

### Widget (30% of effort)

- **`HandleHitFrame`** golden + simulated pointer tests: inner zone hits resize, outer ring hits rotate.
- **Recognizer coalition**: two `ScaleInterest`s merge into one `ScaleGestureRecognizer`; callbacks fan out in order.
- **Pan + Scale conflict assertion**: `BoxBehaviorConfig` constructor throws on misconfiguration.
- **Per-frame contribution merging**: simulated multi-touch, verify single combined controller call per frame.

### Integration / golden (20% of effort)

- **Cursor flow** (`.classic()`): hover handle → click-drag → release.
- **Touch-optimized flow**: tap-to-select → pinch → twist → drag → release.
- **Instagram flow**: end-to-end gesture composition.
- **Byte-equivalence golden** for `BoxBehaviorConfig.classic()` against frozen v0.4.7 widget tree dumps. Cartesian product over `rotatable` × `resizable` × `draggable` × `enabledHandles` × `visibleHandles` × `handleAlignment` × custom builders.

### CI gates

- All unit + widget + integration tests pass.
- All golden tests pass.
- Byte-equivalence test passes.
- `dart analyze` and `dart format` clean.
- **Test coverage ≥ 90%** on new code.
- **Mutation testing** on `TransformPolicy.apply` functions catches "tests that assert but don't really test."

### Test directory layout

```
test/
├── transform_policies/
│   ├── snap_to_canvas_edges_test.dart
│   ├── snap_to_siblings_test.dart
│   ├── snap_to_angles_test.dart
│   ├── snap_to_grid_test.dart
│   ├── magnetic_attraction_test.dart
│   └── policy_chain_composition_test.dart
├── controller/
│   ├── propose_resize_test.dart
│   ├── propose_drag_test.dart
│   ├── propose_rotate_test.dart
│   ├── propose_scale_test.dart
│   ├── policy_chain_integration_test.dart
│   ├── safety_clamp_test.dart
│   └── event_emission_test.dart
├── box_behaviors/
│   ├── handle/{corner,side,stem_rotation,corner_ring_rotate}_handle_test.dart
│   ├── body/{body_drag,body_transform,tap_to_select}_test.dart
│   ├── observer/haptic_on_snap_test.dart
│   └── overlay/{snap_guides,dimension_readout}_test.dart
├── anchors/
│   ├── corner_anchor_test.dart
│   ├── side_anchor_test.dart
│   ├── edge_stem_anchor_test.dart
│   └── custom_anchor_test.dart
├── coalition/
│   ├── recognizer_coalition_test.dart
│   ├── pan_scale_conflict_assertion_test.dart
│   └── per_frame_contribution_merging_test.dart
├── widget/
│   ├── transformable_box_test.dart        (existing, adapted)
│   ├── byte_equivalence_classic_test.dart (NEW, frozen golden)
│   └── handle_hit_frame_test.dart
├── integration/
│   ├── cursor_flow_test.dart
│   ├── touch_optimized_flow_test.dart
│   └── instagram_flow_test.dart
└── helpers/
    ├── test_fixtures.dart
    └── fake_box_behavior_bindings.dart
```

---

## 9. v1.x deferred work

Tracked here for future planning; out of scope for v1.0:

1. **Engine refactor** — extract constraint logic from `ui_box_transform.dart` into a user-orderable `TerminalConstraint` policy. Enables snap-then-clamp ordering control and `AspectRatioConstraint` as user policy.
2. **Richer `Anchor` types** — content-aware pivots, anchored to bounding-rect vs. unrotated-rect, anchor-relative-to-anchor (e.g., "midway between top-left and rotation pivot").
3. **Stable third-party `BodyBehavior` contract.** Promote from `@experimental` to stable once recognizer-coalition rules are battle-tested through built-ins.
4. **Additional recognizer kinds** in body coalition: `ForcePressInterest`, `MultiDragInterest`, custom recognizer factories.
5. **`Stream<ControllerEvent>` public API** — if there's user demand for typed event streams without writing an `ObserverBehavior`.
6. **Multi-box scene primitives** — sibling registration, scene-level selection coordination, group transforms.
7. **`HandleAlignment` non-center variants under rotation** — currently `rotatable: true` requires `HandleAlignment.center` (existing limitation in `_TransformableBoxState`). Proper non-center support for rotated boxes.
8. **Side handle rotation gestures** — currently only corners have rotation rings; sides could too.

---

## 10. References

### Prior art

- [Moveable.js Able plugin system](https://github.com/daybrush/moveable/blob/master/handbook/handbook.md) — closest spiritual cousin
- [tldraw Tool/StateNode architecture](https://tldraw.dev/sdk-features/tools)
- [Excalidraw extensibility model](https://deepwiki.com/zsviczian/excalidraw/3-core-excalidraw-library)
- [Konva Transformer](https://konvajs.org/docs/select_and_transform/Basic_demo.html)
- [Rive Transform Constraint](https://help.rive.app/editor/constraints/transform-constraint)

### Flutter platform constraints

- [Flutter gesture arena documentation](https://docs.flutter.dev/ui/interactivity/gestures)
- [`ScaleGestureRecognizer` API](https://api.flutter.dev/flutter/gestures/ScaleGestureRecognizer-class.html)
- [`RawGestureDetector` API](https://api.flutter.dev/flutter/widgets/RawGestureDetector-class.html)
- [flutter#13101 — Pan vs Scale conflict](https://github.com/flutter/flutter/issues/13101)
- [flutter#9949 — Pan should yield to Scale](https://github.com/flutter/flutter/issues/9949)
- [flutter#115061 — Scale superset of Pan](https://github.com/flutter/flutter/issues/115061)

### Standards

- [W3C Pointer Events specification](https://w3c.github.io/pointerevents/)
- [Apple HIG — touch target sizes](https://developer.apple.com/design/human-interface-guidelines/inputs/pointing-devices)
- [Material Design touch targets](https://m2.material.io/develop/web/supporting/touch-target)
- [Procreate Transform Interface & Gestures](https://help.procreate.com/procreate/handbook/transform/transform-interface-gestures)
