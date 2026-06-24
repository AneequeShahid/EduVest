import '../entities/expense_entity.dart';
import '../repositories/expense_repository.dart';

class GetExpensesUseCase {
  final ExpenseRepository repository;
  const GetExpensesUseCase(this.repository);

  Stream<List<ExpenseEntity>> call(String uid, {int? month, int? year}) =>
      repository.getExpensesStream(uid, month: month, year: year);
}
