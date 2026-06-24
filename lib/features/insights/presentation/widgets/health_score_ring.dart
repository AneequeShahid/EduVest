import 'dart:math' as math;

import 'package:flutter/material.dart';

import '../../../../core/constants/app_colors.dart';
import '../../../../core/constants/app_text_styles.dart';

/// Animated circular health-score gauge. The arc grows 0 → score over 1.5s
/// and the number counts up in sync. The painting itself uses a [CustomPainter]
/// (no charting library).
class HealthScoreRing extends StatefulWidget {
  final int score;
  final Duration duration;

  const HealthScoreRing({
    super.key,
    required this.score,
    this.duration = const Duration(milliseconds: 1500),
  });

  String get label {
    if (score >= 80) return 'EXCELLENT';
    if (score >= 60) return 'GOOD';
    if (score >= 40) return 'FAIR';
    return 'NEEDS WORK';
  }

  @override
  State<HealthScoreRing> createState() => _HealthScoreRingState();
}

class _HealthScoreRingState extends State<HealthScoreRing>
    with SingleTickerProviderStateMixin {
  late final AnimationController _controller =
      AnimationController(vsync: this, duration: widget.duration);
  late final Animation<double> _animation =
      CurvedAnimation(parent: _controller, curve: Curves.easeOutCubic);

  @override
  void initState() {
    super.initState();
    _controller.forward();
  }

  @override
  void didUpdateWidget(covariant HealthScoreRing oldWidget) {
    super.didUpdateWidget(oldWidget);
    if (oldWidget.score != widget.score) {
      _controller.forward(from: 0);
    }
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final target = (widget.score.clamp(0, 100)) / 100.0;
    return SizedBox(
      width: 180,
      height: 180,
      child: AnimatedBuilder(
        animation: _animation,
        builder: (context, _) {
          final progress = target * _animation.value;
          final shownScore = (widget.score * _animation.value).round();
          return CustomPaint(
            painter: HealthScoreRingPainter(progress: progress),
            child: Center(
              child: Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  Text('$shownScore',
                      style: AppTextStyles.displayLarge
                          .copyWith(fontSize: 48, color: AppColors.textPrimary)),
                  Text(widget.label,
                      style: AppTextStyles.labelLarge
                          .copyWith(color: AppColors.primary)),
                ],
              ),
            ),
          );
        },
      ),
    );
  }
}

class HealthScoreRingPainter extends CustomPainter {
  /// 0.0–1.0 (score / 100).
  final double progress;
  final Color trackColor;
  final Color arcColor;
  final double strokeWidth;

  HealthScoreRingPainter({
    required this.progress,
    this.trackColor = const Color(0xFFF2EDE5),
    this.arcColor = AppColors.primary,
    this.strokeWidth = 14,
  });

  /// The swept angle in radians: progress × 2π.
  double get sweepAngle => progress.clamp(0.0, 1.0) * 2 * math.pi;

  @override
  void paint(Canvas canvas, Size size) {
    final center = size.center(Offset.zero);
    final radius = (size.shortestSide - strokeWidth) / 2;

    final track = Paint()
      ..color = trackColor
      ..style = PaintingStyle.stroke
      ..strokeWidth = strokeWidth;
    canvas.drawCircle(center, radius, track);

    if (progress <= 0) return;
    final arc = Paint()
      ..color = arcColor
      ..style = PaintingStyle.stroke
      ..strokeWidth = strokeWidth
      ..strokeCap = StrokeCap.round;
    canvas.drawArc(
      Rect.fromCircle(center: center, radius: radius),
      -math.pi / 2, // start at top
      sweepAngle,
      false,
      arc,
    );
  }

  @override
  bool shouldRepaint(covariant HealthScoreRingPainter oldDelegate) =>
      oldDelegate.progress != progress;
}
