import 'package:dartz/dartz.dart';

import '../../../../core/errors/failures.dart';
import '../entities/dashboard_entity.dart';
import '../entities/goal_summary_entity.dart';
import '../entities/transaction_entity.dart';
import '../repositories/home_repository.dart';

/// Assembles the [DashboardEntity] by fetching its parts in parallel.
class GetDashboardUseCase {
  final HomeRepository repository;

  const GetDashboardUseCase(this.repository);

  Future<Either<Failure, DashboardEntity>> call() async {
    if (!repository.isAuthenticated) {
      return const Left(AuthFailure('User not authenticated.'));
    }

    try {
      // Kick off all reads before awaiting so they run concurrently.
      final balanceFuture = repository.getTotalBalance();
      final budgetFuture = repository.getMonthlyBudget();
      final transactionsFuture = repository.getRecentTransactions();
      final goalFuture = repository.getActiveGoal();
      final changeFuture = repository.getBalanceChangePercent();

      await Future.wait<Object?>([
        balanceFuture,
        budgetFuture,
        transactionsFuture,
        goalFuture,
        changeFuture,
      ]);

      final double balance = await balanceFuture;
      final MonthlyBudget budget = await budgetFuture;
      final List<TransactionEntity> transactions = await transactionsFuture;
      final GoalSummaryEntity? goal = await goalFuture;
      final double change = await changeFuture;

      return Right(
        DashboardEntity(
          totalBalance: balance,
          monthlyBudgetLimit: budget.limit,
          monthlySpent: budget.spent,
          recentTransactions: transactions,
          activeGoal: goal,
          balanceChangePercent: change,
        ),
      );
    } catch (e) {
      return Left(ServerFailure('Failed to load dashboard: $e'));
    }
  }
}
