import 'package:cloud_firestore/cloud_firestore.dart';

import '../../../../core/constants/firestore_paths.dart';
import '../../domain/entities/budget_category_entity.dart';
import '../../domain/entities/budget_entity.dart';
import '../models/budget_category_model.dart';
import '../models/budget_model.dart';

/// Firestore reads/writes for budgets. Spending is always computed live from
/// the `expenses` collection (the single source of truth), then merged with
/// per-category limits.
class BudgetRemoteSource {
  final FirebaseFirestore _db;

  BudgetRemoteSource({FirebaseFirestore? db})
      : _db = db ?? FirebaseFirestore.instance;

  CollectionReference<Map<String, dynamic>> _budgetCol(String uid) => _db
      .collection(FirestorePaths.users)
      .doc(uid)
      .collection(FirestorePaths.budget);

  DocumentReference<Map<String, dynamic>> _budgetDoc(
          String uid, int month, int year) =>
      _budgetCol(uid).doc(BudgetModel.docId(month, year));

  CollectionReference<Map<String, dynamic>> _categoriesCol(
          String uid, int month, int year) =>
      _budgetDoc(uid, month, year).collection(FirestorePaths.categories);

  CollectionReference<Map<String, dynamic>> _expenses(String uid) => _db
      .collection(FirestorePaths.users)
      .doc(uid)
      .collection(FirestorePaths.expenses);

  static int daysInMonth(int month, int year) =>
      DateTime(year, month + 1, 0).day;

  // ── Reads ────────────────────────────────────────────────────────────────

  /// Re-emits whenever the month's expenses change.
  Stream<BudgetEntity?> watchBudget(String uid, int month, int year) {
    return _monthExpenses(uid, month, year).snapshots().asyncMap(
          (expSnap) => _compose(uid, month, year, expSnap.docs),
        );
  }

  Future<BudgetEntity?> getBudget(String uid, int month, int year) async {
    final expSnap = await _monthExpenses(uid, month, year).get();
    return _compose(uid, month, year, expSnap.docs);
  }

  Query<Map<String, dynamic>> _monthExpenses(
          String uid, int month, int year) =>
      _expenses(uid).where('year', isEqualTo: year).where('month',
          isEqualTo: month);

  Future<BudgetEntity?> _compose(
    String uid,
    int month,
    int year,
    List<QueryDocumentSnapshot<Map<String, dynamic>>> expenseDocs,
  ) async {
    final budgetDoc = await _budgetDoc(uid, month, year).get();
    if (!budgetDoc.exists) return null;

    // Sum non-income expenses by category.
    final spentByCategory = <String, double>{};
    var totalSpent = 0.0;
    for (final doc in expenseDocs) {
      final data = doc.data();
      if (data['isIncome'] == true) continue;
      final amount = (data['amount'] as num?)?.toDouble() ?? 0.0;
      final category = data['category'] as String? ?? 'Others';
      spentByCategory[category] = (spentByCategory[category] ?? 0) + amount;
      totalSpent += amount;
    }

    final catSnap = await _categoriesCol(uid, month, year).get();
    final categories = catSnap.docs.map((d) {
      final name = d.data()['name'] as String? ?? d.id;
      return BudgetCategoryModel.fromDoc(d,
          spent: spentByCategory[name] ?? 0.0);
    }).toList();

    final data = budgetDoc.data() ?? const {};
    return BudgetEntity(
      month: month,
      year: year,
      totalLimit: (data['totalLimit'] as num?)?.toDouble() ?? 0.0,
      totalSpent: totalSpent,
      daysInMonth:
          (data['daysInMonth'] as num?)?.toInt() ?? daysInMonth(month, year),
      categories: categories,
    );
  }

  /// Average monthly spend per category over the previous 3 months.
  Future<Map<String, double>> getThreeMonthAverageByCategory(
      String uid, int month, int year) async {
    final totals = <String, double>{};
    for (var i = 1; i <= 3; i++) {
      var m = month - i;
      var y = year;
      while (m <= 0) {
        m += 12;
        y -= 1;
      }
      final snap = await _expenses(uid)
          .where('year', isEqualTo: y)
          .where('month', isEqualTo: m)
          .get();
      for (final doc in snap.docs) {
        final data = doc.data();
        if (data['isIncome'] == true) continue;
        final amount = (data['amount'] as num?)?.toDouble() ?? 0.0;
        final category = data['category'] as String? ?? 'Others';
        totals[category] = (totals[category] ?? 0) + amount;
      }
    }
    return totals.map((k, v) => MapEntry(k, v / 3));
  }

  // ── Writes ───────────────────────────────────────────────────────────────

  Future<void> setMonthlyLimit(
      String uid, int month, int year, double limit) async {
    final ref = _budgetDoc(uid, month, year);
    final exists = (await ref.get()).exists;
    await ref.set(
      BudgetModel.toJson(
        month: month,
        year: year,
        totalLimit: limit,
        daysInMonth: daysInMonth(month, year),
        isUpdate: exists,
      ),
      SetOptions(merge: true),
    );
  }

  Future<void> addCategory(
      String uid, int month, int year, BudgetCategoryEntity category) async {
    final col = _categoriesCol(uid, month, year);
    final ref = category.id.isEmpty ? col.doc() : col.doc(category.id);
    await ref.set(BudgetCategoryModel.toJson(category));
  }

  Future<void> updateCategory(
      String uid, int month, int year, BudgetCategoryEntity category) async {
    await _categoriesCol(uid, month, year)
        .doc(category.id)
        .set(BudgetCategoryModel.toJson(category), SetOptions(merge: true));
  }

  Future<void> deleteCategory(
      String uid, int month, int year, String categoryId) async {
    await _categoriesCol(uid, month, year).doc(categoryId).delete();
  }

  Future<void> markAsPaid(
      String uid, int month, int year, String categoryId, bool isPaid) async {
    await _categoriesCol(uid, month, year)
        .doc(categoryId)
        .set({'isPaid': isPaid}, SetOptions(merge: true));
  }
}
