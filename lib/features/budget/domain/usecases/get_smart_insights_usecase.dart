import '../../../../core/utils/currency_utils.dart';
import '../entities/smart_insight_entity.dart';

/// Per-category input for insight generation.
typedef InsightCategoryInput = ({
  String name,
  double spent,
  double limit,
  double avg3m,
});

/// Generates spending insights. Pure computation — no I/O — so it is fully
/// deterministic and unit-testable.
class GetSmartInsightsUseCase {
  const GetSmartInsightsUseCase();

  List<SmartInsightEntity> call({
    required List<InsightCategoryInput> categories,
    required double remaining,
    required double dailyAllowance,
    required int monthsOfHistory,
  }) {
    final insights = <SmartInsightEntity>[];

    for (final c in categories) {
      final isGrocery = c.name.toLowerCase() == 'groceries';

      // "Saved X%" — only with at least 3 months of history.
      if (monthsOfHistory >= 3 && c.avg3m > 0 && c.spent < c.avg3m * 0.88) {
        final savedPct = ((1 - c.spent / c.avg3m) * 100).round();
        insights.add(SmartInsightEntity(
          type: SmartInsightType.saved,
          message: 'You saved $savedPct% on ${c.name}!',
          category: c.name,
          isGroceryRelated: isGrocery,
        ));
      }

      // "Warning" — over 90% of the category limit.
      if (c.limit > 0 && c.spent > c.limit * 0.9) {
        insights.add(SmartInsightEntity(
          type: SmartInsightType.warning,
          message: 'Warning: ${c.name} at 90% of limit',
          category: c.name,
          isGroceryRelated: isGrocery,
        ));
      }
    }

    // "Tight week" — less than a week of daily allowance left.
    if (remaining < dailyAllowance * 7) {
      insights.add(SmartInsightEntity(
        type: SmartInsightType.tightWeek,
        message:
            'Tight week — only ${formatCurrency(dailyAllowance)}/day remaining',
      ));
    }

    return insights;
  }
}
