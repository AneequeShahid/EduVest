import 'package:eduvest_output/features/settings/data/repositories/settings_repository_impl.dart';
import 'package:eduvest_output/features/settings/data/sources/settings_remote_source.dart';
import 'package:eduvest_output/features/settings/domain/entities/settings_entity.dart';
import 'package:eduvest_output/features/settings/domain/usecases/change_password_usecase.dart';
import 'package:eduvest_output/features/settings/domain/usecases/get_settings_usecase.dart';
import 'package:eduvest_output/features/settings/domain/usecases/update_profile_usecase.dart';
import 'package:eduvest_output/features/settings/presentation/providers/settings_provider.dart';
import 'package:fake_cloud_firestore/fake_cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_test/flutter_test.dart';

void main() {
  TestWidgetsFlutterBinding.ensureInitialized();

  const channel =
      MethodChannel('plugins.it_nomads.com/flutter_secure_storage');
  late Map<String, String> secureStore;

  setUp(() {
    secureStore = {};
    TestDefaultBinaryMessengerBinding.instance.defaultBinaryMessenger
        .setMockMethodCallHandler(channel, (call) async {
      final args = (call.arguments as Map?) ?? {};
      final key = args['key'] as String?;
      switch (call.method) {
        case 'write':
          secureStore[key!] = args['value'] as String;
          return null;
        case 'read':
          return secureStore[key];
        case 'delete':
          secureStore.remove(key);
          return null;
        case 'readAll':
          return Map<String, String>.from(secureStore);
        case 'containsKey':
          return secureStore.containsKey(key);
        default:
          return null;
      }
    });
  });

  tearDown(() {
    TestDefaultBinaryMessengerBinding.instance.defaultBinaryMessenger
        .setMockMethodCallHandler(channel, null);
  });

  SettingsNotifier build(FakeFirebaseFirestore firestore) {
    final source = SettingsRemoteSource(uid: 'u1', db: firestore);
    final repo = SettingsRepositoryImpl(source);
    return SettingsNotifier(
      GetSettingsUseCase(repo),
      UpdateProfileUseCase(repo),
      ChangePasswordUseCase(repo),
      source,
    );
  }

  test('1. load fetches settings into state', () async {
    final firestore = FakeFirebaseFirestore();
    final source = SettingsRemoteSource(uid: 'u1', db: firestore);
    await source.saveSettings(const SettingsEntity(
      budgetAlerts: false,
      goalAchievements: true,
      marketingEmails: true,
      selectedTheme: 1,
    ));

    final notifier = build(firestore);
    await notifier.load();

    expect(notifier.state.isLoading, isFalse);
    expect(notifier.state.settings.budgetAlerts, isFalse);
    expect(notifier.state.settings.marketingEmails, isTrue);
    expect(notifier.state.settings.selectedTheme, 1);
  });

  test('2. update persists settings and reflects them in state', () async {
    final firestore = FakeFirebaseFirestore();
    final notifier = build(firestore);

    await notifier.update(const SettingsEntity(
      budgetAlerts: true,
      goalAchievements: false,
      marketingEmails: false,
      selectedTheme: 0,
    ));

    expect(notifier.state.settings.goalAchievements, isFalse);
    final saved = await SettingsRemoteSource(uid: 'u1', db: firestore)
        .getSettings();
    expect(saved.goalAchievements, isFalse);
  });

  test('3. updateNotificationPreferences merges and persists', () async {
    final firestore = FakeFirebaseFirestore();
    final notifier = build(firestore);
    await notifier.load();

    await notifier.updateNotificationPreferences({'marketingEmails': true});

    expect(notifier.state.settings.marketingEmails, isTrue);
    // unchanged keys remain at their defaults
    expect(notifier.state.settings.budgetAlerts, isTrue);
    final saved = await SettingsRemoteSource(uid: 'u1', db: firestore)
        .getSettings();
    expect(saved.marketingEmails, isTrue);
  });

  test('4. updateTheme maps dark to index 1 and light to 0', () async {
    final firestore = FakeFirebaseFirestore();
    final notifier = build(firestore);

    await notifier.updateTheme(ThemeMode.dark);
    expect(notifier.state.settings.selectedTheme, 1);

    await notifier.updateTheme(ThemeMode.light);
    expect(notifier.state.settings.selectedTheme, 0);
  });

  test('5. toggleBiometric persists to secure storage and state', () async {
    final firestore = FakeFirebaseFirestore();
    final notifier = build(firestore);

    await notifier.toggleBiometric(true);

    expect(notifier.state.settings.biometricEnabled, isTrue);
    expect(secureStore[kBiometricEnabledKey], 'true');

    await notifier.toggleBiometric(false);
    expect(notifier.state.settings.biometricEnabled, isFalse);
    expect(secureStore[kBiometricEnabledKey], 'false');
  });

  test('6. load surfaces the biometric flag from secure storage', () async {
    secureStore[kBiometricEnabledKey] = 'true';
    final firestore = FakeFirebaseFirestore();
    final notifier = build(firestore);

    await notifier.load();

    expect(notifier.state.settings.biometricEnabled, isTrue);
  });
}
