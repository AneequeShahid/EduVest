import 'package:freezed_annotation/freezed_annotation.dart';

import 'goal_summary_entity.dart';
import 'transaction_entity.dart';

part 'dashboard_entity.freezed.dart';

@freezed
class DashboardEntity with _$DashboardEntity {
  const DashboardEntity._();

  const factory DashboardEntity({
    required double totalBalance,
    required double monthlyBudgetLimit,
    required double monthlySpent,
    @Default(<TransactionEntity>[]) List<TransactionEntity> recentTransactions,
    GoalSummaryEntity? activeGoal,
    @Default(0.0) double balanceChangePercent,
  }) = _DashboardEntity;

  double get monthlyRemaining => monthlyBudgetLimit - monthlySpent;

  /// Fraction of the monthly budget used, clamped to 0.0–1.0.
  double get budgetProgress => monthlyBudgetLimit > 0
      ? (monthlySpent / monthlyBudgetLimit).clamp(0.0, 1.0)
      : 0.0;

  /// Remaining budget spread evenly across the days left in the current month.
  double get dailyLimit {
    if (monthlyRemaining <= 0) return 0;
    final now = DateTime.now();
    final daysInMonth = DateTime(now.year, now.month + 1, 0).day;
    final daysLeft = (daysInMonth - now.day + 1).clamp(1, daysInMonth);
    return monthlyRemaining / daysLeft;
  }
}
