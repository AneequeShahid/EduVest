import '../../domain/entities/goal_summary_entity.dart';
import '../../domain/entities/transaction_entity.dart';
import '../../domain/repositories/home_repository.dart';
import '../sources/home_remote_source.dart';

class HomeRepositoryImpl implements HomeRepository {
  final HomeRemoteSource _source;
  final String _uid;

  HomeRepositoryImpl(this._source, {required String uid}) : _uid = uid;

  @override
  bool get isAuthenticated => _uid.isNotEmpty;

  @override
  Future<double> getTotalBalance() => _source.getTotalBalance();

  @override
  Future<MonthlyBudget> getMonthlyBudget() => _source.getMonthlyBudget();

  @override
  Future<List<TransactionEntity>> getRecentTransactions() =>
      _source.getRecentTransactions();

  @override
  Future<GoalSummaryEntity?> getActiveGoal() => _source.getActiveGoal();

  @override
  Future<double> getBalanceChangePercent() =>
      _source.getBalanceChangePercent();

  @override
  Stream<List<TransactionEntity>> watchRecentTransactions() =>
      _source.watchRecentTransactions();
}
