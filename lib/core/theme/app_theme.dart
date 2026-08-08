import 'package:amanah/core/theme/app_colors.dart';
import 'package:amanah/core/theme/app_spacing.dart';
import 'package:amanah/core/theme/app_text_styles.dart';
import 'package:flutter/material.dart';

/// Assembles [ThemeData] from the design tokens. Single light theme in v1.
abstract final class AppTheme {
  static ThemeData get light {
    final scheme = ColorScheme.fromSeed(
      seedColor: AppColors.brand,
      surface: AppColors.bgDefault,
    ).copyWith(
      primary: AppColors.brand,
      onPrimary: AppColors.brandOnPrimary,
      error: AppColors.textDanger,
    );

    return ThemeData(
      useMaterial3: true,
      colorScheme: scheme,
      scaffoldBackgroundColor: AppColors.bgDefault,
      textTheme: _textTheme,
      appBarTheme: const AppBarTheme(
        backgroundColor: AppColors.bgDefault,
        surfaceTintColor: Colors.transparent,
        elevation: 0,
        centerTitle: false,
      ),
      elevatedButtonTheme: ElevatedButtonThemeData(
        style: ElevatedButton.styleFrom(
          backgroundColor: AppColors.bgBrandBold,
          foregroundColor: AppColors.brandOnPrimary,
          disabledBackgroundColor: AppColors.borderDisabled,
          minimumSize: const Size.fromHeight(52),
          elevation: 0,
          textStyle: AppText.buttonL,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(AppRadius.md),
          ),
        ),
      ),
      inputDecorationTheme: InputDecorationTheme(
        filled: true,
        fillColor: AppColors.bgDefault,
        contentPadding: const EdgeInsets.symmetric(
          horizontal: AppSpacing.s4,
          vertical: AppSpacing.s4,
        ),
        hintStyle: AppText.bodyLRegular.copyWith(color: AppColors.textSubtlest),
        enabledBorder: _border(AppColors.borderDefault),
        focusedBorder: _border(AppColors.borderFocus, width: 1.5),
        errorBorder: _border(AppColors.borderDanger),
        focusedErrorBorder: _border(AppColors.borderDanger, width: 1.5),
        disabledBorder: _border(AppColors.borderDisabled),
      ),
    );
  }

  static OutlineInputBorder _border(Color color, {double width = 1}) {
    return OutlineInputBorder(
      borderRadius: BorderRadius.circular(AppRadius.md),
      borderSide: BorderSide(color: color, width: width),
    );
  }

  static TextTheme get _textTheme => TextTheme(
        displayLarge: AppText.headingXl,
        headlineMedium: AppText.headingL,
        headlineSmall: AppText.headingM,
        titleLarge: AppText.headingS,
        titleMedium: AppText.headingXs,
        bodyLarge: AppText.bodyLRegular,
        bodyMedium: AppText.bodyMRegular,
        bodySmall: AppText.bodySRegular,
        labelLarge: AppText.buttonL,
      );
}
