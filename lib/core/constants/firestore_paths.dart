/// Centralized Firestore collection and well-known document identifiers.
///
/// Every data source must reference these instead of inline string literals so
/// the schema has a single source of truth.
class FirestorePaths {
  FirestorePaths._();

  // ── Collections ────────────────────────────────────────────────────────────
  static const String users = 'users';
  static const String expenses = 'expenses';
  static const String income = 'income';
  static const String budget = 'budget';
  static const String categories = 'categories';
  static const String goals = 'goals';
  static const String contributions = 'contributions';
  static const String settings = 'settings';

  // ── Well-known document ids ──────────────────────────────────────────────────
  /// Legacy single-doc budget at `users/{uid}/budget/current`.
  static const String currentBudgetDoc = 'current';

  /// User preferences at `users/{uid}/settings/prefs`.
  static const String settingsPrefsDoc = 'prefs';
}
