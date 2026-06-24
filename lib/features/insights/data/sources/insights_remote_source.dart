import 'package:cloud_firestore/cloud_firestore.dart';

import '../../../../core/constants/firestore_paths.dart';
import '../../domain/entities/goal_progress_status.dart';
import '../../domain/entities/insights_raw_data.dart';
import '../../domain/entities/monthly_flow_entity.dart';

/// Read-only aggregation across expenses, budget and goals. Performs only
/// fetching + light grouping; all scoring lives in the domain layer.
class InsightsRemoteSource {
  final FirebaseFirestore _db;

  InsightsRemoteSource({FirebaseFirestore? db})
      : _db = db ?? FirebaseFirestore.instance;

  CollectionReference<Map<String, dynamic>> _expenses(String uid) => _db
      .collection(FirestorePaths.users)
      .doc(uid)
      .collection(FirestorePaths.expenses);

  CollectionReference<Map<String, dynamic>> _goals(String uid) => _db
      .collection(FirestorePaths.users)
      .doc(uid)
      .collection(FirestorePaths.goals);

  /// Returns ([month], [year]) shifted back by [monthsAgo].
  static (int, int) _shift(int month, int year, int monthsAgo) {
    var m = month - monthsAgo;
    var y = year;
    while (m <= 0) {
      m += 12;
      y -= 1;
    }
    return (m, y);
  }

  Future<InsightsRawData> getRawData(String uid, int month, int year) async {
    // Fetch all expenses once, then bucket in memory (avoids many queries).
    final expenseSnap = await _expenses(uid).get();
    final expenses = expenseSnap.docs.map((d) => d.data()).toList();

    // 6-month capital flow (oldest → newest).
    final flow = <MonthlyFlowEntity>[];
    for (var i = 5; i >= 0; i--) {
      final (m, y) = _shift(month, year, i);
      var spent = 0.0;
      var income = 0.0;
      for (final e in expenses) {
        if ((e['month'] as num?)?.toInt() != m ||
            (e['year'] as num?)?.toInt() != y) {
          continue;
        }
        final amount = (e['amount'] as num?)?.toDouble() ?? 0.0;
        if (e['isIncome'] == true) {
          income += amount;
        } else {
          spent += amount;
        }
      }
      flow.add(MonthlyFlowEntity(
          month: m, year: y, totalSpent: spent, totalIncome: income));
    }

    // Current-month category totals (expenses only).
    final categoryTotals = <String, double>{};
    for (final e in expenses) {
      if ((e['month'] as num?)?.toInt() != month ||
          (e['year'] as num?)?.toInt() != year ||
          e['isIncome'] == true) {
        continue;
      }
      final amount = (e['amount'] as num?)?.toDouble() ?? 0.0;
      final cat = e['category'] as String? ?? 'Others';
      categoryTotals[cat] = (categoryTotals[cat] ?? 0) + amount;
    }

    // Last 3 months spending (for variance) + 6-month total expenses.
    final last3 =
        flow.sublist(flow.length - 3).map((f) => f.totalSpent).toList();
    final totalExpenses =
        flow.fold<double>(0, (acc, f) => acc + f.totalSpent);

    // Budget usage for the current month.
    final budgetDoc = await _db
        .collection(FirestorePaths.users)
        .doc(uid)
        .collection(FirestorePaths.budget)
        .doc('$year-${month.toString().padLeft(2, '0')}')
        .get();
    final limit = (budgetDoc.data()?['totalLimit'] as num?)?.toDouble() ??
        (budgetDoc.data()?['monthlyLimit'] as num?)?.toDouble() ??
        0.0;
    final currentSpent =
        categoryTotals.values.fold<double>(0, (a, b) => a + b);
    final budgetUsagePercent = limit > 0 ? currentSpent / limit : 0.0;

    // Goals → total saved + aggregate progress status.
    final goalsSnap = await _goals(uid).get();
    var totalSaved = 0.0;
    final progresses = <double>[];
    final timeProgresses = <double>[];
    final now = DateTime.now();
    for (final doc in goalsSnap.docs) {
      final data = doc.data();
      final saved = (data['savedAmount'] as num?)?.toDouble() ?? 0.0;
      final target = (data['targetAmount'] as num?)?.toDouble() ?? 0.0;
      totalSaved += saved;
      if (target <= 0) continue;
      progresses.add((saved / target).clamp(0.0, 1.0));

      final created = (data['createdAt'] as Timestamp?)?.toDate();
      final due = (data['targetDate'] as Timestamp?)?.toDate() ??
          (data['deadline'] as Timestamp?)?.toDate();
      if (created != null && due != null && due.isAfter(created)) {
        final total = due.difference(created).inDays;
        final elapsed = now.difference(created).inDays.clamp(0, total);
        timeProgresses.add(total > 0 ? elapsed / total : 1.0);
      }
    }

    final goalStatus = _goalStatus(progresses, timeProgresses);

    return InsightsRawData(
      last6Months: flow,
      categoryTotals: categoryTotals,
      budgetUsagePercent: budgetUsagePercent,
      totalSaved: totalSaved,
      totalExpenses: totalExpenses,
      goalStatus: goalStatus,
      last3MonthsSpending: last3,
    );
  }

  GoalProgressStatus _goalStatus(
      List<double> progresses, List<double> timeProgresses) {
    if (progresses.isEmpty) return GoalProgressStatus.noGoals;
    final avgProgress =
        progresses.reduce((a, b) => a + b) / progresses.length;
    final avgExpected = timeProgresses.isEmpty
        ? avgProgress
        : timeProgresses.reduce((a, b) => a + b) / timeProgresses.length;
    final gap = avgExpected - avgProgress;
    if (gap <= 0.05) return GoalProgressStatus.onTrack;
    if (gap <= 0.20) return GoalProgressStatus.slightlyBehind;
    return GoalProgressStatus.veryBehind;
  }
}
