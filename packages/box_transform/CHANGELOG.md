## 0.4.4-dev.3

- Revert root pubspec.yaml.

## 0.4.4-dev.2

- Update root pubspec.yaml name from box_transform to melos_box_transform

## 0.4.4-dev.1

- Fix pubspec.yaml repository url.

## 0.4.3

- Update dependencies & resolve deprecation warnings.
- Fix a bug where terminal resize events triggered on the incorrect axis.

## 0.4.1

- Remove `DoubleExt` from package exports.

## 0.4.0

- Fix stack overflow error when the clamping rect is smaller than the box rect.

## 0.3.0

- Refactored the core logic to make it more readable, cleaner and easier to maintain.
- Fix issues with resizing, constraints, clamping and flipping.
- [BREAKING]: Replace `flipRect` with `allowFlipping`.
- [BREAKING]: Rename `initialBox` to `initialRect` in `BoxTransformer.move` and `BoxTransformer.resize` methods.
- `ResizeResult` now exposes `laregest` rect and `handle` used.
- Refactored code and performed some cleanup.
- Bump up Dart sdk constraints to `3.0.0`.
- Update all documentation to reflect the new changes.
- Fix broken links in docs.
- Add tests for resizing features.

## 0.2.1

- Update license to Apache 2.0.
- Update docs and fix broken links.

## 0.2.0

- Fix scaling of rect not matching cursor position.

## 0.1.1

- Add example.

## 0.1.0

- Initial release.
