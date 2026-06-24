import 'package:eduvest_output/features/budget/domain/entities/smart_insight_entity.dart';
import 'package:eduvest_output/features/budget/domain/usecases/get_smart_insights_usecase.dart';
import 'package:flutter_test/flutter_test.dart';

void main() {
  const useCase = GetSmartInsightsUseCase();

  test("1. returns 'saved X%' when spending < 88% of 3-month avg", () async {
    final insights = useCase.call(
      categories: [
        (name: 'Groceries', spent: 50, limit: 400, avg3m: 100),
      ],
      remaining: 1000,
      dailyAllowance: 50,
      monthsOfHistory: 3,
    );

    expect(insights.any((i) => i.type == SmartInsightType.saved), isTrue);
    final saved =
        insights.firstWhere((i) => i.type == SmartInsightType.saved);
    expect(saved.message, contains('saved'));
    expect(saved.message, contains('Groceries'));
  });

  test("2. returns 'warning' when spending > 90% of limit", () async {
    final insights = useCase.call(
      categories: [
        (name: 'Rent', spent: 95, limit: 100, avg3m: 0),
      ],
      remaining: 1000,
      dailyAllowance: 50,
      monthsOfHistory: 0,
    );

    expect(insights.any((i) => i.type == SmartInsightType.warning), isTrue);
  });

  test("3. returns 'tight week' when remaining < 7 * dailyAllowance",
      () async {
    final insights = useCase.call(
      categories: const [],
      remaining: 50,
      dailyAllowance: 10, // 50 < 70
      monthsOfHistory: 3,
    );

    expect(
        insights.any((i) => i.type == SmartInsightType.tightWeek), isTrue);
  });

  test('4. returns empty list with insufficient history', () async {
    final insights = useCase.call(
      categories: [
        (name: 'Food', spent: 50, limit: 400, avg3m: 100),
      ],
      remaining: 1000,
      dailyAllowance: 10, // 1000 >= 70 → no tight week
      monthsOfHistory: 1, // insufficient → no "saved"
    );

    expect(insights, isEmpty);
  });
}
