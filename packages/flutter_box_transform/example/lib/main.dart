import 'package:adaptive_theme/adaptive_theme.dart';
import 'package:flutter/material.dart';
import 'package:flutter/scheduler.dart';
import 'package:flutter/services.dart';
import 'package:flutter_box_transform/flutter_box_transform.dart';
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
        inputDecorationTheme: InputDecorationTheme(
          isDense: true,
          contentPadding:
              const EdgeInsets.symmetric(horizontal: 10, vertical: 12),
          border: OutlineInputBorder(
            borderRadius: BorderRadius.circular(6),
          ),
        ),
      ),
      dark: ThemeData(
        useMaterial3: true,
        brightness: Brightness.dark,
        colorSchemeSeed: Colors.blue,
        inputDecorationTheme: InputDecorationTheme(
          isDense: true,
          contentPadding:
              const EdgeInsets.symmetric(horizontal: 10, vertical: 12),
          border: OutlineInputBorder(
            borderRadius: BorderRadius.circular(6),
          ),
        ),
      ),
      initial: AdaptiveThemeMode.system,
      builder: (theme, darkTheme) => MaterialApp(
        title: 'Box Transform demo',
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
  Rect rect = Rect.zero;
  Flip flip = Flip.none;

  bool showSecondImageBox = false;
  Rect rect2 = Rect.zero;
  Flip flip2 = Flip.none;

  Rect clampingRect = Rect.largest;
  Rect? playgroundArea;
  late BoxConstraints constraints = const BoxConstraints(
    minWidth: 0,
    minHeight: 0,
  );

  bool flipRectWhileResizing = true;
  bool flipChild = true;
  bool clampingEnabled = false;
  bool constraintsEnabled = false;
  bool resizable = true;
  bool movable = true;
  bool hideHandlesWhenNotResizable = true;

  void reset(BuildContext context) {
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

    rect2 = Rect.fromLTWH(
      (width - kInitialWidth) / 3,
      (height - kInitialHeight) / 3,
      kInitialWidth,
      kInitialHeight,
    );
    flip2 = Flip.none;

    clampingRect = Rect.fromLTWH(
      0,
      0,
      size.width - kSidePanelWidth,
      size.height,
    );

    constraints = const BoxConstraints(
      minWidth: 0,
      minHeight: 0,
    );

    resizable = true;
    movable = true;
    clampingEnabled = false;
    constraintsEnabled = false;
    hideHandlesWhenNotResizable = true;

    notifyListeners();
  }

  void onRectChanged(UITransformResult result) {
    rect = result.rect;
    flip = result is UIResizeResult ? result.flip : flip;
    notifyListeners();
  }

  void onRect2Changed(UITransformResult result) {
    rect2 = result.rect;
    flip2 = result is UIResizeResult ? result.flip : flip;
    notifyListeners();
  }

  void onFlipChanged(Flip flip) {
    this.flip = flip;
    notifyListeners();
  }

  void onFlipChildChanged(bool enabled) {
    flipChild = enabled;
    notifyListeners();
  }

  void onFlipWhileResizingChanged(bool enabled) {
    flipRectWhileResizing = enabled;
    notifyListeners();
  }

  void setClampingRect(Rect rect,
      {bool notify = true, bool insidePlayground = false}) {
    clampingRect = rect;

    if (insidePlayground && playgroundArea != null) {
      clampingRect = Rect.fromLTWH(
        clampingRect.left.clamp(0.0, playgroundArea!.width),
        clampingRect.top.clamp(0.0, playgroundArea!.height),
        clampingRect.width.clamp(0.0, playgroundArea!.width),
        clampingRect.height.clamp(0.0, playgroundArea!.height),
      );
    }

    if (notify) notifyListeners();
  }

  void setConstraints(BoxConstraints constraints, {bool notify = true}) {
    this.constraints = constraints;

    if (notify) notifyListeners();
  }

  void flipHorizontally() {
    flip = Flip.fromValue(flip.horizontalValue * -1, flip.verticalValue);
    notifyListeners();
  }

  void flipVertically() {
    flip = Flip.fromValue(flip.horizontalValue, flip.verticalValue * -1);
    notifyListeners();
  }

  void toggleClamping(bool enabled) {
    clampingEnabled = enabled;
    notifyListeners();
  }

  void toggleResizing(bool enabled) {
    resizable = enabled;
    notifyListeners();
  }

  void toggleMoving(bool enabled) {
    movable = enabled;
    notifyListeners();
  }

  void toggleConstraints(bool enabled) {
    constraintsEnabled = enabled;
    notifyListeners();
  }

  void toggleHideHandlesWhenNotResizable(bool enabled) {
    hideHandlesWhenNotResizable = enabled;
    notifyListeners();
  }

  void toggleShowSecondImageBox(bool enabled) {
    showSecondImageBox = enabled;
    notifyListeners();
  }

  void onClampingRectChanged({
    double? left,
    double? top,
    double? right,
    double? bottom,
  }) {
    clampingRect = Rect.fromLTRB(
      left ?? clampingRect.left,
      top ?? clampingRect.top,
      right ?? clampingRect.right,
      bottom ?? clampingRect.bottom,
    );
    notifyListeners();
  }

  void onConstraintsChanged({
    double? minWidth,
    double? minHeight,
    double? maxWidth,
    double? maxHeight,
    bool forceMinWidth = false,
    bool forceMinHeight = false,
    bool forceMaxWidth = false,
    bool forceMaxHeight = false,
  }) {
    constraints = BoxConstraints(
      minWidth:
          forceMinWidth ? minWidth ?? 0 : minWidth ?? constraints.minWidth,
      minHeight:
          forceMinHeight ? minHeight ?? 0 : minHeight ?? constraints.minHeight,
      maxWidth: forceMaxWidth
          ? maxWidth ?? double.infinity
          : maxWidth ?? constraints.maxWidth,
      maxHeight: forceMaxHeight
          ? maxHeight ?? double.infinity
          : maxHeight ?? constraints.maxHeight,
    );
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
const double kStrokeWidth = 1.5;
const Color kGridColor = Color.fromARGB(126, 27, 181, 228);

class _PlaygroundState extends State<Playground> with WidgetsBindingObserver {
  @override
  void initState() {
    super.initState();

    // This is required to center the box based on screen size when the app
    // starts.
    SchedulerBinding.instance.addPostFrameCallback((_) {
      final PlaygroundModel model = context.read<PlaygroundModel>();
      model.reset(context);
    });

    WidgetsBinding.instance.addObserver(this);
  }

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    resetPlayground();
  }

  @override
  void didChangeMetrics() {
    super.didChangeMetrics();
    resetPlayground(notify: true);
  }

  @override
  void dispose() {
    WidgetsBinding.instance.removeObserver(this);
    super.dispose();
  }

  // This is done to automatically resize clamping rect to the new screen size
  // when the app is resized but only when the clampingRect is already
  // set to the full screen. This is done to avoid the clamping rect to be
  // resized when the user has already resized it.
  void resetPlayground({bool notify = false}) {
    final PlaygroundModel model = context.read<PlaygroundModel>();
    final Size size = MediaQuery.of(context).size;
    model.playgroundArea = Rect.fromLTWH(
      0,
      0,
      size.width - kSidePanelWidth,
      size.height,
    );

    final Rect playgroundArea = model.playgroundArea!;
    if (model.clampingRect.width > playgroundArea.width ||
        model.clampingRect.height > playgroundArea.height) {
      model.setClampingRect(
        model.clampingRect,
        notify: notify,
        insidePlayground: true,
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    final PlaygroundModel model = context.watch<PlaygroundModel>();

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
                if (model.clampingEnabled && model.playgroundArea != null)
                  const ClampingRect(),
                ImageBox(rect:model.rect, flip:model.flip, imageAsset:'assets/images/landscape2.jpg', onChanged:model.onRectChanged),
                if(model.showSecondImageBox) ImageBox(rect:model.rect2, flip:model.flip2, imageAsset:'assets/images/landscape.jpg', onChanged:model.onRect2Changed),
              ],
            ),
          ),
          const ControlPanel(),
        ],
      ),
    );
  }
}

class ImageBox extends StatefulWidget {
  const ImageBox({super.key, required this.rect, required this.flip, required this.imageAsset,
        required this.onChanged});

  final Rect rect;
  final Flip flip;
  final String imageAsset;
  final Function(TransformResult<Rect, Offset, Size>)? onChanged;

  @override
  State<ImageBox> createState() => _ImageBoxState();
}

class _ImageBoxState extends State<ImageBox> {
  bool minWidthReached = false;
  bool minHeightReached = false;
  bool maxWidthReached = false;
  bool maxHeightReached = false;

  @override
  Widget build(BuildContext context) {
    final PlaygroundModel model = context.watch<PlaygroundModel>();
    final Color handleColor = Theme.of(context).colorScheme.primary;
    return TransformableBox(
      key: ValueKey('image-box-${widget.imageAsset}'),
      rect: widget.rect,
      flip: widget.flip,
      clampingRect: model.clampingEnabled ? model.clampingRect : null,
      constraints: model.constraintsEnabled ? model.constraints : null,
      onChanged: widget.onChanged,
      resizable: model.resizable,
      hideHandlesWhenNotResizable: model.hideHandlesWhenNotResizable,
      movable: model.movable,
      flipChild: model.flipChild,
      flipWhileResizing: model.flipRectWhileResizing,
      onTerminalSizeReached: (
        bool reachedMinWidth,
        bool reachedMaxWidth,
        bool reachedMinHeight,
        bool reachedMaxHeight,
      ) {
        if (minWidthReached == reachedMinWidth &&
            minHeightReached == reachedMinHeight &&
            maxWidthReached == reachedMaxWidth &&
            maxHeightReached == reachedMaxHeight) return;

        setState(() {
          minWidthReached = reachedMinWidth;
          minHeightReached = reachedMinHeight;
          maxWidthReached = reachedMaxWidth;
          maxHeightReached = reachedMaxHeight;
        });
      },
      childBuilder: (context, rect, flip) => Container(
        width: rect.width,
        height: rect.height,
        decoration: BoxDecoration(
          color: Colors.white,
          image: DecorationImage(
            image: AssetImage(widget.imageAsset),
            fit: BoxFit.fill,
          ),
          border: Border.symmetric(
            horizontal: BorderSide(
              color: minHeightReached
                  ? Colors.orange
                  : maxHeightReached
                      ? Colors.red
                      : handleColor,
              width: 2,
            ),
            vertical: BorderSide(
              color: minWidthReached
                  ? Colors.orange
                  : maxWidthReached
                      ? Colors.red
                      : handleColor,
              width: 2,
            ),
          ),
        ),
      ),
    );
  }
}

class ClampingRect extends StatefulWidget {
  const ClampingRect({super.key});

  @override
  State<ClampingRect> createState() => _ClampingRectState();
}

class _ClampingRectState extends State<ClampingRect> {
  bool minWidthReached = false;
  bool minHeightReached = false;
  bool maxWidthReached = false;
  bool maxHeightReached = false;

  @override
  Widget build(BuildContext context) {
    final PlaygroundModel model = context.watch<PlaygroundModel>();
    const Color mainColor = Colors.green;
    final Color horizontalEdgeColor, verticalEdgeColor;
    final bool anyTerminalSize = minWidthReached ||
        minHeightReached ||
        maxWidthReached ||
        maxHeightReached;
    if (minHeightReached) {
      horizontalEdgeColor = Colors.orange;
    } else if (maxHeightReached) {
      horizontalEdgeColor = Colors.red;
    } else {
      horizontalEdgeColor = mainColor;
    }
    if (minWidthReached) {
      verticalEdgeColor = Colors.orange;
    } else if (maxWidthReached) {
      verticalEdgeColor = Colors.red;
    } else {
      verticalEdgeColor = mainColor;
    }

    final String label;
    if (minWidthReached && minHeightReached) {
      label = 'Min size reached';
    } else if (maxWidthReached && maxHeightReached) {
      label = 'Max size reached';
    } else if (minWidthReached) {
      label = 'Min width reached';
    } else if (minHeightReached) {
      label = 'Min height reached';
    } else if (maxWidthReached) {
      label = 'Max width reached';
    } else if (maxHeightReached) {
      label = 'Max height reached';
    } else {
      label = 'Clamping Box';
    }

    return TransformableBox(
      key: const ValueKey('clamping-box'),
      rect: model.clampingRect,
      flip: Flip.none,
      clampingRect: model.playgroundArea!,
      constraints: BoxConstraints(
        minWidth: model.rect.width,
        minHeight: model.rect.height,
      ),
      onChanged: (result) => model.setClampingRect(result.rect),
      onTerminalSizeReached: (
        bool reachedMinWidth,
        bool reachedMaxWidth,
        bool reachedMinHeight,
        bool reachedMaxHeight,
      ) {
        if (minWidthReached == reachedMinWidth &&
            minHeightReached == reachedMinHeight &&
            maxWidthReached == reachedMaxWidth &&
            maxHeightReached == reachedMaxHeight) return;

        setState(() {
          minWidthReached = reachedMinWidth;
          minHeightReached = reachedMinHeight;
          maxWidthReached = reachedMaxWidth;
          maxHeightReached = reachedMaxHeight;
        });
      },
      handleAlign: HandleAlign.inside,
      cornerHandleBuilder: (context, handle) => AngularHandle(
        handle: handle,
        color: mainColor,
        hasShadow: false,
        handleAlign: HandleAlign.inside,
      ),
      sideHandleBuilder: (context, handle) => AngularHandle(
        handle: handle,
        color: mainColor,
        hasShadow: false,
        handleAlign: HandleAlign.inside,
      ),
      childBuilder: (context, _, flip) => Container(
        width: model.clampingRect.width,
        height: model.clampingRect.height,
        alignment: Alignment.bottomRight,
        decoration: BoxDecoration(
          border: Border.symmetric(
            horizontal: BorderSide(
              color: horizontalEdgeColor,
              width: 1.5,
            ),
            vertical: BorderSide(
              color: verticalEdgeColor,
              width: 1.5,
            ),
          ),
        ),
        child: DecoratedBox(
          decoration: BoxDecoration(
            color:
                (anyTerminalSize ? Colors.orange : mainColor).withOpacity(0.1),
            borderRadius: const BorderRadius.only(
              topLeft: Radius.circular(6),
            ),
          ),
          child: Padding(
            padding: const EdgeInsets.all(8.0),
            child: Text(
              label,
              style: TextStyle(
                color: anyTerminalSize ? Colors.orange : mainColor,
                fontSize: 12,
              ),
            ),
          ),
        ),
      ),
    );
  }
}

class ControlPanel extends StatelessWidget {
  const ControlPanel({super.key});

  @override
  Widget build(BuildContext context) {
    final PlaygroundModel model = context.watch<PlaygroundModel>();
    return Card(
      margin: const EdgeInsets.only(left: 0),
      shape: const RoundedRectangleBorder(),
      child: SizedBox(
        width: kSidePanelWidth,
        child: ListView(
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
            const PositionControls(),
            const Divider(height: 1),
            Container(
              height: 44,
              padding: const EdgeInsets.fromLTRB(16, 0, 6, 0),
              alignment: Alignment.centerLeft,
              child: Row(
                children: [
                  Expanded(
                    child: Text(
                      'Resizable',
                      style: Theme.of(context).textTheme.titleSmall!.copyWith(
                            color: Theme.of(context).colorScheme.secondary,
                          ),
                    ),
                  ),
                  SizedBox(
                    height: 20,
                    child: Transform.scale(
                      scale: 0.7,
                      child: Switch(
                        value: model.resizable,
                        onChanged: (value) => model.toggleResizing(value),
                      ),
                    ),
                  ),
                ],
              ),
            ),
            const Divider(height: 1),
            Container(
              height: 44,
              padding: const EdgeInsets.fromLTRB(16, 0, 6, 0),
              alignment: Alignment.centerLeft,
              child: Row(
                children: [
                  Expanded(
                    child: Text(
                      'Movable',
                      style: Theme.of(context).textTheme.titleSmall!.copyWith(
                            color: Theme.of(context).colorScheme.secondary,
                          ),
                    ),
                  ),
                  SizedBox(
                    height: 20,
                    child: Transform.scale(
                      scale: 0.7,
                      child: Switch(
                        value: model.movable,
                        onChanged: (value) => model.toggleMoving(value),
                      ),
                    ),
                  ),
                ],
              ),
            ),
            const Divider(height: 1),
            Container(
              height: 44,
              padding: const EdgeInsets.fromLTRB(16, 0, 6, 0),
              alignment: Alignment.centerLeft,
              child: Row(
                children: [
                  Expanded(
                    child: Text(
                      'Hide corner/side controls if not resizable',
                      style: Theme.of(context).textTheme.titleSmall!.copyWith(
                            color: Theme.of(context).colorScheme.secondary,
                          ),
                    ),
                  ),
                  SizedBox(
                    height: 20,
                    child: Transform.scale(
                      scale: 0.7,
                      child: Switch(
                        value: model.hideHandlesWhenNotResizable,
                        onChanged: (value) => model.toggleHideHandlesWhenNotResizable(value),
                      ),
                    ),
                  ),
                ],
              ),
            ),
            const Divider(height: 1),
            const FlipControls(),
            const Divider(height: 1),
            const ClampingControls(),
            const Divider(height: 1),
            const ConstraintsControls(),
            const Divider(height: 1),
            Container(
              height: 44,
              padding: const EdgeInsets.fromLTRB(16, 0, 6, 0),
              alignment: Alignment.centerLeft,
              child: Row(
                children: [
                  Expanded(
                    child: Text(
                      'Add second image',
                      style: Theme.of(context).textTheme.titleSmall!.copyWith(
                            color: Theme.of(context).colorScheme.secondary,
                          ),
                    ),
                  ),
                  SizedBox(
                    height: 20,
                    child: Transform.scale(
                      scale: 0.7,
                      child: Switch(
                        value: model.showSecondImageBox,
                        onChanged: (value) => model.toggleShowSecondImageBox(value),
                      ),
                    ),
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

class PositionControls extends StatelessWidget {
  const PositionControls({super.key});

  @override
  Widget build(BuildContext context) {
    final PlaygroundModel model = context.watch<PlaygroundModel>();
    final Rect rect = model.rect;
    return Column(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      mainAxisSize: MainAxisSize.min,
      children: [
        const SectionHeader('POSITION'),
        Padding(
          padding: const EdgeInsets.fromLTRB(16, 0, 16, 16),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              const Row(
                children: [
                  Expanded(child: Label('X')),
                  SizedBox(width: 16),
                  Expanded(child: Label('Y')),
                ],
              ),
              const SizedBox(height: 8),
              Row(
                children: [
                  Expanded(
                    child: ValueText(rect.left.toStringAsFixed(0)),
                  ),
                  const SizedBox(width: 16),
                  Expanded(
                    child: ValueText(rect.top.toStringAsFixed(0)),
                  ),
                ],
              ),
              const SizedBox(height: 16),
              const Row(
                children: [
                  Expanded(child: Label('WIDTH')),
                  SizedBox(width: 16),
                  Expanded(child: Label('HEIGHT')),
                ],
              ),
              const SizedBox(height: 8),
              Row(
                children: [
                  Expanded(
                    child: ValueText(rect.width.toStringAsFixed(0)),
                  ),
                  const SizedBox(width: 16),
                  Expanded(
                    child: ValueText(rect.height.toStringAsFixed(0)),
                  ),
                ],
              ),
              const SizedBox(height: 16),
              const Row(
                children: [
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
    );
  }
}

class FlipControls extends StatelessWidget {
  const FlipControls({super.key});

  @override
  Widget build(BuildContext context) {
    final PlaygroundModel model = context.watch<PlaygroundModel>();
    return AnimatedSize(
      duration: const Duration(milliseconds: 200),
      curve: Curves.easeInOut,
      alignment: Alignment.topCenter,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        mainAxisSize: MainAxisSize.min,
        children: [
          Container(
            // color: Theme.of(context).colorScheme.secondary.withOpacity(0.1),
            // height: 44,
            padding: const EdgeInsets.fromLTRB(16, 16, 6, 16),
            alignment: Alignment.centerLeft,
            child: Row(
              children: [
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      Text(
                        'Flip rect while resizing',
                        style: Theme.of(context).textTheme.titleSmall!.copyWith(
                              color: Theme.of(context).colorScheme.secondary,
                              fontWeight: FontWeight.bold,
                            ),
                      ),
                      const SizedBox(height: 4),
                      FractionallySizedBox(
                        widthFactor: 0.9,
                        child: Text(
                          'Allows to flip the rect while resizing. The actual contents of the rect won\'t be flipped.',
                          style: Theme.of(context)
                              .textTheme
                              .bodySmall!
                              .copyWith(
                                color: Theme.of(context).colorScheme.secondary,
                              ),
                        ),
                      ),
                    ],
                  ),
                ),
                SizedBox(
                  height: 20,
                  child: Transform.scale(
                    scale: 0.7,
                    child: Switch(
                      value: model.flipRectWhileResizing,
                      onChanged: (value) =>
                          model.onFlipWhileResizingChanged(value),
                    ),
                  ),
                ),
              ],
            ),
          ),
          const Divider(height: 1),
          Container(
            // color: Theme.of(context).colorScheme.secondary.withOpacity(0.1),
            // height: 44,
            padding: const EdgeInsets.fromLTRB(16, 16, 6, 16),
            alignment: Alignment.centerLeft,
            child: Row(
              children: [
                Expanded(
                  child: Column(
                    mainAxisSize: MainAxisSize.min,
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        'Flip Child',
                        style: Theme.of(context).textTheme.titleSmall!.copyWith(
                              color: Theme.of(context).colorScheme.secondary,
                            ),
                      ),
                      const SizedBox(height: 4),
                      FractionallySizedBox(
                        widthFactor: 0.9,
                        child: Text(
                          'Flip the contents of the rect when it is flipped.',
                          style: Theme.of(context)
                              .textTheme
                              .bodySmall!
                              .copyWith(
                                color: Theme.of(context).colorScheme.secondary,
                              ),
                        ),
                      ),
                    ],
                  ),
                ),
                SizedBox(
                  height: 20,
                  child: Transform.scale(
                    scale: 0.7,
                    child: Switch(
                      value: model.flipChild,
                      onChanged: (value) => model.onFlipChildChanged(value),
                    ),
                  ),
                ),
              ],
            ),
          ),
          if (model.flipChild)
            Padding(
              padding: const EdgeInsets.fromLTRB(16, 0, 16, 16),
              child: Row(
                children: [
                  ToggleButtons(
                    onPressed: (index) {
                      if (index == 0) {
                        model.flipHorizontally();
                      } else {
                        model.flipVertically();
                      }
                    },
                    isSelected: [
                      model.flip.isHorizontal,
                      model.flip.isVertical,
                    ],
                    selectedColor: Theme.of(context).colorScheme.primary,
                    constraints: const BoxConstraints.tightFor(height: 32),
                    children: const [
                      Tooltip(
                        message: 'Flip Horizontally',
                        waitDuration: Duration(milliseconds: 500),
                        child: Padding(
                          padding: EdgeInsets.symmetric(horizontal: 8),
                          child: Row(
                            children: [
                              ImageIcon(
                                AssetImage('assets/images/ic_flip.png'),
                                size: 20,
                              ),
                              SizedBox(width: 8),
                              Text('Horizontal'),
                            ],
                          ),
                        ),
                      ),
                      Tooltip(
                        message: 'Flip Vertically',
                        waitDuration: Duration(milliseconds: 500),
                        child: Padding(
                          padding: EdgeInsets.symmetric(horizontal: 8),
                          child: Row(
                            children: [
                              RotatedBox(
                                quarterTurns: 1,
                                child: ImageIcon(
                                  AssetImage('assets/images/ic_flip.png'),
                                  size: 20,
                                ),
                              ),
                              SizedBox(width: 8),
                              Text('Vertical'),
                            ],
                          ),
                        ),
                      ),
                    ],
                  ),
                ],
              ),
            ),
        ],
      ),
    );
  }
}

class ClampingControls extends StatefulWidget {
  const ClampingControls({super.key});

  @override
  State<ClampingControls> createState() => _ClampingControlsState();
}

class _ClampingControlsState extends State<ClampingControls> {
  late final PlaygroundModel model = context.read<PlaygroundModel>();

  late final TextEditingController leftController;
  late final TextEditingController topController;
  late final TextEditingController bottomController;
  late final TextEditingController rightController;

  double get left => double.tryParse(leftController.text) ?? 0;

  double get top => double.tryParse(topController.text) ?? 0;

  double get bottom => double.tryParse(bottomController.text) ?? 0;

  double get right => double.tryParse(rightController.text) ?? 0;

  @override
  void initState() {
    super.initState();
    leftController =
        TextEditingController(text: model.clampingRect.left.toStringAsFixed(0));
    topController =
        TextEditingController(text: model.clampingRect.top.toStringAsFixed(0));
    bottomController = TextEditingController(
        text: model.clampingRect.bottom.toStringAsFixed(0));
    rightController = TextEditingController(
        text: model.clampingRect.right.toStringAsFixed(0));

    model.addListener(onModelChanged);
  }

  void onModelChanged() {
    if (model.clampingRect.left != left) {
      leftController.text = model.clampingRect.left.toStringAsFixed(0);
    }
    if (model.clampingRect.top != top) {
      topController.text = model.clampingRect.top.toStringAsFixed(0);
    }
    if (model.clampingRect.bottom != bottom) {
      bottomController.text = model.clampingRect.bottom.toStringAsFixed(0);
    }
    if (model.clampingRect.right != right) {
      rightController.text = model.clampingRect.right.toStringAsFixed(0);
    }
  }

  @override
  Widget build(BuildContext context) {
    final PlaygroundModel model = context.watch<PlaygroundModel>();
    return FocusScope(
      child: Builder(
        builder: (context) {
          return GestureDetector(
            onTap: () {
              FocusScope.of(context).unfocus();
              model.onClampingRectChanged(
                left: left,
                top: top,
                bottom: bottom,
                right: right,
              );
            },
            child: AnimatedSize(
              duration: const Duration(milliseconds: 200),
              curve: Curves.easeInOut,
              alignment: Alignment.topCenter,
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.stretch,
                mainAxisSize: MainAxisSize.min,
                children: [
                  Container(
                    height: 44,
                    padding: const EdgeInsets.fromLTRB(16, 0, 6, 0),
                    alignment: Alignment.centerLeft,
                    child: Row(
                      children: [
                        Expanded(
                          child: Text(
                            'CLAMPING',
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
                              value: model.clampingEnabled,
                              onChanged: (value) => model.toggleClamping(value),
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),
                  if (model.clampingEnabled)
                    Padding(
                      padding: const EdgeInsets.fromLTRB(16, 0, 16, 16),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.stretch,
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          const Row(
                            children: [
                              Expanded(child: Label('LEFT')),
                              SizedBox(width: 16),
                              Expanded(child: Label('TOP')),
                            ],
                          ),
                          const SizedBox(height: 8),
                          Row(
                            children: [
                              Expanded(
                                child: TextField(
                                  enabled: model.clampingEnabled,
                                  controller: leftController,
                                  onSubmitted: (value) {
                                    model.onClampingRectChanged(left: left);
                                  },
                                  decoration: const InputDecoration(
                                    suffixText: 'px',
                                  ),
                                  inputFormatters: [
                                    FilteringTextInputFormatter.allow(
                                      RegExp(r'[0-9]*'),
                                    ),
                                  ],
                                ),
                              ),
                              const SizedBox(width: 16),
                              Expanded(
                                child: TextField(
                                  enabled: model.clampingEnabled,
                                  controller: topController,
                                  onSubmitted: (value) {
                                    model.onClampingRectChanged(top: top);
                                  },
                                  decoration: const InputDecoration(
                                    suffixText: 'px',
                                  ),
                                  inputFormatters: [
                                    FilteringTextInputFormatter.allow(
                                      RegExp(r'[0-9]*'),
                                    ),
                                  ],
                                ),
                              ),
                            ],
                          ),
                          const SizedBox(height: 16),
                          const Row(
                            children: [
                              Expanded(child: Label('RIGHT')),
                              SizedBox(width: 16),
                              Expanded(child: Label('BOTTOM')),
                            ],
                          ),
                          const SizedBox(height: 8),
                          Row(
                            children: [
                              Expanded(
                                child: TextFormField(
                                  enabled: model.clampingEnabled,
                                  controller: rightController,
                                  onFieldSubmitted: (value) {
                                    model.onClampingRectChanged(right: right);
                                  },
                                  decoration: const InputDecoration(
                                    suffixText: 'px',
                                  ),
                                  inputFormatters: [
                                    FilteringTextInputFormatter.allow(
                                      RegExp(r'[0-9]*'),
                                    ),
                                  ],
                                ),
                              ),
                              const SizedBox(width: 16),
                              Expanded(
                                child: TextField(
                                  enabled: model.clampingEnabled,
                                  controller: bottomController,
                                  onSubmitted: (value) {
                                    model.onClampingRectChanged(bottom: bottom);
                                  },
                                  decoration: const InputDecoration(
                                    suffixText: 'px',
                                  ),
                                  inputFormatters: [
                                    FilteringTextInputFormatter.allow(
                                      RegExp(r'[0-9]*'),
                                    ),
                                  ],
                                ),
                              ),
                            ],
                          ),
                          const SizedBox(height: 16),
                          FilledButton.tonalIcon(
                            onPressed: () {
                              model.setClampingRect(model.playgroundArea!);
                            },
                            icon: const Icon(Icons.fullscreen_rounded),
                            label: const Text('Full screen'),
                          ),
                        ],
                      ),
                    ),
                ],
              ),
            ),
          );
        },
      ),
    );
  }

  @override
  void dispose() {
    model.removeListener(onModelChanged);
    super.dispose();
  }
}

class ConstraintsControls extends StatefulWidget {
  const ConstraintsControls({super.key});

  @override
  State<ConstraintsControls> createState() => _ConstraintsControlsState();
}

class _ConstraintsControlsState extends State<ConstraintsControls> {
  late final PlaygroundModel model = context.read<PlaygroundModel>();

  late final TextEditingController minWidthController;
  late final TextEditingController minHeightController;
  late final TextEditingController maxWidthController;
  late final TextEditingController maxHeightController;

  double? get minWidth => double.tryParse(minWidthController.text) ?? 0;

  double? get minHeight => double.tryParse(minHeightController.text) ?? 0;

  double? get maxWidth => double.tryParse(maxWidthController.text);

  double? get maxHeight => double.tryParse(maxHeightController.text);

  @override
  void initState() {
    super.initState();
    minWidthController =
        TextEditingController(text: formatted(model.constraints.minWidth));
    minHeightController =
        TextEditingController(text: formatted(model.constraints.minHeight));
    maxHeightController =
        TextEditingController(text: formatted(model.constraints.maxHeight));
    maxWidthController =
        TextEditingController(text: formatted(model.constraints.maxWidth));

    model.addListener(onModelChanged);
  }

  void onModelChanged() {
    if (model.constraints.minWidth != minWidth) {
      minWidthController.text = formatted(model.constraints.minWidth);
    }
    if (model.constraints.minHeight != minHeight) {
      minHeightController.text = formatted(model.constraints.minHeight);
    }
    if (model.constraints.maxHeight != maxHeight) {
      maxHeightController.text = formatted(model.constraints.maxHeight);
    }
    if (model.constraints.maxWidth != maxWidth) {
      maxWidthController.text = formatted(model.constraints.maxWidth);
    }
  }

  String formatted(double? value) {
    if (value == null || value == 0) return '';
    if (value.isInfinite) return '';
    return value.toStringAsFixed(0);
  }

  @override
  Widget build(BuildContext context) {
    final PlaygroundModel model = context.watch<PlaygroundModel>();
    return FocusScope(
      child: Builder(
        builder: (context) {
          return GestureDetector(
            onTap: () {
              FocusScope.of(context).unfocus();
              model.onConstraintsChanged(
                minWidth: minWidth,
                minHeight: minHeight,
                maxHeight: maxHeight,
                maxWidth: maxWidth,
                forceMinWidth: true,
                forceMinHeight: true,
                forceMaxWidth: true,
                forceMaxHeight: true,
              );
            },
            child: AnimatedSize(
              duration: const Duration(milliseconds: 200),
              curve: Curves.easeInOut,
              alignment: Alignment.topCenter,
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.stretch,
                mainAxisSize: MainAxisSize.min,
                children: [
                  Container(
                    height: 44,
                    padding: const EdgeInsets.fromLTRB(16, 0, 6, 0),
                    alignment: Alignment.centerLeft,
                    child: Row(
                      children: [
                        Expanded(
                          child: Text(
                            'CONSTRAINTS',
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
                              value: model.constraintsEnabled,
                              onChanged: (value) =>
                                  model.toggleConstraints(value),
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),
                  if (model.constraintsEnabled)
                    Padding(
                      padding: const EdgeInsets.fromLTRB(16, 0, 16, 16),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.stretch,
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          const Row(
                            children: [
                              Expanded(child: Label('Min W')),
                              SizedBox(width: 16),
                              Expanded(child: Label('Min H')),
                            ],
                          ),
                          const SizedBox(height: 8),
                          Row(
                            children: [
                              Expanded(
                                child: TextField(
                                  enabled: model.constraintsEnabled,
                                  controller: minWidthController,
                                  onSubmitted: (value) {
                                    model.onConstraintsChanged(
                                      minWidth: minWidth,
                                      forceMinWidth: true,
                                    );
                                  },
                                  decoration: const InputDecoration(
                                    suffixText: 'px',
                                    hintText: '0',
                                  ),
                                  inputFormatters: [
                                    FilteringTextInputFormatter.allow(
                                      RegExp(r'[0-9]*'),
                                    ),
                                  ],
                                ),
                              ),
                              const SizedBox(width: 16),
                              Expanded(
                                child: TextField(
                                  enabled: model.constraintsEnabled,
                                  controller: minHeightController,
                                  onSubmitted: (value) {
                                    model.onConstraintsChanged(
                                      minHeight: minHeight,
                                      forceMinHeight: true,
                                    );
                                  },
                                  decoration: const InputDecoration(
                                    suffixText: 'px',
                                    hintText: '0',
                                  ),
                                  inputFormatters: [
                                    FilteringTextInputFormatter.allow(
                                      RegExp(r'[0-9]*'),
                                    ),
                                  ],
                                ),
                              ),
                            ],
                          ),
                          const SizedBox(height: 16),
                          const Row(
                            children: [
                              Expanded(child: Label('Max W')),
                              SizedBox(width: 16),
                              Expanded(child: Label('Max H')),
                            ],
                          ),
                          const SizedBox(height: 8),
                          Row(
                            children: [
                              Expanded(
                                child: TextFormField(
                                  enabled: model.constraintsEnabled,
                                  controller: maxWidthController,
                                  onFieldSubmitted: (value) {
                                    model.onConstraintsChanged(
                                      maxWidth: maxWidth,
                                      forceMaxWidth: true,
                                    );
                                  },
                                  decoration: const InputDecoration(
                                    suffixText: 'px',
                                    hintText: '∞',
                                  ),
                                  inputFormatters: [
                                    FilteringTextInputFormatter.allow(
                                      RegExp(r'[0-9]*'),
                                    ),
                                  ],
                                ),
                              ),
                              const SizedBox(width: 16),
                              Expanded(
                                child: TextField(
                                  enabled: model.constraintsEnabled,
                                  controller: maxHeightController,
                                  onSubmitted: (value) {
                                    model.onConstraintsChanged(
                                      maxHeight: maxHeight,
                                      forceMaxHeight: true,
                                    );
                                  },
                                  decoration: const InputDecoration(
                                    suffixText: 'px',
                                    hintText: '∞',
                                  ),
                                  inputFormatters: [
                                    FilteringTextInputFormatter.allow(
                                      RegExp(r'[0-9]*'),
                                    ),
                                  ],
                                ),
                              ),
                            ],
                          ),
                          const SizedBox(height: 16),
                          FilledButton.tonalIcon(
                            onPressed: () {
                              model.setConstraints(const BoxConstraints(
                                minWidth: double.infinity,
                                minHeight: double.infinity,
                              ));
                            },
                            icon: const Icon(Icons.refresh),
                            label: const Text('Reset'),
                          ),
                        ],
                      ),
                    ),
                ],
              ),
            ),
          );
        },
      ),
    );
  }

  @override
  void dispose() {
    model.removeListener(onModelChanged);
    super.dispose();
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
    return Text(
      label,
      style: Theme.of(context).textTheme.labelMedium!.copyWith(
            color: Theme.of(context).colorScheme.primary,
          ),
    );
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
      height: 44,
      padding: const EdgeInsets.symmetric(horizontal: 16),
      alignment: Alignment.centerLeft,
      child: Text(
        title,
        style: Theme.of(context).textTheme.titleSmall!.copyWith(
              color: Theme.of(context).colorScheme.secondary,
            ),
      ),
    );
  }
}

