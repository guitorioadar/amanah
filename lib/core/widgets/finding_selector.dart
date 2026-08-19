import 'package:amanah/core/theme/app_colors.dart';
import 'package:amanah/core/theme/app_spacing.dart';
import 'package:amanah/core/theme/app_text_styles.dart';
import 'package:amanah/features/audits/data/models/audit_detail.dart';
import 'package:flutter/material.dart';

/// Three-way finding selector (Compliant / Non-compliant / N/A), 32pt pills.
/// Reflects [selected] and calls [onChanged] on tap. Used on the observation
/// list (tap opens the submission sheet) and inside the sheet (tap sets it).
class FindingSelector extends StatelessWidget {
  const FindingSelector({
    required this.selected,
    required this.onChanged,
    super.key,
  });

  final Finding? selected;
  final ValueChanged<Finding> onChanged;

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        for (final finding in Finding.values) ...[
          if (finding != Finding.values.first)
            const SizedBox(width: AppSpacing.s2),
          Expanded(
            child: _Pill(
              finding: finding,
              selected: selected == finding,
              onTap: () => onChanged(finding),
            ),
          ),
        ],
      ],
    );
  }
}

class _Pill extends StatelessWidget {
  const _Pill({
    required this.finding,
    required this.selected,
    required this.onTap,
  });

  final Finding finding;
  final bool selected;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    final (text, bg) = switch (finding) {
      Finding.compliant => (AppColors.textSuccess, AppColors.bgSuccess),
      Finding.nonCompliant => (AppColors.textDanger, AppColors.bgDanger),
      Finding.na => (AppColors.textDefault, AppColors.bgPressed),
    };
    return GestureDetector(
      onTap: onTap,
      behavior: HitTestBehavior.opaque,
      child: Container(
        height: 32,
        alignment: Alignment.center,
        padding: const EdgeInsets.symmetric(horizontal: AppSpacing.s1),
        decoration: BoxDecoration(
          color: selected ? bg : AppColors.transparent,
          borderRadius: BorderRadius.circular(AppRadius.sm),
          border: Border.all(
            color: selected ? text : AppColors.borderDefault,
          ),
        ),
        child: Text(
          finding.label,
          maxLines: 1,
          overflow: TextOverflow.ellipsis,
          style: AppText.buttonS.copyWith(
            color: selected ? text : AppColors.textDefault,
          ),
        ),
      ),
    );
  }
}
