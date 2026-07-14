import 'dart:math' as math;

import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'package:flutter_box_transform/flutter_box_transform.dart';
import 'package:flutter_test/flutter_test.dart';

void main() {
  const rect = Rect.fromLTWH(200, 200, 100, 100);
  const topHandleKey = ValueKey('box_transform_top_rotation_handle');

  Future<TransformableBoxController> pumpBox(
    WidgetTester tester, {
    RotationHandleMode mode = RotationHandleMode.cornerRing,
    double rotation = 0,
    RotationHandleBuilder? rotationHandleBuilder,
    Set<PointerDeviceKind>? supportedRotationDevices,
  }) async {
    final controller = TransformableBoxController(
      rect: rect,
      rotation: rotation,
    );
    await tester.pumpWidget(
      Directionality(
        textDirection: TextDirection.ltr,
        child: SizedBox(
          width: 800,
          height: 600,
          child: Stack(
            children: [
              TransformableBox(
                controller: controller,
                rotatable: true,
                rotationHandleMode: mode,
                rotationHandleBuilder:
                    rotationHandleBuilder ?? HandleBuilders.defaultRotation,
                supportedRotationDevices: supportedRotationDevices,
                contentBuilder: (context, rect, flip) =>
                    const ColoredBox(color: Color(0xFF4B9EF4)),
              ),
            ],
          ),
        ),
      ),
    );
    await tester.pump();
    return controller;
  }

  testWidgets('cornerRing preserves existing outside-corner rotation',
      (tester) async {
    final c = await pumpBox(tester, mode: RotationHandleMode.cornerRing);

    final gesture = await tester.startGesture(const Offset(312, 312));
    await tester.pump();
    await gesture.moveTo(const Offset(188, 312));
    await tester.pump();
    await gesture.up();
    await tester.pump();

    expect(c.rotation, closeTo(math.pi / 2, 1e-3));
    expect(find.byKey(topHandleKey), findsNothing);
  });

  testWidgets('cornerRing installs visible rotation indicator painters',
      (tester) async {
    await pumpBox(tester, mode: RotationHandleMode.cornerRing);

    final rotationPainters = tester
        .widgetList<CustomPaint>(find.byType(CustomPaint))
        .where((paint) =>
            paint.painter.runtimeType.toString() == '_RotationIndicatorPainter')
        .toList();

    expect(rotationPainters, hasLength(4));
  });

  testWidgets('topHandle rotates from visible top handle', (tester) async {
    final c = await pumpBox(tester, mode: RotationHandleMode.topHandle);

    expect(find.byKey(topHandleKey), findsOneWidget);
    final gesture = await tester.startGesture(tester.getCenter(
      find.byKey(topHandleKey),
    ));
    await tester.pump();
    await gesture.moveTo(const Offset(340, 250));
    await tester.pump();
    await gesture.up();
    await tester.pump();

    expect(c.rotation, closeTo(math.pi / 2, 1e-3));
  });

  testWidgets('topHandle does not expose corner rotation ring', (tester) async {
    final c = await pumpBox(tester, mode: RotationHandleMode.topHandle);

    final gesture = await tester.startGesture(const Offset(312, 312));
    await tester.pump();
    await gesture.moveTo(const Offset(188, 312));
    await tester.pump();
    await gesture.up();
    await tester.pump();

    expect(c.rotation, closeTo(0, 1e-9));
  });

  testWidgets('both mode allows top handle and corner ring rotation',
      (tester) async {
    final c = await pumpBox(tester, mode: RotationHandleMode.both);

    final topGesture = await tester.startGesture(tester.getCenter(
      find.byKey(topHandleKey),
    ));
    await tester.pump();
    await topGesture.moveTo(const Offset(340, 250));
    await tester.pump();
    await topGesture.up();
    await tester.pump();
    expect(c.rotation.abs(), greaterThan(math.pi / 4));

    c.setRotation(0);
    await tester.pump();
    final cornerGesture = await tester.startGesture(const Offset(312, 312));
    await tester.pump();
    await cornerGesture.moveTo(const Offset(188, 312));
    await tester.pump();
    await cornerGesture.up();
    await tester.pump();
    expect(c.rotation, closeTo(math.pi / 2, 1e-3));
  });

  testWidgets('top handle is positioned with box rotation', (tester) async {
    for (final rotation in [0.0, math.pi / 4, math.pi / 2]) {
      await pumpBox(
        tester,
        mode: RotationHandleMode.topHandle,
        rotation: rotation,
      );
      final expected = RotatedLayout.topRotationHandleCenterInWorld(
        rect: rect,
        rotation: rotation,
        offsetFromTopEdge: 40,
      );
      expect(tester.getCenter(find.byKey(topHandleKey)).dx,
          closeTo(expected.dx, 0.01));
      expect(tester.getCenter(find.byKey(topHandleKey)).dy,
          closeTo(expected.dy, 0.01));
    }
  });

  testWidgets('resize wins inside corner resize zone in both mode',
      (tester) async {
    final c = await pumpBox(tester, mode: RotationHandleMode.both);

    final gesture = await tester.startGesture(const Offset(300, 300));
    await tester.pump();
    await gesture.moveBy(const Offset(20, 20));
    await tester.pump();
    await gesture.up();
    await tester.pump();

    expect(c.rect.width, greaterThan(100));
    expect(c.rect.height, greaterThan(100));
    expect(c.rotation, closeTo(0, 1e-9));
  });

  testWidgets('cornerRing resize priority works without debug bounds',
      (tester) async {
    final c = await pumpBox(tester, mode: RotationHandleMode.cornerRing);

    final gesture = await tester.startGesture(const Offset(300, 300));
    await tester.pump();
    await gesture.moveBy(const Offset(20, 20));
    await tester.pump();
    await gesture.up();
    await tester.pump();

    expect(c.rect.width, greaterThan(100));
    expect(c.rect.height, greaterThan(100));
    expect(c.rotation, closeTo(0, 1e-9));
  });

  testWidgets('custom rotationHandleBuilder renders at top handle position',
      (tester) async {
    const customKey = ValueKey('custom_rotation_handle');
    await pumpBox(
      tester,
      mode: RotationHandleMode.topHandle,
      rotationHandleBuilder: (_) => const SizedBox.expand(key: customKey),
    );

    expect(find.byKey(customKey), findsOneWidget);
    expect(tester.getCenter(find.byKey(customKey)),
        tester.getCenter(find.byKey(topHandleKey)));
  });

  testWidgets('supportedRotationDevices does not restrict resize gestures',
      (tester) async {
    final c = await pumpBox(
      tester,
      mode: RotationHandleMode.topHandle,
      supportedRotationDevices: const {PointerDeviceKind.mouse},
    );

    final touchRotation = await tester.startGesture(
      tester.getCenter(find.byKey(topHandleKey)),
      kind: PointerDeviceKind.touch,
    );
    await tester.pump();
    await touchRotation.moveTo(const Offset(340, 250));
    await tester.pump();
    await touchRotation.up();
    await tester.pump();
    expect(c.rotation, closeTo(0, 1e-9));

    final resize = await tester.startGesture(
      const Offset(300, 300),
      kind: PointerDeviceKind.touch,
    );
    await tester.pump();
    await resize.moveBy(const Offset(20, 20));
    await tester.pump();
    await resize.up();
    await tester.pump();

    expect(c.rect.width, greaterThan(100));
    expect(c.rect.height, greaterThan(100));
  });
}
