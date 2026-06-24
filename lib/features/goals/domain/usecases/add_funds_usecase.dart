import 'package:dartz/dartz.dart';

import '../../../../core/errors/failures.dart';
import '../repositories/goals_repository.dart';

class AddFundsUseCase {
  final GoalsRepository repository;
  const AddFundsUseCase(this.repository);

  Future<Either<Failure, void>> call(
      String uid, String goalId, double amount, String? note) {
    if (amount <= 0) {
      return Future.value(
          const Left(ValidationFailure('Amount must be greater than zero.')));
    }
    return repository.addFunds(uid, goalId, amount, note);
  }
}
