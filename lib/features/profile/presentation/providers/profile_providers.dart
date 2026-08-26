import 'package:amanah/core/providers.dart';
import 'package:amanah/features/profile/data/profile_repository.dart';
import 'package:amanah/features/profile/data/profile_repository_impl.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

/// Real profile repository — every method is backed by a live endpoint.
final profileRepositoryProvider = Provider<ProfileRepository>(
  (ref) => ProfileRepositoryImpl(ref.watch(dioProvider)),
);

/// Cached notification preferences. Preloaded once the session is active
/// (login + cold-start restore) so the Notification screen renders instantly
/// without a per-visit fetch. `null` means "not loaded yet".
final notificationSettingsProvider =
    NotifierProvider<NotificationSettingsNotifier, NotificationSettings?>(
  NotificationSettingsNotifier.new,
);

class NotificationSettingsNotifier extends Notifier<NotificationSettings?> {
  @override
  NotificationSettings? build() => null;

  /// Fetches the latest settings into the cache. Swallows errors so a failed
  /// preload never blocks routing; the screen can retry.
  Future<void> load() async {
    try {
      state = await ref.read(profileRepositoryProvider).notificationSettings();
    } on Object catch (_) {
      // Leave the previous cache (or null) in place.
    }
  }

  /// Optimistically applies [next], persists it, and reverts + rethrows on
  /// failure so the UI can surface the error.
  Future<void> update(NotificationSettings next) async {
    final previous = state;
    state = next;
    try {
      await ref
          .read(profileRepositoryProvider)
          .updateNotificationSettings(next);
    } on Object {
      state = previous;
      rethrow;
    }
  }

  /// Drops the cache on logout.
  void clear() => state = null;
}
