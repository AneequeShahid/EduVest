import 'package:flutter/material.dart';

import '../../../../core/constants/app_colors.dart';
import '../../../../core/constants/app_text_styles.dart';
import '../../../../core/utils/currency_utils.dart';

class BalanceCard extends StatelessWidget {
  final double totalBalance;
  final double changePercent;

  const BalanceCard({
    super.key,
    required this.totalBalance,
    this.changePercent = 0,
  });

  @override
  Widget build(BuildContext context) {
    final isPositive = changePercent >= 0;
    final pillColor = isPositive ? AppColors.income : AppColors.expense;

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          'TOTAL AVAILABLE BALANCE',
          style: AppTextStyles.labelLarge.copyWith(
            color: AppColors.textTertiary,
            letterSpacing: 1.2,
          ),
        ),
        const SizedBox(height: 6),
        Text(
          formatCurrency(totalBalance),
          style: AppTextStyles.amount,
        ),
        const SizedBox(height: 8),
        Container(
          padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
          decoration: BoxDecoration(
            color: pillColor.withValues(alpha: 0.12),
            borderRadius: BorderRadius.circular(100),
          ),
          child: Row(
            mainAxisSize: MainAxisSize.min,
            children: [
              Icon(
                isPositive ? Icons.trending_up : Icons.trending_down,
                size: 14,
                color: pillColor,
              ),
              const SizedBox(width: 4),
              Text(
                '${isPositive ? '+' : ''}${changePercent.toStringAsFixed(1)}%',
                style: AppTextStyles.labelLarge.copyWith(color: pillColor),
              ),
            ],
          ),
        ),
      ],
    );
  }
}
