import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';

import '../constants/app_colors.dart';
import '../constants/app_sizes.dart';
import '../constants/app_strings.dart';
import '../constants/app_text_styles.dart';
import '../routes/route_names.dart';
import '../../features/authentication/presentation/providers/auth_provider.dart';

/// Shared top navigation bar used across every primary tab screen.
///
/// Left: profile avatar that opens Settings. Center: app wordmark.
/// Right: notifications. Kept identical on all screens for consistency.
class AppTopBar extends ConsumerWidget {
  const AppTopBar({super.key});

  static String _initials(String? name) {
    if (name == null || name.trim().isEmpty) return '?';
    final parts = name.trim().split(RegExp(r'\s+'));
    if (parts.length == 1) return parts.first[0].toUpperCase();
    return (parts.first[0] + parts.last[0]).toUpperCase();
  }

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final user = ref.watch(authStateProvider).valueOrNull;

    return Align(
      alignment: Alignment.topCenter,
      child: ConstrainedBox(
        constraints: const BoxConstraints(maxWidth: 720),
        child: Padding(
          padding: const EdgeInsets.fromLTRB(
              AppSizes.space20, AppSizes.space12, AppSizes.sm, AppSizes.sm),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              GestureDetector(
                key: const Key('top-bar-settings'),
                onTap: () => context.push(RouteNames.settings),
                child: CircleAvatar(
                  radius: AppSizes.space20,
                  backgroundColor: AppColors.surfaceSecondary,
                  child: Text(
                    _initials(user?.name),
                    style: AppTextStyles.titleMedium
                        .copyWith(color: AppColors.primary),
                  ),
                ),
              ),
              Text(
                AppStrings.appName,
                style: AppTextStyles.displayMedium.copyWith(
                  color: AppColors.primary,
                  fontSize: AppSizes.font22,
                ),
              ),
              IconButton(
                onPressed: () {},
                icon: const Icon(Icons.notifications_none_rounded,
                    color: AppColors.textPrimary),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

