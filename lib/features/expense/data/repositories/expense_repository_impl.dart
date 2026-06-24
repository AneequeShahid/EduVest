import 'dart:io';

import 'package:dartz/dartz.dart';

import '../../../../core/errors/failures.dart';
import '../../domain/entities/expense_entity.dart';
import '../../domain/repositories/expense_repository.dart';
import '../sources/expense_remote_source.dart';

class ExpenseRepositoryImpl implements ExpenseRepository {
  final ExpenseRemoteSource _source;

  ExpenseRepositoryImpl(this._source);

  @override
  Stream<List<ExpenseEntity>> getExpensesStream(
    String uid, {
    int? month,
    int? year,
  }) =>
      _source.getExpensesStream(uid, month: month, year: year);

  @override
  Future<Either<Failure, void>> addExpense(
      String uid, ExpenseEntity expense) async {
    try {
      await _source.addExpense(uid, expense);
      return const Right(null);
    } catch (e) {
      return Left(ServerFailure('Failed to add expense: $e'));
    }
  }

  @override
  Future<Either<Failure, void>> updateExpense(
      String uid, ExpenseEntity expense) async {
    try {
      await _source.updateExpense(uid, expense);
      return const Right(null);
    } catch (e) {
      return Left(ServerFailure('Failed to update expense: $e'));
    }
  }

  @override
  Future<Either<Failure, void>> deleteExpense(
      String uid, String expenseId) async {
    try {
      await _source.deleteExpense(uid, expenseId);
      return const Right(null);
    } catch (e) {
      return Left(ServerFailure('Failed to delete expense: $e'));
    }
  }

  @override
  Future<Either<Failure, void>> deleteReceipt(
      String uid, String expenseId) async {
    try {
      await _source.deleteReceipt(uid, expenseId);
      return const Right(null);
    } catch (e) {
      // Receipt cleanup is best-effort.
      return Left(ServerFailure('Failed to delete receipt: $e'));
    }
  }

  @override
  Future<Either<Failure, String>> uploadReceipt(
      String uid, String expenseId, File file) async {
    try {
      final url = await _source.uploadReceipt(uid, expenseId, file);
      return Right(url);
    } catch (e) {
      return Left(ServerFailure('Failed to upload receipt: $e'));
    }
  }
}
