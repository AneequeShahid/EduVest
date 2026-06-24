import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:eduvest_output/features/budget/data/repositories/budget_repository_impl.dart';
import 'package:eduvest_output/features/budget/data/sources/budget_remote_source.dart';
import 'package:eduvest_output/features/budget/domain/usecases/get_budget_usecase.dart';
import 'package:fake_cloud_firestore/fake_cloud_firestore.dart';
import 'package:flutter_test/flutter_test.dart';

void main() {
  const uid = 'uid-1';
  final now = DateTime.now();
  final month = now.month;
  final year = now.year;
  final docId = '$year-${month.toString().padLeft(2, '0')}';
  final daysInMonth = DateTime(year, month + 1, 0).day;

  late FakeFirebaseFirestore firestore;
  late GetBudgetUseCase useCase;

  setUp(() {
    firestore = FakeFirebaseFirestore();
    useCase = GetBudgetUseCase(
        BudgetRepositoryImpl(BudgetRemoteSource(db: firestore)));
  });

  CollectionReference<Map<String, dynamic>> expensesCol() =>
      firestore.collection('users').doc(uid).collection('expenses');

  Future<void> seedBudget({double limit = 1000}) async {
    await firestore
        .collection('users')
        .doc(uid)
        .collection('budget')
        .doc(docId)
        .set({
      'month': month,
      'year': year,
      'totalLimit': limit,
      'daysInMonth': daysInMonth,
    });
  }

  Future<void> addExpense(String id, double amount, String category,
      {bool isIncome = false}) {
    return expensesCol().doc(id).set({
      'amount': amount,
      'category': category,
      'month': month,
      'year': year,
      'isIncome': isIncome,
      'date': Timestamp.fromDate(DateTime(year, month, 5)),
    });
  }

  test('1. returns BudgetEntity with correct totalSpent from expenses',
      () async {
    await seedBudget();
    await addExpense('e1', 200, 'Groceries');
    await addExpense('e2', 100, 'Rent');
    await addExpense('e3', 500, 'Salary', isIncome: true); // ignored

    final result = await useCase(uid, month, year);

    final budget = result.getOrElse(() => throw 'expected Right');
    expect(budget.totalSpent, 300);
  });

  test('2. usagePercent calculates correctly', () async {
    await seedBudget(limit: 1000);
    await addExpense('e1', 300, 'Groceries');

    final budget = (await useCase(uid, month, year))
        .getOrElse(() => throw 'expected Right');
    expect(budget.usagePercent, closeTo(0.3, 0.0001));
  });

  test('3. remainingAmount calculates correctly', () async {
    await seedBudget(limit: 1000);
    await addExpense('e1', 300, 'Groceries');

    final budget = (await useCase(uid, month, year))
        .getOrElse(() => throw 'expected Right');
    expect(budget.remainingAmount, 700);
  });

  test('4. dailyAllowance is correct', () async {
    await seedBudget(limit: 1000);
    await addExpense('e1', 300, 'Groceries');

    final budget = (await useCase(uid, month, year))
        .getOrElse(() => throw 'expected Right');
    final expectedDays = daysInMonth - now.day + 1;
    expect(budget.dailyAllowance, closeTo(700 / expectedDays, 0.0001));
  });

  test('5. daysRemaining is correct for the current month', () async {
    await seedBudget();

    final budget = (await useCase(uid, month, year))
        .getOrElse(() => throw 'expected Right');
    expect(budget.daysRemaining, daysInMonth - now.day + 1);
  });

  test('6. returns Left(Failure) when no budget set', () async {
    // No budget doc seeded.
    final result = await useCase(uid, month, year);
    expect(result.isLeft(), isTrue);
  });
}
