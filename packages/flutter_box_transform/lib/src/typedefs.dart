import 'package:box_transform/box_transform.dart';
import 'package:flutter/widgets.dart';

import 'ui_result.dart';

/// Distinguishes the gesture zone a [MouseCursor] is being requested for.
///
/// Corner handles expose two zones when `rotatable` is true: an inner resize
/// zone ([HandleCursorKind.resize]) and an outer rotation ring
/// ([HandleCursorKind.rotation]). Side handles only expose a resize zone.
enum HandleCursorKind {
  /// Cursor for the resize gesture zone (inner zone on corner handles, the
  /// full strip on side handles).
  resize,

  /// Cursor for the rotation gesture ring around a corner handle.
  rotation,
}

/// Resolves the [MouseCursor] to display over a handle's gesture zone.
///
/// Return `null` to fall back to the package defaults:
///   - resize handles use the appropriate `SystemMouseCursors.resize*`
///   - rotation rings reuse the diagonal resize cursor (Flutter has no native
///     rotation cursor; see [`custom_mouse_cursor`](https://pub.dev/packages/custom_mouse_cursor)
///     if you want to ship a real rotate glyph)
typedef HandleCursorResolver = MouseCursor? Function(
  HandlePosition handle,
  HandleCursorKind kind,
);

/// A callback that expects a [Widget] that represents any of the handles.
/// The [handle] is the current position and size of the handle.
typedef HandleBuilder = Widget Function(
  BuildContext context,
  HandlePosition handle,
);

/// A callback that builds the visible top rotation handle.
typedef RotationHandleBuilder = Widget Function(BuildContext context);

/// A callback that expects a [Widget] that represents the content of the box.
/// The [rect] is the current position and size of the box.
/// The [flip] is the current flip state of the box.
typedef TransformableChildBuilder = Widget Function(
  BuildContext context,
  Rect rect,
  Flip flip,
);

/// A callback that is called when the box is moved or resized.
typedef RectChangeEvent = void Function(
  UITransformResult result,
  DragUpdateDetails event,
);

/// A callback that is called when the box begins a drag operation.
typedef RectDragStartEvent = void Function(
  DragStartDetails event,
);

/// A callback that is called when the box is being dragged.
typedef RectDragUpdateEvent = void Function(
  UIMoveResult result,
  DragUpdateDetails event,
);

/// A callback that is called when the box ends a drag operation.
typedef RectDragEndEvent = void Function(
  DragEndDetails event,
);

/// A callback that is called when the box cancels a drag operation.
typedef RectDragCancelEvent = void Function();

/// A callback that is called when the box begins a resize operation.
typedef RectResizeStart = void Function(
  HandlePosition handle,
  DragStartDetails event,
);

/// A callback that is called when the box is being resized.
typedef RectResizeUpdateEvent = void Function(
  UIResizeResult result,
  DragUpdateDetails event,
);

/// A callback that is called when the box ends a resize operation.
typedef RectResizeEnd = void Function(
  HandlePosition handle,
  DragEndDetails event,
);

/// A callback that is called when the box cancels a resize operation.
typedef RectResizeCancel = void Function(
  HandlePosition handle,
);

/// A callback that is called when the box reaches a terminal edge when
/// resizing.
typedef TerminalEdgeEvent = void Function(
  bool reached,
);

/// A callback that is called when the box reaches a minimum or maximum size
/// when resizing a specific axis.
typedef TerminalAxisEvent = void Function(
  bool reachedMin,
  bool reachedMax,
);

/// A callback that is called when the box reaches a minimum or maximum size
/// when resizing.
typedef TerminalEvent = void Function(
  bool reachedMinWidth,
  bool reachedMaxWidth,
  bool reachedMinHeight,
  bool reachedMaxHeight,
);

/// A callback that is called when a rotation gesture begins on a handle.
typedef RectRotateStart = void Function(
  HandlePosition handle,
  DragStartDetails event,
);

/// A callback that is called during a rotation gesture.
typedef RectRotateUpdateEvent = void Function(
  UIRotateResult result,
  DragUpdateDetails event,
);

/// A callback that is called when a rotation gesture ends.
typedef RectRotateEnd = void Function(
  HandlePosition handle,
  DragEndDetails event,
);

/// A callback that is called when a rotation gesture is cancelled.
typedef RectRotateCancel = void Function(
  HandlePosition handle,
);
