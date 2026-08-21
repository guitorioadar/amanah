import 'dart:async';
import 'dart:io';

import 'package:amanah/core/widgets/media_viewer.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';

/// Pinch/pan-zoomable image page (network or local) for the media viewer.
/// Double-tap toggles between 1x and a tap-point-anchored 2.5x; a single tap
/// toggles the viewer chrome. Panning is enabled only while zoomed in, so a
/// plain vertical drag at rest reaches the dismiss gesture instead of being
/// swallowed here.
class ImagePageView extends StatefulWidget {
  const ImagePageView({
    required this.item,
    required this.onTap,
    required this.onZoomedChanged,
    super.key,
  });

  final MediaItem item;
  final VoidCallback onTap;
  final ValueChanged<bool> onZoomedChanged;

  @override
  State<ImagePageView> createState() => _ImagePageViewState();
}

class _ImagePageViewState extends State<ImagePageView>
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
