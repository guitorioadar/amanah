import 'package:amanah/core/widgets/image_page_view.dart';
import 'package:amanah/core/widgets/video_player_view.dart';
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
                          : ImagePageView(
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
