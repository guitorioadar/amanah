import 'dart:async';

import 'package:amanah/core/config/env.dart';
import 'package:amanah/core/providers.dart';
import 'package:amanah/features/auth/data/auth_repository.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';


final Provider<AuthRepository> authRepositoryProvider =
    Provider<AuthRepository>((ref) {
      final storage = ref.watch(secureStorageProvider);
      final real = AuthRepositoryImpl(ref.watch(dioProvider), storage);
      if (!Env.useMockApi) return real;
      return HybridAuthRepository(real, MockAuthRepository(storage));
    });

/// Drives the sign-in action. `AsyncValue<void>` exposes loading/error/data
/// for the UI (button spinner, error message).
// ignore: specify_nonobvious_property_types
final signInControllerProvider =
    AsyncNotifierProvider.autoDispose<SignInController, void>(
      SignInController.new,
    );

class SignInController extends AsyncNotifier<void> {
  @override
  FutureOr<void> build() {}

  /// Returns true on success so the screen can navigate.
  Future<bool> signIn({
    required String email,
    required String password,
  }) async {
    state = const AsyncLoading<void>();
    final result = await AsyncValue.guard<void>(() async {
      await ref
          .read(authRepositoryProvider)
          .signIn(email: email, password: password);
    });
    state = result;
    return !result.hasError;
  }
}
