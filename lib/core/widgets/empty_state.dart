import 'package:flutter/material.dart';
import '../constants/app_colors.dart';
import '../constants/app_text_styles.dart';

/// Centered empty-state placeholder with an optional title, icon and action.
///
/// On wide screens the content is capped at [maxWidth] (default 400) so it
/// does not stretch uncomfortably across the full viewport.
class EmptyState extends StatelessWidget {
  final String message;
  final String? title;
  final IconData icon;
  final String? actionLabel;
  final VoidCallback? onAction;
  final double maxWidth;

  const EmptyState({
    super.key,
    required this.message,
    this.title,
    this.icon = Icons.inbox_outlined,
    this.actionLabel,
    this.onAction,
    this.maxWidth = 400,
  });

  @override
  Widget build(BuildContext context) {
    return Center(
      child: ConstrainedBox(
        constraints: BoxConstraints(maxWidth: maxWidth),
        child: Padding(
          padding: const EdgeInsets.all(32),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              Icon(icon, size: 56, color: AppColors.textTertiary),
              const SizedBox(height: 16),
              if (title != null) ...[
                Text(
                  title!,
                  style: AppTextStyles.headlineMedium,
                  textAlign: TextAlign.center,
                ),
                const SizedBox(height: 8),
              ],
              Text(
                message,
                style: AppTextStyles.bodyMedium,
                textAlign: TextAlign.center,
              ),
              if (actionLabel != null && onAction != null) ...[
                const SizedBox(height: 24),
                ElevatedButton(
                  onPressed: onAction,
                  child: Text(actionLabel!),
                ),
              ],
            ],
          ),
        ),
      ),
    );
  }
}

