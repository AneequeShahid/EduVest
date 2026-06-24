// Form validators. Each returns `null` when valid, or an error message.

final RegExp _emailRegExp =
    RegExp(r'^[a-zA-Z0-9._%+-]+@[a-zA-Z0-9.-]+\.[a-zA-Z]{2,}$');

String? validateEmail(String? value) {
  if (value == null || value.trim().isEmpty) return 'Email is required';
  if (!_emailRegExp.hasMatch(value.trim())) {
    return 'Enter a valid email address';
  }
  return null;
}

String? validatePassword(String? value) {
  if (value == null || value.isEmpty) return 'Password is required';
  if (value.length < 8) return 'Password must be at least 8 characters';
  if (!value.contains(RegExp(r'[0-9]'))) {
    return 'Password must contain at least one number';
  }
  return null;
}

String? validateConfirmPassword(String? value, String? original) {
  if (value == null || value.isEmpty) return 'Please confirm your password';
  if (value != original) return 'Passwords do not match';
  return null;
}

String? validateRequired(String? value, String fieldName) {
  if (value == null || value.trim().isEmpty) return '$fieldName is required';
  return null;
}

String? validateAmount(String? value) {
  if (value == null || value.trim().isEmpty) return 'Amount is required';
  final parsed = double.tryParse(value.trim());
  if (parsed == null) return 'Enter a valid number';
  if (parsed <= 0) return 'Amount must be greater than zero';
  return null;
}

/// Legacy class-based API retained for backward compatibility.
class Validators {
  Validators._();

  static String? email(String? value) => validateEmail(value);

  static String? password(String? value) => validatePassword(value);

  static String? required(String? value, {String fieldName = 'Field'}) =>
      validateRequired(value, fieldName);

  static String? amount(String? value) => validateAmount(value);

  static String? confirmPassword(String? value, String password) =>
      validateConfirmPassword(value, password);
}
