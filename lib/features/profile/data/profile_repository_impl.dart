import 'package:amanah/core/network/api_exception.dart';
import 'package:amanah/features/auth/data/models/user.dart';
import 'package:amanah/features/profile/data/profile_repository.dart';
import 'package:dio/dio.dart';

/// Real profile repository. `updateProfile` (`PUT /auth/profile`), the avatar
/// upload, and the notification preferences (`GET`/`PUT /notifications/settings`)
/// are live; account deletion is delegated to [_fallback] until its API ships.
class ProfileRepositoryImpl implements ProfileRepository {
  ProfileRepositoryImpl(this._dio, this._fallback);

  final Dio _dio;
  final ProfileRepository _fallback;

  @override
  Future<User> updateProfile(ProfileUpdate update) async {
    try {
      final res = await _dio.put<Map<String, dynamic>>(
        '/auth/profile',
        data: {
          'name': update.name,
          'mobile_number': update.mobileNumber,
          // Sent whenever the form supplied the field (even empty), so the user
          // can both set and clear their address.
          if (update.address != null)
            'address': {'address_line': update.address},
        },
      );
      // Envelope: { success, message, data: { ...user } }.
      return User.fromJson(res.data!['data'] as Map<String, dynamic>);
    } on DioException catch (e) {
      throw ApiException.fromDio(e);
    }
  }

  @override
  Future<String> updateProfilePicture(String filePath) async {
    try {
      final form = FormData.fromMap({
        'profile_picture': await MultipartFile.fromFile(filePath),
      });
      final res = await _dio.post<Map<String, dynamic>>(
        '/auth/profile-picture',
        data: form,
      );
      // Envelope: { data: { file: { url, ... }, download_url } }.
      final data = res.data!['data'] as Map<String, dynamic>;
      final file = data['file'] as Map<String, dynamic>?;
      return (file?['url'] ?? data['download_url']) as String;
    } on DioException catch (e) {
      throw ApiException.fromDio(e);
    }
  }

  @override
  Future<void> deleteAccount() => _fallback.deleteAccount();

  @override
  Future<NotificationSettings> notificationSettings() async {
    try {
      final res = await _dio.get<Map<String, dynamic>>(
        '/notifications/settings',
      );
      return NotificationSettings.fromJson(
        res.data!['data'] as Map<String, dynamic>,
      );
    } on DioException catch (e) {
      throw ApiException.fromDio(e);
    }
  }

  @override
  Future<void> updateNotificationSettings(NotificationSettings settings) async {
    try {
      // Only the two master toggles are user-editable; the per-event flags
      // are left untouched server-side.
      await _dio.put<Map<String, dynamic>>(
        '/notifications/settings',
        data: {
          'email_notification': settings.emailNotification,
          'push_notification': settings.pushNotification,
        },
      );
    } on DioException catch (e) {
      throw ApiException.fromDio(e);
    }
  }
}
