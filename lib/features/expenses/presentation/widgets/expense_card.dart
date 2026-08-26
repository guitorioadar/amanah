import 'package:amanah/core/theme/app_colors.dart';
import 'package:amanah/core/theme/app_spacing.dart';
import 'package:amanah/core/theme/app_text_styles.dart';
import 'package:amanah/features/expenses/data/models/expense_group.dart';
import 'package:amanah/features/expenses/presentation/widgets/expense_common.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:intl/intl.dart';

/// Expense summary card on the "All expenses" list — a date group. Top zone:
/// date + category chips. Footer: total (after tax) · receipt pill · Details.
class ExpenseCard extends StatelessWidget {
  const ExpenseCard({required this.group, this.onTap, super.key});

  final ExpenseGroup group;
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
                padding: const EdgeInsets.all(14),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      _dateFmt.format(group.expenseDate),
                      style: AppText.headingS,
                    ),
                    const SizedBox(height: AppSpacing.s3),
                    CategoryChips(categories: group.categories),
                  ],
                ),
              ),
              Divider(height: 1, thickness: 1, color: AppColors.borderDefault),
              Padding(
                padding: const EdgeInsets.symmetric(
                  horizontal: 14,
                  vertical: AppSpacing.s3,
                ),
                child: _Footer(group: group),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

class _Footer extends StatelessWidget {
  const _Footer({required this.group});
  final ExpenseGroup group;

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        SvgPicture.asset(
          'assets/icons/fill/CurrencyCircleDollar.svg',
          width: 20,
          colorFilter: const ColorFilter.mode(
            AppColors.iconDefault,
            BlendMode.srcIn,
          ),
        ),
        const SizedBox(width: AppSpacing.s1),
        Text(
          formatMoney(group.totalAfterTax),
          style: AppText.bodyLSemiBold.copyWith(color: AppColors.textDefault),
        ),
        const SizedBox(width: AppSpacing.s3),
        Container(width: 1, height: 16, color: AppColors.borderDefault),
        const SizedBox(width: AppSpacing.s3),
        ReceiptPill(
          count: group.receiptsCount,
          required: group.receiptsRequired,
        ),
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
