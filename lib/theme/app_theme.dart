import 'package:flutter/material.dart';

class AppColors {

  static const Color background = Color(0xFFF5F0EB);
  static const Color darkBackground = Color(0xFF1A1612);
  static const Color cardBackground = Color(0xFFFFFFFF);
  static const Color cardBeige = Color(0xFFFAF6F1);


  static const Color primary = Color(0xFFB85C2A);
  static const Color primaryLight = Color(0xFFD4713A);
  static const Color primaryDark = Color(0xFF8B4220);

  static const Color textDark = Color(0xFF1A1612);
  static const Color textMedium = Color(0xFF4A3F35);
  static const Color textLight = Color(0xFF8A7D72);
  static const Color textMuted = Color(0xFFAA9D94);


  static const Color success = Color(0xFF4CAF6A);
  static const Color warning = Color(0xFFE8A44A);
  static const Color danger = Color(0xFFD45B5B);


  static const Color border = Color(0xFFE8E0D8);
  static const Color borderLight = Color(0xFFF0EBE4);

  static const Color navBackground = Color(0xFFFFFFFF);


  static const Color darkSurface = Color(0xFF2A2420);
  static const Color darkCard = Color(0xFF332E29);
}

class AppTextStyles {
  static const String fontFamily = 'Georgia';
  static const String sansFamily = 'SF Pro Display';

  static const TextStyle displayLarge = TextStyle(
    fontSize: 32,
    fontWeight: FontWeight.w300,
    color: AppColors.textDark,
    letterSpacing: -0.5,
    fontFamily: 'Georgia',
  );

  static const TextStyle displayMedium = TextStyle(
    fontSize: 26,
    fontWeight: FontWeight.w400,
    color: AppColors.textDark,
    letterSpacing: -0.3,
    fontFamily: 'Georgia',
  );

  static const TextStyle headlineLarge = TextStyle(
    fontSize: 22,
    fontWeight: FontWeight.w600,
    color: AppColors.textDark,
    letterSpacing: -0.2,
  );

  static const TextStyle headlineMedium = TextStyle(
    fontSize: 18,
    fontWeight: FontWeight.w600,
    color: AppColors.textDark,
  );

  static const TextStyle bodyLarge = TextStyle(
    fontSize: 16,
    fontWeight: FontWeight.w400,
    color: AppColors.textMedium,
  );

  static const TextStyle bodyMedium = TextStyle(
    fontSize: 14,
    fontWeight: FontWeight.w400,
    color: AppColors.textMedium,
  );

  static const TextStyle labelSmall = TextStyle(
    fontSize: 11,
    fontWeight: FontWeight.w500,
    color: AppColors.textLight,
    letterSpacing: 0.8,
  );
}

class AppTheme {
  static ThemeData get lightTheme {
    return ThemeData(
      useMaterial3: true,
      scaffoldBackgroundColor: AppColors.background,
      colorScheme: const ColorScheme.light(
        primary: AppColors.primary,
        surface: AppColors.cardBackground,
        onPrimary: Colors.white,
        onSurface: AppColors.textDark,
      ),
      fontFamily: 'Georgia',
      appBarTheme: const AppBarTheme(
        backgroundColor: AppColors.background,
        elevation: 0,
        centerTitle: true,
        titleTextStyle: TextStyle(
          fontSize: 18,
          fontWeight: FontWeight.w600,
          color: AppColors.primary,
          fontFamily: 'Georgia',
        ),
        iconTheme: IconThemeData(color: AppColors.textDark),
      ),
      cardTheme: const CardThemeData(
        color: AppColors.cardBackground,
        elevation: 0,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.all(Radius.circular(16)),
        ),
      ),
      elevatedButtonTheme: ElevatedButtonThemeData(
        style: ElevatedButton.styleFrom(
          backgroundColor: AppColors.primary,
          foregroundColor: Colors.white,
          elevation: 0,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(14),
          ),
          padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 16),
          textStyle: const TextStyle(
            fontSize: 16,
            fontWeight: FontWeight.w600,
          ),
        ),
      ),
      bottomNavigationBarTheme: const BottomNavigationBarThemeData(
        backgroundColor: AppColors.navBackground,
        selectedItemColor: AppColors.primary,
        unselectedItemColor: AppColors.textMuted,
        type: BottomNavigationBarType.fixed,
        elevation: 0,
        selectedLabelStyle: TextStyle(
          fontSize: 10,
          fontWeight: FontWeight.w500,
        ),
        unselectedLabelStyle: TextStyle(
          fontSize: 10,
          fontWeight: FontWeight.w400,
        ),
      ),
    );
  }
}
