import 'package:amanah/core/theme/app_colors.dart';
import 'package:amanah/core/theme/app_spacing.dart';
import 'package:amanah/core/theme/app_text_styles.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';

/// Illustration + caption shown when a list has no items. Reused across Home
/// (running / upcoming), Notifications, Audits, and Expenses empty states.
///
/// Set [onDark] when placed on the navy header so the caption stays legible.
class EmptyState extends StatelessWidget {
  const EmptyState({
    required this.asset,
    required this.message,
    this.onDark = false,
    this.illustrationSize = 120,
    super.key,
  });

  /// Path to the illustration SVG (e.g. `assets/vectors/Vectors-1.svg`).
  final String asset;
  final String message;
  final bool onDark;
  final double illustrationSize;

  @override
  Widget build(BuildContext context) {
    return Column(
      mainAxisSize: MainAxisSize.min,
      children: [
        SvgPicture.asset(asset, width: illustrationSize),
        const SizedBox(height: AppSpacing.s4),
        Text(
          message,
          textAlign: TextAlign.center,
          style: AppText.bodyLRegular.copyWith(
            color: onDark ? AppColors.textSubtlest : AppColors.textSubtle,
          ),
        ),
      ],
    );
  }
}
