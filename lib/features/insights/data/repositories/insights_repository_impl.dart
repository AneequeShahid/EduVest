import '../../domain/entities/insights_raw_data.dart';
import '../../domain/repositories/insights_repository.dart';
import '../sources/insights_remote_source.dart';

class InsightsRepositoryImpl implements InsightsRepository {
  final InsightsRemoteSource _source;

  InsightsRepositoryImpl(this._source);

  @override
  Future<InsightsRawData> getRawData(String uid, int month, int year) =>
      _source.getRawData(uid, month, year);
}
