import 'package:cloud_firestore/cloud_firestore.dart';
import '../../../../core/errors/exceptions.dart';
import '../models/transaction_model.dart';

class HomeFirebaseDataSource {
  final String uid;
  final FirebaseFirestore _firestore;

  HomeFirebaseDataSource({
    required this.uid,
    FirebaseFirestore? firestore,
  }) : _firestore = firestore ?? FirebaseFirestore.instance;

  CollectionReference<Map<String, dynamic>> get _transactionsCollection =>
      _firestore.collection('users').doc(uid).collection('transactions');

  DocumentReference<Map<String, dynamic>> get _budgetDoc =>
      _firestore.collection('users').doc(uid).collection('budget').doc('current');

  /// Computes the user's total balance from their transactions (income minus expenses).
  Future<double> getBalanceSummary() async {
    try {
      final snapshot = await _transactionsCollection.get();
      double balance = 0.0;
      for (final doc in snapshot.docs) {
        final data = doc.data();
        final amount = (data['amount'] as num?)?.toDouble() ?? 0.0;
        final type = data['type'] as String?;
        if (type == 'income') {
          balance += amount;
        } else if (type == 'expense') {
          balance -= amount;
        }
      }
      return balance;
    } catch (e) {
      throw HomeException('Failed to calculate balance summary from Firestore: $e');
    }
  }

  /// Fetches the last 5 transactions ordered by createdAt descending.
  Future<List<TransactionModel>> getRecentTransactions({int limit = 5}) async {
    try {
      final snapshot = await _transactionsCollection
          .orderBy('createdAt', descending: true)
          .limit(limit)
          .get();
      return snapshot.docs
          .map((doc) => TransactionModel.fromJson({...doc.data(), 'id': doc.id}))
          .toList();
    } catch (e) {
      throw HomeException('Failed to fetch recent transactions: $e');
    }
  }

  /// Reads budget usage from users/{uid}/budget/current.
  Future<Map<String, double>> getMonthlyBudgetUsage() async {
    try {
      final snapshot = await _budgetDoc.get();
      if (!snapshot.exists || snapshot.data() == null) {
        return {
          'totalBudget': 1500.0,
          'spent': 0.0,
        };
      }
      final data = snapshot.data()!;
      final totalBudget = (data['totalBudget'] as num?)?.toDouble() ?? (data['monthlyLimit'] as num?)?.toDouble() ?? 1500.0;
      
      // Calculate spent as sum of spent in all categories or monthlySpent field
      double spent = (data['monthlySpent'] as num?)?.toDouble() ?? 0.0;
      if (spent == 0.0) {
        final categoriesRaw = data['categories'];
        if (categoriesRaw is Map) {
          categoriesRaw.forEach((k, v) {
            if (v is Map) {
              spent += (v['spent'] as num?)?.toDouble() ?? 0.0;
            }
          });
        }
      }
      
      return {
        'totalBudget': totalBudget,
        'spent': spent,
      };
    } catch (e) {
      throw HomeException('Failed to fetch monthly budget usage: $e');
    }
  }
}
