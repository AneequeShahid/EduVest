import 'package:flutter/material.dart';
import '../theme/app_theme.dart';

class EduvestBottomNav extends StatelessWidget {
  final int currentIndex;

  const EduvestBottomNav({super.key, required this.currentIndex});

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        color: Colors.white,
        border: const Border(
          top: BorderSide(color: AppColors.borderLight, width: 1),
        ),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.04),
            blurRadius: 10,
            offset: const Offset(0, -2),
          ),
        ],
      ),
      child: SafeArea(
        top: false,
        child: Padding(
          padding: const EdgeInsets.symmetric(vertical: 8),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceAround,
            children: [
              _navItem(context, Icons.home_outlined, 'HOME', 0),
              _navItem(context, Icons.bar_chart_outlined, 'INSIGHTS', 1),
              _addButton(context),
              _navItem(
                  context,
                  Icons.account_balance_wallet_outlined,
                  'BUDGET',
                  3),
              _navItem(context, Icons.savings_outlined, 'GOALS', 4),
            ],
          ),
        ),
      ),
    );
  }

  Widget _navItem(
      BuildContext context, IconData icon, String label, int index) {
    final isSelected = currentIndex == index;
    return GestureDetector(
      onTap: () => _navigate(context, index),
      behavior: HitTestBehavior.opaque,
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
        child: Column(
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
                fontWeight:
                    isSelected ? FontWeight.w700 : FontWeight.w400,
                color: isSelected ? AppColors.primary : AppColors.textMuted,
                letterSpacing: 0.5,
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _addButton(BuildContext context) {
    return GestureDetector(
      onTap: () => _navigate(context, 2),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          Container(
            width: 48,
            height: 48,
            decoration: BoxDecoration(
              color: currentIndex == 2
                  ? AppColors.primaryDark
                  : AppColors.primary,
              shape: BoxShape.circle,
              boxShadow: [
                BoxShadow(
                  color: AppColors.primary.withOpacity(0.3),
                  blurRadius: 8,
                  offset: const Offset(0, 4),
                ),
              ],
            ),
            child: const Icon(Icons.add, color: Colors.white, size: 24),
          ),
          const SizedBox(height: 4),
          Text(
            'ADD',
            style: TextStyle(
              fontSize: 9,
              fontWeight: FontWeight.w700,
              color: currentIndex == 2
                  ? AppColors.primary
                  : AppColors.textMuted,
              letterSpacing: 0.5,
            ),
          ),
        ],
      ),
    );
  }

  void _navigate(BuildContext context, int index) {
    if (index == currentIndex) return;

    final routes = [
      '/home',
      '/insights',
      '/add',
      '/budget',
      '/goals',
    ];

    Navigator.pushReplacementNamed(context, routes[index]);
  }
}
