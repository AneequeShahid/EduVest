import 'package:dartz/dartz.dart';

import '../../../../core/errors/failures.dart';
import '../repositories/goals_repository.dart';

class AdjustPlanUseCase {
  final GoalsRepository repository;
  const AdjustPlanUseCase(this.repository);

  Future<Either<Failure, void>> call(
    String uid,
    String goalId, {
    double? targetAmount,
    DateTime? targetDate,
  }) {
    if (targetAmount == null && targetDate == null) {
      return Future.value(
          const Left(ValidationFailure('Nothing to update.')));
    }
    if (targetAmount != null && targetAmount <= 0) {
      return Future.value(const Left(
          ValidationFailure('Target amount must be greater than zero.')));
    }
    if (targetDate != null && !targetDate.isAfter(DateTime.now())) {
      return Future.value(
          const Left(ValidationFailure('Target date must be in the future.')));
    }
    return repository.adjustPlan(uid, goalId,
        targetAmount: targetAmount, targetDate: targetDate);
  }
}
