import '../../domain/entities/transaction.dart';
import '../../domain/repositories/transaction_repository.dart';

class GetTransactionsByCategoryUseCase {
  final TransactionRepository repository;

  GetTransactionsByCategoryUseCase(this.repository);

  Future<List<Transaction>> call(String category) =>
      repository.getTransactionsByCategory(category);
}
