import 'package:dartz/dartz.dart';

import '../../../../core/errors/failures.dart';
import '../entities/budget_entity.dart';
import '../repositories/budget_repository.dart';

class GetBudgetUseCase {
  final BudgetRepository repository;
  const GetBudgetUseCase(this.repository);

  /// Fetches the budget (with spending computed from expenses).
  /// Returns [Left] when no budget has been set for the month.
  Future<Either<Failure, BudgetEntity>> call(
      String uid, int month, int year) async {
    try {
      final budget = await repository.getBudget(uid, month, year);
      if (budget == null) {
        return const Left(NotFoundFailure('No budget set for this month.'));
      }
      return Right(budget);
    } catch (e) {
      return Left(ServerFailure('Failed to load budget: $e'));
    }
  }
}
