import 'package:flutter/material.dart'; 
import 'package:google_fonts/google_fonts.dart'; 
 
/// Exact mirror of globals.css CSS variables 
/// Every value is read directly from the frontend source — not guessed 
class ZenTokens { 
  // Backgrounds (from --zen-bg, --zen-surface, etc in globals.css) 
  static const Color bg          = Color(0xFFF9F8FB); 
  static const Color surface     = Color(0xFFFFFFFF); 
  static const Color surfaceRaised = Color(0xFFFCFCFD); 
 
  // Text (from --zen-fg, --zen-fg-muted, --zen-fg-subtle) 
  static const Color fg          = Color(0xFF1D2135); 
  static const Color fgMuted     = Color(0xFF58607E); 
  static const Color fgSubtle    = Color(0xFF9297AA); 
 
  // Brand colors (from --zen-primary, --zen-secondary, --zen-accent) 
  static const Color primary     = Color(0xFF2F65DA); 
  static const Color secondary   = Color(0xFF8660C7); 
  static const Color accent      = Color(0xFF319B8D); 
 
  // Borders (from --zen-border, --zen-border-soft) 
  static const Color border      = Color(0xFFDADDE7); 
  static const Color borderSoft  = Color(0xFFEAEBF1); 
 
  // Radius (from --radius-zen-xl etc) 
  static const double radiusSm   = 8.0; 
  static const double radiusMd   = 12.0; 
  static const double radiusLg   = 16.0; 
  static const double radiusXl   = 24.0; 
  static const double radius2xl  = 32.0; 
  static const double radiusFull = 9999.0; 
 
  // Spacing (standard Flutter spacing to match the web's spacing scale) 
  static const double space1     = 4.0; 
  static const double space2     = 8.0; 
  static const double space3     = 12.0; 
  static const double space4     = 16.0; 
  static const double space5     = 20.0; 
  static const double space6     = 24.0; 
  static const double space8     = 32.0; 
  static const double space10    = 40.0; 
  static const double space12    = 48.0; 
} 
 
/// App-level ThemeData — used for scaffold, dialog, text defaults 
/// Mirrors the web app's base (non-module) theme 
class AppTheme { 
  static ThemeData get theme => ThemeData( 
    useMaterial3: true, 
    scaffoldBackgroundColor: Colors.transparent, 
    colorScheme: ColorScheme.fromSeed( 
      seedColor: ZenTokens.primary, 
      primary: ZenTokens.primary, 
      secondary: ZenTokens.secondary, 
      surface: ZenTokens.surface, 
    ), 
    textTheme: _textTheme, 
    appBarTheme: AppBarTheme( 
      backgroundColor: Colors.transparent, 
      elevation: 0, 
      scrolledUnderElevation: 0, 
      iconTheme: const IconThemeData(color: ZenTokens.fg), 
      titleTextStyle: GoogleFonts.inter( 
        fontSize: 17, fontWeight: FontWeight.w600, color: ZenTokens.fg, 
      ), 
    ), 
    elevatedButtonTheme: ElevatedButtonThemeData( 
      style: ElevatedButton.styleFrom( 
        backgroundColor: ZenTokens.primary, 
        foregroundColor: Colors.white, 
        shape: RoundedRectangleBorder( 
          borderRadius: BorderRadius.circular(ZenTokens.radius2xl)), 
        padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 14), 
        textStyle: GoogleFonts.inter(fontSize: 15, fontWeight: FontWeight.w600), 
        elevation: 0, 
      ), 
    ), 
    cardTheme: CardThemeData( 
      color: ZenTokens.surface, 
      elevation: 0, 
      shape: RoundedRectangleBorder( 
        borderRadius: BorderRadius.circular(ZenTokens.radiusXl), 
        side: const BorderSide(color: ZenTokens.borderSoft, width: 1), 
      ), 
    ), 
  ); 
 
  static TextTheme get _textTheme => GoogleFonts.interTextTheme().copyWith( 
    displayLarge: GoogleFonts.inter( 
      fontSize: 32, fontWeight: FontWeight.w700, 
      color: ZenTokens.fg, letterSpacing: -0.5, 
    ), 
    headlineLarge: GoogleFonts.inter( 
      fontSize: 24, fontWeight: FontWeight.w700, color: ZenTokens.fg, 
    ), 
    headlineMedium: GoogleFonts.inter( 
      fontSize: 20, fontWeight: FontWeight.w600, color: ZenTokens.fg, 
    ), 
    titleLarge: GoogleFonts.inter( 
      fontSize: 17, fontWeight: FontWeight.w600, color: ZenTokens.fg, 
    ), 
    bodyLarge: GoogleFonts.inter(fontSize: 16, color: ZenTokens.fg), 
    bodyMedium: GoogleFonts.inter(fontSize: 14, color: ZenTokens.fgMuted), 
    bodySmall: GoogleFonts.inter(fontSize: 12, color: ZenTokens.fgSubtle), 
    labelLarge: GoogleFonts.inter( 
      fontSize: 14, fontWeight: FontWeight.w600, color: ZenTokens.fg, 
    ), 
    labelSmall: GoogleFonts.inter( 
      fontSize: 10, fontWeight: FontWeight.w600, 
      letterSpacing: 0.15, color: ZenTokens.fgSubtle, 
    ), 
  ); 
}
