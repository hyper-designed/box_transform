import 'dart:developer';
import 'dart:math' hide log;

import 'package:vector_math/vector_math_64.dart';

import 'enums.dart';
import 'geometry.dart';
import 'helpers.dart';
import 'resizers/resizer.dart';
import 'result.dart';
import 'rotated_clamping_solver.dart';

/// A class that transforms a [Box] in several different supported forms.
class BoxTransformer {
  /// A private constructor to prevent instantiation.
  const BoxTransformer._();

  /// Rotations smaller than this in absolute value are treated as zero and
  /// take the axis-aligned fast path. At this magnitude the difference
  /// between the rotated and unrotated rect is sub-ULP for any practical
  /// box dimensions, so the visual outcome is identical and we save the LP
  /// solver cost. Float intermediates from animation tweens routinely land
  /// in this range when interpolating to or through zero.
  static const double _kRotationEpsilon = 1e-9;

  // Per-isolate scratch buffers reused by the rotated-resize hot path. Both
  // the inequality batch and the projection result are mutable bags reused
  // across calls so the solver never allocates on the steady-state path.
  // Resize is called O(60-120 Hz) on a single isolate; sharing scratch
  // is safe (Dart isolates are single-threaded) and saves ~256 B/call.
  static final IneqBuffer _ineqScratch = IneqBuffer();
  static final FlatProjection _projScratch = FlatProjection();

  /// Moves the given [initialRect] with given [initialLocalPosition] of the
  /// mouse cursor and wherever [localPosition] of the mouse cursor is
  /// currently at.
  ///
  /// The [clampingRect] is the rect that the [initialRect] is not allowed
  /// to go outside of when dragging or resizing.
  ///
  /// [bindingStrategy] controls which corners are enforced against the
  /// clamp at nonzero [rotation]:
  ///
  /// * [BindingStrategy.boundingBox]: the four rotated rect corners stay
  ///   inside the clamp (the rendered footprint cannot poke out).
  /// * [BindingStrategy.originalBox]: the four unrotated rect corners stay
  ///   inside the clamp (the logical rect stays in; rotated corners may
  ///   extend outside).
  ///
  /// Ignored when [rotation] is 0 — the axis-aligned branch always clamps
  /// against the unrotated rect.
  static RawMoveResult move({
    required Box initialRect,
    required Vector2 initialLocalPosition,
    required Vector2 localPosition,
    Box clampingRect = Box.largest,
    double rotation = 0.0,
    BindingStrategy bindingStrategy = BindingStrategy.boundingBox,
  }) {
    final Vector2 delta = localPosition - initialLocalPosition;

    if (rotation.abs() < _kRotationEpsilon) {
      final Box unclampedRect = initialRect.translate(delta.x, delta.y);
      final Box clampedRect = clampingRect.containOther(unclampedRect);
      final Vector2 clampedDelta = clampedRect.topLeft - initialRect.topLeft;
      final Box newRect = initialRect.translate(clampedDelta.x, clampedDelta.y);
      return MoveResult(
        rect: newRect,
        oldRect: initialRect,
        delta: delta,
        rawSize: newRect.size,
        largestRect: clampingRect,
        rotation: rotation,
        boundingRect: rotation == 0.0
            ? null
            : ClampHelpers.calculateBoundingRect(newRect),
        oldBoundingRect: rotation == 0.0
            ? null
            : ClampHelpers.calculateBoundingRect(initialRect),
      );
    }

    // Rotated move. Translation of a rotated rect preserves rotation;
    // clamping reduces to "find tx, ty such that each of the 4 corners
    // stays in clampingRect". Which four corners are enforced depends on
    // [bindingStrategy]:
    //
    //  * boundingBox: the rendered rotated rect's four corners must stay
    //    in the clamp. Offsets use the rotated basis (cos, sin).
    //  * originalBox: the unrotated rect's four corners must stay in the
    //    clamp. The rendered rotated corners MAY extend outside. Offsets
    //    are axis-aligned (cos=1, sin=0 effectively).
    //
    // Per-corner bounds on (tx, ty) are linear in either case.
    final w = initialRect.width;
    final h = initialRect.height;
    final cx0 = initialRect.left + w / 2;
    final cy0 = initialRect.top + h / 2;
    // boundingBox: enforce the rotated quad's four corners only. The
    // rendered footprint stays in the clamp; the unrotated stored rect
    // is invisible storage and need not also be in the clamp. (Adding
    // the unrotated corners as a second constraint set was an earlier
    // attempt to guard against degenerate post-flip geometries where
    // h≈0 or w≈0; for non-degenerate boxes, which `minWidth` and
    // `minHeight` enforce, the unrotated corners are strictly tighter
    // than the rotated AABB on whichever axis they extend further
    // along, which contradicts the boundingBox semantic of "rendered
    // AABB stays in the clamp".)
    //
    // originalBox: enforce the unrotated rect's four axis-aligned
    // corners. Rotated corners may extend outside the clamp.
    final List<Vector2> offsets;
    if (bindingStrategy == BindingStrategy.boundingBox) {
      final c = cos(rotation);
      final s = sin(rotation);
      offsets = <Vector2>[
        Vector2(-w / 2 * c - (-h / 2) * s, -w / 2 * s + (-h / 2) * c),
        Vector2(w / 2 * c - (-h / 2) * s, w / 2 * s + (-h / 2) * c),
        Vector2(w / 2 * c - h / 2 * s, w / 2 * s + h / 2 * c),
        Vector2(-w / 2 * c - h / 2 * s, -w / 2 * s + h / 2 * c),
      ];
    } else {
      offsets = <Vector2>[
        Vector2(-w / 2, -h / 2),
        Vector2(w / 2, -h / 2),
        Vector2(w / 2, h / 2),
        Vector2(-w / 2, h / 2),
      ];
    }
    // Compute the GLOBAL feasible interval for (tx, ty) rather than
    // applying per-corner constraints sequentially. Sequential max/min is
    // order-dependent when the constraint system is empty (the clamp is
    // tighter than the rotated bounding rect, even by a hair of float
    // precision): opposite corners push tx in opposing directions and the
    // last corner visited wins, flicking the box past the clamp.
    double txMin = double.negativeInfinity;
    double txMax = double.infinity;
    double tyMin = double.negativeInfinity;
    double tyMax = double.infinity;
    for (final off in offsets) {
      final left = clampingRect.left - (cx0 + off.x);
      final right = clampingRect.right - (cx0 + off.x);
      final top = clampingRect.top - (cy0 + off.y);
      final bottom = clampingRect.bottom - (cy0 + off.y);
      if (left > txMin) txMin = left;
      if (right < txMax) txMax = right;
      if (top > tyMin) tyMin = top;
      if (bottom < tyMax) tyMax = bottom;
    }
    // Sanitise empty intervals: at saturation the feasible region can be a
    // single point. Float precision may invert the bounds; collapse to the
    // midpoint so the delta.clamp below is well-ordered and semantically
    // correct (no order-dependent flick).
    if (txMin > txMax) {
      final mid = (txMin + txMax) / 2;
      txMin = mid;
      txMax = mid;
    }
    if (tyMin > tyMax) {
      final mid = (tyMin + tyMax) / 2;
      tyMin = mid;
      tyMax = mid;
    }
    final double tx = delta.x.clamp(txMin, txMax).toDouble();
    final double ty = delta.y.clamp(tyMin, tyMax).toDouble();
    final clampedRect = Box.fromLTRB(
      initialRect.left + tx,
      initialRect.top + ty,
      initialRect.right + tx,
      initialRect.bottom + ty,
      rotation: rotation,
    );
    return MoveResult(
      rect: clampedRect,
      oldRect: initialRect,
      delta: Vector2(tx, ty),
      rawSize: clampedRect.size,
      largestRect: clampingRect,
      rotation: rotation,
      boundingRect: ClampHelpers.calculateBoundingRect(clampedRect),
      oldBoundingRect: ClampHelpers.calculateBoundingRect(initialRect),
    );
  }

  /// Resizes the given [initialRect] with given [initialLocalPosition] of
  /// the mouse cursor and wherever [localPosition] of the mouse cursor is
  /// currently at.
  ///
  /// Specifying the [handle] and [resizeMode] will determine how the
  /// [initialRect] will be resized.
  ///
  /// The [initialFlip] helps determine the initial state of the rectangle.
  ///
  /// The [clampingRect] is the rect that the [initialRect] is not allowed
  /// to go outside of when dragging or resizing.
  ///
  /// The [constraints] is the constraints that the [initialRect] is not allowed
  /// to shrink or grow beyond.
  static RawResizeResult resize({
    required Box initialRect,
    required Vector2 initialLocalPosition,
    required Vector2 localPosition,
    required HandlePosition handle,
    required ResizeMode resizeMode,
    required Flip initialFlip,
    Box clampingRect = Box.largest,
    Constraints constraints = const Constraints.unconstrained(),
    bool allowFlipping = true,
    double rotation = 0.0,
    BindingStrategy bindingStrategy = BindingStrategy.boundingBox,
  }) {
    // NOTE: this uses strict `!= 0.0` rather than the rotation epsilon used
    // by `move()`. The AA path is now actually *faster* than the LP path
    // post-roundToPrecision fix, but extending the epsilon bypass here would
    // also require re-wrapping the resizer's rotation=0 result Box with the
    // input rotation to preserve the contract `result.rect.rotation == input
    // rotation`. Left as a future optimization for sub-epsilon rotations,
    // which only arise from animation tweens rounding through zero.
    if (rotation != 0.0) {
      if (handle == HandlePosition.none) handle = HandlePosition.bottomRight;
      switch (resizeMode) {
        case ResizeMode.freeform:
          return _resizeRotatedFreeform(
            initialRect: initialRect,
            initialLocalPosition: initialLocalPosition,
            localPosition: localPosition,
            handle: handle,
            initialFlip: initialFlip,
            clampingRect: clampingRect,
            constraints: constraints,
            rotation: rotation,
            bindingStrategy: bindingStrategy,
            allowFlipping: allowFlipping,
          );
        case ResizeMode.scale:
          return _resizeRotatedScale(
            initialRect: initialRect,
            initialLocalPosition: initialLocalPosition,
            localPosition: localPosition,
            handle: handle,
            initialFlip: initialFlip,
            clampingRect: clampingRect,
            constraints: constraints,
            rotation: rotation,
            bindingStrategy: bindingStrategy,
            allowFlipping: allowFlipping,
          );
        case ResizeMode.symmetric:
          return _resizeRotatedSymmetric(
            initialRect: initialRect,
            initialLocalPosition: initialLocalPosition,
            localPosition: localPosition,
            handle: handle,
            initialFlip: initialFlip,
            clampingRect: clampingRect,
            constraints: constraints,
            rotation: rotation,
            bindingStrategy: bindingStrategy,
            allowFlipping: allowFlipping,
          );
        case ResizeMode.symmetricScale:
          return _resizeRotatedSymmetricScale(
            initialRect: initialRect,
            initialLocalPosition: initialLocalPosition,
            localPosition: localPosition,
            handle: handle,
            initialFlip: initialFlip,
            clampingRect: clampingRect,
            constraints: constraints,
            rotation: rotation,
            bindingStrategy: bindingStrategy,
            allowFlipping: allowFlipping,
          );
      }
    }

    if (handle == HandlePosition.none) {
      log('Using bottomRight handle instead of none.');
      handle = HandlePosition.bottomRight;
    }

    Vector2 delta = localPosition - initialLocalPosition;

    // getFlipForRect uses delta instead of localPosition to know exactly when
    // to flip based on the current local position of the mouse cursor.
    final Flip currentFlip = !allowFlipping
        ? Flip.none
        : ClampHelpers.getFlipForRect(initialRect, delta, handle, resizeMode);

    // This sets the constraints such that it reflects flipRect state.
    if (allowFlipping &&
        (constraints.minWidth == 0 || constraints.minHeight == 0)) {
      // Rect flipping is enabled, but minWidth or minHeight is 0 which
      // means it won't be able to flip. So we update the constraints
      // to allow flipping.
      constraints = Constraints(
        minWidth: constraints.minWidth == 0
            ? -constraints.maxWidth
            : constraints.minWidth,
        minHeight: constraints.minHeight == 0
            ? -constraints.maxHeight
            : constraints.minHeight,
        maxWidth: constraints.maxWidth,
        maxHeight: constraints.maxHeight,
      );
    } else if (!allowFlipping && constraints.isUnconstrained) {
      // Rect flipping is disabled, but the constraints are unconstrained.
      // So we update the constraints to prevent flipping.
      constraints = Constraints(
        minWidth: 0,
        minHeight: 0,
        maxWidth: constraints.maxWidth,
        maxHeight: constraints.maxHeight,
      );
    }

    // Check if clampingRect is smaller than initialRect.
    // If it is, then we return the initialRect and not resize it.
    if (clampingRect.width < initialRect.width ||
        clampingRect.height < initialRect.height) {
      return ResizeResult(
        rect: initialRect,
        oldRect: initialRect,
        flip: initialFlip,
        resizeMode: resizeMode,
        delta: delta,
        handle: handle,
        rawSize: initialRect.size,
        minWidthReached: false,
        minHeightReached: false,
        largestRect: clampingRect,
        maxHeightReached: false,
        maxWidthReached: false,
      );
    }

    // Symmetric resizing requires the delta to be doubled since it grows or
    // shrinks in all directions from center.
    if (resizeMode.hasSymmetry) delta = Vector2(delta.x * 2, delta.y * 2);

    // No constraints or clamping is done. Only delta is applied to the
    // initial rect.
    Box explodedRect = _applyDelta(
      initialRect: initialRect,
      handle: handle,
      delta: delta,
      resizeMode: resizeMode,
      allowFlipping: allowFlipping,
    );

    final Resizer resizer = Resizer.from(resizeMode);
    final result = resizer.resize(
      explodedRect: explodedRect,
      clampingRect: clampingRect,
      handle: handle,
      constraints: constraints,
      initialRect: initialRect,
      flip: currentFlip,
    );

    final Box newRect = result.rect;
    final Box largestRect = result.largest;

    // Detect terminal resizing, where the resizing reached a hard limit.
    final terminalResult = checkForTerminalSizes(
      rect: newRect,
      initialRect: initialRect,
      clampingRect: clampingRect,
      constraints: constraints,
      handle: handle,
    );

    return ResizeResult(
      rect: newRect,
      oldRect: initialRect,
      flip: currentFlip * initialFlip,
      resizeMode: resizeMode,
      delta: delta,
      rawSize: newRect.size,
      minWidthReached: terminalResult.minWidthReached,
      maxWidthReached: terminalResult.maxWidthReached,
      minHeightReached: terminalResult.minHeightReached,
      maxHeightReached: terminalResult.maxHeightReached,
      largestRect: largestRect,
      handle: handle,
    );
  }

  /// Checks if the [rect] has reached a terminal size.
  /// Terminal size is when the rect has reached the min or max size according
  /// to the constraints defined by the [constraints] and [clampingRect].
  static ({
    bool minWidthReached,
    bool maxWidthReached,
    bool minHeightReached,
    bool maxHeightReached
  }) checkForTerminalSizes({
    required Box rect,
    required Box initialRect,
    required Box clampingRect,
    required Constraints constraints,
    required HandlePosition handle,
  }) {
    bool minWidthReached = false;
    bool maxWidthReached = false;
    bool minHeightReached = false;
    bool maxHeightReached = false;
    if (handle.influencesHorizontal) {
      if (rect.width <= initialRect.width &&
          rect.width == constraints.minWidth) {
        minWidthReached = true;
      }
      if (rect.width >= initialRect.width &&
          (rect.width == constraints.maxWidth ||
              rect.width == clampingRect.width)) {
        maxWidthReached = true;
      }
    }
    if (handle.influencesVertical) {
      if (rect.height <= initialRect.height &&
          rect.height == constraints.minHeight) {
        minHeightReached = true;
      }
      if (rect.height >= initialRect.height &&
          (rect.height == constraints.maxHeight ||
              rect.height == clampingRect.height)) {
        maxHeightReached = true;
      }
    }

    return (
      minWidthReached: minWidthReached,
      maxWidthReached: maxWidthReached,
      minHeightReached: minHeightReached,
      maxHeightReached: maxHeightReached,
    );
  }

  static Box _applyDelta({
    required Box initialRect,
    required HandlePosition handle,
    required Vector2 delta,
    required ResizeMode resizeMode,
    required bool allowFlipping,
  }) {
    double left;
    double top;
    double right;
    double bottom;

    left = initialRect.left + (handle.influencesLeft ? delta.x : 0);
    top = initialRect.top + (handle.influencesTop ? delta.y : 0);
    right = initialRect.right + (handle.influencesRight ? delta.x : 0);
    bottom = initialRect.bottom + (handle.influencesBottom ? delta.y : 0);

    double width = right - left;
    double height = bottom - top;

    if (allowFlipping) {
      width = width.abs();
      height = height.abs();
    } else {
      // If not flipping, we need to make sure the width and height are
      // positive which would imply that the left and top are less than
      // the right and bottom respectively stopping rect from flipping.
      width = width.clamp(0, double.infinity);
      height = height.clamp(0, double.infinity);
    }

    // If in symmetric scaling mode, utilize width and height to constructor
    // the new rect from its center.
    if (resizeMode.hasSymmetry) {
      // symmetric resizing is not affected if flipping is disabled.
      final widthDelta = (initialRect.width - width) / 2;
      final heightDelta = (initialRect.height - height) / 2;
      left = initialRect.left + widthDelta;
      top = initialRect.top + heightDelta;
      right = initialRect.right - widthDelta;
      bottom = initialRect.bottom - heightDelta;
    } else if (!allowFlipping) {
      // If not flipping, then we know that handles are not allowed to
      // cross the opposite one. So we use handle with width and height
      // instead of left, top, right, bottom to construct the new rect.
      return Box.fromHandle(
        handle.anchor(initialRect),
        handle,
        width,
        height,
      );
    }

    return Box.fromLTRB(
      min(left, right),
      min(top, bottom),
      max(left, right),
      max(top, bottom),
    );
  }

  /// Computes a rotation update from gesture pointer positions.
  ///
  /// Returns a [RawRotateResult] whose [RotateResult.rotation] is
  /// [initialRotation] plus the signed angle between the vectors from the
  /// box center to [initialLocalPosition] and [localPosition].
  static RawRotateResult rotate({
    required Box initialRect,
    required Vector2 initialLocalPosition,
    required Vector2 localPosition,
    required double initialRotation,
    Box clampingRect = Box.largest,
    BindingStrategy bindingStrategy = BindingStrategy.boundingBox,
  }) {
    final center = Vector2(
      (initialRect.left + initialRect.right) / 2,
      (initialRect.top + initialRect.bottom) / 2,
    );
    final fromVec = initialLocalPosition - center;
    final toVec = localPosition - center;
    final deltaAngle = atan2(toVec.y, toVec.x) - atan2(fromVec.y, fromVec.x);
    final newRotation = initialRotation + deltaAngle;

    // Slide-then-freeze: compute the feasible (tx, ty) interval that keeps
    // the rotated rect inside [clampingRect] under [bindingStrategy], then
    // either translate by the smallest tx/ty in that interval (slide-to-fit)
    // or — if the interval is empty — reject the rotation.
    final fit = _fitRotatedRect(
      initialRect: initialRect,
      rotation: newRotation,
      clampingRect: clampingRect,
      bindingStrategy: bindingStrategy,
    );
    if (fit == null) {
      return RotateResult<Box, Vector2, Dimension>(
        rect: initialRect,
        oldRect: initialRect,
        // Report the attempted gesture motion so consumers can observe the
        // user's intent without first checking [feasible]. Mirrors how
        // `move()` reports its clamped delta.
        delta: localPosition - initialLocalPosition,
        rawSize: Dimension(initialRect.width, initialRect.height),
        largestRect: clampingRect,
        rotation: initialRotation,
        boundingRect: ClampHelpers.calculateBoundingRect(initialRect),
        oldBoundingRect: ClampHelpers.calculateBoundingRect(initialRect),
        feasible: false,
      );
    }

    final (double tx, double ty) = fit;
    final rotatedRect = Box.fromLTRB(
      initialRect.left + tx,
      initialRect.top + ty,
      initialRect.right + tx,
      initialRect.bottom + ty,
      rotation: newRotation,
    );
    return RotateResult<Box, Vector2, Dimension>(
      rect: rotatedRect,
      oldRect: initialRect,
      delta: localPosition - initialLocalPosition,
      rawSize: Dimension(rotatedRect.width, rotatedRect.height),
      largestRect: clampingRect,
      rotation: newRotation,
      boundingRect: ClampHelpers.calculateBoundingRect(rotatedRect),
      oldBoundingRect: ClampHelpers.calculateBoundingRect(initialRect),
      feasible: true,
    );
  }

  /// Reconstructs the un-rotated rect for a side-handle resize.
  ///
  /// Side handles' anchor is the midpoint of the opposite side, not a
  /// corner of the rect. The rect is positioned such that the new rect's
  /// corresponding side midpoint sits at [anchorLocal] (so the
  /// post-correction world-anchor invariant holds): the perpendicular
  /// dimension extends symmetrically about that anchor; the dragged
  /// dimension may flip across the anchor if the pointer crossed it
  /// (reflected via [pointerRightOfAnchor] / [pointerBelowAnchor]).
  static Box _buildSideRotatedRect({
    required HandlePosition handle,
    required Vector2 anchorLocal,
    required double w,
    required double h,
    required bool pointerRightOfAnchor,
    required bool pointerBelowAnchor,
    required double rotation,
  }) {
    if (handle.influencesLeft || handle.influencesRight) {
      final dx = pointerRightOfAnchor ? w : -w;
      return Box.fromLTRB(
        min(anchorLocal.x, anchorLocal.x + dx),
        anchorLocal.y - h / 2,
        max(anchorLocal.x, anchorLocal.x + dx),
        anchorLocal.y + h / 2,
        rotation: rotation,
      );
    }
    final dy = pointerBelowAnchor ? h : -h;
    return Box.fromLTRB(
      anchorLocal.x - w / 2,
      min(anchorLocal.y, anchorLocal.y + dy),
      anchorLocal.x + w / 2,
      max(anchorLocal.y, anchorLocal.y + dy),
      rotation: rotation,
    );
  }

  /// Returns `(tx, ty)` such that translating [initialRect] by it places the
  /// rect at rotation [rotation] fully inside [clampingRect] (per
  /// [bindingStrategy]'s 4-corner feasibility) with minimum motion from the
  /// rect's current center, or `null` if no such translation exists.
  ///
  /// Mirrors the per-corner interval-intersection used by [move]; the only
  /// difference is the empty-interval response — `move` collapses to the
  /// midpoint, here we surface the infeasibility so the caller can reject.
  static (double, double)? _fitRotatedRect({
    required Box initialRect,
    required double rotation,
    required Box clampingRect,
    required BindingStrategy bindingStrategy,
  }) {
    final w = initialRect.width;
    final h = initialRect.height;
    final cx0 = initialRect.left + w / 2;
    final cy0 = initialRect.top + h / 2;
    // boundingBox: rotated quad corners only (rendered footprint inside
    // the clamp). originalBox: unrotated rect corners (axis-aligned).
    final List<Vector2> offsets;
    if (bindingStrategy == BindingStrategy.boundingBox) {
      final c = cos(rotation);
      final s = sin(rotation);
      offsets = <Vector2>[
        Vector2(-w / 2 * c - (-h / 2) * s, -w / 2 * s + (-h / 2) * c),
        Vector2(w / 2 * c - (-h / 2) * s, w / 2 * s + (-h / 2) * c),
        Vector2(w / 2 * c - h / 2 * s, w / 2 * s + h / 2 * c),
        Vector2(-w / 2 * c - h / 2 * s, -w / 2 * s + h / 2 * c),
      ];
    } else {
      offsets = <Vector2>[
        Vector2(-w / 2, -h / 2),
        Vector2(w / 2, -h / 2),
        Vector2(w / 2, h / 2),
        Vector2(-w / 2, h / 2),
      ];
    }
    double txMin = double.negativeInfinity;
    double txMax = double.infinity;
    double tyMin = double.negativeInfinity;
    double tyMax = double.infinity;
    for (final off in offsets) {
      final left = clampingRect.left - (cx0 + off.x);
      final right = clampingRect.right - (cx0 + off.x);
      final top = clampingRect.top - (cy0 + off.y);
      final bottom = clampingRect.bottom - (cy0 + off.y);
      if (left > txMin) txMin = left;
      if (right < txMax) txMax = right;
      if (top > tyMin) tyMin = top;
      if (bottom < tyMax) tyMax = bottom;
    }
    if (txMin > txMax || tyMin > tyMax) return null;
    final tx = 0.0.clamp(txMin, txMax).toDouble();
    final ty = 0.0.clamp(tyMin, tyMax).toDouble();
    return (tx, ty);
  }

  // ---------------------------------------------------------------------------
  // Rotated resize implementations.
  //
  // Approach: work in the box's unrotated-local frame with the handle's
  // opposite corner as anchor. Transform the pointer into that frame, solve
  // the resize against a feasibility polygon (up to 32 linear inequalities
  // for boundingBox — rotated and unrotated corners — or 16 for
  // originalBox; plus min/max constraints), then place the result in world
  // space such that the anchor's world position is preserved.
  // ---------------------------------------------------------------------------

  static RawResizeResult _resizeRotatedFreeform({
    required Box initialRect,
    required Vector2 initialLocalPosition,
    required Vector2 localPosition,
    required HandlePosition handle,
    required Flip initialFlip,
    required Box clampingRect,
    required Constraints constraints,
    required double rotation,
    required BindingStrategy bindingStrategy,
    required bool allowFlipping,
  }) {
    // 1. Box center + anchor (both in world-unrotated frame).
    final anchorLocal = handle.anchor(initialRect);
    final center = Vector2(
      (initialRect.left + initialRect.right) / 2,
      (initialRect.top + initialRect.bottom) / 2,
    );
    final anchorWorld =
        ClampHelpers.rotatePointAround(anchorLocal, center, rotation);

    // 2. Un-rotate pointer positions around the BOX CENTRE to land them in
    //    the box's own unrotated coordinate frame. Delta in that frame maps
    //    directly onto rect edges via handle.influences*.
    final initialPointerLocal =
        ClampHelpers.worldToUnrotated(initialLocalPosition, center, rotation);
    final currentPointerLocal =
        ClampHelpers.worldToUnrotated(localPosition, center, rotation);
    final delta = currentPointerLocal - initialPointerLocal;

    // 3. Apply delta to edges, compute desired (w, h). This mirrors the
    //    non-rotated `_applyDelta` semantics.
    final double newL =
        initialRect.left + (handle.influencesLeft ? delta.x : 0.0);
    final double newT =
        initialRect.top + (handle.influencesTop ? delta.y : 0.0);
    final double newR =
        initialRect.right + (handle.influencesRight ? delta.x : 0.0);
    final double newB =
        initialRect.bottom + (handle.influencesBottom ? delta.y : 0.0);
    final desiredW = (newR - newL).abs();
    final desiredH = (newB - newT).abs();
    // Pointer sign relative to anchor (for placing the new local corner).
    final bool pointerRightOfAnchor =
        handle.influencesRight ? newR >= anchorLocal.x : newL >= anchorLocal.x;
    final bool pointerBelowAnchor =
        handle.influencesBottom ? newB >= anchorLocal.y : newT >= anchorLocal.y;

    // 4. Build feasibility polygon and project. Reinterpret the legacy
    //    "Constraints.unconstrained()" sentinel (minWidth/minHeight = infinity)
    //    as effective min = 0 for the LP.
    //
    //    The sign of (w, h) direction from anchor depends on which handle is
    //    being dragged: bottomRight → (+w, +h), topRight → (+w, -h),
    //    bottomLeft → (-w, +h), topLeft → (-w, -h). Without these signs, the
    //    solver would describe a mirrored non-existent rectangle on the wrong
    //    side of the anchor and produce nonsensical clamping.
    final effMinW = constraints.minWidth.isFinite ? constraints.minWidth : 0.0;
    final effMinH =
        constraints.minHeight.isFinite ? constraints.minHeight : 0.0;
    final double widthSign = pointerRightOfAnchor ? 1.0 : -1.0;
    final double heightSign = pointerBelowAnchor ? 1.0 : -1.0;
    // "Natural" signs are the direction the rect occupies in the
    // gesture-start state — i.e. what the rect's geometry looks like
    // before any force-flip. For a topLeft handle the rect grows up-left
    // from the bottomRight anchor (-, -); for bottomRight it grows
    // down-right (+, +). Force-flip swaps these when the cursor crosses
    // the anchor.
    final double naturalWidthSign = handle.influencesRight ? 1.0 : -1.0;
    final double naturalHeightSign = handle.influencesBottom ? 1.0 : -1.0;
    bool effectiveRightOfAnchor = pointerRightOfAnchor;
    bool effectiveBelowAnchor = pointerBelowAnchor;
    final bool inForceFlipTerritory =
        widthSign != naturalWidthSign || heightSign != naturalHeightSign;

    final ineqs = _ineqScratch;
    void buildIneqs(double wSign, double hSign) {
      if (handle.isSide) {
        RotatedClampingSolver.buildSideHandleIneqsInto(
          ineqs,
          anchor: anchorWorld,
          theta: rotation,
          clampingRect: clampingRect,
          handle: handle,
          bindingStrategy: bindingStrategy,
          widthSign: wSign,
          heightSign: hSign,
        );
      } else {
        RotatedClampingSolver.buildCornerIneqsInto(
          ineqs,
          anchor: anchorWorld,
          theta: rotation,
          clampingRect: clampingRect,
          bindingStrategy: bindingStrategy,
          widthSign: wSign,
          heightSign: hSign,
        );
      }
    }

    buildIneqs(widthSign, heightSign);

    // Side handles lock the perpendicular dimension at initialRect's value;
    // the LP must not vary it. Pin min=max for that axis.
    final bool horizontalSide =
        handle.isSide && (handle.influencesLeft || handle.influencesRight);
    final bool verticalSide =
        handle.isSide && (handle.influencesTop || handle.influencesBottom);
    final double lpMinW = verticalSide ? initialRect.width : effMinW;
    final double lpMaxW =
        verticalSide ? initialRect.width : constraints.maxWidth;
    final double lpMinH = horizontalSide ? initialRect.height : effMinH;
    final double lpMaxH =
        horizontalSide ? initialRect.height : constraints.maxHeight;
    final projection = _projScratch;
    RotatedClampingSolver.projectOntoFeasibleRegionFlat(
      ineqs,
      out: projection,
      targetW: desiredW,
      targetH: desiredH,
      minW: lpMinW,
      maxW: lpMaxW,
      minH: lpMinH,
      maxH: lpMaxH,
    );

    // Force-flip fallback: when the cursor is past the anchor but the
    // flipped state can't fit clamp + constraints, retry the LP with
    // natural-direction signs. The rect then tracks the cursor by
    // clamp-pinning at the natural wall instead of freezing — the
    // "expectantly clamped" behavior. Force-flip only engages when it's
    // actually feasible. If both directions are infeasible, freeze.
    //
    // Crucially, the fallback target on each *flipped* axis is 0 — not
    // the original desired magnitude. The cursor's distance past the
    // anchor in the flip direction has no meaning in the natural-
    // direction LP; using it would grow the rect in the *opposite*
    // direction from where the user dragged. Zeroing makes the LP
    // collapse the flipped axis toward minimum, while axes that were
    // already natural keep tracking their cursor-derived target.
    if (!projection.feasible && inForceFlipTerritory) {
      final double fallbackDesiredW =
          widthSign != naturalWidthSign ? 0.0 : desiredW;
      final double fallbackDesiredH =
          heightSign != naturalHeightSign ? 0.0 : desiredH;
      buildIneqs(naturalWidthSign, naturalHeightSign);
      RotatedClampingSolver.projectOntoFeasibleRegionFlat(
        ineqs,
        out: projection,
        targetW: fallbackDesiredW,
        targetH: fallbackDesiredH,
        minW: lpMinW,
        maxW: lpMaxW,
        minH: lpMinH,
        maxH: lpMaxH,
      );
      if (projection.feasible) {
        effectiveRightOfAnchor = handle.influencesRight;
        effectiveBelowAnchor = handle.influencesBottom;
      }
    }

    if (!projection.feasible) {
      // Even the natural direction cannot fit — gesture is truly stuck.
      // Return a sentinel rect equal to gesture-start. The controller
      // will hold its last feasible state instead of writing this one.
      return ResizeResult<Box, Vector2, Dimension>(
        rect: initialRect,
        oldRect: initialRect,
        delta: localPosition - initialLocalPosition,
        flip: initialFlip,
        resizeMode: ResizeMode.freeform,
        rawSize: Dimension(initialRect.width, initialRect.height),
        minWidthReached: false,
        maxWidthReached: false,
        minHeightReached: false,
        maxHeightReached: false,
        largestRect: clampingRect,
        handle: handle,
        rotation: rotation,
        boundingRect: ClampHelpers.calculateBoundingRect(initialRect),
        oldBoundingRect: ClampHelpers.calculateBoundingRect(initialRect),
        feasible: false,
      );
    }

    // 5. Reconstruct the unrotated rect anchored at anchorLocal with
    //    projected dimensions. Side handles use a different construction
    //    than corners because their anchor is the midpoint of the
    //    opposite side (not a corner of the rect): the rect spans the
    //    perpendicular axis symmetrically around the anchor.
    final Box newRect;
    if (handle.isSide) {
      // Freeform side: lock the perpendicular dimension at initialRect's
      // value (the LP can't change it because newR/newL or newT/newB stay
      // pinned to the initial rect).
      final bool horizontal = handle.influencesLeft || handle.influencesRight;
      newRect = _buildSideRotatedRect(
        handle: handle,
        anchorLocal: anchorLocal,
        w: horizontal ? projection.w : initialRect.width,
        h: horizontal ? initialRect.height : projection.h,
        pointerRightOfAnchor: effectiveRightOfAnchor,
        pointerBelowAnchor: effectiveBelowAnchor,
        rotation: rotation,
      );
    } else {
      final dx = effectiveRightOfAnchor ? projection.w : -projection.w;
      final dy = effectiveBelowAnchor ? projection.h : -projection.h;
      final newLocalCorner = Vector2(anchorLocal.x + dx, anchorLocal.y + dy);
      newRect = Box.fromLTRB(
        min(anchorLocal.x, newLocalCorner.x),
        min(anchorLocal.y, newLocalCorner.y),
        max(anchorLocal.x, newLocalCorner.x),
        max(anchorLocal.y, newLocalCorner.y),
        rotation: rotation,
      );
    }

    // 6. Shift the new rect in world space so that its rotated anchor lands
    //    exactly back on anchorWorld.
    final newCenter = Vector2(
      (newRect.left + newRect.right) / 2,
      (newRect.top + newRect.bottom) / 2,
    );
    final newAnchorInWorld =
        ClampHelpers.rotatePointAround(anchorLocal, newCenter, rotation);
    final correction = anchorWorld - newAnchorInWorld;
    final shifted = Box.fromLTRB(
      newRect.left + correction.x,
      newRect.top + correction.y,
      newRect.right + correction.x,
      newRect.bottom + correction.y,
      rotation: rotation,
    );

    // Flip transition: the pointer crossed the handle's "natural" direction
    // in the un-rotated frame. For corner/side handles, flip on each axis
    // independently. Pure-side handles only flip on their active axis.
    // Uses the EFFECTIVE side-of-anchor: when force-flip fell back to
    // natural-direction (because the flipped state was infeasible), the
    // rect is unflipped, so report no flip even if the cursor is past
    // the anchor in raw coordinates.
    final bool xFlipped = handle.influencesRight
        ? !effectiveRightOfAnchor
        : (handle.influencesLeft ? effectiveRightOfAnchor : false);
    final bool yFlipped = handle.influencesBottom
        ? !effectiveBelowAnchor
        : (handle.influencesTop ? effectiveBelowAnchor : false);
    final Flip currentFlip = allowFlipping
        ? Flip.fromValue(xFlipped ? -1 : 1, yFlipped ? -1 : 1)
        : Flip.none;

    return ResizeResult<Box, Vector2, Dimension>(
      rect: shifted,
      oldRect: initialRect,
      delta: localPosition - initialLocalPosition,
      flip: currentFlip * initialFlip,
      resizeMode: ResizeMode.freeform,
      rawSize: Dimension(shifted.width, shifted.height),
      minWidthReached: projection.wMinHit,
      maxWidthReached: projection.wMaxHit,
      minHeightReached: projection.hMinHit,
      maxHeightReached: projection.hMaxHit,
      largestRect: clampingRect,
      handle: handle,
      rotation: rotation,
      boundingRect: ClampHelpers.calculateBoundingRect(shifted),
      oldBoundingRect: ClampHelpers.calculateBoundingRect(initialRect),
    );
  }

  static RawResizeResult _resizeRotatedScale({
    required Box initialRect,
    required Vector2 initialLocalPosition,
    required Vector2 localPosition,
    required HandlePosition handle,
    required Flip initialFlip,
    required Box clampingRect,
    required Constraints constraints,
    required double rotation,
    required BindingStrategy bindingStrategy,
    required bool allowFlipping,
  }) {
    final anchorLocal = handle.anchor(initialRect);
    final center = Vector2(
      (initialRect.left + initialRect.right) / 2,
      (initialRect.top + initialRect.bottom) / 2,
    );
    final anchorWorld =
        ClampHelpers.rotatePointAround(anchorLocal, center, rotation);

    // Un-rotate pointers around the box centre (not anchorWorld) so delta
    // is in the box's own unrotated frame.
    final initialPointerLocal =
        ClampHelpers.worldToUnrotated(initialLocalPosition, center, rotation);
    final currentPointerLocal =
        ClampHelpers.worldToUnrotated(localPosition, center, rotation);
    final delta = currentPointerLocal - initialPointerLocal;

    final double newL =
        initialRect.left + (handle.influencesLeft ? delta.x : 0.0);
    final double newR =
        initialRect.right + (handle.influencesRight ? delta.x : 0.0);
    final double newT =
        initialRect.top + (handle.influencesTop ? delta.y : 0.0);
    final double newB =
        initialRect.bottom + (handle.influencesBottom ? delta.y : 0.0);
    // Aspect ratio k = h / w from the initial rect.
    final k = initialRect.height / initialRect.width;
    // For top/bottom side handles in scale mode, the user drags vertically;
    // height is the active dimension. Convert to an equivalent w via k so
    // the rest of the LP (which substitutes h = k*w) still applies.
    final bool isVerticalSide =
        handle.isSide && (handle.influencesTop || handle.influencesBottom);
    final desiredW =
        isVerticalSide ? (newB - newT).abs() / k : (newR - newL).abs();
    // Pointer sign relative to anchor (same logic as freeform).
    final bool pointerRightOfAnchor =
        handle.influencesRight ? newR >= anchorLocal.x : newL >= anchorLocal.x;
    final bool pointerBelowAnchor =
        handle.influencesBottom ? newB >= anchorLocal.y : newT >= anchorLocal.y;

    // Reinterpret unconstrained-sentinel infinities as zero mins.
    final effMinW = constraints.minWidth.isFinite ? constraints.minWidth : 0.0;
    final effMinH =
        constraints.minHeight.isFinite ? constraints.minHeight : 0.0;

    final double widthSign = pointerRightOfAnchor ? 1.0 : -1.0;
    final double heightSign = pointerBelowAnchor ? 1.0 : -1.0;
    final ineqs = _ineqScratch;
    if (handle.isSide) {
      // Same anchor-geometry fix as in freeform: side handles need the
      // side-anchored inequalities, not the corner ones. Pass widthSign /
      // heightSign so force-flipped side handles get the right LP geometry.
      RotatedClampingSolver.buildSideHandleIneqsInto(
        ineqs,
        anchor: anchorWorld,
        theta: rotation,
        clampingRect: clampingRect,
        handle: handle,
        bindingStrategy: bindingStrategy,
        widthSign: widthSign,
        heightSign: heightSign,
      );
    } else {
      RotatedClampingSolver.buildCornerIneqsInto(
        ineqs,
        anchor: anchorWorld,
        theta: rotation,
        clampingRect: clampingRect,
        bindingStrategy: bindingStrategy,
        widthSign: widthSign,
        heightSign: heightSign,
      );
    }

    // Substitute h = k * w into each inequality: (a + b*k)*w <= c.
    double wUpper = constraints.maxWidth;
    if (constraints.maxHeight.isFinite) {
      wUpper = min(wUpper, constraints.maxHeight / k);
    }
    double wLower = effMinW;
    if (effMinH > 0) {
      wLower = max(wLower, effMinH / k);
    }
    final ineqData = ineqs.data;
    final ineqCount = ineqs.count;
    for (int i = 0; i < ineqCount; i++) {
      final a = ineqData[3 * i];
      final b = ineqData[3 * i + 1];
      final coef = a + b * k;
      if (coef.abs() < 1e-12) continue;
      final bound = ineqData[3 * i + 2] / coef;
      if (coef > 0 && bound < wUpper) wUpper = bound;
      if (coef < 0 && bound > wLower) wLower = bound;
    }
    // Sanitize: at constraint-saturation boundaries the feasible interval for
    // w can degenerate to a single point (e.g. minH/k == maxW == 500). Finite
    // arithmetic can leave wLower above wUpper by a few ULP; treat that case
    // as the intended point. If they're separated by more than a reasonable
    // epsilon, the feasible region genuinely is empty — fall back to the
    // current size rather than throwing.
    if (wLower > wUpper) {
      if ((wLower - wUpper) <= 1e-6 * max(1.0, wUpper.abs())) {
        final mid = (wLower + wUpper) / 2;
        wLower = mid;
        wUpper = mid;
      } else {
        wLower = desiredW;
        wUpper = desiredW;
      }
    }
    final w = desiredW.clamp(wLower, wUpper).toDouble();
    final h = w * k;

    // Side handles use a side-anchored construction (rect is centered on
    // the perpendicular axis around anchorLocal); corners use the existing
    // anchor-corner span via min/max.
    final Box newRect;
    if (handle.isSide) {
      newRect = _buildSideRotatedRect(
        handle: handle,
        anchorLocal: anchorLocal,
        w: w,
        h: h,
        pointerRightOfAnchor: pointerRightOfAnchor,
        pointerBelowAnchor: pointerBelowAnchor,
        rotation: rotation,
      );
    } else {
      final dx = widthSign * w;
      final dy = heightSign * h;
      final newLocalCorner = Vector2(anchorLocal.x + dx, anchorLocal.y + dy);
      newRect = Box.fromLTRB(
        min(anchorLocal.x, newLocalCorner.x),
        min(anchorLocal.y, newLocalCorner.y),
        max(anchorLocal.x, newLocalCorner.x),
        max(anchorLocal.y, newLocalCorner.y),
        rotation: rotation,
      );
    }
    final newCenter = Vector2(
      (newRect.left + newRect.right) / 2,
      (newRect.top + newRect.bottom) / 2,
    );
    final correction = anchorWorld -
        ClampHelpers.rotatePointAround(anchorLocal, newCenter, rotation);
    final shifted = Box.fromLTRB(
      newRect.left + correction.x,
      newRect.top + correction.y,
      newRect.right + correction.x,
      newRect.bottom + correction.y,
      rotation: rotation,
    );

    final bool xFlipped = handle.influencesRight
        ? !pointerRightOfAnchor
        : (handle.influencesLeft ? pointerRightOfAnchor : false);
    final bool yFlipped = handle.influencesBottom
        ? !pointerBelowAnchor
        : (handle.influencesTop ? pointerBelowAnchor : false);
    final Flip currentFlip = allowFlipping
        ? Flip.fromValue(xFlipped ? -1 : 1, yFlipped ? -1 : 1)
        : Flip.none;

    return ResizeResult<Box, Vector2, Dimension>(
      rect: shifted,
      oldRect: initialRect,
      delta: localPosition - initialLocalPosition,
      flip: currentFlip * initialFlip,
      resizeMode: ResizeMode.scale,
      rawSize: Dimension(shifted.width, shifted.height),
      minWidthReached: (w - wLower).abs() < 1e-9,
      maxWidthReached: wUpper.isFinite && (w - wUpper).abs() < 1e-9,
      minHeightReached: effMinH > 0 && (h - effMinH).abs() < 1e-9,
      maxHeightReached: constraints.maxHeight.isFinite &&
          (h - constraints.maxHeight).abs() < 1e-9,
      largestRect: clampingRect,
      handle: handle,
      rotation: rotation,
      boundingRect: ClampHelpers.calculateBoundingRect(shifted),
      oldBoundingRect: ClampHelpers.calculateBoundingRect(initialRect),
    );
  }

  static RawResizeResult _resizeRotatedSymmetric({
    required Box initialRect,
    required Vector2 initialLocalPosition,
    required Vector2 localPosition,
    required HandlePosition handle,
    required Flip initialFlip,
    required Box clampingRect,
    required Constraints constraints,
    required double rotation,
    required BindingStrategy bindingStrategy,
    required bool allowFlipping,
  }) {
    final centerWorld = Vector2(
      (initialRect.left + initialRect.right) / 2,
      (initialRect.top + initialRect.bottom) / 2,
    );
    final currentLocal =
        ClampHelpers.worldToUnrotated(localPosition, centerWorld, rotation);

    // Desired (w, h): twice the distance from center to the dragged corner.
    // Side handles only drive one axis; lock the perpendicular dimension at
    // the initial value so symmetric expansion doesn't collapse it.
    final bool horizontalSide =
        handle.isSide && (handle.influencesLeft || handle.influencesRight);
    final bool verticalSide =
        handle.isSide && (handle.influencesTop || handle.influencesBottom);
    final desiredW = verticalSide
        ? initialRect.width
        : (currentLocal.x - centerWorld.x).abs() * 2;
    final desiredH = horizontalSide
        ? initialRect.height
        : (currentLocal.y - centerWorld.y).abs() * 2;

    final effMinW = constraints.minWidth.isFinite ? constraints.minWidth : 0.0;
    final effMinH =
        constraints.minHeight.isFinite ? constraints.minHeight : 0.0;

    final ineqs = _ineqScratch;
    RotatedClampingSolver.buildCenterIneqsInto(
      ineqs,
      center: centerWorld,
      theta: rotation,
      clampingRect: clampingRect,
      bindingStrategy: bindingStrategy,
    );
    final projection = _projScratch;
    RotatedClampingSolver.projectOntoFeasibleRegionFlat(
      ineqs,
      out: projection,
      targetW: desiredW,
      targetH: desiredH,
      minW: effMinW,
      maxW: constraints.maxWidth,
      minH: effMinH,
      maxH: constraints.maxHeight,
    );
    if (!projection.feasible) {
      return ResizeResult<Box, Vector2, Dimension>(
        rect: initialRect,
        oldRect: initialRect,
        delta: localPosition - initialLocalPosition,
        flip: initialFlip,
        resizeMode: ResizeMode.symmetric,
        rawSize: Dimension(initialRect.width, initialRect.height),
        minWidthReached: false,
        maxWidthReached: false,
        minHeightReached: false,
        maxHeightReached: false,
        largestRect: clampingRect,
        handle: handle,
        rotation: rotation,
        boundingRect: ClampHelpers.calculateBoundingRect(initialRect),
        oldBoundingRect: ClampHelpers.calculateBoundingRect(initialRect),
        feasible: false,
      );
    }
    final w = projection.w;
    final h = projection.h;

    final newRect = Box.fromLTRB(
      centerWorld.x - w / 2,
      centerWorld.y - h / 2,
      centerWorld.x + w / 2,
      centerWorld.y + h / 2,
      rotation: rotation,
    );

    // Symmetric flip: pointer crossed centerWorld on the handle's natural axis.
    final bool xFlipped = handle.influencesRight
        ? currentLocal.x < centerWorld.x
        : (handle.influencesLeft ? currentLocal.x > centerWorld.x : false);
    final bool yFlipped = handle.influencesBottom
        ? currentLocal.y < centerWorld.y
        : (handle.influencesTop ? currentLocal.y > centerWorld.y : false);
    final Flip currentFlip = allowFlipping
        ? Flip.fromValue(xFlipped ? -1 : 1, yFlipped ? -1 : 1)
        : Flip.none;

    return ResizeResult<Box, Vector2, Dimension>(
      rect: newRect,
      oldRect: initialRect,
      delta: localPosition - initialLocalPosition,
      flip: currentFlip * initialFlip,
      resizeMode: ResizeMode.symmetric,
      rawSize: Dimension(w, h),
      minWidthReached: projection.wMinHit,
      maxWidthReached: projection.wMaxHit,
      minHeightReached: projection.hMinHit,
      maxHeightReached: projection.hMaxHit,
      largestRect: clampingRect,
      handle: handle,
      rotation: rotation,
      boundingRect: ClampHelpers.calculateBoundingRect(newRect),
      oldBoundingRect: ClampHelpers.calculateBoundingRect(initialRect),
    );
  }

  static RawResizeResult _resizeRotatedSymmetricScale({
    required Box initialRect,
    required Vector2 initialLocalPosition,
    required Vector2 localPosition,
    required HandlePosition handle,
    required Flip initialFlip,
    required Box clampingRect,
    required Constraints constraints,
    required double rotation,
    required BindingStrategy bindingStrategy,
    required bool allowFlipping,
  }) {
    final centerWorld = Vector2(
      (initialRect.left + initialRect.right) / 2,
      (initialRect.top + initialRect.bottom) / 2,
    );
    final currentLocal =
        ClampHelpers.worldToUnrotated(localPosition, centerWorld, rotation);
    final k = initialRect.height / initialRect.width;
    final desiredW = (currentLocal.x - centerWorld.x).abs() * 2;

    final effMinW = constraints.minWidth.isFinite ? constraints.minWidth : 0.0;
    final effMinH =
        constraints.minHeight.isFinite ? constraints.minHeight : 0.0;

    final ineqs = _ineqScratch;
    RotatedClampingSolver.buildCenterIneqsInto(
      ineqs,
      center: centerWorld,
      theta: rotation,
      clampingRect: clampingRect,
      bindingStrategy: bindingStrategy,
    );
    double wUpper = constraints.maxWidth;
    if (constraints.maxHeight.isFinite) {
      wUpper = min(wUpper, constraints.maxHeight / k);
    }
    double wLower = effMinW;
    if (effMinH > 0) {
      wLower = max(wLower, effMinH / k);
    }
    final ineqData = ineqs.data;
    final ineqCount = ineqs.count;
    for (int i = 0; i < ineqCount; i++) {
      final a = ineqData[3 * i];
      final b = ineqData[3 * i + 1];
      final coef = a + b * k;
      if (coef.abs() < 1e-12) continue;
      final bound = ineqData[3 * i + 2] / coef;
      if (coef > 0 && bound < wUpper) wUpper = bound;
      if (coef < 0 && bound > wLower) wLower = bound;
    }
    // Sanitize: at constraint-saturation boundaries the feasible interval for
    // w can degenerate to a single point (e.g. minH/k == maxW == 500). Finite
    // arithmetic can leave wLower above wUpper by a few ULP; treat that case
    // as the intended point. If they're separated by more than a reasonable
    // epsilon, the feasible region genuinely is empty — fall back to the
    // current size rather than throwing.
    if (wLower > wUpper) {
      if ((wLower - wUpper) <= 1e-6 * max(1.0, wUpper.abs())) {
        final mid = (wLower + wUpper) / 2;
        wLower = mid;
        wUpper = mid;
      } else {
        wLower = desiredW;
        wUpper = desiredW;
      }
    }
    final w = desiredW.clamp(wLower, wUpper).toDouble();
    final h = w * k;

    final newRect = Box.fromLTRB(
      centerWorld.x - w / 2,
      centerWorld.y - h / 2,
      centerWorld.x + w / 2,
      centerWorld.y + h / 2,
      rotation: rotation,
    );
    // SymmetricScale flip: pointer crossed centerWorld on the handle's
    // natural axis (same logic as symmetric).
    final bool xFlipped = handle.influencesRight
        ? currentLocal.x < centerWorld.x
        : (handle.influencesLeft ? currentLocal.x > centerWorld.x : false);
    final bool yFlipped = handle.influencesBottom
        ? currentLocal.y < centerWorld.y
        : (handle.influencesTop ? currentLocal.y > centerWorld.y : false);
    final Flip currentFlip = allowFlipping
        ? Flip.fromValue(xFlipped ? -1 : 1, yFlipped ? -1 : 1)
        : Flip.none;

    return ResizeResult<Box, Vector2, Dimension>(
      rect: newRect,
      oldRect: initialRect,
      delta: localPosition - initialLocalPosition,
      flip: currentFlip * initialFlip,
      resizeMode: ResizeMode.symmetricScale,
      rawSize: Dimension(w, h),
      minWidthReached: (w - wLower).abs() < 1e-9,
      maxWidthReached: wUpper.isFinite && (w - wUpper).abs() < 1e-9,
      minHeightReached: effMinH > 0 && (h - effMinH).abs() < 1e-9,
      maxHeightReached: constraints.maxHeight.isFinite &&
          (h - constraints.maxHeight).abs() < 1e-9,
      largestRect: clampingRect,
      handle: handle,
      rotation: rotation,
      boundingRect: ClampHelpers.calculateBoundingRect(newRect),
      oldBoundingRect: ClampHelpers.calculateBoundingRect(initialRect),
    );
  }
}
