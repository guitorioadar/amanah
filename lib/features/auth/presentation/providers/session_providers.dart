import 'dart:convert';

import 'package:amanah/core/providers.dart';
import 'package:amanah/features/auth/data/models/user.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

/// The signed-in user, or `null` when signed out. Populated on sign-in and on
/// cold start (from cached storage); cleared on logout.
final currentUserProvider =
    NotifierProvider<CurrentUserNotifier, User?>(CurrentUserNotifier.new);

class CurrentUserNotifier extends Notifier<User?> {
  @override
  User? build() => null;

  /// Sets the user and caches it to storage for next cold start.
  Future<void> setUser(User user) async {
    state = user;
    await ref.read(secureStorageProvider).saveUser(jsonEncode(user.toJson()));
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
    return true;
  }

  /// Clears tokens + cached user and drops in-memory state.
  Future<void> logout() async {
    await ref.read(secureStorageProvider).clear();
    state = null;
  }
}
