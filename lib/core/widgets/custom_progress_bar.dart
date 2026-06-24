import 'package:flutter/material.dart';
import '../constants/app_colors.dart';

/// Rounded, animated horizontal progress bar.
///
/// [value] is clamped to 0.0–1.0 and transitions are animated via
/// [AnimatedContainer].
class CustomProgressBar extends StatelessWidget {
  final double value;
  final double height;
  final Color? backgroundColor;
  final Color? foregroundColor;
  final Duration duration;

  const CustomProgressBar({
    super.key,
    required this.value,
    this.height = 8,
    this.backgroundColor,
    this.foregroundColor,
    this.duration = const Duration(milliseconds: 400),
  });

  @override
  Widget build(BuildContext context) {
    final clamped = value.clamp(0.0, 1.0);
    final bg = backgroundColor ?? AppColors.surfaceSecondary;
    final fg = foregroundColor ?? AppColors.primary;

    return ClipRRect(
      borderRadius: BorderRadius.circular(height),
      child: LayoutBuilder(
        builder: (context, constraints) {
          return Stack(
            children: [
              Container(
                height: height,
                width: constraints.maxWidth,
                color: bg,
              ),
              AnimatedContainer(
                duration: duration,
                curve: Curves.easeInOut,
                height: height,
                width: constraints.maxWidth * clamped,
                decoration: BoxDecoration(
                  color: fg,
                  borderRadius: BorderRadius.circular(height),
                ),
              ),
            ],
          );
        },
      ),
    );
  }
}
