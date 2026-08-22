import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

// AUTO-GENERATED from globals.css
class ZenTokens {
  static const Color zenBg = Color(0xFFF9F8FB); // from --zen-bg
  static const Color zenBgSubtle = Color(0xFFF3F3F7); // from --zen-bg-subtle
  static const Color zenBgMuted = Color(0xFFEEEDF2); // from --zen-bg-muted
  static const Color zenSurface = Color(0xFFFFFFFF); // from --zen-surface
  static const Color zenSurfaceRaised = Color(0xFFFCFCFD); // from --zen-surface-raised
  static const Color zenSurfaceElevated = Color(0xFFFFFFFF); // from --zen-surface-elevated
  static const Color zenEmotionSadness = Color(0xFF4994DF); // from --zen-emotion-sadness
  static const Color zenEmotionSadnessSoft = Color(0xFFEEF5FC); // from --zen-emotion-sadness-soft
  static const Color zenEmotionOkay = Color(0xFF389F91); // from --zen-emotion-okay
  static const Color zenEmotionOkaySoft = Color(0xFFECF8F7); // from --zen-emotion-okay-soft
  static const Color zenEmotionCalm = Color(0xFF8660C7); // from --zen-emotion-calm
  static const Color zenEmotionCalmSoft = Color(0xFFF3EFFA); // from --zen-emotion-calm-soft
  static const Color zenEmotionJoy = Color(0xFFF6B623); // from --zen-emotion-joy
  static const Color zenEmotionJoySoft = Color(0xFFFEF9EB); // from --zen-emotion-joy-soft
  static const Color zenEmotionGreat = Color(0xFFE45870); // from --zen-emotion-great
  static const Color zenEmotionGreatSoft = Color(0xFFFCEDF0); // from --zen-emotion-great-soft
  static const Color zenEmotionSurprise = Color(0xFFF48134); // from --zen-emotion-surprise
  static const Color zenEmotionSurpriseSoft = Color(0xFFFEF3EC); // from --zen-emotion-surprise-soft
  static const Color zenEmotionAnger = Color(0xFFE64F37); // from --zen-emotion-anger
  static const Color zenEmotionAngerSoft = Color(0xFFFDEFED); // from --zen-emotion-anger-soft
  static const Color zenEmotionFear = Color(0xFF9559C0); // from --zen-emotion-fear
  static const Color zenEmotionFearSoft = Color(0xFFF6F0F9); // from --zen-emotion-fear-soft
  static const Color zenEmotionDisgust = Color(0xFF409660); // from --zen-emotion-disgust
  static const Color zenEmotionDisgustSoft = Color(0xFFEDF7F1); // from --zen-emotion-disgust-soft
  static const Color zenFg = Color(0xFF1D2135); // from --zen-fg
  static const Color zenFgMuted = Color(0xFF58607E); // from --zen-fg-muted
  static const Color zenFgSubtle = Color(0xFF9297AA); // from --zen-fg-subtle
  static const Color zenFgInverse = Color(0xFFFFFFFF); // from --zen-fg-inverse
  static const Color zenPrimary = Color(0xFF2F65DA); // from --zen-primary
  static const Color zenPrimaryHover = Color(0xFF2357C7); // from --zen-primary-hover
  static const Color zenPrimarySoft = Color(0xFFEDF2FC); // from --zen-primary-soft
  static const Color zenPrimaryFg = Color(0xFFFFFFFF); // from --zen-primary-fg
  static const Color zenSecondary = Color(0xFF8660C7); // from --zen-secondary
  static const Color zenSecondarySoft = Color(0xFFF3EFFA); // from --zen-secondary-soft
  static const Color zenSecondaryFg = Color(0xFFFFFFFF); // from --zen-secondary-fg
  static const Color zenAccent = Color(0xFF319B8D); // from --zen-accent
  static const Color zenAccentSoft = Color(0xFFEBF9F7); // from --zen-accent-soft
  static const Color zenAccentFg = Color(0xFFFFFFFF); // from --zen-accent-fg
  static const Color zenJoy = Color(0xFFF6AF23); // from --zen-joy
  static const Color zenJoySoft = Color(0xFFFEF8EB); // from --zen-joy-soft
  static const Color zenBorder = Color(0xFFDADDE7); // from --zen-border
  static const Color zenBorderSoft = Color(0xFFEAEBF1); // from --zen-border-soft
  static const Color zenBorderFocus = Color(0xFF2F65DA); // from --zen-border-focus
  static const Color zenSuccess = Color(0xFF259D51); // from --zen-success
  static const Color zenSuccessSoft = Color(0xFFEAFAF0); // from --zen-success-soft
  static const Color zenWarning = Color(0xFFF0960F); // from --zen-warning
  static const Color zenWarningSoft = Color(0xFFFEF7EC); // from --zen-warning-soft
  static const Color zenDestructive = Color(0xFFE52E2E); // from --zen-destructive
  static const Color zenDestructiveSoft = Color(0xFFFDEDED); // from --zen-destructive-soft

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
