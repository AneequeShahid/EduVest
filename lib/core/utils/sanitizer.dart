/// Input sanitization helpers applied before persisting user-provided text.
///
/// Strips HTML/script markup and trims, then enforces field length caps.
class Sanitizer {
  Sanitizer._();

  static const int maxDescriptionLength = 200;
  static const int maxNameLength = 50;
  static const int maxCategoryLength = 30;

  static final RegExp _htmlTag = RegExp(r'<[^>]*>');
  static final RegExp _multiSpace = RegExp(r'\s+');
  static final RegExp _scriptTag =
      RegExp(r'<script[^>]*>[\s\S]*?</script>', caseSensitive: false);

  /// Removes HTML/script tags, collapses whitespace and trims.
  static String stripHtml(String input) {
    return input
        .replaceAll(_scriptTag, '')
        .replaceAll(_htmlTag, '')
        .replaceAll(_multiSpace, ' ')
        .trim();
  }

  /// Sanitizes [input] and clamps to [maxLength] characters.
  static String clean(String input, int maxLength) {
    final stripped = stripHtml(input);
    return stripped.length > maxLength
        ? stripped.substring(0, maxLength)
        : stripped;
  }

  /// Sanitized description (max 200 chars).
  static String description(String input) =>
      clean(input, maxDescriptionLength);

  /// Sanitized name (max 50 chars).
  static String name(String input) => clean(input, maxNameLength);

  /// Sanitized category label (max 30 chars).
  static String category(String input) => clean(input, maxCategoryLength);

  /// Sanitizes an amount string: strips non-numeric chars except `.` and `-`.
  ///
  /// Returns `null` if the result cannot be parsed to a valid number.
  static double? amount(String input) {
    final cleaned = input.replaceAll(RegExp(r'[^\d.\-]'), '').trim();
    return double.tryParse(cleaned);
  }
}
