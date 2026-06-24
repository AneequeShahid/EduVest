import '../../domain/entities/settings_entity.dart';

class SettingsModel extends SettingsEntity {
  const SettingsModel({
    required super.budgetAlerts,
    required super.goalAchievements,
    required super.marketingEmails,
    required super.selectedTheme,
    super.biometricEnabled,
    super.displayName,
    super.photoUrl,
  });

  factory SettingsModel.fromJson(Map<String, dynamic> json) => SettingsModel(
        budgetAlerts: json['budgetAlerts'] as bool? ?? true,
        goalAchievements: json['goalAchievements'] as bool? ?? true,
        marketingEmails: json['marketingEmails'] as bool? ?? false,
        selectedTheme: json['selectedTheme'] as int? ?? 0,
        biometricEnabled: json['biometricEnabled'] as bool? ?? false,
        displayName: json['displayName'] as String?,
        photoUrl: json['photoUrl'] as String?,
      );

  factory SettingsModel.fromEntity(SettingsEntity e) => SettingsModel(
        budgetAlerts: e.budgetAlerts,
        goalAchievements: e.goalAchievements,
        marketingEmails: e.marketingEmails,
        selectedTheme: e.selectedTheme,
        biometricEnabled: e.biometricEnabled,
        displayName: e.displayName,
        photoUrl: e.photoUrl,
      );

  Map<String, dynamic> toJson() => {
        'budgetAlerts': budgetAlerts,
        'goalAchievements': goalAchievements,
        'marketingEmails': marketingEmails,
        'selectedTheme': selectedTheme,
        'biometricEnabled': biometricEnabled,
        if (displayName != null) 'displayName': displayName,
        if (photoUrl != null) 'photoUrl': photoUrl,
      };
}
