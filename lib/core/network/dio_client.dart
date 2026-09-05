import 'dart:io';

import 'package:amanah/core/config/env.dart';
import 'package:amanah/core/network/auth_interceptor.dart';
import 'package:amanah/core/network/multipart_log_interceptor.dart';
import 'package:amanah/core/storage/secure_storage.dart';
import 'package:dio/dio.dart';
import 'package:dio/io.dart';
import 'package:flutter/foundation.dart';

/// Builds the app's configured [Dio]. Repositories receive this via Riverpod;
/// they never construct their own client.
class DioClient {
  /// Linux `SO_SNDBUF` (level `SOL_SOCKET`). dart:io exposes the level but not
  /// this option number; it's stable on Linux/Android.
  static const int _soSndBuf = 7;

  /// Kernel send-buffer cap for Android sockets (the kernel doubles it for
  /// bookkeeping, so ~512 KB is actually in flight). Smaller = more accurate
  /// upload progress but lower max throughput (≈ buffer / RTT).
  static const int _androidSendBufferBytes = 256 * 1024;

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
    if (!kIsWeb && Platform.isAndroid) {
      dio.httpClientAdapter = IOHttpClientAdapter(
        createHttpClient: _createAndroidHttpClient,
      );
    }
    dio.interceptors.add(AuthInterceptor(storage));
    // Logs multipart parts (file type + size) to the console in debug only.
    if (kDebugMode) dio.interceptors.add(MultipartLogInterceptor());
    return dio;
  }

  /// [HttpClient] whose sockets have a capped kernel send buffer.
  ///
  /// Dio's `onSendProgress` counts bytes as the socket accepts them. Linux
  /// (Android) autotunes the TCP send buffer up to several MB, so it swallows
  /// a whole multi-MB upload instantly and progress hits 100% long before the
  /// bytes reach the wire. Capping `SO_SNDBUF` makes backpressure track the
  /// actual transfer. iOS kernels keep small buffers, so it isn't needed there.
  static HttpClient _createAndroidHttpClient() {
    return HttpClient()
      ..connectionFactory = (uri, proxyHost, proxyPort) async {
      // Through a proxy: connect to it and hand back a plain socket —
      // HttpClient sets up the CONNECT tunnel and TLS itself in that case.
      final viaProxy = proxyHost != null;
      final host = viaProxy ? proxyHost : uri.host;
      final port = viaProxy ? proxyPort! : uri.port;
      final task = await Socket.startConnect(host, port);
      final socket = task.socket.then((raw) {
        raw.setRawOption(
          RawSocketOption.fromInt(
            RawSocketOption.levelSocket,
            _soSndBuf,
            _androidSendBufferBytes,
          ),
        );
        // Direct https: with a custom connectionFactory, HttpClient doesn't
        // negotiate TLS itself, so secure the socket here.
        if (!viaProxy && uri.scheme == 'https') {
          return SecureSocket.secure(raw, host: uri.host);
        }
        return Future<Socket>.value(raw);
      });
      return ConnectionTask.fromSocket(socket, task.cancel);
    };
  }
}
