import 'package:intl/intl.dart';

final NumberFormat _currencyFormat =
    NumberFormat.currency(locale: 'en_US', symbol: '\$', decimalDigits: 2);

/// `1234.56 → "$1,234.56"`, `0 → "$0.00"`.
String formatCurrency(double amount) => _currencyFormat.format(amount);

/// Format [amount] with a custom [symbol] and [locale].
///
/// Common examples:
/// ```dart
/// formatWithSymbol(1500, symbol: 'Rs', locale: 'en_PK') // "Rs1,500.00"
/// formatWithSymbol(1500, symbol: '£', locale: 'en_GB')  // "£1,500.00"
/// ```
String formatWithSymbol(
  double amount, {
  String symbol = '\$',
  String locale = 'en_US',
  int decimalDigits = 2,
}) {
  return NumberFormat.currency(
    locale: locale,
    symbol: symbol,
    decimalDigits: decimalDigits,
  ).format(amount);
}

/// Compact form: `1200 → "$1.2K"`, `1500000 → "$1.5M"`.
/// Values below 1,000 fall back to full currency formatting.
String formatCompact(double amount) {
  final abs = amount.abs();
  final sign = amount < 0 ? '-' : '';
  if (abs >= 1000000) {
    return '$sign\$${_trim(abs / 1000000)}M';
  }
  if (abs >= 1000) {
    return '$sign\$${_trim(abs / 1000)}K';
  }
  return formatCurrency(amount);
}

/// Formats a percentage value: `0.753 → "75.3%"`, `1.0 → "100%"`.
///
/// Pass [decimals] to control precision (default 1).
String formatPercentage(double fraction, {int decimals = 1}) {
  final percent = (fraction * 100).clamp(0.0, 100.0);
  if (decimals == 0) return '${percent.round()}%';
  return '${percent.toStringAsFixed(decimals)}%';
}

/// Formats a change value with a leading + / − sign: `+12.5%` or `-3.2%`.
String formatChangePercent(double fraction, {int decimals = 1}) {
  final percent = fraction * 100;
  final sign = percent >= 0 ? '+' : '';
  return '$sign${percent.toStringAsFixed(decimals)}%';
}

String _trim(double v) {
  // One decimal place, dropping a trailing ".0" (e.g. 1.0 → "1", 1.2 → "1.2").
  final s = v.toStringAsFixed(1);
  return s.endsWith('.0') ? s.substring(0, s.length - 2) : s;
}

/// Legacy helper retained for backward compatibility.
class CurrencyUtils {
  CurrencyUtils._();

  static String format(double amount, {String symbol = '\$'}) =>
      symbol == '\$'
          ? formatCurrency(amount)
          : NumberFormat.currency(symbol: symbol, decimalDigits: 2)
              .format(amount);

  static String formatCompact(double amount) => _formatCompact(amount);

  static double parse(String value) =>
      double.tryParse(value.replaceAll(RegExp(r'[^\d.-]'), '')) ?? 0.0;

  static String percentage(double fraction, {int decimals = 1}) =>
      formatPercentage(fraction, decimals: decimals);

  static String changePercent(double fraction, {int decimals = 1}) =>
      formatChangePercent(fraction, decimals: decimals);
}

// Alias so the static wrapper can reach the top-level function unambiguously.
String _formatCompact(double amount) => formatCompact(amount);
