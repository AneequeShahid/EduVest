import 'package:dartz/dartz.dart';

import '../../../../core/errors/failures.dart';
import '../../../../core/utils/sanitizer.dart';
import '../entities/expense_entity.dart';
import '../repositories/expense_repository.dart';

class AddExpenseUseCase {
  final ExpenseRepository repository;
  const AddExpenseUseCase(this.repository);

  Future<Either<Failure, void>> call(String uid, ExpenseEntity expense) {
    final validation = validateExpense(expense);
    if (validation != null) return Future.value(Left(validation));

    // Sanitize free text + derive month/year from the transaction date.
    final normalized = expense.copyWith(
      description: Sanitizer.description(expense.description),
      month: expense.date.month,
      year: expense.date.year,
    );
    return repository.addExpense(uid, normalized);
  }

  /// Shared validation used by add + update. Returns a [Failure] or null.
  static ValidationFailure? validateExpense(ExpenseEntity expense) {
    if (expense.amount <= 0) {
      return const ValidationFailure('Amount must be greater than zero.');
    }
    if (expense.description.trim().isEmpty) {
      return const ValidationFailure('Description is required.');
    }
    if (expense.category.trim().isEmpty) {
      return const ValidationFailure('Please select a category.');
    }
    return null;
  }
}
