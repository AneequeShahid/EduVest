import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';

import '../../../authentication/presentation/providers/auth_provider.dart';
import '../../data/repositories/budget_repository_impl.dart';
import '../../data/sources/budget_remote_source.dart';
import '../../domain/entities/budget_category_entity.dart';
import '../../domain/entities/budget_entity.dart';
import '../../domain/entities/smart_insight_entity.dart';
import '../../domain/repositories/budget_repository.dart';
import '../../domain/usecases/add_budget_category_usecase.dart';
import '../../domain/usecases/delete_budget_category_usecase.dart';
import '../../domain/usecases/get_smart_insights_usecase.dart';
import '../../domain/usecases/set_monthly_limit_usecase.dart';
import '../../domain/usecases/update_budget_category_usecase.dart';

part 'budget_provider.g.dart';

// ── DI ───────────────────────────────────────────────────────────────────────

@riverpod
BudgetRepository budgetRepository(Ref ref) =>
    BudgetRepositoryImpl(BudgetRemoteSource());

@riverpod
SetMonthlyLimitUseCase setMonthlyLimitUseCase(Ref ref) =>
    SetMonthlyLimitUseCase(ref.watch(budgetRepositoryProvider));

@riverpod
AddBudgetCategoryUseCase addBudgetCategoryUseCase(Ref ref) =>
    AddBudgetCategoryUseCase(ref.watch(budgetRepositoryProvider));

@riverpod
UpdateBudgetCategoryUseCase updateBudgetCategoryUseCase(Ref ref) =>
    UpdateBudgetCategoryUseCase(ref.watch(budgetRepositoryProvider));

@riverpod
DeleteBudgetCategoryUseCase deleteBudgetCategoryUseCase(Ref ref) =>
    DeleteBudgetCategoryUseCase(ref.watch(budgetRepositoryProvider));

const _smartInsights = GetSmartInsightsUseCase();

// ── Current month/year ──────────────────────────────────────────────────────

typedef BudgetPeriod = ({int month, int year});

@riverpod
BudgetPeriod budgetPeriod(Ref ref) {
  final now = DateTime.now();
  return (month: now.month, year: now.year);
}

// ── Real-time budget stream ──────────────────────────────────────────────────

@riverpod
Stream<BudgetEntity?> budgetStream(Ref ref) {
  final uid = ref.watch(authStateProvider).valueOrNull?.id ?? '';
  final period = ref.watch(budgetPeriodProvider);
  return ref
      .watch(budgetRepositoryProvider)
      .watchBudget(uid, period.month, period.year);
}

// ── Smart insights ──────────────────────────────────────────────────────────

@riverpod
Future<List<SmartInsightEntity>> smartInsights(Ref ref) {
  final budget = ref.watch(budgetStreamProvider).valueOrNull;
  if (budget == null) return Future.value(const []);
  return ref.read(budgetNotifierProvider.notifier).getSmartInsights();
}

// ── Mutations controller ────────────────────────────────────────────────────

@riverpod
class BudgetNotifier extends _$BudgetNotifier {
  @override
  String? build() => null; // last error message

  String get _uid => ref.read(authStateProvider).valueOrNull?.id ?? '';
  BudgetPeriod get _period => ref.read(budgetPeriodProvider);

  Future<bool> setMonthlyLimit(double limit) => _run((p) => ref
      .read(setMonthlyLimitUseCaseProvider)
      .call(_uid, p.month, p.year, limit));

  Future<bool> addCategory(BudgetCategoryEntity category) => _run((p) => ref
      .read(addBudgetCategoryUseCaseProvider)
      .call(_uid, p.month, p.year, category));

  Future<bool> updateCategory(BudgetCategoryEntity category) => _run((p) => ref
      .read(updateBudgetCategoryUseCaseProvider)
      .call(_uid, p.month, p.year, category));

  Future<bool> deleteCategory(String categoryId) => _run((p) => ref
      .read(deleteBudgetCategoryUseCaseProvider)
      .call(_uid, p.month, p.year, categoryId));

  Future<bool> markAsPaid(String categoryId, bool isPaid) => _run((p) => ref
      .read(budgetRepositoryProvider)
      .markAsPaid(_uid, p.month, p.year, categoryId, isPaid));

  Future<bool> _run(
    Future<dynamic> Function(BudgetPeriod period) action,
  ) async {
    final result = await action(_period);
    return result.fold(
      (f) {
        state = f.message as String?;
        return false;
      },
      (_) {
        state = null;
        return true;
      },
    );
  }

  /// Computes smart insights for the current budget by comparing this month's
  /// per-category spend against the trailing 3-month average.
  Future<List<SmartInsightEntity>> getSmartInsights() async {
    final budget = ref.read(budgetStreamProvider).valueOrNull;
    if (budget == null) return const [];

    final period = _period;
    final repo = ref.read(budgetRepositoryProvider);
    final avg = await repo.getThreeMonthAverageByCategory(
        _uid, period.month, period.year);

    final inputs = budget.categories
        .map((c) => (
              name: c.name,
              spent: c.spent,
              limit: c.limit,
              avg3m: avg[c.name] ?? 0.0,
            ))
        .toList();

    return _smartInsights.call(
      categories: inputs,
      remaining: budget.remainingAmount,
      dailyAllowance: budget.dailyAllowance,
      monthsOfHistory: avg.isEmpty ? 0 : 3,
    );
  }
}
