import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

import 'app_colors.dart';

/// Typography — Lora (display) + Plus Jakarta Sans (UI).
///
/// Styles respect ambient [TextScaler] via Theme / DefaultTextStyle.
abstract final class AppTextStyles {
  static TextStyle get display => GoogleFonts.lora(
        fontSize: 36,
        fontWeight: FontWeight.w600,
        height: 1.15,
        letterSpacing: -0.5,
        color: AppColors.textPrimary,
      );

  static TextStyle get headline => GoogleFonts.lora(
        fontSize: 28,
        fontWeight: FontWeight.w600,
        height: 1.2,
        letterSpacing: -0.3,
        color: AppColors.textPrimary,
      );

  static TextStyle get title => GoogleFonts.plusJakartaSans(
        fontSize: 20,
        fontWeight: FontWeight.w600,
        height: 1.3,
        color: AppColors.textPrimary,
      );

  static TextStyle get subtitle => GoogleFonts.plusJakartaSans(
        fontSize: 17,
        fontWeight: FontWeight.w500,
        height: 1.35,
        color: AppColors.textPrimary,
      );

  static TextStyle get body => GoogleFonts.plusJakartaSans(
        fontSize: 16,
        fontWeight: FontWeight.w400,
        height: 1.5,
        color: AppColors.textPrimary,
      );

  static TextStyle get bodyMedium => GoogleFonts.plusJakartaSans(
        fontSize: 15,
        fontWeight: FontWeight.w500,
        height: 1.45,
        color: AppColors.textPrimary,
      );

  static TextStyle get bodySmall => GoogleFonts.plusJakartaSans(
        fontSize: 14,
        fontWeight: FontWeight.w400,
        height: 1.45,
        color: AppColors.textSecondary,
      );

  static TextStyle get label => GoogleFonts.plusJakartaSans(
        fontSize: 13,
        fontWeight: FontWeight.w600,
        height: 1.3,
        letterSpacing: 0.2,
        color: AppColors.textPrimary,
      );

  static TextStyle get caption => GoogleFonts.plusJakartaSans(
        fontSize: 12,
        fontWeight: FontWeight.w400,
        height: 1.35,
        color: AppColors.textMuted,
      );

  static TextStyle get button => GoogleFonts.plusJakartaSans(
        fontSize: 15,
        fontWeight: FontWeight.w600,
        height: 1.2,
        letterSpacing: 0.1,
        color: AppColors.textInverse,
      );
}
