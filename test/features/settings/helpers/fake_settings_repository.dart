import 'package:eduvest_output/features/settings/domain/entities/settings_entity.dart';
import 'package:eduvest_output/features/settings/domain/repositories/settings_repository.dart';

/// Hand-written in-memory [SettingsRepository] for unit tests. Records the
/// arguments of the most recent call so tests can assert on them.
class FakeSettingsRepository implements SettingsRepository {
  SettingsEntity stored = const SettingsEntity(
    budgetAlerts: true,
    goalAchievements: true,
    marketingEmails: false,
    selectedTheme: 0,
  );

  String? lastDisplayName;
  String? lastPhotoUrl;
  String? lastCurrentPassword;
  String? lastNewPassword;
  Object? throwOn;

  @override
  Future<SettingsEntity> getSettings() async {
    if (throwOn == #getSettings) throw Exception('load failed');
    return stored;
  }

  @override
  Future<void> saveSettings(SettingsEntity settings) async {
    if (throwOn == #saveSettings) throw Exception('save failed');
    stored = settings;
  }

  @override
  Future<void> updateProfile({String? displayName, String? photoUrl}) async {
    lastDisplayName = displayName;
    lastPhotoUrl = photoUrl;
  }

  @override
  Future<void> changePassword(
      String currentPassword, String newPassword) async {
    if (throwOn == #changePassword) throw Exception('reauth failed');
    lastCurrentPassword = currentPassword;
    lastNewPassword = newPassword;
  }
}
