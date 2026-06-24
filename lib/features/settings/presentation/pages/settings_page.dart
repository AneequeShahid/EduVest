import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import '../../../../core/constants/app_colors.dart';
import '../../../../core/constants/app_sizes.dart';
import '../../../../core/constants/app_strings.dart';
import '../../../../core/routes/route_names.dart';
import '../providers/settings_provider.dart';
import '../../../../features/authentication/presentation/providers/auth_provider.dart';
import '../widgets/settings_tile.dart';
import '../widgets/theme_selector.dart';

class SettingsPage extends ConsumerStatefulWidget {
  const SettingsPage({super.key});

  @override
  ConsumerState<SettingsPage> createState() => _SettingsPageState();
}

class _SettingsPageState extends ConsumerState<SettingsPage> {
  @override
  void initState() {
    super.initState();
    Future.microtask(() => ref.read(settingsProvider.notifier).load());
  }

  static const _sectionStyle = TextStyle(
      fontSize: AppSizes.font17,
      fontWeight: FontWeight.w600,
      color: AppColors.primary);

  @override
  Widget build(BuildContext context) {
    final state = ref.watch(settingsProvider);
    final s = state.settings;

    return Scaffold(
      backgroundColor: AppColors.background,
      appBar: AppBar(
        title: const Text(AppStrings.settings),
        leading: BackButton(onPressed: () => context.pop()),
      ),
      body: SafeArea(
        child: Align(
          alignment: Alignment.topCenter,
          child: ConstrainedBox(
            constraints: const BoxConstraints(maxWidth: 600),
            child: SingleChildScrollView(
              padding: const EdgeInsets.symmetric(horizontal: AppSizes.pagePadding),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const SizedBox(height: AppSizes.md),
                  _buildProfileCard(context),
              const SizedBox(height: AppSizes.lg),
              const Text(AppStrings.notifications, style: _sectionStyle),
              const SizedBox(height: AppSizes.space12),
              _card(
                children: [
                  SettingsTile(
                    title: AppStrings.budgetAlerts,
                    subtitle: AppStrings.budgetAlertsSubtitle,
                    trailing: Switch(
                      value: s.budgetAlerts,
                      onChanged: (v) => ref
                          .read(settingsProvider.notifier)
                          .update(s.copyWith(budgetAlerts: v)),
                      activeThumbColor: AppColors.primary,
                    ),
                  ),
                  const Divider(height: 1, color: AppColors.borderLight),
                  SettingsTile(
                    title: AppStrings.goalAchievements,
                    subtitle: AppStrings.goalAchievementsSubtitle,
                    trailing: Switch(
                      value: s.goalAchievements,
                      onChanged: (v) => ref
                          .read(settingsProvider.notifier)
                          .updateNotificationPreferences(
                              {'goalAchievements': v}),
                      activeThumbColor: AppColors.primary,
                    ),
                  ),
                  const Divider(height: 1, color: AppColors.borderLight),
                  SettingsTile(
                    title: AppStrings.marketingEmails,
                    subtitle: AppStrings.marketingEmailsSubtitle,
                    trailing: Switch(
                      value: s.marketingEmails,
                      onChanged: (v) => ref
                          .read(settingsProvider.notifier)
                          .updateNotificationPreferences(
                              {'marketingEmails': v}),
                      activeThumbColor: AppColors.primary,
                    ),
                  ),
                ],
              ),
              const SizedBox(height: AppSizes.lg),
              const Text(AppStrings.securityPrivacy, style: _sectionStyle),
              const SizedBox(height: AppSizes.space12),
              _card(
                children: [
                  SettingsTile(
                    title: AppStrings.changePassword,
                    icon: Icons.lock_outline,
                    trailing: const Icon(Icons.chevron_right,
                        color: AppColors.textLight),
                    onTap: () => context.push(RouteNames.changePassword),
                  ),
                  const Divider(height: 1, color: AppColors.borderLight),
                  SettingsTile(
                    title: AppStrings.biometricUnlock,
                    subtitle: AppStrings.biometricUnlockSubtitle,
                    icon: Icons.fingerprint,
                    trailing: Switch(
                      value: s.biometricEnabled,
                      onChanged: (v) => ref
                          .read(settingsProvider.notifier)
                          .toggleBiometric(v),
                      activeThumbColor: AppColors.primary,
                    ),
                  ),
                  const Divider(height: 1, color: AppColors.borderLight),
                  SettingsTile(
                    title: AppStrings.privacyCenter,
                    icon: Icons.shield_outlined,
                    trailing: const Icon(Icons.chevron_right,
                        color: AppColors.textLight),
                    onTap: () => ScaffoldMessenger.of(context).showSnackBar(
                      const SnackBar(
                          content: Text(AppStrings.privacyCenterComingSoon)),
                    ),
                  ),
                ],
              ),
              const SizedBox(height: AppSizes.lg),
              const Text(AppStrings.appearance, style: _sectionStyle),
              const SizedBox(height: AppSizes.space12),
              ThemeSelector(
                selectedTheme: s.selectedTheme,
                onSelect: (idx) => ref
                    .read(settingsProvider.notifier)
                    .update(s.copyWith(selectedTheme: idx)),
              ),
              const SizedBox(height: AppSizes.xl),
              const Divider(color: AppColors.borderLight),
              const SizedBox(height: AppSizes.md),
              GestureDetector(
                onTap: () async {
                  await ref.read(authNotifierProvider.notifier).logout();
                  if (!context.mounted) return;
                  context.go(RouteNames.login);
                },
                child: const Row(
                  children: [
                    Icon(Icons.logout,
                        color: AppColors.primary, size: AppSizes.space20),
                    SizedBox(width: AppSizes.space10),
                    Text(AppStrings.signOut,
                        style: TextStyle(
                            fontSize: AppSizes.fontLg,
                            fontWeight: FontWeight.w600,
                            color: AppColors.primary)),
                  ],
                ),
              ),
              const SizedBox(height: AppSizes.lg),
              const Center(
                child: Text(
                  AppStrings.appVersionLabel,
                  style: TextStyle(
                      fontSize: AppSizes.fontSm, color: AppColors.textLight),
                ),
              ),
              const SizedBox(height: AppSizes.xl),
            ],
          ),
        ),
      ),
    );
  }

  Widget _card({required List<Widget> children}) => Container(
        decoration: BoxDecoration(
            color: AppColors.cardBackground,
            borderRadius: BorderRadius.circular(AppSizes.radiusLg),
            border: Border.all(color: AppColors.borderLight)),
        child: Column(children: children),
      );

  Widget _buildProfileCard(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(AppSizes.space20),
      decoration: BoxDecoration(
        color: AppColors.cardBackground,
        borderRadius: BorderRadius.circular(AppSizes.radiusCard),
        border: Border.all(color: AppColors.borderLight),
      ),
      child: Row(
        children: [
          const CircleAvatar(
            radius: AppSizes.iconLg,
            backgroundColor: AppColors.cardBeige,
            child: Icon(Icons.person_outline,
                size: AppSizes.iconLg, color: AppColors.primary),
          ),
          const SizedBox(width: AppSizes.md),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  children: [
                    Flexible(
                      child: Text(
                        ref.read(authStateProvider).valueOrNull?.name ??
                            AppStrings.student,
                        overflow: TextOverflow.ellipsis,
                        style: const TextStyle(
                            fontSize: AppSizes.fontXl,
                            fontWeight: FontWeight.w600,
                            color: AppColors.textDark,
                            fontFamily: 'Georgia'),
                      ),
                    ),
                    const SizedBox(width: AppSizes.sm),
                    Container(
                      padding: const EdgeInsets.symmetric(
                          horizontal: AppSizes.sm, vertical: AppSizes.space2),
                      decoration: BoxDecoration(
                        color: AppColors.primary,
                        borderRadius: BorderRadius.circular(AppSizes.radiusSm),
                      ),
                      child: const Text(
                        AppStrings.premium,
                        style: TextStyle(
                            fontSize: AppSizes.fontXs,
                            fontWeight: FontWeight.w700,
                            letterSpacing: 0.5,
                            color: Colors.white),
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: AppSizes.space3),
                Text(
                  ref.read(authStateProvider).valueOrNull?.email ?? '',
                  style: const TextStyle(
                      fontSize: AppSizes.font13, color: AppColors.textLight),
                ),
              ],
            ),
          ),
          TextButton(
            onPressed: () => context.push(RouteNames.editProfile),
            child: const Text(AppStrings.edit),
          ),
        ],
      ),
    );
  }
}
