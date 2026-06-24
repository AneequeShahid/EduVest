import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:eduvest_output/features/goals/data/sources/goals_remote_source.dart';
import 'package:eduvest_output/features/goals/domain/entities/goal_entity.dart';
import 'package:fake_cloud_firestore/fake_cloud_firestore.dart';
import 'package:flutter_test/flutter_test.dart';

void main() {
  const uid = 'uid-1';

  late FakeFirebaseFirestore firestore;
  late GoalsRemoteSource source;

  setUp(() {
    firestore = FakeFirebaseFirestore();
    source = GoalsRemoteSource(db: firestore);
  });

  CollectionReference<Map<String, dynamic>> goalsCol() =>
      firestore.collection('users').doc(uid).collection('goals');

  GoalEntity newGoal({
    String id = 'g1',
    String title = 'Laptop',
    double target = 1000,
    double saved = 0,
  }) =>
      GoalEntity(
        id: id,
        title: title,
        targetAmount: target,
        savedAmount: saved,
        targetDate: DateTime.now().add(const Duration(days: 60)),
        createdAt: DateTime(2026, 1, 1),
      );

  test('1. creates a goal with correct fields', () async {
    await source.createGoal(uid, newGoal(target: 2500, title: 'MacBook'));

    final doc = await goalsCol().doc('g1').get();
    expect(doc.exists, isTrue);
    final data = doc.data()!;
    expect(data['title'], 'MacBook');
    expect(data['targetAmount'], 2500);
    expect(data['savedAmount'], 0);
    expect(data['isCompleted'], false);
    expect(data['targetDate'], isA<Timestamp>());
  });

  test('2. addFunds increments savedAmount + creates contribution atomically',
      () async {
    await source.createGoal(uid, newGoal(saved: 100, target: 1000));

    await source.addFunds(uid, 'g1', 250, 'paycheck');

    final goal = (await goalsCol().doc('g1').get()).data()!;
    final contribs =
        await goalsCol().doc('g1').collection('contributions').get();
    expect(goal['savedAmount'], 350);
    expect(contribs.docs.length, 1);
    expect(contribs.docs.first.data()['amount'], 250);
  });

  test('3. marks isCompleted when target reached', () async {
    await source.createGoal(uid, newGoal(saved: 900, target: 1000));

    await source.addFunds(uid, 'g1', 100, null);

    expect((await goalsCol().doc('g1').get()).data()!['isCompleted'], true);
  });

  test('4. deleteGoal removes the goal and all contributions', () async {
    await source.createGoal(uid, newGoal());
    await source.addFunds(uid, 'g1', 50, null);
    await source.addFunds(uid, 'g1', 75, null);

    await source.deleteGoal(uid, 'g1');

    expect((await goalsCol().doc('g1').get()).exists, isFalse);
    final contribs =
        await goalsCol().doc('g1').collection('contributions').get();
    expect(contribs.docs, isEmpty);
  });

  test('5. stream updates when a new goal is added', () async {
    final stream = source.watchGoals(uid);
    expectLater(
      stream.map((goals) => goals.length),
      emitsThrough(1),
    );

    await source.createGoal(uid, newGoal());
  });
}
