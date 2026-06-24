import 'package:intl/intl.dart';

/// `DateTime(2024, 3, 12) → "Mar 12, 2024"`.
String formatDate(DateTime date) => DateFormat('MMM d, yyyy').format(date);

/// Relative short form: `"Today"`, `"Yesterday"`, otherwise `"Mar 12"`
/// (year included only when it differs from the current year).
String formatDateShort(DateTime date) {
  final now = DateTime.now();
  final today = DateTime(now.year, now.month, now.day);
  final target = DateTime(date.year, date.month, date.day);
  final diff = today.difference(target).inDays;

  if (diff == 0) return 'Today';
  if (diff == 1) return 'Yesterday';
  if (date.year == now.year) return DateFormat('MMM d').format(date);
  return DateFormat('MMM d, yyyy').format(date);
}

/// Human-readable "time ago" string.
///
/// Examples:
/// - `"just now"` (< 1 min)
/// - `"5 minutes ago"` (< 1 hour)
/// - `"2 hours ago"` (< 24 hours)
/// - `"Yesterday"` (1 day ago)
/// - `"3 days ago"` (< 7 days)
/// - Falls back to [formatDateShort] for anything older.
String timeAgo(DateTime date) {
  final now = DateTime.now();
  final diff = now.difference(date);

  if (diff.inSeconds < 60) return 'just now';
  if (diff.inMinutes < 60) {
    final m = diff.inMinutes;
    return '$m ${m == 1 ? "minute" : "minutes"} ago';
  }
  if (diff.inHours < 24) {
    final h = diff.inHours;
    return '$h ${h == 1 ? "hour" : "hours"} ago';
  }
  if (diff.inDays == 1) return 'Yesterday';
  if (diff.inDays < 7) {
    final d = diff.inDays;
    return '$d ${d == 1 ? "day" : "days"} ago';
  }
  return formatDateShort(date);
}

/// `3 → "March"`. Accepts 1–12.
String getMonthName(int month) {
  const names = [
    'January', 'February', 'March', 'April', 'May', 'June',
    'July', 'August', 'September', 'October', 'November', 'December',
  ];
  if (month < 1 || month > 12) return '';
  return names[month - 1];
}

/// Legacy helper retained for backward compatibility.
class AppDateUtils {
  AppDateUtils._();

  static String formatDate(DateTime date) =>
      DateFormat('MM/dd/yyyy').format(date);

  static String formatMonthYear(DateTime date) =>
      '${getMonthName(date.month)} ${date.year}';

  static String formatMonth(DateTime date) => DateFormat('MMM').format(date);

  static String toMonthKey(DateTime date) =>
      '${date.year}-${date.month.toString().padLeft(2, '0')}';

  static bool isSameMonth(DateTime a, DateTime b) =>
      a.year == b.year && a.month == b.month;

  /// Convenience wrapper for [timeAgo].
  static String timeAgo(DateTime date) => _timeAgo(date);
}

// Alias so the static wrapper can reach the top-level function unambiguously.
String _timeAgo(DateTime date) => timeAgo(date);
