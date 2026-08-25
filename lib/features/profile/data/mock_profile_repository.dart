import 'dart:async';

import 'package:amanah/features/auth/data/models/user.dart';
import 'package:amanah/features/profile/data/profile_repository.dart';
import 'package:shared_preferences/shared_preferences.dart';

/// No-API implementation used until the profile endpoints ship. Simulates
/// network latency, persists notification toggles to SharedPreferences, and
/// keeps profile edits in memory only (until the real repository replaces
/// it — the UI contract is identical).
class MockProfileRepository implements ProfileRepository {
  MockProfileRepository([this._cachedUser]);

  static const _prefsPrefix = 'profile.notifications';

  /// Signed-in user injected by the provider so mocks can return a properly
  /// merged result, like the real API will. Refreshed with the provider.
  final User? _cachedUser;

  @override
  Future<User> updateProfile(ProfileUpdate update) async {
    await Future<void>.delayed(const Duration(milliseconds: 600));
    final base = _cachedUser ??
        const User(
          id: '0',
          name: 'Auditor',
          email: 'jenniferanniston@amanah.com',
        );
    // Merge onto the cached identity — what the real endpoint will return.
    return base.copyWith(
      name: update.name ?? base.name,
      mobileNumber:
          '${update.mobileCountryCode ?? ''}${update.mobileNumber ?? ''}',
      profilePictureUrl: update.profilePictureUrl ?? base.profilePictureUrl,
    );
  }

  @override
  Future<String> updateProfilePicture(String filePath) async {
    await Future<void>.delayed(const Duration(milliseconds: 600));
    return _cachedUser?.profilePictureUrl ?? '';
  }

  @override
  Future<void> deleteAccount() async {
    await Future<void>.delayed(const Duration(milliseconds: 600));
  }

  @override
  Future<NotificationSettings> notificationSettings() async {
    final prefs = await SharedPreferences.getInstance();
    return NotificationSettings(
      emailNotification: prefs.getBool('$_prefsPrefix.email') ?? true,
      pushNotification: prefs.getBool('$_prefsPrefix.push') ?? true,
    );
  }

  @override
  Future<void> updateNotificationSettings(
    NotificationSettings settings,
  ) async {
    await Future<void>.delayed(const Duration(milliseconds: 200));
    final prefs = await SharedPreferences.getInstance();
    await prefs.setBool('$_prefsPrefix.email', settings.emailNotification);
    await prefs.setBool('$_prefsPrefix.push', settings.pushNotification);
  }
}
