import 'package:amanah/core/theme/app_colors.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';

/// Circular type badge for a notification: blue for assignments, amber for
/// alerts (overdue / missed / expired). Shared by the feed row and the detail
/// sheet so the two can share a Hero flight.
class NotificationBadge extends StatelessWidget {
  const NotificationBadge({required this.alert, this.size = 36, super.key});

  final bool alert;
  final double size;

  @override
  Widget build(BuildContext context) {
    return Container(
      width: size,
      height: size,
      decoration: BoxDecoration(
        shape: BoxShape.circle,
        color: alert ? AppColors.ringWarning : AppColors.brand,
      ),
      child: Center(
        child: SvgPicture.asset(
          'assets/icons/fill/ClipboardText.svg',
          width: size * 0.5,
          colorFilter: const ColorFilter.mode(
            AppColors.iconInverse,
            BlendMode.srcIn,
          ),
        ),
      ),
    );
  }
}

/// Hero tag shared between a notification's row badge and its detail-sheet
/// badge. Unique per notification id.
String notificationBadgeTag(int id) => 'notif-badge-$id';
