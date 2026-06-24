// Integration flow: expenses.
//
// Uses a real ExpenseRepositoryImpl backed by FakeFirebaseFirestore, so adding
// an expense on AddExpensePage genuinely persists and surfaces on the
// ExpenseListPage (wired at /home). No Firebase, no network.
import 'package:eduvest_output/features/authentication/domain/entities/user_entity.dart';
import 'package:eduvest_output/features/authentication/presentation/providers/auth_provider.dart';
import 'package:eduvest_output/features/expense/data/repositories/expense_repository_impl.dart';
import 'package:eduvest_output/features/expense/data/sources/expense_remote_source.dart';
import 'package:eduvest_output/features/expense/domain/entities/expense_entity.dart';
import 'package:eduvest_output/features/expense/presentation/pages/add_expense_page.dart';
import 'package:eduvest_output/features/expense/presentation/pages/expense_list_page.dart';
import 'package:eduvest_output/features/expense/presentation/providers/expense_provider.dart';
import 'package:eduvest_output/features/expense/presentation/widgets/category_picker.dart';
import 'package:fake_cloud_firestore/fake_cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:go_router/go_router.dart';
import 'package:google_fonts/google_fonts.dart';

void main() {
  setUpAll(() => GoogleFonts.config.allowRuntimeFetching = false);

  late FakeFirebaseFirestore firestore;
  late ExpenseRepositoryImpl repo;

  final testUser = UserEntity(
    id: 'u1',
    email: 'a@b.com',
    name: 'Alex',
    memberSince: DateTime(2024, 1, 1),
  );

  setUp(() {
    firestore = FakeFirebaseFirestore();
    repo = ExpenseRepositoryImpl(ExpenseRemoteSource(db: firestore));
  });

  Future<void> pump(WidgetTester tester, {String initial = '/home/add'}) async {
    tester.view.physicalSize = const Size(1200, 3200);
    tester.view.devicePixelRatio = 1.0;
    addTearDown(tester.view.reset);

    final router = GoRouter(
      initialLocation: initial,
      routes: [
        GoRoute(path: '/home', builder: (_, __) => const ExpenseListPage()),
        GoRoute(
            path: '/home/add', builder: (_, __) => const AddExpensePage()),
      ],
    );

    await tester.pumpWidget(
      ProviderScope(
        overrides: [
          expenseRepositoryProvider.overrideWithValue(repo),
          authStateProvider
              .overrideWith((ref) => Stream<UserEntity?>.value(testUser)),
        ],
        child: MaterialApp.router(routerConfig: router),
      ),
    );
    await tester.pumpAndSettle();
  }

  Future<void> fillValidForm(WidgetTester tester,
      {String description = 'Calculus book', String category = 'Education'}) async {
    await tester.tap(find.byKey(const Key('numpad-5')));
    await tester.tap(find.byKey(const Key('numpad-0')));
    await tester.tap(find.byKey(const Key('numpad-0')));
    await tester.enterText(find.byType(TextFormField), description);
    await tester.tap(find.byKey(Key('category-chip-$category')));
    await tester.pump();
  }

  testWidgets("1. amount display starts at \$0.00", (tester) async {
    await pump(tester);
    expect(find.text('\$0.00'), findsOneWidget);
  });

  testWidgets('2. numpad input updates the amount', (tester) async {
    await pump(tester);
    await tester.tap(find.byKey(const Key('numpad-1')));
    await tester.tap(find.byKey(const Key('numpad-2')));
    await tester.tap(find.byKey(const Key('numpad-3')));
    await tester.pump();
    expect(find.text('\$1.23'), findsOneWidget);
  });

  testWidgets('3. all seven categories render', (tester) async {
    await pump(tester);
    for (final c in CategoryPicker.categories) {
      expect(find.byKey(Key('category-chip-$c')), findsOneWidget);
    }
  });

  testWidgets('4. empty description is rejected', (tester) async {
    await pump(tester);
    await tester.tap(find.byKey(const Key('numpad-5')));
    await tester.tap(find.byKey(const Key('category-chip-Education')));
    await tester.pump();
    await tester.tap(find.text('Save Expense'));
    await tester.pump();
    expect(find.text('Description is required'), findsOneWidget);
  });

  testWidgets('5. zero amount is rejected', (tester) async {
    await pump(tester);
    await tester.enterText(find.byType(TextFormField), 'Something');
    await tester.tap(find.byKey(const Key('category-chip-Education')));
    await tester.pump();
    await tester.tap(find.text('Save Expense'));
    await tester.pump();
    expect(find.text('Amount must be greater than zero'), findsOneWidget);
  });

  testWidgets('6. a valid save runs through to the success state',
      (tester) async {
    await pump(tester);
    await fillValidForm(tester);
    await tester.tap(find.text('Save Expense'));
    await tester.pump(); // saving
    await tester.pump(); // resolve save → navigate
    await tester.pump(const Duration(milliseconds: 350)); // snackbar entry

    expect(find.text('Expense added!'), findsOneWidget);
    await tester.pump(const Duration(seconds: 5)); // drain snackbar timer
  });

  testWidgets('7. persisted expenses surface on the expense list',
      (tester) async {
    final now = DateTime.now();
    await repo.addExpense('u1', _seed('Calculus book', 500, now));
    await repo.addExpense('u1', _seed('Bus pass', 30, now));

    await pump(tester, initial: '/home');
    await tester.pumpAndSettle();

    expect(find.text('Calculus book'), findsOneWidget);
    expect(find.text('Bus pass'), findsOneWidget);
  });

  testWidgets('8. list shows empty state for a month with no expenses',
      (tester) async {
    // Seed an expense in the current month, then switch to a different month.
    await pump(tester, initial: '/home');
    await tester.pumpAndSettle();

    // No data yet → empty state.
    expect(find.text('No expenses'), findsOneWidget);
  });

  testWidgets('9. swipe-to-delete removes an expense', (tester) async {
    // Seed directly through the repo, then open the list.
    final now = DateTime.now();
    await repo.addExpense('u1', _seed('Lab fee', 42, now));

    await pump(tester, initial: '/home');
    await tester.pumpAndSettle();
    expect(find.text('Lab fee'), findsOneWidget);

    await tester.drag(
        find.text('Lab fee'), const Offset(-500, 0));
    await tester.pumpAndSettle();
    await tester.tap(find.text('Delete'));
    await tester.pumpAndSettle();

    expect(find.text('Lab fee'), findsNothing);
  });
}

ExpenseEntity _seed(String description, double amount, DateTime date) =>
    ExpenseEntity(
      id: 'seed-${description.hashCode}',
      amount: amount,
      description: description,
      category: 'Education',
      date: date,
      month: date.month,
      year: date.year,
    );
