class AuthException implements Exception {
  final String message;
  const AuthException(this.message);
  @override
  String toString() => message;
}

class ExpenseException implements Exception {
  final String message;
  const ExpenseException(this.message);
  @override
  String toString() => message;
}

class TransactionException implements Exception {
  final String message;
  const TransactionException(this.message);
  @override
  String toString() => message;
}

class BudgetException implements Exception {
  final String message;
  const BudgetException(this.message);
  @override
  String toString() => message;
}

class GoalException implements Exception {
  final String message;
  const GoalException(this.message);
  @override
  String toString() => message;
}

class InsightsException implements Exception {
  final String message;
  const InsightsException(this.message);
  @override
  String toString() => message;
}

class SettingsException implements Exception {
  final String message;
  const SettingsException(this.message);
  @override
  String toString() => message;
}

class HomeException implements Exception {
  final String message;
  const HomeException(this.message);
  @override
  String toString() => message;
}
