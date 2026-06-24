import 'package:cloud_firestore/cloud_firestore.dart';

import '../../domain/entities/contribution_entity.dart';

/// Firestore <-> [ContributionEntity] mapping for
/// `users/{uid}/goals/{goalId}/contributions/{id}`.
class ContributionModel {
  ContributionModel._();

  static ContributionEntity fromDoc(
      DocumentSnapshot<Map<String, dynamic>> doc) {
    final data = doc.data() ?? const {};
    final raw = data['date'];
    return ContributionEntity(
      id: doc.id,
      amount: (data['amount'] as num?)?.toDouble() ?? 0.0,
      note: data['note'] as String? ?? '',
      date: raw is Timestamp ? raw.toDate() : DateTime.now(),
    );
  }

  static Map<String, dynamic> toJson(double amount, String? note,
          {DateTime? date}) =>
      {
        'amount': amount,
        'note': note ?? '',
        'date': date != null
            ? Timestamp.fromDate(date)
            : FieldValue.serverTimestamp(),
      };
}
