import 'package:flutter/material.dart';

import '../../../../core/constants/app_colors.dart';
import '../../../../core/constants/app_text_styles.dart';
import '../../../../core/utils/currency_utils.dart';
import '../../../../core/widgets/category_icon.dart';
import '../../domain/entities/category_spend_entity.dart';

class CategoryBreakdown extends StatelessWidget {
  final List<CategorySpendEntity> categories;
  final ValueChanged<CategorySpendEntity>? onTap;

  const CategoryBreakdown({super.key, required this.categories, this.onTap});

  @override
  Widget build(BuildContext context) {
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
          Text('PORTFOLIO MIX',
              style: AppTextStyles.labelLarge
                  .copyWith(color: AppColors.textTertiary)),
          const SizedBox(height: 6),
          Text('Categories', style: AppTextStyles.displayMedium),
          const SizedBox(height: 16),
          if (categories.isEmpty)
            Text('No spending yet this month.',
                style: AppTextStyles.bodyMedium)
          else
            for (final c in categories)
              Padding(
                padding: const EdgeInsets.only(bottom: 12),
                child: InkWell(
                  onTap: onTap == null ? null : () => onTap!(c),
                  child: Row(
                    children: [
                      CategoryIcon(category: c.category),
                      const SizedBox(width: 12),
                      Expanded(
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(c.category,
                                style: AppTextStyles.titleMedium),
                            Text('${c.percentOfTotal.toStringAsFixed(0)}%',
                                style: AppTextStyles.bodySmall),
                          ],
                        ),
                      ),
                      Text(formatCurrency(c.totalSpent),
                          style: AppTextStyles.titleLarge),
                    ],
                  ),
                ),
              ),
        ],
      ),
    );
  }
}
