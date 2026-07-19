# Phase 1: Foundation — Implementation Plan

> **For agentic workers:** REQUIRED SUB-SKILL: Use superpowers:subagent-driven-development (recommended) or superpowers:executing-plans to implement this plan task-by-task. Steps use checkbox (`- [ ]`) syntax for tracking.

**Goal:** Add the new BoxBehavior plugin foundation alongside the existing widget — abstract types, anchor system, transform-pipeline data types, config object, and frozen byte-equivalence baselines — without changing any existing widget behavior.

**Architecture:** All new code lives under `packages/flutter_box_transform/lib/src/behaviors/`, `policies/`, `controller/`, `anchors/` directories. Existing files (`transformable_box.dart`, `handles.dart`, `ui_box_transform.dart`, etc.) are NOT modified in Phase 1. The existing test suite must continue to pass without changes. At the end of this phase, the new types compile and have unit-test coverage; nothing user-visible changes.

**Tech Stack:** Dart 3 (sealed types required), Flutter `flutter_test`, golden tests via `flutter test --update-goldens`, package `vector_math` (already a transitive dep) for matrix helpers.

**Spec reference:** `docs/superpowers/specs/2026-04-27-box-behavior-plugin-architecture-design.md`

---

## File structure created in this phase

```
packages/flutter_box_transform/lib/src/
├── anchors/
│   ├── anchor.dart                  (sealed base + 4 concrete variants)
│   ├── corner.dart                  (Corner enum)
│   └── side.dart                    (Side enum)
├── behaviors/
│   ├── box_behavior.dart            (abstract base + 4 abstract subtypes)
│   ├── box_behavior_bindings.dart   (BoxBehaviorBindings interface)
│   ├── box_behavior_config.dart     (BoxBehaviorConfig with merge + assertion)
│   ├── recognizer_interest.dart     (sealed hierarchy)
│   └── scale_contribution.dart      (ScaleContribution + merge)
├── policies/
│   ├── transform_adjustment.dart    (sealed hierarchy)
│   ├── transform_input.dart
│   ├── transform_output.dart
│   └── transform_policy.dart        (abstract base)
└── controller/
    └── controller_event.dart        (sealed hierarchy)

packages/flutter_box_transform/test/
├── anchors/
│   ├── corner_anchor_test.dart
│   ├── side_anchor_test.dart
│   ├── edge_stem_anchor_test.dart
│   └── custom_anchor_test.dart
├── behaviors/
│   ├── box_behavior_test.dart
│   ├── box_behavior_bindings_test.dart
│   ├── box_behavior_config_test.dart
│   ├── recognizer_interest_test.dart
│   └── scale_contribution_test.dart
├── policies/
│   ├── transform_adjustment_test.dart
│   ├── transform_input_test.dart
│   ├── transform_output_test.dart
│   └── transform_policy_test.dart
├── controller/
│   └── controller_event_test.dart
├── widget/
│   └── byte_equivalence_baselines_test.dart
├── helpers/
│   ├── test_fixtures.dart
│   └── fake_box_behavior_bindings.dart
└── (existing test files unchanged)
```

`packages/flutter_box_transform/lib/flutter_box_transform.dart` gains new `export` lines but the existing exports are unchanged.

---

## Task 1: Create directory structure and test helpers stubs

**Files:**
- Create: `packages/flutter_box_transform/lib/src/anchors/.gitkeep`
- Create: `packages/flutter_box_transform/lib/src/behaviors/.gitkeep`
- Create: `packages/flutter_box_transform/lib/src/policies/.gitkeep`
- Create: `packages/flutter_box_transform/lib/src/controller/.gitkeep`
- Create: `packages/flutter_box_transform/test/helpers/test_fixtures.dart`
- Create: `packages/flutter_box_transform/test/helpers/fake_box_behavior_bindings.dart`

- [ ] **Step 1: Create directories with placeholder files**

```bash
cd packages/flutter_box_transform/lib/src
mkdir -p anchors behaviors policies controller
touch anchors/.gitkeep behaviors/.gitkeep policies/.gitkeep controller/.gitkeep
```

```bash
cd packages/flutter_box_transform/test
mkdir -p anchors behaviors policies controller widget helpers
```

- [ ] **Step 2: Write test_fixtures.dart with initial sentinel rects/rotations**

File: `packages/flutter_box_transform/test/helpers/test_fixtures.dart`

```dart
import 'dart:math' as math;
import 'dart:ui';

/// Fixed list of test rectangles used in parametric Anchor tests.
const List<Rect> kTestRects = [
  Rect.fromLTWH(0, 0, 100, 100),
  Rect.fromLTWH(50, 50, 200, 100),
  Rect.fromLTWH(-50, -50, 100, 100),
  Rect.fromLTWH(0, 0, 1, 1),
  Rect.fromLTWH(100, 200, 300, 400),
];

/// Fixed list of test rotations (radians) used in parametric Anchor tests.
final List<double> kTestRotations = [
  0,
  math.pi / 6,    // 30°
  math.pi / 4,    // 45°
  math.pi / 2,    // 90°
  math.pi,        // 180°
  -math.pi / 4,   // -45°
];
```

- [ ] **Step 3: Write fake_box_behavior_bindings.dart stub (will be filled in Task 15)**

File: `packages/flutter_box_transform/test/helpers/fake_box_behavior_bindings.dart`

```dart
// Stub. Filled in Task 15 once BoxBehaviorBindings is defined.
```

- [ ] **Step 4: Commit**

```bash
git add packages/flutter_box_transform/lib/src/anchors/ \
        packages/flutter_box_transform/lib/src/behaviors/ \
        packages/flutter_box_transform/lib/src/policies/ \
        packages/flutter_box_transform/lib/src/controller/ \
        packages/flutter_box_transform/test/helpers/
git commit -m "chore: scaffold v1.0 phase-1 directory structure"
```

---

## Task 2: Corner enum, Side enum, Anchor sealed base

**Files:**
- Create: `packages/flutter_box_transform/lib/src/anchors/corner.dart`
- Create: `packages/flutter_box_transform/lib/src/anchors/side.dart`
- Create: `packages/flutter_box_transform/lib/src/anchors/anchor.dart`
- Test: `packages/flutter_box_transform/test/anchors/anchor_basics_test.dart`

- [ ] **Step 1: Write the failing test**

File: `packages/flutter_box_transform/test/anchors/anchor_basics_test.dart`

```dart
import 'package:flutter_box_transform/src/anchors/anchor.dart';
import 'package:flutter_box_transform/src/anchors/corner.dart';
import 'package:flutter_box_transform/src/anchors/side.dart';
import 'package:flutter_test/flutter_test.dart';

void main() {
  group('Corner / Side enums', () {
    test('Corner has exactly 4 values: tl, tr, bl, br', () {
      expect(Corner.values, hasLength(4));
      expect(Corner.values, containsAll([
        Corner.topLeft, Corner.topRight, Corner.bottomLeft, Corner.bottomRight,
      ]));
    });

    test('Side has exactly 4 values: top, right, bottom, left', () {
      expect(Side.values, hasLength(4));
      expect(Side.values, containsAll([Side.top, Side.right, Side.bottom, Side.left]));
    });
  });

  group('Anchor sealed dispatch', () {
    test('Anchor.corner constructs CornerAnchor', () {
      final a = Anchor.corner(Corner.topLeft);
      expect(a, isA<CornerAnchor>());
      expect((a as CornerAnchor).corner, Corner.topLeft);
    });

    test('Anchor.side constructs SideAnchor', () {
      final a = Anchor.side(Side.top);
      expect(a, isA<SideAnchor>());
    });

    test('Anchor.edgeStem constructs EdgeStemAnchor', () {
      final a = Anchor.edgeStem(from: Side.top, distance: 24);
      expect(a, isA<EdgeStemAnchor>());
      final e = a as EdgeStemAnchor;
      expect(e.from, Side.top);
      expect(e.distance, 24);
    });

    test('Anchor.custom constructs CustomAnchor', () {
      final a = Anchor.custom((_, __, ___, ____) => Offset.zero);
      expect(a, isA<CustomAnchor>());
    });
  });
}
```

- [ ] **Step 2: Run test, expect failure (types don't exist)**

```bash
cd packages/flutter_box_transform
flutter test test/anchors/anchor_basics_test.dart
```

Expected: compile error / "Anchor not found".

- [ ] **Step 3: Implement Corner enum**

File: `packages/flutter_box_transform/lib/src/anchors/corner.dart`

```dart
/// The four corners of an axis-aligned rectangle.
enum Corner {
  topLeft,
  topRight,
  bottomLeft,
  bottomRight;
}
```

- [ ] **Step 4: Implement Side enum**

File: `packages/flutter_box_transform/lib/src/anchors/side.dart`

```dart
/// The four sides of an axis-aligned rectangle.
enum Side {
  top,
  right,
  bottom,
  left;
}
```

- [ ] **Step 5: Implement Anchor sealed base + 4 placeholder concrete types**

File: `packages/flutter_box_transform/lib/src/anchors/anchor.dart`

```dart
import 'dart:ui';

import 'corner.dart';
import 'side.dart';

/// Function shape for Anchor.custom.
typedef AnchorComputer = Offset Function(
  Rect rect,
  double rotation,
  Size handleSize,
  HandleAlignment alignment,
);

/// Where a HandleBehavior anchors itself on the box.
///
/// Override `computeWorld` to return the anchor's world-frame top-left position
/// for a handle widget of [handleSize], given the box's [rect], [rotation],
/// and the [HandleAlignment] preference.
sealed class Anchor {
  const Anchor();

  Offset computeWorld(
    Rect rect,
    double rotation,
    Size handleSize,
    HandleAlignment alignment,
  );

  const factory Anchor.corner(Corner c) = CornerAnchor;
  const factory Anchor.side(Side s) = SideAnchor;
  const factory Anchor.edgeStem({required Side from, required double distance}) = EdgeStemAnchor;
  const factory Anchor.custom(AnchorComputer compute) = CustomAnchor;
}

/// Where the handle's painted area sits relative to the rect's edge.
enum HandleAlignment {
  /// Handle straddles the edge (half inside, half outside).
  center,
  /// Handle sits fully inside the rect.
  inside,
  /// Handle sits fully outside the rect.
  outside;
}

class CornerAnchor extends Anchor {
  final Corner corner;
  const CornerAnchor(this.corner);

  @override
  Offset computeWorld(Rect rect, double rotation, Size handleSize, HandleAlignment alignment) {
    throw UnimplementedError('Implemented in Task 3');
  }
}

class SideAnchor extends Anchor {
  final Side side;
  const SideAnchor(this.side);

  @override
  Offset computeWorld(Rect rect, double rotation, Size handleSize, HandleAlignment alignment) {
    throw UnimplementedError('Implemented in Task 4');
  }
}

class EdgeStemAnchor extends Anchor {
  final Side from;
  final double distance;
  const EdgeStemAnchor({required this.from, required this.distance});

  @override
  Offset computeWorld(Rect rect, double rotation, Size handleSize, HandleAlignment alignment) {
    throw UnimplementedError('Implemented in Task 5');
  }
}

class CustomAnchor extends Anchor {
  final AnchorComputer compute;
  const CustomAnchor(this.compute);

  @override
  Offset computeWorld(Rect rect, double rotation, Size handleSize, HandleAlignment alignment) {
    return compute(rect, rotation, handleSize, alignment);
  }
}
```

- [ ] **Step 6: Run test, expect pass**

```bash
flutter test test/anchors/anchor_basics_test.dart
```

Expected: all 5 tests pass.

- [ ] **Step 7: Add export to library**

File: `packages/flutter_box_transform/lib/flutter_box_transform.dart`

Add after existing exports:

```dart
export 'src/anchors/anchor.dart';
export 'src/anchors/corner.dart';
export 'src/anchors/side.dart';
```

- [ ] **Step 8: Commit**

```bash
git add packages/flutter_box_transform/lib/src/anchors/ \
        packages/flutter_box_transform/test/anchors/anchor_basics_test.dart \
        packages/flutter_box_transform/lib/flutter_box_transform.dart
git commit -m "feat(anchors): add Corner, Side enums and Anchor sealed base"
```

---

## Task 3: CornerAnchor with rotation math

**Files:**
- Modify: `packages/flutter_box_transform/lib/src/anchors/anchor.dart` (CornerAnchor.computeWorld)
- Test: `packages/flutter_box_transform/test/anchors/corner_anchor_test.dart`

- [ ] **Step 1: Write the failing tests**

File: `packages/flutter_box_transform/test/anchors/corner_anchor_test.dart`

```dart
import 'dart:math' as math;
import 'dart:ui';

import 'package:flutter_box_transform/src/anchors/anchor.dart';
import 'package:flutter_box_transform/src/anchors/corner.dart';
import 'package:flutter_test/flutter_test.dart';

import '../helpers/test_fixtures.dart';

void main() {
  group('CornerAnchor.computeWorld', () {
    const handleSize = Size(24, 24);
    const rect = Rect.fromLTWH(100, 100, 200, 200); // corners at (100,100) (300,100) (100,300) (300,300)

    test('topLeft, alignment center, no rotation: handle top-left = corner - handleSize/2', () {
      final anchor = const CornerAnchor(Corner.topLeft);
      final pos = anchor.computeWorld(rect, 0, handleSize, HandleAlignment.center);
      expect(pos, const Offset(88, 88)); // 100 - 12 = 88
    });

    test('bottomRight, alignment center, no rotation: handle top-left = corner - handleSize/2', () {
      final anchor = const CornerAnchor(Corner.bottomRight);
      final pos = anchor.computeWorld(rect, 0, handleSize, HandleAlignment.center);
      expect(pos, const Offset(288, 288)); // 300 - 12 = 288
    });

    test('topLeft, alignment inside, no rotation: handle fully inside (top-left = corner)', () {
      final anchor = const CornerAnchor(Corner.topLeft);
      final pos = anchor.computeWorld(rect, 0, handleSize, HandleAlignment.inside);
      expect(pos, const Offset(100, 100));
    });

    test('topLeft, alignment outside, no rotation: handle fully outside (top-left = corner - handleSize)', () {
      final anchor = const CornerAnchor(Corner.topLeft);
      final pos = anchor.computeWorld(rect, 0, handleSize, HandleAlignment.outside);
      expect(pos, const Offset(76, 76)); // 100 - 24 = 76
    });

    test('topLeft, alignment center, rotation 90°: corner rotates to bottom-left', () {
      final anchor = const CornerAnchor(Corner.topLeft);
      // Rotation around rect center (200, 200). topLeft (100,100) → (100,300) after +90°.
      final pos = anchor.computeWorld(rect, math.pi / 2, handleSize, HandleAlignment.center);
      expect(pos.dx, closeTo(88, 1e-6));
      expect(pos.dy, closeTo(288, 1e-6));
    });

    test('returns finite values for all (corner × rotation × alignment) combos in fixture set', () {
      for (final r in kTestRects) {
        for (final rot in kTestRotations) {
          for (final c in Corner.values) {
            for (final a in HandleAlignment.values) {
              final pos = CornerAnchor(c).computeWorld(r, rot, handleSize, a);
              expect(pos.dx.isFinite, true, reason: 'rect=$r rot=$rot corner=$c align=$a');
              expect(pos.dy.isFinite, true, reason: 'rect=$r rot=$rot corner=$c align=$a');
            }
          }
        }
      }
    });
  });
}
```

- [ ] **Step 2: Run test, expect UnimplementedError**

```bash
flutter test test/anchors/corner_anchor_test.dart
```

Expected: tests fail with `UnimplementedError`.

- [ ] **Step 3: Implement CornerAnchor.computeWorld**

File: `packages/flutter_box_transform/lib/src/anchors/anchor.dart`

Replace `CornerAnchor.computeWorld` body:

```dart
@override
Offset computeWorld(Rect rect, double rotation, Size handleSize, HandleAlignment alignment) {
  // 1. Pick the unrotated corner offset.
  final Offset cornerLocal;
  switch (corner) {
    case Corner.topLeft:     cornerLocal = rect.topLeft;     break;
    case Corner.topRight:    cornerLocal = rect.topRight;    break;
    case Corner.bottomLeft:  cornerLocal = rect.bottomLeft;  break;
    case Corner.bottomRight: cornerLocal = rect.bottomRight; break;
  }

  // 2. Rotate the corner around the rect center.
  final Offset cornerWorld = rotation == 0
      ? cornerLocal
      : _rotateAround(cornerLocal, rect.center, rotation);

  // 3. Apply alignment to derive the handle's top-left.
  switch (alignment) {
    case HandleAlignment.center:
      return cornerWorld - Offset(handleSize.width / 2, handleSize.height / 2);
    case HandleAlignment.inside:
      // Push handle into the rect by (handleSize) — direction depends on corner.
      final dir = _insideDirection(corner);
      return cornerWorld + Offset(
        dir.dx * 0,            // Top-left aligned at corner; stays at corner for inside alignment.
        dir.dy * 0,
      );
    case HandleAlignment.outside:
      // Pull handle out of the rect by handleSize, direction per corner.
      final dir = _insideDirection(corner);
      return cornerWorld + Offset(
        -dir.dx * handleSize.width,
        -dir.dy * handleSize.height,
      );
  }
}

Offset _insideDirection(Corner c) {
  switch (c) {
    case Corner.topLeft:     return const Offset(1, 1);
    case Corner.topRight:    return const Offset(-1, 1);
    case Corner.bottomLeft:  return const Offset(1, -1);
    case Corner.bottomRight: return const Offset(-1, -1);
  }
}

Offset _rotateAround(Offset point, Offset pivot, double angle) {
  final dx = point.dx - pivot.dx;
  final dy = point.dy - pivot.dy;
  final c = math.cos(angle);
  final s = math.sin(angle);
  return Offset(
    pivot.dx + dx * c - dy * s,
    pivot.dy + dx * s + dy * c,
  );
}
```

Add at top of file:

```dart
import 'dart:math' as math;
```

- [ ] **Step 4: Run test, expect pass**

```bash
flutter test test/anchors/corner_anchor_test.dart
```

Expected: all 6 tests pass.

- [ ] **Step 5: Commit**

```bash
git add packages/flutter_box_transform/lib/src/anchors/anchor.dart \
        packages/flutter_box_transform/test/anchors/corner_anchor_test.dart
git commit -m "feat(anchors): implement CornerAnchor.computeWorld with rotation"
```

---

## Task 4: SideAnchor with rotation math

**Files:**
- Modify: `packages/flutter_box_transform/lib/src/anchors/anchor.dart` (SideAnchor.computeWorld)
- Test: `packages/flutter_box_transform/test/anchors/side_anchor_test.dart`

- [ ] **Step 1: Write the failing tests**

File: `packages/flutter_box_transform/test/anchors/side_anchor_test.dart`

```dart
import 'dart:math' as math;
import 'dart:ui';

import 'package:flutter_box_transform/src/anchors/anchor.dart';
import 'package:flutter_box_transform/src/anchors/side.dart';
import 'package:flutter_test/flutter_test.dart';

import '../helpers/test_fixtures.dart';

void main() {
  group('SideAnchor.computeWorld', () {
    const handleSize = Size(24, 24);
    const rect = Rect.fromLTWH(100, 100, 200, 200);

    test('top, alignment center, no rotation: handle centered above top edge midpoint', () {
      final pos = const SideAnchor(Side.top).computeWorld(rect, 0, handleSize, HandleAlignment.center);
      // Top edge midpoint = (200, 100). Handle top-left = (200-12, 100-12) = (188, 88).
      expect(pos, const Offset(188, 88));
    });

    test('left, alignment center, no rotation: handle centered on left edge midpoint', () {
      final pos = const SideAnchor(Side.left).computeWorld(rect, 0, handleSize, HandleAlignment.center);
      // Left edge midpoint = (100, 200). Handle top-left = (100-12, 200-12) = (88, 188).
      expect(pos, const Offset(88, 188));
    });

    test('returns finite values for all (side × rotation × alignment) combos in fixture set', () {
      for (final r in kTestRects) {
        for (final rot in kTestRotations) {
          for (final s in Side.values) {
            for (final a in HandleAlignment.values) {
              final pos = SideAnchor(s).computeWorld(r, rot, handleSize, a);
              expect(pos.dx.isFinite, true, reason: 'rect=$r rot=$rot side=$s align=$a');
              expect(pos.dy.isFinite, true, reason: 'rect=$r rot=$rot side=$s align=$a');
            }
          }
        }
      }
    });
  });
}
```

- [ ] **Step 2: Run test, expect UnimplementedError**

```bash
flutter test test/anchors/side_anchor_test.dart
```

Expected: tests fail with `UnimplementedError`.

- [ ] **Step 3: Implement SideAnchor.computeWorld**

File: `packages/flutter_box_transform/lib/src/anchors/anchor.dart`

Replace `SideAnchor.computeWorld` body:

```dart
@override
Offset computeWorld(Rect rect, double rotation, Size handleSize, HandleAlignment alignment) {
  // 1. Pick edge midpoint in unrotated frame.
  final Offset midLocal;
  switch (side) {
    case Side.top:    midLocal = Offset(rect.center.dx, rect.top);    break;
    case Side.right:  midLocal = Offset(rect.right,     rect.center.dy); break;
    case Side.bottom: midLocal = Offset(rect.center.dx, rect.bottom); break;
    case Side.left:   midLocal = Offset(rect.left,      rect.center.dy); break;
  }

  // 2. Rotate around rect center.
  final Offset midWorld = rotation == 0
      ? midLocal
      : _rotateAround(midLocal, rect.center, rotation);

  // 3. Apply alignment offset along the edge's outward normal.
  // Outward normal direction for each side BEFORE rotation:
  final Offset outwardLocal;
  switch (side) {
    case Side.top:    outwardLocal = const Offset(0, -1); break;
    case Side.right:  outwardLocal = const Offset(1, 0);  break;
    case Side.bottom: outwardLocal = const Offset(0, 1);  break;
    case Side.left:   outwardLocal = const Offset(-1, 0); break;
  }
  // Rotate the outward normal by the same rotation.
  final Offset outwardWorld = rotation == 0
      ? outwardLocal
      : _rotateAround(outwardLocal, Offset.zero, rotation);

  switch (alignment) {
    case HandleAlignment.center:
      return midWorld - Offset(handleSize.width / 2, handleSize.height / 2);
    case HandleAlignment.inside:
      // Pull handle inward by handleSize/2 (so handle's far edge sits at the rect edge).
      final shift = Offset(-outwardWorld.dx * handleSize.width / 2,
                           -outwardWorld.dy * handleSize.height / 2);
      return midWorld + shift - Offset(handleSize.width / 2, handleSize.height / 2);
    case HandleAlignment.outside:
      // Push handle outward by handleSize/2.
      final shift = Offset(outwardWorld.dx * handleSize.width / 2,
                           outwardWorld.dy * handleSize.height / 2);
      return midWorld + shift - Offset(handleSize.width / 2, handleSize.height / 2);
  }
}
```

- [ ] **Step 4: Run test, expect pass**

```bash
flutter test test/anchors/side_anchor_test.dart
```

Expected: all 3 tests pass.

- [ ] **Step 5: Commit**

```bash
git add packages/flutter_box_transform/lib/src/anchors/anchor.dart \
        packages/flutter_box_transform/test/anchors/side_anchor_test.dart
git commit -m "feat(anchors): implement SideAnchor.computeWorld with rotation"
```

---

## Task 5: EdgeStemAnchor

**Files:**
- Modify: `packages/flutter_box_transform/lib/src/anchors/anchor.dart` (EdgeStemAnchor.computeWorld)
- Test: `packages/flutter_box_transform/test/anchors/edge_stem_anchor_test.dart`

- [ ] **Step 1: Write the failing tests**

File: `packages/flutter_box_transform/test/anchors/edge_stem_anchor_test.dart`

```dart
import 'dart:math' as math;
import 'dart:ui';

import 'package:flutter_box_transform/src/anchors/anchor.dart';
import 'package:flutter_box_transform/src/anchors/side.dart';
import 'package:flutter_test/flutter_test.dart';

import '../helpers/test_fixtures.dart';

void main() {
  group('EdgeStemAnchor.computeWorld', () {
    const handleSize = Size(24, 24);
    const rect = Rect.fromLTWH(100, 100, 200, 200);

    test('top, distance 50, no rotation: handle centered 50 px above top edge midpoint', () {
      final pos = const EdgeStemAnchor(from: Side.top, distance: 50)
          .computeWorld(rect, 0, handleSize, HandleAlignment.center);
      // Edge midpoint (200, 100); 50 above = (200, 50). Handle top-left = (188, 38).
      expect(pos, const Offset(188, 38));
    });

    test('bottom, distance 30, no rotation: handle centered 30 px below bottom edge midpoint', () {
      final pos = const EdgeStemAnchor(from: Side.bottom, distance: 30)
          .computeWorld(rect, 0, handleSize, HandleAlignment.center);
      // Edge midpoint (200, 300); 30 below = (200, 330). Handle top-left = (188, 318).
      expect(pos, const Offset(188, 318));
    });

    test('top, distance 50, rotation 180°: stem points down (handle below box bottom edge)', () {
      final pos = const EdgeStemAnchor(from: Side.top, distance: 50)
          .computeWorld(rect, math.pi, handleSize, HandleAlignment.center);
      // Top edge after 180° rotation maps to bottom; "outward" (was up) now points down.
      // Original edge midpoint was (200, 100); rotated around (200, 200) by 180° → (200, 300).
      // Outward direction (was 0,-1) → (0, 1) after rotation. 50px in that direction → (200, 350).
      // Handle top-left → (188, 338).
      expect(pos.dx, closeTo(188, 1e-6));
      expect(pos.dy, closeTo(338, 1e-6));
    });

    test('returns finite values for all (side × distance × rotation × alignment) in fixtures', () {
      for (final r in kTestRects) {
        for (final rot in kTestRotations) {
          for (final s in Side.values) {
            for (final d in [0.0, 24.0, 64.0]) {
              for (final a in HandleAlignment.values) {
                final pos = EdgeStemAnchor(from: s, distance: d)
                    .computeWorld(r, rot, handleSize, a);
                expect(pos.dx.isFinite, true);
                expect(pos.dy.isFinite, true);
              }
            }
          }
        }
      }
    });
  });
}
```

- [ ] **Step 2: Run test, expect UnimplementedError**

```bash
flutter test test/anchors/edge_stem_anchor_test.dart
```

- [ ] **Step 3: Implement EdgeStemAnchor.computeWorld**

File: `packages/flutter_box_transform/lib/src/anchors/anchor.dart`

Replace `EdgeStemAnchor.computeWorld` body:

```dart
@override
Offset computeWorld(Rect rect, double rotation, Size handleSize, HandleAlignment alignment) {
  // Edge midpoint (unrotated).
  final Offset midLocal;
  Offset outwardLocal;
  switch (from) {
    case Side.top:    midLocal = Offset(rect.center.dx, rect.top);    outwardLocal = const Offset(0, -1); break;
    case Side.right:  midLocal = Offset(rect.right,     rect.center.dy); outwardLocal = const Offset(1, 0);  break;
    case Side.bottom: midLocal = Offset(rect.center.dx, rect.bottom); outwardLocal = const Offset(0, 1);  break;
    case Side.left:   midLocal = Offset(rect.left,      rect.center.dy); outwardLocal = const Offset(-1, 0); break;
  }

  // Apply rotation.
  final Offset midWorld = rotation == 0
      ? midLocal
      : _rotateAround(midLocal, rect.center, rotation);
  final Offset outwardWorld = rotation == 0
      ? outwardLocal
      : _rotateAround(outwardLocal, Offset.zero, rotation);

  // Anchor center = midpoint + outward * distance.
  final Offset anchorCenter = midWorld + outwardWorld * distance;

  // Handle top-left = anchor center - handleSize/2 (alignment is currently informational
  // for stem anchors; both inside/outside collapse to center because the stem distance
  // already controls offset).
  return anchorCenter - Offset(handleSize.width / 2, handleSize.height / 2);
}
```

- [ ] **Step 4: Run test, expect pass**

```bash
flutter test test/anchors/edge_stem_anchor_test.dart
```

- [ ] **Step 5: Commit**

```bash
git add packages/flutter_box_transform/lib/src/anchors/anchor.dart \
        packages/flutter_box_transform/test/anchors/edge_stem_anchor_test.dart
git commit -m "feat(anchors): implement EdgeStemAnchor.computeWorld"
```

---

## Task 6: CustomAnchor

**Files:**
- Test: `packages/flutter_box_transform/test/anchors/custom_anchor_test.dart`

(CustomAnchor is already implemented in Task 2; this task adds tests and verifies pass-through.)

- [ ] **Step 1: Write the test**

File: `packages/flutter_box_transform/test/anchors/custom_anchor_test.dart`

```dart
import 'dart:ui';

import 'package:flutter_box_transform/src/anchors/anchor.dart';
import 'package:flutter_test/flutter_test.dart';

void main() {
  group('CustomAnchor', () {
    test('forwards arguments to user function and returns its result', () {
      Rect? receivedRect;
      double? receivedRotation;
      Size? receivedSize;
      HandleAlignment? receivedAlignment;

      final anchor = CustomAnchor((rect, rotation, size, alignment) {
        receivedRect = rect;
        receivedRotation = rotation;
        receivedSize = size;
        receivedAlignment = alignment;
        return const Offset(42, 99);
      });

      const rect = Rect.fromLTWH(0, 0, 100, 50);
      const size = Size(24, 24);
      final out = anchor.computeWorld(rect, 1.5, size, HandleAlignment.outside);

      expect(out, const Offset(42, 99));
      expect(receivedRect, rect);
      expect(receivedRotation, 1.5);
      expect(receivedSize, size);
      expect(receivedAlignment, HandleAlignment.outside);
    });
  });
}
```

- [ ] **Step 2: Run test, expect pass (already implemented in Task 2)**

```bash
flutter test test/anchors/custom_anchor_test.dart
```

Expected: 1 test passes.

- [ ] **Step 3: Commit**

```bash
git add packages/flutter_box_transform/test/anchors/custom_anchor_test.dart
git commit -m "test(anchors): add CustomAnchor pass-through test"
```

---

## Task 7: TransformAdjustment sealed hierarchy

**Files:**
- Create: `packages/flutter_box_transform/lib/src/policies/transform_adjustment.dart`
- Test: `packages/flutter_box_transform/test/policies/transform_adjustment_test.dart`

- [ ] **Step 1: Write the failing test**

File: `packages/flutter_box_transform/test/policies/transform_adjustment_test.dart`

```dart
import 'package:flutter_box_transform/src/policies/transform_adjustment.dart';
import 'package:flutter_test/flutter_test.dart';

void main() {
  group('TransformAdjustment sealed hierarchy', () {
    test('SnapAdjustment carries snap fields', () {
      const a = SnapAdjustment(
        source: 'snap-canvas',
        axis: SnapAxis.x,
        target: SnapTarget.canvasEdge,
        snappedFromValue: 5,
        snappedToValue: 0,
        targetCoordinate: 0,
      );
      expect(a.axis, SnapAxis.x);
      expect(a.target, SnapTarget.canvasEdge);
      expect(a.snappedFromValue, 5);
      expect(a.snappedToValue, 0);
    });

    test('MagnetAdjustment carries magnet fields', () {
      const a = MagnetAdjustment(
        source: 'magnet',
        magnetWorld: Offset(100, 100),
        pullStrength: 0.7,
        distance: 12,
      );
      expect(a.magnetWorld, const Offset(100, 100));
      expect(a.pullStrength, 0.7);
      expect(a.distance, 12);
    });

    test('ConstraintAdjustment carries constraint kind', () {
      const a = ConstraintAdjustment(
        source: 'aspect',
        kind: ConstraintKind.userAspectRatio,
      );
      expect(a.kind, ConstraintKind.userAspectRatio);
    });

    test('exhaustive switch compiles for all variants', () {
      const TransformAdjustment a = SnapAdjustment(
        source: 's',
        axis: SnapAxis.y,
        target: SnapTarget.center,
        snappedFromValue: 0,
        snappedToValue: 1,
        targetCoordinate: 1,
      );
      // Sealed switch — compile fails if a new variant is added without updating.
      final label = switch (a) {
        SnapAdjustment()       => 'snap',
        MagnetAdjustment()     => 'magnet',
        ConstraintAdjustment() => 'constraint',
      };
      expect(label, 'snap');
    });
  });
}
```

- [ ] **Step 2: Run test, expect failure**

```bash
flutter test test/policies/transform_adjustment_test.dart
```

- [ ] **Step 3: Implement TransformAdjustment hierarchy**

File: `packages/flutter_box_transform/lib/src/policies/transform_adjustment.dart`

```dart
import 'dart:ui';

/// Axis along which a snap occurred.
enum SnapAxis { x, y, rotation }

/// What the snap aligned to.
enum SnapTarget { canvasEdge, siblingEdge, center, angle, gridCell }

/// What kind of constraint was applied.
enum ConstraintKind { userAspectRatio, customConstraint }

/// A typed record of one adjustment a TransformPolicy made on a transform delta.
sealed class TransformAdjustment {
  /// The policy.policyKey that emitted this adjustment.
  final Object source;
  const TransformAdjustment({required this.source});
}

class SnapAdjustment extends TransformAdjustment {
  final SnapAxis axis;
  final SnapTarget target;
  final double snappedFromValue;
  final double snappedToValue;
  final double targetCoordinate;

  const SnapAdjustment({
    required super.source,
    required this.axis,
    required this.target,
    required this.snappedFromValue,
    required this.snappedToValue,
    required this.targetCoordinate,
  });
}

class MagnetAdjustment extends TransformAdjustment {
  final Offset magnetWorld;
  final double pullStrength;
  final double distance;

  const MagnetAdjustment({
    required super.source,
    required this.magnetWorld,
    required this.pullStrength,
    required this.distance,
  });
}

class ConstraintAdjustment extends TransformAdjustment {
  final ConstraintKind kind;

  const ConstraintAdjustment({
    required super.source,
    required this.kind,
  });
}
```

- [ ] **Step 4: Run test, expect pass**

```bash
flutter test test/policies/transform_adjustment_test.dart
```

- [ ] **Step 5: Add export and commit**

File: `packages/flutter_box_transform/lib/flutter_box_transform.dart`

Add:
```dart
export 'src/policies/transform_adjustment.dart';
```

```bash
git add packages/flutter_box_transform/lib/src/policies/transform_adjustment.dart \
        packages/flutter_box_transform/test/policies/transform_adjustment_test.dart \
        packages/flutter_box_transform/lib/flutter_box_transform.dart
git commit -m "feat(policies): add TransformAdjustment sealed hierarchy"
```

---

## Task 8: TransformInput data type with testFixture

**Files:**
- Create: `packages/flutter_box_transform/lib/src/policies/transform_input.dart`
- Test: `packages/flutter_box_transform/test/policies/transform_input_test.dart`
- Modify: `packages/flutter_box_transform/test/helpers/test_fixtures.dart` (add TransformInput.testFixture helper)

- [ ] **Step 1: Write the failing test**

File: `packages/flutter_box_transform/test/policies/transform_input_test.dart`

```dart
import 'package:box_transform/box_transform.dart';
import 'package:flutter/widgets.dart';
import 'package:flutter_box_transform/src/policies/transform_adjustment.dart';
import 'package:flutter_box_transform/src/policies/transform_input.dart';
import 'package:flutter_test/flutter_test.dart';

import '../helpers/test_fixtures.dart';

void main() {
  group('TransformInput', () {
    test('default fixture is a valid TransformInput', () {
      final i = TransformInputFixture.defaults();
      expect(i.kind, TransformKind.drag);
      expect(i.proposedRect, isNotNull);
      expect(i.upstreamAdjustments, isEmpty);
    });

    test('copyWith replaces only the named fields', () {
      final original = TransformInputFixture.defaults();
      final modified = original.copyWith(
        proposedRect: const Rect.fromLTWH(99, 99, 50, 50),
        upstreamAdjustments: const [
          SnapAdjustment(
            source: 'x', axis: SnapAxis.x, target: SnapTarget.canvasEdge,
            snappedFromValue: 1, snappedToValue: 0, targetCoordinate: 0,
          ),
        ],
      );
      expect(modified.proposedRect, const Rect.fromLTWH(99, 99, 50, 50));
      expect(modified.upstreamAdjustments, hasLength(1));
      expect(modified.kind, original.kind); // unchanged
      expect(modified.currentRect, original.currentRect); // unchanged
    });
  });
}
```

- [ ] **Step 2: Run test, expect failure**

```bash
flutter test test/policies/transform_input_test.dart
```

- [ ] **Step 3: Implement TransformInput**

File: `packages/flutter_box_transform/lib/src/policies/transform_input.dart`

```dart
import 'dart:ui';

import 'package:box_transform/box_transform.dart';
import 'package:flutter/gestures.dart';
import 'package:flutter/widgets.dart';

import 'transform_adjustment.dart';

/// What sort of transform produced this input.
enum TransformKind { resize, drag, rotate, scale, programmatic }

/// One unit of input fed into the policy chain.
///
/// [proposedRect] / [proposedRotation] / [proposedFlip] are CONSTRAINT-RESPECTING:
/// the engine math has already enforced [clampingRect] and [constraints]. Policies
/// see these and may modify them; any policy-induced violation of constraints is
/// caught by a hidden safety re-clamp after the chain.
class TransformInput {
  final TransformKind kind;
  final Rect proposedRect;
  final double proposedRotation;
  final Flip proposedFlip;
  final Rect gestureStartRect;
  final double gestureStartRotation;
  final Rect currentRect;
  final double currentRotation;
  final Rect clampingRect;
  final BoxConstraints constraints;
  final HandlePosition? sourceHandle;
  final PointerDeviceKind? sourceDevice;
  final Object? gestureId;
  final List<TransformAdjustment> upstreamAdjustments;

  const TransformInput({
    required this.kind,
    required this.proposedRect,
    required this.proposedRotation,
    required this.proposedFlip,
    required this.gestureStartRect,
    required this.gestureStartRotation,
    required this.currentRect,
    required this.currentRotation,
    required this.clampingRect,
    required this.constraints,
    required this.upstreamAdjustments,
    this.sourceHandle,
    this.sourceDevice,
    this.gestureId,
  });

  TransformInput copyWith({
    TransformKind? kind,
    Rect? proposedRect,
    double? proposedRotation,
    Flip? proposedFlip,
    Rect? gestureStartRect,
    double? gestureStartRotation,
    Rect? currentRect,
    double? currentRotation,
    Rect? clampingRect,
    BoxConstraints? constraints,
    HandlePosition? sourceHandle,
    PointerDeviceKind? sourceDevice,
    Object? gestureId,
    List<TransformAdjustment>? upstreamAdjustments,
  }) {
    return TransformInput(
      kind: kind ?? this.kind,
      proposedRect: proposedRect ?? this.proposedRect,
      proposedRotation: proposedRotation ?? this.proposedRotation,
      proposedFlip: proposedFlip ?? this.proposedFlip,
      gestureStartRect: gestureStartRect ?? this.gestureStartRect,
      gestureStartRotation: gestureStartRotation ?? this.gestureStartRotation,
      currentRect: currentRect ?? this.currentRect,
      currentRotation: currentRotation ?? this.currentRotation,
      clampingRect: clampingRect ?? this.clampingRect,
      constraints: constraints ?? this.constraints,
      sourceHandle: sourceHandle ?? this.sourceHandle,
      sourceDevice: sourceDevice ?? this.sourceDevice,
      gestureId: gestureId ?? this.gestureId,
      upstreamAdjustments: upstreamAdjustments ?? this.upstreamAdjustments,
    );
  }
}
```

- [ ] **Step 4: Add TransformInputFixture to test helpers**

File: `packages/flutter_box_transform/test/helpers/test_fixtures.dart`

Append:

```dart
import 'package:box_transform/box_transform.dart';
import 'package:flutter/widgets.dart';
import 'package:flutter_box_transform/src/policies/transform_input.dart';

class TransformInputFixture {
  /// Returns a TransformInput with reasonable defaults for tests.
  /// Override fields with [TransformInput.copyWith].
  static TransformInput defaults({
    TransformKind kind = TransformKind.drag,
    Rect rect = const Rect.fromLTWH(100, 100, 200, 200),
    double rotation = 0,
    Rect clampingRect = const Rect.fromLTWH(0, 0, 1000, 800),
  }) {
    return TransformInput(
      kind: kind,
      proposedRect: rect,
      proposedRotation: rotation,
      proposedFlip: Flip.none,
      gestureStartRect: rect,
      gestureStartRotation: rotation,
      currentRect: rect,
      currentRotation: rotation,
      clampingRect: clampingRect,
      constraints: const BoxConstraints(),
      upstreamAdjustments: const [],
    );
  }
}
```

- [ ] **Step 5: Run test, expect pass**

```bash
flutter test test/policies/transform_input_test.dart
```

- [ ] **Step 6: Add export and commit**

Add to `flutter_box_transform.dart`:

```dart
export 'src/policies/transform_input.dart';
```

```bash
git add packages/flutter_box_transform/lib/src/policies/transform_input.dart \
        packages/flutter_box_transform/test/policies/transform_input_test.dart \
        packages/flutter_box_transform/test/helpers/test_fixtures.dart \
        packages/flutter_box_transform/lib/flutter_box_transform.dart
git commit -m "feat(policies): add TransformInput data type and test fixture"
```

---

## Task 9: TransformOutput with passthrough constructor

**Files:**
- Create: `packages/flutter_box_transform/lib/src/policies/transform_output.dart`
- Test: `packages/flutter_box_transform/test/policies/transform_output_test.dart`

- [ ] **Step 1: Write the failing test**

File: `packages/flutter_box_transform/test/policies/transform_output_test.dart`

```dart
import 'package:box_transform/box_transform.dart';
import 'package:flutter_box_transform/src/policies/transform_input.dart';
import 'package:flutter_box_transform/src/policies/transform_output.dart';
import 'package:flutter_test/flutter_test.dart';

import '../helpers/test_fixtures.dart';

void main() {
  group('TransformOutput', () {
    test('passthrough copies proposed values from input', () {
      final input = TransformInputFixture.defaults();
      final out = TransformOutput.passthrough(input);
      expect(out.rect, input.proposedRect);
      expect(out.rotation, input.proposedRotation);
      expect(out.flip, input.proposedFlip);
      expect(out.adjustments, isEmpty);
    });

    test('explicit constructor accepts adjustments list', () {
      final input = TransformInputFixture.defaults();
      final out = TransformOutput(
        rect: input.proposedRect,
        rotation: 0,
        flip: Flip.none,
        adjustments: const [],
      );
      expect(out.rect, input.proposedRect);
    });
  });
}
```

- [ ] **Step 2: Run test, expect failure**

```bash
flutter test test/policies/transform_output_test.dart
```

- [ ] **Step 3: Implement TransformOutput**

File: `packages/flutter_box_transform/lib/src/policies/transform_output.dart`

```dart
import 'dart:ui';

import 'package:box_transform/box_transform.dart';

import 'transform_adjustment.dart';
import 'transform_input.dart';

class TransformOutput {
  final Rect rect;
  final double rotation;
  final Flip flip;
  final List<TransformAdjustment> adjustments;

  const TransformOutput({
    required this.rect,
    required this.rotation,
    required this.flip,
    required this.adjustments,
  });

  /// A passthrough output — a policy chose not to adjust this input.
  factory TransformOutput.passthrough(TransformInput input) {
    return TransformOutput(
      rect: input.proposedRect,
      rotation: input.proposedRotation,
      flip: input.proposedFlip,
      adjustments: const [],
    );
  }
}
```

- [ ] **Step 4: Run test, expect pass**

```bash
flutter test test/policies/transform_output_test.dart
```

- [ ] **Step 5: Add export and commit**

Add to `flutter_box_transform.dart`:

```dart
export 'src/policies/transform_output.dart';
```

```bash
git add packages/flutter_box_transform/lib/src/policies/transform_output.dart \
        packages/flutter_box_transform/test/policies/transform_output_test.dart \
        packages/flutter_box_transform/lib/flutter_box_transform.dart
git commit -m "feat(policies): add TransformOutput data type"
```

---

## Task 10: TransformPolicy abstract base

**Files:**
- Create: `packages/flutter_box_transform/lib/src/policies/transform_policy.dart`
- Test: `packages/flutter_box_transform/test/policies/transform_policy_test.dart`

- [ ] **Step 1: Write the failing test**

File: `packages/flutter_box_transform/test/policies/transform_policy_test.dart`

```dart
import 'package:flutter_box_transform/src/policies/transform_input.dart';
import 'package:flutter_box_transform/src/policies/transform_output.dart';
import 'package:flutter_box_transform/src/policies/transform_policy.dart';
import 'package:flutter_test/flutter_test.dart';

import '../helpers/test_fixtures.dart';

class _IdentityPolicy extends TransformPolicy {
  const _IdentityPolicy();

  @override
  TransformOutput apply(TransformInput input) => TransformOutput.passthrough(input);
}

class _ShiftRightPolicy extends TransformPolicy {
  const _ShiftRightPolicy();

  @override
  TransformOutput apply(TransformInput input) {
    return TransformOutput(
      rect: input.proposedRect.translate(10, 0),
      rotation: input.proposedRotation,
      flip: input.proposedFlip,
      adjustments: const [],
    );
  }
}

void main() {
  group('TransformPolicy abstract', () {
    test('subclass must implement apply', () {
      const policy = _IdentityPolicy();
      final input = TransformInputFixture.defaults();
      final out = policy.apply(input);
      expect(out.rect, input.proposedRect);
    });

    test('default policyKey is runtimeType', () {
      const policy = _IdentityPolicy();
      expect(policy.policyKey, _IdentityPolicy);
    });

    test('subclass can mutate proposed rect', () {
      const policy = _ShiftRightPolicy();
      final input = TransformInputFixture.defaults(
        rect: const Rect.fromLTWH(0, 0, 100, 100),
      );
      final out = policy.apply(input);
      expect(out.rect, const Rect.fromLTWH(10, 0, 100, 100));
    });
  });
}
```

- [ ] **Step 2: Run test, expect failure**

```bash
flutter test test/policies/transform_policy_test.dart
```

- [ ] **Step 3: Implement TransformPolicy**

File: `packages/flutter_box_transform/lib/src/policies/transform_policy.dart`

```dart
import 'transform_input.dart';
import 'transform_output.dart';

/// Marker for the bindings interface a TransformPolicy receives at attach time.
/// Filled in v1.0 controller phase; placeholder here.
abstract class PolicyBindings {}

abstract class TransformPolicy {
  const TransformPolicy();

  /// Stable identity for ordering/equality/debug.
  Object get policyKey => runtimeType;

  /// Apply the policy. Must be idempotent on its own input
  /// (apply(apply(x)) == apply(x)).
  TransformOutput apply(TransformInput input);

  /// Optional lifecycle hook for stateful policies.
  void attach(PolicyBindings bindings) {}
  void detach() {}
}
```

- [ ] **Step 4: Run test, expect pass**

```bash
flutter test test/policies/transform_policy_test.dart
```

- [ ] **Step 5: Add export and commit**

Add to `flutter_box_transform.dart`:

```dart
export 'src/policies/transform_policy.dart';
```

```bash
git add packages/flutter_box_transform/lib/src/policies/transform_policy.dart \
        packages/flutter_box_transform/test/policies/transform_policy_test.dart \
        packages/flutter_box_transform/lib/flutter_box_transform.dart
git commit -m "feat(policies): add TransformPolicy abstract base"
```

---

## Task 11: ScaleContribution with merge

**Files:**
- Create: `packages/flutter_box_transform/lib/src/behaviors/scale_contribution.dart`
- Test: `packages/flutter_box_transform/test/behaviors/scale_contribution_test.dart`

- [ ] **Step 1: Write the failing test**

File: `packages/flutter_box_transform/test/behaviors/scale_contribution_test.dart`

```dart
import 'dart:ui';

import 'package:flutter_box_transform/src/behaviors/scale_contribution.dart';
import 'package:flutter_test/flutter_test.dart';

void main() {
  group('ScaleContribution', () {
    test('none has all-null fields', () {
      const c = ScaleContribution.none;
      expect(c.focalDelta, isNull);
      expect(c.scaleDelta, isNull);
      expect(c.rotationDelta, isNull);
    });

    test('merge: null and null → null per axis', () {
      const a = ScaleContribution.none;
      const b = ScaleContribution.none;
      final m = a.merge(b);
      expect(m.focalDelta, isNull);
      expect(m.scaleDelta, isNull);
      expect(m.rotationDelta, isNull);
    });

    test('merge: value and null → value per axis (no overwrite with null)', () {
      const a = ScaleContribution(
        focalDelta: Offset(10, 5),
        scaleDelta: 1.5,
        rotationDelta: 0.1,
      );
      const b = ScaleContribution.none;
      final m = a.merge(b);
      expect(m.focalDelta, const Offset(10, 5));
      expect(m.scaleDelta, 1.5);
      expect(m.rotationDelta, 0.1);
    });

    test('merge: focalDelta sums additively', () {
      const a = ScaleContribution(focalDelta: Offset(10, 5));
      const b = ScaleContribution(focalDelta: Offset(3, 2));
      final m = a.merge(b);
      expect(m.focalDelta, const Offset(13, 7));
    });

    test('merge: scaleDelta multiplies (1.5 × 0.8 = 1.2)', () {
      const a = ScaleContribution(scaleDelta: 1.5);
      const b = ScaleContribution(scaleDelta: 0.8);
      final m = a.merge(b);
      expect(m.scaleDelta, closeTo(1.2, 1e-9));
    });

    test('merge: rotationDelta sums additively', () {
      const a = ScaleContribution(rotationDelta: 0.1);
      const b = ScaleContribution(rotationDelta: 0.2);
      final m = a.merge(b);
      expect(m.rotationDelta, closeTo(0.3, 1e-9));
    });
  });
}
```

- [ ] **Step 2: Run test, expect failure**

```bash
flutter test test/behaviors/scale_contribution_test.dart
```

- [ ] **Step 3: Implement ScaleContribution**

File: `packages/flutter_box_transform/lib/src/behaviors/scale_contribution.dart`

```dart
import 'dart:ui';

/// One BodyBehavior's per-frame contribution to a body-coalition scale gesture.
///
/// The body-coalition merges all behaviors' contributions into a single combined
/// call to controller.proposeScaleUpdate per frame:
/// - focalDelta sums additively across behaviors (pure translation).
/// - scaleDelta multiplies (compositional scale).
/// - rotationDelta sums additively (rotation around the focal point).
///
/// A null channel means "this behavior is not contributing to that axis"; merging
/// a value with null keeps the value.
class ScaleContribution {
  final Offset? focalDelta;
  final double? scaleDelta;
  final double? rotationDelta;

  const ScaleContribution({
    this.focalDelta,
    this.scaleDelta,
    this.rotationDelta,
  });

  static const ScaleContribution none = ScaleContribution();

  /// Merge another contribution into this one.
  /// Translation is summed, scale is multiplied, rotation is summed.
  /// Null means "no contribution to that axis."
  ScaleContribution merge(ScaleContribution other) {
    return ScaleContribution(
      focalDelta: _mergeOffset(focalDelta, other.focalDelta),
      scaleDelta: _mergeScale(scaleDelta, other.scaleDelta),
      rotationDelta: _mergeRotation(rotationDelta, other.rotationDelta),
    );
  }

  static Offset? _mergeOffset(Offset? a, Offset? b) {
    if (a == null) return b;
    if (b == null) return a;
    return a + b;
  }

  static double? _mergeScale(double? a, double? b) {
    if (a == null) return b;
    if (b == null) return a;
    return a * b;
  }

  static double? _mergeRotation(double? a, double? b) {
    if (a == null) return b;
    if (b == null) return a;
    return a + b;
  }
}
```

- [ ] **Step 4: Run test, expect pass**

```bash
flutter test test/behaviors/scale_contribution_test.dart
```

- [ ] **Step 5: Add export and commit**

Add to `flutter_box_transform.dart`:

```dart
export 'src/behaviors/scale_contribution.dart';
```

```bash
git add packages/flutter_box_transform/lib/src/behaviors/scale_contribution.dart \
        packages/flutter_box_transform/test/behaviors/scale_contribution_test.dart \
        packages/flutter_box_transform/lib/flutter_box_transform.dart
git commit -m "feat(behaviors): add ScaleContribution with merge semantics"
```

---

## Task 12: RecognizerInterest sealed hierarchy

**Files:**
- Create: `packages/flutter_box_transform/lib/src/behaviors/recognizer_interest.dart`
- Test: `packages/flutter_box_transform/test/behaviors/recognizer_interest_test.dart`

- [ ] **Step 1: Write the failing test**

File: `packages/flutter_box_transform/test/behaviors/recognizer_interest_test.dart`

```dart
import 'package:flutter/gestures.dart';
import 'package:flutter_box_transform/src/behaviors/recognizer_interest.dart';
import 'package:flutter_box_transform/src/behaviors/scale_contribution.dart';
import 'package:flutter_test/flutter_test.dart';

void main() {
  group('RecognizerInterest sealed hierarchy', () {
    test('ScaleInterest stores callbacks', () {
      ScaleStartDetails? startSeen;
      final i = ScaleInterest(
        onStart: (d) { startSeen = d; return ScaleContribution.none; },
      );
      expect(i.onStart, isNotNull);
      expect(i.onUpdate, isNull);
      expect(i.onEnd, isNull);
    });

    test('PanInterest stores callbacks', () {
      final i = PanInterest(onStart: (_) {}, onUpdate: (_) {}, onEnd: (_) {});
      expect(i.onStart, isNotNull);
      expect(i.onUpdate, isNotNull);
      expect(i.onEnd, isNotNull);
    });

    test('TapInterest, LongPressInterest, DoubleTapInterest construct', () {
      expect(const TapInterest(), isA<TapInterest>());
      expect(const LongPressInterest(), isA<LongPressInterest>());
      expect(const DoubleTapInterest(), isA<DoubleTapInterest>());
    });

    test('exhaustive sealed switch compiles', () {
      const RecognizerInterest i = TapInterest();
      final label = switch (i) {
        ScaleInterest()      => 'scale',
        PanInterest()        => 'pan',
        TapInterest()        => 'tap',
        LongPressInterest()  => 'long-press',
        DoubleTapInterest()  => 'double-tap',
      };
      expect(label, 'tap');
    });
  });
}
```

- [ ] **Step 2: Run test, expect failure**

```bash
flutter test test/behaviors/recognizer_interest_test.dart
```

- [ ] **Step 3: Implement RecognizerInterest**

File: `packages/flutter_box_transform/lib/src/behaviors/recognizer_interest.dart`

```dart
import 'package:flutter/gestures.dart';

import 'scale_contribution.dart';

sealed class RecognizerInterest {
  const RecognizerInterest();
}

/// Behaviors register a ScaleInterest to participate in body-coalition scale
/// gestures (pinch + rotate + pan-via-focalDelta). Callbacks return a
/// [ScaleContribution] that the body-coalition merges per frame into a single
/// combined call to the controller.
class ScaleInterest extends RecognizerInterest {
  final ScaleContribution Function(ScaleStartDetails)? onStart;
  final ScaleContribution Function(ScaleUpdateDetails)? onUpdate;
  final ScaleContribution Function(ScaleEndDetails)? onEnd;

  const ScaleInterest({this.onStart, this.onUpdate, this.onEnd});
}

/// Behaviors register a PanInterest for single-pointer pan-only gestures
/// (cursor body-drag). Cannot coexist on the same device with ScaleInterest.
class PanInterest extends RecognizerInterest {
  final void Function(DragStartDetails)? onStart;
  final void Function(DragUpdateDetails)? onUpdate;
  final void Function(DragEndDetails)? onEnd;

  const PanInterest({this.onStart, this.onUpdate, this.onEnd});
}

class TapInterest extends RecognizerInterest {
  final void Function(TapDownDetails)? onTapDown;
  final void Function(TapUpDetails)? onTapUp;
  final VoidCallback? onTap;
  final VoidCallback? onTapCancel;

  const TapInterest({this.onTapDown, this.onTapUp, this.onTap, this.onTapCancel});
}

class LongPressInterest extends RecognizerInterest {
  final void Function(LongPressStartDetails)? onStart;
  final void Function(LongPressMoveUpdateDetails)? onMoveUpdate;
  final void Function(LongPressEndDetails)? onEnd;

  const LongPressInterest({this.onStart, this.onMoveUpdate, this.onEnd});
}

class DoubleTapInterest extends RecognizerInterest {
  final VoidCallback? onDoubleTap;

  const DoubleTapInterest({this.onDoubleTap});
}
```

- [ ] **Step 4: Run test, expect pass**

```bash
flutter test test/behaviors/recognizer_interest_test.dart
```

- [ ] **Step 5: Add export and commit**

Add to `flutter_box_transform.dart`:

```dart
export 'src/behaviors/recognizer_interest.dart';
```

```bash
git add packages/flutter_box_transform/lib/src/behaviors/recognizer_interest.dart \
        packages/flutter_box_transform/test/behaviors/recognizer_interest_test.dart \
        packages/flutter_box_transform/lib/flutter_box_transform.dart
git commit -m "feat(behaviors): add RecognizerInterest sealed hierarchy"
```

---

## Task 13: ControllerEvent sealed hierarchy

**Files:**
- Create: `packages/flutter_box_transform/lib/src/controller/controller_event.dart`
- Test: `packages/flutter_box_transform/test/controller/controller_event_test.dart`

- [ ] **Step 1: Write the failing test**

File: `packages/flutter_box_transform/test/controller/controller_event_test.dart`

```dart
import 'dart:ui';

import 'package:flutter_box_transform/src/controller/controller_event.dart';
import 'package:flutter_box_transform/src/policies/transform_adjustment.dart';
import 'package:flutter_box_transform/src/policies/transform_input.dart';
import 'package:flutter_box_transform/src/policies/transform_output.dart';
import 'package:box_transform/box_transform.dart';
import 'package:flutter_test/flutter_test.dart';

void main() {
  group('ControllerEvent sealed hierarchy', () {
    test('TransformStartEvent constructs with kind, rect, rotation', () {
      final e = TransformStartEvent(
        source: 'box',
        timestamp: DateTime(2026, 4, 27),
        kind: TransformKind.drag,
        rect: const Rect.fromLTWH(0, 0, 100, 100),
        rotation: 0,
      );
      expect(e.kind, TransformKind.drag);
    });

    test('TransformAppliedEvent carries TransformOutput', () {
      final out = TransformOutput(
        rect: const Rect.fromLTWH(0, 0, 100, 100),
        rotation: 0,
        flip: Flip.none,
        adjustments: const [],
      );
      final e = TransformAppliedEvent(
        source: 'box',
        timestamp: DateTime.now(),
        output: out,
      );
      expect(e.output, out);
    });

    test('exhaustive switch compiles for all variants', () {
      final ControllerEvent e = TransformStartEvent(
        source: 'box',
        timestamp: DateTime.now(),
        kind: TransformKind.drag,
        rect: Rect.zero,
        rotation: 0,
      );
      final label = switch (e) {
        TransformStartEvent()    => 'start',
        TransformUpdateEvent()   => 'update',
        TransformEndEvent()      => 'end',
        TransformCancelEvent()   => 'cancel',
        TransformAppliedEvent()  => 'applied',
        TerminalEdgeEvent()      => 'terminal',
      };
      expect(label, 'start');
    });
  });
}
```

- [ ] **Step 2: Run test, expect failure**

```bash
flutter test test/controller/controller_event_test.dart
```

- [ ] **Step 3: Implement ControllerEvent**

File: `packages/flutter_box_transform/lib/src/controller/controller_event.dart`

```dart
import 'dart:ui';

import '../policies/transform_adjustment.dart';
import '../policies/transform_input.dart';
import '../policies/transform_output.dart';

/// Typed events emitted by [TransformableBoxController] to ObserverBehaviors.
sealed class ControllerEvent {
  final Object source;
  final DateTime timestamp;
  const ControllerEvent({required this.source, required this.timestamp});
}

class TransformStartEvent extends ControllerEvent {
  final TransformKind kind;
  final Rect rect;
  final double rotation;
  const TransformStartEvent({
    required super.source,
    required super.timestamp,
    required this.kind,
    required this.rect,
    required this.rotation,
  });
}

class TransformUpdateEvent extends ControllerEvent {
  final TransformKind kind;
  final Rect prevRect;
  final Rect newRect;
  final double prevRotation;
  final double newRotation;
  final List<TransformAdjustment> adjustments;
  const TransformUpdateEvent({
    required super.source,
    required super.timestamp,
    required this.kind,
    required this.prevRect,
    required this.newRect,
    required this.prevRotation,
    required this.newRotation,
    required this.adjustments,
  });
}

class TransformEndEvent extends ControllerEvent {
  final TransformKind kind;
  const TransformEndEvent({
    required super.source,
    required super.timestamp,
    required this.kind,
  });
}

class TransformCancelEvent extends ControllerEvent {
  final TransformKind kind;
  const TransformCancelEvent({
    required super.source,
    required super.timestamp,
    required this.kind,
  });
}

class TransformAppliedEvent extends ControllerEvent {
  final TransformOutput output;
  const TransformAppliedEvent({
    required super.source,
    required super.timestamp,
    required this.output,
  });
}

class TerminalEdgeEvent extends ControllerEvent {
  final bool minWidthReached;
  final bool maxWidthReached;
  final bool minHeightReached;
  final bool maxHeightReached;
  const TerminalEdgeEvent({
    required super.source,
    required super.timestamp,
    required this.minWidthReached,
    required this.maxWidthReached,
    required this.minHeightReached,
    required this.maxHeightReached,
  });
}
```

- [ ] **Step 4: Run test, expect pass**

```bash
flutter test test/controller/controller_event_test.dart
```

- [ ] **Step 5: Add export and commit**

Add to `flutter_box_transform.dart`:

```dart
export 'src/controller/controller_event.dart';
```

```bash
git add packages/flutter_box_transform/lib/src/controller/controller_event.dart \
        packages/flutter_box_transform/test/controller/controller_event_test.dart \
        packages/flutter_box_transform/lib/flutter_box_transform.dart
git commit -m "feat(controller): add ControllerEvent sealed hierarchy"
```

---

## Task 14: BoxBehavior abstract base + 4 abstract subtypes (full contracts)

**Files:**
- Create: `packages/flutter_box_transform/lib/src/behaviors/box_behavior.dart`
- Create: `packages/flutter_box_transform/lib/src/behaviors/handle_build_context.dart`
- Create: `packages/flutter_box_transform/lib/src/behaviors/overlay_layer.dart`
- Test: `packages/flutter_box_transform/test/behaviors/box_behavior_test.dart`

> Defines the FULL abstract contracts (anchor, build, recognizers, layer, etc.) per the spec. Phase 2 concrete classes will implement these without changes to the base contracts.

- [ ] **Step 1: Write the failing test**

File: `packages/flutter_box_transform/test/behaviors/box_behavior_test.dart`

```dart
import 'package:flutter/gestures.dart';
import 'package:flutter/widgets.dart';
import 'package:flutter_box_transform/src/anchors/anchor.dart';
import 'package:flutter_box_transform/src/anchors/corner.dart';
import 'package:flutter_box_transform/src/behaviors/box_behavior.dart';
import 'package:flutter_box_transform/src/behaviors/box_behavior_bindings.dart';
import 'package:flutter_box_transform/src/behaviors/handle_build_context.dart';
import 'package:flutter_box_transform/src/behaviors/overlay_layer.dart';
import 'package:flutter_box_transform/src/behaviors/recognizer_interest.dart';
import 'package:flutter_test/flutter_test.dart';

class _StubHandle extends HandleBehavior {
  const _StubHandle({super.devices});
  @override
  Anchor get anchor => const CornerAnchor(Corner.topLeft);
  @override
  Widget build(BuildContext context, HandleBuildContext ctx, BoxBehaviorBindings b) =>
      const SizedBox.shrink();
}

class _StubBody extends BodyBehavior {
  const _StubBody({super.devices});
  @override
  List<RecognizerInterest> recognizers(BoxBehaviorBindings bindings) => const [];
}

class _StubObserver extends ObserverBehavior {
  const _StubObserver({super.devices});
}

class _StubOverlay extends OverlayBehavior {
  const _StubOverlay({super.devices});
  @override
  OverlayLayer get layer => OverlayLayer.aboveHandles;
  @override
  Widget build(BuildContext context, BoxBehaviorBindings bindings) =>
      const SizedBox.shrink();
}

void main() {
  group('BoxBehavior hierarchy', () {
    test('all four subtypes inherit from BoxBehavior', () {
      expect(const _StubHandle(), isA<BoxBehavior>());
      expect(const _StubBody(), isA<BoxBehavior>());
      expect(const _StubObserver(), isA<BoxBehavior>());
      expect(const _StubOverlay(), isA<BoxBehavior>());
    });

    test('default devices is null (= all devices)', () {
      expect(const _StubHandle().devices, isNull);
    });

    test('explicit devices filter is preserved', () {
      const h = _StubHandle(devices: {PointerDeviceKind.mouse});
      expect(h.devices, {PointerDeviceKind.mouse});
    });

    test('default behaviorKey is runtimeType', () {
      expect(const _StubHandle().behaviorKey, _StubHandle);
    });

    test('HandleBehavior requires anchor and build', () {
      const h = _StubHandle();
      expect(h.anchor, isA<CornerAnchor>());
    });

    test('BodyBehavior requires recognizers; default usesPan/Scale = false', () {
      const b = _StubBody();
      expect(b.usesPanRecognizer, false);
      expect(b.usesScaleRecognizer, false);
      expect(b.shouldClaim(_DummyPointerDownEvent(), _NullBindings()), true);
    });

    test('OverlayBehavior requires layer and build', () {
      const o = _StubOverlay();
      expect(o.layer, OverlayLayer.aboveHandles);
    });

    test('ObserverBehavior pointer/controller events default to no-op', () {
      const o = _StubObserver();
      expect(() => o.onPointerEvent(_DummyPointerDownEvent(), _NullBindings()),
          returnsNormally);
    });
  });
}

class _DummyPointerDownEvent extends PointerDownEvent {
  _DummyPointerDownEvent() : super(position: Offset.zero);
}

class _NullBindings implements BoxBehaviorBindings {
  @override
  noSuchMethod(Invocation i) => null;
}
```

- [ ] **Step 2: Run test, expect failure**

```bash
flutter test test/behaviors/box_behavior_test.dart
```

- [ ] **Step 3: Implement HandleBuildContext**

File: `packages/flutter_box_transform/lib/src/behaviors/handle_build_context.dart`

```dart
import 'dart:ui';

import '../anchors/anchor.dart';

/// State a [HandleBehavior] receives at build time.
class HandleBuildContext {
  final Rect boxRect;
  final double rotation;
  final bool selected;
  final bool hovered;
  final bool pressed;
  final HandleAlignment alignment;
  final double tapSize;
  final double visualSize;

  const HandleBuildContext({
    required this.boxRect,
    required this.rotation,
    required this.selected,
    required this.hovered,
    required this.pressed,
    required this.alignment,
    required this.tapSize,
    required this.visualSize,
  });
}
```

- [ ] **Step 4: Implement OverlayLayer**

File: `packages/flutter_box_transform/lib/src/behaviors/overlay_layer.dart`

```dart
/// Z-order slot for [OverlayBehavior]s.
enum OverlayLayer {
  /// Below handle widgets (e.g. selection ring drawn under handles).
  belowHandles,

  /// Above handle widgets (e.g. dimension readout pill).
  aboveHandles;
}
```

- [ ] **Step 5: Implement BoxBehavior + 4 subtypes (full abstract contracts)**

File: `packages/flutter_box_transform/lib/src/behaviors/box_behavior.dart`

```dart
import 'package:flutter/gestures.dart';
import 'package:flutter/widgets.dart';

import '../anchors/anchor.dart';
import 'box_behavior_bindings.dart';
import 'handle_build_context.dart';
import 'overlay_layer.dart';
import 'recognizer_interest.dart';
import '../controller/controller_event.dart';

/// Base for all box plugins.
///
/// Concrete plugins extend one of the four category subtypes:
/// [HandleBehavior], [BodyBehavior], [ObserverBehavior], or [OverlayBehavior].
abstract class BoxBehavior {
  final Set<PointerDeviceKind>? devices;
  const BoxBehavior({this.devices});

  /// Stable identity for hot-reload, equality, debug.
  Object get behaviorKey => runtimeType;

  void attach(BoxBehaviorBindings bindings) {}
  void detach() {}
}

/// Visual + own gesture, spatial-priority handle.
abstract class HandleBehavior extends BoxBehavior {
  const HandleBehavior({super.devices});

  /// Where this handle anchors on the box.
  Anchor get anchor;

  /// Build the handle widget, including its own gesture detector(s).
  Widget build(BuildContext context, HandleBuildContext ctx, BoxBehaviorBindings bindings);
}

/// Recognizer factory participating in the body coalition.
abstract class BodyBehavior extends BoxBehavior {
  const BodyBehavior({super.devices});

  /// Recognizer interests this behavior wants the body coalition to wire up.
  /// The package coalesces interests by recognizer kind; multiple ScaleInterests
  /// merge into one ScaleGestureRecognizer with fan-out callbacks.
  List<RecognizerInterest> recognizers(BoxBehaviorBindings bindings);

  /// Pre-flight veto. Called per pointer-down before the body coalition
  /// joins the gesture arena. The coalition claims if ANY active body behavior
  /// returns true; declines if ALL return false. Default: true.
  bool shouldClaim(PointerEvent down, BoxBehaviorBindings bindings) => true;

  /// Whether this body behavior contributes a Pan recognizer interest.
  /// Used at config-construction time to detect Pan/Scale conflicts.
  bool get usesPanRecognizer => false;

  /// Whether this body behavior contributes a Scale recognizer interest.
  /// Used at config-construction time to detect Pan/Scale conflicts.
  bool get usesScaleRecognizer => false;
}

/// Passive watcher of pointer + controller events. Never claims gestures.
abstract class ObserverBehavior extends BoxBehavior {
  const ObserverBehavior({super.devices});

  /// Called for every pointer event in the box's region, before any
  /// GestureDetector or RawGestureDetector sees it. Wrapped in a [Listener]
  /// at the box root.
  void onPointerEvent(PointerEvent event, BoxBehaviorBindings bindings) {}

  /// Called for typed controller events (transform start/update/end,
  /// adjustments applied, terminal edges hit, etc.).
  void onControllerEvent(ControllerEvent event, BoxBehaviorBindings bindings) {}
}

/// Pure paint, no gestures.
abstract class OverlayBehavior extends BoxBehavior {
  const OverlayBehavior({super.devices});

  /// Z-order layer for this overlay.
  OverlayLayer get layer;

  /// Build the overlay widget. Wrapped in [IgnorePointer] by the package.
  Widget build(BuildContext context, BoxBehaviorBindings bindings);
}
```

- [ ] **Step 6: Implement BoxBehaviorBindings stub (filled in Task 15)**

File: `packages/flutter_box_transform/lib/src/behaviors/box_behavior_bindings.dart`

```dart
/// Interface a behavior receives at attach time. Filled in Task 15 with
/// concrete getters; stub here so BoxBehavior compiles.
abstract class BoxBehaviorBindings {}
```

- [ ] **Step 7: Run test, expect pass**

```bash
flutter test test/behaviors/box_behavior_test.dart
```

- [ ] **Step 8: Add exports and commit**

Add to `flutter_box_transform.dart`:

```dart
export 'src/behaviors/box_behavior.dart';
export 'src/behaviors/box_behavior_bindings.dart';
export 'src/behaviors/handle_build_context.dart';
export 'src/behaviors/overlay_layer.dart';
```

```bash
git add packages/flutter_box_transform/lib/src/behaviors/box_behavior.dart \
        packages/flutter_box_transform/lib/src/behaviors/box_behavior_bindings.dart \
        packages/flutter_box_transform/lib/src/behaviors/handle_build_context.dart \
        packages/flutter_box_transform/lib/src/behaviors/overlay_layer.dart \
        packages/flutter_box_transform/test/behaviors/box_behavior_test.dart \
        packages/flutter_box_transform/lib/flutter_box_transform.dart
git commit -m "feat(behaviors): add BoxBehavior base and 4 abstract subtypes (full contracts)"
```

---

## Task 15: Complete BoxBehaviorBindings + FakeBoxBehaviorBindings

**Files:**
- Modify: `packages/flutter_box_transform/lib/src/behaviors/box_behavior_bindings.dart`
- Modify: `packages/flutter_box_transform/test/helpers/fake_box_behavior_bindings.dart`
- Test: `packages/flutter_box_transform/test/behaviors/box_behavior_bindings_test.dart`

> Bindings exposes [TransformableBoxController] when the controller is implemented in Phase 3. For Phase 1 we use a forward-declared abstract `ControllerHandle` interface with the methods/getters Phase 1 tests need; the real controller will implement it.

- [ ] **Step 1: Write the failing test**

File: `packages/flutter_box_transform/test/behaviors/box_behavior_bindings_test.dart`

```dart
import 'dart:ui';

import 'package:flutter/foundation.dart';
import 'package:flutter/gestures.dart';
import 'package:flutter_box_transform/src/behaviors/box_behavior_bindings.dart';
import 'package:flutter_test/flutter_test.dart';

import '../helpers/fake_box_behavior_bindings.dart';

void main() {
  group('FakeBoxBehaviorBindings', () {
    test('exposes activeDevice, isEnabled, isHovered, clampingRect', () {
      final fake = FakeBoxBehaviorBindings(
        activeDevice: PointerDeviceKind.touch,
        isEnabled: ValueNotifier(true),
        isHovered: ValueNotifier(false),
        clampingRect: const Rect.fromLTWH(0, 0, 1000, 800),
      );
      expect(fake.activeDevice, PointerDeviceKind.touch);
      expect(fake.isEnabled.value, true);
      expect(fake.isHovered.value, false);
      expect(fake.clampingRect, const Rect.fromLTWH(0, 0, 1000, 800));
    });

    test('requestRebuild captures call count', () {
      final fake = FakeBoxBehaviorBindings(
        activeDevice: PointerDeviceKind.touch,
        isEnabled: ValueNotifier(true),
        isHovered: ValueNotifier(false),
        clampingRect: Rect.zero,
      );
      expect(fake.rebuildRequestCount, 0);
      fake.requestRebuild();
      fake.requestRebuild();
      expect(fake.rebuildRequestCount, 2);
    });
  });
}
```

- [ ] **Step 2: Run test, expect failure**

```bash
flutter test test/behaviors/box_behavior_bindings_test.dart
```

- [ ] **Step 3: Implement BoxBehaviorBindings interface**

File: `packages/flutter_box_transform/lib/src/behaviors/box_behavior_bindings.dart`

Replace stub with:

```dart
import 'dart:ui';

import 'package:flutter/foundation.dart';
import 'package:flutter/gestures.dart';
import 'package:flutter/scheduler.dart';

/// Forward-declared interface for the controller handle a behavior receives.
/// The real [TransformableBoxController] (Phase 3) implements this.
abstract class ControllerHandle {
  Rect get rect;
  double get rotation;
  // Methods grow in Phase 3. Phase 1 only needs read access.
}

/// What a behavior gets at attach time and during build/event callbacks.
abstract class BoxBehaviorBindings {
  ControllerHandle get controller;
  PointerDeviceKind get activeDevice;
  ValueListenable<bool> get isEnabled;
  ValueListenable<bool> get isHovered;
  Rect get clampingRect;
  TickerProvider get vsync;

  /// Cause the box widget to rebuild (used when a behavior's internal state
  /// changes in a way that affects its painted output).
  void requestRebuild();
}
```

- [ ] **Step 4: Implement FakeBoxBehaviorBindings**

File: `packages/flutter_box_transform/test/helpers/fake_box_behavior_bindings.dart`

Replace stub with:

```dart
import 'dart:ui';

import 'package:flutter/foundation.dart';
import 'package:flutter/gestures.dart';
import 'package:flutter/scheduler.dart';
import 'package:flutter_box_transform/src/behaviors/box_behavior_bindings.dart';

class _FakeControllerHandle implements ControllerHandle {
  @override
  Rect rect;
  @override
  double rotation;
  _FakeControllerHandle({
    this.rect = Rect.zero,
    this.rotation = 0,
  });
}

class _FakeTickerProvider implements TickerProvider {
  @override
  Ticker createTicker(TickerCallback onTick) => Ticker(onTick);
}

class FakeBoxBehaviorBindings implements BoxBehaviorBindings {
  @override
  final PointerDeviceKind activeDevice;
  @override
  final ValueListenable<bool> isEnabled;
  @override
  final ValueListenable<bool> isHovered;
  @override
  final Rect clampingRect;
  @override
  final ControllerHandle controller;
  @override
  final TickerProvider vsync = _FakeTickerProvider();

  int rebuildRequestCount = 0;

  FakeBoxBehaviorBindings({
    required this.activeDevice,
    required this.isEnabled,
    required this.isHovered,
    required this.clampingRect,
    ControllerHandle? controller,
  }) : controller = controller ?? _FakeControllerHandle();

  @override
  void requestRebuild() {
    rebuildRequestCount++;
  }
}
```

- [ ] **Step 5: Run test, expect pass**

```bash
flutter test test/behaviors/box_behavior_bindings_test.dart
```

- [ ] **Step 6: Commit**

```bash
git add packages/flutter_box_transform/lib/src/behaviors/box_behavior_bindings.dart \
        packages/flutter_box_transform/test/helpers/fake_box_behavior_bindings.dart \
        packages/flutter_box_transform/test/behaviors/box_behavior_bindings_test.dart
git commit -m "feat(behaviors): complete BoxBehaviorBindings interface and fake"
```

---

## Task 16: BoxBehaviorConfig — additive merge + Pan/Scale assertion

**Files:**
- Create: `packages/flutter_box_transform/lib/src/behaviors/box_behavior_config.dart`
- Test: `packages/flutter_box_transform/test/behaviors/box_behavior_config_test.dart`

- [ ] **Step 1: Write the failing test**

File: `packages/flutter_box_transform/test/behaviors/box_behavior_config_test.dart`

```dart
import 'package:flutter/gestures.dart';
import 'package:flutter_box_transform/src/behaviors/box_behavior.dart';
import 'package:flutter_box_transform/src/behaviors/box_behavior_config.dart';
import 'package:flutter_test/flutter_test.dart';

class _TestHandleA extends HandleBehavior {
  const _TestHandleA({super.devices});
}
class _TestHandleB extends HandleBehavior {
  const _TestHandleB({super.devices});
}

class _PanBody extends BodyBehavior {
  const _PanBody({super.devices});
  @override bool get usesPanRecognizer => true;
}

class _ScaleBody extends BodyBehavior {
  const _ScaleBody({super.devices});
  @override bool get usesScaleRecognizer => true;
}

void main() {
  group('BoxBehaviorConfig.effectiveBehaviorsForDevice', () {
    test('shared-only config: every device gets the same list', () {
      const cfg = BoxBehaviorConfig(shared: [_TestHandleA()]);
      expect(cfg.effectiveBehaviorsForDevice(PointerDeviceKind.mouse), hasLength(1));
      expect(cfg.effectiveBehaviorsForDevice(PointerDeviceKind.touch), hasLength(1));
    });

    test('perDevice adds to shared additively for that device', () {
      const cfg = BoxBehaviorConfig(
        shared: [_TestHandleA()],
        perDevice: {
          PointerDeviceKind.mouse: [_TestHandleB()],
        },
      );
      expect(cfg.effectiveBehaviorsForDevice(PointerDeviceKind.mouse), hasLength(2));
      expect(cfg.effectiveBehaviorsForDevice(PointerDeviceKind.touch), hasLength(1));
    });

    test('behavior-level devices filter narrows further', () {
      const cfg = BoxBehaviorConfig(
        shared: [_TestHandleA(devices: {PointerDeviceKind.mouse})],
      );
      expect(cfg.effectiveBehaviorsForDevice(PointerDeviceKind.mouse), hasLength(1));
      expect(cfg.effectiveBehaviorsForDevice(PointerDeviceKind.touch), hasLength(0));
    });

    test('null devices on a behavior means all devices', () {
      const cfg = BoxBehaviorConfig(shared: [_TestHandleA(devices: null)]);
      expect(cfg.effectiveBehaviorsForDevice(PointerDeviceKind.mouse), hasLength(1));
      expect(cfg.effectiveBehaviorsForDevice(PointerDeviceKind.touch), hasLength(1));
      expect(cfg.effectiveBehaviorsForDevice(PointerDeviceKind.stylus), hasLength(1));
    });
  });

  group('BoxBehaviorConfig Pan/Scale conflict assertion', () {
    test('mixing PanBody and ScaleBody on touch throws AssertionError', () {
      expect(
        () => BoxBehaviorConfig(
          perDevice: {
            PointerDeviceKind.touch: [_PanBody(), _ScaleBody()],
          },
        ),
        throwsA(isA<AssertionError>()),
      );
    });

    test('Pan-only on touch is fine', () {
      expect(
        () => const BoxBehaviorConfig(
          perDevice: {
            PointerDeviceKind.touch: [_PanBody()],
          },
        ),
        returnsNormally,
      );
    });

    test('Scale-only on touch is fine', () {
      expect(
        () => const BoxBehaviorConfig(
          perDevice: {
            PointerDeviceKind.touch: [_ScaleBody()],
          },
        ),
        returnsNormally,
      );
    });

    test('Pan on mouse and Scale on touch is fine (different devices)', () {
      expect(
        () => const BoxBehaviorConfig(
          perDevice: {
            PointerDeviceKind.mouse: [_PanBody()],
            PointerDeviceKind.touch: [_ScaleBody()],
          },
        ),
        returnsNormally,
      );
    });

    test('Pan in shared + Scale in perDevice on same device throws', () {
      expect(
        () => const BoxBehaviorConfig(
          shared: [_PanBody()],
          perDevice: {
            PointerDeviceKind.touch: [_ScaleBody()],
          },
        ),
        throwsA(isA<AssertionError>()),
      );
    });
  });
}
```

- [ ] **Step 2: Run test, expect failure**

```bash
flutter test test/behaviors/box_behavior_config_test.dart
```

- [ ] **Step 3: Implement BoxBehaviorConfig**

File: `packages/flutter_box_transform/lib/src/behaviors/box_behavior_config.dart`

```dart
import 'package:flutter/foundation.dart';
import 'package:flutter/gestures.dart';

import 'box_behavior.dart';

/// Configuration object for a [TransformableBox]'s plugin behaviors.
///
/// Behaviors are merged additively: every device gets [shared] PLUS the
/// device-specific entry in [perDevice] (if any). A behavior is only active
/// for a device if its own [BoxBehavior.devices] filter (null = all) includes
/// that device.
@immutable
class BoxBehaviorConfig {
  final List<BoxBehavior> shared;
  final Map<PointerDeviceKind, List<BoxBehavior>> perDevice;

  const BoxBehaviorConfig({
    this.shared = const [],
    this.perDevice = const {},
  });

  /// All behaviors that should be active for [device].
  ///
  /// Effective list = (shared ∪ perDevice[device]) filtered by each behavior's
  /// own [BoxBehavior.devices] filter.
  List<BoxBehavior> effectiveBehaviorsForDevice(PointerDeviceKind device) {
    final out = <BoxBehavior>[];
    for (final b in shared) {
      if (_appliesToDevice(b, device)) out.add(b);
    }
    final perDev = perDevice[device];
    if (perDev != null) {
      for (final b in perDev) {
        if (_appliesToDevice(b, device)) out.add(b);
      }
    }
    return List.unmodifiable(out);
  }

  static bool _appliesToDevice(BoxBehavior b, PointerDeviceKind device) {
    return b.devices == null || b.devices!.contains(device);
  }

  /// Constructor with conflict assertions.
  ///
  /// Asserts that no device has both Pan-using and Scale-using BodyBehaviors —
  /// they conflict in Flutter's gesture arena. Caught at construction time.
  void _assertNoConflicts() {
    assert(() {
      // Compute the closed set of devices appearing anywhere in the config.
      final touched = <PointerDeviceKind>{};
      for (final b in shared) {
        if (b.devices == null) {
          touched.addAll(PointerDeviceKind.values);
        } else {
          touched.addAll(b.devices!);
        }
      }
      touched.addAll(perDevice.keys);

      for (final d in touched) {
        final eff = effectiveBehaviorsForDevice(d);
        final hasPan = eff.any((b) => b is BodyBehavior && b.usesPanRecognizer);
        final hasScale = eff.any((b) => b is BodyBehavior && b.usesScaleRecognizer);
        if (hasPan && hasScale) {
          throw AssertionError(
            'Cannot mix Pan-using and Scale-using BodyBehaviors on $d — '
            'Flutter\'s gesture arena does not allow both. '
            'Pick one (typically BodyDrag for cursor-only configs, '
            'BodyTransform for touch with pinch+twist).',
          );
        }
      }
      return true;
    }());
  }
}

/// Const-friendly factory wrapper that runs the conflict assertion.
/// Use this in tests/runtime to ensure construction triggers checks.
extension BoxBehaviorConfigChecks on BoxBehaviorConfig {
  /// Re-checks Pan/Scale conflicts. Called automatically when the
  /// TransformableBox widget consumes the config; tests can call it directly.
  void checkConflicts() => _assertNoConflicts();
}
```

Wait — `const` constructors can't run runtime assertions. Need to make the constructor non-const OR run checks lazily. Pick non-const for safety:

Replace constructor block with:

```dart
@immutable
class BoxBehaviorConfig {
  final List<BoxBehavior> shared;
  final Map<PointerDeviceKind, List<BoxBehavior>> perDevice;

  /// Construct a config. Runs assertion checks for Pan/Scale conflicts in
  /// debug builds.
  BoxBehaviorConfig({
    this.shared = const [],
    this.perDevice = const {},
  }) {
    _assertNoConflicts();
  }
  // ... rest as above ...
}
```

Tests that use `const BoxBehaviorConfig(...)` need to drop the `const`. Update the test file accordingly.

- [ ] **Step 4: Update tests to remove `const` from BoxBehaviorConfig constructor calls**

In `test/behaviors/box_behavior_config_test.dart`, replace every `const BoxBehaviorConfig(...)` with `BoxBehaviorConfig(...)` (drop `const`).

- [ ] **Step 5: Run test, expect pass**

```bash
flutter test test/behaviors/box_behavior_config_test.dart
```

- [ ] **Step 6: Add export and commit**

Add to `flutter_box_transform.dart`:

```dart
export 'src/behaviors/box_behavior_config.dart';
```

```bash
git add packages/flutter_box_transform/lib/src/behaviors/box_behavior_config.dart \
        packages/flutter_box_transform/test/behaviors/box_behavior_config_test.dart \
        packages/flutter_box_transform/lib/flutter_box_transform.dart
git commit -m "feat(behaviors): add BoxBehaviorConfig with merge and conflict assertion"
```

---

## Task 17: Capture v0.4.7 byte-equivalence baselines

**Files:**
- Create: `packages/flutter_box_transform/test/widget/byte_equivalence_baselines_test.dart`
- Create (via `--update-goldens`): golden files under `packages/flutter_box_transform/test/widget/baselines/`

> **Purpose:** This test pumps the existing v0.4.7 `TransformableBox` with a representative set of configurations and captures rendered goldens. These goldens are the frozen baseline that Phase 2's refactor must match. Phase 1 ends with the goldens captured and committed; Phase 2 will run the same tests *without* `--update-goldens` and the byte-equivalence guarantee is the test passing.

- [ ] **Step 1: Write the test (capture mode initially)**

File: `packages/flutter_box_transform/test/widget/byte_equivalence_baselines_test.dart`

```dart
import 'dart:ui';

import 'package:box_transform/box_transform.dart';
import 'package:flutter/material.dart';
import 'package:flutter_box_transform/flutter_box_transform.dart';
import 'package:flutter_test/flutter_test.dart';

/// Configurations chosen to cover the most-impactful v0.4.x widget-tree variants.
/// Phase 2's refactored TransformableBox must produce byte-equivalent output for
/// every entry below. If a regression is introduced, one of these goldens fails.
final List<_Config> _baselineConfigs = [
  _Config(
    name: 'default',
    rotatable: false,
    resizable: true,
    draggable: true,
    handleAlignment: HandleAlignment.center,
  ),
  _Config(
    name: 'rotatable',
    rotatable: true,
    resizable: true,
    draggable: true,
    handleAlignment: HandleAlignment.center,
  ),
  _Config(
    name: 'no-resize',
    rotatable: false,
    resizable: false,
    draggable: true,
    handleAlignment: HandleAlignment.center,
  ),
  _Config(
    name: 'no-drag',
    rotatable: false,
    resizable: true,
    draggable: false,
    handleAlignment: HandleAlignment.center,
  ),
  _Config(
    name: 'inside-aligned',
    rotatable: false,
    resizable: true,
    draggable: true,
    handleAlignment: HandleAlignment.inside,
  ),
  _Config(
    name: 'outside-aligned',
    rotatable: false,
    resizable: true,
    draggable: true,
    handleAlignment: HandleAlignment.outside,
  ),
  _Config(
    name: 'corners-only',
    rotatable: false,
    resizable: true,
    draggable: true,
    handleAlignment: HandleAlignment.center,
    visibleHandles: const {
      HandlePosition.topLeft,
      HandlePosition.topRight,
      HandlePosition.bottomLeft,
      HandlePosition.bottomRight,
    },
    enabledHandles: const {
      HandlePosition.topLeft,
      HandlePosition.topRight,
      HandlePosition.bottomLeft,
      HandlePosition.bottomRight,
    },
  ),
  _Config(
    name: 'rotated-30deg',
    rotatable: true,
    resizable: true,
    draggable: true,
    handleAlignment: HandleAlignment.center,
    rotation: 0.5236, // ~30°
  ),
];

void main() {
  group('byte-equivalence baselines (v0.4.7 frozen)', () {
    for (final cfg in _baselineConfigs) {
      testWidgets(cfg.name, (tester) async {
        await tester.pumpWidget(
          MaterialApp(
            home: Scaffold(
              backgroundColor: Colors.white,
              body: SizedBox(
                width: 600,
                height: 600,
                child: Stack(
                  children: [
                    TransformableBox(
                      contentBuilder: (context, rect, flip) =>
                          Container(color: Colors.blue),
                      rect: const Rect.fromLTWH(150, 150, 300, 300),
                      rotation: cfg.rotation,
                      rotatable: cfg.rotatable,
                      resizable: cfg.resizable,
                      draggable: cfg.draggable,
                      handleAlignment: cfg.handleAlignment,
                      visibleHandles: cfg.visibleHandles,
                      enabledHandles: cfg.enabledHandles,
                    ),
                  ],
                ),
              ),
            ),
          ),
        );
        await tester.pumpAndSettle();
        await expectLater(
          find.byType(MaterialApp),
          matchesGoldenFile('baselines/${cfg.name}.png'),
        );
      });
    }
  });
}

class _Config {
  final String name;
  final bool rotatable;
  final bool resizable;
  final bool draggable;
  final HandleAlignment handleAlignment;
  final double rotation;
  final Set<HandlePosition> visibleHandles;
  final Set<HandlePosition> enabledHandles;

  const _Config({
    required this.name,
    required this.rotatable,
    required this.resizable,
    required this.draggable,
    required this.handleAlignment,
    this.rotation = 0,
    this.visibleHandles = const {...HandlePosition.values},
    this.enabledHandles = const {...HandlePosition.values},
  });
}
```

- [ ] **Step 2: Capture goldens**

```bash
cd packages/flutter_box_transform
flutter test test/widget/byte_equivalence_baselines_test.dart --update-goldens
```

Expected: 8 PNG files appear under `test/widget/baselines/`.

- [ ] **Step 3: Verify capture is stable (re-run without --update-goldens)**

```bash
flutter test test/widget/byte_equivalence_baselines_test.dart
```

Expected: all 8 tests pass (goldens match captured PNGs).

- [ ] **Step 4: Commit baselines**

```bash
git add packages/flutter_box_transform/test/widget/byte_equivalence_baselines_test.dart \
        packages/flutter_box_transform/test/widget/baselines/
git commit -m "test: capture v0.4.7 byte-equivalence baseline goldens"
```

---

## Task 18: Run full Phase 1 test suite + final commit

- [ ] **Step 1: Run all tests**

```bash
cd packages/flutter_box_transform
flutter test
```

Expected: all existing tests pass + all new Phase 1 tests pass.

- [ ] **Step 2: Run analyzer**

```bash
flutter analyze
```

Expected: no warnings or errors in new code.

- [ ] **Step 3: Verify nothing user-visible has changed**

The existing `TransformableBox` widget tree is unchanged in Phase 1. Run the example app:

```bash
cd ../../example
flutter run
```

Expected: app behavior is identical to v0.4.7. (Manual smoke check: drag, resize, rotate if available.)

- [ ] **Step 4: Final commit (if any uncommitted work) and tag the foundation milestone**

```bash
cd packages/flutter_box_transform
git status # should be clean
git tag v1.0.0-phase-1
git log --oneline -20 # confirm task commits are linear and clean
```

---

## What Phase 1 leaves us with

- New types compile and have unit-test coverage: `Anchor`, `BoxBehavior` + 4 subtypes, `BoxBehaviorBindings`, `BoxBehaviorConfig` (with merge + conflict assertion), `RecognizerInterest` sealed hierarchy, `ScaleContribution` with merge, `TransformInput`, `TransformOutput`, `TransformAdjustment`, `TransformPolicy`, `ControllerEvent`.
- Test infrastructure scaffolded: `test_fixtures.dart`, `FakeBoxBehaviorBindings`, helper directories.
- 8 frozen v0.4.7 byte-equivalence golden baselines committed under `test/widget/baselines/`. Phase 2's refactor of `TransformableBox` will run against these and they're the cursor-sacred guarantee.
- Existing widget behavior is unchanged. No regressions possible because no existing files were touched.
- `flutter_box_transform.dart` library export gains 13 new export lines for the new types.

## What Phase 1 does NOT include (deferred to later phases)

- Concrete `HandleBehavior` implementations (Phase 2)
- `BoxBehaviorConfig.classic()` factory and other convenience constructors (Phase 2)
- `TransformableBox` widget refactor to consume behaviors (Phase 2)
- Concrete `BodyBehavior` implementations (`BodyDrag`, `BodyTransform`) (Phase 4)
- Concrete `TransformPolicy` implementations (snap, magnet, grid, etc.) (Phase 5)
- Controller v1.0 changes (`propose*` rename, policy chain wiring, event emission) (Phase 3)
- `enabled: ValueListenable<bool>` migration on `TransformableBox` (Phase 3)
- `dart fix` codemod (Phase 3)
- Mutation testing setup (Phase 6)

---

## Self-review notes

**Spec coverage (Phase 1 scope):**
- ✅ `BoxBehavior` 4-category type hierarchy with full abstract contracts (anchor/build/recognizers/layer/onPointer/onController) — Task 14
- ✅ `HandleBuildContext` and `OverlayLayer` types — Task 14
- ✅ `BoxBehaviorBindings` interface — Task 15
- ✅ `BoxBehaviorConfig` with additive merge + Pan/Scale conflict assertion — Task 16
- ✅ `Anchor` sealed type with 4 variants — Tasks 2, 3, 4, 5, 6
- ✅ `RecognizerInterest` sealed hierarchy — Task 12
- ✅ `ScaleContribution` with merge semantics — Task 11
- ✅ `TransformInput` / `TransformOutput` / `TransformAdjustment` / `TransformPolicy` — Tasks 7, 8, 9, 10
- ✅ `ControllerEvent` sealed hierarchy — Task 13
- ✅ Byte-equivalence baselines captured — Task 17

**Type consistency check:**
- `BoxBehavior.devices` is `Set<PointerDeviceKind>?` everywhere ✓
- `Anchor.computeWorld(rect, rotation, handleSize, alignment)` signature matches spec ✓
- `ScaleContribution.merge` semantics: focal+, scale*, rotation+ — matches spec ✓
- `BoxBehaviorConfig` uses `shared:` and `perDevice:` field names per spec ✓

**Placeholder scan:** none — every step has concrete code or commands.

**Scope check:** focused on foundation types only; no widget refactors; existing behavior preserved by construction (no existing files modified).
