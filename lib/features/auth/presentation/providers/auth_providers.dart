import 'dart:async';
import 'package:amanah/core/providers.dart';
import 'package:amanah/features/auth/data/auth_repository.dart';
import 'package:amanah/features/auth/presentation/providers/session_providers.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

/// Auth backend is fully live (login + password recovery), so the app always
/// talks to the real repository. [MockAuthRepository] remains for tests.
final Provider<AuthRepository> authRepositoryProvider =
    Provider<AuthRepository>((ref) {
  return AuthRepositoryImpl(
    ref.watch(dioProvider),
    ref.watch(secureStorageProvider),
  );
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
      final user = await ref
          .read(authRepositoryProvider)
          .signIn(email: email, password: password);
      await ref.read(currentUserProvider.notifier).setUser(user);
    });
    state = result;
    return !result.hasError;
  }
}
