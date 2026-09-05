import 'package:amanah/core/theme/app_colors.dart';
import 'package:amanah/core/theme/app_spacing.dart';
import 'package:amanah/core/theme/app_text_styles.dart';
import 'package:flutter/material.dart';

/// A labeled upload progress bar ("Uploading… 42%") shown while multipart
/// files are being sent. [value] is 0..1.
class UploadProgress extends StatelessWidget {
  const UploadProgress(this.value, {super.key});

  final double value;

  @override
  Widget build(BuildContext context) {
    // Once the bytes are all sent, the wait that remains is the server
    // processing the response — which the client can't measure. Switch to an
    // indeterminate "Processing…" bar so it clearly keeps working, rather than
    // sitting at a frozen 100%.
    final sending = value < 1.0;

    if (!sending) {
      // Processing: indeterminate bar, nothing to animate.
      return _layout(
        label: 'Processing…',
        percentText: null,
        barValue: null,
      );
    }

    // Progress arrives in discrete jumps (10% → 20% → 70%). Tween between the
    // last rendered value and the new one so the bar (and %) glides instead of
    // snapping. TweenAnimationBuilder keeps its own state, so on each rebuild it
    // animates from where it currently is to the new [value].
    return TweenAnimationBuilder<double>(
      tween: Tween<double>(begin: 0, end: value.clamp(0.0, 1.0)),
      duration: const Duration(milliseconds: 300),
      curve: Curves.easeOut,
      builder: (context, animated, _) => _layout(
        label: 'Uploading…',
        percentText: '${(animated * 100).round()}%',
        barValue: animated,
      ),
    );
  }

  Widget _layout({
    required String label,
    required String? percentText,
    required double? barValue,
  }) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: [
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Text(
              label,
              style: AppText.bodyMRegular.copyWith(color: AppColors.textSubtle),
            ),
            if (percentText != null)
              Text(
                percentText,
                style:
                    AppText.bodyMMedium.copyWith(color: AppColors.textDefault),
              ),
          ],
        ),
        const SizedBox(height: AppSpacing.s2),
        ClipRRect(
          borderRadius: BorderRadius.circular(AppRadius.sm),
          child: LinearProgressIndicator(
            // Null = indeterminate (while the server processes).
            value: barValue,
            minHeight: 6,
            backgroundColor: AppColors.bgHovered,
            color: AppColors.brand,
          ),
        ),
      ],
    );
  }
}
