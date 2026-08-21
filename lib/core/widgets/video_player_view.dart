import 'dart:async';
import 'dart:io';

import 'package:flutter/material.dart';
import 'package:video_player/video_player.dart';

const Duration _seekStep = Duration(seconds: 5);

/// Full-frame video player used inside the media viewer. Initializes the
/// controller, auto-plays/loops, and shows a control bar (play/pause, 5s
/// seek back/forward, elapsed / total time, scrub bar). Tapping the frame
/// toggles the control overlay, which auto-hides after a short delay while
/// playing and stays visible while paused.
class VideoPlayerView extends StatefulWidget {
  const VideoPlayerView({
    required this.source,
    required this.isLocal,
    super.key,
  });

  /// File path (local) or URL (remote).
  final String source;
  final bool isLocal;

  @override
  State<VideoPlayerView> createState() => _VideoPlayerViewState();
}

class _VideoPlayerViewState extends State<VideoPlayerView> {
  late final VideoPlayerController _controller = widget.isLocal
      ? VideoPlayerController.file(File(widget.source))
      : VideoPlayerController.networkUrl(Uri.parse(widget.source));
  bool _ready = false;
  Object? _error;
  bool _controlsVisible = true;
  Timer? _hideTimer;

  static const _hideAfter = Duration(seconds: 3);

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
    setState(() => _controlsVisible = true);
    final shouldHide = autoHide ?? _controller.value.isPlaying;
    if (shouldHide) {
      _hideTimer = Timer(_hideAfter, () {
        // Never hide over a paused frame: the user needs the play button.
        if (mounted && _controller.value.isPlaying) {
          setState(() => _controlsVisible = false);
        }
      });
    }
  }

  void _onFrameTap() {
    if (_controlsVisible && _controller.value.isPlaying) {
      _hideTimer?.cancel();
      setState(() => _controlsVisible = false);
    } else {
      _pingControls();
    }
  }

  void _toggle() {
    final resuming = !_controller.value.isPlaying;
    unawaited(resuming ? _controller.play() : _controller.pause());
    _pingControls(autoHide: resuming);
  }

  Future<void> _seekBy(Duration delta) async {
    final total = _controller.value.duration;
    var target = _controller.value.position + delta;
    if (target < Duration.zero) target = Duration.zero;
    if (target > total) target = total;
    await _controller.seekTo(target);
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
              child: GestureDetector(
                onTap: _toggle,
                behavior: HitTestBehavior.opaque,
                child: const Icon(
                  Icons.play_circle_fill,
                  size: 72,
                  color: Colors.white,
                  shadows: [Shadow(color: Colors.black54, blurRadius: 16)],
                ),
              ),
            ),
          ),
        ),
        Positioned(
          left: 0,
          right: 0,
          bottom: 0,
          child: AnimatedOpacity(
            opacity: _controlsVisible ? 1 : 0,
            duration: const Duration(milliseconds: 200),
            child: IgnorePointer(
              ignoring: !_controlsVisible,
              child: _VideoControls(
                controller: _controller,
                onToggle: _toggle,
                onSeekBy: _seekBy,
              ),
            ),
          ),
        ),
      ],
    );
  }
}

/// Bottom control bar: 5s seek back, play/pause, 5s seek forward, elapsed
/// time, seek bar, total time — over a bottom gradient scrim.
class _VideoControls extends StatelessWidget {
  const _VideoControls({
    required this.controller,
    required this.onToggle,
    required this.onSeekBy,
  });

  final VideoPlayerController controller;
  final VoidCallback onToggle;
  final ValueChanged<Duration> onSeekBy;

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
        top: 24,
        bottom: MediaQuery.paddingOf(context).bottom + 12,
      ),
      decoration: const BoxDecoration(
        gradient: LinearGradient(
          begin: Alignment.topCenter,
          end: Alignment.bottomCenter,
          stops: [0, 0.4, 1],
          colors: [Colors.transparent, Colors.black45, Colors.black87],
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
                onPressed: () => onSeekBy(-_seekStep),
                visualDensity: VisualDensity.compact,
                icon: const Icon(
                  Icons.replay_5,
                  color: Colors.white,
                  size: 26,
                ),
              ),
              IconButton(
                onPressed: onToggle,
                visualDensity: VisualDensity.compact,
                icon: Icon(
                  value.isPlaying ? Icons.pause : Icons.play_arrow,
                  color: Colors.white,
                  size: 30,
                ),
              ),
              IconButton(
                onPressed: () => onSeekBy(_seekStep),
                visualDensity: VisualDensity.compact,
                icon: const Icon(
                  Icons.forward_5,
                  color: Colors.white,
                  size: 26,
                ),
              ),
              const SizedBox(width: 4),
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
