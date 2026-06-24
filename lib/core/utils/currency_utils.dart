import 'package:intl/intl.dart';

final NumberFormat _currencyFormat =
    NumberFormat.currency(locale: 'en_US', symbol: '\$', decimalDigits: 2);

/// `1234.56 → "$1,234.56"`, `0 → "$0.00"`.
String formatCurrency(double amount) => _currencyFormat.format(amount);

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
}

// Alias so the static wrapper can reach the top-level function unambiguously.
String _formatCompact(double amount) => formatCompact(amount);
