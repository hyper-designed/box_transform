import 'dart:developer';
import 'dart:io';

import 'package:dart_style/dart_style.dart';
import 'package:equatable/equatable.dart';
import 'package:file_picker/file_picker.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_box_transform/flutter_box_transform.dart';
import 'package:provider/provider.dart';

import 'main.dart';

class TestRecorder with ChangeNotifier {
  Map<String, List<TestRecord>> tests = {};

  List<TestRecord> current = [];

  bool isRecording = false;

  String? testBeingRecorded;

  void startRecording(
    String testName, {
    Box? clampingBox,
    Constraints? constraints,
  }) {
    testBeingRecorded = testName;
    current = [];
    isRecording = true;
    notifyListeners();
  }

  TestAction onAction({
    required ResizeMode resizeMode,
    required Flip flip,
    required Rect rect,
    required HandlePosition handle,
    required Offset cursorPosition,
    required bool flipRect,
    required double rotation,
    required BindingStrategy bindingStrategy,
    Rect? clampingRect,
    BoxConstraints? constraints,
  }) {
    final action = TestAction(
      resizeMode: resizeMode,
      flip: flip,
      box: rect,
      handle: handle,
      position: cursorPosition,
      clampingBox: clampingRect,
      constraints: constraints,
      flipRect: flipRect,
      rotation: rotation,
      bindingStrategy: bindingStrategy,
    );
    current.add(TestRecord(action: action));
    return action;
  }

  // Append a single onResizeUpdate tick to the matching record. The recorder
  // captures every tick of a gesture so the exported test can replay the
  // same micro-delta sequence — the bug we chase often only manifests
  // tick-by-tick, not on a single direct jump from start to end.
  void onUpdate({
    required TestAction action,
    required Offset localPosition,
    required UITransformResult result,
  }) {
    final record = current.firstWhere((item) => item.action.id == action.id);
    record.ticks.add(TestTick(localPosition: localPosition, result: result));
  }

  // Legacy: kept for callers that only push a final result. Implemented as
  // a tick append so old call-sites still produce a valid (single-tick)
  // recording.
  void onResult({
    required TestAction action,
    required Offset localPosition,
    required UITransformResult result,
  }) =>
      onUpdate(action: action, localPosition: localPosition, result: result);

  void stopRecording({String? saveAs}) {
    if (current.isNotEmpty) {
      tests[saveAs ?? testBeingRecorded ?? 'Test ${tests.length + 1}'] = [
        ...current
      ];
    }
    testBeingRecorded = null;
    isRecording = false;
    current = [];
    notifyListeners();
  }
}

class TestRecord {
  final TestAction action;
  final List<TestTick> ticks = [];

  TestRecord({required this.action});
}

class TestTick {
  final Offset localPosition;
  final UITransformResult result;

  TestTick({required this.localPosition, required this.result});
}

class TestAction with Equatable {
  final int id;
  final ResizeMode resizeMode;
  final Flip flip;
  final Rect box;
  final HandlePosition handle;
  final Offset position;
  final Rect? clampingBox;
  final BoxConstraints? constraints;
  final bool flipRect;
  final double rotation;
  final BindingStrategy bindingStrategy;

  TestAction({
    required this.resizeMode,
    required this.flip,
    required this.box,
    required this.handle,
    required this.position,
    this.clampingBox,
    this.constraints,
    this.flipRect = false,
    this.rotation = 0.0,
    this.bindingStrategy = BindingStrategy.boundingBox,
  }) : id = DateTime.now().millisecondsSinceEpoch;

  @override
  List<Object?> get props => [
        id,
        resizeMode,
        flip,
        box,
        handle,
        position,
        clampingBox,
        constraints,
        flipRect,
        rotation,
        bindingStrategy,
      ];
}

class TestRecorderUI extends StatefulWidget {
  const TestRecorderUI({super.key});

  @override
  State<TestRecorderUI> createState() => _TestRecorderUIState();
}

class _TestRecorderUIState extends State<TestRecorderUI> {
  late final TestRecorder recorder = context.read<TestRecorder>();

  @override
  Widget build(BuildContext context) {
    final recorder = context.watch<TestRecorder>();
    return Column(
      children: [
        const SectionHeader('TEST RECORDER'),
        Padding(
          padding: const EdgeInsets.fromLTRB(16, 0, 8, 8),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              Row(
                children: [
                  Expanded(
                    child: FilledButton.tonalIcon(
                      style: FilledButton.styleFrom(
                        backgroundColor: recorder.isRecording
                            ? Theme.of(context).colorScheme.error
                            : null,
                        foregroundColor: recorder.isRecording
                            ? Theme.of(context).colorScheme.onError
                            : null,
                      ),
                      onPressed: () {
                        if (recorder.isRecording) {
                          recorder.stopRecording();
                        } else {
                          onStartRecording();
                        }
                      },
                      icon: Icon(
                          recorder.isRecording ? Icons.stop : Icons.play_arrow),
                      label: Text(recorder.isRecording
                          ? 'Stop recording'
                          : 'Start recording'),
                    ),
                  ),
                  const SizedBox(width: 8),
                  IconButton(
                    tooltip: 'Export tests',
                    onPressed: recorder.tests.isNotEmpty ? onExportTests : null,
                    icon: const Icon(Icons.file_download_outlined),
                  ),
                ],
              ),
              Row(
                children: [
                  Expanded(
                    child: Text('Tests recorded: ${recorder.tests.length}'),
                  ),
                  const SizedBox(width: 8),
                  TextButton(
                    onPressed: recorder.tests.isNotEmpty
                        ? () {
                            recorder.stopRecording();
                            recorder.tests.clear();
                            setState(() {});
                          }
                        : null,
                    child: const Text('Delete all'),
                  ),
                ],
              ),
            ],
          ),
        ),
        if (recorder.tests.isNotEmpty) const Divider(height: 1, thickness: 1),
        Expanded(
          child: ListView.builder(
            itemCount: recorder.tests.length + (recorder.isRecording ? 1 : 0),
            shrinkWrap: true,
            itemBuilder: (context, ind) {
              if (recorder.isRecording && ind == 0) {
                return ListTile(
                  tileColor: Colors.orange.shade100,
                  textColor: Colors.orange.shade900,
                  visualDensity:
                      const VisualDensity(vertical: -4, horizontal: -4),
                  leading: Align(
                    widthFactor: 1,
                    child: CupertinoActivityIndicator(
                      radius: 10,
                      color: Colors.orange.shade900,
                    ),
                  ),
                  minLeadingWidth: 24,
                  title: Text(
                    '${recorder.testBeingRecorded}',
                    maxLines: 1,
                    overflow: TextOverflow.ellipsis,
                    style: const TextStyle(fontSize: 12),
                  ),
                  subtitle: Text(
                    '${recorder.current.length} actions',
                    style: const TextStyle(fontSize: 12, height: 2),
                  ),
                );
              }
              final index = ind - (recorder.isRecording ? 1 : 0);
              final test = recorder.tests.entries.elementAt(index);
              return ListTile(
                onTap: () {},
                visualDensity: VisualDensity.comfortable,
                trailing: IconButton(
                  tooltip: 'Delete test',
                  onPressed: () {
                    recorder.tests.remove(test.key);
                    setState(() {});
                  },
                  iconSize: 18,
                  splashRadius: 18,
                  padding: const EdgeInsets.all(4),
                  constraints: const BoxConstraints(),
                  icon: const Icon(Icons.delete_outline_rounded),
                ),
                leading: Text(
                  '${index + 1}',
                  style: const TextStyle(fontSize: 18),
                ),
                tileColor:
                    index % 2 == 0 ? Colors.grey.withValues(alpha: 0.07) : null,
                minLeadingWidth: 14,
                title: Text(
                  test.key,
                  style: const TextStyle(fontSize: 12),
                ),
                subtitle: Text(
                  '${test.value.length} actions',
                  style: const TextStyle(
                    fontSize: 12,
                    height: 2,
                    color: Colors.grey,
                  ),
                ),
              );
            },
          ),
        ),
      ],
    );
  }

  Future<void> onExportTests() async {
    try {
      final Map<String, dynamic>? settings =
          await showDialog<Map<String, dynamic>>(
        context: context,
        builder: (context) => const ExportDialog(),
      );

      if (settings == null) return;

      final path = await FilePicker.saveFile(
        dialogTitle: 'Export tests',
        fileName: 'resizing_test.dart',
        allowedExtensions: ['.dart'],
        type: FileType.custom,
      );
      if (path == null) return;

      exportTests(
        path,
        roundValues: settings['roundValues'] == true,
        withTolerance: settings['withTolerance'] == true,
      );
      log('Exporting tests to $path with settings: $settings');
    } catch (error, stacktrace) {
      log(error.toString());
      log(stacktrace.toString());
    }
  }

  Future<void> exportTests(
    String path, {
    required bool withTolerance,
    required bool roundValues,
  }) async {
    final messenger = ScaffoldMessenger.of(context);
    try {
      final List<String> tests = [];
      for (final record in recorder.tests.entries) {
        final name = record.key;
        // Skip records that captured no ticks (recorder paused mid-gesture
        // before any onResizeUpdate fired).
        final records = record.value.where((r) => r.ticks.isNotEmpty).toList();
        if (records.isEmpty) continue;
        final contents = <String>[];
        for (var index = 0; index < records.length; index++) {
          final record = records[index];
          final content = buildTest(
            record,
            index,
            withTolerance: withTolerance,
            roundValues: roundValues,
          );
          contents.add(content);
        }

        final test = '''
      test('$name', (){
        ${contents.join('\n')}
      });
      ''';
        tests.add(test);
      }

      final testFile = '''
      import 'package:test/test.dart';
      import 'package:vector_math/vector_math_64.dart';
      import 'package:box_transform/box_transform.dart';
      ${withTolerance ? "import 'utils.dart';" : ''}
      
      void main(){
        ${tests.join('\n')}
      }
    ''';

      final formatted = DartFormatter(
        languageVersion: DartFormatter.latestLanguageVersion,
      ).format(testFile);
      final dir = Directory('tests');

      if (!await dir.exists()) await dir.create();

      final file = File(path);

      await file.writeAsString(formatted);
      log('Wrote test file to ${file.path}');
      // Process.run('open', [file.parent.path]);

      messenger.showSnackBar(
        SnackBar(
          content: Text('Wrote test file to ${file.path}'),
          width: 700,
          behavior: SnackBarBehavior.floating,
          action: SnackBarAction(
            label: 'Open',
            onPressed: () {
              Process.run('open', [file.parent.path]);
            },
          ),
        ),
      );
    } catch (error, stackTrace) {
      log(error.toString());
      log(stackTrace.toString());
    }
  }

  String buildTest(
    TestRecord record,
    int index, {
    bool roundValues = false,
    bool withTolerance = false,
  }) {
    final StringBuffer buffer = StringBuffer();

    String formattedValue(num value) {
      if (value.isInfinite) return 'double.infinity';
      return roundValues ? value.round().toString() : value.toStringAsFixed(2);
    }

    final String left = formattedValue(record.action.box.left);
    final String top = formattedValue(record.action.box.top);
    final String width = formattedValue(record.action.box.width);
    final String height = formattedValue(record.action.box.height);

    String? clampingRect;
    String? constraints;

    if (record.action.clampingBox != null) {
      clampingRect =
          'Box.fromLTWH(${formattedValue(record.action.clampingBox!.left)}, ${formattedValue(record.action.clampingBox!.top)}, ${formattedValue(record.action.clampingBox!.width)}, ${formattedValue(record.action.clampingBox!.height)})';
    }

    if (record.action.constraints != null) {
      constraints =
          'Constraints(minWidth: ${formattedValue(record.action.constraints!.minWidth)}, minHeight: ${formattedValue(record.action.constraints!.minHeight)}, maxWidth: ${formattedValue(record.action.constraints!.maxWidth)}, maxHeight: ${formattedValue(record.action.constraints!.maxHeight)})';
    }

    // Emit the tick cursor sequence. The replay loop calls
    // `BoxTransformer.resize` once per tick — the engine is stateless so
    // every tick uses the SAME initialRect/initialLocalPosition (gesture
    // start), with only `localPosition` varying. This is exactly how
    // TransformableBoxController calls the engine during a real gesture.
    final tickList = record.ticks
        .map((t) =>
            'Vector2(${formattedValue(t.localPosition.dx)}, ${formattedValue(t.localPosition.dy)})')
        .join(',\n        ');

    final hasClamp = clampingRect != null;

    buffer.writeln('''

      ${index == 0 ? 'final ' : ''}initialRect = Box.fromLTWH($left, $top, $width, $height);
      ${index == 0 ? 'final ' : ''}initialCursor = Vector2(${formattedValue(record.action.position.dx)}, ${formattedValue(record.action.position.dy)});
      ${index == 0 ? 'final ' : ''}cursors = <Vector2>[
        $tickList,
      ];
      ${index == 0 ? 'late RawResizeResult ' : ''}result;
      for (var i = 0; i < cursors.length; i++) {
        result = BoxTransformer.resize(
          resizeMode: ${record.action.resizeMode},
          initialFlip: ${record.action.flip},
          initialRect: initialRect,
          handle: ${record.action.handle},
          initialLocalPosition: initialCursor,
          allowFlipping: ${record.action.flipRect},
          rotation: ${record.action.rotation},
          bindingStrategy: ${record.action.bindingStrategy},
          localPosition: cursors[i],
          ${hasClamp ? 'clampingRect: $clampingRect,' : ''}
          ${constraints != null ? 'constraints: $constraints,' : ''}
        );
        ${hasClamp ? '''
        // Invariant: rect must stay inside clamp at every tick.
        final clamp = $clampingRect;
        expect(result.rect.left, greaterThanOrEqualTo(clamp.left - 1e-3),
            reason: 'tick \$i: rect.left=\${result.rect.left} leaked clamp.left=\${clamp.left}');
        expect(result.rect.top, greaterThanOrEqualTo(clamp.top - 1e-3),
            reason: 'tick \$i: rect.top=\${result.rect.top} leaked clamp.top=\${clamp.top}');
        expect(result.rect.right, lessThanOrEqualTo(clamp.right + 1e-3),
            reason: 'tick \$i: rect.right=\${result.rect.right} leaked clamp.right=\${clamp.right}');
        expect(result.rect.bottom, lessThanOrEqualTo(clamp.bottom + 1e-3),
            reason: 'tick \$i: rect.bottom=\${result.rect.bottom} leaked clamp.bottom=\${clamp.bottom}');
        ''' : ''}
      }

    ''');

    return buffer.toString();
  }

  Future<void> onStartRecording() async {
    final name = await showDialog<String?>(
      context: context,
      builder: (context) => SingleInputDialog(
        label: 'Test name',
        validator: (value) {
          if (value == null || value.isEmpty) {
            return 'Please enter a name';
          }
          return null;
        },
      ),
    );

    if (name == null) return;

    recorder.startRecording(name);
  }
}

class SingleInputDialog extends StatefulWidget {
  final String label;
  final String? initialValue;
  final String? Function(String?)? validator;

  const SingleInputDialog({
    super.key,
    required this.label,
    this.initialValue,
    this.validator,
  });

  @override
  State<SingleInputDialog> createState() => _SingleInputDialogState();
}

class _SingleInputDialogState extends State<SingleInputDialog> {
  late final TextEditingController controller =
      TextEditingController(text: widget.initialValue);

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Material(
        type: MaterialType.transparency,
        child: Container(
          width: 500,
          padding: const EdgeInsets.all(20),
          decoration: BoxDecoration(
            color: Theme.of(context).colorScheme.surface,
            borderRadius: BorderRadius.circular(12),
          ),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              const Text(
                'Enter a name for the test',
                style: TextStyle(fontSize: 18),
              ),
              const SizedBox(height: 12),
              TextFormField(
                controller: controller,
                autofocus: true,
                autovalidateMode: AutovalidateMode.onUserInteraction,
                initialValue: widget.initialValue,
                decoration: InputDecoration(
                  labelText: widget.label,
                  border: const OutlineInputBorder(),
                ),
                validator: widget.validator,
              ),
              const SizedBox(height: 20),
              OverflowBar(
                children: [
                  TextButton(
                    onPressed: () => Navigator.pop(context),
                    child: const Text('Cancel'),
                  ),
                  FilledButton(
                    onPressed: () {
                      final value = controller.text.trim();
                      if (widget.validator != null) {
                        if (widget.validator!(value) == null) {
                          Navigator.pop(context, value);
                        }
                      } else {
                        Navigator.pop(context, value);
                      }
                    },
                    child: const Text('Record'),
                  ),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }

  @override
  void dispose() {
    controller.dispose();
    super.dispose();
  }
}

class ExportDialog extends StatefulWidget {
  const ExportDialog({super.key});

  @override
  State<ExportDialog> createState() => _ExportDialogState();
}

class _ExportDialogState extends State<ExportDialog> {
  bool withTolerance = true;
  bool roundValues = false;

  @override
  Widget build(BuildContext context) {
    return Material(
      type: MaterialType.transparency,
      child: Center(
        child: Container(
          width: 300,
          decoration: BoxDecoration(
            color: Theme.of(context).colorScheme.surface,
            borderRadius: BorderRadius.circular(12),
          ),
          padding: const EdgeInsets.all(20),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                'Export Settings',
                style: Theme.of(context).textTheme.titleMedium,
              ),
              CheckboxListTile(
                value: withTolerance,
                controlAffinity: ListTileControlAffinity.leading,
                title: const Text('With tolerance'),
                onChanged: (value) =>
                    setState(() => withTolerance = value ?? false),
              ),
              CheckboxListTile(
                value: roundValues,
                controlAffinity: ListTileControlAffinity.leading,
                title: const Text('Pixel Snapping'),
                onChanged: (value) =>
                    setState(() => roundValues = value ?? false),
              ),
              OverflowBar(
                children: [
                  TextButton(
                    onPressed: () => Navigator.pop(context),
                    child: const Text('Cancel'),
                  ),
                  FilledButton(
                    onPressed: () {
                      Navigator.pop(context, {
                        'withTolerance': withTolerance,
                        'roundValues': roundValues,
                      });
                    },
                    child: const Text('Export'),
                  ),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }
}
