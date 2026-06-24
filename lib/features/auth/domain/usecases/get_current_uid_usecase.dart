import '../repositories/auth_repository.dart';

class GetCurrentUidUseCase {
  final AuthRepository repository;

  GetCurrentUidUseCase(this.repository);

  String call() => repository.getCurrentUid();
}
