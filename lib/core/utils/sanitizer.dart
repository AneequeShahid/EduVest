/// Input sanitization helpers applied before persisting user-provided text.
///
/// Strips HTML/script markup and trims, then enforces field length caps.
class Sanitizer {
  Sanitizer._();

  static const int maxDescriptionLength = 200;
  static const int maxNameLength = 50;

  static final RegExp _htmlTag = RegExp(r'<[^>]*>');
  static final RegExp _multiSpace = RegExp(r'\s+');

  /// Removes HTML tags, collapses whitespace and trims.
  static String stripHtml(String input) {
    return input
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
}
