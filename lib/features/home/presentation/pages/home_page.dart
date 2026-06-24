import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';

import '../../../../core/constants/app_colors.dart';
import '../../../../core/constants/app_text_styles.dart';
import '../../../../core/routes/route_names.dart';
import '../../../../core/widgets/app_top_bar.dart';
import '../../../../core/widgets/bottom_nav_bar.dart';
import '../../../../core/widgets/secure_screen.dart';
import '../../../../core/widgets/error_state.dart';
import '../providers/home_provider.dart';
import '../widgets/balance_card.dart';
import '../widgets/budget_summary_card.dart';
import '../widgets/dashboard_shimmer.dart';
import '../widgets/goal_preview_card.dart';
import '../widgets/transaction_list_item.dart';

class HomePage extends ConsumerWidget {
  const HomePage({super.key});

  String _stripException(Object error) {
    final s = error.toString();
    return s.startsWith('Exception: ')
        ? s.substring('Exception: '.length)
        : s;
  }

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final dashboardAsync = ref.watch(homeNotifierProvider);

    return SecureScreen(
      child: Scaffold(
      backgroundColor: AppColors.background,
      body: SafeArea(
        child: Column(
          children: [
            const AppTopBar(),
            Expanded(
              child: RefreshIndicator(
                color: AppColors.primary,
                onRefresh: () =>
                    ref.read(homeNotifierProvider.notifier).refresh(),
                child: ListView(
                  physics: const AlwaysScrollableScrollPhysics(),
                  padding: const EdgeInsets.fromLTRB(20, 8, 20, 24),
                  children: [
                    dashboardAsync.when(
                      loading: () => const DashboardShimmer(),
                      error: (e, _) => Padding(
                        padding: const EdgeInsets.only(top: 40),
                        child: ErrorState(
                          message: _stripException(e),
                          onRetry: () => ref
                              .read(homeNotifierProvider.notifier)
                              .refresh(),
                        ),
                      ),
                      data: (dashboard) => Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          BalanceCard(
                            totalBalance: dashboard.totalBalance,
                            changePercent: dashboard.balanceChangePercent,
                          ),
                          const SizedBox(height: 24),
                          BudgetSummaryCard(dashboard: dashboard),
                          if (dashboard.activeGoal != null) ...[
                            const SizedBox(height: 20),
                            GoalPreviewCard(
                              goal: dashboard.activeGoal!,
                              onTap: () => context.go(RouteNames.goals),
                            ),
                          ],
                          const SizedBox(height: 24),
                          const _RecentTransactionsSection(),
                        ],
                      ),
                    ),
                  ],
                ),
              ),
            ),
            const AppBottomNavBar(currentIndex: 0),
          ],
        ),
      ),
      ),
    );
  }
}

class _RecentTransactionsSection extends ConsumerWidget {
  const _RecentTransactionsSection();

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final txAsync = ref.watch(recentTransactionsProvider);

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Text('Recent Transactions', style: AppTextStyles.headlineMedium),
            TextButton(
              onPressed: () => context.go(RouteNames.expenseList),
              child: const Text('View All Activity'),
            ),
          ],
        ),
        const SizedBox(height: 8),
        txAsync.when(
          loading: () => const Padding(
            padding: EdgeInsets.symmetric(vertical: 24),
            child: Center(
              child: CircularProgressIndicator(color: AppColors.primary),
            ),
          ),
          error: (e, _) => Padding(
            padding: const EdgeInsets.symmetric(vertical: 16),
            child: Text('Could not load transactions',
                style: AppTextStyles.bodyMedium),
          ),
          data: (transactions) {
            if (transactions.isEmpty) {
              return Padding(
                padding: const EdgeInsets.symmetric(vertical: 32),
                child: Center(
                  child: Text(
                    'No transactions yet. Add your first expense!',
                    textAlign: TextAlign.center,
                    style: AppTextStyles.bodyMedium,
                  ),
                ),
              );
            }
            return Column(
              children: [
                for (final tx in transactions)
                  Padding(
                    padding: const EdgeInsets.only(bottom: 12),
                    child: TransactionListItem(transaction: tx),
                  ),
              ],
            );
          },
        ),
      ],
    );
  }
}
