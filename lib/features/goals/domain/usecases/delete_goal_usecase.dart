import 'package:dartz/dartz.dart';

import '../../../../core/errors/failures.dart';
import '../repositories/goals_repository.dart';

class DeleteGoalUseCase {
  final GoalsRepository repository;
  const DeleteGoalUseCase(this.repository);

  Future<Either<Failure, void>> call(String uid, String goalId) =>
      repository.deleteGoal(uid, goalId);
}
