import 'package:flutter/material.dart';
import '../theme/app_theme.dart';


class GoalsScreen extends StatelessWidget {
  const GoalsScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.background,
      body: SafeArea(
        child: Column(
          children: [
            Expanded(
              child: SingleChildScrollView(
                padding: const EdgeInsets.symmetric(horizontal: 20),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    const SizedBox(height: 28),
                    _buildHeader(),
                    const SizedBox(height: 24),
                    _buildTotalSavedCard(),
                    const SizedBox(height: 16),
                    _buildOnTrackBanner(),
                    const SizedBox(height: 24),
                    _buildGoalCard(
                      title: 'New MacBook Pro',
                      category: 'TECH',
                      categoryColor: AppColors.primary,
                      percent: 75,
                      percentColor: AppColors.primary,
                      saved: '\$1,875.00',
                      target: '\$2,500.00',
                      targetDate: 'Target: Dec 2024',
                      imagePlaceholderColor: const Color(0xFF2A2420),
                      imagePlaceholderIcon: Icons.laptop_mac,
                    ),
                    const SizedBox(height: 16),
                    _buildGoalCard(
                      title: 'Summer Trip',
                      category: 'TRAVEL',
                      categoryColor: const Color(0xFF4A9BAD),
                      percent: 42,
                      percentColor: AppColors.primary,
                      saved: '\$1,260.00',
                      target: '\$3,000.00',
                      targetDate: 'Target: June 2025',
                      imagePlaceholderColor: const Color(0xFF3AADAB),
                      imagePlaceholderIcon: Icons.beach_access,
                    ),
                    const SizedBox(height: 16),
                    _buildGoalCard(
                      title: 'Graduation Gown',
                      category: 'ACADEMIC',
                      categoryColor: const Color(0xFF5BAD7E),
                      percent: 100,
                      percentColor: AppColors.success,
                      saved: '\$350.00',
                      target: null,
                      targetDate: 'Target: May 2024',
                      imagePlaceholderColor: const Color(0xFF3AADAB),
                      imagePlaceholderIcon: Icons.school,
                      isComplete: true,
                    ),
                    const SizedBox(height: 16),
                    _buildCreateNewGoal(),
                    const SizedBox(height: 24),
                  ],
                ),
              ),
            ),
            _buildDarkBottomNav(),
          ],
        ),
      ),
    );
  }

  Widget _buildHeader() {
    return const Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          'My Savings Goals',
          style: TextStyle(
            fontSize: 30,
            fontWeight: FontWeight.w400,
            color: Colors.white,
            fontFamily: 'Georgia',
          ),
        ),
        SizedBox(height: 6),
        Text(
          'Curating your future, one contribution at\na time.',
          style: TextStyle(
            fontSize: 14,
            color: AppColors.textMuted,
            height: 1.4,
          ),
        ),
      ],
    );
  }

  Widget _buildTotalSavedCard() {
    return Container(
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        color: AppColors.darkCard,
        borderRadius: BorderRadius.circular(20),
        border: Border.all(color: AppColors.darkSurface),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Text(
            'TOTAL SAVED',
            style: TextStyle(
              fontSize: 11,
              letterSpacing: 1.2,
              color: AppColors.textMuted,
              fontWeight: FontWeight.w500,
            ),
          ),
          const SizedBox(height: 8),
          const Text(
            '\$4,850.00',
            style: TextStyle(
              fontSize: 36,
              fontWeight: FontWeight.w300,
              color: Colors.white,
              fontFamily: 'Georgia',
              letterSpacing: -1,
            ),
          ),
          const SizedBox(height: 16),
          Row(
            children: [
              Expanded(
                child: ElevatedButton(
                  onPressed: () {},
                  style: ElevatedButton.styleFrom(
                    backgroundColor: AppColors.primary,
                    shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(12)),
                    padding: const EdgeInsets.symmetric(vertical: 14),
                    elevation: 0,
                  ),
                  child: const Text(
                    'Add\nFunds',
                    textAlign: TextAlign.center,
                    style: TextStyle(
                      fontSize: 14,
                      fontWeight: FontWeight.w600,
                      color: Colors.white,
                    ),
                  ),
                ),
              ),
              const SizedBox(width: 12),
              Expanded(
                child: OutlinedButton(
                  onPressed: () {},
                  style: OutlinedButton.styleFrom(
                    side: const BorderSide(color: AppColors.textMuted),
                    shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(12)),
                    padding: const EdgeInsets.symmetric(vertical: 14),
                  ),
                  child: const Text(
                    'Adjust\nPlan',
                    textAlign: TextAlign.center,
                    style: TextStyle(
                      fontSize: 14,
                      fontWeight: FontWeight.w600,
                      color: Colors.white,
                    ),
                  ),
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }

  Widget _buildOnTrackBanner() {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 16),
      decoration: BoxDecoration(
        color: const Color(0xFFFAF0E8),
        borderRadius: BorderRadius.circular(16),
      ),
      child: const Row(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Icon(Icons.auto_awesome, size: 18, color: AppColors.primary),
          SizedBox(width: 10),
          Text(
            'You are on track to meet 3 of your 4\ngoals early.',
            textAlign: TextAlign.center,
            style: TextStyle(
              fontSize: 14,
              color: AppColors.textMedium,
              height: 1.4,
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildGoalCard({
    required String title,
    required String category,
    required Color categoryColor,
    required int percent,
    required Color percentColor,
    required String saved,
    String? target,
    required String targetDate,
    required Color imagePlaceholderColor,
    required IconData imagePlaceholderIcon,
    bool isComplete = false,
  }) {
    return Container(
      decoration: BoxDecoration(
        color: AppColors.darkCard,
        borderRadius: BorderRadius.circular(20),
        border: Border.all(color: AppColors.darkSurface),
      ),
      clipBehavior: Clip.antiAlias,
      child: Column(
        children: [
          // Image placeholder
          Container(
            height: 160,
            width: double.infinity,
            color: imagePlaceholderColor,
            child: Stack(
              alignment: Alignment.center,
              children: [
                Icon(imagePlaceholderIcon, size: 60, color: Colors.white30),
                Positioned(
                  top: 12,
                  right: 12,
                  child: Container(
                    padding: const EdgeInsets.symmetric(
                        horizontal: 10, vertical: 5),
                    decoration: BoxDecoration(
                      color: categoryColor,
                      borderRadius: BorderRadius.circular(20),
                    ),
                    child: Text(
                      category,
                      style: const TextStyle(
                        fontSize: 11,
                        fontWeight: FontWeight.w700,
                        color: Colors.white,
                        letterSpacing: 0.5,
                      ),
                    ),
                  ),
                ),
              ],
            ),
          ),
          // Content
          Padding(
            padding: const EdgeInsets.all(16),
            child: Column(
              children: [
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          title,
                          style: const TextStyle(
                            fontSize: 17,
                            fontWeight: FontWeight.w600,
                            color: Colors.white,
                          ),
                        ),
                        const SizedBox(height: 3),
                        Text(
                          targetDate,
                          style: const TextStyle(
                            fontSize: 12,
                            color: AppColors.textMuted,
                          ),
                        ),
                      ],
                    ),
                    Text(
                      '$percent%',
                      style: TextStyle(
                        fontSize: 20,
                        fontWeight: FontWeight.w700,
                        color: percentColor,
                        fontFamily: 'Georgia',
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 12),
                ClipRRect(
                  borderRadius: BorderRadius.circular(4),
                  child: LinearProgressIndicator(
                    value: percent / 100,
                    backgroundColor: AppColors.darkSurface,
                    valueColor: AlwaysStoppedAnimation<Color>(percentColor),
                    minHeight: 6,
                  ),
                ),
                const SizedBox(height: 12),
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Text(
                      '$saved saved',
                      style: const TextStyle(
                        fontSize: 13,
                        color: AppColors.textMuted,
                      ),
                    ),
                    isComplete
                        ? Row(
                            children: [
                              Container(
                                width: 16,
                                height: 16,
                                decoration: const BoxDecoration(
                                  color: AppColors.success,
                                  shape: BoxShape.circle,
                                ),
                                child: const Icon(Icons.check,
                                    size: 10, color: Colors.white),
                              ),
                              const SizedBox(width: 5),
                              const Text(
                                'Goal Met',
                                style: TextStyle(
                                  fontSize: 13,
                                  color: AppColors.success,
                                  fontWeight: FontWeight.w600,
                                ),
                              ),
                            ],
                          )
                        : Text(
                            '${target ?? ''} target',
                            style: const TextStyle(
                              fontSize: 13,
                              color: AppColors.textMuted,
                            ),
                          ),
                  ],
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildCreateNewGoal() {
    return Container(
      padding: const EdgeInsets.symmetric(vertical: 28),
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(20),
        border: Border.all(
          color: AppColors.textMuted,
          width: 1.5,
          style: BorderStyle.solid,
        ),
      ),
      child: const Column(
        children: [
          CircleAvatar(
            radius: 20,
            backgroundColor: AppColors.darkCard,
            child: Icon(Icons.add, color: AppColors.textMuted, size: 22),
          ),
          SizedBox(height: 10),
          Text(
            'Create New Goal',
            style: TextStyle(
              fontSize: 14,
              color: AppColors.textMuted,
              fontWeight: FontWeight.w500,
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildDarkBottomNav() {
    return Container(
      decoration: const BoxDecoration(
        color: AppColors.darkCard,
        border: Border(
            top: BorderSide(color: AppColors.darkSurface, width: 1)),
      ),
      child: SafeArea(
        top: false,
        child: Padding(
          padding: const EdgeInsets.symmetric(vertical: 8),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceAround,
            children: [
              _darkNavItem(Icons.home_outlined, 'HOME', false),
              _darkNavItem(Icons.bar_chart_outlined, 'INSIGHTS', false),
              Container(
                width: 48,
                height: 48,
                decoration: const BoxDecoration(
                  color: AppColors.primary,
                  shape: BoxShape.circle,
                ),
                child: const Icon(Icons.add, color: Colors.white, size: 24),
              ),
              _darkNavItem(Icons.account_balance_wallet_outlined, 'BUDGET', false),
              _darkNavItem(Icons.savings_outlined, 'GOALS', true),
            ],
          ),
        ),
      ),
    );
  }

  Widget _darkNavItem(IconData icon, String label, bool isSelected) {
    return Column(
      mainAxisSize: MainAxisSize.min,
      children: [
        Icon(
          icon,
          size: 22,
          color: isSelected ? AppColors.primary : AppColors.textMuted,
        ),
        const SizedBox(height: 4),
        Text(
          label,
          style: TextStyle(
            fontSize: 9,
            fontWeight: isSelected ? FontWeight.w700 : FontWeight.w400,
            color: isSelected ? AppColors.primary : AppColors.textMuted,
            letterSpacing: 0.5,
          ),
        ),
      ],
    );
  }
}
