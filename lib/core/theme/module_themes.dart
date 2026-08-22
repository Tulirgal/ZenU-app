import 'package:flutter/material.dart';
import 'dart:math' as math;

enum LiveEffect { stars, bubbles, ripples, leaves, fireflies, petals, aurora, none }

class ModuleTheme {
  final LinearGradient gradient;
  final Color accentColor;
  final Color accentLight;
  final Color textPrimary;
  final Color textSecondary;
  final Color cardBg;
  final Color cardBorder;
  final Color particleColor;
  final int particleCount;
  final LiveEffect liveEffect;

  const ModuleTheme({
    required this.gradient,
    required this.accentColor,
    required this.accentLight,
    required this.textPrimary,
    required this.textSecondary,
    required this.cardBg,
    required this.cardBorder,
    required this.particleColor,
    required this.particleCount,
    required this.liveEffect,
  });
}

class ModuleThemes {
  static final Map<String, ModuleTheme> _themes = {
    'home': const ModuleTheme(
      gradient: LinearGradient(
        colors: [Color(0xFF0F0C29), Color(0xFF302B63), Color(0xFF24243E)],
        stops: [0.0, 0.40, 1.0],
        transform: GradientRotation(135 * math.pi / 180),
      ),
      accentColor: Color(0xFFA78BFA),
      accentLight: Color.fromRGBO(167, 139, 250, 0.12),
      textPrimary: Color(0xFFF1F0FF),
      textSecondary: Color(0xFFC4B5FD),
      cardBg: Color.fromRGBO(255, 255, 255, 0.07),
      cardBorder: Color.fromRGBO(167, 139, 250, 0.2),
      particleColor: Color(0xFFC4B5FD),
      particleCount: 30,
      liveEffect: LiveEffect.aurora,
    ),
    'breathing': const ModuleTheme(
      gradient: LinearGradient(
        colors: [Color(0xFF001A2C), Color(0xFF003D5C), Color(0xFF00688B), Color(0xFF0099BB)],
        stops: [0.0, 0.40, 0.80, 1.0],
        transform: GradientRotation(180 * math.pi / 180),
      ),
      accentColor: Color(0xFF38BDF8),
      accentLight: Color.fromRGBO(56, 189, 248, 0.12),
      textPrimary: Color(0xFFE0F7FF),
      textSecondary: Color(0xFF7DD3FC),
      cardBg: Color.fromRGBO(0, 100, 150, 0.25),
      cardBorder: Color.fromRGBO(56, 189, 248, 0.25),
      particleColor: Color(0xFF38BDF8),
      particleCount: 20,
      liveEffect: LiveEffect.ripples,
    ),
    'mindfulness': const ModuleTheme(
      gradient: LinearGradient(
        colors: [Color(0xFF0D1F12), Color(0xFF1A3A22), Color(0xFF2D5A3D), Color(0xFF1A3A22)],
        stops: [0.0, 0.35, 0.70, 1.0],
        transform: GradientRotation(160 * math.pi / 180),
      ),
      accentColor: Color(0xFF4ADE80),
      accentLight: Color.fromRGBO(74, 222, 128, 0.1),
      textPrimary: Color(0xFFDCFCE7),
      textSecondary: Color(0xFF86EFAC),
      cardBg: Color.fromRGBO(20, 60, 30, 0.4),
      cardBorder: Color.fromRGBO(74, 222, 128, 0.2),
      particleColor: Color(0xFF86EFAC),
      particleCount: 25,
      liveEffect: LiveEffect.leaves,
    ),
    'gratitude': const ModuleTheme(
      gradient: LinearGradient(
        colors: [Color(0xFF1A0A00), Color(0xFF3D1F00), Color(0xFF7C4000), Color(0xFFC8740A), Color(0xFFF2C14E)],
        stops: [0.0, 0.30, 0.60, 0.85, 1.0],
        transform: GradientRotation(160 * math.pi / 180),
      ),
      accentColor: Color(0xFFF59E0B),
      accentLight: Color.fromRGBO(245, 158, 11, 0.12),
      textPrimary: Color(0xFFFEF9EE),
      textSecondary: Color(0xFFFCD34D),
      cardBg: Color.fromRGBO(120, 60, 0, 0.3),
      cardBorder: Color.fromRGBO(245, 158, 11, 0.25),
      particleColor: Color(0xFFFCD34D),
      particleCount: 20,
      liveEffect: LiveEffect.petals,
    ),
    'diary': const ModuleTheme(
      gradient: LinearGradient(
        colors: [Color(0xFF0F0817), Color(0xFF1E1035), Color(0xFF2D1B69), Color(0xFF1E1035)],
        stops: [0.0, 0.40, 0.75, 1.0],
        transform: GradientRotation(150 * math.pi / 180),
      ),
      accentColor: Color(0xFF818CF8),
      accentLight: Color.fromRGBO(129, 140, 248, 0.12),
      textPrimary: Color(0xFFEEF2FF),
      textSecondary: Color(0xFFA5B4FC),
      cardBg: Color.fromRGBO(30, 16, 53, 0.5),
      cardBorder: Color.fromRGBO(129, 140, 248, 0.2),
      particleColor: Color(0xFFA5B4FC),
      particleCount: 40,
      liveEffect: LiveEffect.stars,
    ),
    'doodle': const ModuleTheme(
      gradient: LinearGradient(
        colors: [Color(0xFF1A0533), Color(0xFF2D0D5E), Color(0xFF1E3A8A), Color(0xFF065F46), Color(0xFF1A0533)],
        stops: [0.0, 0.25, 0.55, 0.85, 1.0],
        transform: GradientRotation(135 * math.pi / 180),
      ),
      accentColor: Color(0xFFF0ABFC),
      accentLight: Color.fromRGBO(240, 171, 252, 0.12),
      textPrimary: Color(0xFFFDF4FF),
      textSecondary: Color(0xFFE879F9),
      cardBg: Color.fromRGBO(45, 13, 94, 0.4),
      cardBorder: Color.fromRGBO(240, 171, 252, 0.2),
      particleColor: Color(0xFFF0ABFC),
      particleCount: 35,
      liveEffect: LiveEffect.bubbles,
    ),
    'bubble': const ModuleTheme(
      gradient: LinearGradient(
        colors: [Color(0xFF001219), Color(0xFF005F73), Color(0xFF0A9396), Color(0xFF94D2BD)],
        stops: [0.0, 0.40, 0.75, 1.0],
        transform: GradientRotation(160 * math.pi / 180),
      ),
      accentColor: Color(0xFF94D2BD),
      accentLight: Color.fromRGBO(148, 210, 189, 0.12),
      textPrimary: Color(0xFFE8F8F5),
      textSecondary: Color(0xFF94D2BD),
      cardBg: Color.fromRGBO(0, 95, 115, 0.3),
      cardBorder: Color.fromRGBO(148, 210, 189, 0.25),
      particleColor: Color(0xFF94D2BD),
      particleCount: 18,
      liveEffect: LiveEffect.bubbles,
    ),
    'burst': const ModuleTheme(
      gradient: LinearGradient(
        colors: [Color(0xFF0A0514), Color(0xFF1E1035), Color(0xFF3B1C7A), Color(0xFF2D1B69)],
        stops: [0.0, 0.35, 0.70, 1.0],
        transform: GradientRotation(160 * math.pi / 180),
      ),
      accentColor: Color(0xFFC084FC),
      accentLight: Color.fromRGBO(192, 132, 252, 0.12),
      textPrimary: Color(0xFFFAF5FF),
      textSecondary: Color(0xFFD8B4FE),
      cardBg: Color.fromRGBO(30, 16, 53, 0.5),
      cardBorder: Color.fromRGBO(192, 132, 252, 0.25),
      particleColor: Color(0xFFE9D5FF),
      particleCount: 45,
      liveEffect: LiveEffect.stars,
    ),
    'scribble': const ModuleTheme(
      gradient: LinearGradient(
        colors: [Color(0xFF1C1410), Color(0xFF2D1F14), Color(0xFF3D2A1A), Color(0xFF1C1410)],
        stops: [0.0, 0.40, 0.70, 1.0],
        transform: GradientRotation(150 * math.pi / 180),
      ),
      accentColor: Color(0xFFD97706),
      accentLight: Color.fromRGBO(217, 119, 6, 0.12),
      textPrimary: Color(0xFFFEF3C7),
      textSecondary: Color(0xFFFCD34D),
      cardBg: Color.fromRGBO(45, 30, 20, 0.5),
      cardBorder: Color.fromRGBO(217, 119, 6, 0.2),
      particleColor: Color(0xFFFCD34D),
      particleCount: 12,
      liveEffect: LiveEffect.none,
    ),
    'chat': const ModuleTheme(
      gradient: LinearGradient(
        colors: [Color(0xFF020617), Color(0xFF0F172A), Color(0xFF1E3A5F), Color(0xFF0F172A)],
        stops: [0.0, 0.40, 0.75, 1.0],
        transform: GradientRotation(160 * math.pi / 180),
      ),
      accentColor: Color(0xFF60A5FA),
      accentLight: Color.fromRGBO(96, 165, 250, 0.1),
      textPrimary: Color(0xFFEFF6FF),
      textSecondary: Color(0xFF93C5FD),
      cardBg: Color.fromRGBO(15, 23, 42, 0.6),
      cardBorder: Color.fromRGBO(96, 165, 250, 0.2),
      particleColor: Color(0xFF93C5FD),
      particleCount: 25,
      liveEffect: LiveEffect.stars,
    ),
    'healing-garden': const ModuleTheme(
      gradient: LinearGradient(
        colors: [Color(0xFF0A1628), Color(0xFF0D2137), Color(0xFF0F3D2A), Color(0xFF0A1628)],
        stops: [0.0, 0.30, 0.65, 1.0],
        transform: GradientRotation(180 * math.pi / 180),
      ),
      accentColor: Color(0xFF4ADE80),
      accentLight: Color.fromRGBO(74, 222, 128, 0.1),
      textPrimary: Color(0xFFF0FFF4),
      textSecondary: Color(0xFF86EFAC),
      cardBg: Color.fromRGBO(10, 22, 40, 0.5),
      cardBorder: Color.fromRGBO(74, 222, 128, 0.15),
      particleColor: Color(0xFFF2C14E),
      particleCount: 8,
      liveEffect: LiveEffect.fireflies,
    ),
    'innercompass': const ModuleTheme(
      gradient: LinearGradient(
        colors: [Color(0xFFFFF0F5), Color(0xFFFFE1E9), Color(0xFFFFD1DF)],
        stops: [0.0, 0.50, 1.0],
        transform: GradientRotation(160 * math.pi / 180),
      ),
      accentColor: Color(0xFFEC4899),
      accentLight: Color.fromRGBO(236, 72, 153, 0.1),
      textPrimary: Color(0xFF831843),
      textSecondary: Color(0xFFBE185D),
      cardBg: Color.fromRGBO(255, 255, 255, 0.6),
      cardBorder: Color.fromRGBO(236, 72, 153, 0.2),
      particleColor: Color(0xFFFBCFE8),
      particleCount: 30,
      liveEffect: LiveEffect.petals,
    ),
  };

  static ModuleTheme getTheme(String key) {
    return _themes[key] ?? _themes['home']!;
  }
}
