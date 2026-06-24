import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:fake_cloud_firestore/fake_cloud_firestore.dart';
import 'package:eduvest_output/features/expense/data/sources/expense_remote_source.dart';
import 'package:eduvest_output/features/expense/domain/entities/expense_entity.dart';
import 'package:flutter_test/flutter_test.dart';

void main() {
  const uid = 'uid-1';
  late FakeFirebaseFirestore firestore;
  late ExpenseRemoteSource source;

  setUp(() {
    firestore = FakeFirebaseFirestore();
    source = ExpenseRemoteSource(db: firestore);
  });

  CollectionReference<Map<String, dynamic>> expensesCol() =>
      firestore.collection('users').doc(uid).collection('expenses');

  ExpenseEntity expense({
    String id = 'e1',
    double amount = 25.0,
    String category = 'Education',
    DateTime? date,
    bool isIncome = false,
  }) =>
      ExpenseEntity(
        id: id,
        amount: amount,
        description: 'Textbook',
        category: category,
        date: date ?? DateTime(2026, 7, 4),
        month: 0,
        year: 0,
        isIncome: isIncome,
      );

  test('1. creates a document in users/{uid}/expenses with correct fields',
      () async {
    await source.addExpense(uid, expense(amount: 42.0));

    final doc = await expensesCol().doc('e1').get();
    expect(doc.exists, isTrue);
    final data = doc.data()!;
    expect(data['amount'], 42.0);
    expect(data['description'], 'Textbook');
    expect(data['category'], 'Education');
    expect(data['isIncome'], false);
    expect(data['date'], isA<Timestamp>());
  });

  test('2. sets month and year automatically from the date', () async {
    await source.addExpense(uid, expense(date: DateTime(2026, 7, 4)));

    final data = (await expensesCol().doc('e1').get()).data()!;
    expect(data['month'], 7);
    expect(data['year'], 2026);
  });

  test('3. queries correctly by month and year', () async {
    await source.addExpense(uid, expense(id: 'jul', date: DateTime(2026, 7, 4)));
    await source.addExpense(uid, expense(id: 'aug', date: DateTime(2026, 8, 1)));
    await source.addExpense(uid, expense(id: 'jul25', date: DateTime(2025, 7, 9)));

    final result =
        await source.getExpensesStream(uid, month: 7, year: 2026).first;

    expect(result.map((e) => e.id), ['jul']);
  });

  test('4. deletes the document on deleteExpense', () async {
    await source.addExpense(uid, expense());
    expect((await expensesCol().doc('e1').get()).exists, isTrue);

    await source.deleteExpense(uid, 'e1');

    expect((await expensesCol().doc('e1').get()).exists, isFalse);
  });

  test('5. stream updates when a new expense is added', () async {
    final stream = source.getExpensesStream(uid, month: 7, year: 2026);

    expectLater(
      stream.map((list) => list.length),
      emitsThrough(1),
    );

    await source.addExpense(uid, expense(date: DateTime(2026, 7, 4)));
  });
}
