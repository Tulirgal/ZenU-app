import 'package:flutter/material.dart';

/// ZenU semantic colors — mapped from web design tokens (light mode only).
///
/// Source of truth for identity: Zenu-frontend `globals.css` `--zen-*` tokens.
abstract final class AppColors {
  static Color _hsl(double h, double s, double l) =>
      HSLColor.fromAHSL(1, h, s / 100, l / 100).toColor();

  // Brand
  static final Color primary = _hsl(221, 70, 52);
  static final Color primarySoft = _hsl(221, 75, 96);
  static final Color primaryDark = _hsl(221, 70, 46);

  static final Color secondary = _hsl(262, 48, 58);
  static final Color secondarySoft = _hsl(262, 55, 96);

  static final Color accent = _hsl(172, 52, 40);
  static final Color accentSoft = _hsl(172, 55, 95);

  // Background
  static final Color background = _hsl(250, 28, 98);
  static final Color backgroundSecondary = _hsl(250, 22, 96);

  // Surface
  static final Color surface = _hsl(0, 0, 100);
  static final Color surfaceSoft = _hsl(250, 30, 99);
  static final Color surfaceElevated = _hsl(0, 0, 100);

  // Text
  static final Color textPrimary = _hsl(228, 30, 16);
  static final Color textSecondary = _hsl(228, 18, 42);
  static final Color textMuted = _hsl(228, 12, 62);
  static final Color textInverse = _hsl(0, 0, 100);

  // Borders
  static final Color border = _hsl(228, 20, 88);
  static final Color divider = _hsl(228, 20, 93);

  // Semantic
  static final Color success = _hsl(142, 62, 38);
  static final Color warning = _hsl(36, 88, 50);
  static final Color error = _hsl(0, 78, 54);
  static final Color info = primary;

  static final Color successSoft = _hsl(142, 62, 95);
  static final Color warningSoft = _hsl(36, 88, 96);
  static final Color errorSoft = _hsl(0, 78, 96);

  static final Color overlay = const Color(0x661E295A);

  // Emotion accents (Inner Compass / mood — not scattered in UI chrome)
  static final Color emotionSadness = _hsl(210, 70, 58);
  static final Color emotionCalm = _hsl(262, 48, 58);
  static final Color emotionJoy = _hsl(42, 92, 55);
  static final Color emotionAnger = _hsl(8, 78, 56);
  static final Color emotionFear = _hsl(275, 45, 55);
  static final Color emotionOkay = _hsl(172, 48, 42);
}
