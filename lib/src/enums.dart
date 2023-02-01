enum HandlePosition {
  topLeft,
  topRight,
  bottomLeft,
  bottomRight;

  bool get isLeft => this == topLeft || this == bottomLeft;

  bool get isRight => this == topRight || this == bottomRight;

  bool get isTop => this == topLeft || this == topRight;

  bool get isBottom => this == bottomLeft || this == bottomRight;
}

enum Flip {
  none,
  horizontal,
  vertical,
  diagonal;

  bool get isFlipped => this != Flip.none;

  bool get isHorizontal => this == Flip.horizontal || this == Flip.diagonal;

  bool get isVertical => this == Flip.vertical || this == Flip.diagonal;

  bool get isDiagonal => this == Flip.diagonal;

  bool get isFlippingOnX => this == Flip.horizontal || this == Flip.diagonal;

  bool get isFlippingOnY => this == Flip.vertical || this == Flip.diagonal;

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

  bool get isFreeform => this == ResizeMode.freeform;

  bool get isSymmetric => this == ResizeMode.symmetric;

  bool get isScale => this == ResizeMode.scale;

  bool get isSymmetricScale => this == ResizeMode.symmetricScale;
}
