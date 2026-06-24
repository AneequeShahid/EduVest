import 'dart:io';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_storage/firebase_storage.dart';

import '../../../../core/constants/firestore_paths.dart';
import '../../domain/entities/expense_entity.dart';
import '../models/expense_model.dart';

class ExpenseRemoteSource {
  final FirebaseFirestore _db;
  FirebaseStorage? _storageOrNull;

  ExpenseRemoteSource({FirebaseFirestore? db, FirebaseStorage? storage})
      : _db = db ?? FirebaseFirestore.instance,
        _storageOrNull = storage;

  // Resolved lazily so Firestore-only callers never touch FirebaseStorage.
  FirebaseStorage get _storage =>
      _storageOrNull ??= FirebaseStorage.instance;

  CollectionReference<Map<String, dynamic>> _col(String uid) => _db
      .collection(FirestorePaths.users)
      .doc(uid)
      .collection(FirestorePaths.expenses);

  DocumentReference<Map<String, dynamic>> _budgetDoc(String uid) => _db
      .collection(FirestorePaths.users)
      .doc(uid)
      .collection(FirestorePaths.budget)
      .doc(FirestorePaths.currentBudgetDoc);

  // ── Writes ───────────────────────────────────────────────────────────────

  /// Atomic batch: write the expense doc and bump the budget totals together.
  Future<void> addExpense(String uid, ExpenseEntity expense) async {
    final batch = _db.batch();
    batch.set(_col(uid).doc(expense.id), ExpenseModel.toJson(expense));

    if (!expense.isIncome) {
      batch.set(
        _budgetDoc(uid),
        {'monthlySpent': FieldValue.increment(expense.amount)},
        SetOptions(merge: true),
      );
      batch.set(
        _budgetDoc(uid).collection(FirestorePaths.categories).doc(expense.category),
        {
          'category': expense.category,
          'spent': FieldValue.increment(expense.amount),
        },
        SetOptions(merge: true),
      );
    }

    await batch.commit();
  }

  Future<void> updateExpense(String uid, ExpenseEntity expense) async {
    await _col(uid)
        .doc(expense.id)
        .set(ExpenseModel.toJson(expense, isUpdate: true), SetOptions(merge: true));
  }

  Future<void> deleteExpense(String uid, String expenseId) async {
    await _col(uid).doc(expenseId).delete();
  }

  // ── Reads ────────────────────────────────────────────────────────────────

  Stream<List<ExpenseEntity>> getExpensesStream(
    String uid, {
    int? month,
    int? year,
  }) {
    Query<Map<String, dynamic>> query = _col(uid);
    if (year != null) query = query.where('year', isEqualTo: year);
    if (month != null) query = query.where('month', isEqualTo: month);
    query = query.orderBy('date', descending: true);

    return query.snapshots().map(
          (snap) => snap.docs.map(ExpenseModel.fromDoc).toList(),
        );
  }

  // ── Storage ──────────────────────────────────────────────────────────────

  Future<String> uploadReceipt(String uid, String expenseId, File file) async {
    final ref = _storage.ref().child('users/$uid/receipts/$expenseId.jpg');
    final task = await ref.putFile(file);
    return task.ref.getDownloadURL();
  }

  Future<void> deleteReceipt(String uid, String expenseId) async {
    await _storage.ref().child('users/$uid/receipts/$expenseId.jpg').delete();
  }
}
