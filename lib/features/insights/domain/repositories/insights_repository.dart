import '../entities/insights_raw_data.dart';

abstract class InsightsRepository {
  /// Gathers raw, read-only data from expense/budget/goals for the given month.
  Future<InsightsRawData> getRawData(String uid, int month, int year);
}
