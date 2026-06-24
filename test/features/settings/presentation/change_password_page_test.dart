import 'package:eduvest_output/features/settings/data/repositories/settings_repository_impl.dart';
import 'package:eduvest_output/features/settings/data/sources/settings_remote_source.dart';
import 'package:eduvest_output/features/settings/domain/usecases/change_password_usecase.dart';
import 'package:eduvest_output/features/settings/domain/usecases/get_settings_usecase.dart';
import 'package:eduvest_output/features/settings/domain/usecases/update_profile_usecase.dart';
import 'package:eduvest_output/features/settings/presentation/pages/change_password_page.dart';
import 'package:eduvest_output/features/settings/presentation/providers/settings_provider.dart';
import 'package:fake_cloud_firestore/fake_cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:google_fonts/google_fonts.dart';

void main() {
  setUpAll(() => GoogleFonts.config.allowRuntimeFetching = false);

  SettingsNotifier buildNotifier() {
    final source = SettingsRemoteSource(uid: 'u1', db: FakeFirebaseFirestore());
    final repo = SettingsRepositoryImpl(source);
    return SettingsNotifier(
      GetSettingsUseCase(repo),
      UpdateProfileUseCase(repo),
      ChangePasswordUseCase(repo),
      source,
    );
  }

  Future<void> pump(WidgetTester tester) async {
    tester.view.physicalSize = const Size(1200, 2400);
    tester.view.devicePixelRatio = 1.0;
    addTearDown(tester.view.reset);

    await tester.pumpWidget(
      ProviderScope(
        overrides: [
          settingsProvider.overrideWith((ref) => buildNotifier()),
        ],
        child: const MaterialApp(home: ChangePasswordPage()),
      ),
    );
    await tester.pumpAndSettle();
  }

  testWidgets('1. renders the three password fields', (tester) async {
    await pump(tester);
    expect(find.byKey(const Key('current-password-field')), findsOneWidget);
    expect(find.byKey(const Key('new-password-field')), findsOneWidget);
    expect(find.byKey(const Key('confirm-password-field')), findsOneWidget);
  });

  testWidgets('2. shows validation errors on empty submit', (tester) async {
    await pump(tester);
    await tester.tap(find.text('Update Password'));
    await tester.pumpAndSettle();

    expect(find.text('Current password is required'), findsOneWidget);
  });

  testWidgets('3. flags a confirm-password mismatch', (tester) async {
    await pump(tester);
    await tester.enterText(
        find.byKey(const Key('current-password-field')), 'oldpass1');
    await tester.enterText(
        find.byKey(const Key('new-password-field')), 'newpass1');
    await tester.enterText(
        find.byKey(const Key('confirm-password-field')), 'different2');
    await tester.tap(find.text('Update Password'));
    await tester.pumpAndSettle();

    expect(find.text('Passwords do not match'), findsOneWidget);
  });
}
