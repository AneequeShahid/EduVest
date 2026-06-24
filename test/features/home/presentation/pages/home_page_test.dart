import 'dart:async';

import 'package:eduvest_output/core/utils/currency_utils.dart';
import 'package:eduvest_output/core/widgets/custom_progress_bar.dart';
import 'package:eduvest_output/core/widgets/error_state.dart';
import 'package:eduvest_output/features/authentication/domain/entities/user_entity.dart';
import 'package:eduvest_output/features/authentication/presentation/providers/auth_provider.dart';
import 'package:eduvest_output/features/home/domain/entities/goal_summary_entity.dart';
import 'package:eduvest_output/features/home/domain/entities/transaction_entity.dart';
import 'package:eduvest_output/features/home/domain/repositories/home_repository.dart';
import 'package:eduvest_output/features/home/presentation/pages/home_page.dart';
import 'package:eduvest_output/features/home/presentation/providers/home_provider.dart';
import 'package:eduvest_output/features/home/presentation/widgets/dashboard_shimmer.dart';
import 'package:eduvest_output/features/home/presentation/widgets/goal_preview_card.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:go_router/go_router.dart';
import 'package:google_fonts/google_fonts.dart';

class FakeHomeRepository implements HomeRepository {
  bool authenticated = true;
  double balance = 1000;
  MonthlyBudget budget = (limit: 1000, spent: 700);
  List<TransactionEntity> recent = [];
  GoalSummaryEntity? goal;
  double change = 5;

  /// When set, [getTotalBalance] returns this future (used to hold "loading").
  Completer<double>? balanceGate;

  /// When true, [getTotalBalance] throws (used for error/retry tests).
  bool throwError = false;
  int balanceCalls = 0;

  @override
  bool get isAuthenticated => authenticated;

  @override
  Future<double> getTotalBalance() async {
    balanceCalls++;
    if (balanceGate != null) return balanceGate!.future;
    if (throwError) {
      throw Exception('firestore down');
    }
    return balance;
  }

  @override
  Future<MonthlyBudget> getMonthlyBudget() async => budget;

  @override
  Future<List<TransactionEntity>> getRecentTransactions() async => recent;

  @override
  Future<GoalSummaryEntity?> getActiveGoal() async => goal;

  @override
  Future<double> getBalanceChangePercent() async => change;

  @override
  Stream<List<TransactionEntity>> watchRecentTransactions() =>
      Stream.value(recent);
}

void main() {
  setUpAll(() {
    GoogleFonts.config.allowRuntimeFetching = false;
  });

  late FakeHomeRepository fake;

  setUp(() {
    fake = FakeHomeRepository();
  });

  final testUser = UserEntity(
    id: 'u1',
    email: 'a@b.com',
    name: 'Alex Sterling',
    memberSince: DateTime(2024, 1, 1),
  );

  GoRouter buildRouter() => GoRouter(
        initialLocation: '/home',
        routes: [
          GoRoute(path: '/home', builder: (_, __) => const HomePage()),
          GoRoute(
              path: '/home/goals',
              builder: (_, __) =>
                  const Scaffold(body: Text('GOALS PAGE'))),
          GoRoute(
              path: '/home/expenses',
              builder: (_, __) =>
                  const Scaffold(body: Text('EXPENSES PAGE'))),
          GoRoute(
              path: '/settings',
              builder: (_, __) =>
                  const Scaffold(body: Text('SETTINGS PAGE'))),
        ],
      );

  Future<void> pumpHome(WidgetTester tester) async {
    tester.view.physicalSize = const Size(1200, 2800);
    tester.view.devicePixelRatio = 1.0;
    addTearDown(tester.view.reset);

    await tester.pumpWidget(
      ProviderScope(
        overrides: [
          homeRepositoryProvider.overrideWithValue(fake),
          authStateProvider.overrideWith(
            (ref) => Stream<UserEntity?>.value(testUser),
          ),
        ],
        child: MaterialApp.router(routerConfig: buildRouter()),
      ),
    );
  }

  testWidgets('1. shows shimmer while loading', (tester) async {
    fake.balanceGate = Completer<double>(); // never completes → stays loading
    await pumpHome(tester);
    await tester.pump();

    expect(find.byType(DashboardShimmer), findsOneWidget);

    fake.balanceGate!.complete(1000); // let it settle cleanly
    await tester.pumpAndSettle();
  });

  testWidgets('2. displays balance after load', (tester) async {
    fake.balance = 1234.56;
    await pumpHome(tester);
    await tester.pumpAndSettle();

    expect(find.text(formatCurrency(1234.56)), findsOneWidget);
  });

  testWidgets("3. shows 'No transactions yet' when empty", (tester) async {
    fake.recent = [];
    fake.goal = null;
    await pumpHome(tester);
    await tester.pumpAndSettle();

    expect(
      find.textContaining('No transactions yet'),
      findsOneWidget,
    );
  });

  testWidgets('4. shows budget progress bar with the correct fill',
      (tester) async {
    fake.goal = null; // isolate the single (budget) progress bar
    fake.budget = (limit: 1000, spent: 700);
    await pumpHome(tester);
    await tester.pumpAndSettle();

    final bar = tester.widget<CustomProgressBar>(
      find.byType(CustomProgressBar),
    );
    expect(bar.value, closeTo(0.7, 0.0001));
  });

  testWidgets('5. navigates to GoalsPage on goal card tap', (tester) async {
    fake.goal = const GoalSummaryEntity(
      id: 'g1',
      title: 'New Laptop',
      savedAmount: 200,
      targetAmount: 1000,
      category: 'Education',
    );
    await pumpHome(tester);
    await tester.pumpAndSettle();

    await tester.tap(find.byType(GoalPreviewCard));
    await tester.pumpAndSettle();

    expect(find.text('GOALS PAGE'), findsOneWidget);
  });

  testWidgets("6. navigates to ExpenseListPage on 'View All Activity' tap",
      (tester) async {
    await pumpHome(tester);
    await tester.pumpAndSettle();

    await tester.tap(find.text('View All Activity'));
    await tester.pumpAndSettle();

    expect(find.text('EXPENSES PAGE'), findsOneWidget);
  });

  testWidgets('7. shows error state with retry on failure', (tester) async {
    fake.throwError = true;
    await pumpHome(tester);
    await tester.pumpAndSettle();

    expect(find.byType(ErrorState), findsOneWidget);
    expect(find.text('Retry'), findsOneWidget);
  });

  testWidgets('8. retry button triggers a reload', (tester) async {
    fake.throwError = true; // initial load fails
    fake.balance = 4242.0;
    await pumpHome(tester);
    await tester.pumpAndSettle();

    expect(find.byType(ErrorState), findsOneWidget);
    final callsBeforeRetry = fake.balanceCalls;

    fake.throwError = false; // recovery
    await tester.tap(find.text('Retry'));
    await tester.pumpAndSettle();

    expect(find.byType(ErrorState), findsNothing);
    expect(find.text(formatCurrency(4242.0)), findsOneWidget);
    expect(fake.balanceCalls, greaterThan(callsBeforeRetry));
  });
}
