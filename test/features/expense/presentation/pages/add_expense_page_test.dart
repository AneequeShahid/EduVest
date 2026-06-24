import 'dart:async';
import 'dart:io';

import 'package:dartz/dartz.dart';
import 'package:eduvest_output/core/errors/failures.dart';
import 'package:eduvest_output/core/widgets/loading_overlay.dart';
import 'package:eduvest_output/features/authentication/domain/entities/user_entity.dart';
import 'package:eduvest_output/features/authentication/presentation/providers/auth_provider.dart';
import 'package:eduvest_output/features/expense/domain/entities/expense_entity.dart';
import 'package:eduvest_output/features/expense/domain/repositories/expense_repository.dart';
import 'package:eduvest_output/features/expense/presentation/pages/add_expense_page.dart';
import 'package:eduvest_output/features/expense/presentation/providers/expense_provider.dart';
import 'package:eduvest_output/features/expense/presentation/widgets/category_picker.dart';
import 'package:eduvest_output/features/expense/presentation/widgets/receipt_picker.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:go_router/go_router.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:image_picker/image_picker.dart';

class FakeExpenseRepository implements ExpenseRepository {
  Completer<void>? addGate;
  bool addShouldFail = false;
  bool uploadShouldFail = false;
  int addCalls = 0;

  @override
  Future<Either<Failure, void>> addExpense(
      String uid, ExpenseEntity expense) async {
    addCalls++;
    if (addGate != null) await addGate!.future;
    if (addShouldFail) return const Left(ServerFailure('save failed'));
    return const Right(null);
  }

  @override
  Future<Either<Failure, void>> updateExpense(
          String uid, ExpenseEntity expense) async =>
      const Right(null);

  @override
  Future<Either<Failure, void>> deleteExpense(
          String uid, String expenseId) async =>
      const Right(null);

  @override
  Future<Either<Failure, void>> deleteReceipt(
          String uid, String expenseId) async =>
      const Right(null);

  @override
  Future<Either<Failure, String>> uploadReceipt(
      String uid, String expenseId, File file) async {
    if (uploadShouldFail) {
      return const Left(ServerFailure('storage unavailable'));
    }
    return const Right('https://example.com/r.jpg');
  }

  @override
  Stream<List<ExpenseEntity>> getExpensesStream(String uid,
          {int? month, int? year}) =>
      Stream.value(const []);
}

class FakeReceiptPicker implements ReceiptPicker {
  final File file;
  FakeReceiptPicker(this.file);

  @override
  Future<File?> pick(ImageSource source) async => file;
}

void main() {
  setUpAll(() {
    GoogleFonts.config.allowRuntimeFetching = false;
  });

  late FakeExpenseRepository fakeRepo;
  late File tempReceipt;

  final testUser = UserEntity(
    id: 'u1',
    email: 'a@b.com',
    name: 'Alex',
    memberSince: DateTime(2024, 1, 1),
  );

  setUp(() {
    fakeRepo = FakeExpenseRepository();
    tempReceipt = File(
        '${Directory.systemTemp.path}/eduvest_test_receipt.jpg')
      ..writeAsBytesSync([0, 1, 2, 3]);
  });

  Future<void> pumpPage(WidgetTester tester, {ReceiptPicker? picker}) async {
    tester.view.physicalSize = const Size(1200, 3200);
    tester.view.devicePixelRatio = 1.0;
    addTearDown(tester.view.reset);

    final router = GoRouter(
      initialLocation: '/home/add-expense',
      routes: [
        GoRoute(
            path: '/home',
            builder: (_, __) => const Scaffold(body: Text('HOME STUB'))),
        GoRoute(
          path: '/home/add-expense',
          builder: (_, __) => AddExpensePage(picker: picker),
        ),
      ],
    );

    await tester.pumpWidget(
      ProviderScope(
        overrides: [
          expenseRepositoryProvider.overrideWithValue(fakeRepo),
          authStateProvider
              .overrideWith((ref) => Stream<UserEntity?>.value(testUser)),
        ],
        child: MaterialApp.router(routerConfig: router),
      ),
    );
    await tester.pumpAndSettle();
  }

  // Fills a valid form (amount via numpad, description, category).
  Future<void> fillValidForm(WidgetTester tester) async {
    await tester.tap(find.byKey(const Key('numpad-5')));
    await tester.tap(find.byKey(const Key('numpad-0')));
    await tester.tap(find.byKey(const Key('numpad-0')));
    await tester.enterText(find.byType(TextFormField), 'Calculus book');
    await tester.tap(find.byKey(const Key('category-chip-Education')));
    await tester.pump();
  }

  testWidgets("1. amount display starts at '\$0.00'", (tester) async {
    await pumpPage(tester);
    expect(find.text('\$0.00'), findsOneWidget);
  });

  testWidgets('2. numpad input updates the amount display', (tester) async {
    await pumpPage(tester);

    await tester.tap(find.byKey(const Key('numpad-1')));
    await tester.tap(find.byKey(const Key('numpad-2')));
    await tester.tap(find.byKey(const Key('numpad-3')));
    await tester.pump();

    expect(find.text('\$1.23'), findsOneWidget);
  });

  testWidgets('3. category picker shows all 7 categories', (tester) async {
    await pumpPage(tester);
    for (final c in CategoryPicker.categories) {
      expect(find.byKey(Key('category-chip-$c')), findsOneWidget);
    }
    expect(CategoryPicker.categories.length, 7);
  });

  testWidgets('4. selected category chip turns primary color',
      (tester) async {
    await pumpPage(tester);

    await tester.tap(find.byKey(const Key('category-chip-Rent')));
    await tester.pump();

    final container = tester.widget<Container>(
      find.descendant(
        of: find.byKey(const Key('category-chip-Rent')),
        matching: find.byType(Container),
      ),
    );
    final decoration = container.decoration as BoxDecoration;
    expect(decoration.color, const Color(0xFFC1622A)); // AppColors.primary
  });

  testWidgets('5. shows validation error on empty description',
      (tester) async {
    await pumpPage(tester);
    // Valid amount + category, but no description.
    await tester.tap(find.byKey(const Key('numpad-5')));
    await tester.tap(find.byKey(const Key('category-chip-Education')));
    await tester.pump();

    await tester.tap(find.text('Save Expense'));
    await tester.pump();

    expect(find.text('Description is required'), findsOneWidget);
  });

  testWidgets('6. shows validation error on zero amount', (tester) async {
    await pumpPage(tester);
    await tester.enterText(find.byType(TextFormField), 'Something');
    await tester.tap(find.byKey(const Key('category-chip-Education')));
    await tester.pump();

    await tester.tap(find.text('Save Expense'));
    await tester.pump();

    expect(find.text('Amount must be greater than zero'), findsOneWidget);
  });

  testWidgets('7. shows receipt thumbnail after an image is picked',
      (tester) async {
    await pumpPage(tester, picker: FakeReceiptPicker(tempReceipt));

    await tester.tap(find.byKey(const Key('receipt-upload-area')));
    await tester.pumpAndSettle();
    await tester.tap(find.text('Gallery'));
    await tester.pumpAndSettle();

    expect(find.byKey(const Key('receipt-thumbnail')), findsOneWidget);
  });

  testWidgets('8. shows loading overlay during save', (tester) async {
    fakeRepo.addGate = Completer<void>();
    await pumpPage(tester);
    await fillValidForm(tester);

    await tester.tap(find.text('Save Expense'));
    await tester.pump(); // enters saving state

    expect(find.byType(LoadingOverlay), findsOneWidget);
    expect(find.byType(CircularProgressIndicator), findsOneWidget);

    // Drain without pumpAndSettle (spinner + SnackBar timer never settle).
    fakeRepo.addGate!.complete();
    await tester.pump(); // resolve save → navigate
    await tester.pump(const Duration(milliseconds: 350)); // snackbar entry
    await tester.pump(const Duration(seconds: 5)); // drain snackbar timer
  });

  testWidgets('9. pops and shows SnackBar on successful save',
      (tester) async {
    await pumpPage(tester);
    await fillValidForm(tester);

    await tester.tap(find.text('Save Expense'));
    await tester.pump(); // saving
    await tester.pump(); // resolve save → navigate + snackbar
    await tester.pump(const Duration(milliseconds: 350)); // snackbar entry

    expect(find.text('Expense added!'), findsOneWidget);
    expect(find.text('HOME STUB'), findsOneWidget);
    await tester.pump(const Duration(seconds: 5)); // drain snackbar timer
  });

}
