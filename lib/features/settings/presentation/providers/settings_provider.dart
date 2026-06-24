import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import '../../domain/entities/settings_entity.dart';
import '../../domain/usecases/get_settings_usecase.dart';
import '../../domain/usecases/update_profile_usecase.dart';
import '../../domain/usecases/change_password_usecase.dart';
import '../../data/sources/settings_remote_source.dart';
import '../../data/repositories/settings_repository_impl.dart';
import '../../../../core/services/crash_reporter.dart';
import '../../../../features/authentication/presentation/providers/auth_provider.dart';

/// Secure-storage key recording whether biometric unlock is enabled.
const String kBiometricEnabledKey = 'eduvest_biometric_enabled';

// ── DI ─────────────────────────────────────────────────────────────────────
final _settingsSourceProvider = Provider((ref) {
  final uid = ref.watch(authStateProvider).valueOrNull?.id ?? '';
  return SettingsRemoteSource(uid: uid);
});

final _settingsRepoProvider = Provider(
    (ref) => SettingsRepositoryImpl(ref.read(_settingsSourceProvider)));

final getSettingsUseCaseProvider =
    Provider((ref) => GetSettingsUseCase(ref.read(_settingsRepoProvider)));
final updateProfileUseCaseProvider =
    Provider((ref) => UpdateProfileUseCase(ref.read(_settingsRepoProvider)));
final changePasswordUseCaseProvider =
    Provider((ref) => ChangePasswordUseCase(ref.read(_settingsRepoProvider)));

// ── State ──────────────────────────────────────────────────────────────────
class SettingsState {
  final SettingsEntity settings;
  final bool isLoading;
  final String? error;

  SettingsState({
    SettingsEntity? settings,
    this.isLoading = false,
    this.error,
  }) : settings = settings ??
            const SettingsEntity(
                budgetAlerts: true,
                goalAchievements: true,
                marketingEmails: false,
                selectedTheme: 0);

  SettingsState copyWith({
    SettingsEntity? settings,
    bool? isLoading,
    String? error,
  }) =>
      SettingsState(
        settings: settings ?? this.settings,
        isLoading: isLoading ?? this.isLoading,
        error: error,
      );
}

class SettingsNotifier extends StateNotifier<SettingsState> {
  final GetSettingsUseCase _get;
  final UpdateProfileUseCase _updateProfile;
  final ChangePasswordUseCase _changePassword;
  final SettingsRemoteSource _source;
  final FlutterSecureStorage _storage;

  SettingsNotifier(
    this._get,
    this._updateProfile,
    this._changePassword,
    this._source, {
    FlutterSecureStorage? storage,
  })  : _storage = storage ?? const FlutterSecureStorage(),
        super(SettingsState());

  Future<void> load() async {
    state = state.copyWith(isLoading: true, error: null);
    try {
      final settings = await _get();
      bool biometric = settings.biometricEnabled;
      try {
        biometric =
            (await _storage.read(key: kBiometricEnabledKey)) == 'true';
      } catch (_) {
        // Secure storage unavailable; fall back to the persisted value.
      }
      state = state.copyWith(
        settings: settings.copyWith(biometricEnabled: biometric),
        isLoading: false,
      );
    } catch (e, st) {
      CrashReporter.record(e, st, reason: 'settings.load');
      state = state.copyWith(isLoading: false, error: e.toString());
    }
  }

  Future<void> update(SettingsEntity settings) async {
    try {
      await _source.saveSettings(settings);
      state = state.copyWith(settings: settings);
    } catch (e, st) {
      CrashReporter.record(e, st, reason: 'settings.update');
      state = state.copyWith(error: e.toString());
    }
  }

  /// Merges the supplied notification toggles into the current settings and
  /// persists them. Recognised keys: budgetAlerts, goalAchievements,
  /// marketingEmails.
  Future<void> updateNotificationPreferences(Map<String, bool> prefs) {
    final current = state.settings;
    return update(current.copyWith(
      budgetAlerts: prefs['budgetAlerts'] ?? current.budgetAlerts,
      goalAchievements:
          prefs['goalAchievements'] ?? current.goalAchievements,
      marketingEmails: prefs['marketingEmails'] ?? current.marketingEmails,
    ));
  }

  /// Persists the chosen [ThemeMode] (light → 0 "Sahara Light",
  /// dark → 1 "Midnight Sands"; system maps to light).
  Future<void> updateTheme(ThemeMode mode) {
    final index = mode == ThemeMode.dark ? 1 : 0;
    return update(state.settings.copyWith(selectedTheme: index));
  }

  Future<void> updateProfile({String? displayName, String? photoUrl}) async {
    await _updateProfile(displayName: displayName, photoUrl: photoUrl);
    await load();
  }

  Future<void> changePassword(
      String currentPassword, String newPassword) async {
    state = state.copyWith(isLoading: true, error: null);
    try {
      await _changePassword(currentPassword, newPassword);
      state = state.copyWith(isLoading: false);
    } catch (e, st) {
      CrashReporter.record(e, st, reason: 'settings.changePassword');
      state = state.copyWith(isLoading: false, error: e.toString());
    }
  }

  /// Persists the biometric-unlock preference to secure storage and reflects
  /// it in state.
  Future<void> toggleBiometric(bool enabled) async {
    try {
      await _storage.write(
          key: kBiometricEnabledKey, value: enabled.toString());
    } catch (e, st) {
      CrashReporter.record(e, st, reason: 'settings.toggleBiometric');
    }
    state = state.copyWith(
        settings: state.settings.copyWith(biometricEnabled: enabled));
  }
}

final settingsProvider =
    StateNotifierProvider<SettingsNotifier, SettingsState>((ref) {
  final source = ref.read(_settingsSourceProvider);
  return SettingsNotifier(
    ref.read(getSettingsUseCaseProvider),
    ref.read(updateProfileUseCaseProvider),
    ref.read(changePasswordUseCaseProvider),
    source,
  );
});
