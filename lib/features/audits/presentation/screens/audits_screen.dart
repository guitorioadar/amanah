import 'dart:async';

import 'package:amanah/core/theme/app_colors.dart';
import 'package:amanah/core/theme/app_spacing.dart';
import 'package:amanah/core/theme/app_system_ui.dart';
import 'package:amanah/core/theme/app_text_styles.dart';
import 'package:amanah/core/widgets/app_search_field.dart';
import 'package:amanah/core/widgets/app_tabs.dart';
import 'package:amanah/core/widgets/audit_card.dart';
import 'package:amanah/core/widgets/empty_state.dart';
import 'package:amanah/core/widgets/identity_bar.dart';
import 'package:amanah/core/widgets/skeletons/audit_card_skeleton.dart';
import 'package:amanah/features/audits/presentation/providers/audit_providers.dart';
import 'package:amanah/features/auth/presentation/providers/session_providers.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

/// Audits tab — navy header over a white body with a segmented control
/// (Assigned / In progress / Completed), a shared search box, and the matching
/// list of audit cards. Each tab loads independently with a shimmer placeholder
/// and its own empty state.
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
                const Expanded(child: _AuditsBody()),
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

/// White body: segmented tabs + debounced search + the active tab's list.
class _AuditsBody extends ConsumerStatefulWidget {
  const _AuditsBody();

  @override
  ConsumerState<_AuditsBody> createState() => _AuditsBodyState();
}

class _AuditsBodyState extends ConsumerState<_AuditsBody> {
  static const List<AuditTab> _tabs = AuditTab.values;

  final _controller = TextEditingController();
  Timer? _debounce;
  int _index = 0;

  @override
  void dispose() {
    _debounce?.cancel();
    _controller.dispose();
    super.dispose();
  }

  void _onSearchChanged(String value) {
    _debounce?.cancel();
    _debounce = Timer(const Duration(milliseconds: 350), () {
      ref.read(auditsSearchProvider.notifier).setQuery(value);
    });
  }

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: AppSpacing.s4),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          const SizedBox(height: AppSpacing.s5),
          AppTabs(
            labels: [for (final t in _tabs) t.label],
            selected: _index,
            onChanged: (i) => setState(() => _index = i),
          ),
          const SizedBox(height: AppSpacing.s4),
          AppSearchField(
            controller: _controller,
            onChanged: _onSearchChanged,
          ),
          const SizedBox(height: AppSpacing.s4),
          Expanded(child: _TabList(_tabs[_index])),
        ],
      ),
    );
  }
}

/// Scrollable list for one tab: shimmer while loading, an empty state when the
/// tab (or search) yields nothing, or the audit cards. Pull-to-refresh reloads
/// the active tab.
class _TabList extends ConsumerWidget {
  const _TabList(this.tab);

  final AuditTab tab;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final async = ref.watch(auditsTabProvider(tab));
    final query = ref.watch(auditsSearchProvider);
    final topInset = MediaQuery.of(context).viewPadding.top;

    // Clear the bottom nav + FAB so the last card isn't tucked under them.
    final bottomClear =
        MediaQuery.of(context).viewPadding.bottom + AppSpacing.s9 + 56;

    Future<void> refresh() async {
      ref.invalidate(auditsTabProvider(tab));
      try {
        await ref.read(auditsTabProvider(tab).future);
      } on Object {
        // Errors surface in the error state; the pull just ends.
      }
    }

    return RefreshIndicator(
      color: AppColors.brand,
      displacement: topInset + AppSpacing.s5,
      onRefresh: refresh,
      child: async.when(
        loading: () => ListView(
          physics: const AlwaysScrollableScrollPhysics(
            parent: ClampingScrollPhysics(),
          ),
          padding: const EdgeInsets.only(bottom: AppSpacing.s6),
          children: const [
            AuditCardSkeleton(),
            SizedBox(height: AppSpacing.s4),
            AuditCardSkeleton(),
            SizedBox(height: AppSpacing.s4),
            AuditCardSkeleton(),
          ],
        ),
        error: (_, _) => _CenteredScroll(
          child: Text(
            "Couldn't load audits. Pull to refresh.",
            textAlign: TextAlign.center,
            style: AppText.bodyMRegular.copyWith(color: AppColors.textSubtle),
          ),
        ),
        data: (audits) {
          if (audits.isEmpty) {
            if (query.isNotEmpty) {
              return _CenteredScroll(
                child: Text(
                  'No audits match "$query".',
                  textAlign: TextAlign.center,
                  style: AppText.bodyMRegular
                      .copyWith(color: AppColors.textSubtle),
                ),
              );
            }
            final empty = _emptyFor(tab);
            return _CenteredScroll(
              child: EmptyState(
                asset: empty.asset,
                title: empty.title,
                message: empty.message,
                illustrationSize: 140,
              ),
            );
          }
          return ListView.separated(
            physics: const AlwaysScrollableScrollPhysics(
              parent: ClampingScrollPhysics(),
            ),
            padding: EdgeInsets.only(bottom: bottomClear),
            itemCount: audits.length,
            separatorBuilder: (_, _) => const SizedBox(height: AppSpacing.s4),
            itemBuilder: (context, i) => AuditCard(
              audit: audits[i],
              onTap: () {}, // TODO(M4): open audit details
            ),
          );
        },
      ),
    );
  }

  _EmptyCopy _emptyFor(AuditTab tab) => switch (tab) {
        AuditTab.assigned => const _EmptyCopy(
            asset: 'assets/vectors/Vectors-3.svg',
            title: 'Nothing assigned yet!',
            message: 'Enjoy the day off',
          ),
        AuditTab.inProgress => const _EmptyCopy(
            asset: 'assets/vectors/Vectors-1.svg',
            title: 'Nothing in progress',
            message: 'No audits are running right now',
          ),
        AuditTab.completed => const _EmptyCopy(
            asset: 'assets/vectors/Vectors.svg',
            title: 'No completed audits',
            message: 'Finished audits will show up here',
          ),
      };
}

/// Empty-state copy + illustration for a tab.
class _EmptyCopy {
  const _EmptyCopy({
    required this.asset,
    required this.title,
    required this.message,
  });
  final String asset;
  final String title;
  final String message;
}

/// A single child parked near the top of the scroll area, but still fully
/// scrollable so pull-to-refresh works over an empty/error list.
class _CenteredScroll extends StatelessWidget {
  const _CenteredScroll({required this.child});
  final Widget child;

  @override
  Widget build(BuildContext context) {
    return LayoutBuilder(
      builder: (context, constraints) => SingleChildScrollView(
        physics: const AlwaysScrollableScrollPhysics(
          parent: ClampingScrollPhysics(),
        ),
        child: ConstrainedBox(
          constraints: BoxConstraints(minHeight: constraints.maxHeight),
          child: Padding(
            padding: const EdgeInsets.only(top: AppSpacing.s9),
            child: Align(alignment: Alignment.topCenter, child: child),
          ),
        ),
      ),
    );
  }
}
