import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';

import '../../../../core/constants/app_colors.dart';
import '../../../../core/constants/app_text_styles.dart';
import '../../../../core/routes/route_names.dart';
import '../../../../core/widgets/app_top_bar.dart';
import '../../../../core/widgets/bottom_nav_bar.dart';
import '../../../../core/widgets/secure_screen.dart';
import '../../../../core/widgets/empty_state.dart';
import '../../../../core/widgets/error_state.dart';
import '../../../../core/widgets/app_button.dart';
import '../providers/budget_provider.dart';
import '../widgets/add_category_sheet.dart';
import '../widgets/budget_shimmer.dart';
import '../widgets/set_budget_sheet.dart';
import '../widgets/budget_usage_meter.dart';
import '../widgets/category_budget_card.dart';
import '../widgets/smart_insight_card.dart';

class BudgetPage extends ConsumerWidget {
  const BudgetPage({super.key});

  void _openAddCategory(BuildContext context, WidgetRef ref) {
    showModalBottomSheet<void>(
      context: context,
      isScrollControlled: true,
      backgroundColor: AppColors.surface,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(24)),
      ),
      builder: (_) => AddCategorySheet(
        onSave: (category) =>
            ref.read(budgetNotifierProvider.notifier).addCategory(category),
      ),
    );
  }

  void _openSetBudget(BuildContext context, WidgetRef ref,
      {double? initialLimit}) {
    showModalBottomSheet<void>(
      context: context,
      isScrollControlled: true,
      backgroundColor: AppColors.surface,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(24)),
      ),
      builder: (_) => SetBudgetSheet(
        initialLimit: initialLimit,
        onSave: (limit) =>
            ref.read(budgetNotifierProvider.notifier).setMonthlyLimit(limit),
      ),
    );
  }

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final budgetAsync = ref.watch(budgetStreamProvider);

    return SecureScreen(
      child: Scaffold(
      backgroundColor: AppColors.background,
      floatingActionButton: budgetAsync.valueOrNull == null
          ? null
          : FloatingActionButton(
              key: const Key('add-category-fab'),
              backgroundColor: AppColors.primary,
              onPressed: () => _openAddCategory(context, ref),
              child: const Icon(Icons.add, color: Colors.white),
            ),
      body: SafeArea(
        child: Column(
          children: [
            const AppTopBar(),
            Expanded(
              child: budgetAsync.when(
                loading: () => const Padding(
                  padding: EdgeInsets.all(20),
                  child: BudgetShimmer(),
                ),
                error: (e, _) => ErrorState(
                  message: e.toString(),
                  onRetry: () => ref.invalidate(budgetStreamProvider),
                ),
                data: (budget) {
                  if (budget == null) {
                    return Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        const EmptyState(
                          title: 'No budget yet',
                          message:
                              'Set a monthly limit to start tracking your spending.',
                          icon: Icons.account_balance_wallet_outlined,
                        ),
                        const SizedBox(height: 16),
                        Padding(
                          padding:
                              const EdgeInsets.symmetric(horizontal: 40),
                          child: AppButton(
                            key: const Key('set-budget-button'),
                            label: 'Set Monthly Budget',
                            onPressed: () => _openSetBudget(context, ref),
                          ),
                        ),
                      ],
                    );
                  }
                  return ListView(
                    padding: const EdgeInsets.fromLTRB(20, 16, 20, 24),
                    children: [
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Text('Budget', style: AppTextStyles.displayMedium),
                          TextButton.icon(
                            key: const Key('edit-budget-button'),
                            onPressed: () => _openSetBudget(context, ref,
                                initialLimit: budget.totalLimit),
                            icon: const Icon(Icons.edit_outlined, size: 18),
                            label: const Text('Edit'),
                          ),
                        ],
                      ),
                      const SizedBox(height: 16),
                      BudgetUsageMeter(budget: budget),
                      const SizedBox(height: 24),
                      Text('Categories', style: AppTextStyles.headlineMedium),
                      const SizedBox(height: 12),
                      if (budget.categories.isEmpty)
                        Text('No categories yet. Tap + to add one.',
                            style: AppTextStyles.bodyMedium)
                      else
                        for (final c in budget.categories) ...[
                          CategoryBudgetCard(
                            category: c,
                            onMarkPaid: (paid) => ref
                                .read(budgetNotifierProvider.notifier)
                                .markAsPaid(c.id, paid),
                          ),
                          const SizedBox(height: 12),
                        ],
                      const SizedBox(height: 12),
                      const _SmartInsightSection(),
                    ],
                  );
                },
              ),
            ),
            const AppBottomNavBar(currentIndex: 3),
          ],
        ),
      ),
      ),
    );
  }
}

class _SmartInsightSection extends ConsumerWidget {
  const _SmartInsightSection();

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final insightsAsync = ref.watch(smartInsightsProvider);

    // Hide entirely until the first computation resolves.
    if (insightsAsync.isLoading && !insightsAsync.hasValue) {
      return const SizedBox.shrink();
    }

    return SmartInsightCard(
      insights: insightsAsync.valueOrNull ?? const [],
      onOptimize: () => context.go(RouteNames.goals),
    );
  }
}
