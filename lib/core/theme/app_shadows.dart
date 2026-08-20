import 'package:flutter/material.dart';

/// Soft navy-tinted depth — subtle, never heavy glass.
abstract final class AppShadows {
  static const Color _tint = Color(0xFF1E295A);

  static List<BoxShadow> get subtle => [
        BoxShadow(
          color: _tint.withValues(alpha: 0.04),
          blurRadius: 2,
          offset: const Offset(0, 1),
        ),
        BoxShadow(
          color: _tint.withValues(alpha: 0.04),
          blurRadius: 4,
          offset: const Offset(0, 1),
        ),
      ];

  static List<BoxShadow> get card => [
        BoxShadow(
          color: _tint.withValues(alpha: 0.06),
          blurRadius: 8,
          offset: const Offset(0, 2),
        ),
        BoxShadow(
          color: _tint.withValues(alpha: 0.04),
          blurRadius: 2,
          offset: const Offset(0, 1),
        ),
      ];

  static List<BoxShadow> get elevated => [
        BoxShadow(
          color: _tint.withValues(alpha: 0.08),
          blurRadius: 24,
          offset: const Offset(0, 8),
        ),
        BoxShadow(
          color: _tint.withValues(alpha: 0.04),
          blurRadius: 6,
          offset: const Offset(0, 2),
        ),
      ];

  static List<BoxShadow> get floating => [
        BoxShadow(
          color: _tint.withValues(alpha: 0.12),
          blurRadius: 40,
          offset: const Offset(0, 16),
        ),
        BoxShadow(
          color: _tint.withValues(alpha: 0.06),
          blurRadius: 12,
          offset: const Offset(0, 4),
        ),
      ];

  /// Soft primary glow for focus / celebration accents.
  static List<BoxShadow> glow(Color color) => [
        BoxShadow(
          color: color.withValues(alpha: 0.28),
          blurRadius: 24,
          spreadRadius: 0,
          offset: const Offset(0, 8),
        ),
      ];
}
