import 'dart:developer';

import 'package:adaptive_theme/adaptive_theme.dart';
import 'package:flutter/material.dart';
import 'package:flutter_rect_resizer/flutter_rect_resizer.dart';
import 'package:url_launcher/url_launcher_string.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return AdaptiveTheme(
      light: ThemeData(
        useMaterial3: true,
        brightness: Brightness.light,
        colorSchemeSeed: Colors.blue,
      ),
      dark: ThemeData(
        useMaterial3: true,
        brightness: Brightness.dark,
        colorSchemeSeed: Colors.blue,
      ),
      initial: AdaptiveThemeMode.system,
      builder: (theme, darkTheme) => MaterialApp(
        title: 'Rect resizer demo',
        debugShowCheckedModeBanner: false,
        theme: theme,
        darkTheme: darkTheme,
        home: const MyHomePage(title: 'Flutter Demo Home Page'),
      ),
    );
  }
}

class MyHomePage extends StatefulWidget {
  const MyHomePage({super.key, required this.title});

  final String title;

  @override
  State<MyHomePage> createState() => _MyHomePageState();
}

const double kInitialWidth = 400;
const double kInitialHeight = 300;
const double kHandleSize = 12;
const double kStrokeWidth = 1.5;
const Color kGridColor = Color(0x7FC3E8F3);

class _MyHomePageState extends State<MyHomePage> {
  final FocusScopeNode focusNode = FocusScopeNode();
  final UIRectResizer resizer = UIRectResizer();

  // TODO: Remove unnecessary states since we are using Resizable widget.

  /// Keep track of the keys that are currently pressed to change
  /// the resize mode.
  List<String> pressedKeys = [];

  bool get isAltPressed => pressedKeys.contains('ALT');

  bool get isShiftPressed => pressedKeys.contains('SHIFT');

  Rect rect = Rect.zero;
  bool hasFocus = true;
  Flip flip = Flip.none;

  Offset initialLocalPosition = Offset.zero;
  Rect initialRect = Rect.zero;
  Flip initialFlip = Flip.none;

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    if (rect == Rect.zero) reset();
  }

  @override
  void dispose() {
    focusNode.dispose();
    super.dispose();
  }

  void reset() {
    final Size size = MediaQuery.of(context).size;
    final double width = size.width - 300;
    final double height = size.height;
    rect = Rect.fromLTWH(
      (width - kInitialWidth) / 2,
      (height - kInitialHeight) / 2,
      kInitialWidth,
      kInitialHeight,
    );
    flip = Flip.none;
    if (mounted) setState(() {});
  }

  void onFocusChanged(bool hasFocus) {
    setState(() => this.hasFocus = hasFocus);
  }

  @override
  Widget build(BuildContext context) {
    final Color handleColor = hasFocus
        ? Theme.of(context).colorScheme.primary
        : Theme.of(context).disabledColor;
    return Scaffold(
      backgroundColor: Theme.of(context).scaffoldBackgroundColor,
      body: FocusScope(
        node: focusNode,
        autofocus: true,
        onFocusChange: onFocusChanged,
        onKey: onKeyEvent,
        child: Row(
          children: [
            Expanded(
              child: Stack(
                fit: StackFit.expand,
                children: [
                  Positioned.fill(
                    child: GridPaper(
                      color: Theme.of(context).brightness == Brightness.dark
                          ? kGridColor.withOpacity(0.1)
                          : kGridColor,
                    ),
                  ),
                  ResizableBox(
                    box: rect,
                    onChanged: (box, flip) {
                      setState(() {
                        rect = box;
                        this.flip = flip;
                      });
                    },
                    contentBuilder: (context, rect, flip) => Transform.scale(
                      scaleX: flip.isHorizontal ? -1 : 1,
                      scaleY: flip.isVertical ? -1 : 1,
                      child: Container(
                        width: rect.width,
                        height: rect.height,
                        decoration: BoxDecoration(
                          color: Colors.white,
                          image: const DecorationImage(
                            image: AssetImage('assets/images/landscape2.jpg'),
                            fit: BoxFit.fill,
                          ),
                          border: Border.all(
                            color: handleColor,
                            width: 2,
                          ),
                          // boxShadow: [
                          //   BoxShadow(
                          //     color: Colors.black.withOpacity(0.1),
                          //     blurRadius: 8,
                          //     spreadRadius: 5,
                          //   ),
                          // ],
                        ),
                      ),
                    ),
                  ),
                  // Top left
                  // Positioned(
                  //   left: rect.left - kHandleSize / 2 + kStrokeWidth,
                  //   top: rect.top - kHandleSize / 2 + kStrokeWidth,
                  //   child: GestureDetector(
                  //     onPanStart: onPanStart,
                  //     onPanUpdate: (details) =>
                  //         onPanUpdate(details, HandlePosition.topLeft),
                  //     onPanEnd: onPanEnd,
                  //     child: MouseRegion(
                  //       cursor: SystemMouseCursors.resizeUpLeft,
                  //       child: Container(
                  //         width: kHandleSize,
                  //         height: kHandleSize,
                  //         decoration: BoxDecoration(
                  //           color: Theme.of(context).scaffoldBackgroundColor,
                  //           shape: BoxShape.circle,
                  //           border: Border.all(
                  //             color: handleColor,
                  //             width: kStrokeWidth,
                  //           ),
                  //         ),
                  //       ),
                  //     ),
                  //   ),
                  // ),
                  // // Top right
                  // Positioned(
                  //   left: rect.right - kHandleSize / 2 - kStrokeWidth,
                  //   top: rect.top - kHandleSize / 2 + kStrokeWidth,
                  //   child: GestureDetector(
                  //     onPanStart: onPanStart,
                  //     onPanUpdate: (details) =>
                  //         onPanUpdate(details, HandlePosition.topRight),
                  //     onPanEnd: onPanEnd,
                  //     child: MouseRegion(
                  //       cursor: SystemMouseCursors.resizeUpRight,
                  //       child: Container(
                  //         width: kHandleSize,
                  //         height: kHandleSize,
                  //         decoration: BoxDecoration(
                  //           color: Theme.of(context).scaffoldBackgroundColor,
                  //           shape: BoxShape.circle,
                  //           border: Border.all(
                  //             color: handleColor,
                  //             width: kStrokeWidth,
                  //           ),
                  //         ),
                  //       ),
                  //     ),
                  //   ),
                  // ),
                  // // Bottom left
                  // Positioned(
                  //   left: rect.left - kHandleSize / 2 + kStrokeWidth,
                  //   top: rect.bottom - kHandleSize / 2 - kStrokeWidth,
                  //   child: GestureDetector(
                  //     onPanStart: onPanStart,
                  //     onPanUpdate: (details) =>
                  //         onPanUpdate(details, HandlePosition.bottomLeft),
                  //     onPanEnd: onPanEnd,
                  //     child: MouseRegion(
                  //       cursor: SystemMouseCursors.resizeDownLeft,
                  //       child: Container(
                  //         width: kHandleSize,
                  //         height: kHandleSize,
                  //         decoration: BoxDecoration(
                  //           color: Theme.of(context).scaffoldBackgroundColor,
                  //           shape: BoxShape.circle,
                  //           border: Border.all(
                  //             color: handleColor,
                  //             width: kStrokeWidth,
                  //           ),
                  //         ),
                  //       ),
                  //     ),
                  //   ),
                  // ),
                  // // Bottom right
                  // Positioned(
                  //   left: rect.right - kHandleSize / 2 - kStrokeWidth,
                  //   top: rect.bottom - kHandleSize / 2 - kStrokeWidth,
                  //   child: GestureDetector(
                  //     onPanStart: onPanStart,
                  //     onPanUpdate: (details) =>
                  //         onPanUpdate(details, HandlePosition.bottomRight),
                  //     onPanEnd: onPanEnd,
                  //     child: MouseRegion(
                  //       cursor: SystemMouseCursors.resizeDownRight,
                  //       child: Container(
                  //         width: kHandleSize,
                  //         height: kHandleSize,
                  //         decoration: BoxDecoration(
                  //           color: Theme.of(context).scaffoldBackgroundColor,
                  //           shape: BoxShape.circle,
                  //           border: Border.all(
                  //             color: handleColor,
                  //             width: kStrokeWidth,
                  //           ),
                  //         ),
                  //       ),
                  //     ),
                  //   ),
                  // ),
                  // // Keyboard indicator
                  // Positioned(
                  //   bottom: 12,
                  //   left: 12,
                  //   child: KeyboardListenerIndicator(
                  //     pressedKeys: pressedKeys,
                  //     onClear: () => setState(() => pressedKeys.clear()),
                  //   ),
                  // ),
                ],
              ),
            ),
            ControlPanel(
              key: ValueKey(rect),
              rect: rect,
              onReset: reset,
            ),
          ],
        ),
      ),
    );
  }

  void onDragUpdate(details) {
    // TODO: implement dragging feature in the package.
    setState(() => rect = rect.shift(details.delta));
  }

  void onPanStart(DragStartDetails details) {
    initialLocalPosition = details.localPosition;
    initialRect = rect;
    initialFlip = flip;
  }

  void onPanUpdate(DragUpdateDetails details, HandlePosition handle) {
    final UIResizeResult result = resizer.resize(
      initialRect: initialRect,
      initialLocalPosition: initialLocalPosition,
      localPosition: details.localPosition,
      handle: handle,
      resizeMode: getResizeMode(),
      initialFlip: initialFlip,
    );

    rect = result.newRect;
    flip = result.flip;
    setState(() {});

    log('new size: ${result.newRect.size} new flip: ${result.flip}');
    // log('new Rect: $rect');
  }

  void onPanEnd(DragEndDetails details) {
    initialLocalPosition = Offset.zero;
    initialRect = Rect.zero;
    initialFlip = Flip.none;
    setState(() {});
  }

  ResizeMode getResizeMode() {
    if (isAltPressed && isShiftPressed) {
      return ResizeMode.symmetricScale;
    } else if (isAltPressed) {
      return ResizeMode.symmetric;
    } else if (isShiftPressed) {
      return ResizeMode.scale;
    } else {
      return ResizeMode.freeform;
    }
  }

  KeyEventResult onKeyEvent(FocusNode node, RawKeyEvent event) {
    bool changed = false;
    bool handled = false;

    // SHIFT
    if (!pressedKeys.contains('SHIFT') &&
        event.isShiftPressed &&
        focusNode.hasPrimaryFocus) {
      pressedKeys.insert(0, 'SHIFT');
      changed = true;
      handled = true;
    } else if (!event.isShiftPressed && pressedKeys.contains('SHIFT')) {
      pressedKeys.remove('SHIFT');
      changed = true;
      handled = true;
    } else if (event.isShiftPressed && pressedKeys.contains('SHIFT')) {
      handled = true;
    }

    // ALT
    if (!pressedKeys.contains('ALT') &&
        event.isAltPressed &&
        focusNode.hasPrimaryFocus) {
      pressedKeys.add('ALT');
      changed = true;
      handled = true;
    } else if (!event.isAltPressed && pressedKeys.contains('ALT')) {
      pressedKeys.remove('ALT');
      changed = true;
      handled = true;
    } else if (event.isAltPressed && pressedKeys.contains('ALT')) {
      handled = true;
    }

    if (changed) setState(() {});

    return handled && focusNode.hasPrimaryFocus
        ? KeyEventResult.handled
        : KeyEventResult.ignored;
  }
}

class ControlPanel extends StatelessWidget {
  final Rect rect;
  final VoidCallback onReset;

  const ControlPanel({super.key, required this.onReset, required this.rect});

  @override
  Widget build(BuildContext context) {
    return Card(
      margin: const EdgeInsets.only(left: 0),
      shape: const RoundedRectangleBorder(),
      child: SizedBox(
        width: 300,
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          mainAxisAlignment: MainAxisAlignment.start,
          children: [
            Padding(
              padding: const EdgeInsets.fromLTRB(16, 8, 8, 8),
              child: Row(
                children: [
                  Expanded(
                    child: FilledButton.tonalIcon(
                      onPressed: onReset,
                      icon: const Icon(Icons.refresh),
                      label: const Text('Reset'),
                    ),
                  ),
                  const SizedBox(width: 16),
                  IconButton(
                    tooltip: 'Open on GitHub',
                    onPressed: () => launchUrlString(
                        'https://github.com/birjuvachhani/rect_resizer'),
                    icon: const Icon(Icons.open_in_new_rounded),
                  ),
                  const SizedBox(width: 8),
                  IconButton(
                    onPressed: () =>
                        AdaptiveTheme.of(context).toggleThemeMode(),
                    tooltip: 'Toggle Theme',
                    icon: ValueListenableBuilder<AdaptiveThemeMode>(
                      valueListenable:
                          AdaptiveTheme.of(context).modeChangeNotifier,
                      builder: (context, mode, child) => Icon(
                        mode == AdaptiveThemeMode.system
                            ? Icons.brightness_auto_outlined
                            : mode == AdaptiveThemeMode.dark
                                ? Icons.brightness_2_outlined
                                : Icons.brightness_5_rounded,
                      ),
                    ),
                  ),
                ],
              ),
            ),
            const Divider(height: 1),
            Padding(
              padding: const EdgeInsets.all(16),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.stretch,
                mainAxisSize: MainAxisSize.min,
                children: [
                  const SectionHeader('POSITION'),
                  const SizedBox(height: 16),
                  Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 8),
                    child: Column(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        Row(
                          children: const [
                            Expanded(child: Label('X')),
                            Expanded(child: Label('Y')),
                          ],
                        ),
                        const SizedBox(height: 8),
                        Row(
                          children: [
                            Expanded(
                              child: ValueText(rect.left.toStringAsFixed(0)),
                            ),
                            Expanded(
                              child: ValueText(rect.top.toStringAsFixed(0)),
                            ),
                          ],
                        ),
                        const SizedBox(height: 16),
                        Row(
                          children: const [
                            Expanded(child: Label('WIDTH')),
                            Expanded(child: Label('HEIGHT')),
                          ],
                        ),
                        const SizedBox(height: 8),
                        Row(
                          children: [
                            Expanded(
                              child: ValueText(rect.width.toStringAsFixed(0)),
                            ),
                            Expanded(
                              child: ValueText(rect.height.toStringAsFixed(0)),
                            ),
                          ],
                        ),
                        const SizedBox(height: 16),
                        Row(
                          children: const [
                            Expanded(child: Label('ASPECT RATIO')),
                          ],
                        ),
                        const SizedBox(height: 8),
                        Row(
                          children: [
                            Expanded(
                              child: ValueText(
                                (rect.width / rect.height).toStringAsFixed(2),
                              ),
                            ),
                          ],
                        ),
                      ],
                    ),
                  ),
                ],
              ),
            )
          ],
        ),
      ),
    );
  }
}

class KeyboardListenerIndicator extends StatelessWidget {
  final List<String> pressedKeys;
  final VoidCallback onClear;

  const KeyboardListenerIndicator({
    super.key,
    required this.pressedKeys,
    required this.onClear,
  });

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisSize: MainAxisSize.min,
      children: [
        for (final key in pressedKeys)
          Container(
            margin: EdgeInsets.only(right: pressedKeys.last != key ? 12 : 0),
            padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 8),
            decoration: BoxDecoration(
              color: Theme.of(context).scaffoldBackgroundColor,
              borderRadius: BorderRadius.circular(6),
              border: Border.all(
                color: Theme.of(context).colorScheme.primary,
                width: 1.5,
              ),
              boxShadow: [
                BoxShadow(
                  color:
                      Theme.of(context).colorScheme.onPrimary.withOpacity(0.2),
                  blurRadius: 1,
                  offset: const Offset(1, 3),
                ),
              ],
            ),
            child: Text(
              key,
              style: TextStyle(
                color: Theme.of(context).colorScheme.primary,
                fontWeight: FontWeight.bold,
              ),
            ),
          ),
        if (pressedKeys.isNotEmpty)
          IconButton(
            onPressed: onClear,
            splashRadius: 16,
            iconSize: 18,
            icon: Icon(
              Icons.clear,
              color: Colors.grey.shade400,
            ),
          ),
      ],
    );
  }
}

class Label extends StatelessWidget {
  final String label;

  const Label(this.label, {super.key});

  @override
  Widget build(BuildContext context) {
    return Text(label,
        style: Theme.of(context).textTheme.labelMedium!.copyWith(
              color: Theme.of(context).colorScheme.primary,
            ));
  }
}

class ValueText extends StatelessWidget {
  final String value;

  const ValueText(this.value, {super.key});

  @override
  Widget build(BuildContext context) {
    return Text(
      value,
      style: Theme.of(context).textTheme.titleMedium,
    );
  }
}

class SectionHeader extends StatelessWidget {
  final String title;

  const SectionHeader(this.title, {super.key});

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 6),
      decoration: BoxDecoration(
        color: Theme.of(context).colorScheme.secondary.withOpacity(0.1),
        borderRadius: BorderRadius.circular(4),
      ),
      child: Text(
        title,
        style: Theme.of(context).textTheme.titleSmall!.copyWith(
              color: Theme.of(context).colorScheme.secondary,
            ),
      ),
    );
  }
}
