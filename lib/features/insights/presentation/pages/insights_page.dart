import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:shimmer/shimmer.dart';

import '../../../../core/constants/app_colors.dart';
import '../../../../core/constants/app_text_styles.dart';
import '../../../../core/routes/route_names.dart';
import '../../../../core/widgets/app_top_bar.dart';
import '../../../../core/widgets/bottom_nav_bar.dart';
import '../../../../core/widgets/error_state.dart';
import '../../domain/entities/insights_entity.dart';
import '../providers/insights_provider.dart';
import '../widgets/capital_flow_chart.dart';
import '../widgets/category_breakdown.dart';
import '../widgets/health_score_ring.dart';
import '../widgets/recommendation_card.dart';

class InsightsPage extends ConsumerWidget {
  const InsightsPage({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final insightsAsync = ref.watch(insightsProvider);

    return Scaffold(
      backgroundColor: AppColors.background,
      body: SafeArea(
        child: Column(
          children: [
            const AppTopBar(),
            Expanded(
              child: insightsAsync.when(
                loading: () => const _InsightsShimmer(),
                error: (e, _) => ErrorState(
                  message: e.toString(),
                  onRetry: () => ref.invalidate(insightsProvider),
                ),
                data: (insights) => _buildContent(context, insights),
              ),
            ),
            const AppBottomNavBar(currentIndex: 1),
          ],
        ),
      ),
    );
  }

  Widget _buildContent(BuildContext context, InsightsEntity insights) {
    return ListView(
      padding: const EdgeInsets.fromLTRB(20, 16, 20, 24),
      children: [
        Text('Financial Health',
            style: AppTextStyles.displayLarge.copyWith(fontSize: 28)),
        const SizedBox(height: 4),
        Text('A read-only look at your money habits.',
            style: AppTextStyles.bodyMedium),
        const SizedBox(height: 20),
        _HealthScoreCard(insights: insights),
        const SizedBox(height: 20),
        CapitalFlowChart(flow: insights.capitalFlowData),
        const SizedBox(height: 20),
        CategoryBreakdown(
          categories: insights.categoryBreakdown,
          onTap: (_) => context.go(RouteNames.expenseList),
        ),
        const SizedBox(height: 20),
        RecommendationCard(recommendations: insights.recommendations),
      ],
    );
  }
}

class _HealthScoreCard extends StatelessWidget {
  final InsightsEntity insights;
  const _HealthScoreCard({required this.insights});

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(24),
      decoration: BoxDecoration(
        color: AppColors.surface,
        borderRadius: BorderRadius.circular(16),
        border: Border.all(color: AppColors.divider, width: 0.5),
      ),
      child: Column(
        children: [
          Text('CURRENT STANDING',
              style: AppTextStyles.labelLarge
                  .copyWith(color: AppColors.textTertiary)),
          const SizedBox(height: 16),
          HealthScoreRing(score: insights.healthScore),
          const SizedBox(height: 20),
          Row(
            children: [
              Expanded(
                child: _StatChip(
                  label: 'MONTHLY YIELD',
                  value:
                      '${insights.monthlyYieldPercent >= 0 ? '+' : ''}${insights.monthlyYieldPercent.toStringAsFixed(1)}%',
                ),
              ),
              const SizedBox(width: 12),
              Expanded(
                child: _StatChip(
                    label: 'RISK PROFILE', value: insights.riskProfile),
              ),
            ],
          ),
        ],
      ),
    );
  }
}

class _StatChip extends StatelessWidget {
  final String label;
  final String value;
  const _StatChip({required this.label, required this.value});

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(14),
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
          const SizedBox(height: 6),
          Text(value, style: AppTextStyles.titleLarge),
        ],
      ),
    );
  }
}

class _InsightsShimmer extends StatelessWidget {
  const _InsightsShimmer();

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(20),
      child: Shimmer.fromColors(
        baseColor: AppColors.surfaceSecondary,
        highlightColor: AppColors.surface,
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            _box(width: 200, height: 28),
            const SizedBox(height: 20),
            _box(height: 260, radius: 16),
            const SizedBox(height: 20),
            _box(height: 240, radius: 16),
          ],
        ),
      ),
    );
  }

  Widget _box({double? width, required double height, double radius = 8}) =>
      Container(
        width: width ?? double.infinity,
        height: height,
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(radius),
        ),
      );
}
