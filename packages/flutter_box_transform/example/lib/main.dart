import 'dart:math';

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_box_transform/flutter_box_transform.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Box Transform Demo',
      debugShowCheckedModeBanner: false,
      theme: ThemeData(
        colorScheme: ColorScheme.fromSeed(
          seedColor: Colors.deepPurple,
          brightness: Brightness.dark,
        ),
        useMaterial3: true,
      ),
      home: const MyHomePage(),
    );
  }
}

class MyHomePage extends StatefulWidget {
  const MyHomePage({super.key});

  @override
  State<MyHomePage> createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> {
  late Rect rect = Rect.fromCenter(
    center: MediaQuery.of(context).size.center(Offset.zero),
    width: 400,
    height: 300,
  );
  double rotation = 0.0;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Stack(
        fit: StackFit.expand,
        children: [
          TransformableBox(
            rect: rect,
            rotation: rotation,
            rotatable: true,
            rotationHandleMode: RotationHandleMode.both,
            clampingRect: Offset.zero & MediaQuery.sizeOf(context),
            onChanged: (result, event) {
              setState(() {
                rect = result.rect;
              });
            },
            onRotationUpdate: (result, event) {
              // Hold Shift to snap rotation to 15° detents. Uses the package's
              // modifier idiom (WidgetsBinding.instance.keyboard).
              final pressedKeys =
                  WidgetsBinding.instance.keyboard.logicalKeysPressed;
              final isShiftPressed =
                  pressedKeys.contains(LogicalKeyboardKey.shiftLeft) ||
                      pressedKeys.contains(LogicalKeyboardKey.shiftRight);
              const snapStep = pi / 12; // 15°
              setState(() {
                rect = result.rect;
                rotation = isShiftPressed
                    ? (result.rotation / snapStep).round() * snapStep
                    : result.rotation;
              });
            },
            contentBuilder: (context, rect, flip) {
              return DecoratedBox(
                decoration: BoxDecoration(
                  border: Border.all(
                    color: Theme.of(context).colorScheme.primary,
                  ),
                  image: const DecorationImage(
                    image: AssetImage('assets/image1.png'),
                    fit: BoxFit.fill,
                  ),
                ),
              );
            },
          ),
        ],
      ),
    );
  }
}
