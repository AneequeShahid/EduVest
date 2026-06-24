import 'package:dartz/dartz.dart';

import '../../../../core/errors/failures.dart';
import '../entities/budget_category_entity.dart';
import '../repositories/budget_repository.dart';

class AddBudgetCategoryUseCase {
  final BudgetRepository repository;
  const AddBudgetCategoryUseCase(this.repository);

  Future<Either<Failure, void>> call(
      String uid, int month, int year, BudgetCategoryEntity category) {
    if (category.name.trim().isEmpty) {
      return Future.value(
          const Left(ValidationFailure('Category name is required.')));
    }
    if (category.limit <= 0) {
      return Future.value(
          const Left(ValidationFailure('Limit must be greater than zero.')));
    }
    return repository.addCategory(uid, month, year, category);
  }
}
