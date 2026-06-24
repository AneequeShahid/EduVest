import 'package:freezed_annotation/freezed_annotation.dart';

import 'contribution_entity.dart';

part 'goal_entity.freezed.dart';

@freezed
class GoalEntity with _$GoalEntity {
  const GoalEntity._();

  const factory GoalEntity({
    required String id,
    required String title,
    required double targetAmount,
    @Default(0.0) double savedAmount,
    required DateTime targetDate,
    @Default('Other') String category,
    @Default('🎯') String emoji,
    @Default('#C1622A') String colorHex,
    @Default(false) bool isCompleted,
    DateTime? completedAt,
    DateTime? createdAt,
    @Default(<ContributionEntity>[]) List<ContributionEntity> contributions,
  }) = _GoalEntity;

  double get remainingAmount {
    final r = targetAmount - savedAmount;
    return r < 0 ? 0 : r;
  }

  double get progressPercent =>
      targetAmount > 0 ? (savedAmount / targetAmount).clamp(0.0, 1.0) : 0.0;

  /// Whole days until the target date (never negative).
  int get daysUntilTarget {
    final now = DateTime.now();
    final d = DateTime(targetDate.year, targetDate.month, targetDate.day)
        .difference(DateTime(now.year, now.month, now.day))
        .inDays;
    return d < 0 ? 0 : d;
  }

  /// Months until target, at least 1 so [monthlyNeeded] is finite.
  int get monthsUntilTarget {
    final m = (daysUntilTarget / 30).ceil();
    return m < 1 ? 1 : m;
  }

  double get monthlyNeeded => remainingAmount / monthsUntilTarget;

  /// True once the target is reached, regardless of the stored flag.
  bool get isReached => savedAmount >= targetAmount && targetAmount > 0;
}
