import 'package:amanah/core/theme/app_colors.dart';
import 'package:amanah/core/theme/app_spacing.dart';
import 'package:amanah/core/theme/app_text_styles.dart';
import 'package:amanah/core/widgets/app_avatar.dart';
import 'package:amanah/features/notifications/data/models/app_notification.dart';
import 'package:amanah/features/notifications/presentation/widgets/notification_badge.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

/// Opens the notification detail modal. The type badge flies in via a Hero
/// shared with the tapped feed row.
Future<void> showNotificationDetail(
  BuildContext context,
  AppNotification item,
) {
  return showModalBottomSheet<void>(
    context: context,
    isScrollControlled: true,
    useSafeArea: true,
    backgroundColor: AppColors.bgDefault,
    shape: const RoundedRectangleBorder(
      borderRadius: BorderRadius.vertical(top: Radius.circular(AppRadius.xl)),
    ),
    builder: (_) => _NotificationDetailSheet(item: item),
  );
}

class _NotificationDetailSheet extends StatelessWidget {
  const _NotificationDetailSheet({required this.item});

  final AppNotification item;

  @override
  Widget build(BuildContext context) {
    final bottomInset = MediaQuery.of(context).viewPadding.bottom;

    return Padding(
      padding: EdgeInsets.fromLTRB(
        AppSpacing.s5,
        AppSpacing.s3,
        AppSpacing.s5,
        bottomInset + AppSpacing.s6,
      ),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          // Drag handle.
          Center(
            child: Container(
              width: 40,
              height: 4,
              decoration: BoxDecoration(
                color: AppColors.borderDefault,
                borderRadius: BorderRadius.circular(AppRadius.pill),
              ),
            ),
          ),
          const SizedBox(height: AppSpacing.s6),
          Center(
            child: Hero(
              tag: notificationBadgeTag(item.id),
              child: NotificationBadge(alert: item.isAlert, size: 56),
            ),
          ),
          const SizedBox(height: AppSpacing.s4),
          Text(
            item.title,
            textAlign: TextAlign.center,
            style: AppText.headingS.copyWith(color: AppColors.textDefault),
          ),
          const SizedBox(height: AppSpacing.s1),
          Text(
            _dateFmt.format(item.createdAt.toLocal()),
            textAlign: TextAlign.center,
            style:
                AppText.bodySRegular.copyWith(color: AppColors.textSubtlest),
          ),
          const SizedBox(height: AppSpacing.s5),
          Divider(height: 1, color: AppColors.borderDefault),
          const SizedBox(height: AppSpacing.s5),
          Text(
            item.message,
            style:
                AppText.bodyLRegular.copyWith(color: AppColors.textDefault),
          ),
          if (item.causerName != null && item.causerName!.isNotEmpty) ...[
            const SizedBox(height: AppSpacing.s6),
            _CauserRow(
              name: item.causerName!,
              type: item.causerType,
              avatarUrl: item.causerAvatarUrl,
            ),
          ],
        ],
      ),
    );
  }
}

/// "From {name}" with the causer's avatar and a subtle role label.
class _CauserRow extends StatelessWidget {
  const _CauserRow({required this.name, this.type, this.avatarUrl});

  final String name;
  final String? type;
  final String? avatarUrl;

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        AppAvatar(url: avatarUrl, size: 32),
        const SizedBox(width: AppSpacing.s3),
        Expanded(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                name,
                maxLines: 1,
                overflow: TextOverflow.ellipsis,
                style: AppText.bodyMSemiBold
                    .copyWith(color: AppColors.textDefault),
              ),
              if (type != null && type!.isNotEmpty)
                Text(
                  _titleCase(type!),
                  style: AppText.bodySRegular
                      .copyWith(color: AppColors.textSubtle),
                ),
            ],
          ),
        ),
      ],
    );
  }
}

/// `system` -> `System`, `client` -> `Client`.
String _titleCase(String value) =>
    value.isEmpty ? value : value[0].toUpperCase() + value.substring(1);

final _dateFmt = DateFormat('MMM d, yyyy h:mm a');
