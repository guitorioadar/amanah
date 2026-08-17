import 'package:amanah/core/theme/app_colors.dart';
import 'package:amanah/core/theme/app_spacing.dart';
import 'package:flutter/material.dart';
import 'package:shimmer/shimmer.dart';

/// Shimmer placeholder shaped like an AuditCard, shown while audits load.
/// Same white card + border so the skeleton occupies the real card's footprint
/// on both the navy carousel and the white upcoming list.
class AuditCardSkeleton extends StatelessWidget {
  const AuditCardSkeleton({super.key});

  @override
  Widget build(BuildContext context) {
    return DecoratedBox(
      decoration: BoxDecoration(
        color: AppColors.bgDefault,
        borderRadius: BorderRadius.circular(AppRadius.md),
        border: Border.all(color: AppColors.borderDefault),
      ),
      child: Shimmer.fromColors(
        baseColor: AppColors.skeletonBase,
        highlightColor: AppColors.skeletonHighlight,
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Padding(
              padding: EdgeInsets.all(14),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(
                    children: [
                      _Bar(width: 90, height: 24, radius: AppRadius.sm),
                      SizedBox(width: AppSpacing.s2),
                      _Bar(width: 120, height: 24, radius: AppRadius.sm),
                    ],
                  ),
                  SizedBox(height: AppSpacing.s3),
                  _Bar(width: 170, height: 18),
                  SizedBox(height: AppSpacing.s2),
                  _Bar(width: 140, height: 14),
                  SizedBox(height: AppSpacing.s3),
                  Row(
                    children: [
                      _Bar(width: 120, height: 24, radius: AppRadius.sm),
                      SizedBox(width: AppSpacing.s2),
                      _Bar(width: 96, height: 24, radius: AppRadius.sm),
                    ],
                  ),
                ],
              ),
            ),
            Divider(height: 1, thickness: 1, color: AppColors.borderDefault),
            const Padding(
              padding: EdgeInsets.symmetric(
                horizontal: 14,
                vertical: AppSpacing.s3,
              ),
              child: Row(
                children: [
                  _Bar(width: 20, height: 20, radius: AppRadius.pill),
                  SizedBox(width: AppSpacing.s2),
                  _Bar(width: 48, height: 14),
                  SizedBox(width: AppSpacing.s3),
                  _Bar(width: 60, height: 14),
                  Spacer(),
                  _Bar(width: 56, height: 14),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class _Bar extends StatelessWidget {
  const _Bar({required this.width, required this.height, this.radius = 6});
  final double width;
  final double height;
  final double radius;

  @override
  Widget build(BuildContext context) {
    return Container(
      width: width,
      height: height,
      decoration: BoxDecoration(
        color: AppColors.skeletonBase,
        borderRadius: BorderRadius.circular(radius),
      ),
    );
  }
}
