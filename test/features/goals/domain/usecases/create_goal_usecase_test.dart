import 'package:dartz/dartz.dart';
import 'package:eduvest_output/features/goals/domain/entities/goal_entity.dart';
import 'package:eduvest_output/features/goals/domain/usecases/create_goal_usecase.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mockito/mockito.dart';

import '../../helpers/goals_test_mocks.dart';

void main() {
  late MockGoalsRepository repository;
  late CreateGoalUseCase useCase;

  const uid = 'uid-1';

  setUp(() {
    repository = MockGoalsRepository();
    useCase = CreateGoalUseCase(repository);
  });

  GoalEntity goal({
    String title = 'New Laptop',
    double target = 2500,
    DateTime? date,
    double saved = 0,
  }) =>
      GoalEntity(
        id: 'g1',
        title: title,
        targetAmount: target,
        savedAmount: saved,
        targetDate: date ?? DateTime.now().add(const Duration(days: 90)),
      );

  test('1. returns Right(void) with valid data', () async {
    when(repository.createGoal(any, any))
        .thenAnswer((_) async => const Right(null));

    final result = await useCase(uid, goal());

    expect(result.isRight(), isTrue);
  });

  test('2. returns Left(Failure) when title is empty', () async {
    final result = await useCase(uid, goal(title: '   '));
    expect(result.isLeft(), isTrue);
    verifyNever(repository.createGoal(any, any));
  });

  test('3. returns Left(Failure) when targetAmount <= 0', () async {
    expect((await useCase(uid, goal(target: 0))).isLeft(), isTrue);
    expect((await useCase(uid, goal(target: -10))).isLeft(), isTrue);
    verifyNever(repository.createGoal(any, any));
  });

  test('4. returns Left(Failure) when targetDate is in the past', () async {
    final result = await useCase(
        uid, goal(date: DateTime.now().subtract(const Duration(days: 1))));
    expect(result.isLeft(), isTrue);
    verifyNever(repository.createGoal(any, any));
  });

  test('5. sets savedAmount to 0 on creation', () async {
    when(repository.createGoal(any, any))
        .thenAnswer((_) async => const Right(null));

    // Even if a stray savedAmount is provided, it should be reset.
    await useCase(uid, goal(saved: 999));

    final saved =
        verify(repository.createGoal(any, captureAny)).captured.single
            as GoalEntity;
    expect(saved.savedAmount, 0);
    expect(saved.isCompleted, isFalse);
  });
}
