import 'dart:async';

import 'package:dartz/dartz.dart';
import 'package:eduvest_output/core/errors/failures.dart';
import 'package:eduvest_output/features/authentication/domain/entities/user_entity.dart';
import 'package:eduvest_output/features/authentication/presentation/pages/login_page.dart';
import 'package:eduvest_output/features/authentication/presentation/providers/auth_provider.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:go_router/go_router.dart';
import 'package:mockito/mockito.dart';

import '../../helpers/test_mocks.dart';

void main() {
  late MockAuthRepository repository;

  final tUser = UserEntity(
    id: 'uid-123',
    email: 'student@university.edu',
    name: 'Alex Sterling',
    memberSince: DateTime(2024, 1, 1),
  );

  setUp(() {
    repository = MockAuthRepository();
    when(repository.currentUser).thenReturn(null);
  });

  // Test-local router: isolates LoginPage navigation from the real auth guard.
  GoRouter buildRouter() => GoRouter(
        initialLocation: '/login',
        routes: [
          GoRoute(path: '/login', builder: (_, __) => const LoginPage()),
          GoRoute(
              path: '/signup',
              builder: (_, __) =>
                  const Scaffold(body: Text('SIGNUP PAGE'))),
          GoRoute(
              path: '/forgot-password',
              builder: (_, __) =>
                  const Scaffold(body: Text('FORGOT PAGE'))),
          GoRoute(
              path: '/home',
              builder: (_, __) => const Scaffold(body: Text('HOME PAGE'))),
        ],
      );

  Future<void> pumpLogin(WidgetTester tester) async {
    // Use a tall viewport so the full (scrollable) login form is laid out
    // on-screen and every control is hit-testable.
    tester.view.physicalSize = const Size(1200, 2600);
    tester.view.devicePixelRatio = 1.0;
    addTearDown(tester.view.reset);

    await tester.pumpWidget(
      ProviderScope(
        overrides: [
          authRepoProvider.overrideWithValue(repository),
        ],
        child: MaterialApp.router(routerConfig: buildRouter()),
      ),
    );
    await tester.pumpAndSettle();
  }

  Future<void> enterValidCredentials(WidgetTester tester) async {
    await tester.enterText(
        find.byType(TextFormField).at(0), 'student@university.edu');
    await tester.enterText(find.byType(TextFormField).at(1), 'pass1234');
  }

  group('LoginPage widget', () {
    testWidgets('1. renders email and password fields', (tester) async {
      await pumpLogin(tester);

      expect(find.text('Email address'), findsOneWidget);
      expect(find.text('Password'), findsOneWidget);
      expect(find.byType(TextFormField), findsNWidgets(2));
      expect(find.widgetWithText(ElevatedButton, 'Sign In'), findsOneWidget);
    });

    testWidgets('2. shows validation error when email is empty on submit',
        (tester) async {
      await pumpLogin(tester);

      await tester.enterText(find.byType(TextFormField).at(1), 'pass1234');
      await tester.tap(find.widgetWithText(ElevatedButton, 'Sign In'));
      await tester.pump();

      expect(find.text('Please enter your email'), findsOneWidget);
      verifyNever(repository.login(any, any));
    });

    testWidgets('3. shows validation error when password is empty',
        (tester) async {
      await pumpLogin(tester);

      await tester.enterText(
          find.byType(TextFormField).at(0), 'student@university.edu');
      await tester.tap(find.widgetWithText(ElevatedButton, 'Sign In'));
      await tester.pump();

      expect(find.text('Please enter your password'), findsOneWidget);
      verifyNever(repository.login(any, any));
    });

    testWidgets('4. shows loading indicator while signing in',
        (tester) async {
      final completer = Completer<Either<Failure, UserEntity>>();
      when(repository.login(any, any)).thenAnswer((_) => completer.future);

      await pumpLogin(tester);
      await enterValidCredentials(tester);

      await tester.tap(find.widgetWithText(ElevatedButton, 'Sign In'));
      await tester.pump(); // begin async login → AsyncLoading

      expect(find.byType(CircularProgressIndicator), findsOneWidget);

      // Complete to avoid pending timers.
      completer.complete(Right(tUser));
      await tester.pumpAndSettle();
    });

    testWidgets('5. shows error SnackBar on failed login', (tester) async {
      when(repository.login(any, any)).thenAnswer(
        (_) async =>
            const Left(AuthFailure('Incorrect password. Please try again.')),
      );

      await pumpLogin(tester);
      await enterValidCredentials(tester);

      await tester.tap(find.widgetWithText(ElevatedButton, 'Sign In'));
      await tester.pumpAndSettle();

      expect(find.byType(SnackBar), findsOneWidget);
      expect(find.text('Incorrect password. Please try again.'),
          findsOneWidget);
    });

    testWidgets('6. navigates to HomePage on successful login',
        (tester) async {
      when(repository.login(any, any))
          .thenAnswer((_) async => Right(tUser));

      await pumpLogin(tester);
      await enterValidCredentials(tester);

      await tester.tap(find.widgetWithText(ElevatedButton, 'Sign In'));
      await tester.pumpAndSettle();

      expect(find.text('HOME PAGE'), findsOneWidget);
    });

    testWidgets("7. navigates to SignupPage on 'Sign Up' tap",
        (tester) async {
      await pumpLogin(tester);

      await tester.tap(find.text('Sign Up'));
      await tester.pumpAndSettle();

      expect(find.text('SIGNUP PAGE'), findsOneWidget);
    });

    testWidgets("8. navigates to ForgotPasswordPage on 'Forgot password?' tap",
        (tester) async {
      await pumpLogin(tester);

      await tester.tap(find.text('Forgot password?'));
      await tester.pumpAndSettle();

      expect(find.text('FORGOT PAGE'), findsOneWidget);
    });
  });
}
