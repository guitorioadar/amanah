import 'package:amanah/core/theme/app_colors.dart';
import 'package:amanah/core/theme/app_spacing.dart';
import 'package:amanah/core/theme/app_text_styles.dart';
import 'package:amanah/core/widgets/app_avatar.dart';
import 'package:amanah/features/auth/data/models/user.dart';
import 'package:amanah/features/auth/presentation/providers/session_providers.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:go_router/go_router.dart';
import 'package:package_info_plus/package_info_plus.dart';

/// Profile tab — navy header with avatar + identity, grouped settings cards,
/// and a Sign out action. Reads the signed-in user from [currentUserProvider].
class ProfileScreen extends ConsumerWidget {
  const ProfileScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final user = ref.watch(currentUserProvider);

    return ColoredBox(
      color: AppColors.bgDefault,
      child: SingleChildScrollView(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            _Header(user: user),
            const SizedBox(height: AppSpacing.s4),
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: AppSpacing.s4),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.stretch,
                children: [
                  const SizedBox(height: AppSpacing.s2),
                  const _SectionLabel('GENERAL'),
                  const SizedBox(height: AppSpacing.s2),
                  _Card(
                    rows: [
                      _RowSpec(
                        icon: 'User',
                        color: AppColors.iconBrand,
                        label: 'Personal information',
                      ),
                      _RowSpec(
                        icon: 'Lock',
                        color: AppColors.iconInformation,
                        label: 'Sign in & Security',
                      ),
                      _RowSpec(
                        icon: 'Bell',
                        color: AppColors.iconWarning,
                        label: 'Notification',
                      ),
                    ],
                  ),
                  const SizedBox(height: AppSpacing.s5),
                  const _SectionLabel('SUPPORT'),
                  const SizedBox(height: AppSpacing.s2),
                  _Card(
                    rows: [
                      _RowSpec(
                        icon: 'ShieldCheck',
                        color: AppColors.iconSuccess,
                        label: 'Privacy policy',
                      ),
                      _RowSpec(
                        icon: 'FileText',
                        color: AppColors.iconMagenta,
                        label: 'Terms & conditions',
                      ),
                    ],
                  ),
                  const SizedBox(height: AppSpacing.s5),
                  _SignOutButton(onPressed: () => context.push('/signing-out')),
                  const SizedBox(height: AppSpacing.s5),
                  const _BuildInfo(),
                  // Clears the floating Expense button + bottom nav bar.
                  SizedBox(height: AppSpacing.s9 + MediaQuery.of(context).viewPadding.bottom + 56),
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
  const _Header({required this.user});
  final User? user;

  @override
  Widget build(BuildContext context) {
    final topInset = MediaQuery.of(context).viewPadding.top;
    return Container(
      width: double.infinity,
      color: AppColors.bgSolid,
      padding: EdgeInsets.fromLTRB(
        AppSpacing.s6,
        topInset + AppSpacing.s5,
        AppSpacing.s6,
        AppSpacing.s6,
      ),
      child: Column(
        children: [
          AppAvatar(
            url: user?.profilePictureUrl,
            size: 64,
            borderColor: AppColors.textInverse,
            borderWidth: 3,
          ),
          const SizedBox(height: AppSpacing.s4),
          Text(
            user?.name ?? 'Auditor',
            textAlign: TextAlign.center,
            style: AppText.headingM.copyWith(color: AppColors.textInverse),
          ),
          const SizedBox(height: AppSpacing.s1),
          Text(
            user?.email ?? '',
            textAlign: TextAlign.center,
            style: AppText.bodyLRegular.copyWith(color: AppColors.textSubtlest),
          ),
        ],
      ),
    );
  }
}

class _SectionLabel extends StatelessWidget {
  const _SectionLabel(this.text);
  final String text;

  @override
  Widget build(BuildContext context) {
    return Text(
      text,
      style: AppText.capsM.copyWith(color: AppColors.textSubtle),
    );
  }
}

class _RowSpec {
  _RowSpec({required this.icon, required this.color, required this.label});
  final String icon;
  final Color color;
  final String label;
}

class _Card extends StatelessWidget {
  const _Card({required this.rows});
  final List<_RowSpec> rows;

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        color: AppColors.bgDefault,
        borderRadius: BorderRadius.circular(AppRadius.md),
        border: Border.all(color: AppColors.borderDefault),
      ),
      child: Column(
        children: [
          for (var i = 0; i < rows.length; i++) ...[
            _Row(spec: rows[i]),
            if (i != rows.length - 1)
              Divider(height: 1, thickness: 1, color: AppColors.borderDefault),
          ],
        ],
      ),
    );
  }
}

class _Row extends StatelessWidget {
  const _Row({required this.spec});
  final _RowSpec spec;

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: () => ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('${spec.label} — coming soon')),
      ),
      child: Padding(
        padding: const EdgeInsets.symmetric(
          horizontal: AppSpacing.s4,
          vertical: AppSpacing.s4,
        ),
        child: Row(
          children: [
            SvgPicture.asset(
              'assets/icons/fill/${spec.icon}.svg',
              width: 24,
              colorFilter: ColorFilter.mode(spec.color, BlendMode.srcIn),
            ),
            const SizedBox(width: AppSpacing.s3),
            Expanded(
              child: Text(
                spec.label,
                style: AppText.bodyLRegular.copyWith(
                  color: AppColors.textDefault,
                ),
              ),
            ),
            SvgPicture.asset(
              'assets/icons/line/CaretRight.svg',
              width: 20,
              colorFilter: const ColorFilter.mode(
                AppColors.iconSubtle,
                BlendMode.srcIn,
              ),
            ),
          ],
        ),
      ),
    );
  }
}

/// TEMPORARY diagnostic — shows app version/build + which env file loaded.
/// Remove before release.
class _BuildInfo extends StatelessWidget {
  const _BuildInfo();

  @override
  Widget build(BuildContext context) {
    final style = AppText.bodyXsRegular.copyWith(color: AppColors.textSubtlest);
    return FutureBuilder<PackageInfo>(
      future: PackageInfo.fromPlatform(),
      builder: (context, snap) {
        final info = snap.data;
        final version = info == null
            ? '…'
            : 'v${info.version} (${info.buildNumber})';
        return Column(
          children: [
            Text(version, style: style,),
            const SizedBox(height: AppSpacing.s1),
            // Text('env: ${Env.envName}', style: style),
            // const SizedBox(height: AppSpacing.s1),
            // Text(
            //   Env.apiBaseUrl,
            //   textAlign: TextAlign.center,
            //   style: style,
            // ),
          ],
        );
      },
    );
  }
}

class _SignOutButton extends StatelessWidget {
  const _SignOutButton({required this.onPressed});
  final VoidCallback onPressed;

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      height: 48,
      child: OutlinedButton(
        onPressed: onPressed,
        style: OutlinedButton.styleFrom(
          foregroundColor: AppColors.textDanger,
          side: const BorderSide(color: AppColors.borderDanger),
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(AppRadius.md),
          ),
        ),
        child: Text(
          'Sign out',
          style: AppText.buttonL.copyWith(color: AppColors.textDanger),
        ),
      ),
    );
  }
}
