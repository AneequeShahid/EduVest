import 'package:eduvest_output/core/utils/validators.dart';
import 'package:flutter_test/flutter_test.dart';

void main() {
  group('validateEmail', () {
    test('1. returns null for a valid email', () {
      expect(validateEmail('student@university.edu'), isNull);
    });

    test('2. returns error when "@" is missing', () {
      expect(validateEmail('studentuniversity.edu'), isNotNull);
    });
  });

  group('validatePassword', () {
    test('3. returns null for a valid password', () {
      expect(validatePassword('pass1234'), isNull);
    });

    test('4. returns error for < 8 characters', () {
      expect(validatePassword('pas1'), isNotNull);
    });

    test('5. returns error when no number present', () {
      expect(validatePassword('password'), isNotNull);
    });
  });

  group('validateAmount', () {
    test('6. returns null for a positive number', () {
      expect(validateAmount('25.50'), isNull);
    });

    test('7. returns error for 0 or negative', () {
      expect(validateAmount('0'), isNotNull);
      expect(validateAmount('-5'), isNotNull);
    });
  });

  group('extras', () {
    test('validateConfirmPassword matches/ mismatches', () {
      expect(validateConfirmPassword('pass1234', 'pass1234'), isNull);
      expect(validateConfirmPassword('pass1234', 'nope'), isNotNull);
    });

    test('validateRequired flags empty', () {
      expect(validateRequired('Alex', 'Name'), isNull);
      expect(validateRequired('   ', 'Name'), isNotNull);
    });
  });
}
