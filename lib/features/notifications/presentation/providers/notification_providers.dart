import 'dart:async';

import 'package:amanah/core/providers.dart';
import 'package:amanah/features/notifications/data/models/app_notification.dart';
import 'package:amanah/features/notifications/data/notification_repository.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

/// Notifications backend is live.
final Provider<NotificationRepository> notificationRepositoryProvider =
    Provider<NotificationRepository>((ref) {
  return NotificationRepositoryImpl(ref.watch(dioProvider));
});

/// The notification feed for the Notifications screen. Supports optimistic
/// mark-as-read (single + all) and pull-to-refresh.
// ignore: specify_nonobvious_property_types
final notificationsProvider = AsyncNotifierProvider.autoDispose<NotificationsNotifier, List<AppNotification>>(NotificationsNotifier.new);

class NotificationsNotifier extends AsyncNotifier<List<AppNotification>> {
  @override
  Future<List<AppNotification>> build() {
    return ref.watch(notificationRepositoryProvider).list();
  }

  /// Re-fetches the feed (pull-to-refresh), keeping the old list visible while
  /// loading.
  Future<void> refresh() async {
    state = await AsyncValue.guard(
      () => ref.read(notificationRepositoryProvider).list(),
    );
    ref.invalidate(unreadCountProvider);
  }

  /// Optimistically marks one notification read, reverting on failure.
  Future<void> markRead(int id) async {
    final current = state.value;
    if (current == null) return;
    final target = current.firstWhere(
      (n) => n.id == id,
      orElse: () => current.first,
    );
    if (target.id != id || !target.isUnread) return;

    state = AsyncData([
      for (final n in current)
        if (n.id == id) n.copyWith(readAt: DateTime.now()) else n,
    ]);
    try {
      await ref.read(notificationRepositoryProvider).markRead(id);
      ref.invalidate(unreadCountProvider);
    } on Object {
      state = AsyncData(current);
      rethrow;
    }
  }

  /// Optimistically marks every notification read, reverting on failure.
  Future<void> markAllRead() async {
    final current = state.value;
    if (current == null || current.every((n) => !n.isUnread)) return;
    final now = DateTime.now();

    state = AsyncData([
      for (final n in current)
        if (n.isUnread) n.copyWith(readAt: now) else n,
    ]);
    try {
      await ref.read(notificationRepositoryProvider).markAllRead();
      ref.invalidate(unreadCountProvider);
    } on Object {
      state = AsyncData(current);
      rethrow;
    }
  }
}

/// Unread badge count for the header bell. Fetched independently so the bell
/// stays cheap on Home/Audits without loading the full feed.
// ignore: specify_nonobvious_property_types
final unreadCountProvider = FutureProvider.autoDispose<int>((ref) {
  return ref.watch(notificationRepositoryProvider).unreadCount();
});
