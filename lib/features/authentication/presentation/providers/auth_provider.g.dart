// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'auth_provider.dart';

// **************************************************************************
// RiverpodGenerator
// **************************************************************************

String _$authRemoteSourceHash() => r'9f831a3a5e0b99a5e4da41531fb99533916223d9';

/// See also [authRemoteSource].
@ProviderFor(authRemoteSource)
final authRemoteSourceProvider = Provider<AuthRemoteSourceImpl>.internal(
  authRemoteSource,
  name: r'authRemoteSourceProvider',
  debugGetCreateSourceHash: const bool.fromEnvironment('dart.vm.product')
      ? null
      : _$authRemoteSourceHash,
  dependencies: null,
  allTransitiveDependencies: null,
);

@Deprecated('Will be removed in 3.0. Use Ref instead')
// ignore: unused_element
typedef AuthRemoteSourceRef = ProviderRef<AuthRemoteSourceImpl>;
String _$authRepoHash() => r'0e6c246fa6462a54ac99a982b2ca31a4321211d2';

/// See also [authRepo].
@ProviderFor(authRepo)
final authRepoProvider = Provider<AuthRepository>.internal(
  authRepo,
  name: r'authRepoProvider',
  debugGetCreateSourceHash:
      const bool.fromEnvironment('dart.vm.product') ? null : _$authRepoHash,
  dependencies: null,
  allTransitiveDependencies: null,
);

@Deprecated('Will be removed in 3.0. Use Ref instead')
// ignore: unused_element
typedef AuthRepoRef = ProviderRef<AuthRepository>;
String _$loginUseCaseHash() => r'7251658101196de8e58cec10ec4b9156333400ad';

/// See also [loginUseCase].
@ProviderFor(loginUseCase)
final loginUseCaseProvider = AutoDisposeProvider<LoginUseCase>.internal(
  loginUseCase,
  name: r'loginUseCaseProvider',
  debugGetCreateSourceHash:
      const bool.fromEnvironment('dart.vm.product') ? null : _$loginUseCaseHash,
  dependencies: null,
  allTransitiveDependencies: null,
);

@Deprecated('Will be removed in 3.0. Use Ref instead')
// ignore: unused_element
typedef LoginUseCaseRef = AutoDisposeProviderRef<LoginUseCase>;
String _$signupUseCaseHash() => r'a3bda20392c787d34da71f2e47702d7f490e4f32';

/// See also [signupUseCase].
@ProviderFor(signupUseCase)
final signupUseCaseProvider = AutoDisposeProvider<SignupUseCase>.internal(
  signupUseCase,
  name: r'signupUseCaseProvider',
  debugGetCreateSourceHash: const bool.fromEnvironment('dart.vm.product')
      ? null
      : _$signupUseCaseHash,
  dependencies: null,
  allTransitiveDependencies: null,
);

@Deprecated('Will be removed in 3.0. Use Ref instead')
// ignore: unused_element
typedef SignupUseCaseRef = AutoDisposeProviderRef<SignupUseCase>;
String _$logoutUseCaseHash() => r'4293fe59c96229ea2627d555fbdd20f4007bbdaf';

/// See also [logoutUseCase].
@ProviderFor(logoutUseCase)
final logoutUseCaseProvider = AutoDisposeProvider<LogoutUseCase>.internal(
  logoutUseCase,
  name: r'logoutUseCaseProvider',
  debugGetCreateSourceHash: const bool.fromEnvironment('dart.vm.product')
      ? null
      : _$logoutUseCaseHash,
  dependencies: null,
  allTransitiveDependencies: null,
);

@Deprecated('Will be removed in 3.0. Use Ref instead')
// ignore: unused_element
typedef LogoutUseCaseRef = AutoDisposeProviderRef<LogoutUseCase>;
String _$resetPasswordUseCaseHash() =>
    r'2da12f97cea6ceda016ebfdaee4e9a2458594c25';

/// See also [resetPasswordUseCase].
@ProviderFor(resetPasswordUseCase)
final resetPasswordUseCaseProvider =
    AutoDisposeProvider<ResetPasswordUseCase>.internal(
  resetPasswordUseCase,
  name: r'resetPasswordUseCaseProvider',
  debugGetCreateSourceHash: const bool.fromEnvironment('dart.vm.product')
      ? null
      : _$resetPasswordUseCaseHash,
  dependencies: null,
  allTransitiveDependencies: null,
);

@Deprecated('Will be removed in 3.0. Use Ref instead')
// ignore: unused_element
typedef ResetPasswordUseCaseRef = AutoDisposeProviderRef<ResetPasswordUseCase>;
String _$authStateHash() => r'9088e9f1f4d203dbf4c46a151e64cd74d94abfcf';

/// See also [authState].
@ProviderFor(authState)
final authStateProvider = StreamProvider<UserEntity?>.internal(
  authState,
  name: r'authStateProvider',
  debugGetCreateSourceHash:
      const bool.fromEnvironment('dart.vm.product') ? null : _$authStateHash,
  dependencies: null,
  allTransitiveDependencies: null,
);

@Deprecated('Will be removed in 3.0. Use Ref instead')
// ignore: unused_element
typedef AuthStateRef = StreamProviderRef<UserEntity?>;
String _$authNotifierHash() => r'b57b89562daf526635baec87c7e97bfcdea90fbf';

/// See also [AuthNotifier].
@ProviderFor(AuthNotifier)
final authNotifierProvider =
    AsyncNotifierProvider<AuthNotifier, UserEntity?>.internal(
  AuthNotifier.new,
  name: r'authNotifierProvider',
  debugGetCreateSourceHash:
      const bool.fromEnvironment('dart.vm.product') ? null : _$authNotifierHash,
  dependencies: null,
  allTransitiveDependencies: null,
);

typedef _$AuthNotifier = AsyncNotifier<UserEntity?>;
// ignore_for_file: type=lint
// ignore_for_file: subtype_of_sealed_class, invalid_use_of_internal_member, invalid_use_of_visible_for_testing_member, deprecated_member_use_from_same_package
