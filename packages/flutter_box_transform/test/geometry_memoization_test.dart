import 'dart:math' as math;

import 'package:flutter/material.dart';
import 'package:flutter_box_transform/flutter_box_transform.dart';
import 'package:flutter_test/flutter_test.dart';

void main() {
  testWidgets('handle geometry is stable across an unrelated parent rebuild',
      (tester) async {
    final controller = TransformableBoxController(
      rect: const Rect.fromLTWH(100, 100, 200, 120),
      rotation: math.pi / 6,
    );
    addTearDown(controller.dispose);

    // Rebuilds the identical tree. Re-pumping a new-but-equal widget tree
    // triggers didUpdateWidget + build with no change to any geometry input —
    // the exact path memoization must survive without moving handles.
    Widget buildTree() => MaterialApp(
          home: Scaffold(
            body: Stack(
              children: [
                TransformableBox(
                  controller: controller,
                  rotatable: true,
                  rotationHandleMode: RotationHandleMode.both,
                  contentBuilder: (context, rect, flip) =>
                      const SizedBox.shrink(),
                ),
              ],
            ),
          ),
        );

    const keys = <Key>[
      ValueKey(HandlePosition.topLeft),
      ValueKey(HandlePosition.topRight),
      ValueKey(HandlePosition.bottomLeft),
      ValueKey(HandlePosition.bottomRight),
      ValueKey(HandlePosition.top),
      ValueKey(HandlePosition.bottom),
      ValueKey(HandlePosition.left),
      ValueKey(HandlePosition.right),
      ValueKey('box_transform_top_rotation_handle'),
    ];

    await tester.pumpWidget(buildTree());
    final before = {for (final k in keys) k: tester.getRect(find.byKey(k))};

    await tester.pumpWidget(buildTree());
    final after = {for (final k in keys) k: tester.getRect(find.byKey(k))};

    for (final k in keys) {
      expect(after[k], before[k],
          reason: 'Handle $k moved across an unrelated rebuild');
    }
  });
}
