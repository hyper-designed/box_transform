## Setting up project for development

This project is a [Dart pub workspace](https://dart.dev/tools/pub/workspaces).
A single `pub get` at the repository root resolves dependencies for every
package in the monorepo and links them together. Requires Dart `>=3.6.0`
(Flutter `>=3.27.0`).

1. Clone the repository and fetch dependencies for the whole workspace:

```bash
flutter pub get
```

You can now run the example or playground apps directly. Local changes to
`box_transform` and `flutter_box_transform` are picked up automatically
because they are workspace members.

### Running tests

Run from the repo root to test all packages:

```bash
flutter test
```

> Use `flutter test` (not `dart test`) — the workspace contains Flutter
> packages, so the Dart-only resolver can't be used.

### Running tests with coverage report

1. Install genhtml:

```bash
brew install lcov
```

2. Run tests and generate report:

```bash
cd packages/box_transform
flutter pub run coverage:test_with_coverage
flutter pub run coverage:format_coverage --packages=../../.dart_tool/package_config.json --lcov -i coverage/coverage.json -o coverage/lcov.info
genhtml coverage/lcov.info -o coverage/html
```

3. Open `packages/box_transform/coverage/html/index.html` in your browser to
   view the report.

### Formatting and analysis

Run from the repo root to cover every package:

```bash
dart format .
dart analyze . --fatal-infos --fatal-warnings
```

### Test layout

The test suites use two complementary prefixes:

* `rotated_<feature>_test.dart` covers an existing feature *under rotation*
  (e.g. `rotated_freeform_test.dart`, `rotated_side_handle_test.dart`).
* `rotation_<aspect>_test.dart` covers the rotation feature itself
  (e.g. `rotation_primitives_test.dart`, `rotation_integration_test.dart`).

`clamp_*_test.dart` files are targeted regression tests for clamp behavior
(`clamp_invariants_test.dart`, `clamp_at_saturation_move_test.dart`); the
older `clamped_*_resizing_test.dart` family covers the legacy
"resize-with-clamping-enabled" suites.

`packages/flutter_box_transform/test` mirrors the same scheme for widget /
controller tests (`rotated_*` for features, `rotation_*` for rotation
itself).

### Playground test recorder

The playground has a built-in test recorder accessible from its side panel.
It captures every `onResizeUpdate` tick of a gesture (cursor positions +
rect outputs) along with the active `rotation` and `bindingStrategy`, and
exports a tick-by-tick replay test with per-tick clamp invariants. The
exported file uses `BoxTransformer.resize(...)` directly, so it lives in
`packages/box_transform/test/`. Use it whenever you find a visual bug that
only manifests under continuous gesture motion — a single direct jump from
start to end often won't reproduce the bug the recorder catches.
