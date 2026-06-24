import 'dart:async';

import 'package:flutter/material.dart';

import '../../../../core/constants/app_colors.dart';
import '../../../../core/constants/app_text_styles.dart';
import '../../domain/entities/recommendation_entity.dart';

/// Dark "investment tip" card that auto-rotates through recommendations every
/// 5 seconds (and on horizontal swipe).
class RecommendationCard extends StatefulWidget {
  final List<RecommendationEntity> recommendations;
  final VoidCallback? onReadMore;

  const RecommendationCard({
    super.key,
    required this.recommendations,
    this.onReadMore,
  });

  @override
  State<RecommendationCard> createState() => _RecommendationCardState();
}

class _RecommendationCardState extends State<RecommendationCard> {
  int _index = 0;
  Timer? _timer;

  @override
  void initState() {
    super.initState();
    _startTimer();
  }

  void _startTimer() {
    _timer?.cancel();
    if (widget.recommendations.length > 1) {
      _timer = Timer.periodic(const Duration(seconds: 5), (_) => _next());
    }
  }

  void _next() {
    if (widget.recommendations.isEmpty) return;
    setState(() => _index = (_index + 1) % widget.recommendations.length);
  }

  void _prev() {
    if (widget.recommendations.isEmpty) return;
    setState(() => _index =
        (_index - 1 + widget.recommendations.length) %
            widget.recommendations.length);
  }

  @override
  void dispose() {
    _timer?.cancel();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    if (widget.recommendations.isEmpty) return const SizedBox.shrink();
    final rec = widget.recommendations[_index];

    return GestureDetector(
      onHorizontalDragEnd: (details) {
        final v = details.primaryVelocity ?? 0;
        if (v < 0) {
          _next();
        } else if (v > 0) {
          _prev();
        }
      },
      child: Container(
        width: double.infinity,
        padding: const EdgeInsets.all(22),
        decoration: BoxDecoration(
          color: AppColors.backgroundDark,
          borderRadius: BorderRadius.circular(20),
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text('INVESTMENT TIP',
                style: AppTextStyles.labelLarge
                    .copyWith(color: AppColors.primaryLight)),
            const SizedBox(height: 10),
            Text(rec.title,
                style: AppTextStyles.headlineMedium
                    .copyWith(color: Colors.white)),
            const SizedBox(height: 6),
            Text(rec.description,
                style: AppTextStyles.bodyMedium.copyWith(
                  color: Colors.white.withValues(alpha: 0.8),
                  height: 1.5,
                )),
            const SizedBox(height: 12),
            GestureDetector(
              onTap: widget.onReadMore,
              child: Text('Read full analysis',
                  style: AppTextStyles.labelLarge.copyWith(
                    color: AppColors.primaryLight,
                    decoration: TextDecoration.underline,
                  )),
            ),
          ],
        ),
      ),
    );
  }
}
