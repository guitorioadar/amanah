import 'package:amanah/core/network/api_exception.dart';
import 'package:amanah/features/auth/data/models/user.dart';
import 'package:amanah/features/profile/data/profile_repository.dart';
import 'package:dio/dio.dart';

/// Real profile repository. `updateProfile` (`PUT /auth/profile`), the avatar
/// upload, the notification preferences (`GET`/`PUT /notifications/settings`),
/// and OTP-gated account deletion are all live.
class ProfileRepositoryImpl implements ProfileRepository {
  ProfileRepositoryImpl(this._dio);

  final Dio _dio;

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
  Future<void> registerFcmToken(String token) async {
    try {
      await _dio.post<Map<String, dynamic>>(
        '/auth/fcm-token',
        data: {'fcm_token': token, 'platform': 'app'},
      );
    } on DioException catch (e) {
      throw ApiException.fromDio(e);
    }
  }

  @override
  Future<void> sendDeleteAccountOtp() async {
    try {
      await _dio.post<Map<String, dynamic>>('/auth/delete-account/send-otp');
    } on DioException catch (e) {
      throw ApiException.fromDio(e);
    }
  }

  @override
  Future<void> deleteAccount(String otpCode) async {
    try {
      await _dio.post<Map<String, dynamic>>(
        '/auth/delete-account',
        data: {'otp_code': otpCode},
      );
    } on DioException catch (e) {
      throw ApiException.fromDio(e);
    }
  }

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
