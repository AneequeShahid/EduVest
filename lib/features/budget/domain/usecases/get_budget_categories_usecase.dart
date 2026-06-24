import '../entities/budget_category_entity.dart';
import '../repositories/budget_repository.dart';

class GetBudgetCategoriesUseCase {
  final BudgetRepository repository;
  const GetBudgetCategoriesUseCase(this.repository);

  Future<List<BudgetCategoryEntity>> call(
      String uid, int month, int year) async {
    final budget = await repository.getBudget(uid, month, year);
    return budget?.categories ?? const [];
  }
}
