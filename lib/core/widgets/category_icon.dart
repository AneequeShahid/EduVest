import 'package:flutter/material.dart';

/// Maps an expense category name to an icon + accent color, rendered as a
/// rounded tinted badge.
class CategoryIcon extends StatelessWidget {
  final String category;
  final double size;

  const CategoryIcon({
    super.key,
    required this.category,
    this.size = 44,
  });

  static const Map<String, (IconData, Color)> _map = {
    'Rent': (Icons.house_rounded, Color(0xFF7B5EA7)),
    'Groceries': (Icons.shopping_cart_rounded, Color(0xFF2E7D32)),
    'Transport': (Icons.directions_car_rounded, Color(0xFF1565C0)),
    'Fun': (Icons.sports_esports_rounded, Color(0xFFD81B60)),
    'Education': (Icons.menu_book_rounded, Color(0xFFF9A825)),
    'Health': (Icons.favorite_rounded, Color(0xFFC62828)),
    'Others': (Icons.grid_view_rounded, Color(0xFF757575)),
  };

  static (IconData, Color) resolve(String category) =>
      _map[category] ?? _map['Others']!;

  /// Icon for a category (falls back to the "Others" grid icon).
  static IconData iconForCategory(String category) => resolve(category).$1;

  /// Accent color for a category (falls back to gray).
  static Color colorForCategory(String category) => resolve(category).$2;

  @override
  Widget build(BuildContext context) {
    final (icon, color) = resolve(category);
    return Container(
      width: size,
      height: size,
      decoration: BoxDecoration(
        color: color.withValues(alpha: 0.12),
        borderRadius: BorderRadius.circular(size * 0.28),
      ),
      child: Icon(icon, color: color, size: size * 0.5),
    );
  }
}
