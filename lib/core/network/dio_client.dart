import 'package:amanah/core/config/env.dart';
import 'package:amanah/core/network/auth_interceptor.dart';
import 'package:amanah/core/network/multipart_log_interceptor.dart';
import 'package:amanah/core/storage/secure_storage.dart';
import 'package:dio/dio.dart';
import 'package:flutter/foundation.dart';

/// Builds the app's configured [Dio]. Repositories receive this via Riverpod;
/// they never construct their own client.
class DioClient {
  static Dio create(SecureStorage storage) {
    final dio = Dio(
      BaseOptions(
        baseUrl: Env.apiBaseUrl,
        connectTimeout: const Duration(seconds: 20),
        // Generous for multipart uploads: sending the file + waiting on
        // server-side processing can take well over the JSON default.
        sendTimeout: const Duration(seconds: 60),
        receiveTimeout: const Duration(seconds: 60),
        contentType: Headers.jsonContentType,
      ),
    );
    dio.interceptors.add(AuthInterceptor(storage));
    // Logs multipart parts (file type + size) to the console in debug only.
    if (kDebugMode) dio.interceptors.add(MultipartLogInterceptor());
    return dio;
  }
}
