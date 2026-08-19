import 'package:amanah/core/theme/app_colors.dart';
import 'package:amanah/core/theme/app_spacing.dart';
import 'package:amanah/core/theme/app_text_styles.dart';
import 'package:flutter/material.dart';

/// Primary action button. Blue/filled when enabled, white/outlined when
/// disabled ([onPressed] null), spinner while [loading]. Full-width, 44pt tall
/// by default. Used for Save / Submit again / Complete audit.
class AppButton extends StatelessWidget {
  const AppButton({
    required this.label,
    required this.onPressed,
    this.loading = false,
    this.height = 44,
    super.key,
  });

  final String label;

  /// Null disables the button (renders the white/outlined state).
  final VoidCallback? onPressed;
  final bool loading;
  final double height;

  @override
  Widget build(BuildContext context) {
    final enabled = onPressed != null && !loading;
    final filled = enabled || loading;

    return SizedBox(
      height: height,
      width: double.infinity,
      child: Material(
        color: filled ? AppColors.bgBrandBold : AppColors.bgDefault,
        borderRadius: BorderRadius.circular(AppRadius.md),
        child: InkWell(
          onTap: enabled ? onPressed : null,
          borderRadius: BorderRadius.circular(AppRadius.md),
          child: DecoratedBox(
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(AppRadius.md),
              border: filled
                  ? null
                  : Border.all(color: AppColors.borderDefault),
            ),
            child: Center(
              child: loading
                  ? const SizedBox(
                      width: 22,
                      height: 22,
                      child: CircularProgressIndicator(
                        strokeWidth: 2,
                        color: AppColors.brandOnPrimary,
                      ),
                    )
                  : Padding(
                      padding: const EdgeInsets.symmetric(
                        horizontal: AppSpacing.s4,
                      ),
                      child: Text(
                        label,
                        maxLines: 1,
                        overflow: TextOverflow.ellipsis,
                        style: AppText.buttonL.copyWith(
                          color: filled
                              ? AppColors.brandOnPrimary
                              : AppColors.textDefault,
                        ),
                      ),
                    ),
            ),
          ),
        ),
      ),
    );
  }
}
