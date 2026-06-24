class UserSettings {
  final bool budgetAlerts;
  final bool goalAchievements;
  final bool marketingEmails;
  final int selectedTheme;

  const UserSettings({
    required this.budgetAlerts,
    required this.goalAchievements,
    required this.marketingEmails,
    required this.selectedTheme,
  });

  UserSettings copyWith({
    bool? budgetAlerts,
    bool? goalAchievements,
    bool? marketingEmails,
    int? selectedTheme,
  }) {
    return UserSettings(
      budgetAlerts: budgetAlerts ?? this.budgetAlerts,
      goalAchievements: goalAchievements ?? this.goalAchievements,
      marketingEmails: marketingEmails ?? this.marketingEmails,
      selectedTheme: selectedTheme ?? this.selectedTheme,
    );
  }
}
