import 'package:amanah/core/theme/app_colors.dart';
import 'package:amanah/core/theme/app_spacing.dart';
import 'package:amanah/core/theme/app_text_styles.dart';
import 'package:amanah/features/audits/data/models/audit.dart';
import 'package:flutter/material.dart';

/// Status pill colored by [AuditSection] — tinted fill + colored border/text.
/// Shared by the audit card and the Audit-details header.
class AuditStatusChip extends StatelessWidget {
  const AuditStatusChip(this.section, {super.key});

  final AuditSection section;

  @override
  Widget build(BuildContext context) {
    // `assigned` never labels a card (items carry their real section); it maps
    // to the in-progress style only to keep the switch exhaustive.
    final color = switch (section) {
      AuditSection.running || AuditSection.assigned => AppColors.brand,
      AuditSection.upcoming => AppColors.textWarning,
      AuditSection.completed => AppColors.textSuccess,
    };
    final bg = switch (section) {
      AuditSection.running || AuditSection.assigned => AppColors.bgChipInProgress,
      AuditSection.upcoming => AppColors.bgChipUpcoming,
      AuditSection.completed => AppColors.bgChipCompleted,
    };
    return Container(
      padding: const EdgeInsets.symmetric(
        horizontal: AppSpacing.s3,
        vertical: 3,
      ),
      decoration: BoxDecoration(
        color: bg,
        borderRadius: BorderRadius.circular(AppRadius.sm),
        border: Border.all(color: color),
      ),
      child: Text(
        section.chipLabel,
        style: AppText.buttonS.copyWith(color: color),
      ),
    );
  }
}

/// Neutral gray tag chip (category / audit type). Shared by the audit card and
/// the Audit-details header.
class AuditTagChip extends StatelessWidget {
  const AuditTagChip(this.label, {super.key});

  final String label;

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(
        horizontal: AppSpacing.s3,
        vertical: 3,
      ),
      decoration: BoxDecoration(
        color: AppColors.bgPressed,
        borderRadius: BorderRadius.circular(AppRadius.sm),
        border: Border.all(color: AppColors.borderDefault),
      ),
      child: Text(
        label,
        style: AppText.buttonS.copyWith(color: AppColors.textDefault),
      ),
    );
  }
}
