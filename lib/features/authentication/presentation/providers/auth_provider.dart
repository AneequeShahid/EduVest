import 'dart:async';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';
import '../../data/sources/auth_remote_source.dart';
import '../../data/repositories/auth_repository_impl.dart';
import '../../domain/entities/user_entity.dart';
import '../../domain/repositories/auth_repository.dart';
import '../../domain/usecases/login_usecase.dart';
import '../../domain/usecases/logout_usecase.dart';
import '../../domain/usecases/reset_password_usecase.dart';
import '../../domain/usecases/signup_usecase.dart';

part 'auth_provider.g.dart';

// ── Infrastructure ────────────────────────────────────────────────────────

@Riverpod(keepAlive: true)
AuthRemoteSourceImpl authRemoteSource(Ref ref) => AuthRemoteSourceImpl();

@Riverpod(keepAlive: true)
AuthRepository authRepo(Ref ref) =>
    AuthRepositoryImpl(ref.watch(authRemoteSourceProvider));

// ── Use-case providers ────────────────────────────────────────────────────

@riverpod
LoginUseCase loginUseCase(Ref ref) =>
    LoginUseCase(ref.watch(authRepoProvider));

@riverpod
SignupUseCase signupUseCase(Ref ref) =>
    SignupUseCase(ref.watch(authRepoProvider));

@riverpod
LogoutUseCase logoutUseCase(Ref ref) =>
    LogoutUseCase(ref.watch(authRepoProvider));

@riverpod
ResetPasswordUseCase resetPasswordUseCase(Ref ref) =>
    ResetPasswordUseCase(ref.watch(authRepoProvider));

// ── Auth state stream (mirrors Firebase auth changes) ─────────────────────

@Riverpod(keepAlive: true)
Stream<UserEntity?> authState(Ref ref) =>
    ref.watch(authRepoProvider).authStateChanges;

// ── Auth notifier ─────────────────────────────────────────────────────────

@Riverpod(keepAlive: true)
class AuthNotifier extends _$AuthNotifier {
  @override
  FutureOr<UserEntity?> build() =>
      ref.watch(authRepoProvider).currentUser;

  Future<void> login(String email, String password) async {
    state = const AsyncLoading();
    final result =
        await ref.read(loginUseCaseProvider).execute(email, password);
    result.fold(
      (failure) => state = AsyncError(failure.message, StackTrace.current),
      (user) => state = AsyncData(user),
    );
  }

  Future<void> signup(String email, String password, String name) async {
    state = const AsyncLoading();
    final result =
        await ref.read(signupUseCaseProvider).execute(email, password, name);
    result.fold(
      (failure) => state = AsyncError(failure.message, StackTrace.current),
      (user) => state = AsyncData(user),
    );
  }

  Future<void> logout() async {
    state = const AsyncLoading();
    final result = await ref.read(logoutUseCaseProvider).execute();
    result.fold(
      (failure) => state = AsyncError(failure.message, StackTrace.current),
      (_) => state = const AsyncData(null),
    );
  }

  Future<void> resetPassword(String email) async {
    state = const AsyncLoading();
    final result =
        await ref.read(resetPasswordUseCaseProvider).execute(email);
    result.fold(
      (failure) => state = AsyncError(failure.message, StackTrace.current),
      (r) => state = AsyncData(state.valueOrNull),
    );
  }
}
