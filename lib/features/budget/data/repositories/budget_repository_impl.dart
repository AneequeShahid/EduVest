import 'package:dartz/dartz.dart';

import '../../../../core/errors/failures.dart';
import '../../domain/entities/budget_category_entity.dart';
import '../../domain/entities/budget_entity.dart';
import '../../domain/repositories/budget_repository.dart';
import '../sources/budget_remote_source.dart';

class BudgetRepositoryImpl implements BudgetRepository {
  final BudgetRemoteSource _source;

  BudgetRepositoryImpl(this._source);

  @override
  Stream<BudgetEntity?> watchBudget(String uid, int month, int year) =>
      _source.watchBudget(uid, month, year);

  @override
  Future<BudgetEntity?> getBudget(String uid, int month, int year) =>
      _source.getBudget(uid, month, year);

  @override
  Future<Map<String, double>> getThreeMonthAverageByCategory(
          String uid, int month, int year) =>
      _source.getThreeMonthAverageByCategory(uid, month, year);

  @override
  Future<Either<Failure, void>> setMonthlyLimit(
          String uid, int month, int year, double limit) =>
      _guard(() => _source.setMonthlyLimit(uid, month, year, limit));

  @override
  Future<Either<Failure, void>> addCategory(
          String uid, int month, int year, BudgetCategoryEntity category) =>
      _guard(() => _source.addCategory(uid, month, year, category));

  @override
  Future<Either<Failure, void>> updateCategory(
          String uid, int month, int year, BudgetCategoryEntity category) =>
      _guard(() => _source.updateCategory(uid, month, year, category));

  @override
  Future<Either<Failure, void>> deleteCategory(
          String uid, int month, int year, String categoryId) =>
      _guard(() => _source.deleteCategory(uid, month, year, categoryId));

  @override
  Future<Either<Failure, void>> markAsPaid(String uid, int month, int year,
          String categoryId, bool isPaid) =>
      _guard(() => _source.markAsPaid(uid, month, year, categoryId, isPaid));

  Future<Either<Failure, void>> _guard(Future<void> Function() action) async {
    try {
      await action();
      return const Right(null);
    } catch (e) {
      return Left(ServerFailure(e.toString()));
    }
  }
}
