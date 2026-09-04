import 'dart:async';

import 'package:amanah/core/media/media_converter.dart';
import 'package:amanah/core/theme/app_colors.dart';
import 'package:amanah/core/theme/app_spacing.dart';
import 'package:amanah/core/theme/app_text_styles.dart';
import 'package:flutter/material.dart';
import 'package:toastification/toastification.dart';

/// What a picked file is, so [prepareMedia] knows how to convert it.
enum MediaPrepKind { video, image, document }

/// Converts a freshly picked file to a backend-accepted format (mp4 / jpg),
/// shows a conversion progress dialog while it works, and enforces the 100 MB
/// cap. Returns the path to send to the backend, or `null` when it failed or
/// exceeded the limit (the reason is surfaced to the user via a toast).
///
/// Documents are passed through unchanged (no conversion, no size cap).
Future<String?> prepareMedia(
  BuildContext context, {
  required String path,
  required MediaPrepKind kind,
}) async {
  final needsVideo =
      kind == MediaPrepKind.video && MediaConverter.isVideoConversionNeeded(path);
  final needsImage =
      kind == MediaPrepKind.image && MediaConverter.isImageConversionNeeded(path);

  // null value = indeterminate spinner (image); 0..1 = video progress bar.
  final progress = ValueNotifier<double?>(needsVideo ? 0.0 : null);
  var dialogOpen = false;
  if (needsVideo || needsImage) {
    dialogOpen = true;
    unawaited(
      showDialog<void>(
        context: context,
        barrierDismissible: false,
        builder: (_) => _ConversionDialog(
          progress: progress,
          label: needsVideo ? 'Converting video' : 'Converting image',
        ),
      ),
    );
  }

  void closeDialog() {
    if (dialogOpen && context.mounted) {
      Navigator.of(context, rootNavigator: true).pop();
    }
    dialogOpen = false;
  }

  String out;
  try {
    if (needsVideo) {
      out = await MediaConverter.ensureMp4(
        path,
        onProgress: (v) => progress.value = v,
      );
    } else if (needsImage) {
      out = await MediaConverter.ensureJpgOrPng(path);
    } else {
      out = path;
    }
  } on Object {
    closeDialog();
    progress.dispose();
    if (context.mounted) {
      _toast(context, 'Could not convert the file. Try another.');
    }
    return null;
  }

  closeDialog();
  progress.dispose();

  if (kind != MediaPrepKind.document) {
    if (!await MediaConverter.withinLimit(out)) {
      if (context.mounted) {
        _toast(context, 'Files must be under 100 MB.');
      }
      return null;
    }
  }
  return out;
}

void _toast(BuildContext context, String message) {
  toastification.show(
    context: context,
    type: ToastificationType.error,
    style: ToastificationStyle.flat,
    title: Text(message),
    alignment: Alignment.bottomCenter,
    autoCloseDuration: const Duration(seconds: 3),
  );
}

class _ConversionDialog extends StatelessWidget {
  const _ConversionDialog({required this.progress, required this.label});

  final ValueNotifier<double?> progress;
  final String label;

  @override
  Widget build(BuildContext context) {
    return AlertDialog(
      backgroundColor: AppColors.bgDefault,
      content: ValueListenableBuilder<double?>(
        valueListenable: progress,
        builder: (_, value, _) => Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              value == null ? label : '$label ${(value * 100).round()}%',
              style: AppText.bodyMMedium.copyWith(color: AppColors.textDefault),
            ),
            const SizedBox(height: AppSpacing.s3),
            ClipRRect(
              borderRadius: BorderRadius.circular(AppRadius.sm),
              child: LinearProgressIndicator(
                value: value,
                minHeight: 6,
                backgroundColor: AppColors.bgHovered,
                color: AppColors.brand,
              ),
            ),
          ],
        ),
      ),
    );
  }
}
