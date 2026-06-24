import 'package:cloud_firestore/cloud_firestore.dart';

import '../../domain/entities/goal_entity.dart';

/// Firestore <-> [GoalEntity] mapping for `users/{uid}/goals/{id}`.
class GoalModel {
  GoalModel._();

  static DateTime? _date(dynamic raw) {
    if (raw is Timestamp) return raw.toDate();
    if (raw is String) return DateTime.tryParse(raw);
    return null;
  }

  static GoalEntity fromDoc(DocumentSnapshot<Map<String, dynamic>> doc) {
    final data = doc.data() ?? const {};
    return GoalEntity(
      id: doc.id,
      title: data['title'] as String? ?? '',
      targetAmount: (data['targetAmount'] as num?)?.toDouble() ?? 0.0,
      savedAmount: (data['savedAmount'] as num?)?.toDouble() ?? 0.0,
      targetDate: _date(data['targetDate']) ??
          _date(data['deadline']) ??
          DateTime.now(),
      category: data['category'] as String? ?? 'Other',
      emoji: data['emoji'] as String? ?? '🎯',
      colorHex: data['colorHex'] as String? ?? '#C1622A',
      isCompleted: data['isCompleted'] as bool? ?? false,
      completedAt: _date(data['completedAt']),
      createdAt: _date(data['createdAt']),
    );
  }

  static Map<String, dynamic> toJson(GoalEntity g) => {
        'title': g.title,
        'targetAmount': g.targetAmount,
        'savedAmount': g.savedAmount,
        'targetDate': Timestamp.fromDate(g.targetDate),
        // Mirror for the home dashboard which orders goals by `deadline`.
        'deadline': Timestamp.fromDate(g.targetDate),
        'category': g.category,
        'emoji': g.emoji,
        'colorHex': g.colorHex,
        'isCompleted': g.isCompleted,
        'completedAt':
            g.completedAt != null ? Timestamp.fromDate(g.completedAt!) : null,
        'createdAt': g.createdAt != null
            ? Timestamp.fromDate(g.createdAt!)
            : FieldValue.serverTimestamp(),
        'updatedAt': FieldValue.serverTimestamp(),
      };
}
