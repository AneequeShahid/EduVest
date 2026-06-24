import 'package:dartz/dartz.dart';
import '../../../../core/errors/failures.dart';
import '../repositories/auth_repository.dart';

class ResetPasswordUseCase {
  final AuthRepository _repository;
  const ResetPasswordUseCase(this._repository);

  Future<Either<Failure, void>> execute(String email) async {
    if (email.trim().isEmpty) {
      return const Left(ValidationFailure('Email cannot be empty.'));
    }
    return _repository.resetPassword(email.trim());
  }
}
