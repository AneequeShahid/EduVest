import 'dart:async';

import 'package:dartz/dartz.dart';
import 'package:eduvest_output/core/errors/failures.dart';
import 'package:eduvest_output/core/widgets/custom_progress_bar.dart';
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
  // Broadcast so the stream can be re-listened when upstream providers
  // (e.g. authState) settle and trigger a re-subscription.
  final _controller = StreamController<BudgetEntity?>.broadcast();
  BudgetEntity? current;
  Map<String, double> avg = {};

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
      avg;

  @override
  Future<Either<Failure, void>> setMonthlyLimit(
          String uid, int month, int year, double limit) async =>
      const Right(null);

  @override
  Future<Either<Failure, void>> addCategory(String uid, int month, int year,
      BudgetCategoryEntity category) async {
    final updated = (current ?? buildBudget()).copyWith(
      categories: [
        ...?current?.categories,
        category.copyWith(id: category.name),
      ],
    );
    emit(updated);
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

  Future<void> pumpPage(WidgetTester tester) async {
    tester.view.physicalSize = const Size(1200, 2800);
    tester.view.devicePixelRatio = 1.0;
    addTearDown(tester.view.reset);

    final router = GoRouter(
      initialLocation: '/home/budget',
      routes: [
        GoRoute(
            path: '/home/budget', builder: (_, __) => const BudgetPage()),
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

  testWidgets('1. shows shimmer while loading', (tester) async {
    await pumpPage(tester); // no emit → loading
    expect(find.byType(Shimmer), findsOneWidget);
  });

  testWidgets('2. displays the correct total limit', (tester) async {
    await pumpPage(tester);
    fake.emit(buildBudget(totalLimit: 2450, totalSpent: 0));
    await tester.pumpAndSettle();

    expect(find.text('\$2,450.00'), findsOneWidget);
  });

  testWidgets('3. progress bar fills to the correct percentage',
      (tester) async {
    await pumpPage(tester);
    fake.emit(buildBudget(totalLimit: 2450, totalSpent: 1837.5)); // 75%
    await tester.pumpAndSettle();

    expect(find.text('75% USED'), findsOneWidget);
  });

  testWidgets("4. 'PAID' badge appears for paid categories", (tester) async {
    await pumpPage(tester);
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

  testWidgets('5. category turns red when > 90% used', (tester) async {
    await pumpPage(tester);
    fake.emit(buildBudget(
      totalLimit: 500,
      totalSpent: 95,
      categories: const [
        BudgetCategoryEntity(
            id: 'g', name: 'Groceries', limit: 100, spent: 95), // 95%
      ],
    ));
    await tester.pumpAndSettle();

    final bar = tester.widget<CustomProgressBar>(
      find.descendant(
        of: find.byKey(const Key('category-card-Groceries')),
        matching: find.byType(CustomProgressBar),
      ),
    );
    expect(bar.foregroundColor, const Color(0xFFB71C1C)); // AppColors.error
  });

  testWidgets("6. 'Optimize Now' navigates to Goals", (tester) async {
    await pumpPage(tester);
    fake.emit(buildBudget(
      totalLimit: 500,
      totalSpent: 95,
      categories: const [
        BudgetCategoryEntity(
            id: 'r', name: 'Rent', limit: 100, spent: 95), // warning
      ],
    ));
    await tester.pumpAndSettle();

    await tester.ensureVisible(find.text('Optimize Now'));
    await tester.tap(find.text('Optimize Now'));
    await tester.pumpAndSettle();

    expect(find.text('GOALS STUB'), findsOneWidget);
  });

  testWidgets('7. AddCategorySheet appears on FAB tap', (tester) async {
    await pumpPage(tester);
    fake.emit(buildBudget(totalLimit: 1000));
    await tester.pumpAndSettle();

    await tester.tap(find.byKey(const Key('add-category-fab')));
    await tester.pumpAndSettle();

    expect(find.text('New Category'), findsOneWidget);
  });

  testWidgets('8. saving a category updates the list in real-time',
      (tester) async {
    await pumpPage(tester);
    fake.emit(buildBudget(totalLimit: 1000));
    await tester.pumpAndSettle();

    await tester.tap(find.byKey(const Key('add-category-fab')));
    await tester.pumpAndSettle();

    await tester.enterText(
        find.byType(TextFormField).at(0), 'Subscriptions');
    await tester.enterText(find.byType(TextFormField).at(1), '50');
    await tester.tap(find.text('Add Category'));
    await tester.pumpAndSettle();

    expect(find.text('Subscriptions'), findsOneWidget);
  });
}
