// Legacy datasource impl — superseded by features/settings/data/repositories/
import '../datasources/settings_firebase_datasource.dart';

class SettingsRepositoryLegacyImpl {
  final SettingsFirebaseDataSource dataSource;
  SettingsRepositoryLegacyImpl(this.dataSource);
}
