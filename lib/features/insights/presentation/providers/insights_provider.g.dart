// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'insights_provider.dart';

// **************************************************************************
// RiverpodGenerator
// **************************************************************************

String _$insightsRepositoryHash() =>
    r'e6757153fef11e91cd8a917029670c255160181f';

/// See also [insightsRepository].
@ProviderFor(insightsRepository)
final insightsRepositoryProvider =
    AutoDisposeProvider<InsightsRepository>.internal(
  insightsRepository,
  name: r'insightsRepositoryProvider',
  debugGetCreateSourceHash: const bool.fromEnvironment('dart.vm.product')
      ? null
      : _$insightsRepositoryHash,
  dependencies: null,
  allTransitiveDependencies: null,
);

@Deprecated('Will be removed in 3.0. Use Ref instead')
// ignore: unused_element
typedef InsightsRepositoryRef = AutoDisposeProviderRef<InsightsRepository>;
String _$getInsightsUseCaseHash() =>
    r'887861ec000267de83df411a7312c32e083bcfa9';

/// See also [getInsightsUseCase].
@ProviderFor(getInsightsUseCase)
final getInsightsUseCaseProvider =
    AutoDisposeProvider<GetInsightsUseCase>.internal(
  getInsightsUseCase,
  name: r'getInsightsUseCaseProvider',
  debugGetCreateSourceHash: const bool.fromEnvironment('dart.vm.product')
      ? null
      : _$getInsightsUseCaseHash,
  dependencies: null,
  allTransitiveDependencies: null,
);

@Deprecated('Will be removed in 3.0. Use Ref instead')
// ignore: unused_element
typedef GetInsightsUseCaseRef = AutoDisposeProviderRef<GetInsightsUseCase>;
String _$insightsHash() => r'c9bb3ecd7463dda243c8cc5f96f10d83aeca599a';

/// Read-only insights, recomputed whenever the underlying expense, budget or
/// goals data changes.
///
/// Copied from [insights].
@ProviderFor(insights)
final insightsProvider = AutoDisposeFutureProvider<InsightsEntity>.internal(
  insights,
  name: r'insightsProvider',
  debugGetCreateSourceHash:
      const bool.fromEnvironment('dart.vm.product') ? null : _$insightsHash,
  dependencies: null,
  allTransitiveDependencies: null,
);

@Deprecated('Will be removed in 3.0. Use Ref instead')
// ignore: unused_element
typedef InsightsRef = AutoDisposeFutureProviderRef<InsightsEntity>;
// ignore_for_file: type=lint
// ignore_for_file: subtype_of_sealed_class, invalid_use_of_internal_member, invalid_use_of_visible_for_testing_member, deprecated_member_use_from_same_package
