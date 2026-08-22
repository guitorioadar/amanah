import 'package:amanah/core/theme/app_colors.dart';
import 'package:amanah/core/theme/app_spacing.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:go_router/go_router.dart';

/// Rounded-square back button used on the onboarding screens.
class AppBackButton extends StatelessWidget {
  const AppBackButton({this.onTap, super.key});

  final VoidCallback? onTap;

  @override
  Widget build(BuildContext context) {
    return Material(
      color: AppColors.bgPressed,
      borderRadius: BorderRadius.circular(AppRadius.md),
      child: InkWell(
        borderRadius: BorderRadius.circular(AppRadius.md),
        onTap: onTap ?? () => context.pop(),
        child: Padding(
          padding: const EdgeInsets.all(AppSpacing.s3),
          child: SvgPicture.asset(
            'assets/icons/line/CaretLeft.svg',
            width: 24,
            colorFilter: const ColorFilter.mode(
              AppColors.iconSubtlest,
              BlendMode.srcIn,
            ),
          ),
        ),
      ),
    );
  }
}
