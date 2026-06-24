import '../entities/settings_entity.dart';

abstract class SettingsRepository {
  Future<SettingsEntity> getSettings();
  Future<void> saveSettings(SettingsEntity settings);
  Future<void> updateProfile({String? displayName, String? photoUrl});
  Future<void> changePassword(String currentPassword, String newPassword);
}
