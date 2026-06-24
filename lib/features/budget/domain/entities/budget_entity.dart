import 'package:freezed_annotation/freezed_annotation.dart';

import 'budget_category_entity.dart';
import 'budget_status.dart';

part 'budget_entity.freezed.dart';

@freezed
class BudgetEntity with _$BudgetEntity {
  const BudgetEntity._();

  const factory BudgetEntity({
    required int month,
    required int year,
    required double totalLimit,
    required double totalSpent,
    required int daysInMonth,
    @Default(<BudgetCategoryEntity>[]) List<BudgetCategoryEntity> categories,
  }) = _BudgetEntity;

  double get remainingAmount => totalLimit - totalSpent;

  double get usagePercent =>
      totalLimit > 0 ? (totalSpent / totalLimit).clamp(0.0, 1.0) : 0.0;

  /// Days left in the budget's month (inclusive of today for the current
  /// month). 0 for a past month, full month for a future one.
  int get daysRemaining {
    final now = DateTime.now();
    if (now.year == year && now.month == month) {
      final left = daysInMonth - now.day + 1;
      return left < 1 ? 1 : left;
    }
    final isPast =
        DateTime(now.year, now.month).isAfter(DateTime(year, month));
    return isPast ? 0 : daysInMonth;
  }

  double get dailyAllowance =>
      daysRemaining > 0 ? remainingAmount / daysRemaining : remainingAmount;

  BudgetStatus get budgetStatus {
    final p = totalLimit > 0 ? totalSpent / totalLimit : 0.0;
    if (p > 1.0) return BudgetStatus.exceeded;
    if (p >= 0.9) return BudgetStatus.critical;
    if (p >= 0.7) return BudgetStatus.warning;
    return BudgetStatus.good;
  }
}
