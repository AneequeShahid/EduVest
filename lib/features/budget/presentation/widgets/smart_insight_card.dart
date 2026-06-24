import 'package:flutter/material.dart';

import '../../../../core/constants/app_colors.dart';
import '../../../../core/constants/app_text_styles.dart';
import '../../domain/entities/smart_insight_entity.dart';

class SmartInsightCard extends StatelessWidget {
  final List<SmartInsightEntity> insights;
  final VoidCallback onOptimize;

  const SmartInsightCard({
    super.key,
    required this.insights,
    required this.onOptimize,
  });

  @override
  Widget build(BuildContext context) {
    final primary = insights.isNotEmpty
        ? insights.first.message
        : 'Track your spending to unlock personalised insights.';

    return Container(
      width: double.infinity,
      padding: const EdgeInsets.all(22),
      decoration: BoxDecoration(
        color: AppColors.backgroundDark,
        borderRadius: BorderRadius.circular(20),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              const Icon(Icons.auto_awesome, size: 20, color: AppColors.primary),
              const SizedBox(width: 8),
              Text('Smart Insight',
                  style: AppTextStyles.headlineMedium
                      .copyWith(color: Colors.white)),
            ],
          ),
          const SizedBox(height: 12),
          Text(
            primary,
            style: AppTextStyles.bodyMedium.copyWith(
              color: Colors.white.withValues(alpha: 0.85),
              height: 1.5,
            ),
          ),
          for (final insight in insights.skip(1)) ...[
            const SizedBox(height: 6),
            Text(
              insight.message,
              style: AppTextStyles.bodySmall.copyWith(
                color: Colors.white.withValues(alpha: 0.6),
              ),
            ),
          ],
          const SizedBox(height: 16),
          SizedBox(
            width: double.infinity,
            child: ElevatedButton(
              onPressed: onOptimize,
              child: const Text('Optimize Now'),
            ),
          ),
        ],
      ),
    );
  }
}
