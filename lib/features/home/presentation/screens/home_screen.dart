import 'dart:async';
import 'dart:io' show Platform;

import 'package:amanah/core/theme/app_colors.dart';
import 'package:amanah/core/theme/app_spacing.dart';
import 'package:amanah/core/theme/app_system_ui.dart';
import 'package:amanah/core/theme/app_text_styles.dart';
import 'package:amanah/core/widgets/app_search_field.dart';
import 'package:amanah/core/widgets/audit_card.dart';
import 'package:amanah/core/widgets/empty_state.dart';
import 'package:amanah/core/widgets/identity_bar.dart';
import 'package:amanah/core/widgets/skeletons/audit_card_skeleton.dart';
import 'package:amanah/features/audits/data/models/audit.dart';
import 'package:amanah/features/audits/presentation/providers/audit_providers.dart';
import 'package:amanah/features/auth/presentation/providers/session_providers.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
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
    final topInset = MediaQuery.of(context).viewPadding.top;

    return AnnotatedRegion<SystemUiOverlayStyle>(
      value: AppSystemUi.light,
      child: Stack(
        children: [
          ColoredBox(
            color: AppColors.bgDefault,
            child: RefreshIndicator(
              color: AppColors.brand,
              // Drop the spinner below the status bar / notch, not under it.
              displacement: topInset + AppSpacing.s5,
              onRefresh: () async {
                ref
                  ..invalidate(runningAuditsProvider)
                  ..invalidate(upcomingAuditsProvider);
                try {
                  await Future.wait([
                    ref.read(runningAuditsProvider.future),
                    ref.read(upcomingAuditsProvider.future),
                  ]);
                } on Object {
                  // Errors surface in each section's error state; the pull just ends.
                }
              },
              child: SingleChildScrollView(
                // Clamp on both platforms so iOS doesn't bounce/over-scroll the
                // content after a pull-to-refresh (Android already clamps).
                physics: const AlwaysScrollableScrollPhysics(
                  parent: ClampingScrollPhysics(),
                ),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.stretch,
                  children: [
                    if (Platform.isAndroid)
                      const SizedBox(height: AppSpacing.s2),
                    _Header(
                      name: user?.name,
                      avatarUrl: user?.profilePictureUrl,
                    ),
                    Padding(
                      padding: EdgeInsets.fromLTRB(
                        AppSpacing.s4,
                        AppSpacing.s4,
                        AppSpacing.s4,
                        bottomClear,
                      ),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.stretch,
                        children: [
                          Text('Upcoming audits', style: AppText.headingL),
                          const SizedBox(height: AppSpacing.s5),
                          const _UpcomingSection(),
                        ],
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ),
          // Keeps the status-bar area navy even after the header scrolls up.
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
        AppSpacing.s1,
        topInset,
        AppSpacing.s1,
        AppSpacing.s4,
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: AppSpacing.s3),
            child: IdentityBar(name: name, avatarUrl: avatarUrl),
          ),
          const SizedBox(height: AppSpacing.s6),
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: AppSpacing.s3),
            child: Text(
              'Welcome back!',
              style: AppText.bodyLMedium.copyWith(
                color: AppColors.textSubtlest,
              ),
            ),
          ),
          const SizedBox(height: AppSpacing.s1),
          const _RunningSection(),
        ],
      ),
    );
  }
}

/// Running-audits area of the navy header: title + horizontal carousel with
/// page dots. Falls back to a telescope empty state (and swaps the title) when
/// the auditor has nothing running.
class _RunningSection extends ConsumerWidget {
  const _RunningSection();

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final async = ref.watch(runningAuditsProvider);

    Widget frame(String title, Widget child) => Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Padding(
          padding: const EdgeInsets.symmetric(horizontal: AppSpacing.s3),
          child: Text(
            title,
            style: AppText.headingL.copyWith(color: AppColors.textInverse),
          ),
        ),
        const SizedBox(height: AppSpacing.s6),
        child,
      ],
    );

    return async.when(
      loading: () => frame(
        'Currently running audits',
        const Padding(
          padding: EdgeInsets.symmetric(horizontal: AppSpacing.s2),
          child: AuditCardSkeleton(),
        ),
      ),
      error: (_, _) => frame(
        'Currently running audits',
        Padding(
          padding: const EdgeInsets.symmetric(vertical: AppSpacing.s6),
          child: Text(
            "Couldn't load your audits. Pull to refresh.",
            textAlign: TextAlign.center,
            style: AppText.bodyMRegular.copyWith(color: AppColors.textSubtlest),
          ),
        ),
      ),
      data: (audits) {
        if (audits.isEmpty) {
          return frame(
            'No audit running currently',
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
          );
        }
        return frame('Currently running audits', _RunningCarousel(audits));
      },
    );
  }
}

/// Full-width paged carousel of running-audit cards with page-dot indicators.
class _RunningCarousel extends StatefulWidget {
  const _RunningCarousel(this.audits);
  final List<Audit> audits;

  @override
  State<_RunningCarousel> createState() => _RunningCarouselState();
}

class _RunningCarouselState extends State<_RunningCarousel> {
  final _controller = PageController();
  int _page = 0;

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final audits = widget.audits;
    return Column(
      children: [
        SizedBox(
          // Cards are uniform height now (all rows single-line). ~200pt content
          // + small safety margin. Trim if a bottom gap shows.
          height: 210,
          child: PageView.builder(
            controller: _controller,
            itemCount: audits.length,
            onPageChanged: (i) => setState(() => _page = i),
            itemBuilder: (context, i) => Align(
              alignment: Alignment.topCenter,
              child: Padding(
                // Inset each page so adjacent cards have a gap when swiping.
                padding: const EdgeInsets.symmetric(horizontal: AppSpacing.s2),
                child: AuditCard(
                  audit: audits[i],
                  onTap: () => context.push('/audit/${audits[i].id}'),
                ),
              ),
            ),
          ),
        ),
        if (audits.length > 1) ...[
          const SizedBox(height: AppSpacing.s4),
          Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              for (var i = 0; i < audits.length; i++)
                AnimatedContainer(
                  duration: const Duration(milliseconds: 200),
                  margin: const EdgeInsets.symmetric(horizontal: 3),
                  width: i == _page ? 20 : 6,
                  height: 6,
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(AppRadius.pill),
                    color: i == _page
                        ? AppColors.textInverse
                        : AppColors.textInverse.withValues(alpha: 0.35),
                  ),
                ),
            ],
          ),
        ],
      ],
    );
  }
}

/// Upcoming-audits area of the white body: debounced search + vertical list.
/// Hides the search box until there is something to search; shows the rocket
/// empty state only when the auditor has no upcoming audits and no active query.
class _UpcomingSection extends ConsumerStatefulWidget {
  const _UpcomingSection();

  @override
  ConsumerState<_UpcomingSection> createState() => _UpcomingSectionState();
}

class _UpcomingSectionState extends ConsumerState<_UpcomingSection> {
  final _controller = TextEditingController();
  Timer? _debounce;

  @override
  void dispose() {
    _debounce?.cancel();
    _controller.dispose();
    super.dispose();
  }

  void _onChanged(String value) {
    _debounce?.cancel();
    _debounce = Timer(const Duration(milliseconds: 350), () {
      ref.read(upcomingSearchProvider.notifier).setQuery(value);
    });
  }

  @override
  Widget build(BuildContext context) {
    final async = ref.watch(upcomingAuditsProvider);
    final query = ref.watch(upcomingSearchProvider);
    final hasItems = async.asData?.value.isNotEmpty ?? false;
    final showSearch = hasItems || query.isNotEmpty;

    return Column(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: [
        if (showSearch) ...[
          AppSearchField(controller: _controller, onChanged: _onChanged),
          const SizedBox(height: AppSpacing.s4),
        ],
        async.when(
          loading: () => const Column(
            children: [
              AuditCardSkeleton(),
              SizedBox(height: AppSpacing.s4),
              AuditCardSkeleton(),
            ],
          ),
          error: (_, _) => Padding(
            padding: const EdgeInsets.symmetric(vertical: AppSpacing.s7),
            child: Text(
              "Couldn't load upcoming audits.",
              textAlign: TextAlign.center,
              style: AppText.bodyMRegular.copyWith(color: AppColors.textSubtle),
            ),
          ),
          data: (audits) {
            if (audits.isEmpty) {
              if (query.isNotEmpty) {
                return Padding(
                  padding: const EdgeInsets.symmetric(vertical: AppSpacing.s7),
                  child: Text(
                    'No audits match "$query".',
                    textAlign: TextAlign.center,
                    style: AppText.bodyMRegular.copyWith(
                      color: AppColors.textSubtle,
                    ),
                  ),
                );
              }
              return const Padding(
                padding: EdgeInsets.only(top: AppSpacing.s7),
                child: EmptyState(
                  asset: 'assets/vectors/Vectors.svg',
                  message: 'No upcoming audits. Enjoy the day off!',
                  illustrationSize: 80,
                ),
              );
            }
            return Column(
              children: [
                for (var i = 0; i < audits.length; i++) ...[
                  if (i > 0) const SizedBox(height: AppSpacing.s4),
                  AuditCard(
                    audit: audits[i],
                    onTap: () => context.push('/audit/${audits[i].id}'),
                  ),
                ],
              ],
            );
          },
        ),
      ],
    );
  }
}
