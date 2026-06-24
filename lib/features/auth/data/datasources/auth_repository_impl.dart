import '../../domain/repositories/auth_repository.dart';
import '../datasources/auth_firebase_datasource.dart';

class AuthRepositoryImpl implements AuthRepository {
  final AuthFirebaseDataSource dataSource;

  AuthRepositoryImpl(this.dataSource);

  @override
  Future<String> signInAnonymously() => dataSource.signInAnonymously();

  @override
  String getCurrentUid() => dataSource.getCurrentUid();
}
