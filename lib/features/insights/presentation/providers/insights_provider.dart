import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';

import '../../../authentication/presentation/providers/auth_provider.dart';
import '../../../budget/presentation/providers/budget_provider.dart';
import '../../../expense/presentation/providers/expense_provider.dart';
import '../../../goals/presentation/providers/goals_provider.dart';
import '../../data/repositories/insights_repository_impl.dart';
import '../../data/sources/insights_remote_source.dart';
import '../../domain/entities/insights_entity.dart';
import '../../domain/repositories/insights_repository.dart';
import '../../domain/usecases/get_insights_usecase.dart';

part 'insights_provider.g.dart';

@riverpod
InsightsRepository insightsRepository(Ref ref) =>
    InsightsRepositoryImpl(InsightsRemoteSource());

@riverpod
GetInsightsUseCase getInsightsUseCase(Ref ref) =>
    GetInsightsUseCase(ref.watch(insightsRepositoryProvider));

/// Read-only insights, recomputed whenever the underlying expense, budget or
/// goals data changes.
@riverpod
Future<InsightsEntity> insights(Ref ref) async {
  // Recompute when any source stream emits.
  ref.watch(expensesStreamProvider);
  ref.watch(budgetStreamProvider);
  ref.watch(goalsStreamProvider);

  final uid = ref.watch(authStateProvider).valueOrNull?.id ?? '';
  final now = DateTime.now();
  final result = await ref
      .watch(getInsightsUseCaseProvider)
      .call(uid, now.month, now.year);
  return result.fold(
    (failure) => throw Exception(failure.message),
    (insights) => insights,
  );
}
