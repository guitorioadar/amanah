import 'dart:async';
import 'dart:io';

import 'package:amanah/core/widgets/video_player_view.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';

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

  /// Whether the close button / counter chrome is showing. Hidden initially;
  /// a tap toggles it (images) or follows the video control overlay (videos).
  bool _chromeVisible = false;

  /// Whether the CURRENT page's image is zoomed in (lifted from the page so
  /// the pager can stop horizontal swiping while the user pans the image).
  bool _imageZoomed = false;

  /// Fingers currently on the media area. While > 1 (pinch) the dismiss drag
  /// and page swiping step aside so the pinch always wins the gesture arena.
  int _pointers = 0;

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

  /// Video pages drive the chrome through the player's control overlay.
  void _onVideoControlsVisibility(bool visible) {
    if (mounted) setState(() => _chromeVisible = visible);
  }

  void _onPointerDown(PointerDownEvent _) {
    if (_pointers == 0) setState(() => _pointers = 1);
  }

  void _onPointerUp(PointerUpEvent _) {
    if (_pointers > 0) setState(() => _pointers = 0);
  }

  /// True while a pinch is in flight or the image is zoomed: the dismiss
  /// drag, page swiping, and chrome-toggle tap must not fire then.
  bool get _mediaLocked => _pointers >= 2 || _imageZoomed;

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
          // Media pager — translated + scaled by the dismiss drag. The
          // Listener counts fingers: with 2+ down (a pinch) the dismiss drag
          // and page swiping stand down so the pinch wins.
          Transform.translate(
            offset: Offset(0, _dragDy),
            child: Transform.scale(
              scale: scale,
              child: Listener(
                onPointerDown: _onPointerDown,
                onPointerUp: _onPointerUp,
                child: GestureDetector(
                  onVerticalDragUpdate: _mediaLocked ? null : _onDragUpdate,
                  onVerticalDragEnd: _mediaLocked ? null : _onDragEnd,
                  child: PageView.builder(
                    controller: _pageController,
                    physics: _mediaLocked
                        ? const NeverScrollableScrollPhysics()
                        : const PageScrollPhysics(),
                    itemCount: widget.items.length,
                    onPageChanged: (i) => setState(() => _index = i),
                    itemBuilder: (_, i) {
                      final item = widget.items[i];
                      return item.isVideo
                          ? VideoPlayerView(
                              source: item.source,
                              isLocal: item.isLocal,
                              onControlsVisibilityChanged:
                                  _onVideoControlsVisibility,
                            )
                          : _ImagePage(
                              item: item,
                              onTap: () => setState(
                                () => _chromeVisible = !_chromeVisible,
                              ),
                              onZoomedChanged: (z) =>
                                  setState(() => _imageZoomed = z),
                            );
                    },
                  ),
                ),
              ),
            ),
          ),
          AnimatedOpacity(
            opacity: _chromeVisible ? 1 : 0,
            duration: const Duration(milliseconds: 200),
            child: IgnorePointer(
              ignoring: !_chromeVisible,
              child: Stack(
                children: [
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
            ),
          ),
        ],
      ),
    );
  }
}

/// Pinch/pan-zoomable image page (network or local). Double-tap toggles
/// between 1x and a tap-point-anchored 2.5x; a single tap toggles the viewer
/// chrome. Panning is enabled only while zoomed in, so a plain vertical drag
/// at rest reaches the dismiss gesture instead of being swallowed here.
class _ImagePage extends StatefulWidget {
  const _ImagePage({
    required this.item,
    required this.onTap,
    required this.onZoomedChanged,
  });

  final MediaItem item;
  final VoidCallback onTap;
  final ValueChanged<bool> onZoomedChanged;

  @override
  State<_ImagePage> createState() => _ImagePageState();
}

class _ImagePageState extends State<_ImagePage>
    with TickerProviderStateMixin {
  final _transform = TransformationController();
  bool _zoomed = false;
  // Both are created lazily per double-tap and replaced on each new one, so
  // they stay nullable despite what the lint suggests.
  // ignore: use_late_for_private_fields_and_variables
  Matrix4Tween? _tween;
  // Same reason as _tween above.
  AnimationController? _anim;
  // The most recent double-tap's down position; consumed by the zoom handler.
  // ignore: use_late_for_private_fields_and_variables
  TapDownDetails? _lastDoubleTapDown;

  static const _doubleTapScale = 2.5;

  @override
  void initState() {
    super.initState();
    _transform.addListener(_onTransform);
  }

  void _onTransform() {
    final zoomed = _transform.value.getMaxScaleOnAxis() > 1.01;
    if (zoomed != _zoomed) {
      setState(() => _zoomed = zoomed);
      widget.onZoomedChanged(zoomed);
    }
  }

  /// Double-tap: zoom to 2.5x anchored at the tapped point (or reset), with
  /// a short animated tween instead of an abrupt jump.
  void _onDoubleTap(TapDownDetails d) {
    const s = _doubleTapScale;
    if (_transform.value.getMaxScaleOnAxis() > 1.01) {
      _animateTo(Matrix4.identity());
    } else {
      // Scale about the tapped point: translate by p*(1-s) so p stays fixed.
      // Entries are set directly — scaleByDouble(s,s,s,s) would also scale the
      // homogeneous w row, and the pipeline's w-division cancels the zoom.
      final p = d.localPosition;
      final target = Matrix4.identity()
        ..setEntry(0, 0, s)
        ..setEntry(1, 1, s)
        ..setEntry(0, 3, p.dx * (1 - s))
        ..setEntry(1, 3, p.dy * (1 - s));
      _animateTo(target);
    }
  }

  void _animateTo(Matrix4 target) {
    _anim?.dispose();
    _tween = Matrix4Tween(begin: _transform.value, end: target);
    final controller = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 250),
    );
    controller.addListener(() {
      _transform.value = _tween!.evaluate(controller);
    });
    _anim = controller;
    unawaited(controller.forward());
  }

  @override
  void dispose() {
    _anim?.dispose();
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
    // Both taps on ONE detector: Flutter then holds the single tap until the
    // double-tap window closes, so a real double-tap never toggles the chrome.
    return GestureDetector(
      onTap: widget.onTap,
      onDoubleTapDown: (d) => _lastDoubleTapDown = d,
      onDoubleTap: () => _onDoubleTap(_lastDoubleTapDown!),
      behavior: HitTestBehavior.opaque,
      child: InteractiveViewer(
        transformationController: _transform,
        minScale: 1,
        maxScale: 4,
        panEnabled: _zoomed,
        child: Center(child: image),
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
