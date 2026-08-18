import 'package:amanah/core/theme/app_colors.dart';
import 'package:amanah/core/theme/app_spacing.dart';
import 'package:amanah/core/theme/app_text_styles.dart';
import 'package:amanah/core/widgets/app_avatar.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:go_router/go_router.dart';

/// Top row of the navy header shared by Home and Audits: avatar + name +
/// "View profile" link on the left, notification bell on the right. Designed to
/// sit on the dark [AppColors.bgSolid] header, so all text uses inverse tones.
class IdentityBar extends StatelessWidget {
  const IdentityBar({required this.name, required this.avatarUrl, super.key});

  final String? name;
  final String? avatarUrl;

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        AppAvatar(url: avatarUrl, size: 40),
        const SizedBox(width: AppSpacing.s3),
        Expanded(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                name ?? 'Auditor',
                maxLines: 1,
                overflow: TextOverflow.ellipsis,
                style: AppText.bodyLMedium.copyWith(
                  color: AppColors.textInverse,
                ),
              ),
              GestureDetector(
                onTap: () => context.go('/profile'),
                child: Text(
                  'View profile',
                  style: AppText.bodySMedium.copyWith(
                    color: AppColors.textSubtlest,
                    decoration: TextDecoration.underline,
                    decorationColor: AppColors.textSubtlest,
                  ),
                ),
              ),
            ],
          ),
        ),
        const SizedBox(width: AppSpacing.s3),
        const _BellButton(),
      ],
    );
  }
}

/// Notification bell with an unread badge. Tap wiring lands with the
/// Notifications screen (M3).
class _BellButton extends StatelessWidget {
  const _BellButton();

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () {}, // TODO(M3): context.push('/notifications')
      behavior: HitTestBehavior.opaque,
      child: SizedBox(
        width: 36,
        height: 36,
        child: Stack(
          alignment: Alignment.center,
          children: [
            Container(
              width: 32,
              height: 32,
              decoration: BoxDecoration(
                shape: BoxShape.circle,
                color: AppColors.textInverse.withValues(alpha: 0.15),
              ),
              child: Center(
                child: SvgPicture.asset(
                  'assets/icons/line/Bell.svg',
                  width: 20,
                  colorFilter: const ColorFilter.mode(
                    AppColors.iconInverse,
                    BlendMode.srcIn,
                  ),
                ),
              ),
            ),
            Positioned(
              top: 0,
              right: 4,
              child: Container(
                width: 10,
                height: 10,
                decoration: BoxDecoration(
                  shape: BoxShape.circle,
                  color: AppColors.iconNotification,
                  border: Border.all(color: AppColors.bgSolid, width: 2),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
