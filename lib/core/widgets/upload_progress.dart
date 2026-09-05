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

    return Column(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: [
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Text(
              sending ? 'Uploading…' : 'Processing…',
              style: AppText.bodyMRegular.copyWith(color: AppColors.textSubtle),
            ),
            if (sending)
              Text(
                '${(value * 100).round()}%',
                style:
                    AppText.bodyMMedium.copyWith(color: AppColors.textDefault),
              ),
          ],
        ),
        const SizedBox(height: AppSpacing.s2),
        ClipRRect(
          borderRadius: BorderRadius.circular(AppRadius.sm),
          child: LinearProgressIndicator(
            // Indeterminate (null) while the server processes.
            value: sending ? value.clamp(0.0, 1.0) : null,
            minHeight: 6,
            backgroundColor: AppColors.bgHovered,
            color: AppColors.brand,
          ),
        ),
      ],
    );
  }
}
