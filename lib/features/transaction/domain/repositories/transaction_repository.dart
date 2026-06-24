import '../entities/transaction.dart';

/// Abstract contract for transaction operations. Zero Flutter/Firebase imports.
abstract class TransactionRepository {
  Future<void> addTransaction(Transaction transaction);
  Stream<List<Transaction>> watchTransactions();
  Future<List<Transaction>> getTransactionsByDateRange(DateTime startDate, DateTime endDate);
  Future<List<Transaction>> getTransactionsByCategory(String category);
}
