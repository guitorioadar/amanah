import 'package:flutter_secure_storage/flutter_secure_storage.dart';

/// Thin wrapper over [FlutterSecureStorage] for auth tokens (Keychain /
/// Keystore). Repositories and the auth interceptor read/write through this.
class SecureStorage {
  SecureStorage([FlutterSecureStorage? storage])
      : _storage = storage ?? const FlutterSecureStorage();

  final FlutterSecureStorage _storage;

  static const _kAccessToken = 'access_token';
  static const _kRefreshToken = 'refresh_token';
  static const _kTokenType = 'token_type';
  static const _kUser = 'user_json';

  Future<String?> get accessToken => _storage.read(key: _kAccessToken);
  Future<String?> get refreshToken => _storage.read(key: _kRefreshToken);

  /// Scheme for the Authorization header (e.g. `Bearer`). Defaults to
  /// `Bearer` when the backend omits it.
  Future<String> get tokenType async =>
      await _storage.read(key: _kTokenType) ?? 'Bearer';

  /// True when an access token is stored — the app treats this as "signed in"
  /// on cold start (drives the splash → dashboard/sign-in decision).
  Future<bool> get hasSession async {
    final token = await accessToken;
    return token != null && token.isNotEmpty;
  }

  Future<void> saveTokens({
    required String accessToken,
    String? refreshToken,
    String? tokenType,
  }) async {
    await _storage.write(key: _kAccessToken, value: accessToken);
    if (refreshToken != null) {
      await _storage.write(key: _kRefreshToken, value: refreshToken);
    }
    if (tokenType != null) {
      await _storage.write(key: _kTokenType, value: tokenType);
    }
  }

  /// Cached user profile as a JSON string, for offline/cold-start display.
  Future<String?> get userJson => _storage.read(key: _kUser);
  Future<void> saveUser(String json) => _storage.write(key: _kUser, value: json);

  Future<void> clear() async {
    await _storage.delete(key: _kAccessToken);
    await _storage.delete(key: _kRefreshToken);
    await _storage.delete(key: _kTokenType);
    await _storage.delete(key: _kUser);
  }
}
