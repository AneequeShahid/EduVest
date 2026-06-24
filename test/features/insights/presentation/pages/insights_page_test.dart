import 'dart:async';

import 'package:eduvest_output/core/widgets/error_state.dart';
import 'package:eduvest_output/features/authentication/domain/entities/user_entity.dart';
import 'package:eduvest_output/features/authentication/presentation/providers/auth_provider.dart';
import 'package:eduvest_output/features/insights/domain/entities/category_spend_entity.dart';
import 'package:eduvest_output/features/insights/domain/entities/insights_entity.dart';
import 'package:eduvest_output/features/insights/domain/entities/monthly_flow_entity.dart';
import 'package:eduvest_output/features/insights/domain/entities/recommendation_entity.dart';
import 'package:eduvest_output/features/insights/presentation/pages/insights_page.dart';
import 'package:eduvest_output/features/insights/presentation/providers/insights_provider.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:go_router/go_router.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:shimmer/shimmer.dart';

InsightsEntity buildInsights({int score = 85}) => InsightsEntity(
      healthScore: score,
      healthLabel: 'Excellent',
      monthlyYieldPercent: 5.0,
      riskProfile: 'Minimal',
      capitalFlowData: List.generate(
        6,
        (i) => MonthlyFlowEntity(
            month: i + 1, year: 2026, totalSpent: 100.0 + i, totalIncome: 200),
      ),
      categoryBreakdown: const [
        CategorySpendEntity(
            category: 'Groceries', totalSpent: 150, percentOfTotal: 60),
        CategorySpendEntity(
            category: 'Fun', totalSpent: 100, percentOfTotal: 40),
      ],
      recommendations: const [
        RecommendationEntity(
            id: 'r1', title: 'First Tip', description: 'Tip one body.'),
        RecommendationEntity(
            id: 'r2', title: 'Second Tip', description: 'Tip two body.'),
      ],
    );

void main() {
  setUpAll(() => GoogleFonts.config.allowRuntimeFetching = false);

  Future<void> pump(
    WidgetTester tester, {
    required Override insightsOverride,
  }) async {
    tester.view.physicalSize = const Size(1200, 3200);
    tester.view.devicePixelRatio = 1.0;
    addTearDown(tester.view.reset);

    final router = GoRouter(
      initialLocation: '/home/insights',
      routes: [
        GoRoute(
            path: '/home/insights', builder: (_, __) => const InsightsPage()),
        GoRoute(
            path: '/home/expenses',
            builder: (_, __) => const Scaffold(body: Text('EXPENSES STUB'))),
      ],
    );

    await tester.pumpWidget(
      ProviderScope(
        overrides: [
          insightsOverride,
          authStateProvider.overrideWith(
            (ref) => Stream<UserEntity?>.value(
              UserEntity(
                id: 'u1',
                email: 'a@b.com',
                name: 'Alex',
                memberSince: DateTime(2024, 1, 1),
              ),
            ),
          ),
        ],
        child: MaterialApp.router(routerConfig: router),
      ),
    );
  }

  Override dataOverride([int score = 85]) =>
      insightsProvider.overrideWith((ref) => buildInsights(score: score));

  testWidgets('1. health score ring starts at 0 and animates', (tester) async {
    await pump(tester, insightsOverride: dataOverride(82));
    await tester.pump(); // data resolves, ring mounts at value 0

    expect(find.text('0'), findsOneWidget);

    await tester.pump(const Duration(seconds: 2)); // finish 1.5s animation
    expect(find.text('82'), findsOneWidget);
  });

  testWidgets("2. shows 'EXCELLENT' for score >= 80", (tester) async {
    await pump(tester, insightsOverride: dataOverride(85));
    await tester.pump(const Duration(seconds: 2));

    expect(find.text('EXCELLENT'), findsOneWidget);
  });

  testWidgets('3. month toggle is active by default / re-selectable',
      (tester) async {
    await pump(tester, insightsOverride: dataOverride());
    await tester.pump(const Duration(seconds: 2));

    await tester.tap(find.byKey(const Key('toggle-month')));
    await tester.pump();

    final container = tester.widget<Container>(
      find.descendant(
        of: find.byKey(const Key('toggle-month')),
        matching: find.byType(Container),
      ),
    );
    expect((container.decoration as BoxDecoration).color,
        const Color(0xFFC1622A)); // primary
  });

  testWidgets('4. year toggle switches chart data', (tester) async {
    await pump(tester, insightsOverride: dataOverride());
    await tester.pump(const Duration(seconds: 2));

    await tester.tap(find.byKey(const Key('toggle-year')));
    await tester.pump();

    final container = tester.widget<Container>(
      find.descendant(
        of: find.byKey(const Key('toggle-year')),
        matching: find.byType(Container),
      ),
    );
    expect((container.decoration as BoxDecoration).color,
        const Color(0xFFC1622A)); // primary → year now active
  });

  testWidgets('5. category items show correct amounts', (tester) async {
    await pump(tester, insightsOverride: dataOverride());
    await tester.pump(const Duration(seconds: 2));

    expect(find.text('\$150.00'), findsOneWidget);
    expect(find.text('\$100.00'), findsOneWidget);
  });

  testWidgets('6. recommendation auto-rotates after 5 seconds',
      (tester) async {
    await pump(tester, insightsOverride: dataOverride());
    await tester.pump(const Duration(seconds: 2)); // settle ring

    expect(find.text('First Tip'), findsOneWidget);

    await tester.pump(const Duration(seconds: 5)); // rotate
    expect(find.text('Second Tip'), findsOneWidget);
    expect(find.text('First Tip'), findsNothing);
  });

  testWidgets('7. shows shimmer while loading', (tester) async {
    final completer = Completer<InsightsEntity>();
    await pump(
      tester,
      insightsOverride: insightsProvider.overrideWith((ref) => completer.future),
    );
    await tester.pump();

    expect(find.byType(Shimmer), findsOneWidget);
    completer.complete(buildInsights());
    await tester.pump(const Duration(seconds: 2));
  });

  testWidgets('8. shows error state with retry on failure', (tester) async {
    await pump(
      tester,
      insightsOverride: insightsProvider
          .overrideWith((ref) => Future<InsightsEntity>.error('boom')),
    );
    await tester.pump(); // resolve the error

    expect(find.byType(ErrorState), findsOneWidget);
    expect(find.text('Retry'), findsOneWidget);
  });
}
