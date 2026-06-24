import 'package:dartz/dartz.dart';
import 'package:eduvest_output/core/errors/failures.dart';
import 'package:eduvest_output/features/expense/domain/entities/expense_entity.dart';
import 'package:eduvest_output/features/expense/domain/usecases/delete_expense_usecase.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mockito/mockito.dart';

import '../../helpers/expense_test_mocks.dart';

void main() {
  late MockExpenseRepository repository;
  late DeleteExpenseUseCase useCase;

  const uid = 'uid-1';

  setUp(() {
    repository = MockExpenseRepository();
    useCase = DeleteExpenseUseCase(repository);
  });

  ExpenseEntity expense({String? receiptUrl}) => ExpenseEntity(
        id: 'e1',
        amount: 10,
        description: 'd',
        category: 'Education',
        date: DateTime(2026, 3, 1),
        month: 3,
        year: 2026,
        receiptUrl: receiptUrl,
      );

  test('1. calls repository.deleteExpense with the correct id', () async {
    when(repository.deleteExpense(any, any))
        .thenAnswer((_) async => const Right(null));

    await useCase(uid, expense());

    verify(repository.deleteExpense(uid, 'e1')).called(1);
  });

  test('2. returns Left(Failure) on repository error', () async {
    when(repository.deleteExpense(any, any))
        .thenAnswer((_) async => const Left(ServerFailure('boom')));

    final result = await useCase(uid, expense());

    expect(result.isLeft(), isTrue);
  });

  test('3. deletes the receipt from Storage when receiptUrl is not null',
      () async {
    when(repository.deleteReceipt(any, any))
        .thenAnswer((_) async => const Right(null));
    when(repository.deleteExpense(any, any))
        .thenAnswer((_) async => const Right(null));

    await useCase(uid, expense(receiptUrl: 'https://x/receipt.jpg'));

    verify(repository.deleteReceipt(uid, 'e1')).called(1);
    verify(repository.deleteExpense(uid, 'e1')).called(1);
  });

  test('does NOT delete a receipt when receiptUrl is null', () async {
    when(repository.deleteExpense(any, any))
        .thenAnswer((_) async => const Right(null));

    await useCase(uid, expense());

    verifyNever(repository.deleteReceipt(any, any));
  });
}
