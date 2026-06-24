import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';

import '../../../authentication/presentation/providers/auth_provider.dart';
import '../../data/repositories/goals_repository_impl.dart';
import '../../data/sources/goals_remote_source.dart';
import '../../domain/entities/contribution_entity.dart';
import '../../domain/entities/goal_entity.dart';
import '../../domain/repositories/goals_repository.dart';
import '../../domain/usecases/add_funds_usecase.dart';
import '../../domain/usecases/adjust_plan_usecase.dart';
import '../../domain/usecases/create_goal_usecase.dart';
import '../../domain/usecases/delete_goal_usecase.dart';

part 'goals_provider.g.dart';

// ── DI ───────────────────────────────────────────────────────────────────────

@riverpod
GoalsRepository goalsRepository(Ref ref) =>
    GoalsRepositoryImpl(GoalsRemoteSource());

@riverpod
CreateGoalUseCase createGoalUseCase(Ref ref) =>
    CreateGoalUseCase(ref.watch(goalsRepositoryProvider));

@riverpod
AddFundsUseCase addFundsUseCase(Ref ref) =>
    AddFundsUseCase(ref.watch(goalsRepositoryProvider));

@riverpod
AdjustPlanUseCase adjustPlanUseCase(Ref ref) =>
    AdjustPlanUseCase(ref.watch(goalsRepositoryProvider));

@riverpod
DeleteGoalUseCase deleteGoalUseCase(Ref ref) =>
    DeleteGoalUseCase(ref.watch(goalsRepositoryProvider));

String _uidOf(Ref ref) => ref.watch(authStateProvider).valueOrNull?.id ?? '';

// ── Goals stream ────────────────────────────────────────────────────────────

@riverpod
Stream<List<GoalEntity>> goalsStream(Ref ref) {
  final uid = _uidOf(ref);
  return ref.watch(goalsRepositoryProvider).watchGoals(uid);
}

/// Total saved across all goals.
@riverpod
double totalSaved(Ref ref) {
  final goals = ref.watch(goalsStreamProvider).valueOrNull ?? const [];
  return goals.fold<double>(0, (sum, g) => sum + g.savedAmount);
}

// ── Selection ────────────────────────────────────────────────────────────────

@riverpod
class SelectedGoalId extends _$SelectedGoalId {
  @override
  String? build() => null;

  void select(String? id) => state = (state == id) ? null : id;
  void clear() => state = null;
}

/// The currently selected goal, resolved against the live goals list.
@riverpod
GoalEntity? selectedGoal(Ref ref) {
  final id = ref.watch(selectedGoalIdProvider);
  if (id == null) return null;
  final goals = ref.watch(goalsStreamProvider).valueOrNull ?? const [];
  for (final g in goals) {
    if (g.id == id) return g;
  }
  return null;
}

// ── Recent contributions (for AddFundsSheet) ─────────────────────────────────

@riverpod
Future<List<ContributionEntity>> recentContributions(
    Ref ref, String goalId) {
  final uid = _uidOf(ref);
  return ref
      .watch(goalsRepositoryProvider)
      .getRecentContributions(uid, goalId);
}

// ── Mutations controller ─────────────────────────────────────────────────────

@riverpod
class GoalsNotifier extends _$GoalsNotifier {
  @override
  String? build() => null; // last error message

  String get _uid => ref.read(authStateProvider).valueOrNull?.id ?? '';

  Future<bool> createGoal(GoalEntity goal) =>
      _run(ref.read(createGoalUseCaseProvider).call(_uid, goal));

  Future<bool> addFunds(String goalId, double amount, String? note) => _run(
      ref.read(addFundsUseCaseProvider).call(_uid, goalId, amount, note));

  Future<bool> adjustPlan(String goalId,
          {double? targetAmount, DateTime? targetDate}) =>
      _run(ref.read(adjustPlanUseCaseProvider).call(_uid, goalId,
          targetAmount: targetAmount, targetDate: targetDate));

  Future<bool> deleteGoal(String goalId) =>
      _run(ref.read(deleteGoalUseCaseProvider).call(_uid, goalId));

  void selectGoal(String? id) =>
      ref.read(selectedGoalIdProvider.notifier).select(id);

  Future<bool> _run(Future<dynamic> result) async {
    final r = await result;
    return r.fold(
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
}
