import 'package:dartz/dartz.dart';
import 'package:eduvest_output/core/errors/failures.dart';
import 'package:eduvest_output/core/widgets/app_button.dart';
import 'package:eduvest_output/features/authentication/domain/entities/user_entity.dart';
import 'package:eduvest_output/features/authentication/presentation/providers/auth_provider.dart';
import 'package:eduvest_output/features/goals/domain/entities/contribution_entity.dart';
import 'package:eduvest_output/features/goals/domain/entities/goal_entity.dart';
import 'package:eduvest_output/features/goals/domain/repositories/goals_repository.dart';
import 'package:eduvest_output/features/goals/presentation/pages/create_goal_page.dart';
import 'package:eduvest_output/features/goals/presentation/providers/goals_provider.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:go_router/go_router.dart';
import 'package:google_fonts/google_fonts.dart';

class FakeGoalsRepository implements GoalsRepository {
  GoalEntity? created;
  bool fail = false;

  @override
  Stream<List<GoalEntity>> watchGoals(String uid) => Stream.value(const []);

  @override
  Future<List<ContributionEntity>> getRecentContributions(
          String uid, String goalId, {int limit = 5}) async =>
      const [];

  @override
  Future<Either<Failure, void>> createGoal(String uid, GoalEntity g) async {
    if (fail) return const Left(ServerFailure('nope'));
    created = g;
    return const Right(null);
  }

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

  Future<void> pump(WidgetTester tester) async {
    tester.view.physicalSize = const Size(1200, 3600);
    tester.view.devicePixelRatio = 1.0;
    addTearDown(tester.view.reset);

    final router = GoRouter(
      initialLocation: '/home/goals/create',
      routes: [
        GoRoute(
            path: '/home/goals/create',
            builder: (_, __) => const CreateGoalPage()),
        GoRoute(
            path: '/home/goals',
            builder: (_, __) => const Scaffold(body: Text('GOALS STUB'))),
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
    await tester.pumpAndSettle();
  }

  testWidgets('1. renders preview, fields and the create button',
      (tester) async {
    await pump(tester);
    expect(find.text('Goal title'), findsOneWidget);
    expect(find.text('Target amount'), findsOneWidget);
    expect(find.widgetWithText(AppButton, 'Create Goal'), findsOneWidget);
  });

  testWidgets('2. validates an empty title', (tester) async {
    await pump(tester);
    await tester.tap(find.text('Create Goal'));
    await tester.pump();
    expect(find.text('Title is required'), findsOneWidget);
  });

  testWidgets('3. validates a non-positive amount', (tester) async {
    await pump(tester);
    await tester.enterText(find.byType(TextField).at(0), 'New Laptop');
    await tester.enterText(find.byType(TextField).at(1), '0');
    await tester.tap(find.text('Create Goal'));
    await tester.pump();
    expect(find.text('Enter an amount greater than zero'), findsOneWidget);
  });

  testWidgets('4. selecting a category chip updates the selection',
      (tester) async {
    await pump(tester);
    await tester.tap(find.widgetWithText(ChoiceChip, 'Travel'));
    await tester.pump();
    final chip = tester.widget<ChoiceChip>(
        find.widgetWithText(ChoiceChip, 'Travel'));
    expect(chip.selected, isTrue);
  });

  testWidgets('5. a valid goal is created and navigates back', (tester) async {
    await pump(tester);
    await tester.enterText(find.byType(TextField).at(0), 'New Laptop');
    await tester.enterText(find.byType(TextField).at(1), '2500');
    await tester.tap(find.widgetWithText(ChoiceChip, 'Laptop'));
    await tester.pump();

    await tester.tap(find.text('Create Goal'));
    await tester.pump(); // saving
    await tester.pump(); // resolve → navigate
    await tester.pump(const Duration(milliseconds: 350));

    expect(fake.created, isNotNull);
    expect(fake.created!.title, 'New Laptop');
    expect(fake.created!.targetAmount, 2500);
    expect(find.text('GOALS STUB'), findsOneWidget);
    await tester.pump(const Duration(seconds: 5)); // drain snackbar
  });
}
