import 'package:amanah/app.dart';
import 'package:amanah/core/config/env.dart';
import 'package:amanah/core/push/push_service.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Env.load();

  // Push is best-effort: if Firebase isn't configured on this platform yet
  // (e.g. the iOS GoogleService-Info.plist hasn't been added to the target),
  // the app still launches without notifications. No background message handler
  // is needed — the OS posts notification-type pushes itself, and the launcher's
  // native badge counts them (WhatsApp-style).
  try {
    await Firebase.initializeApp();
    await PushService.instance.init();
  } on Object {
    // Notifications unavailable; continue.
  }

  runApp(const ProviderScope(child: AmanahApp()));
}
