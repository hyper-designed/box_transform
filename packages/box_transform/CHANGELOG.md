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
