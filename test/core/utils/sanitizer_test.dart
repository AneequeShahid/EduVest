import 'package:eduvest_output/core/utils/sanitizer.dart';
import 'package:flutter_test/flutter_test.dart';

void main() {
  group('Sanitizer.stripHtml', () {
    test('1. removes HTML tags', () {
      expect(Sanitizer.stripHtml('<b>Hello</b>'), 'Hello');
      expect(Sanitizer.stripHtml('<script>alert(1)</script>coffee'),
          'alert(1)coffee');
    });

    test('2. collapses whitespace and trims', () {
      expect(Sanitizer.stripHtml('  a   b\tc\n '), 'a b c');
    });

    test('3. leaves plain text unchanged', () {
      expect(Sanitizer.stripHtml('Groceries'), 'Groceries');
    });

    test('4. handles empty string', () {
      expect(Sanitizer.stripHtml(''), '');
    });
  });

  group('Sanitizer.clean', () {
    test('5. clamps to the max length', () {
      final long = 'a' * 300;
      expect(Sanitizer.clean(long, 10).length, 10);
    });

    test('6. does not clamp short input', () {
      expect(Sanitizer.clean('short', 100), 'short');
    });
  });

  group('Sanitizer.description', () {
    test('7. enforces 200-char cap', () {
      final input = 'x' * 250;
      expect(Sanitizer.description(input).length, 200);
      expect(Sanitizer.maxDescriptionLength, 200);
    });

    test('8. strips HTML from description', () {
      expect(Sanitizer.description('<i>note</i>'), 'note');
    });
  });

  group('Sanitizer.name', () {
    test('9. enforces 50-char cap', () {
      final input = 'n' * 80;
      expect(Sanitizer.name(input).length, 50);
      expect(Sanitizer.maxNameLength, 50);
    });

    test('10. strips HTML and trims a name', () {
      expect(Sanitizer.name('  <b>Jane  Doe</b> '), 'Jane Doe');
    });
  });
}
