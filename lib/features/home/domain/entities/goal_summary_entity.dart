import 'package:freezed_annotation/freezed_annotation.dart';

part 'goal_summary_entity.freezed.dart';

@freezed
class GoalSummaryEntity with _$GoalSummaryEntity {
  const GoalSummaryEntity._();

  const factory GoalSummaryEntity({
    required String id,
    required String title,
    required double savedAmount,
    required double targetAmount,
    required String category,
  }) = _GoalSummaryEntity;

  /// Fraction saved, clamped to 0.0–1.0.
  double get progress =>
      targetAmount > 0 ? (savedAmount / targetAmount).clamp(0.0, 1.0) : 0.0;

  bool get isComplete => savedAmount >= targetAmount && targetAmount > 0;
}
