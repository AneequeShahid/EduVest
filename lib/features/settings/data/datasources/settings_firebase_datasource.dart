import 'package:cloud_firestore/cloud_firestore.dart';
import '../../../../core/errors/exceptions.dart';
import '../../domain/entities/user_settings.dart';

/// Replaces SettingsLocalDataSource.
class SettingsFirebaseDataSource {
  final String uid;
  final FirebaseFirestore _firestore;

  SettingsFirebaseDataSource({
    required this.uid,
    FirebaseFirestore? firestore,
  }) : _firestore = firestore ?? FirebaseFirestore.instance;

  DocumentReference<Map<String, dynamic>> get _doc =>
      _firestore.collection('users').doc(uid).collection('settings').doc('preferences');

  /// Fetches settings from users/{uid}/settings/preferences.
  Future<UserSettings> getSettings() async {
    try {
      final snapshot = await _doc.get();
      if (!snapshot.exists || snapshot.data() == null) {
        return const UserSettings(
          budgetAlerts: true,
          goalAchievements: true,
          marketingEmails: false,
          selectedTheme: 0,
        );
      }
      final data = snapshot.data()!;
      
      // Parse nested notifications if present, otherwise fallback to root fields
      final notifications = data['notifications'] as Map?;
      final budgetAlerts = notifications?['budgetAlerts'] as bool? ?? data['budgetAlerts'] as bool? ?? true;
      final goalAchievements = notifications?['goalAchievements'] as bool? ?? data['goalAchievements'] as bool? ?? true;
      final marketingEmails = notifications?['marketingEmails'] as bool? ?? data['marketingEmails'] as bool? ?? false;
      
      // Parse theme if present (can be string or int)
      final themeRaw = data['theme'] ?? data['selectedTheme'];
      int selectedTheme = 0;
      if (themeRaw is int) {
        selectedTheme = themeRaw;
      } else if (themeRaw is String) {
        selectedTheme = int.tryParse(themeRaw) ?? 0;
      }

      return UserSettings(
        budgetAlerts: budgetAlerts,
        goalAchievements: goalAchievements,
        marketingEmails: marketingEmails,
        selectedTheme: selectedTheme,
      );
    } catch (e) {
      throw SettingsException('Failed to fetch settings from Firestore: $e');
    }
  }

  /// Writes settings to users/{uid}/settings/preferences using merge: true.
  Future<void> saveSettings(UserSettings settings) async {
    try {
      await _doc.set(
        {
          'currency': 'USD',
          'language': 'en',
          'theme': settings.selectedTheme,
          'notifications': {
            'budgetAlerts': settings.budgetAlerts,
            'goalAchievements': settings.goalAchievements,
            'marketingEmails': settings.marketingEmails,
          },
          // Keep root fields for direct backward compatibility
          'budgetAlerts': settings.budgetAlerts,
          'goalAchievements': settings.goalAchievements,
          'marketingEmails': settings.marketingEmails,
          'selectedTheme': settings.selectedTheme,
        },
        SetOptions(merge: true),
      );
    } catch (e) {
      throw SettingsException('Failed to save settings to Firestore: $e');
    }
  }
}
