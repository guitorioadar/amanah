/// Spacing & radius scale (4pt base). Convention, not exported — verify per
/// component against Figma. See `03 - Design System.md` §6.
abstract final class AppSpacing {
  static const s1 = 4.0;
  static const s2 = 8.0;
  static const s3 = 12.0;
  static const s4 = 16.0;
  static const s5 = 20.0;
  static const s6 = 24.0;
  static const s7 = 32.0;
  static const s8 = 40.0;
  static const s9 = 48.0;

  /// Default horizontal screen padding.
  static const screenH = 16.0;
}

/// Corner radii.
abstract final class AppRadius {
  static const sm = 8.0;
  static const md = 12.0;
  static const lg = 16.0;
  static const xl = 20.0;
  static const pill = 999.0;
}
