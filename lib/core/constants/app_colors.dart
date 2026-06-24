import 'package:flutter/material.dart';

/// EduVest color system.
///
/// The canonical tokens below ("Sahara Light" / "Midnight Sands") are the
/// source of truth. Legacy aliases are kept at the bottom so earlier feature
/// code keeps compiling; new code should prefer the canonical names.
class AppColors {
  AppColors._();

  // ── Light theme — Sahara Light ────────────────────────────────────────────
  static const Color primary = Color(0xFFC1622A);
  static const Color primaryLight = Color(0xFFE8957A);
  static const Color background = Color(0xFFFAF7F2);
  static const Color surface = Color(0xFFFFFFFF);
  static const Color surfaceSecondary = Color(0xFFF2EDE5);
  static const Color textPrimary = Color(0xFF1A1208);
  static const Color textSecondary = Color(0xFF6B5B4E);
  static const Color textTertiary = Color(0xFFB8A990);
  static const Color success = Color(0xFF2E7D32);
  static const Color error = Color(0xFFB71C1C);
  static const Color warning = Color(0xFFF57F17);
  static const Color divider = Color(0xFFE8E0D5);
  static const Color income = Color(0xFF2E7D32);
  static const Color expense = Color(0xFFB71C1C);

  // ── Dark theme — Midnight Sands ───────────────────────────────────────────
  static const Color primaryDark = Color(0xFFC1622A);
  static const Color backgroundDark = Color(0xFF1A1208);
  static const Color surfaceDark = Color(0xFF261A0A);
  static const Color surfaceSecondaryDark = Color(0xFF342210);
  static const Color textPrimaryDark = Color(0xFFF5EDE0);
  static const Color textSecondaryDark = Color(0xFFB8A990);

  // ── Legacy aliases (kept for backward compatibility) ──────────────────────
  // Older feature code references these names; they map to the canonical
  // tokens above. Prefer the canonical names in new code.
  static const Color cardBackground = surface;
  static const Color cardBeige = surfaceSecondary;
  static const Color surfaceVariant = surfaceSecondary;
  static const Color navBackground = surface;

  static const Color textDark = textPrimary;
  static const Color textMedium = textSecondary;
  static const Color textLight = textTertiary;
  static const Color textMuted = textTertiary;
  static const Color textHint = textTertiary;

  static const Color danger = error;
  static const Color info = Color(0xFF3B82F6);
  static const Color secondary = success;
  static const Color secondaryLight = Color(0xFF6DC98A);

  static const Color border = divider;
  static const Color borderLight = divider;

  static const Color darkBackground = backgroundDark;
  static const Color darkSurface = surfaceDark;
  static const Color darkCard = surfaceSecondaryDark;
  static const Color darkSurfaceVariant = surfaceSecondaryDark;
  static const Color darkTextPrimary = textPrimaryDark;
  static const Color darkTextSecondary = textSecondaryDark;
}
