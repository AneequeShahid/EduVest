import 'dart:io';

import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';

import '../../../../core/services/crash_reporter.dart';
import '../../../authentication/presentation/providers/auth_provider.dart';
import '../../data/repositories/expense_repository_impl.dart';
import '../../data/sources/expense_remote_source.dart';
import '../../domain/entities/expense_entity.dart';
import '../../domain/repositories/expense_repository.dart';
import '../../domain/usecases/add_expense_usecase.dart';
import '../../domain/usecases/delete_expense_usecase.dart';
import '../../domain/usecases/get_expenses_usecase.dart';
import '../../domain/usecases/update_expense_usecase.dart';
import '../../domain/usecases/upload_receipt_usecase.dart';

part 'expense_provider.g.dart';

// ── DI ───────────────────────────────────────────────────────────────────────

@riverpod
ExpenseRepository expenseRepository(Ref ref) =>
    ExpenseRepositoryImpl(ExpenseRemoteSource());

@riverpod
AddExpenseUseCase addExpenseUseCase(Ref ref) =>
    AddExpenseUseCase(ref.watch(expenseRepositoryProvider));

@riverpod
UpdateExpenseUseCase updateExpenseUseCase(Ref ref) =>
    UpdateExpenseUseCase(ref.watch(expenseRepositoryProvider));

@riverpod
DeleteExpenseUseCase deleteExpenseUseCase(Ref ref) =>
    DeleteExpenseUseCase(ref.watch(expenseRepositoryProvider));

@riverpod
GetExpensesUseCase getExpensesUseCase(Ref ref) =>
    GetExpensesUseCase(ref.watch(expenseRepositoryProvider));

@riverpod
UploadReceiptUseCase uploadReceiptUseCase(Ref ref) =>
    UploadReceiptUseCase(ref.watch(expenseRepositoryProvider));

// ── Month/year filter ──────────────────────────────────────────────────────

typedef ExpenseFilter = ({int month, int year});

@riverpod
class ExpenseFilterController extends _$ExpenseFilterController {
  @override
  ExpenseFilter build() {
    final now = DateTime.now();
    return (month: now.month, year: now.year);
  }

  void setMonth(int month) => state = (month: month, year: state.year);
  void setYear(int year) => state = (month: state.month, year: year);
  void set(int month, int year) => state = (month: month, year: year);
}

// ── Filtered expenses stream ────────────────────────────────────────────────

@riverpod
Stream<List<ExpenseEntity>> expensesStream(Ref ref) {
  final uid = ref.watch(authStateProvider).valueOrNull?.id ?? '';
  final filter = ref.watch(expenseFilterControllerProvider);
  return ref
      .watch(getExpensesUseCaseProvider)
      .call(uid, month: filter.month, year: filter.year);
}

// ── Mutations controller ────────────────────────────────────────────────────

/// Holds the most recent mutation error message (or null on success/idle).
/// Methods return `true` on success so callers can react synchronously.
@riverpod
class ExpenseController extends _$ExpenseController {
  @override
  String? build() => null;

  String get _uid => ref.read(authStateProvider).valueOrNull?.id ?? '';

  Future<bool> addExpense(ExpenseEntity expense, {File? receipt}) async {
    final uid = _uid;
    if (uid.isEmpty) {
      state = 'You must be signed in to add an expense.';
      return false;
    }

    var toSave = expense;
    if (receipt != null) {
      // Receipt upload is best-effort: if Storage is unavailable the expense
      // is still saved (without a receipt) rather than failing the whole save.
      final upload = await ref
          .read(uploadReceiptUseCaseProvider)
          .call(uid, expense.id, receipt);
      upload.fold(
        (f) => CrashReporter.record(
            f, StackTrace.current, reason: 'expense.receiptUpload'),
        (url) => toSave = expense.copyWith(receiptUrl: url),
      );
    }

    final result = await ref.read(addExpenseUseCaseProvider).call(uid, toSave);
    return result.fold(
      (f) {
        state = f.message;
        return false;
      },
      (_) {
        state = null;
        return true;
      },
    );
  }

  Future<bool> updateExpense(ExpenseEntity expense, {File? receipt}) async {
    final uid = _uid;

    var toSave = expense;
    if (receipt != null) {
      final upload = await ref
          .read(uploadReceiptUseCaseProvider)
          .call(uid, expense.id, receipt);
      final failed = upload.fold((f) {
        state = f.message;
        return true;
      }, (url) {
        toSave = expense.copyWith(receiptUrl: url);
        return false;
      });
      if (failed) return false;
    }

    final result =
        await ref.read(updateExpenseUseCaseProvider).call(uid, toSave);
    return result.fold(
      (f) {
        state = f.message;
        return false;
      },
      (_) {
        state = null;
        return true;
      },
    );
  }

  Future<bool> deleteExpense(ExpenseEntity expense) async {
    final result =
        await ref.read(deleteExpenseUseCaseProvider).call(_uid, expense);
    return result.fold(
      (f) {
        state = f.message;
        return false;
      },
      (_) {
        state = null;
        return true;
      },
    );
  }
}
