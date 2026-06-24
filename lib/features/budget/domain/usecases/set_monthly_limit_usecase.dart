import 'package:dartz/dartz.dart';

import '../../../../core/errors/failures.dart';
import '../repositories/budget_repository.dart';

class SetMonthlyLimitUseCase {
  final BudgetRepository repository;
  const SetMonthlyLimitUseCase(this.repository);

  Future<Either<Failure, void>> call(
      String uid, int month, int year, double limit) {
    if (limit <= 0) {
      return Future.value(
          const Left(ValidationFailure('Limit must be greater than zero.')));
    }
    return repository.setMonthlyLimit(uid, month, year, limit);
  }
}
