import '../../domain/entities/settings_entity.dart';
import '../../domain/repositories/settings_repository.dart';
import '../sources/settings_remote_source.dart';

class SettingsRepositoryImpl implements SettingsRepository {
  final SettingsRemoteSource _source;

  SettingsRepositoryImpl(this._source);

  @override
  Future<SettingsEntity> getSettings() => _source.getSettings();

  @override
  Future<void> saveSettings(SettingsEntity settings) =>
      _source.saveSettings(settings);

  @override
  Future<void> updateProfile({String? displayName, String? photoUrl}) =>
      _source.updateProfile(
          displayName: displayName, photoUrl: photoUrl);

  @override
  Future<void> changePassword(String currentPassword, String newPassword) =>
      _source.changePassword(currentPassword, newPassword);
}
