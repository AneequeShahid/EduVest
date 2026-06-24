import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

import 'app_colors.dart';

/// EduVest typography.
///
/// Display & amount styles use Playfair Display; everything else uses DM Sans.
/// Colors default to the light theme's [AppColors.textPrimary]; the themes
/// re-apply the appropriate color per brightness via [TextTheme].
class AppTextStyles {
  AppTextStyles._();

  static TextStyle displayLarge = GoogleFonts.playfairDisplay(
    fontSize: 32,
    fontWeight: FontWeight.w600,
    color: AppColors.textPrimary,
  );

  static TextStyle displayMedium = GoogleFonts.playfairDisplay(
    fontSize: 24,
    fontWeight: FontWeight.w600,
    color: AppColors.textPrimary,
  );

  static TextStyle headlineLarge = GoogleFonts.dmSans(
    fontSize: 22,
    fontWeight: FontWeight.w600,
    color: AppColors.textPrimary,
  );

  static TextStyle headlineMedium = GoogleFonts.dmSans(
    fontSize: 18,
    fontWeight: FontWeight.w500,
    color: AppColors.textPrimary,
  );

  static TextStyle titleLarge = GoogleFonts.dmSans(
    fontSize: 16,
    fontWeight: FontWeight.w500,
    color: AppColors.textPrimary,
  );

  static TextStyle titleMedium = GoogleFonts.dmSans(
    fontSize: 14,
    fontWeight: FontWeight.w500,
    color: AppColors.textPrimary,
  );

  static TextStyle bodyLarge = GoogleFonts.dmSans(
    fontSize: 16,
    fontWeight: FontWeight.w400,
    color: AppColors.textPrimary,
  );

  static TextStyle bodyMedium = GoogleFonts.dmSans(
    fontSize: 14,
    fontWeight: FontWeight.w400,
    color: AppColors.textSecondary,
  );

  static TextStyle bodySmall = GoogleFonts.dmSans(
    fontSize: 12,
    fontWeight: FontWeight.w400,
    color: AppColors.textSecondary,
  );

  static TextStyle labelLarge = GoogleFonts.dmSans(
    fontSize: 12,
    fontWeight: FontWeight.w600,
    letterSpacing: 0.5,
    color: AppColors.textSecondary,
  );

  static TextStyle amount = GoogleFonts.playfairDisplay(
    fontSize: 36,
    fontWeight: FontWeight.w700,
    color: AppColors.textPrimary,
  );

  static TextStyle amountSmall = GoogleFonts.playfairDisplay(
    fontSize: 24,
    fontWeight: FontWeight.w600,
    color: AppColors.textPrimary,
  );

  /// Builds a Material [TextTheme] from these styles, recoloured for [primary]
  /// (body text) and [heading] (display/headline/title text).
  static TextTheme toTextTheme({
    required Color heading,
    required Color body,
  }) {
    return TextTheme(
      displayLarge: displayLarge.copyWith(color: heading),
      displayMedium: displayMedium.copyWith(color: heading),
      headlineLarge: headlineLarge.copyWith(color: heading),
      headlineMedium: headlineMedium.copyWith(color: heading),
      titleLarge: titleLarge.copyWith(color: heading),
      titleMedium: titleMedium.copyWith(color: heading),
      bodyLarge: bodyLarge.copyWith(color: body),
      bodyMedium: bodyMedium.copyWith(color: body),
      bodySmall: bodySmall.copyWith(color: body),
      labelLarge: labelLarge.copyWith(color: body),
    );
  }
}
