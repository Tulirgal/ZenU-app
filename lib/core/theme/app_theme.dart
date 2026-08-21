import 'package:flutter/material.dart'; 
import 'package:google_fonts/google_fonts.dart'; 
 
/// Base app theme — used for elements outside ModuleBackground 
/// (navigation, dialogs, global scaffolds) 
class AppTheme { 
  // Global semantic colors (same as web app's globals.css zen-* variables) 
  static const zenFg        = Color(0xFF1E293B);  // Deep navy — always readable 
  static const zenFgMuted   = Color(0xFF64748B); 
  static const zenSurface   = Color(0xFFF8F9FF); 
  static const zenPrimary   = Color(0xFFA78BFA); 
  static const zenSecondary = Color(0xFF818CF8); 
  static const zenBorder    = Color(0xFFE2E8F0); 
 
  static ThemeData get theme => ThemeData( 
    useMaterial3: true, 
    brightness: Brightness.light, 
    scaffoldBackgroundColor: Colors.transparent, 
    colorScheme: ColorScheme.fromSeed( 
      seedColor: zenPrimary, 
      primary: zenPrimary, 
      secondary: zenSecondary, 
    ), 
    textTheme: GoogleFonts.interTextTheme().copyWith( 
      displayLarge: GoogleFonts.inter( 
        fontSize: 28, fontWeight: FontWeight.w700, 
        color: zenFg, letterSpacing: -0.5, 
      ), 
      headlineMedium: GoogleFonts.inter( 
        fontSize: 20, fontWeight: FontWeight.w600, color: zenFg, 
      ), 
      bodyLarge: GoogleFonts.inter(fontSize: 16, color: zenFg), 
      bodyMedium: GoogleFonts.inter(fontSize: 14, color: zenFgMuted), 
      labelLarge: GoogleFonts.inter( 
        fontSize: 15, fontWeight: FontWeight.w600, color: zenFg, 
      ), 
    ), 
    appBarTheme: AppBarTheme( 
      backgroundColor: Colors.white.withValues(alpha: 0.8), 
      elevation: 0, 
      scrolledUnderElevation: 0, 
      titleTextStyle: GoogleFonts.inter( 
        fontSize: 17, fontWeight: FontWeight.w600, color: zenFg, 
      ), 
      iconTheme: const IconThemeData(color: zenFg), 
    ), 
    elevatedButtonTheme: ElevatedButtonThemeData( 
      style: ElevatedButton.styleFrom( 
        backgroundColor: zenPrimary, 
        foregroundColor: Colors.white, 
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(999)), 
        padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 14), 
        textStyle: GoogleFonts.inter(fontSize: 15, fontWeight: FontWeight.w600), 
        elevation: 0, 
      ), 
    ), 
    inputDecorationTheme: InputDecorationTheme( 
      filled: true, 
      fillColor: zenSurface, 
      border: OutlineInputBorder( 
        borderRadius: BorderRadius.circular(12), 
        borderSide: const BorderSide(color: zenBorder), 
      ), 
      enabledBorder: OutlineInputBorder( 
        borderRadius: BorderRadius.circular(12), 
        borderSide: const BorderSide(color: zenBorder), 
      ), 
      focusedBorder: OutlineInputBorder( 
        borderRadius: BorderRadius.circular(12), 
        borderSide: const BorderSide(color: zenPrimary, width: 2), 
      ), 
    ), 
  ); 
}
