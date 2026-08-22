import 'package:amanah/core/theme/app_colors.dart';
import 'package:amanah/core/theme/app_spacing.dart';
import 'package:amanah/core/theme/app_text_styles.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';

/// Light top bar shared by every Profile sub-screen: bundled caret-left back
/// button + centered title, with a hairline bottom border. Extends under the
/// status bar via [topInset]. Keeps the sub-screens identical (they used to
/// each redefine this).
class ProfileTopBar extends StatelessWidget {
  const ProfileTopBar({required this.title, required this.topInset, super.key});

  final String title;
  final double topInset;

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        color: AppColors.bgDefault,
        border: Border(bottom: BorderSide(color: AppColors.borderDefault)),
      ),
      padding: EdgeInsets.fromLTRB(
        AppSpacing.s3,
        topInset,
        AppSpacing.s3,
        AppSpacing.s3,
      ),
      child: Row(
        children: [
          GestureDetector(
            onTap: () => Navigator.of(context).pop(),
            behavior: HitTestBehavior.opaque,
            child: Padding(
              padding: const EdgeInsets.all(AppSpacing.s1),
              child: SvgPicture.asset(
                'assets/icons/line/CaretLeft.svg',
                width: 24,
                colorFilter: const ColorFilter.mode(
                  AppColors.iconSubtle,
                  BlendMode.srcIn,
                ),
              ),
            ),
          ),
          Expanded(
            child: Center(
              child: Text(
                title,
                maxLines: 1,
                overflow: TextOverflow.ellipsis,
                style: AppText.bodyLMedium.copyWith(color: AppColors.textSubtle),
              ),
            ),
          ),
          const SizedBox(width: 44),
        ],
      ),
    );
  }
}
