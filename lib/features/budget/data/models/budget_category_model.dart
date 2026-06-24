import 'package:cloud_firestore/cloud_firestore.dart';

import '../../domain/entities/budget_category_entity.dart';

/// Firestore <-> [BudgetCategoryEntity] mapping for
/// `users/{uid}/budget/{month-year}/categories/{id}`.
class BudgetCategoryModel {
  BudgetCategoryModel._();

  /// [spent] is computed from expenses and injected by the source.
  static BudgetCategoryEntity fromDoc(
    DocumentSnapshot<Map<String, dynamic>> doc, {
    double spent = 0.0,
  }) {
    final data = doc.data() ?? const {};
    return BudgetCategoryEntity(
      id: doc.id,
      name: data['name'] as String? ?? doc.id,
      limit: (data['limit'] as num?)?.toDouble() ?? 0.0,
      spent: spent,
      icon: data['icon'] as String? ?? '',
      color: data['color'] as String? ?? '#C1622A',
      isPaid: data['isPaid'] as bool? ?? false,
    );
  }

  static Map<String, dynamic> toJson(BudgetCategoryEntity c) => {
        'name': c.name,
        'limit': c.limit,
        'icon': c.icon,
        'color': c.color,
        'isPaid': c.isPaid,
      };
}
