import 'package:amanah/core/theme/app_colors.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

/// Type scale — transcription of `Typography.png`. Family: Inter Tight.
/// Letter-spacing = 1% of font size (Caps = 5%); `height` = lineHeight / size.
///
/// Before release, switch from the google_fonts fetch to bundled Inter Tight
/// `.ttf` assets for offline field use. See `03 - Design System.md` §4.
abstract final class AppText {
  static TextStyle _base(
    double size,
    double lineHeight,
    FontWeight weight, {
    double spacingPct = 0.01,
  }) {
    return GoogleFonts.interTight(
      fontSize: size,
      height: lineHeight / size,
      fontWeight: weight,
      letterSpacing: size * spacingPct,
      color: AppColors.textDefault,
    );
  }

  // ── Heading (Bold) ──
  static final TextStyle headingXl = _base(34, 46, FontWeight.w700);
  static final TextStyle headingL = _base(26, 36, FontWeight.w700);
  static final TextStyle headingM = _base(20, 28, FontWeight.w700);
  static final TextStyle headingS = _base(18, 26, FontWeight.w700);
  static final TextStyle headingXs = _base(16, 24, FontWeight.w700);
  static final TextStyle headingXxs = _base(14, 20, FontWeight.w700);

  // ── Body/L (16/24) ──
  static final TextStyle bodyLRegular = _base(16, 24, FontWeight.w400);
  static final TextStyle bodyLMedium = _base(16, 24, FontWeight.w500);
  static final TextStyle bodyLSemiBold = _base(16, 24, FontWeight.w600);

  // ── Body/M — default (14/20) ──
  static final TextStyle bodyMRegular = _base(14, 20, FontWeight.w400);
  static final TextStyle bodyMMedium = _base(14, 20, FontWeight.w500);
  static final TextStyle bodyMSemiBold = _base(14, 20, FontWeight.w600);

  // ── Body/S (13/16) ──
  static final TextStyle bodySRegular = _base(13, 16, FontWeight.w400);
  static final TextStyle bodySMedium = _base(13, 16, FontWeight.w500);

  // ── Body/XS (12/16) ──
  static final TextStyle bodyXsRegular = _base(12, 16, FontWeight.w400);
  static final TextStyle bodyXsMedium = _base(12, 16, FontWeight.w500);

  // ── Button (Medium) ──
  static final TextStyle buttonL = _base(16, 22, FontWeight.w500);
  static final TextStyle buttonM = _base(14, 20, FontWeight.w500);
  static final TextStyle buttonS = _base(13, 18, FontWeight.w500);
  static final TextStyle buttonXs = _base(12, 18, FontWeight.w500);

  // ── Caps (Bold, 5% spacing) ──
  static final TextStyle capsM = _base(12, 16, FontWeight.w700, spacingPct: 0.05);
  static final TextStyle capsS = _base(11, 16, FontWeight.w700, spacingPct: 0.05);
}
