import 'package:eduvest_output/features/insights/domain/entities/goal_progress_status.dart';
import 'package:eduvest_output/features/insights/domain/entities/insights_raw_data.dart';
import 'package:eduvest_output/features/insights/domain/entities/monthly_flow_entity.dart';
import 'package:eduvest_output/features/insights/domain/usecases/get_insights_usecase.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mockito/mockito.dart';

import '../../helpers/insights_test_mocks.dart';

void main() {
  late MockInsightsRepository repository;
  late GetInsightsUseCase useCase;

  setUp(() {
    repository = MockInsightsRepository();
    useCase = GetInsightsUseCase(repository);
  });

  List<MonthlyFlowEntity> sixMonths() => List.generate(
        6,
        (i) => MonthlyFlowEntity(
            month: i + 1, year: 2026, totalSpent: 100, totalIncome: 150),
      );

  void stubRaw({
    Map<String, double>? categoryTotals,
    double budgetUsagePercent = 0.5,
    double totalSaved = 300,
    double totalExpenses = 600,
    GoalProgressStatus goalStatus = GoalProgressStatus.onTrack,
    List<double>? last3,
  }) {
    when(repository.getRawData(any, any, any)).thenAnswer(
      (_) async => InsightsRawData(
        last6Months: sixMonths(),
        categoryTotals:
            categoryTotals ?? {'Groceries': 150, 'Rent': 250, 'Fun': 100},
        budgetUsagePercent: budgetUsagePercent,
        totalSaved: totalSaved,
        totalExpenses: totalExpenses,
        goalStatus: goalStatus,
        last3MonthsSpending: last3 ?? const [100, 100, 100],
      ),
    );
  }

  test('1. capitalFlowData has exactly 6 entries', () async {
    stubRaw();
    final result = await useCase('uid', 3, 2026);
    final insights = result.getOrElse(() => throw 'expected Right');
    expect(insights.capitalFlowData.length, 6);
  });

  test('2. categoryBreakdown percentages sum to 100 (±0.1)', () async {
    stubRaw(categoryTotals: {'Groceries': 150, 'Rent': 250, 'Fun': 100});
    final result = await useCase('uid', 3, 2026);
    final insights = result.getOrElse(() => throw 'expected Right');

    final sum = insights.categoryBreakdown
        .fold<double>(0, (a, c) => a + c.percentOfTotal);
    expect(sum, closeTo(100, 0.1));
  });

  test("3. risk profile 'Minimal' when score >= 80", () async {
    stubRaw(
      budgetUsagePercent: 0.5, // 30
      totalSaved: 300, totalExpenses: 600, // savings 0.33 → 25
      goalStatus: GoalProgressStatus.onTrack, // 25
      last3: const [100, 100, 100], // variance 0 → 20  ⇒ 100
    );
    final insights =
        (await useCase('uid', 3, 2026)).getOrElse(() => throw 'Right');
    expect(insights.healthScore, greaterThanOrEqualTo(80));
    expect(insights.riskProfile, 'Minimal');
  });

  test("4. risk profile 'High' when score < 40", () async {
    stubRaw(
      budgetUsagePercent: 1.2, // 0
      totalSaved: 0, totalExpenses: 600, // savings 0 → 0
      goalStatus: GoalProgressStatus.noGoals, // 0
      last3: const [0, 0, 300], // high variance → 0  ⇒ 0
    );
    final insights =
        (await useCase('uid', 3, 2026)).getOrElse(() => throw 'Right');
    expect(insights.healthScore, lessThan(40));
    expect(insights.riskProfile, 'High');
  });

  test('5. at least 1 recommendation when budget > 80% used', () async {
    stubRaw(budgetUsagePercent: 0.85);
    final insights =
        (await useCase('uid', 3, 2026)).getOrElse(() => throw 'Right');
    expect(insights.recommendations, isNotEmpty);
  });
}
