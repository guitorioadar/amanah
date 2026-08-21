import 'dart:async';
import 'dart:io';

import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:video_player/video_player.dart';

/// A single previewable media item (photo or video), remote or local.
class MediaItem {
  const MediaItem.networkImage(this.source)
      : isVideo = false,
        isLocal = false;
  const MediaItem.fileImage(this.source)
      : isVideo = false,
        isLocal = true;
  const MediaItem.networkVideo(this.source)
      : isVideo = true,
        isLocal = false;
  const MediaItem.fileVideo(this.source)
      : isVideo = true,
        isLocal = true;

  /// URL (remote) or file path (local).
  final String source;
  final bool isVideo;
  final bool isLocal;
}

/// Opens a full-screen, swipeable media gallery starting at [initialIndex].
/// Images pinch-to-zoom; videos play with tap-to-toggle and a scrub bar.
Future<void> showMediaViewer(
  BuildContext context, {
  required List<MediaItem> items,
  int initialIndex = 0,
}) {
  if (items.isEmpty) return Future<void>.value();
  return Navigator.of(context).push(
    PageRouteBuilder<void>(
      opaque: false,
      barrierColor: Colors.black,
      fullscreenDialog: true,
      pageBuilder: (_, _, _) =>
          _MediaViewer(items: items, initialIndex: initialIndex),
    ),
  );
}

class _MediaViewer extends StatefulWidget {
  const _MediaViewer({required this.items, required this.initialIndex});

  final List<MediaItem> items;
  final int initialIndex;

  @override
  State<_MediaViewer> createState() => _MediaViewerState();
}

class _MediaViewerState extends State<_MediaViewer> {
  late final PageController _controller =
      PageController(initialPage: widget.initialIndex);
  late int _index = widget.initialIndex;

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final multiple = widget.items.length > 1;
    return Scaffold(
      backgroundColor: Colors.black,
      body: Stack(
        children: [
          PageView.builder(
            controller: _controller,
            itemCount: widget.items.length,
            onPageChanged: (i) => setState(() => _index = i),
            itemBuilder: (_, i) {
              final item = widget.items[i];
              return item.isVideo
                  ? _VideoPage(item: item)
                  : _ImagePage(item: item);
            },
          ),
          Positioned(
            top: MediaQuery.of(context).padding.top + 8,
            left: 8,
            child: _RoundIcon(
              icon: Icons.close,
              onTap: () => Navigator.of(context).pop(),
            ),
          ),
          if (multiple)
            Positioned(
              top: MediaQuery.of(context).padding.top + 16,
              left: 0,
              right: 0,
              child: Center(
                child: Text(
                  '${_index + 1} / ${widget.items.length}',
                  style: const TextStyle(
                    color: Colors.white,
                    fontSize: 14,
                    fontWeight: FontWeight.w600,
                  ),
                ),
              ),
            ),
        ],
      ),
    );
  }
}

/// Pinch/pan-zoomable image page (network or local).
class _ImagePage extends StatelessWidget {
  const _ImagePage({required this.item});
  final MediaItem item;

  @override
  Widget build(BuildContext context) {
    final image = item.isLocal
        ? Image.file(File(item.source), fit: BoxFit.contain)
        : CachedNetworkImage(
            imageUrl: item.source,
            fit: BoxFit.contain,
            placeholder: (_, _) => const Center(
              child: CircularProgressIndicator(color: Colors.white),
            ),
            errorWidget: (_, _, _) => const Center(
              child: Icon(
                Icons.broken_image_outlined,
                color: Colors.white54,
                size: 48,
              ),
            ),
          );
    return InteractiveViewer(
      minScale: 1,
      maxScale: 4,
      child: Center(child: image),
    );
  }
}

/// Video page: initializes the controller, auto-plays, tap toggles play/pause,
/// and a scrub bar sits at the bottom.
class _VideoPage extends StatefulWidget {
  const _VideoPage({required this.item});
  final MediaItem item;

  @override
  State<_VideoPage> createState() => _VideoPageState();
}

class _VideoPageState extends State<_VideoPage> {
  late final VideoPlayerController _controller = widget.item.isLocal
      ? VideoPlayerController.file(File(widget.item.source))
      : VideoPlayerController.networkUrl(Uri.parse(widget.item.source));
  bool _ready = false;
  Object? _error;

  @override
  void initState() {
    super.initState();
    unawaited(_init());
  }

  Future<void> _init() async {
    try {
      await _controller.initialize();
      if (!mounted) return;
      setState(() => _ready = true);
      await _controller.setLooping(true);
      await _controller.play();
    } on Object catch (e) {
      if (mounted) setState(() => _error = e);
    }
  }

  @override
  void dispose() {
    unawaited(_controller.dispose());
    super.dispose();
  }

  void _toggle() {
    setState(() {
      if (_controller.value.isPlaying) {
        unawaited(_controller.pause());
      } else {
        unawaited(_controller.play());
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    if (_error != null) {
      return const Center(
        child: Icon(
          Icons.error_outline,
          color: Colors.white54,
          size: 48,
        ),
      );
    }
    if (!_ready) {
      return const Center(child: CircularProgressIndicator(color: Colors.white));
    }
    return GestureDetector(
      onTap: _toggle,
      behavior: HitTestBehavior.opaque,
      child: Stack(
        alignment: Alignment.center,
        children: [
          Center(
            child: AspectRatio(
              aspectRatio: _controller.value.aspectRatio,
              child: VideoPlayer(_controller),
            ),
          ),
          // Play indicator only while paused.
          ValueListenableBuilder<VideoPlayerValue>(
            valueListenable: _controller,
            builder: (_, value, _) => value.isPlaying
                ? const SizedBox.shrink()
                : const Icon(
                    Icons.play_circle_fill,
                    size: 72,
                    color: Colors.white70,
                  ),
          ),
          Positioned(
            left: 16,
            right: 16,
            bottom: MediaQuery.of(context).padding.bottom + 24,
            child: VideoProgressIndicator(
              _controller,
              allowScrubbing: true,
              colors: const VideoProgressColors(
                playedColor: Colors.white,
                bufferedColor: Colors.white38,
                backgroundColor: Colors.white24,
              ),
            ),
          ),
        ],
      ),
    );
  }
}

class _RoundIcon extends StatelessWidget {
  const _RoundIcon({required this.icon, required this.onTap});
  final IconData icon;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      behavior: HitTestBehavior.opaque,
      child: Container(
        padding: const EdgeInsets.all(8),
        decoration: const BoxDecoration(
          shape: BoxShape.circle,
          color: Colors.black45,
        ),
        child: Icon(icon, size: 24, color: Colors.white),
      ),
    );
  }
}
