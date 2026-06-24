import 'goal_progress_status.dart';
import 'monthly_flow_entity.dart';

/// Raw, pre-computation inputs gathered (read-only) from the expense, budget
/// and goals data. [GetInsightsUseCase] turns this into an [InsightsEntity].
class InsightsRawData {
  final List<MonthlyFlowEntity> last6Months;
  final Map<String, double> categoryTotals; // current month, by category
  final double budgetUsagePercent; // currentMonthSpent / monthlyLimit
  final double totalSaved; // across all goals
  final double totalExpenses; // window used for the savings rate
  final GoalProgressStatus goalStatus;
  final List<double> last3MonthsSpending;

  const InsightsRawData({
    required this.last6Months,
    required this.categoryTotals,
    required this.budgetUsagePercent,
    required this.totalSaved,
    required this.totalExpenses,
    required this.goalStatus,
    required this.last3MonthsSpending,
  });
}
