import 'package:dartz/dartz.dart';
import '../../../../core/errors/failures.dart';
import '../entities/user_entity.dart';
import '../repositories/auth_repository.dart';

class LoginUseCase {
  final AuthRepository _repository;
  const LoginUseCase(this._repository);

  Future<Either<Failure, UserEntity>> execute(
      String email, String password) async {
    if (email.trim().isEmpty) {
      return const Left(ValidationFailure('Email cannot be empty.'));
    }
    if (password.isEmpty) {
      return const Left(ValidationFailure('Password cannot be empty.'));
    }
    return _repository.login(email.trim(), password);
  }
}
