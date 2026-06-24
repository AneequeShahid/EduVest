import 'package:dartz/dartz.dart';

import '../../../../core/errors/failures.dart';
import '../entities/budget_category_entity.dart';
import '../entities/budget_entity.dart';

abstract class BudgetRepository {
  /// Real-time budget for [month]/[year] with spending computed from expenses.
  /// Emits null when no budget has been set for that month.
  Stream<BudgetEntity?> watchBudget(String uid, int month, int year);

  /// One-shot equivalent of [watchBudget].
  Future<BudgetEntity?> getBudget(String uid, int month, int year);

  Future<Either<Failure, void>> setMonthlyLimit(
      String uid, int month, int year, double limit);

  Future<Either<Failure, void>> addCategory(
      String uid, int month, int year, BudgetCategoryEntity category);

  Future<Either<Failure, void>> updateCategory(
      String uid, int month, int year, BudgetCategoryEntity category);

  Future<Either<Failure, void>> deleteCategory(
      String uid, int month, int year, String categoryId);

  Future<Either<Failure, void>> markAsPaid(
      String uid, int month, int year, String categoryId, bool isPaid);

  /// Average monthly spend per category over the previous 3 months.
  Future<Map<String, double>> getThreeMonthAverageByCategory(
      String uid, int month, int year);
}
