import 'package:eduvest_output/features/settings/domain/entities/settings_entity.dart';
import 'package:eduvest_output/features/settings/domain/usecases/change_password_usecase.dart';
import 'package:eduvest_output/features/settings/domain/usecases/get_settings_usecase.dart';
import 'package:eduvest_output/features/settings/domain/usecases/save_settings_usecase.dart';
import 'package:eduvest_output/features/settings/domain/usecases/update_profile_usecase.dart';
import 'package:flutter_test/flutter_test.dart';

import '../helpers/fake_settings_repository.dart';

void main() {
  late FakeSettingsRepository repo;

  setUp(() => repo = FakeSettingsRepository());

  test('1. GetSettingsUseCase returns the stored settings', () async {
    repo.stored = repo.stored.copyWith(selectedTheme: 1);
    final result = await GetSettingsUseCase(repo)();
    expect(result.selectedTheme, 1);
  });

  test('2. SaveSettingsUseCase forwards to the repository', () async {
    const entity = SettingsEntity(
      budgetAlerts: false,
      goalAchievements: true,
      marketingEmails: true,
      selectedTheme: 1,
    );
    await SaveSettingsUseCase(repo)(entity);
    expect(repo.stored.budgetAlerts, isFalse);
    expect(repo.stored.marketingEmails, isTrue);
  });

  test('3. UpdateProfileUseCase sanitizes the display name', () async {
    await UpdateProfileUseCase(repo)(displayName: '  <b>Jane  Doe</b> ');
    expect(repo.lastDisplayName, 'Jane Doe');
  });

  test('4. UpdateProfileUseCase clamps the name to 50 chars', () async {
    await UpdateProfileUseCase(repo)(displayName: 'n' * 80);
    expect(repo.lastDisplayName!.length, 50);
  });

  test('5. UpdateProfileUseCase passes a null name through untouched', () async {
    await UpdateProfileUseCase(repo)(photoUrl: 'http://x/y.png');
    expect(repo.lastDisplayName, isNull);
    expect(repo.lastPhotoUrl, 'http://x/y.png');
  });

  test('6. ChangePasswordUseCase forwards current and new password', () async {
    await ChangePasswordUseCase(repo)('oldPass1', 'newPass2');
    expect(repo.lastCurrentPassword, 'oldPass1');
    expect(repo.lastNewPassword, 'newPass2');
  });
}
