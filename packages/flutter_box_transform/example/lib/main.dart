import 'dart:math';

import 'package:adaptive_theme/adaptive_theme.dart';
import 'package:flutter/material.dart';
import 'package:flutter/scheduler.dart';
import 'package:flutter/services.dart';
import 'package:flutter_box_transform/flutter_box_transform.dart';
import 'package:provider/provider.dart';
import 'package:url_launcher/url_launcher_string.dart';

import 'resources/asset_icons.dart';
import 'resources/images.dart';

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
  Rect clampingRect = Rect.largest;
  bool clampingEnabled = false;

  Rect? playgroundArea;

  final List<BoxData> boxes = [];

  int selectedBoxIndex = -1;

  BoxData? get selectedBox =>
      selectedBoxIndex != -1 ? boxes[selectedBoxIndex] : null;

  void reset(BuildContext context) {
    final Size size = MediaQuery.of(context).size;
    final double width = size.width - kSidePanelWidth - kBoxesPanelWidth;
    final double height = size.height;

    clampingRect = Rect.fromLTWH(
      0,
      0,
      width,
      size.height,
    );

    boxes.clear();
    boxes.add(
      BoxData(
        name: 'Box 1',
        imageAsset: Images.image1,
        rect: Rect.fromLTWH(
          (width - kInitialWidth) / 2,
          (height - kInitialHeight) / 2,
          kInitialWidth,
          kInitialHeight,
        ),
        flip: Flip.none,
      ),
    );
    selectedBoxIndex = 0;

    notifyListeners();
  }

  void onRectChanged(UITransformResult result) {
    if (selectedBox == null) return;
    selectedBox!.rect = result.rect;
    if (result is UIResizeResult) {
      selectedBox!.flip = result.flip;
    }
    notifyListeners();
  }

  void onFlipChanged(Flip flip) {
    if (selectedBoxIndex == -1) return;
    selectedBox!.flip = flip;
    notifyListeners();
  }

  void onFlipChildChanged(bool enabled) {
    if (selectedBoxIndex == -1) return;
    selectedBox!.flipChild = enabled;
    notifyListeners();
  }

  void onFlipWhileResizingChanged(bool enabled) {
    if (selectedBoxIndex == -1) return;
    selectedBox!.flipRectWhileResizing = enabled;
    notifyListeners();
  }

  void setClampingRect(
    Rect rect, {
    bool notify = true,
    bool insidePlayground = false,
  }) {
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

  void addNewBox() {
    boxes.add(
      BoxData(
        name: 'Box ${boxes.length + 1}',
        imageAsset: Images.values[boxes.length % Images.values.length],
        rect: Rect.fromLTWH(
          playgroundArea!.center.dx - kInitialWidth / 2,
          playgroundArea!.center.dy - kInitialHeight / 2,
          kInitialWidth,
          kInitialHeight,
        ),
        flip: Flip.none,
      ),
    );

    notifyListeners();
  }

  void removeSelectedBox() {
    if (selectedBoxIndex == -1) return;
    boxes.removeAt(selectedBoxIndex);
    selectedBoxIndex = -1;
    notifyListeners();
  }

  void removeBox(int index) {
    if (index == -1) return;
    boxes.removeAt(index);
    if (index == selectedBoxIndex) {
      selectedBoxIndex = -1;
    }
    notifyListeners();
  }

  void setConstraints(BoxConstraints constraints, {bool notify = true}) {
    if (selectedBoxIndex == -1) return;
    selectedBox!.constraints = constraints;

    if (notify) notifyListeners();
  }

  void flipHorizontally() {
    if (selectedBoxIndex == -1) return;
    selectedBox!.flip = Flip.fromValue(
      selectedBox!.flip.horizontalValue * -1,
      selectedBox!.flip.verticalValue,
    );
    notifyListeners();
  }

  void flipVertically() {
    if (selectedBoxIndex == -1) return;
    selectedBox!.flip = Flip.fromValue(
      selectedBox!.flip.horizontalValue,
      selectedBox!.flip.verticalValue * -1,
    );
    notifyListeners();
  }

  void toggleClamping(bool enabled) {
    clampingEnabled = enabled;
    notifyListeners();
  }

  void toggleResizing(bool enabled) {
    if (selectedBoxIndex == -1) return;
    selectedBox!.resizable = enabled;
    notifyListeners();
  }

  void toggleMoving(bool enabled) {
    if (selectedBoxIndex == -1) return;
    selectedBox!.movable = enabled;
    notifyListeners();
  }

  void toggleConstraints(bool enabled) {
    if (selectedBoxIndex == -1) return;
    selectedBox!.constraintsEnabled = enabled;
    notifyListeners();
  }

  void toggleHideHandlesWhenNotResizable(bool enabled) {
    if (selectedBoxIndex == -1) return;
    selectedBox!.hideHandlesWhenNotResizable = enabled;
    notifyListeners();
  }

  void onClampingRectChanged({
    double? left,
    double? top,
    double? right,
    double? bottom,
  }) {
    if (selectedBox == null) return;
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
    if (selectedBox == null) return;
    selectedBox!.constraints = BoxConstraints(
      minWidth: forceMinWidth
          ? minWidth ?? 0
          : minWidth ?? selectedBox!.constraints.minWidth,
      minHeight: forceMinHeight
          ? minHeight ?? 0
          : minHeight ?? selectedBox!.constraints.minHeight,
      maxWidth: forceMaxWidth
          ? maxWidth ?? double.infinity
          : maxWidth ?? selectedBox!.constraints.maxWidth,
      maxHeight: forceMaxHeight
          ? maxHeight ?? double.infinity
          : maxHeight ?? selectedBox!.constraints.maxHeight,
    );
    notifyListeners();
  }

  void onBoxSelected(int index) {
    selectedBoxIndex = index;
    notifyListeners();
  }

  void clearSelection() {
    selectedBoxIndex = -1;
    notifyListeners();
  }

  void onReorder(int oldIndex, int newIndex) {
    if (oldIndex < newIndex) {
      newIndex -= 1;
    }
    final selectedBox = this.selectedBox;
    final BoxData box = boxes.removeAt(oldIndex);
    boxes.insert(newIndex, box);
    if (selectedBox != null) {
      selectedBoxIndex =
          boxes.indexWhere((box) => box.name == selectedBox.name);
    }

    notifyListeners();
  }
}

class Playground extends StatefulWidget {
  const Playground({super.key});

  @override
  State<Playground> createState() => _PlaygroundState();
}

const double kSidePanelWidth = 280;
const double kBoxesPanelWidth = 250;
const double kInitialWidth = 400;
const double kInitialHeight = 300;
const double kStrokeWidth = 1.5;
const Color kGridColor = Color.fromARGB(126, 27, 181, 228);

class _PlaygroundState extends State<Playground> with WidgetsBindingObserver {
  Set<LogicalKeyboardKey> pressedKeys = {};

  late final FocusNode focusNode = FocusNode();

  late final PlaygroundModel model = context.read<PlaygroundModel>();

  @override
  void initState() {
    super.initState();

    // This is required to center the box based on screen size when the app
    // starts.
    SchedulerBinding.instance.addPostFrameCallback((_) {
      model.reset(context);
    });

    WidgetsBinding.instance.addObserver(this);
  }

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    if (model.playgroundArea == null) resetPlayground();
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
      max(size.width - kSidePanelWidth - kBoxesPanelWidth, 100),
      max(size.height,
          100), // safe size for when window is resized extremely small.
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
          const BoxesPanel(),
          Expanded(
            child: CallbackShortcuts(
              bindings: {
                const SingleActivator(LogicalKeyboardKey.delete):
                    model.removeSelectedBox,
              },
              child: RawKeyboardListener(
                focusNode: focusNode,
                autofocus: true,
                onKey: (key) {
                  if (key is RawKeyDownEvent) {
                    pressedKeys.add(key.logicalKey);
                    setState(() {});
                  } else if (key is RawKeyUpEvent) {
                    pressedKeys.remove(key.logicalKey);
                    setState(() {});
                  }
                },
                child: GestureDetector(
                  onTap: () {
                    focusNode.requestFocus();
                    model.clearSelection();
                  },
                  behavior: HitTestBehavior.opaque,
                  child: Stack(
                    fit: StackFit.expand,
                    children: [
                      Positioned.fill(
                        child: GridPaper(
                          color: Theme.of(context).brightness == Brightness.dark
                              ? kGridColor.withOpacity(0.05)
                              : kGridColor.withOpacity(0.1),
                        ),
                      ),
                      if (model.clampingEnabled && model.playgroundArea != null)
                        const ClampingRect(),
                      for (int index = 0; index < model.boxes.length; index++)
                        ImageBox(
                          key: ValueKey(model.boxes[index].name),
                          box: model.boxes[index],
                          selected: index == model.selectedBoxIndex,
                          onChanged: model.onRectChanged,
                          onSelected: () => model.onBoxSelected(index),
                        ),
                      Positioned(
                        left: 16,
                        bottom: 16,
                        child: KeyboardListenerIndicator(
                          pressedKeys: pressedKeys.toList(),
                          onClear: () => setState(() => pressedKeys = {}),
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            ),
          ),
          const ControlPanel(),
        ],
      ),
    );
  }
}

class ImageBox extends StatefulWidget {
  const ImageBox({
    super.key,
    required this.box,
    required this.onChanged,
    required this.onSelected,
    required this.selected,
  });

  final BoxData box;
  final bool selected;
  final VoidCallback onSelected;
  final Function(TransformResult<Rect, Offset, Size>)? onChanged;

  @override
  State<ImageBox> createState() => _ImageBoxState();
}

class _ImageBoxState extends State<ImageBox> {
  bool minWidthReached = false;
  bool minHeightReached = false;
  bool maxWidthReached = false;
  bool maxHeightReached = false;

  BoxData get box => widget.box;

  @override
  Widget build(BuildContext context) {
    final PlaygroundModel model = context.read<PlaygroundModel>();
    final Color handleColor = Theme.of(context).colorScheme.primary;
    return TransformableBox(
      key: ValueKey('image-box-${box.name}'),
      rect: box.rect,
      flip: box.flip,
      clampingRect: model.clampingEnabled ? model.clampingRect : null,
      constraints: box.constraintsEnabled ? box.constraints : null,
      onChanged: widget.onChanged,
      resizable: widget.selected && box.resizable,
      hideHandlesWhenNotResizable:
          !widget.selected || box.hideHandlesWhenNotResizable,
      movable: widget.selected && box.movable,
      allowContentFlipping: box.flipChild,
      flipWhileResizing: box.flipRectWhileResizing,
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
      contentBuilder: (context, rect, flip) => GestureDetector(
        onTap: () {
          if (widget.selected) return;
          widget.onSelected();
        },
        onPanStart: (_) {
          if (widget.selected) return;
          widget.onSelected();
        },
        // onTapDown: (_) {
        //   if(widget.selected) return;
        //   widget.onSelected();
        // },
        child: Container(
          key: ValueKey('image-box-${box.name}-content'),
          width: rect.width,
          height: rect.height,
          decoration: BoxDecoration(
            color: Colors.white,
            image: DecorationImage(
              image: AssetImage(box.imageAsset),
              fit: BoxFit.fill,
            ),
          ),
          foregroundDecoration: BoxDecoration(
            border: widget.selected
                ? Border.symmetric(
                    horizontal: BorderSide(
                      color: minHeightReached
                          ? Colors.orange
                          : maxHeightReached
                              ? Colors.red
                              : handleColor,
                      width: 2,
                      // TODO: Due to flutter issue in 3.7.10, this doesn't work in debug mode.
                      // strokeAlign: BorderSide.strokeAlignCenter,
                    ),
                    vertical: BorderSide(
                      color: minWidthReached
                          ? Colors.orange
                          : maxWidthReached
                              ? Colors.red
                              : handleColor,
                      width: 2,
                      // TODO: Due to flutter issue in 3.7.10, this doesn't work in debug mode.
                      // strokeAlign: BorderSide.strokeAlignCenter,
                    ),
                  )
                : null,
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

    final minWidth = model.boxes.fold(0.0,
        (previousValue, element) => max(previousValue, element.rect.width));
    final minHeight = model.boxes.fold(0.0,
        (previousValue, element) => max(previousValue, element.rect.height));

    return TransformableBox(
      key: const ValueKey('clamping-box'),
      rect: model.clampingRect,
      flip: Flip.none,
      clampingRect: model.playgroundArea!,
      constraints: BoxConstraints(
        minWidth: minWidth,
        minHeight: minHeight,
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
      contentBuilder: (context, _, flip) => Container(
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

    final BoxData? box = model.selectedBox;

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
            if (box != null) ...[
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
                          value: box.resizable,
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
                          value: box.movable,
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
                        'Hide handles if not resizable',
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
                          value: box.hideHandlesWhenNotResizable,
                          onChanged: (value) =>
                              model.toggleHideHandlesWhenNotResizable(value),
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
            ] else ...[
              const SizedBox(height: 44),
              Text(
                'Select a box to see controls',
                textAlign: TextAlign.center,
                style: Theme.of(context).textTheme.titleSmall!.copyWith(
                      color: Theme.of(context).colorScheme.secondary,
                    ),
              ),
            ],
          ],
        ),
      ),
    );
  }
}

class BoxesPanel extends StatelessWidget {
  const BoxesPanel({super.key});

  @override
  Widget build(BuildContext context) {
    final PlaygroundModel model = context.watch<PlaygroundModel>();

    return Card(
      margin: const EdgeInsets.only(left: 0),
      shape: const RoundedRectangleBorder(),
      child: SizedBox(
        width: kBoxesPanelWidth,
        height: MediaQuery.of(context).size.height,
        child: SingleChildScrollView(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.start,
            children: [
              Container(
                padding: const EdgeInsets.fromLTRB(16, 0, 4, 0),
                child: Row(
                  children: [
                    const SectionHeader(
                      'Boxes',
                      padding: EdgeInsets.zero,
                    ),
                    Text(
                      ' • ${model.boxes.length}',
                      style: TextStyle(
                        color: Theme.of(context).colorScheme.secondary,
                        letterSpacing: 1,
                        fontSize: 12,
                      ),
                    ),
                    const Spacer(),
                    IconButton(
                      onPressed: model.selectedBox != null
                          ? model.removeSelectedBox
                          : null,
                      tooltip: 'Delete selected box',
                      iconSize: 18,
                      splashRadius: 18,
                      color: Theme.of(context).colorScheme.error,
                      icon: const Icon(Icons.delete_outline_outlined),
                    ),
                    IconButton(
                      onPressed: model.addNewBox,
                      tooltip: 'Add new box',
                      iconSize: 18,
                      splashRadius: 18,
                      icon: const Icon(Icons.add),
                    ),
                  ],
                ),
              ),
              const Divider(height: 1),
              if (model.boxes.isEmpty) ...[
                const SizedBox(height: 44),
                Text(
                  'Add a box to see controls',
                  textAlign: TextAlign.center,
                  style: Theme.of(context).textTheme.titleSmall!.copyWith(
                        color: Theme.of(context).colorScheme.secondary,
                      ),
                ),
              ],
              if (model.boxes.isNotEmpty)
                ReorderableListView.builder(
                  itemCount: model.boxes.length,
                  onReorder: model.onReorder,
                  reverse: true,
                  shrinkWrap: true,
                  buildDefaultDragHandles: false,
                  primary: false,
                  itemBuilder: (context, index) {
                    final box = model.boxes[index];
                    return ReorderableDragStartListener(
                      index: index,
                      key: ValueKey(box.name),
                      child: Container(
                        color: box.name == model.selectedBox?.name
                            ? Theme.of(context)
                                .colorScheme
                                .primary
                                .withOpacity(0.2)
                            : null,
                        child: ListTile(
                          title: Text(box.name),
                          selected: box.name == model.selectedBox?.name,
                          onTap: () => model.onBoxSelected(index),
                          leading: const Icon(
                            Icons.border_style_outlined,
                            size: 18,
                          ),
                          minLeadingWidth: 20,
                          dense: true,
                          // selectedTileColor:
                          //     Theme.of(context).colorScheme.primary.withOpacity(0.2),
                        ),
                      ),
                    );
                  },
                ),
            ],
          ),
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

    final BoxData box = model.selectedBox!;

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
              Row(
                children: const [
                  Expanded(child: Label('X')),
                  SizedBox(width: 16),
                  Expanded(child: Label('Y')),
                ],
              ),
              const SizedBox(height: 8),
              Row(
                children: [
                  Expanded(
                    child: ValueText(box.rect.left.toStringAsFixed(0)),
                  ),
                  const SizedBox(width: 16),
                  Expanded(
                    child: ValueText(box.rect.top.toStringAsFixed(0)),
                  ),
                ],
              ),
              const SizedBox(height: 16),
              Row(
                children: const [
                  Expanded(child: Label('WIDTH')),
                  SizedBox(width: 16),
                  Expanded(child: Label('HEIGHT')),
                ],
              ),
              const SizedBox(height: 8),
              Row(
                children: [
                  Expanded(
                    child: ValueText(box.rect.width.toStringAsFixed(0)),
                  ),
                  const SizedBox(width: 16),
                  Expanded(
                    child: ValueText(box.rect.height.toStringAsFixed(0)),
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
                      (box.rect.width / box.rect.height).toStringAsFixed(2),
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

    final BoxData box = model.selectedBox!;

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
                      value: box.flipRectWhileResizing,
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
                        'Flip Content',
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
                      value: box.flipChild,
                      onChanged: (value) => model.onFlipChildChanged(value),
                    ),
                  ),
                ),
              ],
            ),
          ),
          if (box.flipChild)
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
                      box.flip.isHorizontal,
                      box.flip.isVertical,
                    ],
                    selectedColor: Theme.of(context).colorScheme.primary,
                    constraints: const BoxConstraints.tightFor(height: 32),
                    children: [
                      Tooltip(
                        message: 'Flip Horizontally',
                        waitDuration: const Duration(milliseconds: 500),
                        child: Padding(
                          padding: const EdgeInsets.symmetric(horizontal: 8),
                          child: Row(
                            children: const [
                              ImageIcon(
                                AssetImage(AssetIcons.icFlip),
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
                        waitDuration: const Duration(milliseconds: 500),
                        child: Padding(
                          padding: const EdgeInsets.symmetric(horizontal: 8),
                          child: Row(
                            children: const [
                              RotatedBox(
                                quarterTurns: 1,
                                child: ImageIcon(
                                  AssetImage(AssetIcons.icFlip),
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

  BoxData get box => model.selectedBox!;

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
                          Row(
                            children: const [
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
                          Row(
                            children: const [
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

  BoxData get box => model.selectedBox!;

  @override
  void initState() {
    super.initState();
    minWidthController =
        TextEditingController(text: formatted(box.constraints.minWidth));
    minHeightController =
        TextEditingController(text: formatted(box.constraints.minHeight));
    maxHeightController =
        TextEditingController(text: formatted(box.constraints.maxHeight));
    maxWidthController =
        TextEditingController(text: formatted(box.constraints.maxWidth));

    model.addListener(onModelChanged);
  }

  void onModelChanged() {
    if (model.selectedBox == null) return;
    if (box.constraints.minWidth != minWidth) {
      minWidthController.text = formatted(box.constraints.minWidth);
    }
    if (box.constraints.minHeight != minHeight) {
      minHeightController.text = formatted(box.constraints.minHeight);
    }
    if (box.constraints.maxHeight != maxHeight) {
      maxHeightController.text = formatted(box.constraints.maxHeight);
    }
    if (box.constraints.maxWidth != maxWidth) {
      maxWidthController.text = formatted(box.constraints.maxWidth);
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
                              value: box.constraintsEnabled,
                              onChanged: (value) =>
                                  model.toggleConstraints(value),
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),
                  if (box.constraintsEnabled)
                    Padding(
                      padding: const EdgeInsets.fromLTRB(16, 0, 16, 16),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.stretch,
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          Row(
                            children: const [
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
                                  enabled: box.constraintsEnabled,
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
                                  enabled: box.constraintsEnabled,
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
                          Row(
                            children: const [
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
                                  enabled: box.constraintsEnabled,
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
                                  enabled: box.constraintsEnabled,
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
  final List<LogicalKeyboardKey> pressedKeys;
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
              prettifyKey(key),
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

  String prettifyKey(LogicalKeyboardKey key) {
    final keyLabel = key.keyLabel;
    if (key == LogicalKeyboardKey.arrowLeft) return '←';
    if (key == LogicalKeyboardKey.arrowRight) return '→';
    if (key == LogicalKeyboardKey.arrowUp) return '↑';
    if (key == LogicalKeyboardKey.arrowDown) return '↓';
    if (key == LogicalKeyboardKey.escape) return 'ESC';
    if (key == LogicalKeyboardKey.shiftLeft) return 'SHIFT';
    if (key == LogicalKeyboardKey.altLeft) return 'ALT';
    if (key == LogicalKeyboardKey.controlLeft) return 'CTRL';
    if (key == LogicalKeyboardKey.metaLeft) return 'CMD';
    return keyLabel;
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
  final EdgeInsets? padding;
  final double? height;

  const SectionHeader(
    this.title, {
    super.key,
    this.padding,
    this.height,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      height: height ?? 44,
      padding: padding ?? const EdgeInsets.symmetric(horizontal: 16),
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

class BoxData {
  final String name;
  Rect rect = Rect.zero;
  Flip flip = Flip.none;
  Rect rect2 = Rect.zero;
  Flip flip2 = Flip.none;
  BoxConstraints constraints;

  bool flipRectWhileResizing = true;
  bool flipChild = true;
  bool constraintsEnabled = false;
  bool resizable = true;
  bool movable = true;
  bool hideHandlesWhenNotResizable = true;

  final String imageAsset;

  BoxData({
    required this.name,
    required this.rect,
    required this.imageAsset,
    this.flip = Flip.none,
    this.rect2 = Rect.zero,
    this.flip2 = Flip.none,
    this.constraints = const BoxConstraints(minWidth: 0, minHeight: 0),
    this.flipRectWhileResizing = true,
    this.flipChild = true,
    this.constraintsEnabled = false,
    this.resizable = true,
    this.movable = true,
    this.hideHandlesWhenNotResizable = true,
  });
}
