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

  /// Uploads a new avatar (multipart) and returns its public URL.
  Future<String> updateProfilePicture(String filePath);

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

/// The two master toggles on the Notification screen (email + in-app/push).
/// The API carries additional per-event flags, but only these two are read
/// and written by the app.
class NotificationSettings {
  const NotificationSettings({
    required this.emailNotification,
    required this.pushNotification,
  });

  factory NotificationSettings.fromJson(Map<String, dynamic> json) =>
      NotificationSettings(
        emailNotification: json['email_notification'] as bool? ?? true,
        pushNotification: json['push_notification'] as bool? ?? true,
      );

  /// The email master toggle.
  final bool emailNotification;

  /// The in-app / push master toggle.
  final bool pushNotification;

  NotificationSettings copyWith({
    bool? emailNotification,
    bool? pushNotification,
  }) =>
      NotificationSettings(
        emailNotification: emailNotification ?? this.emailNotification,
        pushNotification: pushNotification ?? this.pushNotification,
      );
}
