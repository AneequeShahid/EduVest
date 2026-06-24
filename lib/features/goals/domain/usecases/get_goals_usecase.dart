import '../entities/goal_entity.dart';
import '../repositories/goals_repository.dart';

class GetGoalsUseCase {
  final GoalsRepository repository;
  const GetGoalsUseCase(this.repository);

  Stream<List<GoalEntity>> call(String uid) => repository.watchGoals(uid);
}
