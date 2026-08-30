import 'dart:async';

import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter_local_notifications/flutter_local_notifications.dart';

/// Push notifications: permission, foreground tray display (via
/// [FlutterLocalNotificationsPlugin]), and FCM token access.
///
/// The app-icon badge is **not** set explicitly — we rely on the OS launcher's
/// native notification-count badge (WhatsApp-style). Samsung/Xiaomi etc. count
/// the app's active tray notifications and stamp that number on the icon
/// automatically; dismissing/opening a notification decrements it. Background &
/// killed `notification`-type pushes are posted by the OS, so they get counted
/// without any Dart code; foreground pushes are posted here with unique ids so
/// the launcher counts them too.
///
/// Token registration to the backend is driven by the session layer, which owns
/// the authenticated repository.
class PushService {
  PushService._();
  static final PushService instance = PushService._();

  final FlutterLocalNotificationsPlugin _local =
      FlutterLocalNotificationsPlugin();

  bool _ready = false;

  /// Must match the FCM default channel declared in AndroidManifest. `showBadge`
  /// defaults to true, which lets the launcher count notifications on this
  /// channel (the native, WhatsApp-style app-icon badge).
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
      badge: true,
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

    // Foreground messages aren't auto-posted by the OS, so display them here
    // (unique id per message) — this is also what makes the launcher badge tick
    // up while the app is open. Background/killed messages are posted by the OS.
    FirebaseMessaging.onMessage.listen(_onForegroundMessage);
  }

  /// This device's current FCM token (null if unavailable / not permitted).
  Future<String?> token() => FirebaseMessaging.instance.getToken();

  /// Fires when FCM rotates the token — re-register with the backend.
  Stream<String> get onTokenRefresh =>
      FirebaseMessaging.instance.onTokenRefresh;

  void _onForegroundMessage(RemoteMessage message) {
    final n = message.notification;
    if (n == null) return;
    // Unique id per message so notifications STACK in the tray (identical
    // title/body would otherwise collide and replace each other, keeping the
    // launcher badge stuck at 1). messageId is unique per push; fall back to a
    // timestamp. Masked to a positive 31-bit int (Android notification id).
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

  /// Clears every posted notification, which also resets the native launcher
  /// badge to zero. Called on logout.
  Future<void> clearNotifications() => _local.cancelAll();
}
