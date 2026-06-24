import 'dart:io';

import 'package:dartz/dartz.dart';

import '../../../../core/errors/failures.dart';
import '../entities/expense_entity.dart';

abstract class ExpenseRepository {
  /// Real-time stream of expenses, optionally filtered by [month]/[year].
  Stream<List<ExpenseEntity>> getExpensesStream(
    String uid, {
    int? month,
    int? year,
  });

  Future<Either<Failure, void>> addExpense(String uid, ExpenseEntity expense);

  Future<Either<Failure, void>> updateExpense(
      String uid, ExpenseEntity expense);

  Future<Either<Failure, void>> deleteExpense(String uid, String expenseId);

  /// Removes a receipt image from Storage (best-effort).
  Future<Either<Failure, void>> deleteReceipt(String uid, String expenseId);

  /// Uploads a receipt image and returns its download URL.
  Future<Either<Failure, String>> uploadReceipt(
      String uid, String expenseId, File file);
}
