import 'package:amanah/core/network/api_exception.dart';
import 'package:amanah/features/auth/data/models/user.dart';
import 'package:amanah/features/profile/data/profile_repository.dart';
import 'package:dio/dio.dart';

/// Real profile repository. Only `updateProfile` has a live endpoint so far
/// (`PUT /auth/profile`); account deletion and notification preferences are
/// delegated to [_fallback] until their APIs ship.
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
  Future<void> deleteAccount() => _fallback.deleteAccount();

  @override
  Future<NotificationSettings> notificationSettings() =>
      _fallback.notificationSettings();

  @override
  Future<void> updateNotificationSettings(NotificationSettings settings) =>
      _fallback.updateNotificationSettings(settings);
}
