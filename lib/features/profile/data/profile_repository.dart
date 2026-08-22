import 'package:amanah/features/auth/data/models/user.dart';

/// Payload for updating the signed-in user's personal information. Only the
/// fields the Personal information screen can edit; the backend merges the
/// rest from the existing record.
class ProfileUpdate {
  const ProfileUpdate({
    this.name,
    this.mobileNumber,
    this.mobileCountryCode,
    this.timeZone,
    this.address,
    this.profilePictureUrl,
  });

  final String? name;
  final String? mobileNumber;

  /// Dial code only, e.g. `+1`. Stored separately until the API defines its
  /// phone shape.
  final String? mobileCountryCode;

  /// IANA name, e.g. `America/Los_Angeles`.
  final String? timeZone;

  /// Free-form single-line address.
  final String? address;
  final String? profilePictureUrl;
}

/// Contract the profile UI depends on. Real implementation arrives with the
/// API; the mock implementation keeps the screens fully usable until then.
abstract interface class ProfileRepository {
  /// Saves the editable personal-info fields and returns the updated user.
  Future<User> updateProfile(ProfileUpdate update);

  /// Verifies [currentPassword] and sets [newPassword]. Throws on a wrong
  /// current password or a rejected new password.
  Future<void> changePassword({
    required String currentPassword,
    required String newPassword,
  });

  /// Permanently deletes the account. The session is invalidated afterwards.
  /// No re-auth is required — the confirmation modal is the guard (per design).
  Future<void> deleteAccount();

  /// Fetches the notification preferences.
  Future<NotificationSettings> notificationSettings();

  /// Persists the notification preferences.
  Future<void> updateNotificationSettings(
    NotificationSettings settings,
  );
}

/// The two toggles on the Notification screen.
class NotificationSettings {
  const NotificationSettings({
    required this.emailEnabled,
    required this.inAppEnabled,
  });

  final bool emailEnabled;
  final bool inAppEnabled;

  NotificationSettings copyWith({bool? emailEnabled, bool? inAppEnabled}) =>
      NotificationSettings(
        emailEnabled: emailEnabled ?? this.emailEnabled,
        inAppEnabled: inAppEnabled ?? this.inAppEnabled,
      );
}
