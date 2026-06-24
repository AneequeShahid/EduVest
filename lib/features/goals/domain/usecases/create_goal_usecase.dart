import 'package:dartz/dartz.dart';

import '../../../../core/errors/failures.dart';
import '../../../../core/utils/sanitizer.dart';
import '../entities/goal_entity.dart';
import '../repositories/goals_repository.dart';

class CreateGoalUseCase {
  final GoalsRepository repository;
  const CreateGoalUseCase(this.repository);

  Future<Either<Failure, void>> call(String uid, GoalEntity goal) {
    if (goal.title.trim().isEmpty) {
      return Future.value(const Left(ValidationFailure('Title is required.')));
    }
    if (goal.targetAmount <= 0) {
      return Future.value(const Left(
          ValidationFailure('Target amount must be greater than zero.')));
    }
    if (!goal.targetDate.isAfter(DateTime.now())) {
      return Future.value(
          const Left(ValidationFailure('Target date must be in the future.')));
    }

    // Sanitize title + always start fresh: no saved amount, not completed.
    final normalized = goal.copyWith(
      title: Sanitizer.name(goal.title),
      savedAmount: 0,
      isCompleted: false,
      completedAt: null,
    );
    return repository.createGoal(uid, normalized);
  }
}
