import 'package:cloud_firestore/cloud_firestore.dart';

/// Serialisation for the budget document
/// `users/{uid}/budget/{month-year}`.
class BudgetModel {
  BudgetModel._();

  /// Document id for a given month/year, e.g. 2024-03.
  static String docId(int month, int year) =>
      '$year-${month.toString().padLeft(2, '0')}';

  static Map<String, dynamic> toJson({
    required int month,
    required int year,
    required double totalLimit,
    required int daysInMonth,
    bool isUpdate = false,
  }) =>
      {
        'month': month,
        'year': year,
        'totalLimit': totalLimit,
        'daysInMonth': daysInMonth,
        if (!isUpdate) 'createdAt': FieldValue.serverTimestamp(),
        'updatedAt': FieldValue.serverTimestamp(),
      };
}
