import 'package:amanah/core/theme/app_colors.dart';
import 'package:amanah/core/theme/app_spacing.dart';
import 'package:flutter/material.dart';
import 'package:shimmer/shimmer.dart';

/// Shimmer placeholder shaped like an ExpenseCard (date + chips over a
/// footer), shown while the grouped-expense list loads.
class ExpenseCardSkeleton extends StatelessWidget {
  const ExpenseCardSkeleton({super.key});

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
                  _Bar(width: 120, height: 22),
                  SizedBox(height: AppSpacing.s3),
                  Row(
                    children: [
                      _Bar(width: 110, height: 24, radius: AppRadius.sm),
                      SizedBox(width: AppSpacing.s2),
                      _Bar(width: 130, height: 24, radius: AppRadius.sm),
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
                  _Bar(width: 72, height: 16),
                  SizedBox(width: AppSpacing.s3),
                  _Bar(width: 90, height: 16),
                  Spacer(),
                  _Bar(width: 52, height: 16),
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
