import 'dart:io';
import 'dart:math';

// HSL to RGB conversion
String hslToHex(double h, double s, double l) {
  s /= 100.0;
  l /= 100.0;
  double c = (1 - (2 * l - 1).abs()) * s;
  double x = c * (1 - ((h / 60) % 2 - 1).abs());
  double m = l - c / 2;
  double r = 0, g = 0, b = 0;
  if (0 <= h && h < 60) {
    r = c; g = x; b = 0;
  } else if (60 <= h && h < 120) {
    r = x; g = c; b = 0;
  } else if (120 <= h && h < 180) {
    r = 0; g = c; b = x;
  } else if (180 <= h && h < 240) {
    r = 0; g = x; b = c;
  } else if (240 <= h && h < 300) {
    r = x; g = 0; b = c;
  } else if (300 <= h && h < 360) {
    r = c; g = 0; b = x;
  }
  int R = ((r + m) * 255).round();
  int G = ((g + m) * 255).round();
  int B = ((b + m) * 255).round();
  return '0xFF${R.toRadixString(16).padLeft(2, '0').toUpperCase()}${G.toRadixString(16).padLeft(2, '0').toUpperCase()}${B.toRadixString(16).padLeft(2, '0').toUpperCase()}';
}

void main() {
  String css = '''
  --zen-bg:             250 28% 98%;
  --zen-bg-subtle:      250 22% 96%;
  --zen-bg-muted:       250 16% 94%;
  --zen-surface:        0 0% 100%;
  --zen-surface-raised: 250 30% 99%;
  --zen-surface-elevated: 0 0% 100%;
  --zen-emotion-sadness:       210 70% 58%;
  --zen-emotion-sadness-soft:  210 70% 96%;
  --zen-emotion-okay:          172 48% 42%;
  --zen-emotion-okay-soft:     172 48% 95%;
  --zen-emotion-calm:          262 48% 58%;
  --zen-emotion-calm-soft:     262 55% 96%;
  --zen-emotion-joy:           42 92% 55%;
  --zen-emotion-joy-soft:      42 92% 96%;
  --zen-emotion-great:         350 72% 62%;
  --zen-emotion-great-soft:    350 72% 96%;
  --zen-emotion-surprise:      24 90% 58%;
  --zen-emotion-surprise-soft: 24 90% 96%;
  --zen-emotion-anger:         8 78% 56%;
  --zen-emotion-anger-soft:    8 78% 96%;
  --zen-emotion-fear:          275 45% 55%;
  --zen-emotion-fear-soft:     275 45% 96%;
  --zen-emotion-disgust:       142 40% 42%;
  --zen-emotion-disgust-soft:  142 40% 95%;
  --zen-fg:             228 30% 16%;
  --zen-fg-muted:       228 18% 42%;
  --zen-fg-subtle:      228 12% 62%;
  --zen-fg-inverse:     0 0% 100%;
  --zen-primary:        221 70% 52%;
  --zen-primary-hover:  221 70% 46%;
  --zen-primary-soft:   221 75% 96%;
  --zen-primary-fg:     0 0% 100%;
  --zen-secondary:      262 48% 58%;
  --zen-secondary-soft: 262 55% 96%;
  --zen-secondary-fg:   0 0% 100%;
  --zen-accent:         172 52% 40%;
  --zen-accent-soft:    172 55% 95%;
  --zen-accent-fg:      0 0% 100%;
  --zen-joy:            40 92% 55%;
  --zen-joy-soft:       40 92% 96%;
  --zen-border:         228 20% 88%;
  --zen-border-soft:    228 20% 93%;
  --zen-border-focus:   221 70% 52%;
  --zen-success:        142 62% 38%;
  --zen-success-soft:   142 62% 95%;
  --zen-warning:        36 88% 50%;
  --zen-warning-soft:   36 88% 96%;
  --zen-destructive:    0 78% 54%;
  --zen-destructive-soft: 0 78% 96%;
  ''';

  String outputColors = '';
  for (var line in css.trim().split(RegExp(r'\r?\n'))) {
    if (line.contains(':')) {
      var parts = line.split(':');
      var varName = parts[0].trim();
      var val = parts[1].trim().replaceAll(';', '');
      if (val.contains('%')) {
        var hslParts = val.split(RegExp(r'\s+'));
        var h = double.parse(hslParts[0]);
        var s = double.parse(hslParts[1].replaceAll('%', ''));
        var l = double.parse(hslParts[2].replaceAll('%', ''));
        var hexVal = hslToHex(h, s, l);
        var dartName = varName.replaceAll('--', '').split('-').asMap().entries.map((e) => e.key == 0 ? e.value.toLowerCase() : e.value[0].toUpperCase() + e.value.substring(1).toLowerCase()).join('');
        outputColors += '  static const Color $dartName = Color($hexVal); // from $varName\n';
      }
    }
  }

  String zenTokensContent = '''
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

// AUTO-GENERATED from globals.css
class ZenTokens {
$outputColors
  // --- RADII ---
  static const double radiusZenSm  = 8.0;
  static const double radiusZenMd  = 12.0;
  static const double radiusZenLg  = 16.0;
  static const double radiusZenXl  = 24.0;
  static const double radiusZen2xl = 32.0;
  static const double radiusZenFull = 9999.0;

  // Standard spacing
  static const double s1  = 4.0;
  static const double s2  = 8.0;
  static const double s3  = 12.0;
  static const double s4  = 16.0;
  static const double s5  = 20.0;
  static const double s6  = 24.0;
  static const double s7  = 28.0;
  static const double s8  = 32.0;
  static const double s9  = 36.0;
  static const double s10 = 40.0;
  static const double s12 = 48.0;
  static const double s14 = 56.0;
  static const double s16 = 64.0;
}

class AppTheme {
  static ThemeData get theme => ThemeData(
    useMaterial3: true,
    scaffoldBackgroundColor: Colors.transparent,
    colorScheme: ColorScheme.fromSeed(
      seedColor: ZenTokens.zenPrimary,
      primary: ZenTokens.zenPrimary,
    ),
    textTheme: GoogleFonts.interTextTheme().copyWith(
      displayLarge:  GoogleFonts.inter(fontSize: 28, fontWeight: FontWeight.w700, color: ZenTokens.zenFg, letterSpacing: -0.5),
      headlineMedium: GoogleFonts.inter(fontSize: 20, fontWeight: FontWeight.w600, color: ZenTokens.zenFg),
      bodyLarge:     GoogleFonts.inter(fontSize: 16, color: ZenTokens.zenFg),
      bodyMedium:    GoogleFonts.inter(fontSize: 14, color: ZenTokens.zenFgMuted),
      bodySmall:     GoogleFonts.inter(fontSize: 12, color: ZenTokens.zenFgSubtle),
      labelLarge:    GoogleFonts.inter(fontSize: 14, fontWeight: FontWeight.w600),
      labelSmall:    GoogleFonts.inter(fontSize: 10, fontWeight: FontWeight.w600, letterSpacing: 0.15),
    ),
    appBarTheme: const AppBarTheme(
      backgroundColor: Colors.transparent,
      elevation: 0,
      scrolledUnderElevation: 0,
    ),
    elevatedButtonTheme: ElevatedButtonThemeData(
      style: ElevatedButton.styleFrom(
        backgroundColor: ZenTokens.zenPrimary,
        foregroundColor: Colors.white,
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(ZenTokens.radiusZen2xl)),
        padding: const EdgeInsets.symmetric(horizontal: ZenTokens.s6, vertical: ZenTokens.s4 - 2),
        textStyle: GoogleFonts.inter(fontSize: 15, fontWeight: FontWeight.w600),
        elevation: 0,
      ),
    ),
  );
}
''';

  File('lib/core/theme/zen_tokens.dart').writeAsStringSync(zenTokensContent);

  String moduleThemesTs = '''
  home: {
    gradient: 'linear-gradient(135deg, #0f0c29 0%, #302b63 40%, #24243e 100%)',
    accentColor: '#a78bfa',
    accentLight: 'rgba(167,139,250,0.12)',
    textPrimary: '#f1f0ff',
    textSecondary: '#c4b5fd',
    cardBg: 'rgba(255,255,255,0.07)',
    cardBorder: 'rgba(167,139,250,0.2)',
    particles: { color: '#c4b5fd', count: 30, size: [1, 3], speed: 0.3 },
    liveEffect: 'aurora',
  },
  breathing: {
    gradient: 'linear-gradient(180deg, #001a2c 0%, #003d5c 40%, #00688b 80%, #0099bb 100%)',
    accentColor: '#38bdf8',
    accentLight: 'rgba(56,189,248,0.12)',
    textPrimary: '#e0f7ff',
    textSecondary: '#7dd3fc',
    cardBg: 'rgba(0,100,150,0.25)',
    cardBorder: 'rgba(56,189,248,0.25)',
    particles: { color: '#38bdf8', count: 20, size: [2, 5], speed: 0.2 },
    liveEffect: 'ripples',
  },
  mindfulness: {
    gradient: 'linear-gradient(160deg, #0d1f12 0%, #1a3a22 35%, #2d5a3d 70%, #1a3a22 100%)',
    accentColor: '#4ade80',
    accentLight: 'rgba(74,222,128,0.1)',
    textPrimary: '#dcfce7',
    textSecondary: '#86efac',
    cardBg: 'rgba(20,60,30,0.4)',
    cardBorder: 'rgba(74,222,128,0.2)',
    particles: { color: '#86efac', count: 25, size: [2, 6], speed: 0.15 },
    liveEffect: 'leaves',
  },
  gratitude: {
    gradient: 'linear-gradient(160deg, #1a0a00 0%, #3d1f00 30%, #7c4000 60%, #c8740a 85%, #f2c14e 100%)',
    accentColor: '#f59e0b',
    accentLight: 'rgba(245,158,11,0.12)',
    textPrimary: '#fef9ee',
    textSecondary: '#fcd34d',
    cardBg: 'rgba(120,60,0,0.3)',
    cardBorder: 'rgba(245,158,11,0.25)',
    particles: { color: '#fcd34d', count: 20, size: [1, 3], speed: 0.2 },
    liveEffect: 'petals',
  },
  diary: {
    gradient: 'linear-gradient(150deg, #0f0817 0%, #1e1035 40%, #2d1b69 75%, #1e1035 100%)',
    accentColor: '#818cf8',
    accentLight: 'rgba(129,140,248,0.12)',
    textPrimary: '#eef2ff',
    textSecondary: '#a5b4fc',
    cardBg: 'rgba(30,16,53,0.5)',
    cardBorder: 'rgba(129,140,248,0.2)',
    particles: { color: '#a5b4fc', count: 40, size: [1, 2], speed: 0.1 },
    liveEffect: 'stars',
  },
  doodle: {
    gradient: 'linear-gradient(135deg, #1a0533 0%, #2d0d5e 25%, #1e3a8a 55%, #065f46 85%, #1a0533 100%)',
    accentColor: '#f0abfc',
    accentLight: 'rgba(240,171,252,0.12)',
    textPrimary: '#fdf4ff',
    textSecondary: '#e879f9',
    cardBg: 'rgba(45,13,94,0.4)',
    cardBorder: 'rgba(240,171,252,0.2)',
    particles: { color: '#f0abfc', count: 35, size: [2, 5], speed: 0.25 },
    liveEffect: 'bubbles',
  },
  bubble: {
    gradient: 'linear-gradient(160deg, #001219 0%, #005f73 40%, #0a9396 75%, #94d2bd 100%)',
    accentColor: '#94d2bd',
    accentLight: 'rgba(148,210,189,0.12)',
    textPrimary: '#e8f8f5',
    textSecondary: '#94d2bd',
    cardBg: 'rgba(0,95,115,0.3)',
    cardBorder: 'rgba(148,210,189,0.25)',
    particles: { color: '#94d2bd', count: 18, size: [8, 24], speed: 0.3 },
    liveEffect: 'bubbles',
  },
  burst: {
    gradient: 'linear-gradient(160deg, #0a0514 0%, #1e1035 35%, #3b1c7a 70%, #2d1b69 100%)',
    accentColor: '#c084fc',
    accentLight: 'rgba(192,132,252,0.12)',
    textPrimary: '#faf5ff',
    textSecondary: '#d8b4fe',
    cardBg: 'rgba(30,16,53,0.5)',
    cardBorder: 'rgba(192,132,252,0.25)',
    particles: { color: '#e9d5ff', count: 45, size: [1, 3], speed: 0.8 },
    liveEffect: 'stars',
  },
  scribble: {
    gradient: 'linear-gradient(150deg, #1c1410 0%, #2d1f14 40%, #3d2a1a 70%, #1c1410 100%)',
    accentColor: '#d97706',
    accentLight: 'rgba(217,119,6,0.12)',
    textPrimary: '#fef3c7',
    textSecondary: '#fcd34d',
    cardBg: 'rgba(45,30,20,0.5)',
    cardBorder: 'rgba(217,119,6,0.2)',
    particles: { color: '#fcd34d', count: 12, size: [1, 3], speed: 0.15 },
    liveEffect: 'none',
  },
  chat: {
    gradient: 'linear-gradient(160deg, #020617 0%, #0f172a 40%, #1e3a5f 75%, #0f172a 100%)',
    accentColor: '#60a5fa',
    accentLight: 'rgba(96,165,250,0.1)',
    textPrimary: '#eff6ff',
    textSecondary: '#93c5fd',
    cardBg: 'rgba(15,23,42,0.6)',
    cardBorder: 'rgba(96,165,250,0.2)',
    particles: { color: '#93c5fd', count: 25, size: [1, 2], speed: 0.1 },
    liveEffect: 'stars',
  },
  "healing-garden": {
    gradient: 'linear-gradient(180deg, #0a1628 0%, #0d2137 30%, #0f3d2a 65%, #0a1628 100%)',
    accentColor: '#4ade80',
    accentLight: 'rgba(74,222,128,0.1)',
    textPrimary: '#f0fff4',
    textSecondary: '#86efac',
    cardBg: 'rgba(10,22,40,0.5)',
    cardBorder: 'rgba(74,222,128,0.15)',
    particles: { color: '#f2c14e', count: 8, size: [3, 5], speed: 0.15 },
    liveEffect: 'fireflies',
  },
  innercompass: {
    gradient: 'linear-gradient(160deg, #FFF0F5 0%, #FFE1E9 50%, #FFD1DF 100%)',
    accentColor: '#ec4899',
    accentLight: 'rgba(236,72,153,0.1)',
    textPrimary: '#831843',
    textSecondary: '#be185d',
    cardBg: 'rgba(255,255,255,0.6)',
    cardBorder: 'rgba(236,72,153,0.2)',
    particles: { color: '#fbcfe8', count: 30, size: [2, 5], speed: 0.15 },
    liveEffect: 'petals',
  },
  ''';

  String parseColor(String c) {
    if (c.startsWith('#')) {
      c = c.substring(1);
      if (c.length == 3) {
        c = c.split('').map((x) => x + x).join('');
      }
      return 'Color(0xFF\${c.toUpperCase()})';
    } else if (c.startsWith('rgba')) {
      var parts = c.substring(5, c.length - 1).split(',');
      return 'Color.fromRGBO(\${parts[0].trim()}, \${parts[1].trim()}, \${parts[2].trim()}, \${parts[3].trim()})';
    }
    return 'Color(0xFF000000)';
  }

  String parseGradient(String grad) {
    var match = RegExp(r'linear-gradient\\((\\d+)deg,\\s*(.*)\\)').firstMatch(grad);
    if (match == null) return 'null';
    var deg = match.group(1);
    var stopsStr = match.group(2)!;
    var stops = [];
    var colors = [];
    for (var part in stopsStr.split(', ')) {
      var colorAndStop = part.trim().split(' ');
      colors.add(parseColor(colorAndStop[0]));
      stops.add((double.parse(colorAndStop[1].replaceAll('%', '')) / 100.0).toString());
    }
    return '''const LinearGradient(
      colors: [\${colors.join(', ')}],
      stops: [\${stops.join(', ')}],
      transform: GradientRotation(\$deg * math.pi / 180),
    )''';
  }

  String moduleEntries = '';
  var blocks = moduleThemesTs.split('},');
  for (var block in blocks) {
    if (block.trim().isEmpty) continue;
    var modNameMatch = RegExp(r'([a-zA-Z0-9"-]+):\\s*\\{').firstMatch(block);
    if (modNameMatch == null) continue;
    var modName = modNameMatch.group(1)!.replaceAll('"', '');

    var grad = RegExp(r"gradient:\\s*'([^']+)'").firstMatch(block)?.group(1);
    var accCol = RegExp(r"accentColor:\\s*'([^']+)'").firstMatch(block)?.group(1);
    var accLight = RegExp(r"accentLight:\\s*'([^']+)'").firstMatch(block)?.group(1);
    var tp = RegExp(r"textPrimary:\\s*'([^']+)'").firstMatch(block)?.group(1);
    var ts = RegExp(r"textSecondary:\\s*'([^']+)'").firstMatch(block)?.group(1);
    var cb = RegExp(r"cardBg:\\s*'([^']+)'").firstMatch(block)?.group(1);
    var cborder = RegExp(r"cardBorder:\\s*'([^']+)'").firstMatch(block)?.group(1);
    var pc = RegExp(r"particles:\\s*\\{\\s*color:\\s*'([^']+)'").firstMatch(block)?.group(1);
    var pcount = RegExp(r"count:\\s*(\\d+)").firstMatch(block)?.group(1);
    var liveEff = RegExp(r"liveEffect:\\s*'([^']+)'").firstMatch(block)?.group(1);

    if (liveEff == 'none') liveEff = 'LiveEffect.none';
    else liveEff = 'LiveEffect.\$liveEff';

    moduleEntries += '''
    '\$modName': ModuleTheme(
      gradient: \${parseGradient(grad!)},
      accentColor: \${parseColor(accCol!)},
      accentLight: \${parseColor(accLight!)},
      textPrimary: \${parseColor(tp!)},
      textSecondary: \${parseColor(ts!)},
      cardBg: \${parseColor(cb!)},
      cardBorder: \${parseColor(cborder!)},
      particleColor: \${parseColor(pc!)},
      particleCount: \$pcount,
      liveEffect: \$liveEff,
    ),
''';
  }

  String moduleThemesContent = '''
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
$moduleEntries  };

  static ModuleTheme getTheme(String key) {
    return _themes[key] ?? _themes['home']!;
  }
}
''';
  File('lib/core/theme/module_themes.dart').writeAsStringSync(moduleThemesContent);
}
