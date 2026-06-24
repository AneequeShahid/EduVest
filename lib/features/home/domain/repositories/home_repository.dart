import '../entities/transaction_entity.dart';
import '../entities/goal_summary_entity.dart';

/// Monthly budget snapshot: configured [limit] and amount [spent] this month.
typedef MonthlyBudget = ({double limit, double spent});

abstract class HomeRepository {
  /// Whether a user is currently authenticated (drives the auth guard in the
  /// dashboard use case).
  bool get isAuthenticated;

  /// Total available balance = sum(income) − sum(expenses).
  Future<double> getTotalBalance();

  /// Current-month budget limit + amount spent this month.
  Future<MonthlyBudget> getMonthlyBudget();

  /// Five most recent transactions (expenses), newest first.
  Future<List<TransactionEntity>> getRecentTransactions();

  /// First active (incomplete) savings goal, or null when none exist.
  Future<GoalSummaryEntity?> getActiveGoal();

  /// Month-over-month balance change, as a percentage.
  Future<double> getBalanceChangePercent();

  /// Real-time stream of the five most recent transactions.
  Stream<List<TransactionEntity>> watchRecentTransactions();
}
