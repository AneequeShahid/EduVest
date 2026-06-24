import 'dart:io';

import 'package:dartz/dartz.dart';
import 'package:eduvest_output/core/errors/failures.dart';
import 'package:eduvest_output/features/authentication/domain/entities/user_entity.dart';
import 'package:eduvest_output/features/authentication/presentation/providers/auth_provider.dart';
import 'package:eduvest_output/features/expense/domain/entities/expense_entity.dart';
import 'package:eduvest_output/features/expense/domain/repositories/expense_repository.dart';
import 'package:eduvest_output/features/expense/presentation/providers/expense_provider.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_test/flutter_test.dart';

class _FakeExpenseRepo implements ExpenseRepository {
  bool uploadShouldFail = false;
  int addCalls = 0;
  ExpenseEntity? lastSaved;

  @override
  Future<Either<Failure, void>> addExpense(
      String uid, ExpenseEntity expense) async {
    addCalls++;
    lastSaved = expense;
    return const Right(null);
  }

  @override
  Future<Either<Failure, String>> uploadReceipt(
      String uid, String expenseId, File file) async {
    if (uploadShouldFail) {
      return const Left(ServerFailure('storage unavailable'));
    }
    return const Right('https://example.com/r.jpg');
  }

  @override
  Future<Either<Failure, void>> updateExpense(
          String uid, ExpenseEntity expense) async =>
      const Right(null);
  @override
  Future<Either<Failure, void>> deleteExpense(
          String uid, String expenseId) async =>
      const Right(null);
  @override
  Future<Either<Failure, void>> deleteReceipt(
          String uid, String expenseId) async =>
      const Right(null);
  @override
  Stream<List<ExpenseEntity>> getExpensesStream(String uid,
          {int? month, int? year}) =>
      const Stream.empty();
}

void main() {
  final testUser = UserEntity(
    id: 'u1',
    email: 'a@b.com',
    name: 'Alex',
    memberSince: DateTime(2024, 1, 1),
  );

  ExpenseEntity expense() => ExpenseEntity(
        id: 'e1',
        amount: 25,
        description: 'Textbook',
        category: 'Education',
        date: DateTime(2026, 6, 3),
        month: 6,
        year: 2026,
      );

  late File tempReceipt;
  setUp(() {
    tempReceipt = File('${Directory.systemTemp.path}/eduvest_ctrl_receipt.jpg')
      ..writeAsBytesSync([0, 1, 2, 3]);
  });

  Future<ProviderContainer> container(_FakeExpenseRepo repo) async {
    final c = ProviderContainer(overrides: [
      expenseRepositoryProvider.overrideWithValue(repo),
      authStateProvider.overrideWith((ref) => Stream.value(testUser)),
    ]);
    addTearDown(c.dispose);
    await c.read(authStateProvider.future); // resolve uid
    return c;
  }

  test('1. a failed receipt upload still saves the expense', () async {
    final repo = _FakeExpenseRepo()..uploadShouldFail = true;
    final c = await container(repo);

    final ok = await c
        .read(expenseControllerProvider.notifier)
        .addExpense(expense(), receipt: tempReceipt);

    expect(ok, isTrue); // save succeeded despite Storage failure
    expect(repo.addCalls, 1);
    expect(repo.lastSaved!.receiptUrl, isNull); // no receipt attached
  });

  test('2. a successful receipt upload attaches the url', () async {
    final repo = _FakeExpenseRepo();
    final c = await container(repo);

    final ok = await c
        .read(expenseControllerProvider.notifier)
        .addExpense(expense(), receipt: tempReceipt);

    expect(ok, isTrue);
    expect(repo.lastSaved!.receiptUrl, 'https://example.com/r.jpg');
  });

  test('3. blocks the save when no user is signed in', () async {
    final repo = _FakeExpenseRepo();
    final c = ProviderContainer(overrides: [
      expenseRepositoryProvider.overrideWithValue(repo),
      authStateProvider.overrideWith((ref) => Stream.value(null)),
    ]);
    addTearDown(c.dispose);
    await c.read(authStateProvider.future);

    final ok = await c
        .read(expenseControllerProvider.notifier)
        .addExpense(expense());

    expect(ok, isFalse);
    expect(repo.addCalls, 0);
  });
}
