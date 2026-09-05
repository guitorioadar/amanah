import 'package:dio/dio.dart';
import 'package:flutter/foundation.dart';

/// Debug-only interceptor that logs the parts of a multipart request — the
/// filename, content type, and size of each uploaded file, plus the text
/// fields. DevTools' network view doesn't surface multipart bodies, so this
/// makes it easy to confirm what file type / size actually goes to the server.
///
/// Only added in debug builds (see `DioClient`); it does nothing in release.
class MultipartLogInterceptor extends Interceptor {
  @override
  void onRequest(
    RequestOptions options,
    RequestInterceptorHandler handler,
  ) {
    final data = options.data;
    if (data is FormData) {
      debugPrint('┌─ multipart ${options.method} ${options.path}');
      for (final field in data.fields) {
        debugPrint('│  field  ${field.key} = ${field.value}');
      }
      for (final entry in data.files) {
        final f = entry.value;
        final kb = (f.length / 1024).toStringAsFixed(1);
        final mb = (f.length / (1024 * 1024)).toStringAsFixed(2);
        debugPrint(
          '│  file   ${entry.key} → name=${f.filename} '
          'type=${f.contentType} size=${kb}KB (${mb}MB)',
        );
      }
      debugPrint('└─');
    }
    handler.next(options);
  }
}
