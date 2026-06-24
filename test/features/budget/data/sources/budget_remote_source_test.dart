import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:eduvest_output/features/budget/data/sources/budget_remote_source.dart';
import 'package:eduvest_output/features/budget/domain/entities/budget_entity.dart';
import 'package:fake_cloud_firestore/fake_cloud_firestore.dart';
import 'package:flutter_test/flutter_test.dart';

void main() {
  const uid = 'uid-1';
  const month = 3;
  const year = 2024;
  const docId = '2024-03';

  late FakeFirebaseFirestore firestore;
  late BudgetRemoteSource source;

  setUp(() {
    firestore = FakeFirebaseFirestore();
    source = BudgetRemoteSource(db: firestore);
  });

  CollectionReference<Map<String, dynamic>> budgetCol() =>
      firestore.collection('users').doc(uid).collection('budget');

  CollectionReference<Map<String, dynamic>> expensesCol() =>
      firestore.collection('users').doc(uid).collection('expenses');

  Future<void> seedBudget({double limit = 1000}) =>
      budgetCol().doc(docId).set({
        'month': month,
        'year': year,
        'totalLimit': limit,
        'daysInMonth': 31,
      });

  Future<void> seedCategory(String id, String name, double limit) =>
      budgetCol()
          .doc(docId)
          .collection('categories')
          .doc(id)
          .set({'name': name, 'limit': limit});

  Future<void> addExpense(
      String id, double amount, String category, int m, int y) {
    return expensesCol().doc(id).set({
      'amount': amount,
      'category': category,
      'month': m,
      'year': y,
      'isIncome': false,
      'date': Timestamp.fromDate(DateTime(y, m, 5)),
    });
  }

  test('1. correctly sums expenses by category for the current month',
      () async {
    await seedBudget();
    await seedCategory('groceries', 'Groceries', 400);
    await seedCategory('rent', 'Rent', 1200);
    await addExpense('e1', 100, 'Groceries', month, year);
    await addExpense('e2', 50, 'Groceries', month, year);
    await addExpense('e3', 200, 'Rent', month, year);

    final budget = await source.getBudget(uid, month, year);

    expect(budget, isNotNull);
    final groceries =
        budget!.categories.firstWhere((c) => c.name == 'Groceries');
    final rent = budget.categories.firstWhere((c) => c.name == 'Rent');
    expect(groceries.spent, 150);
    expect(rent.spent, 200);
    expect(budget.totalSpent, 350);
  });

  test('2. does not include previous-month expenses', () async {
    await seedBudget();
    await seedCategory('groceries', 'Groceries', 400);
    await addExpense('cur', 100, 'Groceries', month, year);
    await addExpense('prev', 999, 'Groceries', 2, year); // February

    final budget = await source.getBudget(uid, month, year);

    expect(budget!.totalSpent, 100);
  });

  test('3. stream updates when a new expense is added', () async {
    await seedBudget();
    await seedCategory('groceries', 'Groceries', 400);

    final stream = source.watchBudget(uid, month, year);
    expectLater(
      stream.map((b) => b?.totalSpent),
      emitsThrough(120.0),
    );

    await addExpense('e1', 120, 'Groceries', month, year);
  });

  test('4. correctly computes remaining amounts', () async {
    await seedBudget(limit: 1000);
    await seedCategory('groceries', 'Groceries', 400);
    await addExpense('e1', 350, 'Groceries', month, year);

    final budget = await source.getBudget(uid, month, year);

    expect(budget!.remainingAmount, 650);
    final groceries =
        budget.categories.firstWhere((c) => c.name == 'Groceries');
    expect(groceries.remaining, 50); // 400 - 350
  });

  test('returns null when no budget doc exists', () async {
    final budget = await source.getBudget(uid, month, year);
    expect(budget, isNull);
  });

  test('budget is a BudgetEntity', () async {
    await seedBudget();
    final budget = await source.getBudget(uid, month, year);
    expect(budget, isA<BudgetEntity>());
  });
}
