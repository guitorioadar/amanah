import 'package:amanah/core/config/env.dart';
import 'package:amanah/core/network/auth_interceptor.dart';
import 'package:amanah/core/storage/secure_storage.dart';
import 'package:dio/dio.dart';

/// Builds the app's configured [Dio]. Repositories receive this via Riverpod;
/// they never construct their own client.
class DioClient {
  static Dio create(SecureStorage storage) {
    final dio = Dio(
      BaseOptions(
        baseUrl: Env.apiBaseUrl,
        connectTimeout: const Duration(seconds: 20),
        receiveTimeout: const Duration(seconds: 20),
        contentType: Headers.jsonContentType,
      ),
    );
    dio.interceptors.add(AuthInterceptor(storage));
    return dio;
  }
}
