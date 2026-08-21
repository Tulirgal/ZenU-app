import 'package:flutter/material.dart'; 
/// Flutter equivalent of the web app's moduleThemes.ts 
/// Every module has its own gradient, accent, text colors, and live particle effect. 
/// This mirrors the web app's Module-Based Theming architecture exactly. 
enum LiveEffect { 
stars, 
bubbles, 
ripples, 
leaves, 
fireflies, 
petals, 
aurora, 
none, 
} 
class ModuleTheme { 
final List<Color> gradientColors; 
final List<double> gradientStops; 
final AlignmentGeometry gradientBegin; 
final AlignmentGeometry gradientEnd; 
final Color accentColor; 
final Color accentLight; 
final Color textPrimary; 
final Color textSecondary; 
final Color cardBg; 
final Color cardBorder; 
final LiveEffect liveEffect; 
  final Color particleColor; 
  final int particleCount; 
 
  const ModuleTheme({ 
    required this.gradientColors, 
    required this.gradientStops, 
    this.gradientBegin = Alignment.topLeft, 
    this.gradientEnd = Alignment.bottomRight, 
    required this.accentColor, 
    required this.accentLight, 
    required this.textPrimary, 
    required this.textSecondary, 
    required this.cardBg, 
    required this.cardBorder, 
    required this.liveEffect, 
    required this.particleColor, 
    this.particleCount = 20, 
  }); 
 
  LinearGradient get gradient => LinearGradient( 
    colors: gradientColors, 
    stops: gradientStops, 
    begin: gradientBegin, 
    end: gradientEnd, 
  ); 
} 
 
class ModuleThemes { 
  // Home / Dashboard — Deep space purple with aurora 
  static const home = ModuleTheme( 
    gradientColors: [Color(0xFF0F0C29), Color(0xFF302B63), Color(0xFF24243E)], 
    gradientStops: [0.0, 0.4, 1.0], 
    gradientBegin: Alignment.topLeft, 
    gradientEnd: Alignment.bottomRight, 
    accentColor: Color(0xFFA78BFA), 
    accentLight: Color(0x1FA78BFA), 
    textPrimary: Color(0xFFF1F0FF), 
    textSecondary: Color(0xFFC4B5FD), 
    cardBg: Color(0x12FFFFFF), 
    cardBorder: Color(0x33A78BFA), 
    liveEffect: LiveEffect.aurora, 
    particleColor: Color(0xFFC4B5FD), 
    particleCount: 30, 
  ); 
 
  // Breathing — Ocean blues with ripple rings 
  static const breathing = ModuleTheme( 
    gradientColors: [Color(0xFF001A2C), Color(0xFF003D5C), Color(0xFF00688B), 
Color(0xFF0099BB)], 
    gradientStops: [0.0, 0.4, 0.8, 1.0], 
    gradientBegin: Alignment.topCenter, 
    gradientEnd: Alignment.bottomCenter, 
    accentColor: Color(0xFF38BDF8), 
    accentLight: Color(0x1F38BDF8), 
    textPrimary: Color(0xFFE0F7FF), 
    textSecondary: Color(0xFF7DD3FC), 
    cardBg: Color(0x40006496), 
    cardBorder: Color(0x4038BDF8), 
    liveEffect: LiveEffect.ripples, 
    particleColor: Color(0xFF38BDF8), 
    particleCount: 20, 
  ); 
 
  // Mindfulness / Meditation — Deep forest green with falling leaves 
  static const mindfulness = ModuleTheme( 
    gradientColors: [Color(0xFF0D1F12), Color(0xFF1A3A22), Color(0xFF2D5A3D)], 
    gradientStops: [0.0, 0.35, 1.0], 
    gradientBegin: Alignment.topLeft, 
    gradientEnd: Alignment.bottomRight, 
    accentColor: Color(0xFF4ADE80), 
    accentLight: Color(0x1A4ADE80), 
    textPrimary: Color(0xFFDCFCE7), 
    textSecondary: Color(0xFF86EFAC), 
    cardBg: Color(0x66143C1E), 
    cardBorder: Color(0x334ADE80), 
    liveEffect: LiveEffect.leaves, 
    particleColor: Color(0xFF86EFAC), 
    particleCount: 25, 
  ); 
 
  // Gratitude — Warm amber sunrise with petals 
  static const gratitude = ModuleTheme( 
    gradientColors: [Color(0xFF1A0A00), Color(0xFF3D1F00), Color(0xFF7C4000), 
Color(0xFFF2C14E)], 
    gradientStops: [0.0, 0.3, 0.6, 1.0], 
    gradientBegin: Alignment.topLeft, 
    gradientEnd: Alignment.bottomRight, 
    accentColor: Color(0xFFF59E0B), 
    accentLight: Color(0x1FF59E0B), 
    textPrimary: Color(0xFFFEF9EE), 
    textSecondary: Color(0xFFFCD34D), 
    cardBg: Color(0x4C783C00), 
    cardBorder: Color(0x40F59E0B), 
    liveEffect: LiveEffect.petals, 
    particleColor: Color(0xFFFCD34D), 
    particleCount: 20, 
  ); 
 
  // Diary — Twilight purple with stars 
  static const diary = ModuleTheme( 
    gradientColors: [Color(0xFF0F0817), Color(0xFF1E1035), Color(0xFF2D1B69)], 
    gradientStops: [0.0, 0.4, 1.0], 
    gradientBegin: Alignment.topLeft, 
    gradientEnd: Alignment.bottomRight, 
    accentColor: Color(0xFF818CF8), 
    accentLight: Color(0x1F818CF8), 
    textPrimary: Color(0xFFEEF2FF), 
    textSecondary: Color(0xFFA5B4FC), 
    cardBg: Color(0x801E1035), 
    cardBorder: Color(0x33818CF8), 
    liveEffect: LiveEffect.stars, 
    particleColor: Color(0xFFA5B4FC), 
    particleCount: 40, 
  ); 
 
  // Chat — Midnight blue with slow stars 
  static const chat = ModuleTheme( 
    gradientColors: [Color(0xFF020617), Color(0xFF0F172A), Color(0xFF1E3A5F)], 
    gradientStops: [0.0, 0.4, 1.0], 
    gradientBegin: Alignment.topLeft, 
    gradientEnd: Alignment.bottomRight, 
    accentColor: Color(0xFF60A5FA), 
    accentLight: Color(0x1960A5FA), 
    textPrimary: Color(0xFFEFF6FF), 
    textSecondary: Color(0xFF93C5FD), 
    cardBg: Color(0x990F172A), 
    cardBorder: Color(0x3360A5FA), 
    liveEffect: LiveEffect.stars, 
    particleColor: Color(0xFF93C5FD), 
    particleCount: 25, 
  ); 
 
  // Burst It Out — Dramatic crimson with ember fireflies 
  static const burst = ModuleTheme( 
    gradientColors: [Color(0xFF0D0000), Color(0xFF3B0014), Color(0xFF7F1D1D)], 
    gradientStops: [0.0, 0.35, 1.0], 
    gradientBegin: Alignment.topLeft, 
    gradientEnd: Alignment.bottomRight, 
    accentColor: Color(0xFFF87171), 
    accentLight: Color(0x1FF87171), 
    textPrimary: Color(0xFFFFF1F1), 
    textSecondary: Color(0xFFFCA5A5), 
    cardBg: Color(0x663C0014), 
    cardBorder: Color(0x40F87171), 
    liveEffect: LiveEffect.fireflies, 
    particleColor: Color(0xFFFCA5A5), 
    particleCount: 15, 
  ); 
 
  // Bubble Canvas — Teal aqua with floating bubbles 
  static const bubble = ModuleTheme( 
    gradientColors: [Color(0xFF001219), Color(0xFF005F73), Color(0xFF0A9396)], 
    gradientStops: [0.0, 0.4, 1.0], 
    gradientBegin: Alignment.topCenter, 
    gradientEnd: Alignment.bottomCenter, 
    accentColor: Color(0xFF94D2BD), 
    accentLight: Color(0x1F94D2BD), 
    textPrimary: Color(0xFFE8F8F5), 
    textSecondary: Color(0xFF94D2BD), 
    cardBg: Color(0x4C005F73), 
    cardBorder: Color(0x4094D2BD), 
    liveEffect: LiveEffect.bubbles, 
    particleColor: Color(0xFF94D2BD), 
    particleCount: 18, 
  ); 
 
  // Doodle Dreams — Deep creative purple with colorful bubbles 
  static const doodle = ModuleTheme( 
    gradientColors: [Color(0xFF1A0533), Color(0xFF2D0D5E), Color(0xFF1E3A8A)], 
    gradientStops: [0.0, 0.25, 1.0], 
    gradientBegin: Alignment.topLeft, 
    gradientEnd: Alignment.bottomRight, 
    accentColor: Color(0xFFF0ABFC), 
    accentLight: Color(0x1FF0ABFC), 
    textPrimary: Color(0xFFFDF4FF), 
    textSecondary: Color(0xFFE879F9), 
    cardBg: Color(0x662D0D5E), 
    cardBorder: Color(0x33F0ABFC), 
    liveEffect: LiveEffect.bubbles, 
    particleColor: Color(0xFFF0ABFC), 
    particleCount: 35, 
  ); 
 
  // Scribble Pad — Warm ink tones, no live effect 
  static const scribble = ModuleTheme( 
    gradientColors: [Color(0xFF1C1410), Color(0xFF2D1F14), Color(0xFF3D2A1A)], 
    gradientStops: [0.0, 0.4, 1.0], 
    gradientBegin: Alignment.topLeft, 
    gradientEnd: Alignment.bottomRight, 
    accentColor: Color(0xFFD97706), 
    accentLight: Color(0x1FD97706), 
    textPrimary: Color(0xFFFEF3C7), 
    textSecondary: Color(0xFFFCD34D), 
    cardBg: Color(0x802D1F14), 
    cardBorder: Color(0x33D97706), 
    liveEffect: LiveEffect.none, 
    particleColor: Color(0xFFFCD34D), 
    particleCount: 0, 
  ); 
 
  // Healing Garden — Deep forest night with fireflies 
  static const healingGarden = ModuleTheme( 
    gradientColors: [Color(0xFF0A1628), Color(0xFF0D2137), Color(0xFF0F3D2A)], 
    gradientStops: [0.0, 0.3, 1.0], 
    gradientBegin: Alignment.topCenter, 
    gradientEnd: Alignment.bottomCenter, 
    accentColor: Color(0xFF4ADE80), 
    accentLight: Color(0x1A4ADE80), 
    textPrimary: Color(0xFFF0FFF4), 
    textSecondary: Color(0xFF86EFAC), 
    cardBg: Color(0x800A1628), 
    cardBorder: Color(0x264ADE80), 
    liveEffect: LiveEffect.fireflies, 
    particleColor: Color(0xFFF2C14E), 
    particleCount: 8, 
  ); 
 
  // Inner Compass — Deep cosmic with dense stars 
  static const innerCompass = ModuleTheme( 
    gradientColors: [Color(0xFF050014), Color(0xFF0F0030), Color(0xFF1A0050)], 
    gradientStops: [0.0, 0.35, 1.0], 
    gradientBegin: Alignment.topLeft, 
    gradientEnd: Alignment.bottomRight, 
    accentColor: Color(0xFFE879F9), 
    accentLight: Color(0x1AE879F9), 
    textPrimary: Color(0xFFFDF4FF), 
    textSecondary: Color(0xFFD946EF), 
    cardBg: Color(0x9905001A), 
    cardBorder: Color(0x33E879F9), 
    liveEffect: LiveEffect.stars, 
    particleColor: Color(0xFFE0AAFF), 
    particleCount: 60, 
  ); 
 
  // PSS Assessment — Calm neutral 
  static const pss = ModuleTheme( 
    gradientColors: [Color(0xFF0F0C29), Color(0xFF1E1B4B)], 
    gradientStops: [0.0, 1.0], 
    accentColor: Color(0xFFA78BFA), 
    accentLight: Color(0x1FA78BFA), 
    textPrimary: Color(0xFFF1F0FF), 
    textSecondary: Color(0xFFC4B5FD), 
    cardBg: Color(0x12FFFFFF), 
    cardBorder: Color(0x33A78BFA), 
    liveEffect: LiveEffect.none, 
    particleColor: Color(0xFFC4B5FD), 
    particleCount: 0, 
  ); 
 
  static ModuleTheme getTheme(String moduleKey) { 
    return switch (moduleKey) { 
      'home'           => home, 
      'breathing'      => breathing, 
      'mindfulness'    => mindfulness, 
      'gratitude'      => gratitude, 
      'diary'          => diary, 
      'chat'           => chat, 
      'burst'          => burst, 
      'bubble'         => bubble, 
      'doodle'         => doodle, 
      'scribble'       => scribble, 
      'healing_garden' => healingGarden, 
      'inner_compass'  => innerCompass, 
      'pss'            => pss, 
      _                => home, 
    }; 
  } 
}
