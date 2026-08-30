import 'dart:async';
import 'dart:convert';

import 'package:amanah/core/providers.dart';
import 'package:amanah/core/push/push_service.dart';
import 'package:amanah/features/auth/data/models/user.dart';
import 'package:amanah/features/profile/presentation/providers/profile_providers.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

/// The signed-in user, or `null` when signed out. Populated on sign-in and on
/// cold start (from cached storage); cleared on logout.
final currentUserProvider =
    NotifierProvider<CurrentUserNotifier, User?>(CurrentUserNotifier.new);

class CurrentUserNotifier extends Notifier<User?> {
  StreamSubscription<String>? _tokenRefreshSub;

  @override
  User? build() => null;

  /// Sets the user and caches it to storage for next cold start. Also warms
  /// the notification-settings cache so those screens open without a fetch, and
  /// registers this device for push.
  Future<void> setUser(User user) async {
    state = user;
    await ref.read(secureStorageProvider).saveUser(jsonEncode(user.toJson()));
    unawaited(ref.read(notificationSettingsProvider.notifier).load());
    unawaited(_syncPush());
  }

  /// Rehydrates the user from cached storage (called on splash). Returns true
  /// when a session token exists — the caller then routes to the dashboard.
  Future<bool> restore() async {
    final storage = ref.read(secureStorageProvider);
    if (!await storage.hasSession) return false;
    final json = await storage.userJson;
    if (json != null && json.isNotEmpty) {
      state = User.fromJson(jsonDecode(json) as Map<String, dynamic>);
    }
    // Warm the notification-settings cache for this restored session.
    unawaited(ref.read(notificationSettingsProvider.notifier).load());
    unawaited(_syncPush());
    return true;
  }

  /// Clears tokens + cached user and drops in-memory state.
  Future<void> logout() async {
    await _tokenRefreshSub?.cancel();
    _tokenRefreshSub = null;
    await ref.read(secureStorageProvider).clear();
    ref.read(notificationSettingsProvider.notifier).clear();
    unawaited(PushService.instance.clearNotifications());
    state = null;
  }

  /// Registers the current FCM token and keeps it fresh on rotation. All
  /// best-effort — failures never block the session.
  Future<void> _syncPush() async {
    final token = await PushService.instance.token();
    if (token != null) await _registerIfChanged(token);
    _tokenRefreshSub ??= PushService.instance.onTokenRefresh.listen((t) {
      unawaited(_registerIfChanged(t));
    });
  }

  /// Calls the register API only when [token] differs from the one we last
  /// registered (cached locally). The cache is written **after** a successful
  /// call, so a failure retries on the next launch.
  Future<void> _registerIfChanged(String token) async {
    final storage = ref.read(secureStorageProvider);
    if (token == await storage.registeredFcmToken) return;
    try {
      await ref.read(profileRepositoryProvider).registerFcmToken(token);
      await storage.saveRegisteredFcmToken(token);
    } on Object {
      // ignore — retried on next launch / token refresh.
    }
  }
}
