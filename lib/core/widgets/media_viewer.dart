import 'dart:async';
import 'dart:io';

import 'package:amanah/core/theme/app_spacing.dart';
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
/// Images pinch-to-zoom; videos have play/pause + a scrub bar with timings.
/// Drag the media up or down to dismiss.
Future<void> showMediaViewer(
  BuildContext context, {
  required List<MediaItem> items,
  int initialIndex = 0,
}) {
  if (items.isEmpty) return Future<void>.value();
  return Navigator.of(context).push(
    PageRouteBuilder<void>(
      opaque: false,
      barrierColor: Colors.transparent,
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
  late final PageController _pageController =
      PageController(initialPage: widget.initialIndex);
  late int _index = widget.initialIndex;

  /// Vertical drag offset for the swipe-to-dismiss gesture.
  double _dragDy = 0;

  /// Distance past which releasing the drag dismisses the viewer.
  static const _dismissThreshold = 120.0;

  @override
  void dispose() {
    _pageController.dispose();
    super.dispose();
  }

  void _onDragUpdate(DragUpdateDetails d) {
    setState(() => _dragDy += d.delta.dy);
  }

  void _onDragEnd(DragEndDetails d) {
    final velocity = d.primaryVelocity ?? 0;
    if (_dragDy.abs() > _dismissThreshold || velocity.abs() > 700) {
      Navigator.of(context).pop();
    } else {
      setState(() => _dragDy = 0);
    }
  }

  @override
  Widget build(BuildContext context) {
    final size = MediaQuery.sizeOf(context);
    final dragFraction = (_dragDy.abs() / (size.height * 0.6)).clamp(0.0, 1.0);
    // Fade the backdrop and slightly shrink the media as it's dragged away.
    final bgOpacity = 1 - dragFraction * 0.9;
    final scale = 1 - dragFraction * 0.1;
    final multiple = widget.items.length > 1;
    final topInset = MediaQuery.paddingOf(context).top;

    return Scaffold(
      backgroundColor: Colors.transparent,
      body: Stack(
        children: [
          Positioned.fill(
            child: ColoredBox(color: Colors.black.withValues(alpha: bgOpacity)),
          ),
          // Media pager — translated + scaled by the dismiss drag.
          Transform.translate(
            offset: Offset(0, _dragDy),
            child: Transform.scale(
              scale: scale,
              child: GestureDetector(
                onVerticalDragUpdate: _onDragUpdate,
                onVerticalDragEnd: _onDragEnd,
                child: PageView.builder(
                  controller: _pageController,
                  itemCount: widget.items.length,
                  onPageChanged: (i) => setState(() => _index = i),
                  itemBuilder: (_, i) {
                    final item = widget.items[i];
                    return item.isVideo
                        ? _VideoPage(item: item)
                        : _ImagePage(item: item);
                  },
                ),
              ),
            ),
          ),
          Positioned(
            top: topInset + 8,
            left: 8,
            child: _RoundIcon(
              icon: Icons.close,
              onTap: () => Navigator.of(context).pop(),
            ),
          ),
          if (multiple)
            Positioned(
              top: topInset + 16,
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

/// Pinch/pan-zoomable image page (network or local). Panning is enabled only
/// while zoomed in, so a plain vertical drag at rest reaches the dismiss
/// gesture instead of being swallowed by the viewer.
class _ImagePage extends StatefulWidget {
  const _ImagePage({required this.item});
  final MediaItem item;

  @override
  State<_ImagePage> createState() => _ImagePageState();
}

class _ImagePageState extends State<_ImagePage> {
  final _transform = TransformationController();
  bool _zoomed = false;

  @override
  void initState() {
    super.initState();
    _transform.addListener(_onTransform);
  }

  void _onTransform() {
    final zoomed = _transform.value.getMaxScaleOnAxis() > 1.01;
    if (zoomed != _zoomed) setState(() => _zoomed = zoomed);
  }

  @override
  void dispose() {
    _transform
      ..removeListener(_onTransform)
      ..dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final item = widget.item;
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
      transformationController: _transform,
      minScale: 1,
      maxScale: 4,
      panEnabled: _zoomed,
      child: Center(child: image),
    );
  }
}

/// Video page: initializes the controller, auto-plays, and shows a control bar
/// (play/pause, elapsed / total time, scrub bar).
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
        child: Icon(Icons.error_outline, color: Colors.white54, size: 48),
      );
    }
    if (!_ready) {
      return const Center(
        child: CircularProgressIndicator(color: Colors.white),
      );
    }
    return Stack(
      alignment: Alignment.center,
      children: [
        Center(
          child: AspectRatio(
            aspectRatio: _controller.value.aspectRatio,
            child: VideoPlayer(_controller),
          ),
        ),
        // Center play affordance only while paused (tap the frame to toggle).
        GestureDetector(
          onTap: _toggle,
          behavior: HitTestBehavior.opaque,
          child: ValueListenableBuilder<VideoPlayerValue>(
            valueListenable: _controller,
            builder: (_, value, _) => AnimatedOpacity(
              opacity: value.isPlaying ? 0 : 1,
              duration: const Duration(milliseconds: 150),
              child: const Icon(
                Icons.play_circle_fill,
                size: 72,
                color: Colors.white70,
              ),
            ),
          ),
        ),
        Positioned(
          left: 0,
          right: 0,
          bottom: AppSpacing.s9,
          child: _VideoControls(controller: _controller, onToggle: _toggle),
        ),
      ],
    );
  }
}

/// Bottom control bar: play/pause button, elapsed time, seek bar, total time.
class _VideoControls extends StatelessWidget {
  const _VideoControls({required this.controller, required this.onToggle});

  final VideoPlayerController controller;
  final VoidCallback onToggle;

  static String _fmt(Duration d) {
    final m = d.inMinutes.remainder(60).toString().padLeft(2, '0');
    final s = d.inSeconds.remainder(60).toString().padLeft(2, '0');
    final h = d.inHours;
    return h > 0 ? '$h:$m:$s' : '$m:$s';
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: EdgeInsets.only(
        left: 8,
        right: 16,
        top: 8,
        bottom: MediaQuery.paddingOf(context).bottom + 12,
      ),
      decoration: const BoxDecoration(
        gradient: LinearGradient(
          begin: Alignment.topCenter,
          end: Alignment.bottomCenter,
          colors: [Colors.transparent, Colors.black54],
        ),
      ),
      child: ValueListenableBuilder<VideoPlayerValue>(
        valueListenable: controller,
        builder: (_, value, _) {
          final total = value.duration;
          final pos = value.position > total ? total : value.position;
          return Row(
            children: [
              IconButton(
                onPressed: onToggle,
                icon: Icon(
                  value.isPlaying ? Icons.pause : Icons.play_arrow,
                  color: Colors.white,
                  size: 28,
                ),
              ),
              Text(
                _fmt(pos),
                style: const TextStyle(color: Colors.white, fontSize: 12),
              ),
              const SizedBox(width: 8),
              Expanded(
                child: VideoProgressIndicator(
                  controller,
                  allowScrubbing: true,
                  padding: const EdgeInsets.symmetric(vertical: 8),
                  colors: const VideoProgressColors(
                    playedColor: Colors.white,
                    bufferedColor: Colors.white38,
                    backgroundColor: Colors.white24,
                  ),
                ),
              ),
              const SizedBox(width: 8),
              Text(
                _fmt(total),
                style: const TextStyle(color: Colors.white, fontSize: 12),
              ),
            ],
          );
        },
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
