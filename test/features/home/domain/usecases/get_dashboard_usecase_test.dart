import 'package:eduvest_output/core/errors/failures.dart';
import 'package:eduvest_output/features/home/domain/entities/goal_summary_entity.dart';
import 'package:eduvest_output/features/home/domain/entities/transaction_entity.dart';
import 'package:eduvest_output/features/home/domain/repositories/home_repository.dart';
import 'package:eduvest_output/features/home/domain/usecases/get_dashboard_usecase.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mockito/mockito.dart';

import '../../helpers/home_test_mocks.dart';

void main() {
  late MockHomeRepository repository;
  late GetDashboardUseCase useCase;

  setUp(() {
    repository = MockHomeRepository();
    useCase = GetDashboardUseCase(repository);
  });

  TransactionEntity tx(String id, DateTime date) => TransactionEntity(
        id: id,
        amount: 10,
        description: 'd$id',
        category: 'Food',
        date: date,
      );

  /// Stubs every repository call for the "happy path" with overridable values.
  void stubHappyPath({
    double balance = 1000,
    MonthlyBudget? budget,
    List<TransactionEntity>? transactions,
    GoalSummaryEntity? goal,
    double change = 5,
  }) {
    final resolvedBudget = budget ?? (limit: 500.0, spent: 200.0);
    when(repository.isAuthenticated).thenReturn(true);
    when(repository.getTotalBalance()).thenAnswer((_) async => balance);
    when(repository.getMonthlyBudget())
        .thenAnswer((_) async => resolvedBudget);
    when(repository.getRecentTransactions())
        .thenAnswer((_) async => transactions ?? const []);
    when(repository.getActiveGoal()).thenAnswer((_) async => goal);
    when(repository.getBalanceChangePercent())
        .thenAnswer((_) async => change);
  }

  test('1. returns DashboardEntity with the correct balance', () async {
    stubHappyPath(balance: 1234.56);

    final result = await useCase();

    expect(result.isRight(), isTrue);
    final dashboard = result.getOrElse(() => throw 'expected Right');
    expect(dashboard.totalBalance, 1234.56);
  });

  test('2. returns the correct monthly spent for the current month', () async {
    stubHappyPath(budget: (limit: 800.0, spent: 325.75));

    final result = await useCase();

    final dashboard = result.getOrElse(() => throw 'expected Right');
    expect(dashboard.monthlyBudgetLimit, 800);
    expect(dashboard.monthlySpent, 325.75);
  });

  test('3. returns only the 5 most recent transactions', () async {
    final five = List.generate(
      5,
      (i) => tx('$i', DateTime(2026, 1, 10 - i)),
    );
    stubHappyPath(transactions: five);

    final result = await useCase();

    final dashboard = result.getOrElse(() => throw 'expected Right');
    expect(dashboard.recentTransactions.length, 5);
  });

  test('4. returns null activeGoal when no goals exist', () async {
    stubHappyPath(goal: null);

    final result = await useCase();

    final dashboard = result.getOrElse(() => throw 'expected Right');
    expect(dashboard.activeGoal, isNull);
  });

  test('5. returns Left(Failure) when the user is not authenticated',
      () async {
    when(repository.isAuthenticated).thenReturn(false);

    final result = await useCase();

    expect(result.isLeft(), isTrue);
    result.fold(
      (f) => expect(f, isA<AuthFailure>()),
      (_) => fail('expected Left'),
    );
    verifyNever(repository.getTotalBalance());
  });

  test('6. returns Left(Failure) on a Firestore error', () async {
    when(repository.isAuthenticated).thenReturn(true);
    when(repository.getTotalBalance())
        .thenThrow(Exception('firestore down'));
    when(repository.getMonthlyBudget())
        .thenAnswer((_) async => (limit: 0.0, spent: 0.0));
    when(repository.getRecentTransactions()).thenAnswer((_) async => const []);
    when(repository.getActiveGoal()).thenAnswer((_) async => null);
    when(repository.getBalanceChangePercent()).thenAnswer((_) async => 0.0);

    final result = await useCase();

    expect(result.isLeft(), isTrue);
    result.fold(
      (f) => expect(f, isA<ServerFailure>()),
      (_) => fail('expected Left'),
    );
  });
}
