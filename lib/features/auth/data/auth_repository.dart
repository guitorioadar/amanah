import 'package:amanah/core/network/api_exception.dart';
import 'package:amanah/core/storage/secure_storage.dart';
import 'package:amanah/features/auth/data/models/user.dart';
import 'package:dio/dio.dart';

/// Contract the UI depends on. Two implementations: real ([AuthRepositoryImpl])
/// and mock ([MockAuthRepository]); the active one is chosen in the provider by
/// `Env.useMockApi`. UI never sees which.
/// Intentional interface — two implementations (real + mock) swap behind it.
abstract interface class AuthRepository {
  Future<User> signIn({required String email, required String password});

  /// Sends an OTP to the account email (password-recovery step 1).
  Future<void> requestPasswordReset(String email);

  /// Verifies the OTP for [email] (step 2). Throws if the code is wrong.
  Future<void> verifyOtp({required String email, required String code});

  /// Sets a new password after OTP verification (step 3).
  Future<void> resetPassword({
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
      final data = res.data!;
      await _storage.saveTokens(
        accessToken: data['access_token'] as String,
        refreshToken: data['refresh_token'] as String?,
      );
      return User.fromJson(data['user'] as Map<String, dynamic>);
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
  Future<void> verifyOtp({required String email, required String code}) async {
    try {
      await _dio.post<void>(
        '/auth/verify-otp',
        data: {'email': email, 'code': code},
      );
    } on DioException catch (e) {
      throw ApiException.fromDio(e);
    }
  }

  @override
  Future<void> resetPassword({
    required String email,
    required String code,
    required String newPassword,
  }) async {
    try {
      final res = await _dio.post<Map<String, dynamic>>(
        '/auth/reset-password',
        data: {'email': email, 'code': code, 'password': newPassword},
      );
      final token = res.data?['access_token'] as String?;
      if (token != null) {
        await _storage.saveTokens(
          accessToken: token,
          refreshToken: res.data?['refresh_token'] as String?,
        );
      }
    } on DioException catch (e) {
      throw ApiException.fromDio(e);
    }
  }
}

/// Mock implementation — dummy data, no backend. Drives M1–M2.
///
/// Demo credentials: `auditor@isnahalal.com` / `password`.
class MockAuthRepository implements AuthRepository {
  MockAuthRepository(this._storage);

  final SecureStorage _storage;

  static const _demoEmail = 'auditor@isnahalal.com';
  static const _demoPassword = 'password';

  /// Demo OTP accepted by [verifyOtp] / [resetPassword] in mock mode.
  static const _demoOtp = '000000';

  static Future<void> _latency() =>
      Future<void>.delayed(const Duration(milliseconds: 900));

  Future<void> _saveMockTokens() => _storage.saveTokens(
    accessToken: 'mock-access-token',
    refreshToken: 'mock-refresh-token',
  );

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
    return const User(id: 'u_1', name: 'Test Auditor', email: _demoEmail);
  }

  @override
  Future<void> requestPasswordReset(String email) => _latency();

  @override
  Future<void> verifyOtp({required String email, required String code}) async {
    await _latency();
    if (code != _demoOtp) {
      throw const ApiException(
        ApiErrorType.validation,
        'Invalid or expired code.',
      );
    }
  }

  @override
  Future<void> resetPassword({
    required String email,
    required String code,
    required String newPassword,
  }) async {
    await _latency();
    if (code != _demoOtp) {
      throw const ApiException(
        ApiErrorType.validation,
        'Invalid or expired code.',
      );
    }
    // Auto sign-in after reset so we can land on the dashboard (per design).
    await _saveMockTokens();
  }
}
