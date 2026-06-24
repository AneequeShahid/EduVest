import '../../domain/entities/transaction.dart';
import '../../domain/repositories/transaction_repository.dart';

class GetTransactionsByDateRangeUseCase {
  final TransactionRepository repository;

  GetTransactionsByDateRangeUseCase(this.repository);

  Future<List<Transaction>> call(DateTime startDate, DateTime endDate) =>
      repository.getTransactionsByDateRange(startDate, endDate);
}
