import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:eduvest_output/core/errors/failures.dart';
import 'package:eduvest_output/features/goals/data/models/contribution_model.dart';
import 'package:eduvest_output/features/goals/data/repositories/goals_repository_impl.dart';
import 'package:eduvest_output/features/goals/data/sources/goals_remote_source.dart';
import 'package:eduvest_output/features/goals/domain/entities/goal_entity.dart';
import 'package:eduvest_output/features/goals/domain/usecases/adjust_plan_usecase.dart';
import 'package:eduvest_output/features/goals/domain/usecases/delete_goal_usecase.dart';
import 'package:fake_cloud_firestore/fake_cloud_firestore.dart';
import 'package:flutter_test/flutter_test.dart';

void main() {
  const uid = 'u1';
  late FakeFirebaseFirestore firestore;
  late GoalsRemoteSource source;
  late GoalsRepositoryImpl repo;

  GoalEntity goal({String id = 'g1', double target = 1000, double saved = 0}) =>
      GoalEntity(
        id: id,
        title: 'Laptop',
        targetAmount: target,
        savedAmount: saved,
        targetDate: DateTime.now().add(const Duration(days: 60)),
        createdAt: DateTime(2026, 1, 1),
      );

  setUp(() {
    firestore = FakeFirebaseFirestore();
    source = GoalsRemoteSource(db: firestore);
    repo = GoalsRepositoryImpl(source);
  });

  group('GoalEntity getters', () {
    test('1. remainingAmount never goes negative', () {
      expect(goal(target: 1000, saved: 1200).remainingAmount, 0);
      expect(goal(target: 1000, saved: 250).remainingAmount, 750);
    });

    test('2. progressPercent clamps to 0..1', () {
      expect(goal(target: 1000, saved: 500).progressPercent, 0.5);
      expect(goal(target: 1000, saved: 5000).progressPercent, 1.0);
      expect(goal(target: 0, saved: 5).progressPercent, 0.0);
    });

    test('3. monthsUntilTarget is at least 1 and drives monthlyNeeded', () {
      final g = goal(target: 1200, saved: 0);
      expect(g.monthsUntilTarget, greaterThanOrEqualTo(1));
      expect(g.monthlyNeeded, g.remainingAmount / g.monthsUntilTarget);
    });

    test('4. isReached reflects savedAmount vs target', () {
      expect(goal(target: 1000, saved: 1000).isReached, isTrue);
      expect(goal(target: 1000, saved: 999).isReached, isFalse);
    });
  });

  group('AdjustPlanUseCase', () {
    test('5. rejects when nothing is supplied', () async {
      final r = await AdjustPlanUseCase(repo)(uid, 'g1');
      expect(r.isLeft(), isTrue);
    });

    test('6. rejects a non-positive target amount', () async {
      final r = await AdjustPlanUseCase(repo)(uid, 'g1', targetAmount: 0);
      expect(r.isLeft(), isTrue);
    });

    test('7. rejects a target date in the past', () async {
      final r = await AdjustPlanUseCase(repo)(uid, 'g1',
          targetDate: DateTime.now().subtract(const Duration(days: 2)));
      expect(r.isLeft(), isTrue);
    });

    test('8. applies a valid target amount', () async {
      await source.createGoal(uid, goal());
      final r = await AdjustPlanUseCase(repo)(uid, 'g1', targetAmount: 1500);
      expect(r.isRight(), isTrue);
      final data = await firestore
          .collection('users')
          .doc(uid)
          .collection('goals')
          .doc('g1')
          .get();
      expect(data.data()!['targetAmount'], 1500);
    });
  });

  group('GoalsRemoteSource extras', () {
    test('9. adjustPlan writes targetDate and deadline mirror', () async {
      await source.createGoal(uid, goal());
      final future = DateTime.now().add(const Duration(days: 120));
      await source.adjustPlan(uid, 'g1', targetDate: future);

      final data = (await firestore
              .collection('users')
              .doc(uid)
              .collection('goals')
              .doc('g1')
              .get())
          .data()!;
      expect(data['targetDate'], isA<Timestamp>());
      expect(data['deadline'], isA<Timestamp>());
    });

    test('10. getRecentContributions returns latest first', () async {
      await source.createGoal(uid, goal());
      await source.addFunds(uid, 'g1', 100, 'one');
      await source.addFunds(uid, 'g1', 200, 'two');

      final contribs = await source.getRecentContributions(uid, 'g1');
      expect(contribs.length, 2);
    });
  });

  group('GoalsRepositoryImpl forwarding', () {
    test('11. createGoal / addFunds / deleteGoal succeed via the repo',
        () async {
      final created = await repo.createGoal(uid, goal());
      expect(created.isRight(), isTrue);

      final funded = await repo.addFunds(uid, 'g1', 100, null);
      expect(funded.isRight(), isTrue);

      final deleted = await DeleteGoalUseCase(repo)(uid, 'g1');
      expect(deleted.isRight(), isTrue);
    });

    test('12. addFunds on a missing goal surfaces a Failure', () async {
      final r = await repo.addFunds(uid, 'missing', 50, null);
      expect(r.isLeft(), isTrue);
      r.fold((f) => expect(f, isA<Failure>()), (_) => fail('expected Left'));
    });
  });

  group('ContributionModel', () {
    test('13. fromDoc maps fields and defaults', () async {
      await firestore
          .collection('users')
          .doc(uid)
          .collection('goals')
          .doc('g1')
          .collection('contributions')
          .doc('c1')
          .set({'amount': 75, 'note': 'gift', 'date': Timestamp.now()});
      final doc = await firestore
          .collection('users')
          .doc(uid)
          .collection('goals')
          .doc('g1')
          .collection('contributions')
          .doc('c1')
          .get();

      final entity = ContributionModel.fromDoc(doc);
      expect(entity.amount, 75);
      expect(entity.note, 'gift');
    });

    test('14. toJson builds the expected map', () {
      final json = ContributionModel.toJson(50, null);
      expect(json['amount'], 50);
      expect(json['note'], '');
      expect(json.containsKey('date'), isTrue);
    });
  });
}
