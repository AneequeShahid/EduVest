import 'dart:async';

import 'package:dartz/dartz.dart';
import 'package:eduvest_output/core/errors/failures.dart';
import 'package:eduvest_output/features/authentication/domain/entities/user_entity.dart';
import 'package:eduvest_output/features/authentication/presentation/providers/auth_provider.dart';
import 'package:eduvest_output/features/goals/domain/entities/contribution_entity.dart';
import 'package:eduvest_output/features/goals/domain/entities/goal_entity.dart';
import 'package:eduvest_output/features/goals/domain/repositories/goals_repository.dart';
import 'package:eduvest_output/features/goals/presentation/pages/goals_page.dart';
import 'package:eduvest_output/features/goals/presentation/providers/goals_provider.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:go_router/go_router.dart';
import 'package:google_fonts/google_fonts.dart';

GoalEntity goal({
  String id = 'g1',
  String title = 'New Laptop',
  double target = 2500,
  double saved = 1875,
  bool completed = false,
}) =>
    GoalEntity(
      id: id,
      title: title,
      targetAmount: target,
      savedAmount: saved,
      targetDate: DateTime.now().add(const Duration(days: 90)),
      isCompleted: completed,
      createdAt: DateTime(2026, 1, 1),
    );

class FakeGoalsRepository implements GoalsRepository {
  final _controller = StreamController<List<GoalEntity>>.broadcast();
  void emit(List<GoalEntity> goals) => _controller.add(goals);

  @override
  Stream<List<GoalEntity>> watchGoals(String uid) => _controller.stream;

  @override
  Future<List<ContributionEntity>> getRecentContributions(
          String uid, String goalId, {int limit = 5}) async =>
      const [];

  @override
  Future<Either<Failure, void>> createGoal(String uid, GoalEntity g) async =>
      const Right(null);

  @override
  Future<Either<Failure, void>> addFunds(
          String uid, String goalId, double amount, String? note) async =>
      const Right(null);

  @override
  Future<Either<Failure, void>> adjustPlan(String uid, String goalId,
          {double? targetAmount, DateTime? targetDate}) async =>
      const Right(null);

  @override
  Future<Either<Failure, void>> deleteGoal(String uid, String goalId) async =>
      const Right(null);
}

void main() {
  setUpAll(() => GoogleFonts.config.allowRuntimeFetching = false);

  late FakeGoalsRepository fake;

  final testUser = UserEntity(
    id: 'u1',
    email: 'a@b.com',
    name: 'Alex',
    memberSince: DateTime(2024, 1, 1),
  );

  setUp(() => fake = FakeGoalsRepository());

  Future<void> pumpPage(WidgetTester tester) async {
    tester.view.physicalSize = const Size(1200, 3000);
    tester.view.devicePixelRatio = 1.0;
    addTearDown(tester.view.reset);

    final router = GoRouter(
      initialLocation: '/home/goals',
      routes: [
        GoRoute(path: '/home/goals', builder: (_, __) => const GoalsPage()),
        GoRoute(
            path: '/home/goals/create',
            builder: (_, __) => const Scaffold(body: Text('CREATE STUB'))),
      ],
    );

    await tester.pumpWidget(
      ProviderScope(
        overrides: [
          goalsRepositoryProvider.overrideWithValue(fake),
          authStateProvider
              .overrideWith((ref) => Stream<UserEntity?>.value(testUser)),
        ],
        child: MaterialApp.router(routerConfig: router),
      ),
    );
    await tester.pump();
  }

  testWidgets('1. shows goals list from provider', (tester) async {
    await pumpPage(tester);
    fake.emit([goal(title: 'New Laptop'), goal(id: 'g2', title: 'Trip Fund')]);
    await tester.pumpAndSettle();

    expect(find.text('New Laptop'), findsOneWidget);
    expect(find.text('Trip Fund'), findsOneWidget);
  });

  testWidgets('2. shows empty state when no goals', (tester) async {
    await pumpPage(tester);
    fake.emit(const []);
    await tester.pumpAndSettle();

    expect(find.text('No goals yet'), findsOneWidget);
  });

  testWidgets('3. tapping a goal selects it (highlight ring)', (tester) async {
    await pumpPage(tester);
    fake.emit([goal()]);
    await tester.pumpAndSettle();

    expect(find.byKey(const Key('selection-ring')), findsNothing);

    await tester.tap(find.byKey(const Key('goal-card-g1')));
    await tester.pumpAndSettle();

    expect(find.byKey(const Key('selection-ring')), findsOneWidget);
  });

  testWidgets('4. Add Funds disabled when no goal selected', (tester) async {
    await pumpPage(tester);
    fake.emit([goal()]);
    await tester.pumpAndSettle();

    final button = tester.widget<ElevatedButton>(
      find.byKey(const Key('add-funds-button')),
    );
    expect(button.onPressed, isNull);
  });

  testWidgets('5. AddFundsSheet appears when a goal is selected',
      (tester) async {
    await pumpPage(tester);
    fake.emit([goal()]);
    await tester.pumpAndSettle();

    await tester.tap(find.byKey(const Key('goal-card-g1')));
    await tester.pumpAndSettle();
    await tester.tap(find.byKey(const Key('add-funds-button')));
    await tester.pumpAndSettle();

    expect(find.text('Recent contributions'), findsOneWidget);
  });

  testWidgets('6. completion badge shows when isCompleted is true',
      (tester) async {
    await pumpPage(tester);
    fake.emit([goal(saved: 2500, completed: true)]);
    await tester.pumpAndSettle();

    expect(find.text('✓ Goal Met!'), findsOneWidget);
  });

  testWidgets('7. GoalCompletionAnimation triggers on completion',
      (tester) async {
    await pumpPage(tester);
    fake.emit([goal(saved: 2000, completed: false)]);
    await tester.pumpAndSettle();

    // Same goal transitions to completed.
    fake.emit([goal(saved: 2500, completed: true)]);
    await tester.pumpAndSettle();

    expect(find.text('Goal Achieved!'), findsOneWidget);
  });
}
