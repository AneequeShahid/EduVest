import 'package:eduvest_output/features/settings/data/sources/settings_remote_source.dart';
import 'package:eduvest_output/features/settings/domain/entities/settings_entity.dart';
import 'package:fake_cloud_firestore/fake_cloud_firestore.dart';
import 'package:flutter_test/flutter_test.dart';

void main() {
  const uid = 'uid-1';
  late FakeFirebaseFirestore firestore;
  late SettingsRemoteSource source;

  setUp(() {
    firestore = FakeFirebaseFirestore();
    source = SettingsRemoteSource(uid: uid, db: firestore);
  });

  test('1. getSettings returns defaults when no document exists', () async {
    final s = await source.getSettings();
    expect(s.budgetAlerts, isTrue);
    expect(s.goalAchievements, isTrue);
    expect(s.marketingEmails, isFalse);
    expect(s.selectedTheme, 0);
  });

  test('2. saveSettings persists to users/{uid}/settings/prefs', () async {
    const entity = SettingsEntity(
      budgetAlerts: false,
      goalAchievements: true,
      marketingEmails: true,
      selectedTheme: 1,
      biometricEnabled: true,
    );

    await source.saveSettings(entity);

    final doc = await firestore
        .collection('users')
        .doc(uid)
        .collection('settings')
        .doc('prefs')
        .get();
    expect(doc.exists, isTrue);
    final data = doc.data()!;
    expect(data['budgetAlerts'], false);
    expect(data['marketingEmails'], true);
    expect(data['selectedTheme'], 1);
    expect(data['biometricEnabled'], true);
  });

  test('3. getSettings reads back what was saved', () async {
    const entity = SettingsEntity(
      budgetAlerts: false,
      goalAchievements: false,
      marketingEmails: true,
      selectedTheme: 1,
    );
    await source.saveSettings(entity);

    final loaded = await source.getSettings();
    expect(loaded.budgetAlerts, isFalse);
    expect(loaded.goalAchievements, isFalse);
    expect(loaded.marketingEmails, isTrue);
    expect(loaded.selectedTheme, 1);
  });
}
