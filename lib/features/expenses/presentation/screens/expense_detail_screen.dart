import 'dart:async';

import 'package:amanah/core/theme/app_colors.dart';
import 'package:amanah/core/theme/app_spacing.dart';
import 'package:amanah/core/theme/app_system_ui.dart';
import 'package:amanah/core/theme/app_text_styles.dart';
import 'package:amanah/core/widgets/app_button.dart';
import 'package:amanah/core/widgets/media_viewer.dart';
import 'package:amanah/core/widgets/skeletons/expense_detail_skeleton.dart';
import 'package:amanah/features/expenses/data/models/expense_detail.dart';
import 'package:amanah/features/expenses/data/models/expense_group.dart';
import 'package:amanah/features/expenses/presentation/providers/expense_providers.dart';
import 'package:amanah/features/expenses/presentation/widgets/expense_common.dart';
import 'package:amanah/features/expenses/presentation/widgets/expense_media.dart';
import 'package:amanah/features/expenses/presentation/widgets/new_expense_sheet.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:go_router/go_router.dart';
import 'package:intl/intl.dart';
import 'package:url_launcher/url_launcher.dart';

/// Expense-details screen for one date group. Read-only summary + line-item
/// table + pooled receipts, with a sticky "New expense" action that prefills
/// this date.
class ExpenseDetailScreen extends ConsumerWidget {
  const ExpenseDetailScreen({required this.dateKey, super.key});

  final String dateKey;

  static final _dateFmt = DateFormat('MMM d, yyyy');

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final async = ref.watch(expenseDetailProvider(dateKey));

    return AnnotatedRegion<SystemUiOverlayStyle>(
      value: AppSystemUi.dark,
      child: Scaffold(
        backgroundColor: AppColors.bgDefault,
        body: SafeArea(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              _TopBar(onBack: () => context.pop()),
              Expanded(
                child: async.when(
                  loading: () => const SingleChildScrollView(
                    child: ExpenseDetailSkeleton(),
                  ),
                  error: (_, _) => Center(
                    child: Padding(
                      padding: const EdgeInsets.all(AppSpacing.s6),
                      child: Text(
                        "Couldn't load this expense. Please try again.",
                        textAlign: TextAlign.center,
                        style: AppText.bodyMRegular
                            .copyWith(color: AppColors.textSubtle),
                      ),
                    ),
                  ),
                  data: (detail) => _Content(
                    detail: detail,
                    dateFmt: _dateFmt,
                    onNewExpense: () async {
                      final created = await showNewExpenseSheet(
                        context,
                        date: detail.expenseDate,
                      );
                      if (!created) return;
                      ref
                        ..invalidate(expenseDetailProvider(dateKey))
                        ..invalidate(expenseGroupsProvider);
                    },
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

class _TopBar extends StatelessWidget {
  const _TopBar({required this.onBack});
  final VoidCallback onBack;

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        border: Border(bottom: BorderSide(color: AppColors.borderDefault)),
      ),
      padding: const EdgeInsets.fromLTRB(
        AppSpacing.s3,
        AppSpacing.s3,
        AppSpacing.s3,
        AppSpacing.s3,
      ),
      child: Row(
        children: [
          GestureDetector(
            onTap: onBack,
            behavior: HitTestBehavior.opaque,
            child: Padding(
              padding: const EdgeInsets.all(AppSpacing.s1),
              child: SvgPicture.asset(
                'assets/icons/line/CaretLeft.svg',
                width: 24,
                colorFilter: const ColorFilter.mode(
                  AppColors.iconDefault,
                  BlendMode.srcIn,
                ),
              ),
            ),
          ),
          Expanded(
            child: Center(
              child: Text(
                'Expense details',
                style:
                    AppText.bodyLMedium.copyWith(color: AppColors.textSubtle),
              ),
            ),
          ),
          const SizedBox(width: 32),
        ],
      ),
    );
  }
}

class _Content extends StatelessWidget {
  const _Content({
    required this.detail,
    required this.dateFmt,
    required this.onNewExpense,
  });

  final ExpenseDetail detail;
  final DateFormat dateFmt;
  final VoidCallback onNewExpense;

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: [
        Expanded(
          child: SingleChildScrollView(
            padding: const EdgeInsets.fromLTRB(
              AppSpacing.s4,
              AppSpacing.s4,
              AppSpacing.s4,
              AppSpacing.s4,
            ),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: [
                _SummaryCard(detail: detail, dateFmt: dateFmt),
                const SizedBox(height: AppSpacing.s4),
                _LineItemTable(items: detail.lineItems),
                if (detail.receipts.isNotEmpty) ...[
                  const SizedBox(height: AppSpacing.s5),
                  _ReceiptsSection(detail: detail),
                ],
              ],
            ),
          ),
        ),
        Padding(
          padding: EdgeInsets.fromLTRB(
            AppSpacing.s4,
            AppSpacing.s3,
            AppSpacing.s4,
            AppSpacing.s4 + MediaQuery.of(context).viewPadding.bottom,
          ),
          child: AppButton(
            label: '+ New expense',
            height: 52,
            onPressed: onNewExpense,
          ),
        ),
      ],
    );
  }
}

class _SummaryCard extends StatelessWidget {
  const _SummaryCard({required this.detail, required this.dateFmt});
  final ExpenseDetail detail;
  final DateFormat dateFmt;

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(AppSpacing.s4),
      decoration: BoxDecoration(
        color: AppColors.bgHovered,
        borderRadius: BorderRadius.circular(AppRadius.lg),
        border: Border.all(color: AppColors.borderDefault),
      ),
      child: Column(
        children: [
          Text(
            dateFmt.format(detail.expenseDate),
            style: AppText.bodyLMedium.copyWith(color: AppColors.textDefault),
          ),
          const SizedBox(height: AppSpacing.s1),
          Text(formatMoney(detail.totalAfterTax), style: AppText.headingXl),
          const SizedBox(height: AppSpacing.s3),
          Divider(height: 1, color: AppColors.borderDefault),
          const SizedBox(height: AppSpacing.s3),
          Row(
            children: [
              Expanded(
                child: _TaxColumn(
                  label: 'Before tax',
                  value: formatMoney(detail.totalBeforeTax),
                ),
              ),
              Expanded(
                child: _TaxColumn(
                  label: 'After tax',
                  value: formatMoney(detail.totalAfterTax),
                ),
              ),
            ],
          ),
          const SizedBox(height: AppSpacing.s3),
          Divider(height: 1, color: AppColors.borderDefault),
          const SizedBox(height: AppSpacing.s3),
          Row(
            mainAxisAlignment: MainAxisAlignment.center,
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
                '${detail.expensesCount} expenses',
                style: AppText.bodyMMedium
                    .copyWith(color: AppColors.textDefault),
              ),
              const SizedBox(width: AppSpacing.s3),
              Container(width: 1, height: 16, color: AppColors.borderBold),
              const SizedBox(width: AppSpacing.s3),
              ReceiptPill(
                count: detail.receiptsHave,
                required: detail.receiptsNeed,
              ),
            ],
          ),
          if (detail.categories.isNotEmpty) ...[
            const SizedBox(height: AppSpacing.s3),
            CategoryChips(categories: detail.categories, maxVisible: 6),
          ],
        ],
      ),
    );
  }
}

class _TaxColumn extends StatelessWidget {
  const _TaxColumn({required this.label, required this.value});
  final String label;
  final String value;

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Text(
          label,
          style: AppText.bodyMRegular.copyWith(color: AppColors.textSubtle),
        ),
        const SizedBox(height: AppSpacing.s1),
        Text(
          value,
          style: AppText.bodyLMedium.copyWith(color: AppColors.textDefault),
        ),
      ],
    );
  }
}

class _LineItemTable extends StatelessWidget {
  const _LineItemTable({required this.items});
  final List<ExpenseLineItem> items;

  @override
  Widget build(BuildContext context) {
    if (items.isEmpty) return const SizedBox.shrink();
    return DecoratedBox(
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(AppRadius.md),
        border: Border.all(color: AppColors.borderDefault),
      ),
      child: Column(
        children: [
          for (int i = 0; i < items.length; i++) ...[
            if (i > 0)
              Divider(height: 1, color: AppColors.borderDefault),
            _LineItemRow(item: items[i]),
          ],
        ],
      ),
    );
  }
}

class _LineItemRow extends StatelessWidget {
  const _LineItemRow({required this.item});
  final ExpenseLineItem item;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(
        horizontal: AppSpacing.s4,
        vertical: AppSpacing.s4,
      ),
      child: Row(
        children: [
          Expanded(
            child: Text(
              item.category,
              maxLines: 1,
              overflow: TextOverflow.ellipsis,
              style:
                  AppText.bodyLRegular.copyWith(color: AppColors.textDefault),
            ),
          ),
          const SizedBox(width: AppSpacing.s3),
          Text(
            '${formatMoney(item.amountBeforeTax)} + ${formatMoney(item.tax)} (tax)',
            style: AppText.bodyMMedium.copyWith(color: AppColors.textDefault),
          ),
        ],
      ),
    );
  }
}

class _ReceiptsSection extends StatelessWidget {
  const _ReceiptsSection({required this.detail});
  final ExpenseDetail detail;

  Future<void> _open(String url) async {
    final uri = Uri.tryParse(url);
    if (uri != null) {
      await launchUrl(uri, mode: LaunchMode.externalApplication);
    }
  }

  @override
  Widget build(BuildContext context) {
    final images = detail.imageReceipts;
    final files = detail.fileReceipts;
    final items = [for (final r in images) MediaItem.networkImage(r.url)];
    return Column(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: [
        Text(
          'Receipts',
          style: AppText.bodyLMedium.copyWith(color: AppColors.textDefault),
        ),
        if (images.isNotEmpty) ...[
          const SizedBox(height: AppSpacing.s3),
          ExpenseMediaStrip([
            for (var i = 0; i < images.length; i++)
              ExpenseMediaThumb.networkImage(
                images[i].url,
                onTap: () => unawaited(
                  showMediaViewer(context, items: items, initialIndex: i),
                ),
              ),
          ]),
        ],
        for (final r in files) ...[
          const SizedBox(height: AppSpacing.s2),
          _FileRow(name: r.originalName, onTap: () => _open(r.url)),
        ],
      ],
    );
  }
}

class _FileRow extends StatelessWidget {
  const _FileRow({required this.name, required this.onTap});
  final String name;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(
        horizontal: AppSpacing.s3,
        vertical: AppSpacing.s3,
      ),
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(AppRadius.md),
        border: Border.all(color: AppColors.borderDefault),
      ),
      child: Row(
        children: [
          SvgPicture.asset(
            'assets/icons/fill/FileText.svg',
            width: 20,
            colorFilter: const ColorFilter.mode(
              AppColors.iconBrand,
              BlendMode.srcIn,
            ),
          ),
          const SizedBox(width: AppSpacing.s2),
          Expanded(
            child: Text(
              name,
              maxLines: 1,
              overflow: TextOverflow.ellipsis,
              style:
                  AppText.bodyMRegular.copyWith(color: AppColors.textDefault),
            ),
          ),
          GestureDetector(
            onTap: onTap,
            behavior: HitTestBehavior.opaque,
            child: Padding(
              padding: const EdgeInsets.all(AppSpacing.s1),
              child: SvgPicture.asset(
                'assets/icons/line/DownloadSimple.svg',
                width: 20,
                colorFilter: const ColorFilter.mode(
                  AppColors.iconDefault,
                  BlendMode.srcIn,
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}
