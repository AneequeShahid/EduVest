import 'package:dartz/dartz.dart';

import '../../../../core/errors/failures.dart';
import '../entities/budget_category_entity.dart';
import '../repositories/budget_repository.dart';

class UpdateBudgetCategoryUseCase {
  final BudgetRepository repository;
  const UpdateBudgetCategoryUseCase(this.repository);

  Future<Either<Failure, void>> call(
          String uid, int month, int year, BudgetCategoryEntity category) =>
      repository.updateCategory(uid, month, year, category);
}
