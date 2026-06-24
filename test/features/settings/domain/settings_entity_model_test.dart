import 'package:eduvest_output/features/settings/data/models/settings_model.dart';
import 'package:eduvest_output/features/settings/domain/entities/settings_entity.dart';
import 'package:flutter_test/flutter_test.dart';

void main() {
  group('SettingsEntity', () {
    const base = SettingsEntity(
      budgetAlerts: true,
      goalAchievements: true,
      marketingEmails: false,
      selectedTheme: 0,
    );

    test('1. defaults biometricEnabled to false', () {
      expect(base.biometricEnabled, isFalse);
    });

    test('2. copyWith overrides only the supplied fields', () {
      final updated = base.copyWith(
          marketingEmails: true, selectedTheme: 1, biometricEnabled: true);
      expect(updated.marketingEmails, isTrue);
      expect(updated.selectedTheme, 1);
      expect(updated.biometricEnabled, isTrue);
      expect(updated.budgetAlerts, isTrue);
    });
  });

  group('SettingsModel', () {
    test('3. round-trips through JSON', () {
      const model = SettingsModel(
        budgetAlerts: false,
        goalAchievements: true,
        marketingEmails: true,
        selectedTheme: 1,
        biometricEnabled: true,
        displayName: 'Jane',
        photoUrl: 'http://x/y.png',
      );

      final json = model.toJson();
      final decoded = SettingsModel.fromJson(json);

      expect(decoded.budgetAlerts, isFalse);
      expect(decoded.goalAchievements, isTrue);
      expect(decoded.marketingEmails, isTrue);
      expect(decoded.selectedTheme, 1);
      expect(decoded.biometricEnabled, isTrue);
      expect(decoded.displayName, 'Jane');
      expect(decoded.photoUrl, 'http://x/y.png');
    });

    test('4. fromJson applies defaults for missing keys', () {
      final decoded = SettingsModel.fromJson(const {});
      expect(decoded.budgetAlerts, isTrue);
      expect(decoded.goalAchievements, isTrue);
      expect(decoded.marketingEmails, isFalse);
      expect(decoded.selectedTheme, 0);
      expect(decoded.biometricEnabled, isFalse);
      expect(decoded.displayName, isNull);
    });

    test('5. fromEntity copies all fields', () {
      const entity = SettingsEntity(
        budgetAlerts: false,
        goalAchievements: false,
        marketingEmails: true,
        selectedTheme: 1,
        biometricEnabled: true,
      );
      final model = SettingsModel.fromEntity(entity);
      expect(model.budgetAlerts, isFalse);
      expect(model.goalAchievements, isFalse);
      expect(model.marketingEmails, isTrue);
      expect(model.biometricEnabled, isTrue);
    });

    test('6. toJson omits null name/photo', () {
      const model = SettingsModel(
        budgetAlerts: true,
        goalAchievements: true,
        marketingEmails: false,
        selectedTheme: 0,
      );
      final json = model.toJson();
      expect(json.containsKey('displayName'), isFalse);
      expect(json.containsKey('photoUrl'), isFalse);
      expect(json['biometricEnabled'], isFalse);
    });
  });
}
