import '../entities/goal_progress_status.dart';

/// Implements the 0–100 financial health score (4 weighted factors).
/// Pure computation — fully deterministic and unit-testable.
class GetHealthScoreUseCase {
  const GetHealthScoreUseCase();

  int call({
    required double budgetUsagePercent, // spent / limit (0..>1)
    required double savingsRate, // saved / (saved + expenses) (0..1)
    required GoalProgressStatus goalStatus,
    required double spendingVariance, // coefficient of variation (0..>1)
  }) {
    final score = _budgetPoints(budgetUsagePercent) +
        _savingsPoints(savingsRate) +
        _goalPoints(goalStatus) +
        _consistencyPoints(spendingVariance);
    return score.clamp(0, 100);
  }

  /// Budget adherence — 30 pts.
  int _budgetPoints(double used) {
    if (used > 1.0) return 0;
    if (used >= 0.85) return 10;
    if (used >= 0.70) return 20;
    return 30;
  }

  /// Savings rate — 25 pts.
  int _savingsPoints(double rate) {
    if (rate > 0.20) return 25;
    if (rate >= 0.10) return 15;
    if (rate >= 0.05) return 8;
    return 0;
  }

  /// Goal progress — 25 pts.
  int _goalPoints(GoalProgressStatus status) {
    switch (status) {
      case GoalProgressStatus.onTrack:
        return 25;
      case GoalProgressStatus.slightlyBehind:
        return 15;
      case GoalProgressStatus.veryBehind:
        return 5;
      case GoalProgressStatus.noGoals:
        return 0;
    }
  }

  /// Spending consistency — 20 pts. [variance] is a coefficient of variation.
  int _consistencyPoints(double variance) {
    if (variance > 0.25) return 0;
    if (variance >= 0.10) return 10;
    return 20;
  }
}
