import 'package:amanah/core/theme/app_colors.dart';
import 'package:flutter/services.dart';

/// Status-bar overlay styles. Transparent bar (edge-to-edge); only the icon
/// brightness changes so the clock/icons contrast the screen's top color.
///
/// Wrap a screen in `AnnotatedRegion<SystemUiOverlayStyle>` with:
///   - [light] when the top of the screen is dark (navy header, gradients),
///   - [dark]  when the top is light (white pages).
/// The inner-most region wins, so per-screen values override the app default.
abstract final class AppSystemUi {
  static const light = SystemUiOverlayStyle(
    statusBarColor: AppColors.transparent,
    statusBarIconBrightness: Brightness.light, // Android
    statusBarBrightness: Brightness.dark, // iOS
  );

  static const dark = SystemUiOverlayStyle(
    statusBarColor: AppColors.transparent,
    statusBarIconBrightness: Brightness.dark, // Android
    statusBarBrightness: Brightness.light, // iOS
  );
}
