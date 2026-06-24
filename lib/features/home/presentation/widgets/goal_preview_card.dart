import 'package:flutter/material.dart';

import '../../../../core/constants/app_colors.dart';
import '../../../../core/constants/app_text_styles.dart';
import '../../../../core/utils/currency_utils.dart';
import '../../../../core/widgets/category_icon.dart';
import '../../../../core/widgets/custom_progress_bar.dart';
import '../../domain/entities/goal_summary_entity.dart';

class GoalPreviewCard extends StatelessWidget {
  final GoalSummaryEntity goal;
  final VoidCallback? onTap;

  const GoalPreviewCard({super.key, required this.goal, this.onTap});

  static const Color _pink = Color(0xFFFCEFEB);
  static const Color _pinkBorder = Color(0xFFF5DDD4);

  @override
  Widget build(BuildContext context) {
    final percent = (goal.progress * 100).round();

    return InkWell(
      onTap: onTap,
      borderRadius: BorderRadius.circular(16),
      child: Container(
        padding: const EdgeInsets.all(16),
        decoration: BoxDecoration(
          color: _pink,
          borderRadius: BorderRadius.circular(16),
          border: Border.all(color: _pinkBorder),
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              children: [
                Text('Savings Goal',
                    style: AppTextStyles.labelLarge
                        .copyWith(color: AppColors.primary)),
                const Spacer(),
                const Icon(Icons.arrow_forward,
                    size: 18, color: AppColors.primary),
              ],
            ),
            const SizedBox(height: 12),
            Row(
              children: [
                CategoryIcon(category: goal.category, size: 48),
                const SizedBox(width: 14),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        goal.title,
                        style: AppTextStyles.displayMedium.copyWith(
                          fontSize: 20,
                          color: AppColors.textPrimary,
                        ),
                        maxLines: 1,
                        overflow: TextOverflow.ellipsis,
                      ),
                      const SizedBox(height: 2),
                      Text(
                        '${formatCurrency(goal.savedAmount)} / ${formatCurrency(goal.targetAmount)}',
                        style: AppTextStyles.bodySmall,
                      ),
                    ],
                  ),
                ),
                Text('$percent%',
                    style: AppTextStyles.headlineMedium
                        .copyWith(color: AppColors.primary)),
              ],
            ),
            const SizedBox(height: 12),
            CustomProgressBar(
              value: goal.progress,
              height: 8,
              foregroundColor: AppColors.primary,
              backgroundColor: Colors.white,
            ),
          ],
        ),
      ),
    );
  }
}
