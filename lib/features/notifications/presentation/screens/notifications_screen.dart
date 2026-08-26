import 'dart:async';

import 'package:amanah/core/theme/app_colors.dart';
import 'package:amanah/core/theme/app_spacing.dart';
import 'package:amanah/core/theme/app_system_ui.dart';
import 'package:amanah/core/theme/app_text_styles.dart';
import 'package:amanah/core/widgets/app_tabs.dart';
import 'package:amanah/core/widgets/skeletons/notifications_skeleton.dart';
import 'package:amanah/features/notifications/data/models/app_notification.dart';
import 'package:amanah/features/notifications/presentation/providers/notification_providers.dart';
import 'package:amanah/features/notifications/presentation/widgets/notification_badge.dart';
import 'package:amanah/features/notifications/presentation/widgets/notification_detail_sheet.dart';
import 'package:amanah/features/profile/presentation/widgets/profile_top_bar.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:intl/intl.dart';

/// Notifications feed: grouped by recency (This week / This month / Earlier),
/// filterable by Unread / All. Tapping a row marks it read. Pull to refresh.
class NotificationsScreen extends ConsumerStatefulWidget {
  const NotificationsScreen({super.key});

  @override
  ConsumerState<NotificationsScreen> createState() =>
      _NotificationsScreenState();
}

class _NotificationsScreenState extends ConsumerState<NotificationsScreen> {
  /// 0 = Unread, 1 = All notifications.
  int _tab = 0;

  @override
  Widget build(BuildContext context) {
    final topInset = MediaQuery.of(context).viewPadding.top;
    final async = ref.watch(notificationsProvider);

    return AnnotatedRegion<SystemUiOverlayStyle>(
      value: AppSystemUi.dark,
      child: Scaffold(
        backgroundColor: AppColors.bgDefault,
        body: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            const SizedBox(height: AppSpacing.s2),
            ProfileTopBar(title: 'Notifications', topInset: topInset),
            Padding(
              padding: const EdgeInsets.fromLTRB(
                AppSpacing.s4,
                AppSpacing.s5,
                AppSpacing.s4,
                AppSpacing.s4,
              ),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.stretch,
                children: [
                  Text('All notifications', style: AppText.headingL),
                  const SizedBox(height: AppSpacing.s5),
                  AppTabs(
                    labels: const ['Unread', 'All notifications'],
                    selected: _tab,
                    onChanged: (i) => setState(() => _tab = i),
                  ),
                ],
              ),
            ),
            Expanded(
              child: RefreshIndicator(
                color: AppColors.brand,
                displacement: AppSpacing.s5,
                onRefresh: () =>
                    ref.read(notificationsProvider.notifier).refresh(),
                child: async.when(
                  loading: () => const NotificationsSkeleton(),
                  error: (_, _) => _ErrorState(
                    onRetry: () => ref.invalidate(notificationsProvider),
                  ),
                  data: (all) {
                    final items = _tab == 0
                        ? all.where((n) => n.isUnread).toList()
                        : all;
                    if (items.isEmpty) return const _EmptyState();
                    return _NotificationList(items: items);
                  },
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}

/// Grouped, scrollable feed. Section bands + rows with dividers.
class _NotificationList extends ConsumerWidget {
  const _NotificationList({required this.items});

  final List<AppNotification> items;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final groups = _groupByRecency(items);

    return ListView.builder(
      // Always scrollable so pull-to-refresh works even with a short list.
      physics: const AlwaysScrollableScrollPhysics(),
      padding: EdgeInsets.only(
        bottom: MediaQuery.of(context).viewPadding.bottom + AppSpacing.s6,
      ),
      itemCount: groups.length,
      itemBuilder: (context, i) {
        final group = groups[i];
        return Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            _SectionHeader(label: group.label),
            for (var j = 0; j < group.items.length; j++) ...[
              _NotificationTile(
                item: group.items[j],
                onTap: () {
                  final item = group.items[j];
                  unawaited(
                    ref.read(notificationsProvider.notifier).markRead(item.id),
                  );
                  unawaited(showNotificationDetail(context, item));
                },
              ),
              if (j != group.items.length - 1)
                Divider(
                  height: 1,
                  indent: AppSpacing.s4,
                  endIndent: AppSpacing.s4,
                  color: AppColors.borderDefault,
                ),
            ],
          ],
        );
      },
    );
  }
}

class _SectionHeader extends StatelessWidget {
  const _SectionHeader({required this.label});

  final String label;

  @override
  Widget build(BuildContext context) {
    return Container(
      width: double.infinity,
      color: AppColors.bgHovered,
      padding: const EdgeInsets.symmetric(
        horizontal: AppSpacing.s4,
        vertical: AppSpacing.s2,
      ),
      child: Text(
        label.toUpperCase(),
        style: AppText.bodySMedium.copyWith(
          color: AppColors.textSubtle,
          letterSpacing: 0.6,
        ),
      ),
    );
  }
}

class _NotificationTile extends StatelessWidget {
  const _NotificationTile({required this.item, required this.onTap});

  final AppNotification item;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: onTap,
      child: Padding(
        padding: const EdgeInsets.symmetric(
          horizontal: AppSpacing.s4,
          vertical: AppSpacing.s4,
        ),
        child: Row(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Hero(
              tag: notificationBadgeTag(item.id),
              child: NotificationBadge(alert: item.isAlert),
            ),
            const SizedBox(width: AppSpacing.s3),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    item.title,
                    style: AppText.bodyLSemiBold
                        .copyWith(color: AppColors.textDefault),
                  ),
                  const SizedBox(height: AppSpacing.s1),
                  Text(
                    item.message,
                    style: AppText.bodyMRegular
                        .copyWith(color: AppColors.textSubtle),
                  ),
                  const SizedBox(height: AppSpacing.s2),
                  Text(
                    _dateFmt.format(item.createdAt.toLocal()),
                    style: AppText.bodySRegular
                        .copyWith(color: AppColors.textSubtlest),
                  ),
                ],
              ),
            ),
            const SizedBox(width: AppSpacing.s3),
            // Unread indicator dot.
            SizedBox(
              width: 8,
              child: item.isUnread
                  ? Padding(
                      padding: const EdgeInsets.only(top: AppSpacing.s2),
                      child: Container(
                        width: 8,
                        height: 8,
                        decoration: const BoxDecoration(
                          shape: BoxShape.circle,
                          color: AppColors.brand,
                        ),
                      ),
                    )
                  : null,
            ),
          ],
        ),
      ),
    );
  }
}

class _EmptyState extends StatelessWidget {
  const _EmptyState();

  @override
  Widget build(BuildContext context) {
    // Scrollable so pull-to-refresh works on the empty view too.
    return ListView(
      physics: const AlwaysScrollableScrollPhysics(),
      children: [
        SizedBox(height: MediaQuery.of(context).size.height * 0.18),
        SvgPicture.asset('assets/vectors/Vectors-2.svg', width: 80),
        const SizedBox(height: AppSpacing.s5),
        Text(
          'All caught up!',
          textAlign: TextAlign.center,
          style: AppText.headingM.copyWith(color: AppColors.textDefault),
        ),
      ],
    );
  }
}

class _ErrorState extends StatelessWidget {
  const _ErrorState({required this.onRetry});

  final VoidCallback onRetry;

  @override
  Widget build(BuildContext context) {
    return ListView(
      physics: const AlwaysScrollableScrollPhysics(),
      children: [
        SizedBox(height: MediaQuery.of(context).size.height * 0.2),
        Padding(
          padding: const EdgeInsets.symmetric(horizontal: AppSpacing.s6),
          child: Text(
            "Couldn't load notifications. Pull to refresh.",
            textAlign: TextAlign.center,
            style:
                AppText.bodyMRegular.copyWith(color: AppColors.textSubtlest),
          ),
        ),
      ],
    );
  }
}

final _dateFmt = DateFormat('MMM d, yyyy h:mm a');

/// A recency bucket with its ordered notifications.
typedef _Group = ({String label, List<AppNotification> items});

/// Splits [items] (already newest-first) into This week / This month / Earlier,
/// dropping empty buckets while preserving order.
List<_Group> _groupByRecency(List<AppNotification> items) {
  final now = DateTime.now();
  final week = <AppNotification>[];
  final month = <AppNotification>[];
  final earlier = <AppNotification>[];

  for (final n in items) {
    final d = n.createdAt.toLocal();
    if (now.difference(d).inDays < 7) {
      week.add(n);
    } else if (d.year == now.year && d.month == now.month) {
      month.add(n);
    } else {
      earlier.add(n);
    }
  }

  return [
    if (week.isNotEmpty) (label: 'This week', items: week),
    if (month.isNotEmpty) (label: 'This month', items: month),
    if (earlier.isNotEmpty) (label: 'Earlier', items: earlier),
  ];
}
