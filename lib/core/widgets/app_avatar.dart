import 'package:amanah/core/theme/app_colors.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:shimmer/shimmer.dart';

/// Circular user avatar. Loads [url] with disk+memory caching
/// ([CachedNetworkImage]) and falls back to the `User` glyph when the URL is
/// missing, empty, or fails to load. Shared by the Home header and Profile.
class AppAvatar extends StatelessWidget {
  const AppAvatar({
    required this.url,
    this.size = 48,
    this.borderColor,
    this.borderWidth = 0,
    super.key,
  });

  final String? url;
  final double size;
  final Color? borderColor;
  final double borderWidth;

  @override
  Widget build(BuildContext context) {
    final hasUrl = url != null && url!.isNotEmpty;
    return Container(
      width: size,
      height: size,
      decoration: BoxDecoration(
        shape: BoxShape.circle,
        border: borderWidth > 0
            ? Border.all(
                color: borderColor ?? AppColors.textInverse,
                width: borderWidth,
              )
            : null,
      ),
      child: ClipOval(
        child: hasUrl
            ? CachedNetworkImage(
                imageUrl: url!,
                fit: BoxFit.cover,
                // Shimmer while the (new) image loads; glyph only on failure.
                placeholder: (_, _) => _shimmer(),
                errorWidget: (_, _, _) => _placeholder(),
              )
            : _placeholder(),
      ),
    );
  }

  Widget _shimmer() => Shimmer.fromColors(
        baseColor: AppColors.skeletonBase,
        highlightColor: AppColors.skeletonHighlight,
        child: const ColoredBox(color: AppColors.skeletonBase),
      );

  Widget _placeholder() => ColoredBox(
        color: AppColors.bgHovered,
        child: Padding(
          padding: EdgeInsets.all(size * 0.22),
          child: SvgPicture.asset(
            'assets/icons/fill/User.svg',
            colorFilter: const ColorFilter.mode(
              AppColors.iconSubtle,
              BlendMode.srcIn,
            ),
          ),
        ),
      );
}
