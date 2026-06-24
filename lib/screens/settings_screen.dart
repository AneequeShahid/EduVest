import 'package:flutter/material.dart';
import '../theme/app_theme.dart';

class SettingsScreen extends StatefulWidget {
  const SettingsScreen({super.key});

  @override
  State<SettingsScreen> createState() => _SettingsScreenState();
}

class _SettingsScreenState extends State<SettingsScreen> {
  bool _budgetAlerts = true;
  bool _goalAchievements = true;
  bool _marketingEmails = false;
  int _selectedTheme = 0;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.background,
      body: SafeArea(
        child: SingleChildScrollView(
          padding: const EdgeInsets.symmetric(horizontal: 20),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const SizedBox(height: 28),
              _buildHeader(),
              const SizedBox(height: 24),
              _buildProfileCard(),
              const SizedBox(height: 28),
              _buildSectionTitle(
                  Icons.notifications_outlined, 'Notifications'),
              const SizedBox(height: 12),
              _buildNotificationsSection(),
              const SizedBox(height: 28),
              _buildSectionTitle(Icons.lock_outline, 'Security & Privacy'),
              const SizedBox(height: 12),
              _buildSecuritySection(),
              const SizedBox(height: 28),
              _buildSectionTitle(Icons.palette_outlined, 'Appearance'),
              const SizedBox(height: 12),
              _buildAppearanceSection(),
              const SizedBox(height: 32),
              const Divider(color: AppColors.borderLight),
              const SizedBox(height: 20),
              _buildSignOut(),
              const SizedBox(height: 20),
              _buildVersionInfo(),
              const SizedBox(height: 32),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildHeader() {
    return const Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          'Settings',
          style: TextStyle(
            fontSize: 30,
            fontWeight: FontWeight.w400,
            color: AppColors.textDark,
            fontFamily: 'Georgia',
          ),
        ),
        SizedBox(height: 6),
        Text(
          'Manage your account preferences and security.',
          style: TextStyle(
            fontSize: 14,
            color: AppColors.textLight,
          ),
        ),
      ],
    );
  }

  Widget _buildProfileCard() {
    return Container(
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        color: AppColors.cardBackground,
        borderRadius: BorderRadius.circular(20),
        border: Border.all(color: AppColors.borderLight),
      ),
      child: Column(
        children: [
          Row(
            children: [
              Container(
                width: 64,
                height: 64,
                decoration: BoxDecoration(
                  shape: BoxShape.circle,
                  border: Border.all(color: AppColors.border, width: 2),
                  image: const DecorationImage(
                    image: NetworkImage('https://i.pravatar.cc/128?img=11'),
                    fit: BoxFit.cover,
                  ),
                ),
              ),
              const SizedBox(width: 16),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    const Text(
                      'Alex Sterling',
                      style: TextStyle(
                        fontSize: 18,
                        fontWeight: FontWeight.w600,
                        color: AppColors.textDark,
                        fontFamily: 'Georgia',
                      ),
                    ),
                    const SizedBox(height: 3),
                    const Text(
                      'alex.sterling@eduvest.com',
                      style: TextStyle(
                        fontSize: 13,
                        color: AppColors.textLight,
                      ),
                    ),
                    const SizedBox(height: 8),
                    Container(
                      padding: const EdgeInsets.symmetric(
                          horizontal: 10, vertical: 4),
                      decoration: BoxDecoration(
                        color: const Color(0xFFFAF0E8),
                        borderRadius: BorderRadius.circular(20),
                        border: Border.all(color: AppColors.border),
                      ),
                      child: const Text(
                        'PREMIUM MEMBER',
                        style: TextStyle(
                          fontSize: 10,
                          fontWeight: FontWeight.w600,
                          color: AppColors.primary,
                          letterSpacing: 0.8,
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ),
          const SizedBox(height: 16),
          SizedBox(
            width: double.infinity,
            child: OutlinedButton(
              onPressed: () {},
              style: OutlinedButton.styleFrom(
                side: const BorderSide(color: AppColors.border),
                shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(12)),
                padding: const EdgeInsets.symmetric(vertical: 14),
              ),
              child: const Text(
                'Edit Profile Details',
                style: TextStyle(
                  fontSize: 15,
                  fontWeight: FontWeight.w500,
                  color: AppColors.textDark,
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildSectionTitle(IconData icon, String title) {
    return Row(
      children: [
        Icon(icon, size: 20, color: AppColors.primary),
        const SizedBox(width: 8),
        Text(
          title,
          style: const TextStyle(
            fontSize: 17,
            fontWeight: FontWeight.w600,
            color: AppColors.primary,
          ),
        ),
      ],
    );
  }

  Widget _buildNotificationsSection() {
    return Container(
      decoration: BoxDecoration(
        color: AppColors.cardBackground,
        borderRadius: BorderRadius.circular(16),
        border: Border.all(color: AppColors.borderLight),
      ),
      child: Column(
        children: [
          _buildToggleRow(
            title: 'Budget Alerts',
            subtitle: 'Notify me when I exceed my weekly limit',
            value: _budgetAlerts,
            onChanged: (val) => setState(() => _budgetAlerts = val),
            isFirst: true,
          ),
          const Divider(height: 1, indent: 16, endIndent: 16,
              color: AppColors.borderLight),
          _buildToggleRow(
            title: 'Goal Achievements',
            subtitle: 'Celebrations when saving milestones are met',
            value: _goalAchievements,
            onChanged: (val) => setState(() => _goalAchievements = val),
          ),
          const Divider(height: 1, indent: 16, endIndent: 16,
              color: AppColors.borderLight),
          _buildToggleRow(
            title: 'Marketing Emails',
            subtitle: 'Tips and updates from the EduVest team',
            value: _marketingEmails,
            onChanged: (val) => setState(() => _marketingEmails = val),
            isLast: true,
          ),
        ],
      ),
    );
  }

  Widget _buildToggleRow({
    required String title,
    required String subtitle,
    required bool value,
    required ValueChanged<bool> onChanged,
    bool isFirst = false,
    bool isLast = false,
  }) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 14),
      child: Row(
        children: [
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  title,
                  style: const TextStyle(
                    fontSize: 15,
                    fontWeight: FontWeight.w600,
                    color: AppColors.textDark,
                  ),
                ),
                const SizedBox(height: 3),
                Text(
                  subtitle,
                  style: const TextStyle(
                    fontSize: 13,
                    color: AppColors.textLight,
                    height: 1.3,
                  ),
                ),
              ],
            ),
          ),
          Switch(
            value: value,
            onChanged: onChanged,
            activeColor: AppColors.primary,
            inactiveThumbColor: Colors.white,
            inactiveTrackColor: AppColors.borderLight,
          ),
        ],
      ),
    );
  }

  Widget _buildSecuritySection() {
    return Container(
      decoration: BoxDecoration(
        color: AppColors.cardBackground,
        borderRadius: BorderRadius.circular(16),
        border: Border.all(color: AppColors.borderLight),
      ),
      child: Column(
        children: [
          _buildSecurityRow(
            icon: Icons.password_outlined,
            title: 'Change Password',
            trailing: const Icon(Icons.chevron_right,
                color: AppColors.textLight),
            isFirst: true,
          ),
          const Divider(height: 1, indent: 16, endIndent: 16,
              color: AppColors.borderLight),
          _buildSecurityRow(
            icon: Icons.fingerprint,
            title: 'Biometric Authentication',
            trailing: const Text(
              'Enabled',
              style: TextStyle(
                fontSize: 14,
                color: AppColors.textLight,
              ),
            ),
          ),
          const Divider(height: 1, indent: 16, endIndent: 16,
              color: AppColors.borderLight),
          _buildSecurityRow(
            icon: Icons.shield_outlined,
            title: 'Privacy Center',
            trailing: const Icon(Icons.open_in_new,
                size: 18, color: AppColors.textLight),
            isLast: true,
          ),
        ],
      ),
    );
  }

  Widget _buildSecurityRow({
    required IconData icon,
    required String title,
    required Widget trailing,
    bool isFirst = false,
    bool isLast = false,
  }) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 16),
      child: Row(
        children: [
          Icon(icon, size: 20, color: AppColors.textMedium),
          const SizedBox(width: 14),
          Expanded(
            child: Text(
              title,
              style: const TextStyle(
                fontSize: 15,
                fontWeight: FontWeight.w500,
                color: AppColors.textDark,
              ),
            ),
          ),
          trailing,
        ],
      ),
    );
  }

  Widget _buildAppearanceSection() {
    return Row(
      children: [
        Expanded(
          child: GestureDetector(
            onTap: () => setState(() => _selectedTheme = 0),
            child: _buildThemeCard(
              isSelected: _selectedTheme == 0,
              isDark: false,
              label: 'Sahara Light',
              description: 'Warm linen & sienna',
              icon: Icons.wb_sunny_outlined,
            ),
          ),
        ),
        const SizedBox(width: 12),
        Expanded(
          child: GestureDetector(
            onTap: () => setState(() => _selectedTheme = 1),
            child: _buildThemeCard(
              isSelected: _selectedTheme == 1,
              isDark: true,
              label: 'Midnight Sands',
              description: 'Deep stone & copper',
              icon: Icons.nightlight_outlined,
            ),
          ),
        ),
      ],
    );
  }

  Widget _buildThemeCard({
    required bool isSelected,
    required bool isDark,
    required String label,
    required String description,
    required IconData icon,
  }) {
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: isDark ? AppColors.darkBackground : AppColors.cardBackground,
        borderRadius: BorderRadius.circular(16),
        border: Border.all(
          color: isSelected ? AppColors.primary : AppColors.borderLight,
          width: isSelected ? 2 : 1,
        ),
      ),
      child: Column(
        children: [
          Container(
            width: 48,
            height: 48,
            decoration: BoxDecoration(
              color: isDark
                  ? AppColors.darkCard
                  : AppColors.cardBeige,
              borderRadius: BorderRadius.circular(12),
            ),
            child: Icon(icon,
                size: 24,
                color: isDark ? AppColors.primary : AppColors.warning),
          ),
          const SizedBox(height: 10),
          Text(
            label,
            textAlign: TextAlign.center,
            style: TextStyle(
              fontSize: 14,
              fontWeight: FontWeight.w600,
              color: isDark ? Colors.white : AppColors.textDark,
            ),
          ),
          const SizedBox(height: 3),
          Text(
            description,
            textAlign: TextAlign.center,
            style: TextStyle(
              fontSize: 12,
              color: isDark ? AppColors.textMuted : AppColors.textLight,
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildSignOut() {
    return GestureDetector(
      onTap: () {},
      child: Row(
        children: [
          Transform.rotate(
            angle: 3.14159,
            child: const Icon(Icons.logout,
                size: 20, color: AppColors.primary),
          ),
          const SizedBox(width: 10),
          const Text(
            'Sign Out',
            style: TextStyle(
              fontSize: 16,
              fontWeight: FontWeight.w600,
              color: AppColors.primary,
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildVersionInfo() {
    return const Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          'EduVest Version 2.4.0 (Build 892)',
          style: TextStyle(fontSize: 12, color: AppColors.textMuted),
        ),
        SizedBox(height: 4),
        Text(
          '© 2024 EduVest Financial Inc.',
          style: TextStyle(fontSize: 12, color: AppColors.textMuted),
        ),
      ],
    );
  }
}
