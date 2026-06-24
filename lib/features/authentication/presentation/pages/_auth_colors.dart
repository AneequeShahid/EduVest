import 'package:flutter/material.dart';

/// Design tokens for auth screens (Figma spec: warm cream + terracotta).
abstract final class AuthColors {
  static const Color background = Color(0xFFFAF7F2);
  static const Color surface = Color(0xFFFFFFFF);
  static const Color primary = Color(0xFFC1622A);
  static const Color primaryLight = Color(0xFFD4713A);
  static const Color primaryDark = Color(0xFF9E4D20);

  static const Color textDark = Color(0xFF1A1612);
  static const Color textMedium = Color(0xFF4A3F35);
  static const Color textMuted = Color(0xFF8A7D72);
  static const Color border = Color(0xFFE8E0D8);
  static const Color inputFill = Color(0xFFF5F0EA);

  static const Color error = Color(0xFFD0312D);
  static const Color success = Color(0xFF2E7D32);
  static const Color successSurface = Color(0xFFEAF6EB);
}
