import 'package:dartz/dartz.dart';
import '../../../../core/errors/failures.dart';
import '../entities/user_entity.dart';
import '../repositories/auth_repository.dart';

class SignupUseCase {
  final AuthRepository _repository;
  const SignupUseCase(this._repository);

  Future<Either<Failure, UserEntity>> execute(
      String email, String password, String name) async {
    if (name.trim().isEmpty) {
      return const Left(ValidationFailure('Name cannot be empty.'));
    }
    if (email.trim().isEmpty) {
      return const Left(ValidationFailure('Email cannot be empty.'));
    }
    if (password.length < 8) {
      return const Left(
          ValidationFailure('Password must be at least 8 characters.'));
    }
    if (!password.contains(RegExp(r'[0-9]'))) {
      return const Left(
          ValidationFailure('Password must contain at least one number.'));
    }
    return _repository.signup(email.trim(), password, name.trim());
  }
}
