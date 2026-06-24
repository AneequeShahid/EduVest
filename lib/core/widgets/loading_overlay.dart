import 'package:flutter/material.dart';
import '../constants/app_colors.dart';

/// Full-screen modal loading overlay: a 50%-black scrim with a centered
/// circular indicator. Use as the top child of a [Stack] gated by [isLoading].
class LoadingOverlay extends StatelessWidget {
  final bool isLoading;
  final Widget? child;
  final String? message;

  const LoadingOverlay({
    super.key,
    this.isLoading = true,
    this.child,
    this.message,
  });

  @override
  Widget build(BuildContext context) {
    final overlay = Positioned.fill(
      child: ColoredBox(
        color: Colors.black.withValues(alpha: 0.5),
        child: Center(
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              const CircularProgressIndicator(
                valueColor: AlwaysStoppedAnimation<Color>(AppColors.primary),
              ),
              if (message != null) ...[
                const SizedBox(height: 16),
                Text(
                  message!,
                  style: const TextStyle(color: Colors.white, fontSize: 14),
                ),
              ],
            ],
          ),
        ),
      ),
    );

    if (child == null) {
      return isLoading ? Stack(children: [overlay]) : const SizedBox.shrink();
    }

    return Stack(
      children: [
        child!,
        if (isLoading) overlay,
      ],
    );
  }
}
