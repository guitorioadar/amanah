import 'dart:async';

import 'package:amanah/core/network/dio_client.dart';
import 'package:amanah/core/storage/secure_storage.dart';
import 'package:app_badge_plus/app_badge_plus.dart';
import 'package:dio/dio.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter_local_notifications/flutter_local_notifications.dart';

/// Handles FCM messages received while the app is terminated/background. Must be
/// a top-level function. The OS renders `notification`-type payloads on its own,
/// so this only needs Firebase initialized; the app-icon badge for background
/// pushes is driven server-side via APNs `aps.badge`.
@pragma('vm:entry-point')
Future<void> firebaseMessagingBackgroundHandler(RemoteMessage message) async {
  await Firebase.initializeApp();
}

/// Push notifications: permission, foreground tray display (via
/// [FlutterLocalNotificationsPlugin]), FCM token access, and the app-icon
/// badge (synced from `GET /notifications/unread-count`).
///
/// Token registration to the backend and badge-clearing on logout are driven by
/// the session layer, which owns the authenticated repository.
class PushService {
  PushService._();
  static final PushService instance = PushService._();

  final FlutterLocalNotificationsPlugin _local =
      FlutterLocalNotificationsPlugin();

  /// Standalone Dio (auth token from storage) used only for the badge count, so
  /// the badge can sync without a Riverpod ref.
  Dio? _dio;
  bool _ready = false;

  /// Must match the FCM default channel declared in AndroidManifest.
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

    FirebaseMessaging.onMessage.listen(_onForegroundMessage);
    // Scope is system tray + badge only (no deep-linking), so opening a push
    // just resyncs the badge.
    FirebaseMessaging.onMessageOpenedApp.listen((_) => unawaited(syncBadge()));
    unawaited(
      messaging.getInitialMessage().then((m) {
        if (m != null) unawaited(syncBadge());
      }),
    );
  }

  /// This device's current FCM token (null if unavailable / not permitted).
  Future<String?> token() => FirebaseMessaging.instance.getToken();

  /// Fires when FCM rotates the token — re-register with the backend.
  Stream<String> get onTokenRefresh =>
      FirebaseMessaging.instance.onTokenRefresh;

  void _onForegroundMessage(RemoteMessage message) {
    final n = message.notification;
    if (n != null) {
      unawaited(_local.show(
        n.hashCode,
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
    unawaited(syncBadge());
  }

  /// Pulls the unread count and reflects it on the app icon. Errors are
  /// swallowed — a failed sync just leaves the badge unchanged.
  Future<void> syncBadge() async {
    try {
      _dio ??= DioClient.create(SecureStorage());
      final res = await _dio!.get<Map<String, dynamic>>(
        '/notifications/unread-count',
      );
      final data = res.data?['data'] as Map<String, dynamic>?;
      await _setBadge(data?['count'] as int? ?? 0);
    } on Object {
      // ignore — best effort.
    }
  }

  Future<void> clearBadge() => _setBadge(0);

  Future<void> _setBadge(int count) async {
    try {
      if (await AppBadgePlus.isSupported()) {
        await AppBadgePlus.updateBadge(count);
      }
    } on Object {
      // ignore — unsupported launcher / platform.
    }
  }
}
