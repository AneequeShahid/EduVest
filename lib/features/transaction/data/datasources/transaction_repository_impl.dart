import '../../domain/entities/transaction.dart';
import '../../domain/repositories/transaction_repository.dart';
import '../datasources/transaction_firebase_datasource.dart';
import '../models/transaction_model.dart';

class TransactionRepositoryImpl implements TransactionRepository {
  final TransactionFirebaseDataSource dataSource;

  TransactionRepositoryImpl(this.dataSource);

  @override
  Future<void> addTransaction(Transaction transaction) {
    final model = TransactionModel(
      id: transaction.id,
      title: transaction.title,
      subtitle: transaction.subtitle,
      amount: transaction.amount,
      isIncome: transaction.isIncome,
      status: transaction.status,
      date: transaction.date,
      category: transaction.category,
      note: transaction.note,
      createdAt: transaction.createdAt,
    );
    return dataSource.addTransaction(model);
  }

  @override
  Stream<List<Transaction>> watchTransactions() {
    return dataSource.watchTransactions().map((list) => list.cast<Transaction>());
  }

  @override
  Future<List<Transaction>> getTransactionsByDateRange(
      DateTime startDate, DateTime endDate) async {
    final list = await dataSource.getTransactionsByDateRange(startDate, endDate);
    return list.cast<Transaction>();
  }

  @override
  Future<List<Transaction>> getTransactionsByCategory(String category) async {
    final list = await dataSource.getTransactionsByCategory(category);
    return list.cast<Transaction>();
  }
}
