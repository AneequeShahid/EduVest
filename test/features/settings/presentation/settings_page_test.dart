import 'package:eduvest_output/features/authentication/domain/entities/user_entity.dart';
import 'package:eduvest_output/features/authentication/presentation/providers/auth_provider.dart';
import 'package:eduvest_output/features/settings/data/repositories/settings_repository_impl.dart';
import 'package:eduvest_output/features/settings/data/sources/settings_remote_source.dart';
import 'package:eduvest_output/features/settings/domain/usecases/change_password_usecase.dart';
import 'package:eduvest_output/features/settings/domain/usecases/get_settings_usecase.dart';
import 'package:eduvest_output/features/settings/domain/usecases/update_profile_usecase.dart';
import 'package:eduvest_output/features/settings/presentation/pages/settings_page.dart';
import 'package:eduvest_output/features/settings/presentation/providers/settings_provider.dart';
import 'package:fake_cloud_firestore/fake_cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:go_router/go_router.dart';
import 'package:google_fonts/google_fonts.dart';

void main() {
  setUpAll(() => GoogleFonts.config.allowRuntimeFetching = false);

  const channel =
      MethodChannel('plugins.it_nomads.com/flutter_secure_storage');
  late Map<String, String> secureStore;
  late FakeFirebaseFirestore firestore;

  final testUser = UserEntity(
    id: 'u1',
    email: 'student@eduvest.app',
    name: 'Alex Sterling',
    memberSince: DateTime(2024, 1, 1),
  );

  setUp(() {
    secureStore = {};
    firestore = FakeFirebaseFirestore();
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
        case 'readAll':
          return Map<String, String>.from(secureStore);
        default:
          return null;
      }
    });
  });

  tearDown(() {
    TestDefaultBinaryMessengerBinding.instance.defaultBinaryMessenger
        .setMockMethodCallHandler(channel, null);
  });

  SettingsNotifier buildNotifier() {
    final source = SettingsRemoteSource(uid: 'u1', db: firestore);
    final repo = SettingsRepositoryImpl(source);
    return SettingsNotifier(
      GetSettingsUseCase(repo),
      UpdateProfileUseCase(repo),
      ChangePasswordUseCase(repo),
      source,
    );
  }

  Future<void> pump(WidgetTester tester) async {
    tester.view.physicalSize = const Size(1200, 3200);
    tester.view.devicePixelRatio = 1.0;
    addTearDown(tester.view.reset);

    final router = GoRouter(
      initialLocation: '/settings',
      routes: [
        GoRoute(path: '/settings', builder: (_, __) => const SettingsPage()),
        GoRoute(
            path: '/settings/change-password',
            builder: (_, __) =>
                const Scaffold(body: Text('CHANGE PASSWORD PAGE'))),
        GoRoute(
            path: '/settings/edit-profile',
            builder: (_, __) => const Scaffold(body: Text('EDIT PROFILE'))),
        GoRoute(path: '/login', builder: (_, __) => const Scaffold(body: Text('LOGIN'))),
      ],
    );

    await tester.pumpWidget(
      ProviderScope(
        overrides: [
          authStateProvider
              .overrideWith((ref) => Stream<UserEntity?>.value(testUser)),
          settingsProvider.overrideWith((ref) => buildNotifier()),
        ],
        child: MaterialApp.router(routerConfig: router),
      ),
    );
    await tester.pumpAndSettle();
  }

  testWidgets('1. shows profile name, email and PREMIUM badge',
      (tester) async {
    await pump(tester);
    expect(find.text('Alex Sterling'), findsOneWidget);
    expect(find.text('student@eduvest.app'), findsOneWidget);
    expect(find.text('PREMIUM'), findsOneWidget);
  });

  testWidgets('2. renders all notification switches', (tester) async {
    await pump(tester);
    expect(find.text('Budget Alerts'), findsOneWidget);
    expect(find.text('Goal Achievements'), findsOneWidget);
    expect(find.text('Marketing Emails'), findsOneWidget);
  });

  testWidgets('3. renders Security & Privacy section', (tester) async {
    await pump(tester);
    expect(find.text('Security & Privacy'), findsOneWidget);
    expect(find.text('Change Password'), findsOneWidget);
    expect(find.text('Biometric Unlock'), findsOneWidget);
    expect(find.text('Privacy Center'), findsOneWidget);
  });

  testWidgets('4. shows Appearance section and app version', (tester) async {
    await pump(tester);
    expect(find.text('Appearance'), findsOneWidget);
    expect(find.textContaining('Version 1.0.0'), findsOneWidget);
  });

  testWidgets('5. tapping Change Password navigates to that page',
      (tester) async {
    await pump(tester);
    await tester.tap(find.text('Change Password'));
    await tester.pumpAndSettle();
    expect(find.text('CHANGE PASSWORD PAGE'), findsOneWidget);
  });

  testWidgets('6. toggling Marketing Emails persists the preference',
      (tester) async {
    await pump(tester);

    final marketingSwitch = find.descendant(
      of: find.ancestor(
        of: find.text('Marketing Emails'),
        matching: find.byType(Row),
      ),
      matching: find.byType(Switch),
    );
    await tester.tap(marketingSwitch.first);
    await tester.pumpAndSettle();

    final saved =
        await SettingsRemoteSource(uid: 'u1', db: firestore).getSettings();
    expect(saved.marketingEmails, isTrue);
  });

  testWidgets('7. toggling Biometric writes to secure storage',
      (tester) async {
    await pump(tester);

    final bioSwitch = find.descendant(
      of: find.ancestor(
        of: find.text('Biometric Unlock'),
        matching: find.byType(Row),
      ),
      matching: find.byType(Switch),
    );
    await tester.tap(bioSwitch.first);
    await tester.pumpAndSettle();

    expect(secureStore[kBiometricEnabledKey], 'true');
  });
}
