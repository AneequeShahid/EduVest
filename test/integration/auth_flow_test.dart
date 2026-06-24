// Integration flow: authentication.
//
// Drives the real LoginPage / SignupPage / ForgotPasswordPage through a
// test-local router with a fake AuthRepository (no Firebase). Exercises the
// full sign-in, sign-up and password-reset journeys end to end.
import 'dart:async';

import 'package:dartz/dartz.dart';
import 'package:eduvest_output/core/errors/failures.dart';
import 'package:eduvest_output/features/authentication/domain/entities/user_entity.dart';
import 'package:eduvest_output/features/authentication/domain/repositories/auth_repository.dart';
import 'package:eduvest_output/features/authentication/presentation/pages/forgot_password_page.dart';
import 'package:eduvest_output/features/authentication/presentation/pages/login_page.dart';
import 'package:eduvest_output/features/authentication/presentation/pages/signup_page.dart';
import 'package:eduvest_output/features/authentication/presentation/providers/auth_provider.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:go_router/go_router.dart';

class FakeAuthRepository implements AuthRepository {
  final StreamController<UserEntity?> _controller =
      StreamController<UserEntity?>.broadcast();
  UserEntity? _current;

  bool failNext = false;
  String failMessage = 'Incorrect password. Please try again.';

  UserEntity _make(String email, [String name = 'Alex Sterling']) =>
      UserEntity(
        id: 'uid-1',
        email: email,
        name: name,
        memberSince: DateTime(2024, 1, 1),
      );

  @override
  UserEntity? get currentUser => _current;

  @override
  Stream<UserEntity?> get authStateChanges => _controller.stream;

  @override
  Future<Either<Failure, UserEntity>> login(
      String email, String password) async {
    if (failNext) return Left(AuthFailure(failMessage));
    _current = _make(email);
    _controller.add(_current);
    return Right(_current!);
  }

  @override
  Future<Either<Failure, UserEntity>> signup(
      String email, String password, String name) async {
    if (failNext) return Left(AuthFailure(failMessage));
    _current = _make(email, name);
    _controller.add(_current);
    return Right(_current!);
  }

  @override
  Future<Either<Failure, void>> logout() async {
    _current = null;
    _controller.add(null);
    return const Right(null);
  }

  @override
  Future<Either<Failure, void>> resetPassword(String email) async {
    if (failNext) return Left(AuthFailure(failMessage));
    return const Right(null);
  }

  void dispose() => _controller.close();
}

void main() {
  late FakeAuthRepository repo;

  setUp(() => repo = FakeAuthRepository());
  tearDown(() => repo.dispose());

  GoRouter buildRouter(String initial) => GoRouter(
        initialLocation: initial,
        routes: [
          GoRoute(path: '/login', builder: (_, __) => const LoginPage()),
          GoRoute(path: '/signup', builder: (_, __) => const SignupPage()),
          GoRoute(
              path: '/forgot-password',
              builder: (_, __) => const ForgotPasswordPage()),
          GoRoute(
              path: '/home',
              builder: (_, __) => const Scaffold(body: Text('HOME PAGE'))),
        ],
      );

  Future<void> pump(WidgetTester tester, {String initial = '/login'}) async {
    tester.view.physicalSize = const Size(1200, 2800);
    tester.view.devicePixelRatio = 1.0;
    addTearDown(tester.view.reset);

    await tester.pumpWidget(
      ProviderScope(
        overrides: [authRepoProvider.overrideWithValue(repo)],
        child: MaterialApp.router(routerConfig: buildRouter(initial)),
      ),
    );
    await tester.pumpAndSettle();
  }

  testWidgets('1. login page renders its core controls', (tester) async {
    await pump(tester);
    expect(find.text('Email address'), findsOneWidget);
    expect(find.text('Password'), findsOneWidget);
    expect(find.widgetWithText(ElevatedButton, 'Sign In'), findsOneWidget);
  });

  testWidgets('2. empty login submit shows a validation error',
      (tester) async {
    await pump(tester);
    await tester.tap(find.widgetWithText(ElevatedButton, 'Sign In'));
    await tester.pump();
    expect(find.textContaining('enter your email'), findsOneWidget);
  });

  testWidgets('3. wrong credentials surface an error SnackBar',
      (tester) async {
    repo.failNext = true;
    await pump(tester);
    await tester.enterText(
        find.byType(TextFormField).at(0), 'a@b.com');
    await tester.enterText(find.byType(TextFormField).at(1), 'wrongpass1');
    await tester.tap(find.widgetWithText(ElevatedButton, 'Sign In'));
    await tester.pumpAndSettle();
    expect(find.byType(SnackBar), findsOneWidget);
  });

  testWidgets('4. successful login navigates to home', (tester) async {
    await pump(tester);
    await tester.enterText(
        find.byType(TextFormField).at(0), 'student@uni.edu');
    await tester.enterText(find.byType(TextFormField).at(1), 'pass1234');
    await tester.tap(find.widgetWithText(ElevatedButton, 'Sign In'));
    await tester.pumpAndSettle();
    expect(find.text('HOME PAGE'), findsOneWidget);
  });

  testWidgets("5. 'Sign Up' link opens the signup page", (tester) async {
    await pump(tester);
    await tester.tap(find.text('Sign Up'));
    await tester.pumpAndSettle();
    expect(find.text('Create account'), findsOneWidget);
  });

  testWidgets('6. signup rejects mismatched passwords', (tester) async {
    await pump(tester, initial: '/signup');
    await tester.enterText(find.byType(TextFormField).at(0), 'Jane Doe');
    await tester.enterText(find.byType(TextFormField).at(1), 'jane@uni.edu');
    await tester.enterText(find.byType(TextFormField).at(2), 'pass1234');
    await tester.enterText(find.byType(TextFormField).at(3), 'different1');
    await tester.tap(find.widgetWithText(ElevatedButton, 'Create Account'));
    await tester.pump();
    expect(find.text('Passwords do not match'), findsOneWidget);
  });

  testWidgets('7. valid signup navigates to home', (tester) async {
    await pump(tester, initial: '/signup');
    await tester.enterText(find.byType(TextFormField).at(0), 'Jane Doe');
    await tester.enterText(find.byType(TextFormField).at(1), 'jane@uni.edu');
    await tester.enterText(find.byType(TextFormField).at(2), 'pass1234');
    await tester.enterText(find.byType(TextFormField).at(3), 'pass1234');
    await tester.tap(find.widgetWithText(ElevatedButton, 'Create Account'));
    await tester.pumpAndSettle();
    expect(find.text('HOME PAGE'), findsOneWidget);
  });

  testWidgets("8. 'Forgot password?' opens the reset page", (tester) async {
    await pump(tester);
    await tester.tap(find.text('Forgot password?'));
    await tester.pumpAndSettle();
    expect(find.text('Reset password'), findsOneWidget);
  });

  testWidgets('9. reset with empty email shows a validation error',
      (tester) async {
    await pump(tester, initial: '/forgot-password');
    await tester.tap(find.widgetWithText(ElevatedButton, 'Send Reset Link'));
    await tester.pump();
    expect(find.textContaining('enter your email'), findsOneWidget);
  });

  testWidgets('10. valid reset shows the confirmation state', (tester) async {
    await pump(tester, initial: '/forgot-password');
    await tester.enterText(
        find.byType(TextFormField).at(0), 'student@uni.edu');
    await tester.tap(find.widgetWithText(ElevatedButton, 'Send Reset Link'));
    await tester.pumpAndSettle();
    expect(find.text('Check your email'), findsOneWidget);
  });
}
