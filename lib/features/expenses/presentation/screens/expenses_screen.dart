import 'dart:io' show Platform;

import 'package:amanah/core/theme/app_colors.dart';
import 'package:amanah/core/theme/app_spacing.dart';
import 'package:amanah/core/theme/app_system_ui.dart';
import 'package:amanah/core/theme/app_text_styles.dart';
import 'package:amanah/core/widgets/app_avatar.dart';
import 'package:amanah/core/widgets/empty_state.dart';
import 'package:amanah/core/widgets/skeletons/expense_card_skeleton.dart';
import 'package:amanah/features/auth/presentation/providers/session_providers.dart';
import 'package:amanah/features/expenses/data/expense_repository.dart';
import 'package:amanah/features/expenses/presentation/providers/expense_providers.dart';
import 'package:amanah/features/expenses/presentation/widgets/expense_card.dart';
import 'package:amanah/features/notifications/presentation/providers/notification_providers.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:go_router/go_router.dart';
import 'package:intl/intl.dart';

/// Expenses tab — white header (identity + bell), "All expenses" title, a
/// date-filter search field, and the date-grouped expense cards. A floating
/// "+ Expense" button opens the new-expense sheet.
class ExpensesScreen extends ConsumerWidget {
  const ExpensesScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final user = ref.watch(currentUserProvider);

    return AnnotatedRegion<SystemUiOverlayStyle>(
      value: AppSystemUi.dark,
      child: ColoredBox(
        color: AppColors.bgDefault,
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            if (Platform.isAndroid) const SizedBox(height: AppSpacing.s2),
            _Header(name: user?.name, avatarUrl: user?.profilePictureUrl),
            const Expanded(child: _ExpensesBody()),
          ],
        ),
      ),
    );
  }
}

/// White page header: identity row + "All expenses" title + subtitle.
class _Header extends ConsumerWidget {
  const _Header({required this.name, required this.avatarUrl});

  final String? name;
  final String? avatarUrl;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final topInset = MediaQuery.of(context).viewPadding.top;
    final hasUnread = (ref.watch(unreadCountProvider).value ?? 0) > 0;
    return Container(
      width: double.infinity,
      color: AppColors.bgDefault,
      padding: EdgeInsets.fromLTRB(
        AppSpacing.s4,
        topInset + AppSpacing.s2,
        AppSpacing.s4,
        AppSpacing.s4,
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
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
                      style: AppText.bodyLMedium
                          .copyWith(color: AppColors.textDefault),
                    ),
                    GestureDetector(
                      onTap: () => context.go('/profile'),
                      child: Text(
                        'View profile',
                        style: AppText.bodySMedium.copyWith(
                          color: AppColors.textBrand,
                          decoration: TextDecoration.underline,
                          decorationColor: AppColors.textBrand,
                        ),
                      ),
                    ),
                  ],
                ),
              ),
              const SizedBox(width: AppSpacing.s3),
              _BellButton(hasUnread: hasUnread),
            ],
          ),
          const SizedBox(height: AppSpacing.s6),
          Text('All expenses', style: AppText.headingL),
          const SizedBox(height: AppSpacing.s1),
          Text(
            'List of all your expenses logged till now',
            style: AppText.bodyLRegular.copyWith(color: AppColors.textSubtle),
          ),
        ],
      ),
    );
  }
}

/// Grey-circle notification bell with an unread dot, for the light header.
class _BellButton extends StatelessWidget {
  const _BellButton({required this.hasUnread});
  final bool hasUnread;

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () => context.push('/notifications'),
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
              decoration: const BoxDecoration(
                shape: BoxShape.circle,
                color: AppColors.bgHovered,
              ),
              child: Center(
                child: SvgPicture.asset(
                  'assets/icons/line/Bell.svg',
                  width: 20,
                  colorFilter: const ColorFilter.mode(
                    AppColors.iconDefault,
                    BlendMode.srcIn,
                  ),
                ),
              ),
            ),
            if (hasUnread)
              Positioned(
                top: 0,
                right: 4,
                child: Container(
                  width: 10,
                  height: 10,
                  decoration: BoxDecoration(
                    shape: BoxShape.circle,
                    color: AppColors.iconNotification,
                    border: Border.all(color: AppColors.bgDefault, width: 2),
                  ),
                ),
              ),
          ],
        ),
      ),
    );
  }
}

class _ExpensesBody extends ConsumerWidget {
  const _ExpensesBody();

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final async = ref.watch(expenseGroupsProvider);
    final filter = ref.watch(expenseFilterProvider);
    final bottomClear =
        MediaQuery.of(context).viewPadding.bottom + AppSpacing.s9 + 56;

    Future<void> refresh() async {
      ref.invalidate(expenseGroupsProvider);
      try {
        await ref.read(expenseGroupsProvider.future);
      } on Object {
        // Errors surface in the error state; the pull just ends.
      }
    }

    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: AppSpacing.s4),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          _DateSearchField(
            filter: filter,
            onPick: (from, to) {
              if (from == to) {
                ref.read(expenseFilterProvider.notifier).setSingle(from);
              } else {
                ref.read(expenseFilterProvider.notifier).setRange(from, to);
              }
            },
            onClear: () => ref.read(expenseFilterProvider.notifier).clear(),
          ),
          const SizedBox(height: AppSpacing.s4),
          Expanded(
            child: RefreshIndicator(
              color: AppColors.brand,
              onRefresh: refresh,
              child: async.when(
                loading: () => ListView(
                  physics: const AlwaysScrollableScrollPhysics(
                    parent: ClampingScrollPhysics(),
                  ),
                  padding: EdgeInsets.only(bottom: bottomClear),
                  children: const [
                    ExpenseCardSkeleton(),
                    SizedBox(height: AppSpacing.s4),
                    ExpenseCardSkeleton(),
                    SizedBox(height: AppSpacing.s4),
                    ExpenseCardSkeleton(),
                  ],
                ),
                error: (_, _) => _CenteredScroll(
                  child: Text(
                    "Couldn't load expenses. Pull to refresh.",
                    textAlign: TextAlign.center,
                    style: AppText.bodyMRegular
                        .copyWith(color: AppColors.textSubtle),
                  ),
                ),
                data: (groups) {
                  if (groups.isEmpty) {
                    return _CenteredScroll(
                      child: EmptyState(
                        asset: 'assets/vectors/Vectors.svg',
                        title: filter.isEmpty
                            ? 'No expenses yet'
                            : 'No expenses found',
                        message: filter.isEmpty
                            ? 'Log your first expense with the + button'
                            : 'Try a different date',
                        illustrationSize: 140,
                      ),
                    );
                  }
                  return ListView.separated(
                    physics: const AlwaysScrollableScrollPhysics(
                      parent: ClampingScrollPhysics(),
                    ),
                    padding: EdgeInsets.only(bottom: bottomClear),
                    itemCount: groups.length,
                    separatorBuilder: (_, _) =>
                        const SizedBox(height: AppSpacing.s4),
                    itemBuilder: (context, i) => ExpenseCard(
                      group: groups[i],
                      onTap: () => context.push('/expense/${groups[i].dateKey}'),
                    ),
                  );
                },
              ),
            ),
          ),
        ],
      ),
    );
  }
}

/// Read-only field that opens a date-range picker (a single day = tap the same
/// date twice). Shows the active filter with a clear affordance.
class _DateSearchField extends StatelessWidget {
  const _DateSearchField({
    required this.filter,
    required this.onPick,
    required this.onClear,
  });

  final ExpenseFilter filter;
  final void Function(DateTime from, DateTime to) onPick;
  final VoidCallback onClear;

  static final _fmt = DateFormat('MMM d, yyyy');

  String? get _label {
    if (filter.date != null) return _fmt.format(filter.date!);
    if (filter.from != null && filter.to != null) {
      return '${_fmt.format(filter.from!)} – ${_fmt.format(filter.to!)}';
    }
    return null;
  }

  Future<void> _pick(BuildContext context) async {
    final now = DateTime.now();
    final range = await showDateRangePicker(
      context: context,
      firstDate: DateTime(now.year - 5),
      lastDate: DateTime(now.year + 1),
      initialDateRange: filter.from != null && filter.to != null
          ? DateTimeRange(start: filter.from!, end: filter.to!)
          : null,
    );
    if (range != null) onPick(range.start, range.end);
  }

  @override
  Widget build(BuildContext context) {
    final label = _label;
    final active = label != null;
    return InkWell(
      onTap: () => _pick(context),
      borderRadius: BorderRadius.circular(AppRadius.md),
      child: Container(
        height: 44,
        padding: const EdgeInsets.symmetric(horizontal: AppSpacing.s3),
        decoration: BoxDecoration(
          color: AppColors.bgDefault,
          borderRadius: BorderRadius.circular(AppRadius.md),
          border: Border.all(color: AppColors.borderDefault),
        ),
        child: Row(
          children: [
            const Icon(Icons.search, size: 20, color: AppColors.iconSubtle),
            const SizedBox(width: AppSpacing.s2),
            Expanded(
              child: Text(
                label ?? 'Search expenses by date',
                maxLines: 1,
                overflow: TextOverflow.ellipsis,
                style: AppText.bodyLRegular.copyWith(
                  color:
                      active ? AppColors.textDefault : AppColors.textSubtlest,
                ),
              ),
            ),
            if (active)
              GestureDetector(
                onTap: onClear,
                behavior: HitTestBehavior.opaque,
                child: const Icon(
                  Icons.close,
                  size: 20,
                  color: AppColors.iconSubtle,
                ),
              ),
          ],
        ),
      ),
    );
  }
}

/// Single child parked near the top but fully scrollable so pull-to-refresh
/// works over an empty/error list.
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
