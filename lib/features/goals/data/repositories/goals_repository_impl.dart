import 'package:dartz/dartz.dart';

import '../../../../core/errors/failures.dart';
import '../../domain/entities/contribution_entity.dart';
import '../../domain/entities/goal_entity.dart';
import '../../domain/repositories/goals_repository.dart';
import '../sources/goals_remote_source.dart';

class GoalsRepositoryImpl implements GoalsRepository {
  final GoalsRemoteSource _source;

  GoalsRepositoryImpl(this._source);

  @override
  Stream<List<GoalEntity>> watchGoals(String uid) => _source.watchGoals(uid);

  @override
  Future<List<ContributionEntity>> getRecentContributions(
          String uid, String goalId, {int limit = 5}) =>
      _source.getRecentContributions(uid, goalId, limit: limit);

  @override
  Future<Either<Failure, void>> createGoal(String uid, GoalEntity goal) =>
      _guard(() => _source.createGoal(uid, goal));

  @override
  Future<Either<Failure, void>> addFunds(
          String uid, String goalId, double amount, String? note) =>
      _guard(() => _source.addFunds(uid, goalId, amount, note));

  @override
  Future<Either<Failure, void>> adjustPlan(String uid, String goalId,
          {double? targetAmount, DateTime? targetDate}) =>
      _guard(() => _source.adjustPlan(uid, goalId,
          targetAmount: targetAmount, targetDate: targetDate));

  @override
  Future<Either<Failure, void>> deleteGoal(String uid, String goalId) =>
      _guard(() => _source.deleteGoal(uid, goalId));

  Future<Either<Failure, void>> _guard(Future<void> Function() action) async {
    try {
      await action();
      return const Right(null);
    } catch (e) {
      return Left(ServerFailure(e.toString()));
    }
  }
}
