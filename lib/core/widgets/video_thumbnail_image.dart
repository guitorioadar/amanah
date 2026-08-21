import 'dart:async';
import 'dart:io';

import 'package:amanah/core/theme/app_colors.dart';
import 'package:amanah/core/widgets/skeletons/thumb_shimmer.dart';
import 'package:flutter/material.dart';
import 'package:path_provider/path_provider.dart';
import 'package:video_thumbnail_gdx_plus/video_thumbnail_gdx_plus.dart';

/// Generates and shows the first-frame thumbnail of a video (remote URL or
/// local path) via the `video_thumbnail` plugin. Falls back to a solid play
/// tile when generation fails (unsupported codec, network error, etc.).
///
/// Generated JPEGs are cached twice: on disk in the temp dir (keyed by an
/// md5 of the source, handled by the plugin) and in this static in-memory
/// map, so remounting a thumbnail (sheet rebuilds, scrolling) reuses the
/// existing file instead of re-running the native extractor.
class VideoThumbnailImage extends StatefulWidget {
  const VideoThumbnailImage({required this.source, super.key});

  /// File path (local) or URL (remote) of the video.
  final String source;

  @override
  State<VideoThumbnailImage> createState() => _VideoThumbnailImageState();
}

class _VideoThumbnailImageState extends State<VideoThumbnailImage> {
  /// Session-level source → generated JPEG path cache.
  static final Map<String, String> _cache = {};

  File? _file;
  bool _failed = false;

  @override
  void initState() {
    super.initState();
    unawaited(_generate());
  }

  Future<void> _generate() async {
    final cached = _cache[widget.source];
    if (cached != null && File(cached).existsSync()) {
      if (mounted) setState(() => _file = File(cached));
      return;
    }
    try {
      final dir = await getTemporaryDirectory();
      final path = await VideoThumbnail.thumbnailFile(
        video: widget.source,
        thumbnailPath: dir.path,
        maxHeight: 320,
        quality: 75,
      );
      if (!mounted) return;
      if (path == null) {
        setState(() => _failed = true);
      } else {
        _cache[widget.source] = path;
        setState(() => _file = File(path));
      }
    } on Object catch (_) {
      if (mounted) setState(() => _failed = true);
    }
  }

  @override
  Widget build(BuildContext context) {
    final file = _file;
    if (file != null) {
      return Image.file(file, fit: BoxFit.cover,
          errorBuilder: (_, _, _) => const _Fallback());
    }
    if (_failed) return const _Fallback();
    return const ThumbShimmer();
  }
}

/// Solid tile with a play glyph — used until generation finishes/fails or
/// when it errors out. Callers overlay their own play badge; this only
/// guarantees no blank cell.
class _Fallback extends StatelessWidget {
  const _Fallback();

  @override
  Widget build(BuildContext context) {
    return const ColoredBox(color: AppColors.bgSolid);
  }
}
