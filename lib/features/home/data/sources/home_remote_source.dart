import 'package:cloud_firestore/cloud_firestore.dart';

import '../../../../core/constants/firestore_paths.dart';
import '../../domain/entities/goal_summary_entity.dart';
import '../../domain/entities/transaction_entity.dart';
import '../../domain/repositories/home_repository.dart';

/// Firestore-backed reads for the home dashboard.
///
/// Data layout (all under `users/{uid}`):
///   - `expenses` : { amount, description, category, date:Timestamp }
///   - `income`   : { amount, date:Timestamp }
///   - `budget/current` : { monthlyLimit }
///   - `goals`    : { title, savedAmount, targetAmount, category, deadline }
class HomeRemoteSource {
  final FirebaseFirestore _db;
  final String _uid;

  HomeRemoteSource({required String uid, FirebaseFirestore? db})
      : _uid = uid,
        _db = db ?? FirebaseFirestore.instance;

  CollectionReference<Map<String, dynamic>> get _expenses => _db
      .collection(FirestorePaths.users)
      .doc(_uid)
      .collection(FirestorePaths.expenses);

  CollectionReference<Map<String, dynamic>> get _income => _db
      .collection(FirestorePaths.users)
      .doc(_uid)
      .collection(FirestorePaths.income);

  CollectionReference<Map<String, dynamic>> get _goals => _db
      .collection(FirestorePaths.users)
      .doc(_uid)
      .collection(FirestorePaths.goals);

  // ── Balance ────────────────────────────────────────────────────────────────

  Future<double> getTotalBalance() async {
    final incomeSnap = await _income.get();
    final expenseSnap = await _expenses.get();

    // Income is recorded inside the expenses collection with `isIncome: true`,
    // plus any docs in the legacy income collection. Everything else is spend.
    var income = _sumAmount(incomeSnap.docs);
    var spent = 0.0;
    for (final d in expenseSnap.docs) {
      final data = d.data();
      final amount = (data['amount'] as num?)?.toDouble() ?? 0.0;
      if (data['isIncome'] == true) {
        income += amount;
      } else {
        spent += amount;
      }
    }
    return income - spent;
  }

  // ── Budget ──────────────────────────────────────────────────────────────────

  Future<MonthlyBudget> getMonthlyBudget() async {
    // Read the same per-month document the Budget feature writes
    // (`budget/{year-MM}`, field `totalLimit`) so the home card stays in sync.
    final now = DateTime.now();
    final docId = '${now.year}-${now.month.toString().padLeft(2, '0')}';
    final budgetDoc = await _db
        .collection(FirestorePaths.users)
        .doc(_uid)
        .collection(FirestorePaths.budget)
        .doc(docId)
        .get();

    final data = budgetDoc.data();
    final limit = (data?['totalLimit'] as num?)?.toDouble() ??
        (data?['monthlyLimit'] as num?)?.toDouble() ??
        (data?['limit'] as num?)?.toDouble() ??
        0.0;

    final spent = await _spentForMonth(now);
    return (limit: limit, spent: spent);
  }

  // ── Recent transactions ──────────────────────────────────────────────────────

  Future<List<TransactionEntity>> getRecentTransactions() async {
    final snap =
        await _expenses.orderBy('date', descending: true).limit(5).get();
    return snap.docs.map(_transactionFromDoc).toList();
  }

  Stream<List<TransactionEntity>> watchRecentTransactions() {
    return _expenses
        .orderBy('date', descending: true)
        .limit(5)
        .snapshots()
        .map((snap) => snap.docs.map(_transactionFromDoc).toList());
  }

  // ── Active goal ──────────────────────────────────────────────────────────────

  Future<GoalSummaryEntity?> getActiveGoal() async {
    final snap = await _goals.orderBy('deadline').get();
    for (final doc in snap.docs) {
      final data = doc.data();
      final saved = (data['savedAmount'] as num?)?.toDouble() ?? 0.0;
      final target = (data['targetAmount'] as num?)?.toDouble() ?? 0.0;
      if (saved < target || target == 0) {
        return GoalSummaryEntity(
          id: doc.id,
          title: data['title'] as String? ?? 'Goal',
          savedAmount: saved,
          targetAmount: target,
          category: data['category'] as String? ?? 'Others',
        );
      }
    }
    return null;
  }

  // ── Balance change ───────────────────────────────────────────────────────────

  /// Month-over-month change in spending, expressed as a percentage.
  /// Positive means this month's spending is lower than last month's
  /// (an improvement), which the UI shows as a green pill.
  Future<double> getBalanceChangePercent() async {
    final now = DateTime.now();
    final thisMonth = await _spentForMonth(now);
    final lastMonth = await _spentForMonth(DateTime(now.year, now.month - 1));
    if (lastMonth <= 0) return 0.0;
    return ((lastMonth - thisMonth) / lastMonth) * 100;
  }

  // ── Helpers ──────────────────────────────────────────────────────────────────

  Future<double> _spentForMonth(DateTime month) async {
    final start = DateTime(month.year, month.month, 1);
    final end = DateTime(month.year, month.month + 1, 1);
    final snap = await _expenses
        .where('date',
            isGreaterThanOrEqualTo: Timestamp.fromDate(start),
            isLessThan: Timestamp.fromDate(end))
        .get();
    // Spending excludes income entries.
    var total = 0.0;
    for (final d in snap.docs) {
      if (d.data()['isIncome'] == true) continue;
      total += (d.data()['amount'] as num?)?.toDouble() ?? 0.0;
    }
    return total;
  }

  double _sumAmount(List<QueryDocumentSnapshot<Map<String, dynamic>>> docs) {
    var total = 0.0;
    for (final d in docs) {
      total += (d.data()['amount'] as num?)?.toDouble() ?? 0.0;
    }
    return total;
  }

  TransactionEntity _transactionFromDoc(
      QueryDocumentSnapshot<Map<String, dynamic>> doc) {
    final data = doc.data();
    final rawDate = data['date'];
    final date = rawDate is Timestamp
        ? rawDate.toDate()
        : (rawDate is String ? DateTime.parse(rawDate) : DateTime.now());
    return TransactionEntity(
      id: doc.id,
      amount: (data['amount'] as num?)?.toDouble() ?? 0.0,
      description:
          data['description'] as String? ?? data['note'] as String? ?? '',
      category: data['category'] as String? ?? 'Others',
      date: date,
      isIncome: data['isIncome'] as bool? ?? false,
    );
  }
}
