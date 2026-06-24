import 'package:flutter/material.dart';
import 'package:shimmer/shimmer.dart';

import '../../../../core/constants/app_colors.dart';

/// Shimmer placeholder shown while the dashboard loads.
class DashboardShimmer extends StatelessWidget {
  const DashboardShimmer({super.key});

  @override
  Widget build(BuildContext context) {
    return Shimmer.fromColors(
      baseColor: AppColors.surfaceSecondary,
      highlightColor: AppColors.surface,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          _box(width: 160, height: 12),
          const SizedBox(height: 12),
          _box(width: 220, height: 40),
          const SizedBox(height: 8),
          _box(width: 80, height: 24, radius: 100),
          const SizedBox(height: 24),
          _box(height: 150, radius: 16),
          const SizedBox(height: 20),
          _box(height: 110, radius: 16),
          const SizedBox(height: 20),
          _box(width: 180, height: 18),
          const SizedBox(height: 16),
          _box(height: 72, radius: 16),
          const SizedBox(height: 12),
          _box(height: 72, radius: 16),
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
