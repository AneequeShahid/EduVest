class SettingsEntity {
  final bool budgetAlerts;
  final bool goalAchievements;
  final bool marketingEmails;
  final int selectedTheme;
  final bool biometricEnabled;
  final String? displayName;
  final String? photoUrl;

  const SettingsEntity({
    required this.budgetAlerts,
    required this.goalAchievements,
    required this.marketingEmails,
    required this.selectedTheme,
    this.biometricEnabled = false,
    this.displayName,
    this.photoUrl,
  });

  SettingsEntity copyWith({
    bool? budgetAlerts,
    bool? goalAchievements,
    bool? marketingEmails,
    int? selectedTheme,
    bool? biometricEnabled,
    String? displayName,
    String? photoUrl,
  }) =>
      SettingsEntity(
        budgetAlerts: budgetAlerts ?? this.budgetAlerts,
        goalAchievements: goalAchievements ?? this.goalAchievements,
        marketingEmails: marketingEmails ?? this.marketingEmails,
        selectedTheme: selectedTheme ?? this.selectedTheme,
        biometricEnabled: biometricEnabled ?? this.biometricEnabled,
        displayName: displayName ?? this.displayName,
        photoUrl: photoUrl ?? this.photoUrl,
      );
}
