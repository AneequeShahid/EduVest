import '../../../../core/utils/sanitizer.dart';
import '../repositories/settings_repository.dart';

class UpdateProfileUseCase {
  final SettingsRepository repository;
  const UpdateProfileUseCase(this.repository);

  Future<void> call({String? displayName, String? photoUrl}) {
    final cleanName =
        displayName == null ? null : Sanitizer.name(displayName);
    return repository.updateProfile(
        displayName: cleanName, photoUrl: photoUrl);
  }
}
