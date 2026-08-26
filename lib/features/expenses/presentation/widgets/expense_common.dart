import 'package:amanah/core/theme/app_colors.dart';
import 'package:amanah/core/theme/app_spacing.dart';
import 'package:amanah/core/theme/app_text_styles.dart';
import 'package:amanah/core/widgets/audit_chips.dart';
import 'package:amanah/features/expenses/data/models/expense_group.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';

/// Foreground color for a [ReceiptState] — red (none), amber (partial),
/// green (complete). Shared by the receipt pill on the card + detail summary.
Color receiptColor(ReceiptState state) => switch (state) {
      ReceiptState.none => AppColors.textDanger,
      ReceiptState.partial => AppColors.ringWarning,
      ReceiptState.complete => AppColors.textSuccess,
    };

/// `▤ N/M receipts` — a receipt glyph + fraction, tinted by coverage state.
class ReceiptPill extends StatelessWidget {
  const ReceiptPill({
    required this.count,
    required this.required,
    this.textStyle,
    super.key,
  });

  final int count;
  final int required;
  final TextStyle? textStyle;

  @override
  Widget build(BuildContext context) {
    final color = receiptColor(receiptStateOf(count, required));
    return Row(
      mainAxisSize: MainAxisSize.min,
      children: [
        SvgPicture.asset(
          'assets/icons/fill/FileText.svg',
          width: 18,
          colorFilter: ColorFilter.mode(color, BlendMode.srcIn),
        ),
        const SizedBox(width: AppSpacing.s1),
        Text(
          '$count/$required receipts',
          style: (textStyle ?? AppText.bodyMMedium).copyWith(color: color),
        ),
      ],
    );
  }
}

/// Wrapping row of grey category chips with a `+N` overflow chip once more than
/// [maxVisible] categories exist. Reuses the shared [AuditTagChip] look.
class CategoryChips extends StatelessWidget {
  const CategoryChips({required this.categories, this.maxVisible = 3, super.key});

  final List<String> categories;
  final int maxVisible;

  @override
  Widget build(BuildContext context) {
    if (categories.isEmpty) return const SizedBox.shrink();
    final visible = categories.take(maxVisible).toList();
    final overflow = categories.length - visible.length;
    return Wrap(
      spacing: AppSpacing.s2,
      runSpacing: AppSpacing.s2,
      children: [
        for (final c in visible) AuditTagChip(c),
        if (overflow > 0) AuditTagChip('+$overflow'),
      ],
    );
  }
}
