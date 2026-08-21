import 'dart:io';

import 'package:amanah/core/network/api_exception.dart';
import 'package:amanah/core/theme/app_colors.dart';
import 'package:amanah/core/theme/app_spacing.dart';
import 'package:amanah/core/theme/app_system_ui.dart';
import 'package:amanah/core/theme/app_text_styles.dart';
import 'package:amanah/core/widgets/app_button.dart';
import 'package:amanah/core/widgets/app_search_field.dart';
import 'package:amanah/core/widgets/audit_chips.dart';
import 'package:amanah/core/widgets/progress_ring.dart';
import 'package:amanah/core/widgets/skeletons/audit_details_skeleton.dart';
import 'package:amanah/features/audits/data/models/audit_detail.dart';
import 'package:amanah/features/audits/presentation/providers/audit_providers.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:go_router/go_router.dart';
import 'package:intl/intl.dart';
import 'package:toastification/toastification.dart';

/// Audit details — dark header (status, meta, completion bar) over a white body
/// (observation search + category/checklist cards) with a "Complete audit" CTA.
/// Full-screen route above the shell (its own back button, no bottom nav).
class AuditDetailsScreen extends ConsumerWidget {
  const AuditDetailsScreen({required this.auditId, super.key});

  final int auditId;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final async = ref.watch(auditDetailProvider(auditId));
    final topInset = MediaQuery.of(context).viewPadding.top;

    return AnnotatedRegion<SystemUiOverlayStyle>(
      value: AppSystemUi.light,
      child: Scaffold(
        backgroundColor: AppColors.bgDefault,
        // Header + pinned CTA stay put; the list scrolls under the keyboard.
        resizeToAvoidBottomInset: false,
        body: Stack(
          children: [
            ColoredBox(
              color: AppColors.bgDefault,
              child: async.when(
                loading: () => const Column(
                  children: [
                    _TopBar(),
                    Expanded(child: AuditDetailsSkeleton()),
                  ],
                ),
                error: (_, _) => Column(
                  children: [
                    const _TopBar(),
                    Expanded(
                      child: Center(
                        child: Padding(
                          padding: const EdgeInsets.all(AppSpacing.s6),
                          child: Text(
                            "Couldn't load this audit. Please try again.",
                            textAlign: TextAlign.center,
                            style: AppText.bodyMRegular.copyWith(
                              color: AppColors.textSubtle,
                            ),
                          ),
                        ),
                      ),
                    ),
                  ],
                ),
                data: (detail) => Column(
                  crossAxisAlignment: CrossAxisAlignment.stretch,
                  children: [
                    _Header(detail),
                    Expanded(child: _Body(detail)),
                  ],
                ),
              ),
            ),
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
      ),
    );
  }
}

/// Navy top bar: back button + centered "Audit details" title.
class _TopBar extends StatelessWidget {
  const _TopBar();

  @override
  Widget build(BuildContext context) {
    final topInset = MediaQuery.of(context).viewPadding.top;
    return Container(
      color: AppColors.bgSolid,
      padding: EdgeInsets.fromLTRB(
        AppSpacing.s3,
        topInset + AppSpacing.s2,
        AppSpacing.s3,
        AppSpacing.s3,
      ),
      child: Row(
        children: [
          GestureDetector(
            onTap: () => context.pop(),
            behavior: HitTestBehavior.opaque,
            child: Padding(
              padding: const EdgeInsets.all(AppSpacing.s1),
              child: SvgPicture.asset(
                'assets/icons/line/CaretLeft.svg',
                width: 24,
                colorFilter: const ColorFilter.mode(
                  AppColors.iconInverse,
                  BlendMode.srcIn,
                ),
              ),
            ),
          ),
          Expanded(
            child: Center(
              child: Text(
                'Audit details',
                style: AppText.headingXs.copyWith(color: AppColors.textInverse),
              ),
            ),
          ),
          // Balances the back button so the title stays centered.
          const SizedBox(width: 32),
        ],
      ),
    );
  }
}

/// Navy header content: top bar + chips + title + meta rows + completion bar.
class _Header extends StatelessWidget {
  const _Header(this.detail);
  final AuditDetail detail;

  static final _dateFmt = DateFormat('MMM d, yyyy');

  String _timeRange() {
    final date = detail.eventDate;
    if (date == null) return '';
    final buffer = StringBuffer(_dateFmt.format(date));
    final start = _formatTime(detail.startTime);
    final end = _formatTime(detail.endTime);
    if (start != null) {
      buffer.write(' $start');
      if (end != null) buffer.write(' to $end');
    }
    return buffer.toString();
  }

  static String? _formatTime(String? raw) {
    if (raw == null || raw.isEmpty) return null;
    final parts = raw.split(':');
    if (parts.length < 2) return null;
    final h = int.tryParse(parts[0]);
    final m = int.tryParse(parts[1]);
    if (h == null || m == null) return null;
    return DateFormat.jm().format(DateTime(2000, 1, 1, h, m));
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      width: double.infinity,
      color: AppColors.bgSolid,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const _TopBar(),
          Padding(
            padding: const EdgeInsets.fromLTRB(
              AppSpacing.s4,
              AppSpacing.s2,
              AppSpacing.s4,
              AppSpacing.s5,
            ),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                SingleChildScrollView(
                  scrollDirection: Axis.horizontal,
                  child: Row(
                    children: [
                      AuditStatusChip(detail.section),
                      if (detail.categoryName != null) ...[
                        const SizedBox(width: AppSpacing.s2),
                        AuditTagChip(detail.categoryName!),
                      ],
                      if (detail.auditType != null) ...[
                        const SizedBox(width: AppSpacing.s2),
                        AuditTagChip(detail.auditType!),
                      ],
                    ],
                  ),
                ),
                const SizedBox(height: AppSpacing.s4),
                Text(
                  detail.title,
                  style: AppText.headingL.copyWith(
                    color: AppColors.textInverse,
                  ),
                ),
                const SizedBox(height: AppSpacing.s3),
                if (detail.location != null)
                  _MetaRow(
                    icon: 'assets/icons/fill/MapPin.svg',
                    label: detail.location!,
                  ),
                if (detail.client != null) ...[
                  const SizedBox(height: AppSpacing.s2),
                  _MetaRow(
                    icon: 'assets/icons/line/User.svg',
                    label: detail.client!.name,
                  ),
                ],
                if (detail.eventDate != null) ...[
                  const SizedBox(height: AppSpacing.s2),
                  _MetaRow(
                    icon: 'assets/icons/fill/CalendarBlank.svg',
                    label: _timeRange(),
                  ),
                ],
                const SizedBox(height: AppSpacing.s4),
                _CompletionBar(detail),
              ],
            ),
          ),
        ],
      ),
    );
  }
}

/// Icon + text row used for the header's location / client / date lines.
class _MetaRow extends StatelessWidget {
  const _MetaRow({required this.icon, required this.label});
  final String icon;
  final String label;

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        SvgPicture.asset(
          icon,
          width: 18,
          colorFilter: const ColorFilter.mode(
            AppColors.textSubtlest,
            BlendMode.srcIn,
          ),
        ),
        const SizedBox(width: AppSpacing.s2),
        Expanded(
          child: Text(
            label,
            maxLines: 1,
            overflow: TextOverflow.ellipsis,
            style: AppText.bodyMRegular.copyWith(color: AppColors.textSubtlest),
          ),
        ),
      ],
    );
  }
}

/// Translucent completion bar: "n/m observations completed" + ring + percent.
class _CompletionBar extends StatelessWidget {
  const _CompletionBar(this.detail);
  final AuditDetail detail;

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(
        horizontal: AppSpacing.s4,
        vertical: AppSpacing.s3,
      ),
      decoration: BoxDecoration(
        color: AppColors.textInverse.withValues(alpha: 0.08),
        borderRadius: BorderRadius.circular(AppRadius.md),
      ),
      child: Row(
        children: [
          SvgPicture.asset(
            'assets/icons/line/ListChecks.svg',
            width: 20,
            colorFilter: const ColorFilter.mode(
              AppColors.iconInverse,
              BlendMode.srcIn,
            ),
          ),
          const SizedBox(width: AppSpacing.s2),
          Expanded(
            child: Text(
              '${detail.observationsCompleted}/${detail.observationsTotal} '
              'observations completed',
              maxLines: 1,
              overflow: TextOverflow.ellipsis,
              style: AppText.bodyMMedium.copyWith(color: AppColors.textInverse),
            ),
          ),
          const SizedBox(width: AppSpacing.s3),
          ProgressRing(
            percent: detail.progressPercent,
            size: 22,
            color: detail.isCompleted
                ? AppColors.ringSuccess
                : AppColors.ringWarning,
            track: detail.isCompleted
                ? AppColors.ringSuccessTrack
                : AppColors.ringWarningTrack,
          ),
          const SizedBox(width: AppSpacing.s2),
          Text(
            '${detail.progressPercent}%',
            style: AppText.bodyMMedium.copyWith(color: AppColors.textInverse),
          ),
        ],
      ),
    );
  }
}

/// White body: observation search, category cards, and the Complete-audit CTA.
class _Body extends ConsumerStatefulWidget {
  const _Body(this.detail);
  final AuditDetail detail;

  @override
  ConsumerState<_Body> createState() => _BodyState();
}

class _BodyState extends ConsumerState<_Body> {
  final _controller = TextEditingController();
  String _query = '';
  bool _completing = false;

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  Future<void> _complete() async {
    final confirmed = await showDialog<bool>(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('Complete audit?'),
        content: const Text(
          "This finalizes every observation. You can't edit them afterwards.",
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.of(context).pop(false),
            child: const Text('Cancel'),
          ),
          TextButton(
            onPressed: () => Navigator.of(context).pop(true),
            child: const Text('Complete'),
          ),
        ],
      ),
    );
    if (confirmed != true) return;

    setState(() => _completing = true);
    try {
      await ref.read(auditRepositoryProvider).completeAudit(widget.detail.id);
      ref.invalidate(auditDetailProvider(widget.detail.id));
      if (!mounted) return;
      _toast('Audit completed.');
      setState(() => _completing = false);
    } on ApiException catch (e) {
      if (!mounted) return;
      setState(() => _completing = false);
      _toast(e.message, error: true);
    }
  }

  void _toast(String message, {bool error = false}) {
    toastification.show(
      context: context,
      type: error ? ToastificationType.error : ToastificationType.success,
      style: ToastificationStyle.flat,
      title: Text(message),
      alignment: Alignment.bottomCenter,
      autoCloseDuration: const Duration(seconds: 3),
    );
  }

  List<AuditCategory> _filtered() {
    final q = _query.trim().toLowerCase();
    if (q.isEmpty) return widget.detail.auditCategories;
    return widget.detail.auditCategories.where((c) {
      if (c.title.toLowerCase().contains(q)) return true;
      return c.observations.any((o) => o.name.toLowerCase().contains(q));
    }).toList();
  }

  Future<void> _refresh() async {
    ref.invalidate(auditDetailProvider(widget.detail.id));
    try {
      await ref.read(auditDetailProvider(widget.detail.id).future);
    } on Object {
      // Errors surface in the screen's error state; the pull just ends.
    }
  }

  @override
  Widget build(BuildContext context) {
    final detail = widget.detail;
    final categories = _filtered();
    final canComplete = detail.permissions?.canComplete ?? false;
    final bottomInset = MediaQuery.of(context).viewPadding.bottom;

    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: AppSpacing.s4),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          const SizedBox(height: AppSpacing.s5),
          AppSearchField(
            controller: _controller,
            hintText: 'Search observation',
            onChanged: (v) => setState(() => _query = v),
          ),
          const SizedBox(height: AppSpacing.s4),
          Expanded(
            child: RefreshIndicator(
              color: AppColors.brand,
              onRefresh: _refresh,
              child: categories.isEmpty
                  ? LayoutBuilder(
                      builder: (context, constraints) => SingleChildScrollView(
                        physics: const AlwaysScrollableScrollPhysics(
                          parent: ClampingScrollPhysics(),
                        ),
                        child: ConstrainedBox(
                          constraints: BoxConstraints(
                            minHeight: constraints.maxHeight,
                          ),
                          child: Center(
                            child: Padding(
                              padding: const EdgeInsets.symmetric(
                                vertical: AppSpacing.s9,
                              ),
                              child: Text(
                                _query.isEmpty
                                    ? 'No observation categories yet.'
                                    : 'No categories match "$_query".',
                                textAlign: TextAlign.center,
                                style: AppText.bodyMRegular.copyWith(
                                  color: AppColors.textSubtle,
                                ),
                              ),
                            ),
                          ),
                        ),
                      ),
                    )
                  : ListView.separated(
                      physics: const AlwaysScrollableScrollPhysics(
                        parent: ClampingScrollPhysics(),
                      ),
                      padding: const EdgeInsets.only(bottom: AppSpacing.s6),
                      itemCount: categories.length,
                      separatorBuilder: (_, _) =>
                          const SizedBox(height: AppSpacing.s4),
                      itemBuilder: (context, i) => _CategoryCard(
                        categories[i],
                        auditId: detail.id,
                      ),
                    ),
            ),
          ),
          if (canComplete)
            Padding(
              padding: EdgeInsets.only(
                top: AppSpacing.s2,
                bottom: bottomInset + (Platform.isAndroid ? AppSpacing.s4 : 0),
              ),
              child: AppButton(
                label: 'Complete Audit',
                loading: _completing,
                onPressed: _completing ? null : _complete,
              ),
            ),
        ],
      ),
    );
  }
}

/// Checklist card for one category: icon, title (+ done check), n/m completed,
/// progress bar. Tapping opens the observation list (M4 sub-screen).
class _CategoryCard extends StatelessWidget {
  const _CategoryCard(this.category, {required this.auditId});
  final AuditCategory category;
  final int auditId;

  @override
  Widget build(BuildContext context) {
    final done = category.progressPercent >= 100;
    return Material(
      color: AppColors.bgDefault,
      borderRadius: BorderRadius.circular(AppRadius.md),
      child: InkWell(
        onTap: () => context.push(
          '/audit/$auditId/category/${category.auditCategoryId}',
        ),
        borderRadius: BorderRadius.circular(AppRadius.md),
        child: DecoratedBox(
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(AppRadius.md),
            border: Border.all(color: AppColors.borderDefault),
          ),
          child: Padding(
            padding: const EdgeInsets.all(AppSpacing.s3),
            child: Column(
              children: [
                IntrinsicHeight(
                  child: Row(
                    crossAxisAlignment: CrossAxisAlignment.stretch,
                    children: [
                      Align(
                        alignment: Alignment.topCenter,
                        child: Padding(
                          padding: const EdgeInsets.only(top: AppSpacing.s1),
                          child: _CategoryIcon(category.iconUrl, size: 34),
                        ),
                      ),
                      const SizedBox(width: AppSpacing.s3),
                      Expanded(
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Row(
                              children: [
                                Flexible(
                                  child: Text(
                                    category.title,
                                    maxLines: 1,
                                    overflow: TextOverflow.ellipsis,
                                    style: AppText.bodyLMedium,
                                  ),
                                ),
                                if (done) ...[
                                  const SizedBox(width: AppSpacing.s2),
                                  SvgPicture.asset(
                                    'assets/icons/fill/CheckCircle.svg',
                                    width: 18,
                                    colorFilter: const ColorFilter.mode(
                                      AppColors.iconSuccess,
                                      BlendMode.srcIn,
                                    ),
                                  ),
                                ],
                              ],
                            ),
                            const SizedBox(height: AppSpacing.s1),
                            Text(
                              '${category.observationsCompleted}/'
                              '${category.observationsTotal} Observation completed',
                              style: AppText.bodyMRegular.copyWith(
                                color: AppColors.textSubtle,
                              ),
                            ),
                            const SizedBox(height: AppSpacing.s1),
                            Row(
                              children: [
                                Expanded(
                                  child: _ProgressBar(category.progressPercent),
                                ),
                                const SizedBox(width: AppSpacing.s3),
                                Text(
                                  '${category.progressPercent}%',
                                  style: AppText.bodyMMedium.copyWith(
                                    color: AppColors.textDefault,
                                  ),
                                ),
                              ],
                            ),
                          ],
                        ),
                      ),
                      const SizedBox(width: AppSpacing.s2),
                      Align(
                        child: SvgPicture.asset(
                          'assets/icons/line/CaretRight.svg',
                          width: 18,
                          colorFilter: const ColorFilter.mode(
                            AppColors.iconSubtle,
                            BlendMode.srcIn,
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}

/// Circular tinted badge holding the category's network icon.
class _CategoryIcon extends StatelessWidget {
  const _CategoryIcon(this.url, {this.size = 44});
  final String? url;
  final double size;

  @override
  Widget build(BuildContext context) {
    final iconSize = size * 0.6;
    return Container(
      width: size,
      height: size,
      decoration: const BoxDecoration(
        shape: BoxShape.circle,
        color: AppColors.bgHovered,
      ),
      clipBehavior: Clip.antiAlias,
      child: url == null
          ? const _IconFallback()
          : CachedNetworkImage(
              imageUrl: url!,
              width: iconSize,
              height: iconSize,
              fit: BoxFit.contain,
              placeholder: (_, _) => const _IconFallback(),
              errorWidget: (_, _, _) => const _IconFallback(),
            ),
    );
  }
}

class _IconFallback extends StatelessWidget {
  const _IconFallback();

  @override
  Widget build(BuildContext context) {
    return Center(
      child: SvgPicture.asset(
        'assets/icons/line/ListChecks.svg',
        width: 22,
        colorFilter: const ColorFilter.mode(
          AppColors.iconSubtle,
          BlendMode.srcIn,
        ),
      ),
    );
  }
}

/// Thin rounded progress track with a fill colored by completion.
class _ProgressBar extends StatelessWidget {
  const _ProgressBar(this.percent);
  final int percent;

  @override
  Widget build(BuildContext context) {
    final fraction = percent.clamp(0, 100) / 100;
    final color = percent >= 100
        ? AppColors.progressComplete
        : AppColors.progressActive;
    return ClipRRect(
      borderRadius: BorderRadius.circular(AppRadius.pill),
      child: Container(
        height: 6,
        color: AppColors.progressTrack,
        child: Align(
          alignment: Alignment.centerLeft,
          child: FractionallySizedBox(
            widthFactor: fraction,
            heightFactor: 1,
            child: ColoredBox(color: color),
          ),
        ),
      ),
    );
  }
}
