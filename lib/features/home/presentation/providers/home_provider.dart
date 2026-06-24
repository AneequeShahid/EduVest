import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';

import '../../../authentication/presentation/providers/auth_provider.dart';
import '../../data/repositories/home_repository_impl.dart';
import '../../data/sources/home_remote_source.dart';
import '../../domain/entities/dashboard_entity.dart';
import '../../domain/entities/transaction_entity.dart';
import '../../domain/repositories/home_repository.dart';
import '../../domain/usecases/get_dashboard_usecase.dart';

part 'home_provider.g.dart';

// ── DI ───────────────────────────────────────────────────────────────────────

@riverpod
HomeRepository homeRepository(Ref ref) {
  final uid = ref.watch(authStateProvider).valueOrNull?.id ?? '';
  return HomeRepositoryImpl(HomeRemoteSource(uid: uid), uid: uid);
}

@riverpod
GetDashboardUseCase getDashboardUseCase(Ref ref) =>
    GetDashboardUseCase(ref.watch(homeRepositoryProvider));

// ── Dashboard notifier ───────────────────────────────────────────────────────

@riverpod
class HomeNotifier extends _$HomeNotifier {
  @override
  Future<DashboardEntity> build() {
    // Re-fetch the dashboard whenever the live transaction stream changes so
    // the balance/budget reflect newly-added expenses in real time.
    ref.watch(recentTransactionsProvider);
    return _load();
  }

  Future<DashboardEntity> _load() async {
    final result = await ref.read(getDashboardUseCaseProvider).call();
    return result.fold(
      (failure) => throw Exception(failure.message),
      (dashboard) => dashboard,
    );
  }

  /// Re-fetches the dashboard, surfacing loading/error via [state].
  Future<void> refresh() async {
    state = const AsyncLoading();
    state = await AsyncValue.guard(_load);
  }
}

// ── Real-time recent transactions ──────────────────────────────────────────────

@riverpod
Stream<List<TransactionEntity>> recentTransactions(Ref ref) {
  return ref.watch(homeRepositoryProvider).watchRecentTransactions();
}
