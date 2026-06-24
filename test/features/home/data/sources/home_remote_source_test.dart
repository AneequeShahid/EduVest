import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:fake_cloud_firestore/fake_cloud_firestore.dart';
import 'package:eduvest_output/features/home/data/sources/home_remote_source.dart';
import 'package:flutter_test/flutter_test.dart';

void main() {
  const uid = 'user-1';
  late FakeFirebaseFirestore firestore;
  late HomeRemoteSource source;

  CollectionReference<Map<String, dynamic>> col(String name) =>
      firestore.collection('users').doc(uid).collection(name);

  setUp(() {
    firestore = FakeFirebaseFirestore();
    source = HomeRemoteSource(uid: uid, db: firestore);
  });

  Future<void> addExpense(String id, double amount, DateTime date,
      {String category = 'Food', bool isIncome = false}) {
    return col('expenses').doc(id).set({
      'id': id,
      'amount': amount,
      'description': 'exp-$id',
      'category': category,
      'date': Timestamp.fromDate(date),
      'isIncome': isIncome,
    });
  }

  test('1. queries expenses ordered by date DESC, limited to 5', () async {
    final now = DateTime(2026, 5, 15);
    // Insert 6 expenses on ascending days; newest = day 6.
    for (var i = 1; i <= 6; i++) {
      await addExpense('e$i', i.toDouble(), DateTime(now.year, now.month, i));
    }

    final result = await source.getRecentTransactions();

    expect(result.length, 5);
    // Newest first → day 6 then 5,4,3,2.
    expect(result.first.id, 'e6');
    for (var i = 0; i < result.length - 1; i++) {
      expect(
        result[i].date.isAfter(result[i + 1].date),
        isTrue,
        reason: 'transactions must be ordered by date DESC',
      );
    }
  });

  test('2. calculates total balance as income − expenses', () async {
    await col('income').doc('i1').set({'amount': 1000.0});
    await col('income').doc('i2').set({'amount': 500.0});
    await addExpense('e1', 200, DateTime(2026, 5, 1));
    await addExpense('e2', 50, DateTime(2026, 5, 2));

    final balance = await source.getTotalBalance();

    expect(balance, 1250.0); // 1500 income − 250 expenses
  });

  test('3. returns the configured limit and current-month spent', () async {
    final now = DateTime.now();
    await col('budget').doc('current').set({'monthlyLimit': 800.0});
    // Two expenses this month + one last month (excluded from "spent").
    await addExpense('cur1', 120, DateTime(now.year, now.month, 5));
    await addExpense('cur2', 80, DateTime(now.year, now.month, 12));
    await addExpense(
        'prev', 999, DateTime(now.year, now.month - 1, 10));

    final budget = await source.getMonthlyBudget();

    expect(budget.limit, 800.0);
    expect(budget.spent, 200.0); // only this month's 120 + 80
  });

  test('4. returns an empty list when there are no transactions', () async {
    final result = await source.getRecentTransactions();
    expect(result, isEmpty);
  });
}
