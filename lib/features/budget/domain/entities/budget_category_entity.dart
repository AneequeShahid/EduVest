import 'package:freezed_annotation/freezed_annotation.dart';

part 'budget_category_entity.freezed.dart';

@freezed
class BudgetCategoryEntity with _$BudgetCategoryEntity {
  const BudgetCategoryEntity._();

  const factory BudgetCategoryEntity({
    required String id,
    required String name,
    required double limit,
    @Default(0.0) double spent,
    @Default('') String icon,
    @Default('#C1622A') String color,
    @Default(false) bool isPaid,
  }) = _BudgetCategoryEntity;

  double get remaining => limit - spent;

  double get usagePercent =>
      limit > 0 ? (spent / limit).clamp(0.0, 1.0) : 0.0;

  bool get isOverBudget => spent > limit;
}
