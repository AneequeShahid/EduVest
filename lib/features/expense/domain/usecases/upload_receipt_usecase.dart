import 'dart:io';

import 'package:dartz/dartz.dart';

import '../../../../core/errors/failures.dart';
import '../repositories/expense_repository.dart';

class UploadReceiptUseCase {
  final ExpenseRepository repository;
  const UploadReceiptUseCase(this.repository);

  /// Maximum accepted receipt size after the picker's quality compression.
  static const int maxBytes = 2 * 1024 * 1024; // 2 MB

  Future<Either<Failure, String>> call(
      String uid, String expenseId, File file) async {
    final length = await file.length();
    if (length > maxBytes) {
      return const Left(
          ValidationFailure('Receipt is too large (max 2 MB).'));
    }
    return repository.uploadReceipt(uid, expenseId, file);
  }
}
