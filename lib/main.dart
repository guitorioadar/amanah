import 'package:amanah/app.dart';
import 'package:amanah/core/config/env.dart';
import 'package:amanah/core/push/push_service.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Env.load();

  // Push is best-effort: if Firebase isn't configured on this platform yet
  // (e.g. the iOS GoogleService-Info.plist hasn't been added to the target),
  // the app still launches without notifications.
  try {
    await Firebase.initializeApp();
    FirebaseMessaging.onBackgroundMessage(firebaseMessagingBackgroundHandler);
    await PushService.instance.init();
  } on Object {
    // Notifications unavailable; continue.
  }

  runApp(const ProviderScope(child: AmanahApp()));
}
