import 'package:amanah/core/theme/app_colors.dart';
import 'package:amanah/core/theme/app_spacing.dart';
import 'package:amanah/core/theme/app_system_ui.dart';
import 'package:amanah/core/theme/app_text_styles.dart';
import 'package:amanah/core/widgets/empty_state.dart';
import 'package:amanah/core/widgets/identity_bar.dart';
import 'package:amanah/features/auth/presentation/providers/session_providers.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

/// Audits tab — navy header (identity + "All audits" title) over a white body.
///
/// This is the empty state: until the assigned-audits list is wired to the API,
/// the body shows the balloon "Nothing assigned yet!" illustration. The
/// segmented tabs (Assigned / In progress / Completed), search, and card list
/// land with the data step. The "+ Expense" FAB is provided by the shell.
class AuditsScreen extends ConsumerWidget {
  const AuditsScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final user = ref.watch(currentUserProvider);
    final topInset = MediaQuery.of(context).viewPadding.top;

    return AnnotatedRegion<SystemUiOverlayStyle>(
      value: AppSystemUi.light,
      child: Stack(
        children: [
          ColoredBox(
            color: AppColors.bgDefault,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: [
                _Header(name: user?.name, avatarUrl: user?.profilePictureUrl),
                const Expanded(
                  child: Align(
                    alignment: Alignment.topCenter,
                    child: Padding(
                      padding: EdgeInsets.fromLTRB(
                        AppSpacing.s6,
                        94,
                        AppSpacing.s6,
                        0,
                      ),
                      child: EmptyState(
                        asset: 'assets/vectors/Vectors-3.svg',
                        title: 'Nothing assigned yet!',
                        message: 'Enjoy the day off',
                        illustrationSize: 140,
                      ),
                    ),
                  ),
                ),
              ],
            ),
          ),
          // Keeps the status-bar area navy behind the header.
          Positioned(
            top: 0,
            left: 0,
            right: 0,
            height: topInset,
            child: const IgnorePointer(
              child: ColoredBox(color: AppColors.bgSolid),
            ),
          ),
        ],
      ),
    );
  }
}

/// Navy page header: identity row + "All audits" title + subtitle.
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
        topInset + AppSpacing.s2,
        AppSpacing.s4,
        AppSpacing.s6,
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          IdentityBar(name: name, avatarUrl: avatarUrl),
          const SizedBox(height: AppSpacing.s6),
          Text(
            'All audits',
            style: AppText.headingL.copyWith(color: AppColors.textInverse),
          ),
          const SizedBox(height: AppSpacing.s1),
          Text(
            'List of all your assigned and completed audits',
            style: AppText.bodyLRegular.copyWith(
              color: AppColors.textSubtlest,
            ),
          ),
        ],
      ),
    );
  }
}
