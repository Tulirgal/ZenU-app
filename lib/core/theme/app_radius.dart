import 'package:flutter/material.dart';

/// Soft, approachable corner radii.
abstract final class AppRadius {
  static const double small = 8;
  static const double medium = 12;
  static const double large = 16;
  static const double extraLarge = 24;
  static const double pill = 999;

  static final BorderRadius smallAll = BorderRadius.circular(small);
  static final BorderRadius mediumAll = BorderRadius.circular(medium);
  static final BorderRadius largeAll = BorderRadius.circular(large);
  static final BorderRadius extraLargeAll = BorderRadius.circular(extraLarge);
  static final BorderRadius pillAll = BorderRadius.circular(pill);
}
