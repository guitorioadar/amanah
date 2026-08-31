import 'dart:async';

import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter_local_notifications/flutter_local_notifications.dart';

/// Push notifications: permission, foreground tray display (via
/// [FlutterLocalNotificationsPlugin]), and FCM token access.
///
/// Background & killed `notification`-type pushes are posted by the OS;
/// foreground pushes are posted here. Token registration to the backend is
/// driven by the session layer, which owns the authenticated repository.
class PushService {
  PushService._();
  static final PushService instance = PushService._();

  final FlutterLocalNotificationsPlugin _local =
      FlutterLocalNotificationsPlugin();

  bool _ready = false;

  /// Must match the FCM default channel declared in AndroidManifest.
  /// `showBadge: false` suppresses the app-icon badge for every notification on
  /// this channel (Android 8+) — this overrides any `notification_count` the
  /// server sends. App-icon badge is deferred; revisit when it's built.
  static const AndroidNotificationChannel _channel = AndroidNotificationChannel(
    'high_importance_channel',
    'Notifications',
    description: 'General notifications',
    importance: Importance.high,
  );

  /// Requests permission, sets up the channel + listeners. Safe to call twice.
  Future<void> init() async {
    if (_ready) return;
    _ready = true;

    final messaging = FirebaseMessaging.instance;
    await messaging.requestPermission();
    await messaging.setForegroundNotificationPresentationOptions(
      alert: true,
      sound: true,
    );

    await _local.initialize(
      const InitializationSettings(
        android: AndroidInitializationSettings('@mipmap/ic_launcher'),
        iOS: DarwinInitializationSettings(),
      ),
    );
    await _local
        .resolvePlatformSpecificImplementation<
            AndroidFlutterLocalNotificationsPlugin>()
        ?.createNotificationChannel(_channel);

    // Foreground messages aren't auto-posted by the OS on Android, so display
    // them here. Background/killed messages are posted by the OS.
    FirebaseMessaging.onMessage.listen(_onForegroundMessage);
  }

  /// This device's current FCM token (null if unavailable / not permitted).
  /// Returns null when push isn't initialized (e.g. Firebase not configured on
  /// this platform yet) so the session layer never touches an uninitialized
  /// Firebase app.
  Future<String?> token() async {
    if (!_ready) return null;
    final messaging = FirebaseMessaging.instance;
    final fcm = await messaging.getToken();
    debugPrint('FCM token=$fcm');
    return fcm;
  }

  /// Fires when FCM rotates the token — re-register with the backend. Empty
  /// stream when push isn't initialized.
  Stream<String> get onTokenRefresh =>
      _ready ? FirebaseMessaging.instance.onTokenRefresh : const Stream.empty();

  void _onForegroundMessage(RemoteMessage message) {
    final n = message.notification;
    if (n == null) return;
    // iOS presents foreground notifications itself (via
    // setForegroundNotificationPresentationOptions). Showing one here too would
    // duplicate it — so only display manually on Android, which does not.
    if (defaultTargetPlatform != TargetPlatform.android) return;
    // Unique id per message so notifications stack in the tray instead of
    // replacing each other (identical title/body would otherwise collide).
    // messageId is unique per push; fall back to a timestamp. Masked to a
    // positive 31-bit int (Android notification id).
    final id =
        (message.messageId?.hashCode ?? DateTime.now().microsecondsSinceEpoch) &
            0x7fffffff;
    unawaited(_local.show(
      id,
      n.title,
      n.body,
      NotificationDetails(
        android: AndroidNotificationDetails(
          _channel.id,
          _channel.name,
          channelDescription: _channel.description,
          importance: Importance.high,
          priority: Priority.high,
          icon: '@mipmap/ic_launcher',
        ),
        iOS: const DarwinNotificationDetails(),
      ),
    ));
  }

  /// Clears every posted notification. Called on logout.
  Future<void> clearNotifications() => _local.cancelAll();
}
