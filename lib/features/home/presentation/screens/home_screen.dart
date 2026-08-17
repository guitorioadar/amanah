import 'package:amanah/core/theme/app_colors.dart';
import 'package:amanah/core/theme/app_spacing.dart';
import 'package:amanah/core/theme/app_text_styles.dart';
import 'package:amanah/core/widgets/app_avatar.dart';
import 'package:amanah/core/widgets/empty_state.dart';
import 'package:amanah/features/auth/presentation/providers/session_providers.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:go_router/go_router.dart';

/// Home tab — navy header (identity + running audits) over a white body
/// (upcoming audits + search). Audit data lands with the audit model/API;
/// until then both sections render their empty states.
class HomeScreen extends ConsumerWidget {
  const HomeScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final user = ref.watch(currentUserProvider);

    final bottomClear =
        MediaQuery.of(context).viewPadding.bottom + AppSpacing.s9 + 56;

    return ColoredBox(
      color: AppColors.bgDefault,
      child: SingleChildScrollView(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            _Header(
              name: user?.name,
              avatarUrl: user?.profilePictureUrl,
            ),
            Padding(
              padding: EdgeInsets.fromLTRB(
                AppSpacing.s6,
                AppSpacing.s7,
                AppSpacing.s6,
                bottomClear,
              ),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.stretch,
                children: [
                  Text('Upcoming audits', style: AppText.headingL),
                  // TODO(M3): search field + upcoming list slot in above the
                  // empty state once the audit model + API are wired.
                  const SizedBox(height: AppSpacing.s9),
                  const EmptyState(
                    asset: 'assets/vectors/Vectors.svg',
                    message: 'No upcoming audits. Enjoy the day off!',
                    illustrationSize: 80,
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class _Header extends StatelessWidget {
  const _Header({required this.name, required this.avatarUrl});

  final String? name;
  final String? avatarUrl;

  @override
  Widget build(BuildContext context) {
    final topInset = MediaQuery.of(context).viewPadding.top;
    return Container(
      width: double.infinity,
      color: AppColors.bgSolid,
      padding: EdgeInsets.fromLTRB(
        AppSpacing.s4,
        topInset,
        AppSpacing.s4,
        AppSpacing.s4,
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          _IdentityRow(name: name, avatarUrl: avatarUrl),
          const SizedBox(height: AppSpacing.s6),
          Text(
            'Welcome back!',
            style: AppText.bodyLMedium.copyWith(color: AppColors.textSubtlest),
          ),
          const SizedBox(height: AppSpacing.s1),
          // TODO(M3): 'Currently running audits' when the carousel has items.
          Text(
            'No audit running currently',
            style: AppText.headingL.copyWith(color: AppColors.textInverse),
          ),
          const SizedBox(height: AppSpacing.s6),
          const Center(
            child: Padding(
              padding: EdgeInsets.only(bottom: AppSpacing.s2),
              child: EmptyState(
                asset: 'assets/vectors/Vectors-1.svg',
                message: 'No audit running at the moment!',
                onDark: true,
                illustrationSize: 80,
              ),
            ),
          ),
        ],
      ),
    );
  }
}

class _IdentityRow extends StatelessWidget {
  const _IdentityRow({required this.name, required this.avatarUrl});

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
                style: AppText.bodyLMedium.copyWith(color: AppColors.textInverse),
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
