import 'package:flutter/material.dart';

import '../../../../core/constants/app_colors.dart';
import '../../../../core/constants/app_text_styles.dart';
import '../../../../core/widgets/app_button.dart';

/// Full-screen celebration overlay shown when a goal is completed.
///
/// A Lottie confetti animation can be dropped in at [_Confetti] once a
/// `confetti.json` asset is bundled; until then an animated trophy is shown so
/// the overlay has no asset dependency.
class GoalCompletionAnimation extends StatelessWidget {
  final String goalTitle;
  final VoidCallback onStartNewGoal;
  final VoidCallback onBackToGoals;

  const GoalCompletionAnimation({
    super.key,
    required this.goalTitle,
    required this.onStartNewGoal,
    required this.onBackToGoals,
  });

  @override
  Widget build(BuildContext context) {
    return Material(
      color: Colors.black.withValues(alpha: 0.85),
      child: Center(
        child: Padding(
          padding: const EdgeInsets.all(32),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              const _Confetti(),
              const SizedBox(height: 24),
              Text(
                'Goal Achieved!',
                style: AppTextStyles.displayLarge.copyWith(color: Colors.white),
                textAlign: TextAlign.center,
              ),
              const SizedBox(height: 8),
              Text(
                goalTitle,
                style: AppTextStyles.headlineMedium
                    .copyWith(color: AppColors.primaryLight),
                textAlign: TextAlign.center,
              ),
              const SizedBox(height: 40),
              AppButton(label: 'Start a New Goal', onPressed: onStartNewGoal),
              const SizedBox(height: 12),
              AppButton(
                label: 'Back to Goals',
                onPressed: onBackToGoals,
                isOutlined: true,
              ),
            ],
          ),
        ),
      ),
    );
  }
}

class _Confetti extends StatefulWidget {
  const _Confetti();

  @override
  State<_Confetti> createState() => _ConfettiState();
}

class _ConfettiState extends State<_Confetti>
    with SingleTickerProviderStateMixin {
  late final AnimationController _controller = AnimationController(
    vsync: this,
    duration: const Duration(milliseconds: 700),
  )..forward();

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return ScaleTransition(
      scale: CurvedAnimation(parent: _controller, curve: Curves.elasticOut),
      child: Container(
        width: 96,
        height: 96,
        decoration: const BoxDecoration(
          color: AppColors.primary,
          shape: BoxShape.circle,
        ),
        child: const Icon(Icons.emoji_events_rounded,
            color: Colors.white, size: 52),
      ),
    );
  }
}
