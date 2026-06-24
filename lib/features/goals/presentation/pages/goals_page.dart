import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';

import '../../../../core/constants/app_colors.dart';
import '../../../../core/constants/app_text_styles.dart';
import '../../../../core/routes/route_names.dart';
import '../../../../core/utils/currency_utils.dart';
import '../../../../core/widgets/app_top_bar.dart';
import '../../../../core/widgets/bottom_nav_bar.dart';
import '../../../../core/widgets/secure_screen.dart';
import '../../../../core/widgets/empty_state.dart';
import '../../../../core/widgets/error_state.dart';
import '../../domain/entities/goal_entity.dart';
import '../providers/goals_provider.dart';
import '../widgets/add_funds_sheet.dart';
import '../widgets/goal_card.dart';
import '../widgets/goal_completion_animation.dart';

class GoalsPage extends ConsumerStatefulWidget {
  const GoalsPage({super.key});

  @override
  ConsumerState<GoalsPage> createState() => _GoalsPageState();
}

class _GoalsPageState extends ConsumerState<GoalsPage> {
  bool _initialized = false;
  final _seenCompleted = <String>{};
  GoalEntity? _justCompleted;

  void _detectCompletions(List<GoalEntity> goals) {
    if (!_initialized) {
      _initialized = true;
      for (final g in goals) {
        if (g.isCompleted) _seenCompleted.add(g.id);
      }
      return;
    }
    for (final g in goals) {
      if (g.isCompleted && !_seenCompleted.contains(g.id)) {
        _seenCompleted.add(g.id);
        WidgetsBinding.instance.addPostFrameCallback((_) {
          if (mounted) setState(() => _justCompleted = g);
        });
      }
    }
  }

  void _openAddFunds(GoalEntity goal) {
    showModalBottomSheet<void>(
      context: context,
      isScrollControlled: true,
      backgroundColor: AppColors.surface,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(24)),
      ),
      builder: (_) => AddFundsSheet(goal: goal),
    );
  }

  void _openAdjustPlan(GoalEntity goal) {
    final amountCtrl =
        TextEditingController(text: goal.targetAmount.toStringAsFixed(0));
    showModalBottomSheet<void>(
      context: context,
      isScrollControlled: true,
      backgroundColor: AppColors.surface,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(24)),
      ),
      builder: (sheetCtx) => Padding(
        padding: EdgeInsets.only(
          left: 20,
          right: 20,
          top: 20,
          bottom: MediaQuery.of(sheetCtx).viewInsets.bottom + 20,
        ),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text('Adjust Plan', style: AppTextStyles.headlineMedium),
            const SizedBox(height: 16),
            TextField(
              controller: amountCtrl,
              keyboardType:
                  const TextInputType.numberWithOptions(decimal: true),
              decoration: const InputDecoration(labelText: 'Target amount'),
            ),
            const SizedBox(height: 20),
            SizedBox(
              width: double.infinity,
              child: ElevatedButton(
                onPressed: () {
                  final v = double.tryParse(amountCtrl.text);
                  if (v != null && v > 0) {
                    ref
                        .read(goalsNotifierProvider.notifier)
                        .adjustPlan(goal.id, targetAmount: v);
                  }
                  Navigator.of(sheetCtx).pop();
                },
                child: const Text('Save Changes'),
              ),
            ),
          ],
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final goalsAsync = ref.watch(goalsStreamProvider);
    final selected = ref.watch(selectedGoalProvider);

    ref.listen<AsyncValue<List<GoalEntity>>>(goalsStreamProvider,
        (prev, next) {
      final goals = next.valueOrNull;
      if (goals != null) _detectCompletions(goals);
    });

    return SecureScreen(
      child: Scaffold(
      backgroundColor: AppColors.background,
      body: Stack(
        children: [
          SafeArea(
            child: Column(
              children: [
                const AppTopBar(),
                Expanded(
                  child: goalsAsync.when(
                    loading: () => const Center(
                        child: CircularProgressIndicator(
                            color: AppColors.primary)),
                    error: (e, _) => ErrorState(
                      message: e.toString(),
                      onRetry: () => ref.invalidate(goalsStreamProvider),
                    ),
                    data: (goals) => _buildBody(goals, selected),
                  ),
                ),
                const AppBottomNavBar(currentIndex: 4),
              ],
            ),
          ),
          if (_justCompleted != null)
            GoalCompletionAnimation(
              goalTitle: _justCompleted!.title,
              onStartNewGoal: () {
                setState(() => _justCompleted = null);
                context.push(RouteNames.createGoal);
              },
              onBackToGoals: () => setState(() => _justCompleted = null),
            ),
        ],
      ),
      ),
    );
  }

  Widget _buildBody(List<GoalEntity> goals, GoalEntity? selected) {
    return ListView(
      padding: const EdgeInsets.fromLTRB(20, 16, 20, 24),
      children: [
        Text('My Savings Goals', style: AppTextStyles.displayLarge),
        const SizedBox(height: 4),
        Text('Save with intention, one goal at a time.',
            style: AppTextStyles.bodyMedium),
        const SizedBox(height: 20),
        _TotalSavedCard(total: ref.watch(totalSavedProvider)),
        const SizedBox(height: 16),
        Row(
          children: [
            Expanded(
              child: ElevatedButton.icon(
                key: const Key('add-funds-button'),
                onPressed:
                    selected == null ? null : () => _openAddFunds(selected),
                icon: const Icon(Icons.add, size: 18),
                label: const Text('Add Funds'),
              ),
            ),
            const SizedBox(width: 12),
            Expanded(
              child: OutlinedButton.icon(
                key: const Key('adjust-plan-button'),
                onPressed:
                    selected == null ? null : () => _openAdjustPlan(selected),
                icon: const Icon(Icons.tune, size: 18),
                label: const Text('Adjust Plan'),
              ),
            ),
          ],
        ),
        const SizedBox(height: 20),
        if (goals.isEmpty)
          const EmptyState(
            title: 'No goals yet',
            message: 'Create your first savings goal to get started.',
            icon: Icons.savings_outlined,
          )
        else
          for (final g in goals) ...[
            GoalCard(
              goal: g,
              isSelected: selected?.id == g.id,
              onTap: () =>
                  ref.read(goalsNotifierProvider.notifier).selectGoal(g.id),
            ),
            const SizedBox(height: 14),
          ],
        const SizedBox(height: 8),
        _CreateGoalButton(
          onTap: () => context.push(RouteNames.createGoal),
        ),
      ],
    );
  }
}

class _TotalSavedCard extends StatelessWidget {
  final double total;
  const _TotalSavedCard({required this.total});

  @override
  Widget build(BuildContext context) {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        color: AppColors.surface,
        borderRadius: BorderRadius.circular(16),
        border: Border.all(color: AppColors.divider, width: 0.5),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text('TOTAL SAVED',
              style: AppTextStyles.labelLarge
                  .copyWith(color: AppColors.textTertiary)),
          const SizedBox(height: 6),
          Text(formatCurrency(total), style: AppTextStyles.amount),
        ],
      ),
    );
  }
}

class _CreateGoalButton extends StatelessWidget {
  final VoidCallback onTap;
  const _CreateGoalButton({required this.onTap});

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      key: const Key('create-goal-button'),
      onTap: onTap,
      child: Container(
        height: 72,
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(16),
          border: Border.all(color: AppColors.textTertiary, width: 1.2),
        ),
        child: const Center(
          child: Row(
            mainAxisSize: MainAxisSize.min,
            children: [
              Icon(Icons.add_circle_outline, color: AppColors.primary),
              SizedBox(width: 8),
              Text('Create a new goal',
                  style: TextStyle(
                      color: AppColors.primary, fontWeight: FontWeight.w600)),
            ],
          ),
        ),
      ),
    );
  }
}
