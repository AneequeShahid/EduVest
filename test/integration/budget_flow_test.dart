// Integration flow: budgeting.
//
// Drives the real BudgetPage + providers against a fake BudgetRepository whose
// stream emits live, so creating a category flows back into the list in real
// time. No Firebase, no network.
import 'dart:async';

import 'package:dartz/dartz.dart';
import 'package:eduvest_output/core/errors/failures.dart';
import 'package:eduvest_output/features/authentication/domain/entities/user_entity.dart';
import 'package:eduvest_output/features/authentication/presentation/providers/auth_provider.dart';
import 'package:eduvest_output/features/budget/domain/entities/budget_category_entity.dart';
import 'package:eduvest_output/features/budget/domain/entities/budget_entity.dart';
import 'package:eduvest_output/features/budget/domain/repositories/budget_repository.dart';
import 'package:eduvest_output/features/budget/presentation/pages/budget_page.dart';
import 'package:eduvest_output/features/budget/presentation/providers/budget_provider.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:go_router/go_router.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:shimmer/shimmer.dart';

BudgetEntity buildBudget({
  double totalLimit = 1000,
  double totalSpent = 0,
  List<BudgetCategoryEntity> categories = const [],
}) {
  final now = DateTime.now();
  return BudgetEntity(
    month: now.month,
    year: now.year,
    totalLimit: totalLimit,
    totalSpent: totalSpent,
    daysInMonth: DateTime(now.year, now.month + 1, 0).day,
    categories: categories,
  );
}

class FakeBudgetRepository implements BudgetRepository {
  final _controller = StreamController<BudgetEntity?>.broadcast();
  BudgetEntity? current;

  void emit(BudgetEntity? b) {
    current = b;
    _controller.add(b);
  }

  @override
  Stream<BudgetEntity?> watchBudget(String uid, int month, int year) =>
      _controller.stream;

  @override
  Future<BudgetEntity?> getBudget(String uid, int month, int year) async =>
      current;

  @override
  Future<Map<String, double>> getThreeMonthAverageByCategory(
          String uid, int month, int year) async =>
      {};

  @override
  Future<Either<Failure, void>> setMonthlyLimit(
      String uid, int month, int year, double limit) async {
    emit((current ?? buildBudget()).copyWith(totalLimit: limit));
    return const Right(null);
  }

  @override
  Future<Either<Failure, void>> addCategory(String uid, int month, int year,
      BudgetCategoryEntity category) async {
    emit((current ?? buildBudget()).copyWith(
      categories: [...?current?.categories, category.copyWith(id: category.name)],
    ));
    return const Right(null);
  }

  @override
  Future<Either<Failure, void>> updateCategory(String uid, int month, int year,
          BudgetCategoryEntity category) async =>
      const Right(null);

  @override
  Future<Either<Failure, void>> deleteCategory(
          String uid, int month, int year, String categoryId) async =>
      const Right(null);

  @override
  Future<Either<Failure, void>> markAsPaid(String uid, int month, int year,
          String categoryId, bool isPaid) async =>
      const Right(null);
}

void main() {
  setUpAll(() => GoogleFonts.config.allowRuntimeFetching = false);

  late FakeBudgetRepository fake;

  final testUser = UserEntity(
    id: 'u1',
    email: 'a@b.com',
    name: 'Alex',
    memberSince: DateTime(2024, 1, 1),
  );

  setUp(() => fake = FakeBudgetRepository());

  Future<void> pump(WidgetTester tester) async {
    tester.view.physicalSize = const Size(1200, 2800);
    tester.view.devicePixelRatio = 1.0;
    addTearDown(tester.view.reset);

    final router = GoRouter(
      initialLocation: '/home/budget',
      routes: [
        GoRoute(path: '/home/budget', builder: (_, __) => const BudgetPage()),
        GoRoute(
            path: '/home/goals',
            builder: (_, __) => const Scaffold(body: Text('GOALS STUB'))),
      ],
    );

    await tester.pumpWidget(
      ProviderScope(
        overrides: [
          budgetRepositoryProvider.overrideWithValue(fake),
          authStateProvider
              .overrideWith((ref) => Stream<UserEntity?>.value(testUser)),
        ],
        child: MaterialApp.router(routerConfig: router),
      ),
    );
    await tester.pump();
  }

  testWidgets('1. shows a shimmer while the budget loads', (tester) async {
    await pump(tester);
    expect(find.byType(Shimmer), findsOneWidget);
  });

  testWidgets('2. renders the monthly limit once data arrives',
      (tester) async {
    await pump(tester);
    fake.emit(buildBudget(totalLimit: 2450));
    await tester.pumpAndSettle();
    expect(find.text('\$2,450.00'), findsOneWidget);
  });

  testWidgets('3. progress bar reflects the percent used', (tester) async {
    await pump(tester);
    fake.emit(buildBudget(totalLimit: 2450, totalSpent: 1837.5)); // 75%
    await tester.pumpAndSettle();
    expect(find.text('75% USED'), findsOneWidget);
  });

  testWidgets('4. paid categories show a PAID badge', (tester) async {
    await pump(tester);
    fake.emit(buildBudget(
      totalLimit: 2000,
      totalSpent: 1200,
      categories: const [
        BudgetCategoryEntity(
            id: 'rent', name: 'Rent', limit: 1200, spent: 1200, isPaid: true),
      ],
    ));
    await tester.pumpAndSettle();
    expect(find.text('PAID'), findsOneWidget);
  });

  testWidgets('5. add-category sheet opens from the FAB', (tester) async {
    await pump(tester);
    fake.emit(buildBudget(totalLimit: 1000));
    await tester.pumpAndSettle();

    await tester.tap(find.byKey(const Key('add-category-fab')));
    await tester.pumpAndSettle();
    expect(find.text('New Category'), findsOneWidget);
  });

  testWidgets('6. saving a category updates the list in real time',
      (tester) async {
    await pump(tester);
    fake.emit(buildBudget(totalLimit: 1000));
    await tester.pumpAndSettle();

    await tester.tap(find.byKey(const Key('add-category-fab')));
    await tester.pumpAndSettle();
    await tester.enterText(find.byType(TextFormField).at(0), 'Subscriptions');
    await tester.enterText(find.byType(TextFormField).at(1), '50');
    await tester.tap(find.text('Add Category'));
    await tester.pumpAndSettle();

    expect(find.text('Subscriptions'), findsOneWidget);
  });

  testWidgets('7. an over-budget category exposes Optimize Now',
      (tester) async {
    await pump(tester);
    fake.emit(buildBudget(
      totalLimit: 500,
      totalSpent: 95,
      categories: const [
        BudgetCategoryEntity(id: 'r', name: 'Rent', limit: 100, spent: 95),
      ],
    ));
    await tester.pumpAndSettle();
    expect(find.text('Optimize Now'), findsOneWidget);
  });

  testWidgets('8. Optimize Now navigates to the goals tab', (tester) async {
    await pump(tester);
    fake.emit(buildBudget(
      totalLimit: 500,
      totalSpent: 95,
      categories: const [
        BudgetCategoryEntity(id: 'r', name: 'Rent', limit: 100, spent: 95),
      ],
    ));
    await tester.pumpAndSettle();

    await tester.ensureVisible(find.text('Optimize Now'));
    await tester.tap(find.text('Optimize Now'));
    await tester.pumpAndSettle();
    expect(find.text('GOALS STUB'), findsOneWidget);
  });

  testWidgets('9. empty state lets the user set a monthly budget',
      (tester) async {
    await pump(tester);
    fake.emit(null); // no budget yet
    await tester.pumpAndSettle();

    expect(find.text('No budget yet'), findsOneWidget);
    expect(find.byKey(const Key('set-budget-button')), findsOneWidget);

    await tester.tap(find.byKey(const Key('set-budget-button')));
    await tester.pumpAndSettle();

    await tester.enterText(
        find.byKey(const Key('monthly-limit-field')), '1500');
    await tester.tap(find.text('Save Budget'));
    await tester.pumpAndSettle();

    // setMonthlyLimit emits a budget → the meter now shows the limit.
    expect(find.text('\$1,500.00'), findsOneWidget);
  });
}
