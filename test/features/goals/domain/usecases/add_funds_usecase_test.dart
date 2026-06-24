import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:eduvest_output/features/goals/data/repositories/goals_repository_impl.dart';
import 'package:eduvest_output/features/goals/data/sources/goals_remote_source.dart';
import 'package:eduvest_output/features/goals/domain/usecases/add_funds_usecase.dart';
import 'package:fake_cloud_firestore/fake_cloud_firestore.dart';
import 'package:flutter_test/flutter_test.dart';

void main() {
  const uid = 'uid-1';
  const goalId = 'g1';

  late FakeFirebaseFirestore firestore;
  late AddFundsUseCase useCase;

  setUp(() {
    firestore = FakeFirebaseFirestore();
    useCase = AddFundsUseCase(
        GoalsRepositoryImpl(GoalsRemoteSource(db: firestore)));
  });

  DocumentReference<Map<String, dynamic>> goalRef() =>
      firestore.collection('users').doc(uid).collection('goals').doc(goalId);

  CollectionReference<Map<String, dynamic>> contribsCol() =>
      goalRef().collection('contributions');

  Future<void> seedGoal({double saved = 100, double target = 1000}) {
    return goalRef().set({
      'title': 'Laptop',
      'targetAmount': target,
      'savedAmount': saved,
      'isCompleted': false,
      'targetDate':
          Timestamp.fromDate(DateTime.now().add(const Duration(days: 60))),
    });
  }

  test('1. increments savedAmount correctly', () async {
    await seedGoal(saved: 100, target: 1000);

    final result = await useCase(uid, goalId, 50, null);

    expect(result.isRight(), isTrue);
    expect((await goalRef().get()).data()!['savedAmount'], 150);
  });

  test('2. marks completed when savedAmount >= targetAmount', () async {
    await seedGoal(saved: 900, target: 1000);

    await useCase(uid, goalId, 100, null);

    final data = (await goalRef().get()).data()!;
    expect(data['isCompleted'], true);
    expect(data['completedAt'], isNotNull);
  });

  test('3. returns Left(Failure) when amount <= 0', () async {
    await seedGoal();
    final result = await useCase(uid, goalId, 0, null);
    expect(result.isLeft(), isTrue);
    // No contribution written.
    expect((await contribsCol().get()).docs, isEmpty);
  });

  test('4. creates a contribution document', () async {
    await seedGoal(saved: 0, target: 1000);

    await useCase(uid, goalId, 250, 'Paycheck');

    final contribs = await contribsCol().get();
    expect(contribs.docs.length, 1);
    expect(contribs.docs.first.data()['amount'], 250);
    expect(contribs.docs.first.data()['note'], 'Paycheck');
  });

  test('5. does not exceed targetAmount', () async {
    await seedGoal(saved: 900, target: 1000);

    await useCase(uid, goalId, 500, null); // would overshoot

    expect((await goalRef().get()).data()!['savedAmount'], 1000);
  });

  test('6. completion is atomic (saved + completion + contribution)',
      () async {
    await seedGoal(saved: 800, target: 1000);

    await useCase(uid, goalId, 200, 'final push');

    final goal = (await goalRef().get()).data()!;
    final contribs = await contribsCol().get();
    expect(goal['savedAmount'], 1000);
    expect(goal['isCompleted'], true);
    expect(contribs.docs.length, 1);
  });
}
