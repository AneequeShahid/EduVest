import 'package:eduvest_output/core/utils/currency_utils.dart';
import 'package:flutter_test/flutter_test.dart';

void main() {
  group('formatCurrency', () {
    test("1. formatCurrency(1234.56) → '\$1,234.56'", () {
      expect(formatCurrency(1234.56), r'$1,234.56');
    });

    test("2. formatCurrency(0) → '\$0.00'", () {
      expect(formatCurrency(0), r'$0.00');
    });
  });

  group('formatCompact', () {
    test("3. formatCompact(1200) → '\$1.2K'", () {
      expect(formatCompact(1200), r'$1.2K');
    });

    test('handles millions and sub-thousand fallback', () {
      expect(formatCompact(1500000), r'$1.5M');
      expect(formatCompact(999), r'$999.00');
    });
  });
}
