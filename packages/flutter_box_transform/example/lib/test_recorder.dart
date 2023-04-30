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
    );
    current.add(TestRecord(action: action));
    return action;
  }

  void onResult({
    required TestAction action,
    required Offset localPosition,
    required UITransformResult result,
  }) {
    final record = current.firstWhere((item) => item.action.id == action.id);
    record.result = result;
    record.localPosition = localPosition;
    notifyListeners();
  }

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
  UITransformResult? result;
  Offset? localPosition;

  TestRecord({
    required this.action,
    this.result,
    this.localPosition,
  });
}

class TestAction with EquatableMixin {
  final int id;
  final ResizeMode resizeMode;
  final Flip flip;
  final Rect box;
  final HandlePosition handle;
  final Offset position;
  final Rect? clampingBox;
  final BoxConstraints? constraints;

  TestAction({
    required this.resizeMode,
    required this.flip,
    required this.box,
    required this.handle,
    required this.position,
    this.clampingBox,
    this.constraints,
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
                    index % 2 == 0 ? Colors.grey.withOpacity(0.07) : null,
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

      final path = await FilePicker.platform.saveFile(
        dialogTitle: 'Export tests',
        fileName: 'resizing_test.dart',
        allowedExtensions: ['.dart'],
      );
      if (path == null) return;

      exportTests(
        path,
        roundValues: settings['roundValues'] == true,
        withTolerance: settings['withTolerance'] == true,
      );
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
        final records = record.value;
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
      import 'package:vector_math/vector_math.dart';
      import 'package:box_transform/box_transform.dart';
      ${withTolerance ? "import 'utils.dart';" : ''}
      
      void main(){
        ${tests.join('\n')}
      }
    ''';

      final formatted = DartFormatter().format(testFile);
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
      return roundValues ? value.round().toString() : value.toStringAsFixed(2);
    }

    final String left = formattedValue(record.action.box.left);
    final String top = formattedValue(record.action.box.top);
    final String width = formattedValue(record.action.box.width);
    final String height = formattedValue(record.action.box.height);

    String matcher =
        'Box.fromLTWH(${formattedValue(record.result!.rect.left)}, ${formattedValue(record.result!.rect.top)}, ${formattedValue(record.result!.rect.width)}, ${formattedValue(record.result!.rect.height)})';

    if (withTolerance) {
      matcher = 'withTolerance($matcher)';
    }

    String? clampingRect;
    String? constraints;

    if (record.action.clampingBox != null) {
      clampingRect =
          'Box.fromLTWH(${formattedValue(record.action.clampingBox!.left)}, ${formattedValue(record.action.clampingBox!.top)}, ${formattedValue(record.action.clampingBox!.width)}, ${formattedValue(record.action.clampingBox!.height)})';
    }

    if (record.action.constraints != null) {
      constraints =
          'Constraints(minWidth: ${formattedValue(record.action.clampingBox!.width)}, minHeight: ${formattedValue(record.action.clampingBox!.height)}, maxWidth: ${formattedValue(record.action.clampingBox!.width)}, maxHeight: ${formattedValue(record.action.clampingBox!.height)}))';
    }

    buffer.writeln('''
    
      ${index == 0 ? 'var ' : ''}result = BoxTransformer.resize(
        resizeMode: ${record.action.resizeMode},
        initialFlip: ${record.action.flip},
        initialBox: Box.fromLTWH($left, $top, $width, $height),
        handle: ${record.action.handle},
        initialLocalPosition: Vector2(${formattedValue(record.action.position.dx)}, ${formattedValue(record.action.position.dy)}),
        flipRect: true,
        localPosition: Vector2(${formattedValue(record.localPosition!.dx)}, ${formattedValue(record.localPosition!.dy)}),
        ${clampingRect != null ? 'clampingRect: $clampingRect,' : ''}
        ${constraints != null ? 'constraints: $constraints,' : ''}
      );
      
      expect(result.flip, ${record.result!.flip});
      expect(result.rect${roundValues ? '.floor()' : ''}, $matcher);
      expect(result.resizeMode, ${record.result!.resizeMode});
      
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
              ButtonBar(
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
              ButtonBar(
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
