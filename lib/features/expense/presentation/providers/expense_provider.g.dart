// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'expense_provider.dart';

// **************************************************************************
// RiverpodGenerator
// **************************************************************************

String _$expenseRepositoryHash() => r'be461a3d0a408dc2e22627a8da973a63ac516f98';

/// See also [expenseRepository].
@ProviderFor(expenseRepository)
final expenseRepositoryProvider =
    AutoDisposeProvider<ExpenseRepository>.internal(
  expenseRepository,
  name: r'expenseRepositoryProvider',
  debugGetCreateSourceHash: const bool.fromEnvironment('dart.vm.product')
      ? null
      : _$expenseRepositoryHash,
  dependencies: null,
  allTransitiveDependencies: null,
);

@Deprecated('Will be removed in 3.0. Use Ref instead')
// ignore: unused_element
typedef ExpenseRepositoryRef = AutoDisposeProviderRef<ExpenseRepository>;
String _$addExpenseUseCaseHash() => r'0cffebf62da0f97c52983bdda9ac0978635a9670';

/// See also [addExpenseUseCase].
@ProviderFor(addExpenseUseCase)
final addExpenseUseCaseProvider =
    AutoDisposeProvider<AddExpenseUseCase>.internal(
  addExpenseUseCase,
  name: r'addExpenseUseCaseProvider',
  debugGetCreateSourceHash: const bool.fromEnvironment('dart.vm.product')
      ? null
      : _$addExpenseUseCaseHash,
  dependencies: null,
  allTransitiveDependencies: null,
);

@Deprecated('Will be removed in 3.0. Use Ref instead')
// ignore: unused_element
typedef AddExpenseUseCaseRef = AutoDisposeProviderRef<AddExpenseUseCase>;
String _$updateExpenseUseCaseHash() =>
    r'160b8762bb300a97b0639fbf1b145ef52b8089b7';

/// See also [updateExpenseUseCase].
@ProviderFor(updateExpenseUseCase)
final updateExpenseUseCaseProvider =
    AutoDisposeProvider<UpdateExpenseUseCase>.internal(
  updateExpenseUseCase,
  name: r'updateExpenseUseCaseProvider',
  debugGetCreateSourceHash: const bool.fromEnvironment('dart.vm.product')
      ? null
      : _$updateExpenseUseCaseHash,
  dependencies: null,
  allTransitiveDependencies: null,
);

@Deprecated('Will be removed in 3.0. Use Ref instead')
// ignore: unused_element
typedef UpdateExpenseUseCaseRef = AutoDisposeProviderRef<UpdateExpenseUseCase>;
String _$deleteExpenseUseCaseHash() =>
    r'a5de0f5c1dba8d7e3aa615570724a7b88675c411';

/// See also [deleteExpenseUseCase].
@ProviderFor(deleteExpenseUseCase)
final deleteExpenseUseCaseProvider =
    AutoDisposeProvider<DeleteExpenseUseCase>.internal(
  deleteExpenseUseCase,
  name: r'deleteExpenseUseCaseProvider',
  debugGetCreateSourceHash: const bool.fromEnvironment('dart.vm.product')
      ? null
      : _$deleteExpenseUseCaseHash,
  dependencies: null,
  allTransitiveDependencies: null,
);

@Deprecated('Will be removed in 3.0. Use Ref instead')
// ignore: unused_element
typedef DeleteExpenseUseCaseRef = AutoDisposeProviderRef<DeleteExpenseUseCase>;
String _$getExpensesUseCaseHash() =>
    r'3c22d49abf2f1b43dddf14f759fee9c67be10eca';

/// See also [getExpensesUseCase].
@ProviderFor(getExpensesUseCase)
final getExpensesUseCaseProvider =
    AutoDisposeProvider<GetExpensesUseCase>.internal(
  getExpensesUseCase,
  name: r'getExpensesUseCaseProvider',
  debugGetCreateSourceHash: const bool.fromEnvironment('dart.vm.product')
      ? null
      : _$getExpensesUseCaseHash,
  dependencies: null,
  allTransitiveDependencies: null,
);

@Deprecated('Will be removed in 3.0. Use Ref instead')
// ignore: unused_element
typedef GetExpensesUseCaseRef = AutoDisposeProviderRef<GetExpensesUseCase>;
String _$uploadReceiptUseCaseHash() =>
    r'9723a8902ee86cc9e617f0263385b85fb3e3bf35';

/// See also [uploadReceiptUseCase].
@ProviderFor(uploadReceiptUseCase)
final uploadReceiptUseCaseProvider =
    AutoDisposeProvider<UploadReceiptUseCase>.internal(
  uploadReceiptUseCase,
  name: r'uploadReceiptUseCaseProvider',
  debugGetCreateSourceHash: const bool.fromEnvironment('dart.vm.product')
      ? null
      : _$uploadReceiptUseCaseHash,
  dependencies: null,
  allTransitiveDependencies: null,
);

@Deprecated('Will be removed in 3.0. Use Ref instead')
// ignore: unused_element
typedef UploadReceiptUseCaseRef = AutoDisposeProviderRef<UploadReceiptUseCase>;
String _$expensesStreamHash() => r'1408ab2839815c676884506a96972b27b1376176';

/// See also [expensesStream].
@ProviderFor(expensesStream)
final expensesStreamProvider =
    AutoDisposeStreamProvider<List<ExpenseEntity>>.internal(
  expensesStream,
  name: r'expensesStreamProvider',
  debugGetCreateSourceHash: const bool.fromEnvironment('dart.vm.product')
      ? null
      : _$expensesStreamHash,
  dependencies: null,
  allTransitiveDependencies: null,
);

@Deprecated('Will be removed in 3.0. Use Ref instead')
// ignore: unused_element
typedef ExpensesStreamRef = AutoDisposeStreamProviderRef<List<ExpenseEntity>>;
String _$expenseFilterControllerHash() =>
    r'0bef8caaf0055f8c9a5b86fa83a07b3760f5c501';

/// See also [ExpenseFilterController].
@ProviderFor(ExpenseFilterController)
final expenseFilterControllerProvider = AutoDisposeNotifierProvider<
    ExpenseFilterController, ExpenseFilter>.internal(
  ExpenseFilterController.new,
  name: r'expenseFilterControllerProvider',
  debugGetCreateSourceHash: const bool.fromEnvironment('dart.vm.product')
      ? null
      : _$expenseFilterControllerHash,
  dependencies: null,
  allTransitiveDependencies: null,
);

typedef _$ExpenseFilterController = AutoDisposeNotifier<ExpenseFilter>;
String _$expenseControllerHash() => r'f92b9666555535a6d935ed2cfd0e3ad5f5171ab4';

/// Holds the most recent mutation error message (or null on success/idle).
/// Methods return `true` on success so callers can react synchronously.
///
/// Copied from [ExpenseController].
@ProviderFor(ExpenseController)
final expenseControllerProvider =
    AutoDisposeNotifierProvider<ExpenseController, String?>.internal(
  ExpenseController.new,
  name: r'expenseControllerProvider',
  debugGetCreateSourceHash: const bool.fromEnvironment('dart.vm.product')
      ? null
      : _$expenseControllerHash,
  dependencies: null,
  allTransitiveDependencies: null,
);

typedef _$ExpenseController = AutoDisposeNotifier<String?>;
// ignore_for_file: type=lint
// ignore_for_file: subtype_of_sealed_class, invalid_use_of_internal_member, invalid_use_of_visible_for_testing_member, deprecated_member_use_from_same_package
