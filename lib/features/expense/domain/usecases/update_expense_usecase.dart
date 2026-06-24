import 'package:dartz/dartz.dart';

import '../../../../core/errors/failures.dart';
import '../entities/expense_entity.dart';
import '../repositories/expense_repository.dart';
import 'add_expense_usecase.dart';

class UpdateExpenseUseCase {
  final ExpenseRepository repository;
  const UpdateExpenseUseCase(this.repository);

  Future<Either<Failure, void>> call(String uid, ExpenseEntity expense) {
    final validation = AddExpenseUseCase.validateExpense(expense);
    if (validation != null) return Future.value(Left(validation));

    final normalized = expense.copyWith(
      month: expense.date.month,
      year: expense.date.year,
    );
    return repository.updateExpense(uid, normalized);
  }
}
