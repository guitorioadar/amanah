import 'package:amanah/core/theme/app_colors.dart';
import 'package:amanah/core/theme/app_spacing.dart';
import 'package:flutter/material.dart';
import 'package:shimmer/shimmer.dart';

/// Shimmer placeholder for the Audit-details screen: navy header (chips, title,
/// meta rows, completion bar) over a white body (search + category cards).
/// Rendered under the real `_TopBar` while the audit loads.
class AuditDetailsSkeleton extends StatelessWidget {
  const AuditDetailsSkeleton({super.key});

  @override
  Widget build(BuildContext context) {
    return const Column(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: [
        _HeaderSkeleton(),
        Expanded(child: _BodySkeleton()),
      ],
    );
  }
}

class _HeaderSkeleton extends StatelessWidget {
  const _HeaderSkeleton();

  @override
  Widget build(BuildContext context) {
    return Container(
      width: double.infinity,
      color: AppColors.bgSolid,
      padding: const EdgeInsets.fromLTRB(
        AppSpacing.s4,
        AppSpacing.s2,
        AppSpacing.s4,
        AppSpacing.s5,
      ),
      // Light shimmer so bars read on the navy header.
      child: Shimmer.fromColors(
        baseColor: AppColors.textInverse.withValues(alpha: 0.10),
        highlightColor: AppColors.textInverse.withValues(alpha: 0.22),
        child: const Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              children: [
                _Bar(width: 90, height: 26, radius: AppRadius.sm),
                SizedBox(width: AppSpacing.s2),
                _Bar(width: 150, height: 26, radius: AppRadius.sm),
              ],
            ),
            SizedBox(height: AppSpacing.s4),
            _Bar(width: 240, height: 28),
            SizedBox(height: AppSpacing.s4),
            _Bar(width: 260, height: 16),
            SizedBox(height: AppSpacing.s2),
            _Bar(width: 170, height: 16),
            SizedBox(height: AppSpacing.s2),
            _Bar(width: 210, height: 16),
            SizedBox(height: AppSpacing.s4),
            _Bar(width: double.infinity, height: 44, radius: AppRadius.md),
          ],
        ),
      ),
    );
  }
}

class _BodySkeleton extends StatelessWidget {
  const _BodySkeleton();

  @override
  Widget build(BuildContext context) {
    return ColoredBox(
      color: AppColors.bgDefault,
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: AppSpacing.s4),
        child: Shimmer.fromColors(
          baseColor: AppColors.skeletonBase,
          highlightColor: AppColors.skeletonHighlight,
          child: const Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              SizedBox(height: AppSpacing.s5),
              _Bar(width: double.infinity, height: 36, radius: AppRadius.md),
              SizedBox(height: AppSpacing.s4),
              _CategoryCardSkeleton(),
              SizedBox(height: AppSpacing.s4),
              _CategoryCardSkeleton(),
              SizedBox(height: AppSpacing.s4),
              _CategoryCardSkeleton(),
            ],
          ),
        ),
      ),
    );
  }
}

class _CategoryCardSkeleton extends StatelessWidget {
  const _CategoryCardSkeleton();

  @override
  Widget build(BuildContext context) {
    return DecoratedBox(
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(AppRadius.md),
        border: Border.all(color: AppColors.borderDefault),
      ),
      child: const Padding(
        padding: EdgeInsets.all(AppSpacing.s4),
        child: Column(
          children: [
            Row(
              children: [
                _Bar(width: 44, height: 44, radius: AppRadius.pill),
                SizedBox(width: AppSpacing.s3),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      _Bar(width: 150, height: 16),
                      SizedBox(height: AppSpacing.s2),
                      _Bar(width: 190, height: 14),
                    ],
                  ),
                ),
                SizedBox(width: AppSpacing.s2),
                _Bar(width: 18, height: 18, radius: AppRadius.sm),
              ],
            ),
            SizedBox(height: AppSpacing.s3),
            Row(
              children: [
                Expanded(
                  child: _Bar(width: double.infinity, height: 6,
                      radius: AppRadius.pill),
                ),
                SizedBox(width: AppSpacing.s3),
                _Bar(width: 36, height: 14),
              ],
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
