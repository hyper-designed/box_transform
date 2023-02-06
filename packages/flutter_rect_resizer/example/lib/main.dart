import 'package:adaptive_theme/adaptive_theme.dart';
import 'package:flutter/material.dart';
import 'package:flutter/scheduler.dart';
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
  final ResizableBoxController controller = ResizableBoxController();

  Rect box = Rect.zero;
  Flip flip = Flip.none;
  Rect clampingBox = const Rect.fromLTWH(100, 100, 500, 500);

  @override
  void initState() {
    super.initState();

    SchedulerBinding.instance.addPostFrameCallback((_) {
      reset();
    });
  }

  @override
  void dispose() {
    controller.dispose();
    super.dispose();
  }

  void reset() {
    final Size size = MediaQuery.of(context).size;
    final double width = size.width - 300;
    final double height = size.height;
    box = Rect.fromLTWH(
      (width - kInitialWidth) / 2,
      (height - kInitialHeight) / 2,
      kInitialWidth,
      kInitialHeight,
    );
    flip = Flip.none;
    controller.setRect(box);
    controller.setFlip(flip);
    if (mounted) setState(() {});
  }

  @override
  Widget build(BuildContext context) {
    final Color handleColor = Theme.of(context).colorScheme.primary;
    return Scaffold(
      backgroundColor: Theme.of(context).scaffoldBackgroundColor,
      body: Row(
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
                Positioned.fromRect(
                    rect: clampingBox,
                    child: Container(
                        width: clampingBox.width,
                        height: clampingBox.height,
                        decoration: BoxDecoration(
                          border: Border.all(color: Colors.red, width: 1),
                        ))),
                ResizableBox(
                  box: box,
                  controller: controller,
                  clampingBox: clampingBox,
                  onChanged: (rect, flip) {
                    setState(() {
                      box = rect;
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
              ],
            ),
          ),
          ControlPanel(
            key: ValueKey(box),
            rect: box,
            onReset: reset,
          ),
        ],
      ),
    );
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
