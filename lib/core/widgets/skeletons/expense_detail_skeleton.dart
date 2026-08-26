import 'package:amanah/core/theme/app_colors.dart';
import 'package:amanah/core/theme/app_spacing.dart';
import 'package:flutter/material.dart';
import 'package:shimmer/shimmer.dart';

/// Shimmer placeholder for the expense-details screen. Mirrors the real layout
/// — summary card (date, total, tax columns, meta row, chips), the line-item
/// table, and the receipts strip — so the load-in doesn't shift.
class ExpenseDetailSkeleton extends StatelessWidget {
  const ExpenseDetailSkeleton({super.key});

  @override
  Widget build(BuildContext context) {
    return Shimmer.fromColors(
      baseColor: AppColors.skeletonBase,
      highlightColor: AppColors.skeletonHighlight,
      child: const Padding(
        padding: EdgeInsets.all(AppSpacing.s4),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            _SummaryCard(),
            SizedBox(height: AppSpacing.s4),
            _Table(),
            SizedBox(height: AppSpacing.s5),
            _Receipts(),
          ],
        ),
      ),
    );
  }
}

class _SummaryCard extends StatelessWidget {
  const _SummaryCard();

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(AppSpacing.s4),
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(AppRadius.lg),
        border: Border.all(color: AppColors.borderDefault),
      ),
      child: const Column(
        children: [
          _Bar(width: 120, height: 16),
          SizedBox(height: AppSpacing.s2),
          _Bar(width: 170, height: 34),
          SizedBox(height: AppSpacing.s3),
          _Line(),
          SizedBox(height: AppSpacing.s3),
          Row(
            children: [
              Expanded(child: _TaxColumn()),
              Expanded(child: _TaxColumn()),
            ],
          ),
          SizedBox(height: AppSpacing.s3),
          _Line(),
          SizedBox(height: AppSpacing.s3),
          Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              _Bar(width: 20, height: 20, radius: AppRadius.pill),
              SizedBox(width: AppSpacing.s2),
              _Bar(width: 84, height: 14),
              SizedBox(width: AppSpacing.s3),
              _Bar(width: 96, height: 14),
            ],
          ),
          SizedBox(height: AppSpacing.s3),
          Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              _Bar(width: 110, height: 24, radius: AppRadius.sm),
              SizedBox(width: AppSpacing.s2),
              _Bar(width: 130, height: 24, radius: AppRadius.sm),
            ],
          ),
        ],
      ),
    );
  }
}

class _TaxColumn extends StatelessWidget {
  const _TaxColumn();

  @override
  Widget build(BuildContext context) {
    return const Column(
      children: [
        _Bar(width: 70, height: 12),
        SizedBox(height: AppSpacing.s2),
        _Bar(width: 84, height: 16),
      ],
    );
  }
}

class _Table extends StatelessWidget {
  const _Table();

  @override
  Widget build(BuildContext context) {
    return DecoratedBox(
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(AppRadius.md),
        border: Border.all(color: AppColors.borderDefault),
      ),
      child: const Column(
        children: [
          _Row(),
          _Line(),
          _Row(),
          _Line(),
          _Row(),
        ],
      ),
    );
  }
}

class _Row extends StatelessWidget {
  const _Row();

  @override
  Widget build(BuildContext context) {
    return const Padding(
      padding: EdgeInsets.symmetric(
        horizontal: AppSpacing.s4,
        vertical: AppSpacing.s4,
      ),
      child: Row(
        children: [
          _Bar(width: 150, height: 16),
          Spacer(),
          _Bar(width: 96, height: 16),
        ],
      ),
    );
  }
}

class _Receipts extends StatelessWidget {
  const _Receipts();

  @override
  Widget build(BuildContext context) {
    return const Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        _Bar(width: 80, height: 16),
        SizedBox(height: AppSpacing.s3),
        Row(
          children: [
            _Thumb(),
            SizedBox(width: AppSpacing.s2),
            _Thumb(),
          ],
        ),
      ],
    );
  }
}

class _Thumb extends StatelessWidget {
  const _Thumb();

  @override
  Widget build(BuildContext context) {
    return Container(
      width: 110,
      height: 70,
      decoration: BoxDecoration(
        color: AppColors.skeletonBase,
        borderRadius: BorderRadius.circular(AppRadius.md),
      ),
    );
  }
}

/// Thin divider-shaped bar (matches the real hairlines).
class _Line extends StatelessWidget {
  const _Line();

  @override
  Widget build(BuildContext context) {
    return Container(height: 1, color: AppColors.skeletonBase);
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
