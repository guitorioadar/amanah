import 'dart:io';

import 'package:amanah/core/theme/app_colors.dart';
import 'package:amanah/core/theme/app_spacing.dart';
import 'package:amanah/core/widgets/skeletons/thumb_shimmer.dart';
import 'package:amanah/core/widgets/thumb_error.dart';
import 'package:amanah/core/widgets/video_thumbnail_image.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';

/// What kind of receipt an attachment is — decides its preview treatment.
enum ReceiptKind { image, video, document }

const _imageExts = {'jpg', 'jpeg', 'png', 'gif', 'webp', 'heic', 'heif', 'bmp'};
const _videoExts = {'mp4', 'mov', 'avi', 'mkv', 'webm', '3gp', 'm4v'};

/// Classifies a file by its extension (used for locally-picked receipts, which
/// carry no MIME type).
ReceiptKind receiptKindFromName(String name) {
  final dot = name.lastIndexOf('.');
  final ext = dot == -1 ? '' : name.substring(dot + 1).toLowerCase();
  if (_imageExts.contains(ext)) return ReceiptKind.image;
  if (_videoExts.contains(ext)) return ReceiptKind.video;
  return ReceiptKind.document;
}

/// Horizontal strip of receipt thumbnails — same footprint as the observation
/// records strip.
class ExpenseMediaStrip extends StatelessWidget {
  const ExpenseMediaStrip(this.thumbs, {super.key});
  final List<Widget> thumbs;

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      height: 70,
      child: ListView.separated(
        scrollDirection: Axis.horizontal,
        itemCount: thumbs.length,
        separatorBuilder: (_, _) => const SizedBox(width: AppSpacing.s2),
        itemBuilder: (_, i) => thumbs[i],
      ),
    );
  }
}

/// A single 110×70 rounded receipt thumbnail. Videos get a play overlay;
/// [onRemove] adds a delete badge (create flow); [onTap] opens the viewer.
class ExpenseMediaThumb extends StatelessWidget {
  const ExpenseMediaThumb._({
    required this.child,
    required this.isVideo,
    this.onRemove,
    this.onTap,
  });

  /// Network image (e.g. an uploaded receipt on the detail screen).
  factory ExpenseMediaThumb.networkImage(
    String url, {
    VoidCallback? onTap,
  }) =>
      ExpenseMediaThumb._(
        isVideo: false,
        onTap: onTap,
        child: CachedNetworkImage(
          imageUrl: url,
          fit: BoxFit.cover,
          placeholder: (_, _) => const ThumbShimmer(),
          errorWidget: (_, _, _) => const ThumbError(),
        ),
      );

  /// Locally-picked image file (create flow).
  factory ExpenseMediaThumb.fileImage(
    String path, {
    VoidCallback? onRemove,
    VoidCallback? onTap,
  }) =>
      ExpenseMediaThumb._(
        isVideo: false,
        onRemove: onRemove,
        onTap: onTap,
        child: Image.file(File(path), fit: BoxFit.cover),
      );

  /// Locally-picked or remote video (thumbnail extracted from the source).
  factory ExpenseMediaThumb.video(
    String source, {
    VoidCallback? onRemove,
    VoidCallback? onTap,
  }) =>
      ExpenseMediaThumb._(
        isVideo: true,
        onRemove: onRemove,
        onTap: onTap,
        child: VideoThumbnailImage(source: source),
      );

  final Widget child;
  final bool isVideo;
  final VoidCallback? onRemove;
  final VoidCallback? onTap;

  @override
  Widget build(BuildContext context) {
    final thumb = SizedBox(
      width: 110,
      height: 70,
      child: Stack(
        fit: StackFit.expand,
        children: [
          ClipRRect(
            borderRadius: BorderRadius.circular(AppRadius.md),
            child: child,
          ),
          if (isVideo)
            const Center(
              child: Icon(
                Icons.play_circle_fill,
                size: 32,
                color: AppColors.iconInverse,
              ),
            ),
          if (onRemove != null)
            Positioned(
              top: 4,
              right: 4,
              child: GestureDetector(
                onTap: onRemove,
                child: Container(
                  padding: const EdgeInsets.all(2),
                  decoration: const BoxDecoration(
                    shape: BoxShape.circle,
                    color: AppColors.bgSolid,
                  ),
                  child: const Icon(
                    Icons.close,
                    size: 14,
                    color: AppColors.iconInverse,
                  ),
                ),
              ),
            ),
        ],
      ),
    );
    if (onTap == null) return thumb;
    return GestureDetector(
      onTap: onTap,
      behavior: HitTestBehavior.opaque,
      child: thumb,
    );
  }
}
