import 'package:amanah/core/router/app_router.dart';
import 'package:amanah/core/theme/app_system_ui.dart';
import 'package:amanah/core/theme/app_theme.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:go_router/go_router.dart';

class AmanahApp extends StatefulWidget {
  const AmanahApp({super.key});

  @override
  State<AmanahApp> createState() => _AmanahAppState();
}

class _AmanahAppState extends State<AmanahApp> {
  late final GoRouter _router = buildRouter();

  @override
  Widget build(BuildContext context) {
    return MaterialApp.router(
      title: 'ISNA Halal Amanah',
      debugShowCheckedModeBanner: false,
      theme: AppTheme.light,
      routerConfig: _router,
      // App-wide default: dark icons for light screens. Screens whose top is
      // dark (navy headers, gradients) override with AppSystemUi.light.
      // Also cap the OS font scale at 1.0 so a device set to a large text size
      // doesn't blow up the fixed design layouts.
      builder: (context, child) => MediaQuery.withClampedTextScaling(
        maxScaleFactor: 1,
        child: AnnotatedRegion<SystemUiOverlayStyle>(
          value: AppSystemUi.dark,
          child: child!,
        ),
      ),
    );
  }
}
