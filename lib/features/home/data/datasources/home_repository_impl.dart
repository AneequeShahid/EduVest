// Legacy datasource impl — superseded by features/home/data/repositories/
import '../datasources/home_firebase_datasource.dart';

class HomeRepositoryLegacyImpl {
  final HomeFirebaseDataSource dataSource;
  HomeRepositoryLegacyImpl(this.dataSource);
}
