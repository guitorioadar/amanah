import 'dart:async';

import 'package:amanah/app.dart';
import 'package:amanah/core/config/env.dart';
import 'package:amanah/core/push/push_service.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Env.load();

  // Push is best-effort and must never block startup. On iOS, FCM setup awaits
  // an APNs token, which can stall until APNs registration completes (or never,
  // if APNs isn't configured yet) — so init runs fire-and-forget, off the path
  // to runApp. No background message handler is needed; the OS posts
  // notification-type pushes itself.
  try {
    await Firebase.initializeApp();
    unawaited(PushService.instance.init());
  } on Object {
    // Notifications unavailable; continue.
  }

  runApp(const ProviderScope(child: AmanahApp()));
}
