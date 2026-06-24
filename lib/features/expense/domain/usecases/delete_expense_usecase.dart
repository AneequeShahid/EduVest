import 'package:dartz/dartz.dart';

import '../../../../core/errors/failures.dart';
import '../entities/expense_entity.dart';
import '../repositories/expense_repository.dart';

class DeleteExpenseUseCase {
  final ExpenseRepository repository;
  const DeleteExpenseUseCase(this.repository);

  /// Deletes the expense doc and, if it has a receipt, removes the receipt
  /// from Storage first (best-effort — a failed receipt cleanup does not
  /// block the document deletion).
  Future<Either<Failure, void>> call(String uid, ExpenseEntity expense) async {
    if (expense.receiptUrl != null && expense.receiptUrl!.isNotEmpty) {
      await repository.deleteReceipt(uid, expense.id);
    }
    return repository.deleteExpense(uid, expense.id);
  }
}
