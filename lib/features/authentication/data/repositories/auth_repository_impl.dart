import 'package:dartz/dartz.dart';
import '../../../../core/errors/failures.dart';
import '../../domain/entities/user_entity.dart';
import '../../domain/repositories/auth_repository.dart';
import '../sources/auth_remote_source.dart';

class AuthRepositoryImpl implements AuthRepository {
  final AuthRemoteSource _source;

  AuthRepositoryImpl(this._source);

  @override
  Future<Either<Failure, UserEntity>> login(
      String email, String password) async {
    try {
      final user = await _source.login(email, password);
      return Right(user);
    } catch (e) {
      return Left(AuthFailure(_extractMessage(e)));
    }
  }

  @override
  Future<Either<Failure, UserEntity>> signup(
      String email, String password, String name) async {
    try {
      final user = await _source.signup(email, password, name);
      return Right(user);
    } catch (e) {
      return Left(AuthFailure(_extractMessage(e)));
    }
  }

  @override
  Future<Either<Failure, void>> logout() async {
    try {
      await _source.logout();
      return const Right(null);
    } catch (e) {
      return Left(AuthFailure(_extractMessage(e)));
    }
  }

  @override
  Future<Either<Failure, void>> resetPassword(String email) async {
    try {
      await _source.resetPassword(email);
      return const Right(null);
    } catch (e) {
      return Left(AuthFailure(_extractMessage(e)));
    }
  }

  @override
  UserEntity? get currentUser => _source.currentUser;

  @override
  Stream<UserEntity?> get authStateChanges => _source.authStateChanges;

  static String _extractMessage(Object e) {
    if (e is Exception) {
      final msg = e.toString();
      // Strip "Exception: " prefix added by our source
      return msg.startsWith('Exception: ')
          ? msg.substring('Exception: '.length)
          : msg;
    }
    return e.toString();
  }
}
