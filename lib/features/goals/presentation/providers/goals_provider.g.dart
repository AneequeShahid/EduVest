// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'goals_provider.dart';

// **************************************************************************
// RiverpodGenerator
// **************************************************************************

String _$goalsRepositoryHash() => r'59cbf67d579797fb5db0fe3535bf5dc28c17b06a';

/// See also [goalsRepository].
@ProviderFor(goalsRepository)
final goalsRepositoryProvider = AutoDisposeProvider<GoalsRepository>.internal(
  goalsRepository,
  name: r'goalsRepositoryProvider',
  debugGetCreateSourceHash: const bool.fromEnvironment('dart.vm.product')
      ? null
      : _$goalsRepositoryHash,
  dependencies: null,
  allTransitiveDependencies: null,
);

@Deprecated('Will be removed in 3.0. Use Ref instead')
// ignore: unused_element
typedef GoalsRepositoryRef = AutoDisposeProviderRef<GoalsRepository>;
String _$createGoalUseCaseHash() => r'688bc09c7b8a04ce4ef2b5aed95c7e56f93f3dd4';

/// See also [createGoalUseCase].
@ProviderFor(createGoalUseCase)
final createGoalUseCaseProvider =
    AutoDisposeProvider<CreateGoalUseCase>.internal(
  createGoalUseCase,
  name: r'createGoalUseCaseProvider',
  debugGetCreateSourceHash: const bool.fromEnvironment('dart.vm.product')
      ? null
      : _$createGoalUseCaseHash,
  dependencies: null,
  allTransitiveDependencies: null,
);

@Deprecated('Will be removed in 3.0. Use Ref instead')
// ignore: unused_element
typedef CreateGoalUseCaseRef = AutoDisposeProviderRef<CreateGoalUseCase>;
String _$addFundsUseCaseHash() => r'6faa263981c05a97b9372ed50c1ecb8396ee3984';

/// See also [addFundsUseCase].
@ProviderFor(addFundsUseCase)
final addFundsUseCaseProvider = AutoDisposeProvider<AddFundsUseCase>.internal(
  addFundsUseCase,
  name: r'addFundsUseCaseProvider',
  debugGetCreateSourceHash: const bool.fromEnvironment('dart.vm.product')
      ? null
      : _$addFundsUseCaseHash,
  dependencies: null,
  allTransitiveDependencies: null,
);

@Deprecated('Will be removed in 3.0. Use Ref instead')
// ignore: unused_element
typedef AddFundsUseCaseRef = AutoDisposeProviderRef<AddFundsUseCase>;
String _$adjustPlanUseCaseHash() => r'd3f5beaf1e5fe69493c38f17ee15558b130f3b2c';

/// See also [adjustPlanUseCase].
@ProviderFor(adjustPlanUseCase)
final adjustPlanUseCaseProvider =
    AutoDisposeProvider<AdjustPlanUseCase>.internal(
  adjustPlanUseCase,
  name: r'adjustPlanUseCaseProvider',
  debugGetCreateSourceHash: const bool.fromEnvironment('dart.vm.product')
      ? null
      : _$adjustPlanUseCaseHash,
  dependencies: null,
  allTransitiveDependencies: null,
);

@Deprecated('Will be removed in 3.0. Use Ref instead')
// ignore: unused_element
typedef AdjustPlanUseCaseRef = AutoDisposeProviderRef<AdjustPlanUseCase>;
String _$deleteGoalUseCaseHash() => r'b51506753f261f6216d9345c27cce030c7b99678';

/// See also [deleteGoalUseCase].
@ProviderFor(deleteGoalUseCase)
final deleteGoalUseCaseProvider =
    AutoDisposeProvider<DeleteGoalUseCase>.internal(
  deleteGoalUseCase,
  name: r'deleteGoalUseCaseProvider',
  debugGetCreateSourceHash: const bool.fromEnvironment('dart.vm.product')
      ? null
      : _$deleteGoalUseCaseHash,
  dependencies: null,
  allTransitiveDependencies: null,
);

@Deprecated('Will be removed in 3.0. Use Ref instead')
// ignore: unused_element
typedef DeleteGoalUseCaseRef = AutoDisposeProviderRef<DeleteGoalUseCase>;
String _$goalsStreamHash() => r'72ac02684aeb3994dc902cd6e2315972668cbe66';

/// See also [goalsStream].
@ProviderFor(goalsStream)
final goalsStreamProvider =
    AutoDisposeStreamProvider<List<GoalEntity>>.internal(
  goalsStream,
  name: r'goalsStreamProvider',
  debugGetCreateSourceHash:
      const bool.fromEnvironment('dart.vm.product') ? null : _$goalsStreamHash,
  dependencies: null,
  allTransitiveDependencies: null,
);

@Deprecated('Will be removed in 3.0. Use Ref instead')
// ignore: unused_element
typedef GoalsStreamRef = AutoDisposeStreamProviderRef<List<GoalEntity>>;
String _$totalSavedHash() => r'0a54941af30e1fa444bcd50865e0e6da7099a712';

/// Total saved across all goals.
///
/// Copied from [totalSaved].
@ProviderFor(totalSaved)
final totalSavedProvider = AutoDisposeProvider<double>.internal(
  totalSaved,
  name: r'totalSavedProvider',
  debugGetCreateSourceHash:
      const bool.fromEnvironment('dart.vm.product') ? null : _$totalSavedHash,
  dependencies: null,
  allTransitiveDependencies: null,
);

@Deprecated('Will be removed in 3.0. Use Ref instead')
// ignore: unused_element
typedef TotalSavedRef = AutoDisposeProviderRef<double>;
String _$selectedGoalHash() => r'7ed93a1df14b6c7186e6e82f3d0b6675eb54968d';

/// The currently selected goal, resolved against the live goals list.
///
/// Copied from [selectedGoal].
@ProviderFor(selectedGoal)
final selectedGoalProvider = AutoDisposeProvider<GoalEntity?>.internal(
  selectedGoal,
  name: r'selectedGoalProvider',
  debugGetCreateSourceHash:
      const bool.fromEnvironment('dart.vm.product') ? null : _$selectedGoalHash,
  dependencies: null,
  allTransitiveDependencies: null,
);

@Deprecated('Will be removed in 3.0. Use Ref instead')
// ignore: unused_element
typedef SelectedGoalRef = AutoDisposeProviderRef<GoalEntity?>;
String _$recentContributionsHash() =>
    r'0418252083216b6c9f814760651c01809509cda6';

/// Copied from Dart SDK
class _SystemHash {
  _SystemHash._();

  static int combine(int hash, int value) {
    // ignore: parameter_assignments
    hash = 0x1fffffff & (hash + value);
    // ignore: parameter_assignments
    hash = 0x1fffffff & (hash + ((0x0007ffff & hash) << 10));
    return hash ^ (hash >> 6);
  }

  static int finish(int hash) {
    // ignore: parameter_assignments
    hash = 0x1fffffff & (hash + ((0x03ffffff & hash) << 3));
    // ignore: parameter_assignments
    hash = hash ^ (hash >> 11);
    return 0x1fffffff & (hash + ((0x00003fff & hash) << 15));
  }
}

/// See also [recentContributions].
@ProviderFor(recentContributions)
const recentContributionsProvider = RecentContributionsFamily();

/// See also [recentContributions].
class RecentContributionsFamily
    extends Family<AsyncValue<List<ContributionEntity>>> {
  /// See also [recentContributions].
  const RecentContributionsFamily();

  /// See also [recentContributions].
  RecentContributionsProvider call(
    String goalId,
  ) {
    return RecentContributionsProvider(
      goalId,
    );
  }

  @override
  RecentContributionsProvider getProviderOverride(
    covariant RecentContributionsProvider provider,
  ) {
    return call(
      provider.goalId,
    );
  }

  static const Iterable<ProviderOrFamily>? _dependencies = null;

  @override
  Iterable<ProviderOrFamily>? get dependencies => _dependencies;

  static const Iterable<ProviderOrFamily>? _allTransitiveDependencies = null;

  @override
  Iterable<ProviderOrFamily>? get allTransitiveDependencies =>
      _allTransitiveDependencies;

  @override
  String? get name => r'recentContributionsProvider';
}

/// See also [recentContributions].
class RecentContributionsProvider
    extends AutoDisposeFutureProvider<List<ContributionEntity>> {
  /// See also [recentContributions].
  RecentContributionsProvider(
    String goalId,
  ) : this._internal(
          (ref) => recentContributions(
            ref as RecentContributionsRef,
            goalId,
          ),
          from: recentContributionsProvider,
          name: r'recentContributionsProvider',
          debugGetCreateSourceHash:
              const bool.fromEnvironment('dart.vm.product')
                  ? null
                  : _$recentContributionsHash,
          dependencies: RecentContributionsFamily._dependencies,
          allTransitiveDependencies:
              RecentContributionsFamily._allTransitiveDependencies,
          goalId: goalId,
        );

  RecentContributionsProvider._internal(
    super._createNotifier, {
    required super.name,
    required super.dependencies,
    required super.allTransitiveDependencies,
    required super.debugGetCreateSourceHash,
    required super.from,
    required this.goalId,
  }) : super.internal();

  final String goalId;

  @override
  Override overrideWith(
    FutureOr<List<ContributionEntity>> Function(RecentContributionsRef provider)
        create,
  ) {
    return ProviderOverride(
      origin: this,
      override: RecentContributionsProvider._internal(
        (ref) => create(ref as RecentContributionsRef),
        from: from,
        name: null,
        dependencies: null,
        allTransitiveDependencies: null,
        debugGetCreateSourceHash: null,
        goalId: goalId,
      ),
    );
  }

  @override
  AutoDisposeFutureProviderElement<List<ContributionEntity>> createElement() {
    return _RecentContributionsProviderElement(this);
  }

  @override
  bool operator ==(Object other) {
    return other is RecentContributionsProvider && other.goalId == goalId;
  }

  @override
  int get hashCode {
    var hash = _SystemHash.combine(0, runtimeType.hashCode);
    hash = _SystemHash.combine(hash, goalId.hashCode);

    return _SystemHash.finish(hash);
  }
}

@Deprecated('Will be removed in 3.0. Use Ref instead')
// ignore: unused_element
mixin RecentContributionsRef
    on AutoDisposeFutureProviderRef<List<ContributionEntity>> {
  /// The parameter `goalId` of this provider.
  String get goalId;
}

class _RecentContributionsProviderElement
    extends AutoDisposeFutureProviderElement<List<ContributionEntity>>
    with RecentContributionsRef {
  _RecentContributionsProviderElement(super.provider);

  @override
  String get goalId => (origin as RecentContributionsProvider).goalId;
}

String _$selectedGoalIdHash() => r'14202ce8f18afc50b853b4bc87ae83fcccbd6d60';

/// See also [SelectedGoalId].
@ProviderFor(SelectedGoalId)
final selectedGoalIdProvider =
    AutoDisposeNotifierProvider<SelectedGoalId, String?>.internal(
  SelectedGoalId.new,
  name: r'selectedGoalIdProvider',
  debugGetCreateSourceHash: const bool.fromEnvironment('dart.vm.product')
      ? null
      : _$selectedGoalIdHash,
  dependencies: null,
  allTransitiveDependencies: null,
);

typedef _$SelectedGoalId = AutoDisposeNotifier<String?>;
String _$goalsNotifierHash() => r'd36a83fb2805e712367d1872b51d7280923f0848';

/// See also [GoalsNotifier].
@ProviderFor(GoalsNotifier)
final goalsNotifierProvider =
    AutoDisposeNotifierProvider<GoalsNotifier, String?>.internal(
  GoalsNotifier.new,
  name: r'goalsNotifierProvider',
  debugGetCreateSourceHash: const bool.fromEnvironment('dart.vm.product')
      ? null
      : _$goalsNotifierHash,
  dependencies: null,
  allTransitiveDependencies: null,
);

typedef _$GoalsNotifier = AutoDisposeNotifier<String?>;
// ignore_for_file: type=lint
// ignore_for_file: subtype_of_sealed_class, invalid_use_of_internal_member, invalid_use_of_visible_for_testing_member, deprecated_member_use_from_same_package
