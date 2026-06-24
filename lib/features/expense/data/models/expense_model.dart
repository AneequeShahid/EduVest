import 'package:cloud_firestore/cloud_firestore.dart';

import '../../domain/entities/expense_entity.dart';

/// Firestore <-> [ExpenseEntity] mapping for `users/{uid}/expenses/{id}`.
class ExpenseModel {
  ExpenseModel._();

  static ExpenseEntity fromDoc(DocumentSnapshot<Map<String, dynamic>> doc) {
    return fromJson({...?doc.data(), 'id': doc.id});
  }

  static ExpenseEntity fromJson(Map<String, dynamic> json) {
    DateTime parseDate(dynamic raw) {
      if (raw is Timestamp) return raw.toDate();
      if (raw is String) return DateTime.tryParse(raw) ?? DateTime.now();
      return DateTime.now();
    }

    final date = parseDate(json['date']);
    return ExpenseEntity(
      id: json['id'] as String? ?? '',
      amount: (json['amount'] as num?)?.toDouble() ?? 0.0,
      description: json['description'] as String? ??
          json['note'] as String? ??
          '',
      category: json['category'] as String? ?? 'Others',
      date: date,
      month: (json['month'] as num?)?.toInt() ?? date.month,
      year: (json['year'] as num?)?.toInt() ?? date.year,
      receiptUrl: json['receiptUrl'] as String?,
      isIncome: json['isIncome'] as bool? ?? false,
      createdAt: json['createdAt'] is Timestamp
          ? (json['createdAt'] as Timestamp).toDate()
          : null,
    );
  }

  /// Serialises for a write. [isUpdate] swaps `createdAt` for `updatedAt`.
  static Map<String, dynamic> toJson(ExpenseEntity e, {bool isUpdate = false}) {
    return {
      'id': e.id,
      'amount': e.amount,
      'description': e.description,
      'category': e.category,
      'date': Timestamp.fromDate(e.date),
      // month/year are derived from the date so they are always consistent.
      'month': e.date.month,
      'year': e.date.year,
      'isIncome': e.isIncome,
      if (e.receiptUrl != null) 'receiptUrl': e.receiptUrl,
      if (!isUpdate)
        'createdAt': e.createdAt != null
            ? Timestamp.fromDate(e.createdAt!)
            : FieldValue.serverTimestamp(),
      'updatedAt': FieldValue.serverTimestamp(),
    };
  }
}
