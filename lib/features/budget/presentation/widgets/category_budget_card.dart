import 'package:flutter/material.dart';

import '../../../../core/constants/app_colors.dart';
import '../../../../core/constants/app_text_styles.dart';
import '../../../../core/utils/currency_utils.dart';
import '../../../../core/widgets/category_icon.dart';
import '../../../../core/widgets/custom_progress_bar.dart';
import '../../domain/entities/budget_category_entity.dart';

class CategoryBudgetCard extends StatelessWidget {
  final BudgetCategoryEntity category;
  final ValueChanged<bool>? onMarkPaid;
  final VoidCallback? onTap;

  const CategoryBudgetCard({
    super.key,
    required this.category,
    this.onMarkPaid,
    this.onTap,
  });

  /// Green under 70%, amber 70–90%, red above 90%.
  static Color progressColor(double usage) {
    if (usage > 0.9) return AppColors.error;
    if (usage >= 0.7) return AppColors.warning;
    return AppColors.success;
  }

  @override
  Widget build(BuildContext context) {
    final color = progressColor(category.usagePercent);

    return InkWell(
      onTap: onTap,
      borderRadius: BorderRadius.circular(16),
      child: Container(
        key: Key('category-card-${category.name}'),
        padding: const EdgeInsets.all(16),
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
                CategoryIcon(category: category.name, size: 40),
                const SizedBox(width: 12),
                Expanded(
                  child: Text(category.name, style: AppTextStyles.titleLarge),
                ),
                if (category.isPaid) const _PaidBadge(),
                if (!category.isPaid)
                  Text(
                    '${formatCurrency(category.spent)} / ${formatCurrency(category.limit)}',
                    style: AppTextStyles.titleMedium.copyWith(color: color),
                  ),
              ],
            ),
            const SizedBox(height: 12),
            CustomProgressBar(
              value: category.usagePercent,
              height: 8,
              foregroundColor: color,
            ),
            if (onMarkPaid != null) ...[
              const SizedBox(height: 4),
              Row(
                children: [
                  Text('Mark as paid', style: AppTextStyles.bodySmall),
                  const Spacer(),
                  Switch(
                    value: category.isPaid,
                    activeThumbColor: AppColors.primary,
                    onChanged: onMarkPaid,
                  ),
                ],
              ),
            ],
          ],
        ),
      ),
    );
  }
}

class _PaidBadge extends StatelessWidget {
  const _PaidBadge();

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
      decoration: BoxDecoration(
        color: AppColors.success.withValues(alpha: 0.12),
        borderRadius: BorderRadius.circular(100),
      ),
      child: Text(
        'PAID',
        style: AppTextStyles.labelLarge.copyWith(color: AppColors.success),
      ),
    );
  }
}
