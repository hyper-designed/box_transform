/// Represents a resizing handle on corners.
enum HandlePosition {
  /// Represents the top left corner of the rect.
  topLeft,

  /// Represents the top right corner of the rect.
  topRight,

  /// Represents the bottom left corner of the rect.
  bottomLeft,

  /// Represents the bottom right corner of the rect.
  bottomRight;

  /// Whether the handle is on the left side of the rect.
  bool get isLeft => this == topLeft || this == bottomLeft;

  /// Whether the handle is on the right side of the rect.
  bool get isRight => this == topRight || this == bottomRight;

  /// Whether the handle is on the top side of the rect.
  bool get isTop => this == topLeft || this == topRight;

  /// Whether the handle is on the bottom side of the rect.
  bool get isBottom => this == bottomLeft || this == bottomRight;
}

/// Represents the flip state of a rectangle, or, in other words, if the
/// box is flipped horizontally, vertically, or diagonally.
enum Flip {
  /// No flipping, the rect stays as it is, not allowing any flipping.
  none,

  /// Flipped horizontally. When a rect is flipped on x-axis, the left side
  /// becomes right and vice versa.
  horizontal,

  /// Flipped vertically. When a rect is flipped on y-axis, the top side
  /// becomes bottom and vice versa.
  vertical,

  /// Flipped diagonally. When a rect is flipped on both axis, the top left
  /// becomes bottom right and vice versa.
  ///
  /// This flip is uniform, meaning that flipping top-left with bottom-right
  /// will result in the same rect as flipping bottom-left with top-right.
  diagonal;

  /// Creates a [Flip] from the given [horizontal] and [vertical] values.
  /// The values itself are not used, only their sign is used to determine
  /// the flip state.
  factory Flip.fromValue(num horizontal, num vertical) {
    if (horizontal.isNegative && vertical.isNegative) {
      return Flip.diagonal;
    } else if (horizontal.isNegative) {
      return Flip.horizontal;
    } else if (vertical.isNegative) {
      return Flip.vertical;
    } else {
      return Flip.none;
    }
  }

  /// Whether it is flipped or not.
  bool get isFlipped => this != Flip.none;

  /// Whether it is not flipped or is.
  bool get isNotFlipped => this == Flip.none;

  /// Whether the flip is horizontal.
  bool get isHorizontal => this == Flip.horizontal || this == Flip.diagonal;

  /// Whether the flip is vertical.
  bool get isVertical => this == Flip.vertical || this == Flip.diagonal;

  /// Whether the flip is diagonal.
  bool get isDiagonal => this == Flip.diagonal;

  /// Whether the flip is on x-axis, meaning that it is either horizontal
  /// or diagonal.
  bool get isFlippingOnX => this == Flip.horizontal || this == Flip.diagonal;

  /// Whether the flip is on y-axis, meaning that it is either vertical
  /// or diagonal.
  bool get isFlippingOnY => this == Flip.vertical || this == Flip.diagonal;

  /// The horizontal value of the flip. Negative if it is flipped horizontally,
  /// positive otherwise.
  double get horizontalValue => isHorizontal ? -1 : 1;

  /// The vertical value of the flip. Negative if it is flipped vertically,
  /// positive otherwise.
  double get verticalValue => isVertical ? -1 : 1;

  /// Creates a new [Flip] by combining this [Flip] with the given.
  /// See [influencedBy] for more details.
  operator *(Flip other) => influencedBy(other);

  /// Creates a new [Flip] by combining this [Flip] with the given
  /// [other] flip making the resulting flip influenced by [other].
  Flip influencedBy(Flip other) {
    if (other == Flip.none) return this;
    if (this == Flip.none) return other;
    return Flip.fromValue(
      horizontalValue * other.horizontalValue,
      verticalValue * other.verticalValue,
    );
  }

  /// Displayable representation of the [Flip] value.
  String get prettify {
    switch (this) {
      case Flip.none:
        return 'None';
      case Flip.horizontal:
        return 'Horizontal';
      case Flip.vertical:
        return 'Vertical';
      case Flip.diagonal:
        return 'Diagonal';
    }
  }
}

/// Represents different types resizing modes. These are used to determine
/// how the rect should be resized.
///
/// For example,
///
/// [ResizeMode.freeform] is the default mode where the rect can be resized
/// freely without any constraints.
///
/// [ResizeMode.symmetric] is like [ResizeMode.freeform] but it is symmetric
/// w.r.t the center. So if you resize the rect from right edge, it will also
/// resize from left edge. This is useful when you want to resize the rect
/// from the center.
///
/// [ResizeMode.scale] is like [ResizeMode.freeform] but it preserves
/// aspect ratio. So if you resize the rect from right edge, it will also
/// resize from left edge but the aspect ratio will be preserved.
///
/// [ResizeMode.symmetricScale] is like [ResizeMode.scale] but it is symmetric
/// w.r.t the center. So if you resize the rect from right edge, it will also
/// resize from left edge but the aspect ratio will be preserved.
///
/// See also:
/// * [ResizeMode.freeform]
/// * [ResizeMode.symmetric]
/// * [ResizeMode.scale]
/// * [ResizeMode.symmetricScale]
enum ResizeMode {
  /// Freeform resizing without any constraints.
  ///
  /// Usually with no modifier keys pressed.
  freeform,

  /// This is like [ResizeMode.freeform] Resizing w.r.t the center.
  ///
  /// This means moving right edge 10 pixels inwards will move left edge
  /// 10 pixels inwards as well. So if you reduce width 10 pixels from right
  /// edge, you will also reduce width 10 pixels from left edge reducing 20
  /// pixels effectively.
  ///
  /// Usually with ALT pressed.
  symmetric,

  /// This is like [ResizeMode.freeform] but preserves aspect ratio making
  /// it look like it is scaling up/down.
  ///
  /// Usually with SHIFT pressed.
  scale,

  /// This is like [ResizeMode.scale] but with rules of [ResizeMode.symmetric]
  /// applied. So it would scale up/down symmetrically w.r.t the center.
  ///
  /// This means moving bottom-right corner 10 pixels inwards will move top-left
  /// corner 10 pixels inwards as well while preserving aspect ratio. So if
  /// you reduce width 10 pixels from bottom-right corner, you will also reduce
  /// width 10 pixels from top-left corner reducing 20 pixels effectively.
  ///
  /// Usually with ALT + SHIFT pressed.
  symmetricScale;

  /// Whether the [ResizeMode] is [ResizeMode.freeform].
  bool get isFreeform => this == ResizeMode.freeform;

  /// Whether the [ResizeMode] is [ResizeMode.symmetric].
  bool get isSymmetric => this == ResizeMode.symmetric;

  /// Whether the [ResizeMode] is [ResizeMode.scale].
  bool get isScale => this == ResizeMode.scale;

  /// Whether the [ResizeMode] is [ResizeMode.symmetricScale].
  bool get isSymmetricScale => this == ResizeMode.symmetricScale;

  /// Whether the [ResizeMode] is scalable.
  /// i.e. [ResizeMode.scale] or [ResizeMode.symmetricScale].
  /// Used to determine whether the aspect ratio should be preserved.
  bool get isScalable => isScale || isSymmetricScale;

  /// Whether the [ResizeMode] is symmetric.
  /// i.e. [ResizeMode.symmetric] or [ResizeMode.symmetricScale].
  /// Used to determine whether the resize should be symmetric and
  /// w.r.t the center.
  bool get hasSymmetry => isSymmetric || isSymmetricScale;
}
