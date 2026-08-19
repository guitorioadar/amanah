import 'package:amanah/core/theme/app_colors.dart';
import 'package:amanah/core/theme/app_spacing.dart';
import 'package:amanah/core/theme/app_text_styles.dart';
import 'package:amanah/core/widgets/audit_chips.dart';
import 'package:amanah/core/widgets/progress_ring.dart';
import 'package:amanah/features/audits/data/models/audit.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:intl/intl.dart';

/// Audit summary card — used on the Home carousel + Upcoming list, and (M4) the
/// Audits tab. Renders one of three looks based on [Audit.section]:
/// In progress (blue chip, amber ring), Upcoming (orange chip, empty ring,
/// "N observations"), Completed (green chip, full green ring + check).
class AuditCard extends StatelessWidget {
  const AuditCard({required this.audit, this.onTap, super.key});

  final Audit audit;
  final VoidCallback? onTap;

  static final _dateFmt = DateFormat('MMM d, yyyy');

  @override
  Widget build(BuildContext context) {
    return Material(
      color: AppColors.bgDefault,
      borderRadius: BorderRadius.circular(AppRadius.md),
      child: InkWell(
        onTap: onTap,
        borderRadius: BorderRadius.circular(AppRadius.md),
        child: DecoratedBox(
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(AppRadius.md),
            border: Border.all(color: AppColors.borderDefault),
          ),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Padding(
                // 14pt content inset per Figma (not on the 4pt token scale).
                padding: const EdgeInsets.all(14),
                child: _Body(audit: audit, dateFmt: _dateFmt),
              ),
              Divider(height: 1, thickness: 1, color: AppColors.borderDefault),
              Padding(
                padding: const EdgeInsets.symmetric(
                  horizontal: 14,
                  vertical: AppSpacing.s3,
                ),
                child: _Footer(audit: audit),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

class _Body extends StatelessWidget {
  const _Body({required this.audit, required this.dateFmt});
  final Audit audit;
  final DateFormat dateFmt;

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        SingleChildScrollView(
          scrollDirection: Axis.horizontal,
          child: Row(
            children: [
              AuditStatusChip(audit.section),
              if (audit.categoryName != null) ...[
                const SizedBox(width: AppSpacing.s2),
                AuditTagChip(audit.categoryName!),
              ],
              if (audit.auditType != null) ...[
                const SizedBox(width: AppSpacing.s2),
                AuditTagChip(audit.auditType!),
              ],
            ],
          ),
        ),
        const SizedBox(height: AppSpacing.s3),
        Text(
          audit.title,
          maxLines: 1,
          overflow: TextOverflow.ellipsis,
          style: AppText.bodyLMedium,
        ),
        const SizedBox(height: AppSpacing.s2),
        // Location row always renders (placeholder when null) so every card
        // keeps the same height inside the fixed-height carousel.
        Row(
          children: [
            SvgPicture.asset(
              'assets/icons/fill/MapPin.svg',
              width: 18,
              colorFilter: const ColorFilter.mode(
                AppColors.iconSubtle,
                BlendMode.srcIn,
              ),
            ),
            const SizedBox(width: AppSpacing.s1),
            Expanded(
              child: Text(
                audit.location ?? 'No location provided',
                maxLines: 1,
                overflow: TextOverflow.ellipsis,
                style: AppText.bodyMRegular.copyWith(
                  color: AppColors.textSubtle,
                ),
              ),
            ),
          ],
        ),
        const SizedBox(height: AppSpacing.s3),
        SingleChildScrollView(
          scrollDirection: Axis.horizontal,
          child: Row(
            children: [
              if (audit.client != null)
                _MetaChip(
                  image: 'assets/images/3.0x/avatar.png',
                  label: audit.client!.name,
                ),
              if (audit.client != null && audit.eventDate != null)
                const SizedBox(width: AppSpacing.s2),
              if (audit.eventDate != null)
                _MetaChip(
                  icon: 'CalendarBlank',
                  label: dateFmt.format(audit.eventDate!),
                ),
            ],
          ),
        ),
      ],
    );
  }
}

class _Footer extends StatelessWidget {
  const _Footer({required this.audit});
  final Audit audit;

  @override
  Widget build(BuildContext context) {
    final isUpcoming = audit.section == AuditSection.upcoming;
    final isCompleted = audit.section == AuditSection.completed;
    final countText = isUpcoming
        ? '${audit.observationsTotal} observations'
        : '${audit.observationsCompleted}/${audit.observationsTotal}';

    return Row(
      children: [
        ProgressRing(
          percent: audit.progressPercent,
          color: isCompleted ? AppColors.ringSuccess : AppColors.ringWarning,
          track: isCompleted
              ? AppColors.ringSuccessTrack
              : AppColors.ringWarningTrack,
        ),
        const SizedBox(width: AppSpacing.s2),
        Text(
          '${audit.progressPercent}%',
          style: AppText.bodyMMedium.copyWith(color: AppColors.textDefault),
        ),
        const SizedBox(width: AppSpacing.s3),
        Container(width: 1, height: 16, color: AppColors.borderDefault),
        const SizedBox(width: AppSpacing.s3),
        SvgPicture.asset(
          'assets/icons/line/ListChecks.svg',
          width: 18,
          colorFilter: const ColorFilter.mode(
            AppColors.iconSubtle,
            BlendMode.srcIn,
          ),
        ),
        const SizedBox(width: AppSpacing.s1),
        Text(
          countText,
          style: AppText.bodyMRegular.copyWith(color: AppColors.textSubtle),
        ),
        if (isCompleted) ...[
          const SizedBox(width: AppSpacing.s1),
          SvgPicture.asset(
            'assets/icons/fill/CheckCircle.svg',
            width: 16,
            colorFilter: const ColorFilter.mode(
              AppColors.iconSuccess,
              BlendMode.srcIn,
            ),
          ),
        ],
        const Spacer(),
        Text(
          'Details',
          style: AppText.buttonM.copyWith(color: AppColors.textDefault),
        ),
        SvgPicture.asset(
          'assets/icons/line/CaretRight.svg',
          width: 18,
          colorFilter: const ColorFilter.mode(
            AppColors.iconDefault,
            BlendMode.srcIn,
          ),
        ),
      ],
    );
  }
}

/// Outlined meta chip with a leading glyph (client / date). Pass [icon] for a
/// tinted line-icon (e.g. the date's calendar) or [image] for a full-color
/// raster (the client avatar).
class _MetaChip extends StatelessWidget {
  const _MetaChip({required this.label, this.icon, this.image})
      : assert(icon != null || image != null, 'need an icon or an image');
  final String label;
  final String? icon;
  final String? image;

  @override
  Widget build(BuildContext context) {
    final leading = image != null
        ? Image.asset(image!, width: 16, height: 16)
        : SvgPicture.asset(
            'assets/icons/fill/$icon.svg',
            width: 16,
            colorFilter: const ColorFilter.mode(
              AppColors.iconSubtle,
              BlendMode.srcIn,
            ),
          );
    return Container(
      padding: const EdgeInsets.symmetric(
        horizontal: AppSpacing.s3,
        vertical: 3,
      ),
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(AppRadius.sm),
        border: Border.all(color: AppColors.borderDefault),
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          leading,
          const SizedBox(width: AppSpacing.s1),
          Text(
            label,
            style: AppText.buttonS.copyWith(color: AppColors.textDefault),
          ),
        ],
      ),
    );
  }
}
