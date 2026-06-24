import '../entities/goal_entity.dart';

/// Whether a goal is pacing to hit its target on time.
typedef GoalProgress = ({bool onTrack, double monthlyNeeded, double expected});

/// Pure computation: compares actual progress against the linear schedule
/// from createdAt → targetDate.
class GetGoalProgressUseCase {
  const GetGoalProgressUseCase();

  GoalProgress call(GoalEntity goal) {
    if (goal.isReached || goal.isCompleted) {
      return (onTrack: true, monthlyNeeded: 0, expected: goal.targetAmount);
    }

    final start = goal.createdAt ?? DateTime.now();
    final totalDays = goal.targetDate.difference(start).inDays;
    if (totalDays <= 0) {
      // Past due — on track only if already reached.
      return (
        onTrack: goal.savedAmount >= goal.targetAmount,
        monthlyNeeded: goal.monthlyNeeded,
        expected: goal.targetAmount,
      );
    }

    final elapsed = DateTime.now().difference(start).inDays.clamp(0, totalDays);
    final expected = goal.targetAmount * (elapsed / totalDays);

    // Allow a 10% slack before flagging "behind".
    final onTrack = goal.savedAmount >= expected * 0.9;
    return (
      onTrack: onTrack,
      monthlyNeeded: goal.monthlyNeeded,
      expected: expected,
    );
  }
}
