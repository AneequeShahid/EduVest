import 'package:flutter/material.dart';
import 'package:shimmer/shimmer.dart';

import '../../../../core/constants/app_colors.dart';

class BudgetShimmer extends StatelessWidget {
  const BudgetShimmer({super.key});

  @override
  Widget build(BuildContext context) {
    return Shimmer.fromColors(
      baseColor: AppColors.surfaceSecondary,
      highlightColor: AppColors.surface,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          _box(width: 140, height: 12),
          const SizedBox(height: 10),
          _box(width: 220, height: 38),
          const SizedBox(height: 16),
          _box(height: 32, radius: 100),
          const SizedBox(height: 24),
          _box(height: 96, radius: 16),
          const SizedBox(height: 12),
          _box(height: 96, radius: 16),
          const SizedBox(height: 12),
          _box(height: 120, radius: 16),
        ],
      ),
    );
  }

  Widget _box({double? width, required double height, double radius = 8}) {
    return Container(
      width: width ?? double.infinity,
      height: height,
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(radius),
      ),
    );
  }
}
