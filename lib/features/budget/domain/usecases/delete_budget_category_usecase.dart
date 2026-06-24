import 'package:dartz/dartz.dart';

import '../../../../core/errors/failures.dart';
import '../repositories/budget_repository.dart';

class DeleteBudgetCategoryUseCase {
  final BudgetRepository repository;
  const DeleteBudgetCategoryUseCase(this.repository);

  Future<Either<Failure, void>> call(
          String uid, int month, int year, String categoryId) =>
      repository.deleteCategory(uid, month, year, categoryId);
}
