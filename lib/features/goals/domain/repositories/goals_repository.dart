import 'package:dartz/dartz.dart';

import '../../../../core/errors/failures.dart';
import '../entities/contribution_entity.dart';
import '../entities/goal_entity.dart';

abstract class GoalsRepository {
  /// All goals, ordered incomplete-first then newest-first.
  Stream<List<GoalEntity>> watchGoals(String uid);

  Future<Either<Failure, void>> createGoal(String uid, GoalEntity goal);

  /// Atomically adds a contribution and increments the goal's savedAmount,
  /// flipping isCompleted when the target is reached.
  Future<Either<Failure, void>> addFunds(
      String uid, String goalId, double amount, String? note);

  Future<Either<Failure, void>> adjustPlan(
    String uid,
    String goalId, {
    double? targetAmount,
    DateTime? targetDate,
  });

  /// Deletes the goal and all of its contributions.
  Future<Either<Failure, void>> deleteGoal(String uid, String goalId);

  Future<List<ContributionEntity>> getRecentContributions(
      String uid, String goalId,
      {int limit});
}
