import 'package:flutter/material.dart';

/// Raw primitive color scales — the transcription of `Color palette.png`
/// (light values). **Never referenced directly by widgets**; only the
/// semantic tokens in AppColors read from here.
///
/// See `Docs & Resources/03 - Design System.md` §2.
abstract final class AppPalette {
  // ── Brand (from logo.png / Sign in CTA — ground truth) ──
  /// Primary royal-blue used by the logo and every primary button.
  static const brand = Color(0xFF2263F0);

  // ── Neutral (text, surfaces, borders) ──
  static const neutral1 = Color(0xFFFFFFFF);
  static const neutral2 = Color(0xFFF7F8F9);
  static const neutral3 = Color(0xFFF3F4F5);
  static const neutral4 = Color(0xFFDCDFE4);
  static const neutral5 = Color(0xFFB3B9C4);
  static const neutral6 = Color(0xFF8590A2);
  static const neutral7 = Color(0xFF758195);
  static const neutral8 = Color(0xFF626F86);
  static const neutral9 = Color(0xFF44546F);
  static const neutral10 = Color(0xFF2C3E5D);
  static const neutral11 = Color(0xFF172B4D);
  static const neutral12 = Color(0xFF091E42);

  // ── Cyan (secondary/teal accent) ──
  static const cyan3 = Color(0xFFDEF7F9);
  static const cyan4 = Color(0xFFCAF1F6);
  static const cyan5 = Color(0xFFB5E9F0);
  static const cyan10 = Color(0xFF0797B9);
  static const cyan11 = Color(0xFF107D98);
  static const cyan12 = Color(0xFF0D3C48);

  // ── Blue (information / focus) ──
  static const blue3 = Color(0xFFE6F4FE);
  static const blue4 = Color(0xFFD5EFFF);
  static const blue5 = Color(0xFFC2E5FF);
  static const blue8 = Color(0xFF5EB1EF);
  static const blue10 = Color(0xFF0588F0);
  static const blue11 = Color(0xFF106EC0);
  static const blue12 = Color(0xFF113264);

  // ── Red (danger) ──
  static const red3 = Color(0xFFFEEBEC);
  static const red4 = Color(0xFFFFDBDC);
  static const red5 = Color(0xFFFFCDCE);
  static const red10 = Color(0xFFDC3E42);
  static const red11 = Color(0xFFCE2C31);
  static const red12 = Color(0xFF641723);

  // ── Orange (warning) ──
  static const orange3 = Color(0xFFFFEFD6);
  static const orange4 = Color(0xFFFFDFB5);
  static const orange5 = Color(0xFFFFD19A);
  static const orange10 = Color(0xFFEF5F00);
  static const orange11 = Color(0xFFCC4E00);
  static const orange12 = Color(0xFF582D1D);

  // ── Green (success) ──
  static const green3 = Color(0xFFE6F6EB);
  static const green4 = Color(0xFFD6F1DF);
  static const green5 = Color(0xFFC4E8D1);
  static const green10 = Color(0xFF2B9A66);
  static const green11 = Color(0xFF218358);
  static const green12 = Color(0xFF193B2D);

  // ── Purple (discovery) ──
  static const purple7 = Color(0xFFD1AFEC);
  static const purple9 = Color(0xFF8E4EC6);
  static const purple10 = Color(0xFF8347B9);

  // ── Magenta (profile "Terms & conditions" accent) ──
  static const magenta10 = Color(0xFFD6409F);
}
