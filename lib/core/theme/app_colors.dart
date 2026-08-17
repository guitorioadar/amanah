import 'package:amanah/core/theme/app_palette.dart';
import 'package:flutter/material.dart';

/// Semantic color tokens — the transcription of `Color Tokens.png`.
/// **Widgets import this, never [AppPalette] directly.**
///
/// Single light theme in v1. See `03 - Design System.md` §3.
abstract final class AppColors {
  // ── Brand / primary (royal blue #2263F0) ──
  static const Color brand = AppPalette.brand;
  static const Color brandOnPrimary = AppPalette.neutral1;

  // ── Text ──
  static const Color textDefault = AppPalette.neutral12;
  static const Color textSubtle = AppPalette.neutral8;
  static const Color textSubtlest = AppPalette.neutral6;
  static const Color textInverse = AppPalette.neutral1;
  static const Color textDisabled = AppPalette.neutral5;
  static const Color textBrand = AppPalette.brand;
  static const Color textDanger = AppPalette.red10;
  static const Color textWarning = AppPalette.orange10;
  static const Color textSuccess = AppPalette.green10;
  static const Color textDiscovery = AppPalette.purple10;
  static const Color textInformation = AppPalette.blue10;

  // ── Icon (mirrors text) ──
  static const Color iconDefault = AppPalette.neutral12;
  static const Color iconSubtle = AppPalette.neutral8;
  static const Color iconSubtlest = AppPalette.neutral6;
  static const Color iconInverse = AppPalette.neutral1;
  static const Color iconDisabled = AppPalette.neutral5;
  static const Color iconBrand = AppPalette.brand;
  static const Color iconDanger = AppPalette.red10;
  static const Color iconSuccess = AppPalette.green10;
  static const Color iconWarning = AppPalette.orange10;
  static const Color iconInformation = AppPalette.cyan10;
  static const Color iconMagenta = AppPalette.magenta10;
  static const Color iconNotification = AppPalette.red5;

  // ── Surfaces ──
  static const Color bgDefault = AppPalette.neutral1;
  static const Color bgHovered = AppPalette.neutral2;
  static const Color bgPressed = AppPalette.neutral3;
  static const Color bgSolid = AppPalette.neutral12; // navy header
  static const Color bgBrandBold = AppPalette.brand;

  // Status subtle tints.
  static const Color bgDanger = AppPalette.red3;
  static const Color bgWarning = AppPalette.orange3;
  static const Color bgSuccess = AppPalette.green3;
  static const Color bgInfo = AppPalette.blue3;

  // ── Borders (navy at opacity) ──
  static final Color borderDefault = AppPalette.neutral12.withValues(alpha: 0.14);
  static final Color borderBold = AppPalette.neutral12.withValues(alpha: 0.27);
  static const Color borderFocus = AppPalette.brand;
  static const Color borderDisabled = AppPalette.neutral3;
  static const Color borderDanger = AppPalette.red10;

  // ── Scrim (bottom-sheet / dialog backdrop) ──
  static final Color scrim = AppPalette.neutral12.withValues(alpha: 0.40);
}
