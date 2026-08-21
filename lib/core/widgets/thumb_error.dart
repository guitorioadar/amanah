import 'package:amanah/core/theme/app_colors.dart';
import 'package:flutter/material.dart';

/// Fallback shown when a thumbnail image fails to load over the network.
class ThumbError extends StatelessWidget {
  const ThumbError({super.key});

  @override
  Widget build(BuildContext context) {
    return const ColoredBox(
      color: AppColors.bgHovered,
      child: Center(
        child: Icon(
          Icons.broken_image_outlined,
          size: 24,
          color: AppColors.iconSubtle,
        ),
      ),
    );
  }
}
