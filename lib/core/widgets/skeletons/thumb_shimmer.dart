import 'package:amanah/core/theme/app_colors.dart';
import 'package:flutter/material.dart';
import 'package:shimmer/shimmer.dart';

/// Shimmer placeholder that fills its box — shown while a thumbnail image loads
/// over the network (e.g. the submission sheet's record thumbnails).
class ThumbShimmer extends StatelessWidget {
  const ThumbShimmer({super.key});

  @override
  Widget build(BuildContext context) {
    return Shimmer.fromColors(
      baseColor: AppColors.skeletonBase,
      highlightColor: AppColors.skeletonHighlight,
      child: const ColoredBox(color: AppColors.skeletonBase),
    );
  }
}
