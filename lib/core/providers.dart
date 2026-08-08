import 'package:amanah/core/network/dio_client.dart';
import 'package:amanah/core/storage/secure_storage.dart';
import 'package:dio/dio.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

/// App-wide singletons wired with manual Riverpod providers (no codegen — see
/// [[amanah-flutter-stack]]). Feature repositories depend on these; the
/// mock/real swap happens inside each feature's repository provider using
/// `Env.useMockApi`.

final secureStorageProvider = Provider<SecureStorage>((ref) {
  return SecureStorage();
});

final dioProvider = Provider<Dio>((ref) {
  return DioClient.create(ref.watch(secureStorageProvider));
});
