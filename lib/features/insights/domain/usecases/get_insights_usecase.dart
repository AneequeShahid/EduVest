import 'dart:math' as math;

import 'package:dartz/dartz.dart';

import '../../../../core/errors/failures.dart';
import '../entities/category_spend_entity.dart';
import '../entities/goal_progress_status.dart';
import '../entities/insights_entity.dart';
import '../entities/insights_raw_data.dart';
import '../entities/recommendation_entity.dart';
import '../repositories/insights_repository.dart';
import 'get_health_score_usecase.dart';

class GetInsightsUseCase {
  final InsightsRepository repository;
  final GetHealthScoreUseCase healthScore;

  const GetInsightsUseCase(
    this.repository, {
    this.healthScore = const GetHealthScoreUseCase(),
  });

  static const Map<String, String> _categoryColors = {
    'Rent': '#7B5EA7',
    'Groceries': '#2E7D32',
    'Transport': '#1565C0',
    'Fun': '#D81B60',
    'Education': '#F9A825',
    'Health': '#C62828',
    'Others': '#757575',
  };

  Future<Either<Failure, InsightsEntity>> call(
      String uid, int month, int year) async {
    try {
      final raw = await repository.getRawData(uid, month, year);

      final savingsRate = (raw.totalSaved + raw.totalExpenses) > 0
          ? raw.totalSaved / (raw.totalSaved + raw.totalExpenses)
          : 0.0;
      final variance = _coefficientOfVariation(raw.last3MonthsSpending);

      final score = healthScore.call(
        budgetUsagePercent: raw.budgetUsagePercent,
        savingsRate: savingsRate,
        goalStatus: raw.goalStatus,
        spendingVariance: variance,
      );

      return Right(
        InsightsEntity(
          healthScore: score,
          healthLabel: _label(score),
          riskProfile: _riskProfile(score),
          monthlyYieldPercent: _monthlyYield(raw),
          capitalFlowData: raw.last6Months,
          categoryBreakdown: _breakdown(raw.categoryTotals),
          recommendations: _recommendations(raw, savingsRate),
        ),
      );
    } catch (e) {
      return Left(ServerFailure('Failed to compute insights: $e'));
    }
  }

  // ── Helpers ────────────────────────────────────────────────────────────────

  String _label(int score) {
    if (score >= 80) return 'Excellent';
    if (score >= 60) return 'Good';
    if (score >= 40) return 'Fair';
    return 'Needs Work';
  }

  String _riskProfile(int score) {
    if (score >= 80) return 'Minimal';
    if (score < 40) return 'High';
    return 'Moderate';
  }

  double _monthlyYield(InsightsRawData raw) {
    final months = raw.last6Months;
    if (months.isEmpty) return 0;
    final last = months.last;
    if (last.totalIncome <= 0) return 0;
    return (last.net / last.totalIncome) * 100;
  }

  List<CategorySpendEntity> _breakdown(Map<String, double> totals) {
    final sum = totals.values.fold<double>(0, (a, b) => a + b);
    if (sum <= 0) return const [];
    final entries = totals.entries
        .map((e) => CategorySpendEntity(
              category: e.key,
              totalSpent: e.value,
              percentOfTotal: (e.value / sum) * 100,
              colorHex: _categoryColors[e.key] ?? '#C1622A',
            ))
        .toList()
      ..sort((a, b) => b.totalSpent.compareTo(a.totalSpent));
    return entries;
  }

  double _coefficientOfVariation(List<double> values) {
    if (values.length < 2) return 0;
    final mean = values.reduce((a, b) => a + b) / values.length;
    if (mean == 0) return 0;
    final varSum = values
        .map((v) => (v - mean) * (v - mean))
        .reduce((a, b) => a + b);
    final stdDev = math.sqrt(varSum / values.length);
    return stdDev / mean;
  }

  List<RecommendationEntity> _recommendations(
      InsightsRawData raw, double savingsRate) {
    final recs = <RecommendationEntity>[];

    if (raw.budgetUsagePercent > 0.90) {
      recs.add(const RecommendationEntity(
        id: 'budget-critical',
        title: 'Ease off spending',
        description:
            "You've used over 90% of your budget. Try to hold off on non-essentials for the rest of the month.",
        type: RecommendationType.budget,
      ));
    } else if (raw.budgetUsagePercent > 0.80) {
      recs.add(const RecommendationEntity(
        id: 'budget-watch',
        title: 'Watch your budget',
        description:
            "You're past 80% of your monthly budget. Keep an eye on discretionary spending.",
        type: RecommendationType.budget,
      ));
    }

    if (savingsRate < 0.05) {
      recs.add(const RecommendationEntity(
        id: 'savings-low',
        title: 'Boost your savings',
        description:
            'Your savings rate is low. Automating even a small weekly transfer can build momentum.',
        type: RecommendationType.savings,
      ));
    }

    if (raw.goalStatus == GoalProgressStatus.veryBehind) {
      recs.add(const RecommendationEntity(
        id: 'goal-behind',
        title: 'Revisit your goals',
        description:
            'Some goals are falling behind schedule. Consider adjusting the target date or amount.',
        type: RecommendationType.goal,
      ));
    }

    if (recs.isEmpty) {
      recs.add(const RecommendationEntity(
        id: 'general-good',
        title: 'Optimize your library hours',
        description:
            "You're doing great. Small, consistent habits keep your financial health strong.",
        type: RecommendationType.general,
      ));
    }

    return recs;
  }
}
