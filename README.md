![Banner](https://raw.githubusercontent.com/hyper-designed/box_transform/main/docs/assets/banner.png)

# Box Transform

[![Build](https://github.com/hyper-designed/box_transform/actions/workflows/build.yml/badge.svg)](https://github.com/hyper-designed/box_transform/actions/workflows/build.yml) [![Tests](https://github.com/hyper-designed/box_transform/workflows/Tests/badge.svg?branch=main)](https://github.com/hyper-designed/box_transform/actions) [![codecov](https://codecov.io/gh/BirjuVachhani/box_transform/branch/main/graph/badge.svg?token=SX5FXDUD7A)](https://codecov.io/gh/BirjuVachhani/box_transform)

[Box Transform][github] provides packages that allows you to programmatically handle box resizing and dragging. 
It provides highly flexible, programmatically resizable and draggable boxes that can be used in any Dart or Flutter 
project.

## Packages

| Package               | Pub                                                                                                                            | Description                                                                                                              |
|-----------------------|--------------------------------------------------------------------------------------------------------------------------------|--------------------------------------------------------------------------------------------------------------------------|
| box_transform         | [![Pub Version](https://img.shields.io/pub/v/box_transform?label=Pub)](https://pub.dev/packages/box_transform)                 | A pure Dart implementation for box transformation operations that does not rely on Flutter.                              |
| flutter_box_transform | [![Pub Version](https://img.shields.io/pub/v/flutter_box_transform?label=Pub)](https://pub.dev/packages/flutter_box_transform) | A Flutter implementation that provides a flexible, customizable and easy to use interface tailored for Flutter projects. |


## Features

* 📏 **Dimension Constraining:** Set maximum and minimum constraints to keep boxes within specific boundaries while resizing.
* 🔁 **Flipping Mechanics:** Advanced positional-flipping when resizing hits extreme values with hard constraints.
* 🔒 **Drag Clamping:** Specify clamping boxes to keep your transformable boxes within a specific region.
* 🎨 **Flexible Resizing Modes:** Choose from four different resizing modes for more flexibility in how boxes are resized.
* 📍 **Customizable Anchor Points:** Define resizing corner-handles to anchor different parts of the box when resizing.
* 🎨 **Customizable Handles:** Use default resizing handles or define your own custom handles.
* 🌀 **Rotation Support:** Rotate boxes around their center, with full rotated-aware drag, resize, flip, and clamping. Choose between `BindingStrategy.originalBox` (the unrotated logical rect stays in the clamp; rotated corners may extend outside) and `BindingStrategy.boundingBox` (the rendered axis-aligned footprint stays inside). Rotation gestures slide-then-freeze: when the requested angle would force the rect outside the clamp, the box slides into available slack first, then caps at the last feasible angle. Rotated force-flip also falls back to the natural direction when the flipped state can't fit, so the rect stays clamp-pinned instead of jumping or freezing.
* 🚀 **Easy Integration:** Integrate Box Transform into your Dart or Flutter project with ease.

## Getting Started

Go to the [Getting Started][get-started] page of the 
[documentation][docsite] to start using Box Transform.

### Example App: [box-transform-example.firebaseapp.com](https://box-transform-example.firebaseapp.com)
### Playground: [box-transform-playground.firebaseapp.com](https://box-transform-playground.firebaseapp.com)

## Documentation

Documentation is available at [boxtransform.hyperdesigned.dev][docsite].

## Contributing

See [CONTRIBUTING.md][contributing] for details.

See [DEVELOPMENT.md][development] for development setup.

## Authors

<table>
  <tr>
    <td align="center"><a href="https://github.com/BirjuVachhani"><img src="https://avatars.githubusercontent.com/u/20423471?s=100" width="100px;" alt=""/><br /><sub><b>Birju Vachhani</b></sub></a></td>
    <td align="center"><a href="https://github.com/SaadArdati"><img src="https://avatars.githubusercontent.com/u/7407478?v=4" width="100px;" alt=""/><br /><sub><b>Saad Ardati</b></sub></a></td>
  </tr>
</table>

Feel free to join our Discord server for any inquiries or support!

<a href="https://discord.gg/yrahEhCqTJ"><img src="docs/assets/discord.png" width="200px"/></a>

## License

```
Copyright © 2023 Hyperdesigned

Licensed under the Apache License, Version 2.0 (the "License");
you may not use this file except in compliance with the License.
You may obtain a copy of the License at

    https://www.apache.org/licenses/LICENSE-2.0

Unless required by applicable law or agreed to in writing, software
distributed under the License is distributed on an "AS IS" BASIS,
WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND, either express or implied.
See the License for the specific language governing permissions and
limitations under the License.
```

[contributing]: https://github.com/hyper-designed/box_transform/blob/main/CONTRIBUTING.md
[development]: https://github.com/hyper-designed/box_transform/blob/main/development.md
[docsite]: https://boxtransform.hyperdesigned.dev/
[get-started]: https://boxtransform.hyperdesigned.dev/flutter_get_started
[github]: https://github.com/hyper-designed/box_transform
