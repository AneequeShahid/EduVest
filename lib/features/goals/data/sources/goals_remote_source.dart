import 'dart:math' as math;

import 'package:cloud_firestore/cloud_firestore.dart';

import '../../../../core/constants/firestore_paths.dart';
import '../../domain/entities/contribution_entity.dart';
import '../../domain/entities/goal_entity.dart';
import '../models/contribution_model.dart';
import '../models/goal_model.dart';

class GoalsRemoteSource {
  final FirebaseFirestore _db;

  GoalsRemoteSource({FirebaseFirestore? db})
      : _db = db ?? FirebaseFirestore.instance;

  CollectionReference<Map<String, dynamic>> _goals(String uid) => _db
      .collection(FirestorePaths.users)
      .doc(uid)
      .collection(FirestorePaths.goals);

  CollectionReference<Map<String, dynamic>> _contribs(
          String uid, String goalId) =>
      _goals(uid).doc(goalId).collection(FirestorePaths.contributions);

  // ── Reads ────────────────────────────────────────────────────────────────

  Stream<List<GoalEntity>> watchGoals(String uid) {
    return _goals(uid)
        .orderBy('isCompleted')
        .orderBy('createdAt', descending: true)
        .snapshots()
        .map((snap) => snap.docs.map(GoalModel.fromDoc).toList());
  }

  Future<List<ContributionEntity>> getRecentContributions(
      String uid, String goalId,
      {int limit = 5}) async {
    final snap = await _contribs(uid, goalId)
        .orderBy('date', descending: true)
        .limit(limit)
        .get();
    return snap.docs.map(ContributionModel.fromDoc).toList();
  }

  // ── Writes ───────────────────────────────────────────────────────────────

  Future<void> createGoal(String uid, GoalEntity goal) async {
    final ref =
        goal.id.isEmpty ? _goals(uid).doc() : _goals(uid).doc(goal.id);
    await ref.set(GoalModel.toJson(goal));
  }

  /// Atomic: append a contribution, increment savedAmount (capped at the
  /// target) and flip completion — all in one transaction.
  Future<void> addFunds(
      String uid, String goalId, double amount, String? note) async {
    final goalRef = _goals(uid).doc(goalId);
    final contribRef = _contribs(uid, goalId).doc();

    await _db.runTransaction((tx) async {
      final snap = await tx.get(goalRef);
      if (!snap.exists) {
        throw StateError('Goal not found');
      }
      final data = snap.data()!;
      final current = (data['savedAmount'] as num?)?.toDouble() ?? 0.0;
      final target = (data['targetAmount'] as num?)?.toDouble() ?? 0.0;

      final newSaved = math.min(current + amount, target);
      final completed = newSaved >= target && target > 0;

      tx.set(contribRef, ContributionModel.toJson(amount, note));
      tx.update(goalRef, {
        'savedAmount': newSaved,
        'isCompleted': completed,
        if (completed) 'completedAt': FieldValue.serverTimestamp(),
        'updatedAt': FieldValue.serverTimestamp(),
      });
    });
  }

  Future<void> adjustPlan(
    String uid,
    String goalId, {
    double? targetAmount,
    DateTime? targetDate,
  }) async {
    await _goals(uid).doc(goalId).update({
      if (targetAmount != null) 'targetAmount': targetAmount,
      if (targetDate != null) ...{
        'targetDate': Timestamp.fromDate(targetDate),
        'deadline': Timestamp.fromDate(targetDate),
      },
      'updatedAt': FieldValue.serverTimestamp(),
    });
  }

  Future<void> deleteGoal(String uid, String goalId) async {
    final contribs = await _contribs(uid, goalId).get();
    final batch = _db.batch();
    for (final doc in contribs.docs) {
      batch.delete(doc.reference);
    }
    batch.delete(_goals(uid).doc(goalId));
    await batch.commit();
  }
}
