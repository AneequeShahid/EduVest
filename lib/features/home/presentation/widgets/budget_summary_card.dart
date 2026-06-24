import 'package:flutter/material.dart';

import '../../../../core/constants/app_colors.dart';
import '../../../../core/constants/app_text_styles.dart';
import '../../../../core/utils/currency_utils.dart';
import '../../../../core/utils/date_utils.dart';
import '../../../../core/widgets/custom_progress_bar.dart';
import '../../domain/entities/dashboard_entity.dart';

class BudgetSummaryCard extends StatelessWidget {
  final DashboardEntity dashboard;

  const BudgetSummaryCard({super.key, required this.dashboard});

  /// Green under 70%, amber 70–90%, red above 90%.
  Color _progressColor(double progress) {
    if (progress > 0.9) return AppColors.error;
    if (progress >= 0.7) return AppColors.warning;
    return AppColors.success;
  }

  @override
  Widget build(BuildContext context) {
    final now = DateTime.now();
    final progress = dashboard.budgetProgress;
    final color = _progressColor(progress);

    return Container(
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        color: AppColors.surface,
        borderRadius: BorderRadius.circular(16),
        border: Border.all(color: AppColors.divider, width: 0.5),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Text('Monthly Budget', style: AppTextStyles.headlineMedium),
              const Spacer(),
              Text(getMonthName(now.month),
                  style: AppTextStyles.bodyMedium),
              const SizedBox(width: 8),
              const Icon(Icons.account_balance_wallet_outlined,
                  size: 20, color: AppColors.primary),
            ],
          ),
          const SizedBox(height: 16),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text('Spent', style: AppTextStyles.bodyMedium),
              Text(
                '${formatCurrency(dashboard.monthlySpent)} / ${formatCurrency(dashboard.monthlyBudgetLimit)}',
                style: AppTextStyles.titleMedium,
              ),
            ],
          ),
          const SizedBox(height: 10),
          CustomProgressBar(
            value: progress,
            height: 10,
            foregroundColor: color,
          ),
          const SizedBox(height: 16),
          Row(
            children: [
              Expanded(
                child: _SubCard(
                  label: 'REMAINING',
                  value: formatCurrency(dashboard.monthlyRemaining),
                ),
              ),
              const SizedBox(width: 12),
              Expanded(
                child: _SubCard(
                  label: 'DAILY LIMIT',
                  value: formatCurrency(dashboard.dailyLimit),
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }
}

class _SubCard extends StatelessWidget {
  final String label;
  final String value;

  const _SubCard({required this.label, required this.value});

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(12),
      decoration: BoxDecoration(
        color: AppColors.surfaceSecondary,
        borderRadius: BorderRadius.circular(12),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(label,
              style: AppTextStyles.labelLarge
                  .copyWith(color: AppColors.textTertiary)),
          const SizedBox(height: 4),
          Text(value, style: AppTextStyles.amountSmall.copyWith(fontSize: 18)),
        ],
      ),
    );
  }
}
