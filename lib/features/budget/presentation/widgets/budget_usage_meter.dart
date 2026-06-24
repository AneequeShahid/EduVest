import 'package:flutter/material.dart';

import '../../../../core/constants/app_colors.dart';
import '../../../../core/constants/app_text_styles.dart';
import '../../../../core/utils/currency_utils.dart';
import '../../domain/entities/budget_entity.dart';
import '../../domain/entities/budget_status.dart';

class BudgetUsageMeter extends StatelessWidget {
  final BudgetEntity budget;

  const BudgetUsageMeter({super.key, required this.budget});

  static Color colorForStatus(BudgetStatus status) {
    switch (status) {
      case BudgetStatus.good:
        return AppColors.success;
      case BudgetStatus.warning:
        return AppColors.warning;
      case BudgetStatus.critical:
      case BudgetStatus.exceeded:
        return AppColors.error;
    }
  }

  @override
  Widget build(BuildContext context) {
    final color = colorForStatus(budget.budgetStatus);
    final percent = (budget.usagePercent * 100).round();

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Row(
          crossAxisAlignment: CrossAxisAlignment.start,
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text('MONTHLY LIMIT',
                    style: AppTextStyles.labelLarge
                        .copyWith(color: AppColors.textTertiary)),
                const SizedBox(height: 4),
                Text(formatCurrency(budget.totalLimit),
                    style: AppTextStyles.amount),
              ],
            ),
            Column(
              crossAxisAlignment: CrossAxisAlignment.end,
              children: [
                Text('SPENT',
                    style: AppTextStyles.labelLarge
                        .copyWith(color: AppColors.textTertiary)),
                const SizedBox(height: 4),
                Text(formatCurrency(budget.totalSpent),
                    style: AppTextStyles.amountSmall
                        .copyWith(color: AppColors.primary)),
              ],
            ),
          ],
        ),
        const SizedBox(height: 16),
        // Animated progress bar with percentage label.
        ClipRRect(
          borderRadius: BorderRadius.circular(10),
          child: Stack(
            alignment: Alignment.center,
            children: [
              Container(height: 28, color: AppColors.surfaceSecondary),
              Align(
                alignment: Alignment.centerLeft,
                child: LayoutBuilder(
                  builder: (context, c) => AnimatedContainer(
                    key: const Key('budget-progress'),
                    duration: const Duration(milliseconds: 400),
                    curve: Curves.easeInOut,
                    height: 28,
                    width: c.maxWidth * budget.usagePercent,
                    color: color,
                  ),
                ),
              ),
              Text('$percent% USED',
                  style: AppTextStyles.labelLarge.copyWith(
                    color: budget.usagePercent > 0.45
                        ? Colors.white
                        : AppColors.textPrimary,
                  )),
            ],
          ),
        ),
        const SizedBox(height: 10),
        Text(
          'You have ${formatCurrency(budget.remainingAmount)} left for the next ${budget.daysRemaining} days.',
          style: AppTextStyles.bodyMedium,
        ),
      ],
    );
  }
}
