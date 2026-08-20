import 'package:flutter/animation.dart';

/// Organic easing curves aligned with ZenU web motion tokens.
abstract final class AppCurves {
  /// CSS `--ease-out`: cubic-bezier(0.16, 1, 0.3, 1)
  static const Curve easeOut = Cubic(0.16, 1, 0.3, 1);

  /// CSS `--ease-in-out`: cubic-bezier(0.65, 0, 0.35, 1)
  static const Curve easeInOut = Cubic(0.65, 0, 0.35, 1);

  /// Soft spring for micro-interactions: cubic-bezier(0.34, 1.56, 0.64, 1)
  static const Curve spring = Cubic(0.34, 1.56, 0.64, 1);

  static const Curve breathe = Curves.easeInOutSine;
}
