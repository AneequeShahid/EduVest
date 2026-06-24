import '../repositories/settings_repository.dart';

class ChangePasswordUseCase {
  final SettingsRepository repository;
  const ChangePasswordUseCase(this.repository);

  Future<void> call(String currentPassword, String newPassword) =>
      repository.changePassword(currentPassword, newPassword);
}
