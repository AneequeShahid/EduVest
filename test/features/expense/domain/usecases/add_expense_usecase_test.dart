import 'package:dartz/dartz.dart';
import 'package:eduvest_output/core/errors/failures.dart';
import 'package:eduvest_output/features/expense/domain/entities/expense_entity.dart';
import 'package:eduvest_output/features/expense/domain/usecases/add_expense_usecase.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mockito/mockito.dart';

import '../../helpers/expense_test_mocks.dart';

void main() {
  late MockExpenseRepository repository;
  late AddExpenseUseCase useCase;

  const uid = 'uid-1';

  setUp(() {
    repository = MockExpenseRepository();
    useCase = AddExpenseUseCase(repository);
  });

  ExpenseEntity expense({
    double amount = 25.0,
    String description = 'Textbook',
    String category = 'Education',
    DateTime? date,
  }) =>
      ExpenseEntity(
        id: 'e1',
        amount: amount,
        description: description,
        category: category,
        date: date ?? DateTime(2026, 3, 12),
        month: 1,
        year: 2000,
      );

  test('1. returns Right(void) on a valid expense', () async {
    when(repository.addExpense(any, any))
        .thenAnswer((_) async => const Right(null));

    final result = await useCase(uid, expense());

    expect(result.isRight(), isTrue);
  });

  test('2. returns Left(Failure) when amount is 0', () async {
    final result = await useCase(uid, expense(amount: 0));
    expect(result.isLeft(), isTrue);
    verifyNever(repository.addExpense(any, any));
  });

  test('3. returns Left(Failure) when amount is negative', () async {
    final result = await useCase(uid, expense(amount: -5));
    expect(result.isLeft(), isTrue);
    verifyNever(repository.addExpense(any, any));
  });

  test('4. returns Left(Failure) when description is empty', () async {
    final result = await useCase(uid, expense(description: '   '));
    expect(result.isLeft(), isTrue);
    result.fold((f) => expect(f, isA<ValidationFailure>()),
        (_) => fail('expected Left'));
    verifyNever(repository.addExpense(any, any));
  });

  test('5. returns Left(Failure) when category is empty', () async {
    final result = await useCase(uid, expense(category: ''));
    expect(result.isLeft(), isTrue);
    verifyNever(repository.addExpense(any, any));
  });

  test('6. calls repository.addExpense with correct data', () async {
    when(repository.addExpense(any, any))
        .thenAnswer((_) async => const Right(null));

    await useCase(uid, expense(amount: 99.5, description: 'Lab fee'));

    final captured =
        verify(repository.addExpense(captureAny, captureAny)).captured;
    expect(captured[0], uid);
    final saved = captured[1] as ExpenseEntity;
    expect(saved.amount, 99.5);
    expect(saved.description, 'Lab fee');
  });

  test('7. sets month and year fields from the date', () async {
    when(repository.addExpense(any, any))
        .thenAnswer((_) async => const Right(null));

    await useCase(uid, expense(date: DateTime(2026, 7, 4)));

    final saved = verify(repository.addExpense(any, captureAny)).captured.single
        as ExpenseEntity;
    expect(saved.month, 7);
    expect(saved.year, 2026);
  });
}
