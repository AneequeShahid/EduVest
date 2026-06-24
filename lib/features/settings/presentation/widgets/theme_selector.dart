import 'package:flutter/material.dart';
import '../../../../core/constants/app_colors.dart';

class ThemeSelector extends StatelessWidget {
  final int selectedTheme;
  final ValueChanged<int> onSelect;

  const ThemeSelector(
      {super.key, required this.selectedTheme, required this.onSelect});

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        Expanded(child: _themeCard(0, 'Sahara Light', 'Warm linen & sienna', false)),
        const SizedBox(width: 12),
        Expanded(child: _themeCard(1, 'Midnight Sands', 'Deep stone & copper', true)),
      ],
    );
  }

  Widget _themeCard(int idx, String label, String desc, bool isDark) {
    final isSelected = selectedTheme == idx;
    return GestureDetector(
      onTap: () => onSelect(idx),
      child: Container(
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
                color: isDark ? AppColors.darkCard : AppColors.cardBeige,
                borderRadius: BorderRadius.circular(12),
              ),
              child: Icon(
                isDark ? Icons.nightlight_outlined : Icons.wb_sunny_outlined,
                size: 24,
                color: isDark ? AppColors.primary : AppColors.warning,
              ),
            ),
            const SizedBox(height: 10),
            Text(label,
                textAlign: TextAlign.center,
                style: TextStyle(
                    fontSize: 13,
                    fontWeight: FontWeight.w600,
                    color: isDark ? Colors.white : AppColors.textDark)),
            const SizedBox(height: 3),
            Text(desc,
                textAlign: TextAlign.center,
                style: TextStyle(
                    fontSize: 11,
                    color:
                        isDark ? AppColors.textMuted : AppColors.textLight)),
          ],
        ),
      ),
    );
  }
}
