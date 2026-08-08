import 'package:amanah/core/storage/secure_storage.dart';
import 'package:dio/dio.dart';

/// Injects the bearer token on every request. Token refresh (single-flight
/// queue on 401) is wired in M-auth once the refresh endpoint exists; for the
/// mock phase, a 401 simply propagates and the redirect logic signs out.
class AuthInterceptor extends Interceptor {
  AuthInterceptor(this._storage);

  final SecureStorage _storage;

  @override
  Future<void> onRequest(
    RequestOptions options,
    RequestInterceptorHandler handler,
  ) async {
    final token = await _storage.accessToken;
    if (token != null && token.isNotEmpty) {
      options.headers['Authorization'] = 'Bearer $token';
    }
    handler.next(options);
  }
}
