import '../repositories/auth_repository.dart';

class SignInAnonymouslyUseCase {
  final AuthRepository repository;

  SignInAnonymouslyUseCase(this.repository);

  Future<String> call() => repository.signInAnonymously();
}
