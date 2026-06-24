// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'home_provider.dart';

// **************************************************************************
// RiverpodGenerator
// **************************************************************************

String _$homeRepositoryHash() => r'4dbcdff572d5194283a03e206591918cb726ee1f';

/// See also [homeRepository].
@ProviderFor(homeRepository)
final homeRepositoryProvider = AutoDisposeProvider<HomeRepository>.internal(
  homeRepository,
  name: r'homeRepositoryProvider',
  debugGetCreateSourceHash: const bool.fromEnvironment('dart.vm.product')
      ? null
      : _$homeRepositoryHash,
  dependencies: null,
  allTransitiveDependencies: null,
);

@Deprecated('Will be removed in 3.0. Use Ref instead')
// ignore: unused_element
typedef HomeRepositoryRef = AutoDisposeProviderRef<HomeRepository>;
String _$getDashboardUseCaseHash() =>
    r'718e7f4cebfd25e4adbab6dc717c6fb9448bcd94';

/// See also [getDashboardUseCase].
@ProviderFor(getDashboardUseCase)
final getDashboardUseCaseProvider =
    AutoDisposeProvider<GetDashboardUseCase>.internal(
  getDashboardUseCase,
  name: r'getDashboardUseCaseProvider',
  debugGetCreateSourceHash: const bool.fromEnvironment('dart.vm.product')
      ? null
      : _$getDashboardUseCaseHash,
  dependencies: null,
  allTransitiveDependencies: null,
);

@Deprecated('Will be removed in 3.0. Use Ref instead')
// ignore: unused_element
typedef GetDashboardUseCaseRef = AutoDisposeProviderRef<GetDashboardUseCase>;
String _$recentTransactionsHash() =>
    r'4de86405acd24d88b864ff10fe2ace2a68f63b33';

/// See also [recentTransactions].
@ProviderFor(recentTransactions)
final recentTransactionsProvider =
    AutoDisposeStreamProvider<List<TransactionEntity>>.internal(
  recentTransactions,
  name: r'recentTransactionsProvider',
  debugGetCreateSourceHash: const bool.fromEnvironment('dart.vm.product')
      ? null
      : _$recentTransactionsHash,
  dependencies: null,
  allTransitiveDependencies: null,
);

@Deprecated('Will be removed in 3.0. Use Ref instead')
// ignore: unused_element
typedef RecentTransactionsRef
    = AutoDisposeStreamProviderRef<List<TransactionEntity>>;
String _$homeNotifierHash() => r'3e6e91c8e62cc53d3d43af36ff1570d2b326f6ea';

/// See also [HomeNotifier].
@ProviderFor(HomeNotifier)
final homeNotifierProvider =
    AutoDisposeAsyncNotifierProvider<HomeNotifier, DashboardEntity>.internal(
  HomeNotifier.new,
  name: r'homeNotifierProvider',
  debugGetCreateSourceHash:
      const bool.fromEnvironment('dart.vm.product') ? null : _$homeNotifierHash,
  dependencies: null,
  allTransitiveDependencies: null,
);

typedef _$HomeNotifier = AutoDisposeAsyncNotifier<DashboardEntity>;
// ignore_for_file: type=lint
// ignore_for_file: subtype_of_sealed_class, invalid_use_of_internal_member, invalid_use_of_visible_for_testing_member, deprecated_member_use_from_same_package
