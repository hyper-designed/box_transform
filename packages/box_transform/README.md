![Banner](https://raw.githubusercontent.com/hyper-designed/box_transform/main/docs/assets/banner.png)

# Box Transform

[![Build](https://github.com/hyper-designed/box_transform/actions/workflows/build.yml/badge.svg)](https://github.com/hyper-designed/box_transform/actions/workflows/build.yml) [![Tests](https://github.com/hyper-designed/box_transform/workflows/Tests/badge.svg?branch=main)](https://github.com/hyper-designed/box_transform/actions) [![Pub Version](https://img.shields.io/pub/v/box_transform?label=Pub)](https://pub.dev/packages/box_transform)

[Box Transform](https://github.com/hyper-designed/box_transform) is a pure-Dart base package that allows you to
programmatically handle box resizing and dragging without relying on Flutter. It provides highly flexible,
programmatically resizable and draggable boxes that can be used in any Dart project.

## Features

* 📏 **Dimension Constraining:** Set maximum and minimum constraints to keep boxes within specific boundaries while
  resizing.
* 🔁 **Flipping Mechanics:** Advanced positional-flipping when resizing hits extreme values with hard constraints.
* 🔒 **Drag Clamping:** Specify clamping boxes to keep your transformable boxes within a specific region.
* 🎨 **Flexible Resizing Modes:** Choose from four different resizing modes for more flexibility in how boxes are
  resized.
* 📍 **Customizable Anchor Points:** Define resizing corner-handles to anchor different parts of the box when resizing.
* 🌀 **Rotation Support:** First-class rotation around the box's center via `Box.rotation` plus a dedicated
  `BoxTransformer.rotate(...)` entry point. Move, resize, scale, symmetric, side-handle, and force-flip all work
  under arbitrary rotation. `BindingStrategy.originalBox` keeps the unrotated logical rect inside the clamp, while
  `BindingStrategy.boundingBox` keeps the rendered AABB (rotated corners + unrotated rect) fully contained. Rotation
  gestures use slide-then-freeze: the box slides into available clamp slack to honor the requested angle, capping at
  the last feasible angle when no translation rescues it. `RotateResult.feasible` and `ResizeResult.feasible` expose
  this signal to callers (`false` ⇒ engine could not honor the gesture; the controller holds the last feasible state).
* 🚀 **Easy Integration:** Integrate Box Transform into your Dart or Flutter project with ease.

## Getting started

Go to the [Getting Started](https://docs.page/hyper-designed/box_transform/get_started) page of the
[documentation](https://boxtransform.hyperdesigned.dev/) to start using Box Transform.

### Example App: [box-transform-example.firebaseapp.com](https://box-transform-example.firebaseapp.com)
### Playground: [box-transform-playground.firebaseapp.com](https://box-transform-playground.firebaseapp.com)

## Documentation

Documentation is available at https://docs.page/hyper-designed/box_transform.

## Contributing

See [CONTRIBUTING.md](https://github.com/BirjuVachhani/adaptive_theme/blob/main/CONTRIBUTING.md) for details.

See [DEVELOPMENT.md](https://github.com/BirjuVachhani/adaptive_theme/blob/main/development.md) for development setup.

## Authors

<table>
  <tr>
    <td align="center"><a href="https://github.com/birjuvachhani"><img src="https://avatars.githubusercontent.com/u/20423471?s=100" width="100px;" alt=""/><br /><sub><b>Birju Vachhani</b></sub></a></td>
    <td align="center"><a href="https://github.com/SaadArdati"><img src="https://avatars.githubusercontent.com/u/7407478?v=4" width="100px;" alt=""/><br /><sub><b>Saad Ardati</b></sub></a></td>
  </tr>
</table>

Feel free to join our Discord server for any inquiries or support: https://discord.gg/yrahEhCqTJ

## License

```
BSD 3-Clause License

Copyright (c) 2023, Birju Vachhani

Redistribution and use in source and binary forms, with or without
modification, are permitted provided that the following conditions are met:

1. Redistributions of source code must retain the above copyright notice, this
   list of conditions and the following disclaimer.

2. Redistributions in binary form must reproduce the above copyright notice,
   this list of conditions and the following disclaimer in the documentation
   and/or other materials provided with the distribution.

3. Neither the name of the copyright holder nor the names of its
   contributors may be used to endorse or promote products derived from
   this software without specific prior written permission.

THIS SOFTWARE IS PROVIDED BY THE COPYRIGHT HOLDERS AND CONTRIBUTORS "AS IS"
AND ANY EXPRESS OR IMPLIED WARRANTIES, INCLUDING, BUT NOT LIMITED TO, THE
IMPLIED WARRANTIES OF MERCHANTABILITY AND FITNESS FOR A PARTICULAR PURPOSE ARE
DISCLAIMED. IN NO EVENT SHALL THE COPYRIGHT HOLDER OR CONTRIBUTORS BE LIABLE
FOR ANY DIRECT, INDIRECT, INCIDENTAL, SPECIAL, EXEMPLARY, OR CONSEQUENTIAL
DAMAGES (INCLUDING, BUT NOT LIMITED TO, PROCUREMENT OF SUBSTITUTE GOODS OR
SERVICES; LOSS OF USE, DATA, OR PROFITS; OR BUSINESS INTERRUPTION) HOWEVER
CAUSED AND ON ANY THEORY OF LIABILITY, WHETHER IN CONTRACT, STRICT LIABILITY,
OR TORT (INCLUDING NEGLIGENCE OR OTHERWISE) ARISING IN ANY WAY OUT OF THE USE
OF THIS SOFTWARE, EVEN IF ADVISED OF THE POSSIBILITY OF SUCH DAMAGE.

```
