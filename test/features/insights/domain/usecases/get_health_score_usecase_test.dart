import 'package:eduvest_output/features/insights/domain/entities/goal_progress_status.dart';
import 'package:eduvest_output/features/insights/domain/usecases/get_health_score_usecase.dart';
import 'package:flutter_test/flutter_test.dart';

void main() {
  const useCase = GetHealthScoreUseCase();

  int score({
    double budget = 0.5,
    double savings = 0.25,
    GoalProgressStatus goals = GoalProgressStatus.onTrack,
    double variance = 0.05,
  }) =>
      useCase.call(
        budgetUsagePercent: budget,
        savingsRate: savings,
        goalStatus: goals,
        spendingVariance: variance,
      );

  test('1. returns 90+ when budget < 70%, savings > 20%, goals on track', () {
    final s = score(
        budget: 0.5,
        savings: 0.25,
        goals: GoalProgressStatus.onTrack,
        variance: 0.05);
    expect(s, greaterThanOrEqualTo(90)); // 30 + 25 + 25 + 20 = 100
  });

  test('2. returns < 40 when budget exceeded and no savings', () {
    final s = score(
        budget: 1.2,
        savings: 0.0,
        goals: GoalProgressStatus.noGoals,
        variance: 0.4);
    expect(s, lessThan(40)); // 0 + 0 + 0 + 0
  });

  test('3. 65% budget used → 30 points', () {
    // Isolate the budget factor: zero out the others.
    final s = score(
        budget: 0.65,
        savings: 0.0,
        goals: GoalProgressStatus.noGoals,
        variance: 0.4);
    expect(s, 30);
  });

  test('4. 95% budget used → 10 points', () {
    final s = score(
        budget: 0.95,
        savings: 0.0,
        goals: GoalProgressStatus.noGoals,
        variance: 0.4);
    expect(s, 10);
  });

  test('5. 110% budget used → 0 points', () {
    final s = score(
        budget: 1.10,
        savings: 0.0,
        goals: GoalProgressStatus.noGoals,
        variance: 0.4);
    expect(s, 0);
  });

  test('6. 25% savings rate → 25 points', () {
    final s = score(
        budget: 1.2,
        savings: 0.25,
        goals: GoalProgressStatus.noGoals,
        variance: 0.4);
    expect(s, 25);
  });

  test('7. 3% savings rate → 0 points', () {
    final s = score(
        budget: 1.2,
        savings: 0.03,
        goals: GoalProgressStatus.noGoals,
        variance: 0.4);
    expect(s, 0);
  });

  test('8. score always clamped 0–100', () {
    final best = score(
        budget: 0.1,
        savings: 0.9,
        goals: GoalProgressStatus.onTrack,
        variance: 0.0);
    final worst = score(
        budget: 2.0,
        savings: 0.0,
        goals: GoalProgressStatus.noGoals,
        variance: 1.0);
    expect(best, inInclusiveRange(0, 100));
    expect(worst, inInclusiveRange(0, 100));
    expect(best, 100);
    expect(worst, 0);
  });
}
