import 'package:cloud_firestore/cloud_firestore.dart';
import '../../../../core/errors/exceptions.dart';
import '../models/transaction_model.dart';

/// The ONLY file in the transaction feature that imports Firestore.
class TransactionFirebaseDataSource {
  final String uid;
  final FirebaseFirestore _firestore;

  TransactionFirebaseDataSource({
    required this.uid,
    FirebaseFirestore? firestore,
  }) : _firestore = firestore ?? FirebaseFirestore.instance;

  CollectionReference<Map<String, dynamic>> get _col =>
      _firestore.collection('users').doc(uid).collection('transactions');

  /// Writes a new transaction document to Firestore.
  Future<void> addTransaction(TransactionModel transaction) async {
    try {
      await _col.doc(transaction.id).set(transaction.toJson());
    } catch (e) {
      throw TransactionException('Failed to add transaction to Firestore: $e');
    }
  }

  /// Returns a real-time stream of transactions ordered by createdAt descending.
  Stream<List<TransactionModel>> watchTransactions() {
    try {
      return _col
          .orderBy('createdAt', descending: true)
          .snapshots()
          .map((snapshot) => snapshot.docs
              .map((doc) =>
                  TransactionModel.fromJson({...doc.data(), 'id': doc.id}))
              .toList());
    } catch (e) {
      throw TransactionException('Failed to watch transactions: $e');
    }
  }

  /// Returns transactions filtered by a date range, ordered by date descending.
  Future<List<TransactionModel>> getTransactionsByDateRange(
      DateTime startDate, DateTime endDate) async {
    try {
      final snapshot = await _col
          .where('date', isGreaterThanOrEqualTo: Timestamp.fromDate(startDate))
          .where('date', isLessThanOrEqualTo: Timestamp.fromDate(endDate))
          .orderBy('date', descending: true)
          .get();
      return snapshot.docs
          .map((doc) => TransactionModel.fromJson({...doc.data(), 'id': doc.id}))
          .toList();
    } catch (e) {
      throw TransactionException('Failed to query transactions by date range: $e');
    }
  }

  /// Returns transactions filtered by category, ordered by date descending.
  Future<List<TransactionModel>> getTransactionsByCategory(String category) async {
    try {
      final snapshot = await _col
          .where('category', isEqualTo: category)
          .orderBy('date', descending: true)
          .get();
      return snapshot.docs
          .map((doc) => TransactionModel.fromJson({...doc.data(), 'id': doc.id}))
          .toList();
    } catch (e) {
      throw TransactionException('Failed to query transactions by category: $e');
    }
  }
}
