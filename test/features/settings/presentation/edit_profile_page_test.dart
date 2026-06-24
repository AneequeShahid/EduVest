import 'package:eduvest_output/features/settings/data/repositories/settings_repository_impl.dart';
import 'package:eduvest_output/features/settings/data/sources/settings_remote_source.dart';
import 'package:eduvest_output/features/settings/domain/usecases/change_password_usecase.dart';
import 'package:eduvest_output/features/settings/domain/usecases/get_settings_usecase.dart';
import 'package:eduvest_output/features/settings/domain/usecases/update_profile_usecase.dart';
import 'package:eduvest_output/features/settings/presentation/pages/edit_profile_page.dart';
import 'package:eduvest_output/features/settings/presentation/providers/settings_provider.dart';
import 'package:fake_cloud_firestore/fake_cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:go_router/go_router.dart';
import 'package:google_fonts/google_fonts.dart';

void main() {
  setUpAll(() => GoogleFonts.config.allowRuntimeFetching = false);

  SettingsNotifier buildNotifier(FakeFirebaseFirestore firestore) {
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
    tester.view.physicalSize = const Size(1200, 2200);
    tester.view.devicePixelRatio = 1.0;
    addTearDown(tester.view.reset);

    final firestore = FakeFirebaseFirestore();
    final router = GoRouter(
      initialLocation: '/settings/edit-profile',
      routes: [
        GoRoute(
            path: '/settings/edit-profile',
            builder: (_, __) => const EditProfilePage()),
        GoRoute(
            path: '/settings',
            builder: (_, __) => const Scaffold(body: Text('SETTINGS'))),
      ],
    );

    await tester.pumpWidget(
      ProviderScope(
        overrides: [
          settingsProvider.overrideWith((ref) => buildNotifier(firestore)),
        ],
        child: MaterialApp.router(routerConfig: router),
      ),
    );
    await tester.pumpAndSettle();
  }

  testWidgets('1. renders the name field and save button', (tester) async {
    await pump(tester);
    expect(find.text('Full Name'), findsOneWidget);
    expect(find.widgetWithText(ElevatedButton, 'Save Changes'),
        findsOneWidget);
  });

  testWidgets('2. rejects an empty name', (tester) async {
    await pump(tester);
    await tester.enterText(find.byType(TextFormField), '   ');
    await tester.tap(find.text('Save Changes'));
    await tester.pump();
    expect(find.textContaining('required'), findsOneWidget);
  });

  testWidgets('3. accepts text entry in the name field', (tester) async {
    await pump(tester);
    await tester.enterText(find.byType(TextFormField), 'Jordan Blake');
    await tester.pump();
    expect(find.text('Jordan Blake'), findsOneWidget);
  });
}
