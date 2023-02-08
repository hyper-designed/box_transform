import 'package:adaptive_theme/adaptive_theme.dart';
import 'package:flutter/material.dart';
import 'package:flutter/scheduler.dart';
import 'package:flutter_rect_resizer/flutter_rect_resizer.dart';
import 'package:provider/provider.dart';
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
        home: ChangeNotifierProvider(
          create: (_) => PlaygroundModel(),
          child: const Playground(),
        ),
      ),
    );
  }
}

class PlaygroundModel with ChangeNotifier {
  Rect box = Rect.zero;
  Flip flip = Flip.none;
  late Rect clampingBox;

  bool flipEnabled = true;

  void reset(context) {
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
    clampingBox = Rect.fromLTWH(
      0,
      0,
      MediaQuery.of(context).size.width - kSidePanelWidth,
      MediaQuery.of(context).size.height,
    );
    notifyListeners();
  }

  void onRectChanged(Rect rect, Flip flip) {
    box = rect;
    this.flip = flip;
    notifyListeners();
  }

  void onFlipChanged(Flip flip) {
    this.flip = flip;
    notifyListeners();
  }

  void onFlipEnabledChanged(bool enabled) {
    flipEnabled = enabled;
    notifyListeners();
  }

  void setClampingBox(Rect rect, {bool notify = true}) {
    clampingBox = rect;
    if (notify) notifyListeners();
  }

  void flipHorizontal() {
    flip = Flip.fromValue(flip.horizontalValue * -1, flip.verticalValue);
    notifyListeners();
  }

  void flipVertically() {
    flip = Flip.fromValue(flip.horizontalValue, flip.verticalValue * -1);
    notifyListeners();
  }
}

class Playground extends StatefulWidget {
  const Playground({super.key});

  @override
  State<Playground> createState() => _PlaygroundState();
}

const double kSidePanelWidth = 300;
const double kInitialWidth = 400;
const double kInitialHeight = 300;
const double kHandleSize = 12;
const double kStrokeWidth = 1.5;
const Color kGridColor = Color(0x7FC3E8F3);

class _PlaygroundState extends State<Playground> {
  late final PlaygroundModel model = context.read<PlaygroundModel>();

  @override
  void initState() {
    super.initState();

    // This is required to center the box based on screen size when the app
    // starts.
    SchedulerBinding.instance.addPostFrameCallback((_) {
      model.reset(context);
    });
  }

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    model.setClampingBox(
      notify: false,
      Rect.fromLTWH(
        0,
        0,
        MediaQuery.of(context).size.width - kSidePanelWidth,
        MediaQuery.of(context).size.height,
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    late final PlaygroundModel model = context.watch<PlaygroundModel>();
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
                  rect: model.clampingBox,
                  child: Container(
                    width: model.clampingBox.width,
                    height: model.clampingBox.height,
                    decoration: BoxDecoration(
                      border: Border.all(color: Colors.red, width: 1),
                    ),
                  ),
                ),
                ResizableBox(
                  box: model.box,
                  flip: model.flip,
                  clampingBox: model.clampingBox,
                  onChanged: model.onRectChanged,
                  contentBuilder: (context, rect, flip) => Transform.scale(
                    scaleX: model.flipEnabled && flip.isHorizontal ? -1 : 1,
                    scaleY: model.flipEnabled && flip.isVertical ? -1 : 1,
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
          const ControlPanel(),
        ],
      ),
    );
  }
}

class ControlPanel extends StatelessWidget {
  const ControlPanel({super.key});

  @override
  Widget build(BuildContext context) {
    final PlaygroundModel model = context.watch<PlaygroundModel>();
    final Rect rect = model.box;
    return Card(
      margin: const EdgeInsets.only(left: 0),
      shape: const RoundedRectangleBorder(),
      child: SizedBox(
        width: kSidePanelWidth,
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
                      onPressed: () => model.reset(context),
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
            ),
            const Divider(height: 1),
            Padding(
              padding: const EdgeInsets.all(16),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                mainAxisSize: MainAxisSize.min,
                children: [
                  Container(
                    padding: const EdgeInsets.fromLTRB(8, 6, 0, 6),
                    decoration: BoxDecoration(
                      color: Theme.of(context)
                          .colorScheme
                          .secondary
                          .withOpacity(0.1),
                      borderRadius: BorderRadius.circular(4),
                    ),
                    child: Row(
                      children: [
                        Expanded(
                          child: Text(
                            'FLIP',
                            style: Theme.of(context)
                                .textTheme
                                .titleSmall!
                                .copyWith(
                                  color:
                                      Theme.of(context).colorScheme.secondary,
                                ),
                          ),
                        ),
                        SizedBox(
                          height: 20,
                          child: Transform.scale(
                            scale: 0.7,
                            child: Switch(
                              value: model.flipEnabled,
                              onChanged: (value) =>
                                  model.onFlipEnabledChanged(value),
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),
                  const SizedBox(height: 8),
                  Row(
                    children: [
                      IconButton(
                        splashRadius: 10,
                        tooltip: 'Flip Horizontally',
                        constraints: const BoxConstraints(),
                        padding: const EdgeInsets.all(6),
                        onPressed: model.flipEnabled
                            ? () => model.flipHorizontal()
                            : null,
                        icon: ImageIcon(
                          const AssetImage('assets/images/ic_flip.png'),
                          size: 24,
                          color: model.flip.isHorizontal && model.flipEnabled
                              ? Theme.of(context).colorScheme.primary
                              : null,
                        ),
                      ),
                      const SizedBox(width: 8),
                      IconButton(
                        splashRadius: 10,
                        tooltip: 'Flip Vertically',
                        constraints: const BoxConstraints(),
                        padding: const EdgeInsets.all(6),
                        onPressed: model.flipEnabled
                            ? () => model.flipVertically()
                            : null,
                        icon: RotatedBox(
                          quarterTurns: 1,
                          child: ImageIcon(
                            const AssetImage('assets/images/ic_flip.png'),
                            size: 24,
                            color: model.flip.isVertical && model.flipEnabled
                                ? Theme.of(context).colorScheme.primary
                                : null,
                          ),
                        ),
                      ),
                    ],
                  ),
                ],
              ),
            ),
            const Divider(height: 1),
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
