import 'package:amanah/core/network/api_exception.dart';
import 'package:amanah/core/storage/secure_storage.dart';
import 'package:amanah/features/auth/data/models/user.dart';
import 'package:dio/dio.dart';

/// Contract the UI depends on. Two implementations: real ([AuthRepositoryImpl])
/// and mock ([MockAuthRepository]). UI never sees which.
///
/// Password recovery is two API calls: [requestPasswordReset] sends the OTP,
/// then [resetPassword] verifies the OTP **and** sets the password in one call
/// (there is no separate verify-OTP endpoint). A successful reset returns the
/// signed-in [User] — the backend auto-logs-in.
abstract interface class AuthRepository {
  Future<User> signIn({required String email, required String password});

  /// Sends an OTP to the account email (password-recovery step 1).
  Future<void> requestPasswordReset(String email);

  /// Verifies the OTP and sets the new password (step 2). Returns the now
  /// signed-in user; throws [ApiException] on a bad OTP or invalid password.
  Future<User> resetPassword({
    required String email,
    required String code,
    required String newPassword,
  });
}

/// Real implementation — talks to the backend over Dio.
class AuthRepositoryImpl implements AuthRepository {
  AuthRepositoryImpl(this._dio, this._storage);

  final Dio _dio;
  final SecureStorage _storage;

  @override
  Future<User> signIn({
    required String email,
    required String password,
  }) async {
    try {
      final res = await _dio.post<Map<String, dynamic>>(
        '/auth/login',
        data: {'email': email, 'password': password},
      );
      return _persistSession(res.data!);
    } on DioException catch (e) {
      throw ApiException.fromDio(e);
    }
  }

  @override
  Future<void> requestPasswordReset(String email) async {
    try {
      await _dio.post<void>('/auth/forgot-password', data: {'email': email});
    } on DioException catch (e) {
      throw ApiException.fromDio(e);
    }
  }

  @override
  Future<User> resetPassword({
    required String email,
    required String code,
    required String newPassword,
  }) async {
    try {
      final res = await _dio.post<Map<String, dynamic>>(
        '/auth/reset-password',
        data: {
          'email': email,
          'otp_code': code,
          'new_password': newPassword,
          'new_password_confirmation': newPassword,
        },
      );
      // Reset auto-logs-in: response carries the user + access token.
      return _persistSession(res.data!);
    } on DioException catch (e) {
      throw ApiException.fromDio(e);
    }
  }

  /// Extracts `{ data: { user, access_token } }`, saves the token, returns User.
  Future<User> _persistSession(Map<String, dynamic> body) async {
    final data = body['data'] as Map<String, dynamic>;
    await _storage.saveTokens(
      accessToken: data['access_token'] as String,
      refreshToken: data['refresh_token'] as String?,
    );
    return User.fromJson(data['user'] as Map<String, dynamic>);
  }
}

/// Mock implementation — dummy data, no backend. Kept for tests / offline demo.
///
/// Demo credentials: `auditor@isnahalal.com` / `password`; demo OTP `000000`.
class MockAuthRepository implements AuthRepository {
  MockAuthRepository(this._storage);

  final SecureStorage _storage;

  static const _demoEmail = 'auditor@isnahalal.com';
  static const _demoPassword = 'password';
  static const _demoOtp = '000000';

  static Future<void> _latency() =>
      Future<void>.delayed(const Duration(milliseconds: 900));

  Future<void> _saveMockTokens() => _storage.saveTokens(
        accessToken: 'mock-access-token',
        refreshToken: 'mock-refresh-token',
      );

  static const _demoUser =
      User(id: 'u_1', name: 'Test Auditor', email: _demoEmail);

  @override
  Future<User> signIn({
    required String email,
    required String password,
  }) async {
    await _latency();
    if (email.trim().toLowerCase() != _demoEmail || password != _demoPassword) {
      throw const ApiException(
        ApiErrorType.unauthorized,
        'Incorrect email or password.',
      );
    }
    await _saveMockTokens();
    return _demoUser;
  }

  @override
  Future<void> requestPasswordReset(String email) => _latency();

  @override
  Future<User> resetPassword({
    required String email,
    required String code,
    required String newPassword,
  }) async {
    await _latency();
    if (code != _demoOtp) {
      throw const ApiException(
        ApiErrorType.validation,
        'Invalid OTP code.',
      );
    }
    // Auto sign-in after reset so we can land on the dashboard (per design).
    await _saveMockTokens();
    return _demoUser;
  }
}
