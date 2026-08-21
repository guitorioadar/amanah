import 'dart:async';
import 'dart:io';
import 'dart:ui' show ImageFilter;

import 'package:flutter/material.dart';
import 'package:video_player/video_player.dart';

const Duration _seekStep = Duration(seconds: 5);

/// Brand accent used for the progress fill, thumb, and primary buttons.
const Color _accent = Color(0xFF2263F0);

/// Full-frame video player used inside the media viewer. Initializes the
/// controller, auto-plays/loops, and shows a floating glass control bar
/// (play/pause, 5s seek back/forward, scrub bar, elapsed / total time).
/// Tapping the frame toggles the control overlay, which auto-hides after a
/// short delay while playing and stays visible while paused. Double-tap
/// toggles play/pause.
class VideoPlayerView extends StatefulWidget {
  const VideoPlayerView({
    required this.source,
    required this.isLocal,
    this.onControlsVisibilityChanged,
    super.key,
  });

  /// File path (local) or URL (remote).
  final String source;
  final bool isLocal;

  /// Notified whenever the control overlay shows or hides, so a parent (e.g.
  /// the media viewer chrome) can sync its own overlays to it.
  final ValueChanged<bool>? onControlsVisibilityChanged;

  @override
  State<VideoPlayerView> createState() => _VideoPlayerViewState();
}

class _VideoPlayerViewState extends State<VideoPlayerView> {
  late final VideoPlayerController _controller = widget.isLocal
      ? VideoPlayerController.file(File(widget.source))
      : VideoPlayerController.networkUrl(Uri.parse(widget.source));
  bool _ready = false;
  Object? _error;
  // Starts hidden and is revealed by the post-init ping, which also notifies
  // the parent so viewer chrome fades in together with the overlay.
  bool _controlsVisible = false;
  Timer? _hideTimer;

  static const _hideAfter = Duration(seconds: 15);

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
      if (mounted) _pingControls();
    } on Object catch (e) {
      if (mounted) setState(() => _error = e);
    }
  }

  @override
  void dispose() {
    _hideTimer?.cancel();
    unawaited(_controller.dispose());
    super.dispose();
  }

  /// Shows the controls and, while playing, restarts the auto-hide countdown.
  /// Pass [autoHide] to override the current play state (e.g. right after
  /// calling play/pause, before the controller reports the new value).
  void _pingControls({bool? autoHide}) {
    _hideTimer?.cancel();
    _setControlsVisible(true);
    final shouldHide = autoHide ?? _controller.value.isPlaying;
    if (shouldHide) {
      _hideTimer = Timer(_hideAfter, () {
        // Never hide over a paused frame: the user needs the play button.
        if (mounted && _controller.value.isPlaying) {
          _setControlsVisible(false);
        }
      });
    }
  }

  void _setControlsVisible(bool visible) {
    if (_controlsVisible == visible) return;
    setState(() => _controlsVisible = visible);
    widget.onControlsVisibilityChanged?.call(visible);
  }

  void _onFrameTap() {
    if (_controlsVisible && _controller.value.isPlaying) {
      _hideTimer?.cancel();
      _setControlsVisible(false);
    } else {
      _pingControls();
    }
  }

  void _toggle() {
    final resuming = !_controller.value.isPlaying;
    unawaited(resuming ? _controller.play() : _controller.pause());
    _pingControls(autoHide: resuming);
  }

  /// Seeks to an absolute position, clamped to the video bounds, and keeps
  /// the controls visible (also used by the ±5s buttons and the scrub bar).
  Future<void> _seekTo(Duration target) async {
    final total = _controller.value.duration;
    var clamped = target;
    if (clamped < Duration.zero) clamped = Duration.zero;
    if (clamped > total) clamped = total;
    await _controller.seekTo(clamped);
    if (mounted) _pingControls();
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
        // Tap layer: tap toggles the control overlay, double-tap toggles
        // play/pause. Registering both makes single taps wait ~300ms for the
        // double-tap disambiguation window.
        GestureDetector(
          onTap: _onFrameTap,
          onDoubleTap: _toggle,
          behavior: HitTestBehavior.opaque,
          child: const SizedBox.expand(),
        ),
        // Center play affordance only while paused (tap it to resume).
        ValueListenableBuilder<VideoPlayerValue>(
          valueListenable: _controller,
          builder: (_, value, _) => IgnorePointer(
            ignoring: value.isPlaying,
            child: AnimatedOpacity(
              opacity: value.isPlaying ? 0 : 1,
              duration: const Duration(milliseconds: 150),
              child: _CircleButton(
                size: 72,
                icon: Icons.play_arrow,
                iconSize: 46,
                onTap: _toggle,
              ),
            ),
          ),
        ),
        Positioned(
          left: 16,
          right: 16,
          bottom: MediaQuery.paddingOf(context).bottom + 12,
          child: AnimatedOpacity(
            opacity: _controlsVisible ? 1 : 0,
            duration: const Duration(milliseconds: 200),
            child: IgnorePointer(
              ignoring: !_controlsVisible,
              child: _VideoControls(
                controller: _controller,
                onToggle: _toggle,
                onSeekTo: _seekTo,
              ),
            ),
          ),
        ),
      ],
    );
  }
}

/// Bottom floating control bar: frosted-glass pill holding the scrub bar
/// above a centered button row (5s back, play/pause, 5s forward) flanked by
/// elapsed / total time.
class _VideoControls extends StatelessWidget {
  const _VideoControls({
    required this.controller,
    required this.onToggle,
    required this.onSeekTo,
  });

  final VideoPlayerController controller;
  final VoidCallback onToggle;
  final ValueChanged<Duration> onSeekTo;

  static String _fmt(Duration d) {
    final m = d.inMinutes.remainder(60).toString().padLeft(2, '0');
    final s = d.inSeconds.remainder(60).toString().padLeft(2, '0');
    final h = d.inHours;
    return h > 0 ? '$h:$m:$s' : '$m:$s';
  }

  @override
  Widget build(BuildContext context) {
    return ClipRRect(
      borderRadius: BorderRadius.circular(28),
      child: BackdropFilter(
        filter: ImageFilter.blur(sigmaX: 16, sigmaY: 16),
        child: Container(
          padding: const EdgeInsets.fromLTRB(16, 12, 16, 12),
          decoration: BoxDecoration(
            color: const Color(0x66000000),
            borderRadius: BorderRadius.circular(28),
            border: Border.all(color: const Color(0x1AFFFFFF)),
          ),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              _ScrubBar(controller: controller, onSeekTo: onSeekTo),
              const SizedBox(height: 8),
              ValueListenableBuilder<VideoPlayerValue>(
                valueListenable: controller,
                builder: (_, value, _) => Row(
                  children: [
                    Text(
                      _fmt(value.position),
                      style: const TextStyle(
                        color: Color(0xCCFFFFFF),
                        fontSize: 12,
                        fontWeight: FontWeight.w500,
                      ),
                    ),
                    Expanded(
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          IconButton(
                            onPressed: () => onSeekTo(
                              controller.value.position - _seekStep,
                            ),
                            visualDensity: VisualDensity.compact,
                            icon: const Icon(
                              Icons.replay_5,
                              color: Colors.white,
                              size: 24,
                            ),
                          ),
                          const SizedBox(width: 8),
                          _CircleButton(
                            icon: value.isPlaying
                                ? Icons.pause
                                : Icons.play_arrow,
                            onTap: onToggle,
                          ),
                          const SizedBox(width: 8),
                          IconButton(
                            onPressed: () => onSeekTo(
                              controller.value.position + _seekStep,
                            ),
                            visualDensity: VisualDensity.compact,
                            icon: const Icon(
                              Icons.forward_5,
                              color: Colors.white,
                              size: 24,
                            ),
                          ),
                        ],
                      ),
                    ),
                    Text(
                      _fmt(value.duration),
                      style: const TextStyle(
                        color: Color(0xCCFFFFFF),
                        fontSize: 12,
                        fontWeight: FontWeight.w500,
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

/// Slim rounded scrub bar: gray track, translucent buffered fill, accent
/// played fill, and a round thumb. Tap or drag anywhere on it to seek.
class _ScrubBar extends StatelessWidget {
  const _ScrubBar({required this.controller, required this.onSeekTo});

  final VideoPlayerController controller;
  final ValueChanged<Duration> onSeekTo;

  static const _thumbSize = 12.0;

  void _seekTo(Offset local, double width) {
    final total = controller.value.duration;
    final fraction = (local.dx / width).clamp(0.0, 1.0);
    onSeekTo(total * fraction);
  }

  @override
  Widget build(BuildContext context) {
    return ValueListenableBuilder<VideoPlayerValue>(
      valueListenable: controller,
      builder: (_, value, _) {
        final total = value.duration;
        final pos = value.position > total ? total : value.position;
        final played = total == Duration.zero
            ? 0.0
            : pos.inMilliseconds / total.inMilliseconds;
        // Furthest buffered end across all ranges, as a 0..1 fraction.
        var buffered = 0.0;
        if (total > Duration.zero) {
          for (final range in value.buffered) {
            final end = range.end.inMilliseconds / total.inMilliseconds;
            if (end > buffered) buffered = end.clamp(0.0, 1.0);
          }
        }
        // Half the thumb width: fills start/end inset so the thumb CENTER
        // (not its left edge) lines up with the played-fill end.
        const inset = _thumbSize / 2;
        return LayoutBuilder(
          builder: (context, constraints) {
            final trackWidth = constraints.maxWidth - _thumbSize;
            return GestureDetector(
              behavior: HitTestBehavior.opaque,
              onTapDown: (d) => _seekTo(
                d.localPosition - const Offset(inset, 0),
                trackWidth,
              ),
              onHorizontalDragStart: (d) => _seekTo(
                d.localPosition - const Offset(inset, 0),
                trackWidth,
              ),
              onHorizontalDragUpdate: (d) => _seekTo(
                d.localPosition - const Offset(inset, 0),
                trackWidth,
              ),
              child: SizedBox(
                height: 28, // Generous touch target over the 4px visual bar.
                child: Center(
                  child: Padding(
                    padding: const EdgeInsets.symmetric(horizontal: inset),
                    child: SizedBox(
                      height: _thumbSize,
                      width: double.infinity,
                      child: Stack(
                        alignment: Alignment.centerLeft,
                        children: [
                          // Track.
                          Container(
                            height: 4,
                            decoration: BoxDecoration(
                              color: const Color(0x33FFFFFF),
                              borderRadius: BorderRadius.circular(2),
                            ),
                          ),
                          // Buffered fill.
                          FractionallySizedBox(
                            widthFactor: buffered,
                            child: Container(
                              height: 4,
                              decoration: BoxDecoration(
                                color: const Color(0x80FFFFFF),
                                borderRadius: BorderRadius.circular(2),
                              ),
                            ),
                          ),
                          // Played fill.
                          FractionallySizedBox(
                            widthFactor: played,
                            child: Container(
                              height: 4,
                              decoration: BoxDecoration(
                                color: _accent,
                                borderRadius: BorderRadius.circular(2),
                              ),
                            ),
                          ),
                          // Thumb — aligned to the played fraction. With the
                          // symmetric inset, Stack width == trackWidth, so the
                          // thumb CENTER tracks the played-fill end exactly.
                          Align(
                            alignment: Alignment(played * 2 - 1, 0),
                            child: Container(
                              width: _thumbSize,
                              height: _thumbSize,
                              decoration: const BoxDecoration(
                                color: Colors.white,
                                shape: BoxShape.circle,
                                boxShadow: [
                                  BoxShadow(color: Colors.black45, blurRadius: 4),
                                ],
                              ),
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),
                ),
              ),
            );
          },
        );
      },
    );
  }
}

/// Round accent-filled button used for the primary play/pause affordances
/// (the big paused-state icon and the bar's center button).
class _CircleButton extends StatelessWidget {
  const _CircleButton({
    required this.icon,
    required this.onTap,
    this.size = 48,
    this.iconSize = 30,
  });

  final IconData icon;
  final VoidCallback onTap;
  final double size;
  final double iconSize;

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        width: size,
        height: size,
        decoration: const BoxDecoration(
          color: _accent,
          shape: BoxShape.circle,
          boxShadow: [BoxShadow(color: Colors.black45, blurRadius: 12)],
        ),
        child: Icon(icon, color: Colors.white, size: iconSize),
      ),
    );
  }
}
