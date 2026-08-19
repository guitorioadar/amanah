import 'dart:math' as math;

import 'package:amanah/core/theme/app_colors.dart';
import 'package:flutter/material.dart';

/// Circular progress ring (donut) with a filled centre. The arc is [color],
/// the unfilled track + centre fill are [track]. Used on the audit card footer
/// and the Audit-details completion bar.
class ProgressRing extends StatelessWidget {
  const ProgressRing({
    required this.percent,
    required this.color,
    this.track = AppColors.ringWarningTrack,
    this.size = 20,
    super.key,
  });

  final int percent;
  final Color color;
  final Color track;
  final double size;

  @override
  Widget build(BuildContext context) {
    return CustomPaint(
      size: Size(size, size),
      painter: _RingPainter(
        fraction: percent.clamp(0, 100) / 100,
        color: color,
        track: track,
      ),
    );
  }
}

class _RingPainter extends CustomPainter {
  _RingPainter({
    required this.fraction,
    required this.color,
    required this.track,
  });
  final double fraction;
  final Color color;
  final Color track;

  @override
  void paint(Canvas canvas, Size size) {
    final center = size.center(Offset.zero);
    final ring = size.width * 0.09;
    final outerR = (size.width - ring) / 2;

    // Outer ring (full circle). Gray when there's no progress yet.
    canvas.drawCircle(
      center,
      outerR,
      Paint()
        ..style = PaintingStyle.stroke
        ..strokeWidth = ring
        ..color = fraction <= 0 ? AppColors.ringEmpty : color,
    );

    if (fraction <= 0) return;

    // Inner pie wedge for the completed fraction, inset by a small gap.
    final pieR = outerR - ring / 2 - size.width * 0.09;
    canvas.drawArc(
      Rect.fromCircle(center: center, radius: pieR),
      -math.pi / 2,
      2 * math.pi * fraction,
      true,
      Paint()
        ..style = PaintingStyle.fill
        ..color = track,
    );
  }

  @override
  bool shouldRepaint(_RingPainter old) =>
      old.fraction != fraction || old.color != color || old.track != track;
}
