import 'dart:async';

import 'package:amanah/core/theme/app_colors.dart';
import 'package:amanah/core/theme/app_spacing.dart';
import 'package:amanah/core/theme/app_system_ui.dart';
import 'package:amanah/core/theme/app_text_styles.dart';
import 'package:amanah/core/widgets/finding_selector.dart';
import 'package:amanah/features/audits/data/models/audit_detail.dart';
import 'package:amanah/features/audits/presentation/providers/audit_providers.dart';
import 'package:amanah/features/audits/presentation/widgets/enter_submission_sheet.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:go_router/go_router.dart';

/// Observation list for one category — light header (back + category name) over
/// the category's observation cards. Each card shows the finding selector
/// (Compliant / Non-compliant / N/A) and, when a submission exists, a records
/// row that opens the submission modal (M4, pending schema).
class ObservationListScreen extends ConsumerWidget {
  const ObservationListScreen({
    required this.auditId,
    required this.categoryId,
    super.key,
  });

  final int auditId;
  final int categoryId;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final async = ref.watch(auditDetailProvider(auditId));

    return AnnotatedRegion<SystemUiOverlayStyle>(
      value: AppSystemUi.dark,
      child: Scaffold(
        backgroundColor: AppColors.bgDefault,
        resizeToAvoidBottomInset: false,
        body: async.when(
          loading: () => const Column(
            children: [
              _TopBar(title: 'Observations'),
              Expanded(
                child: Center(
                  child: CircularProgressIndicator(color: AppColors.brand),
                ),
              ),
            ],
          ),
          error: (_, _) => Column(
            children: [
              const _TopBar(title: 'Observations'),
              Expanded(
                child: Center(
                  child: Padding(
                    padding: const EdgeInsets.all(AppSpacing.s6),
                    child: Text(
                      "Couldn't load this category.",
                      textAlign: TextAlign.center,
                      style: AppText.bodyMRegular
                          .copyWith(color: AppColors.textSubtle),
                    ),
                  ),
                ),
              ),
            ],
          ),
          data: (detail) {
            final category = _find(detail);
            if (category == null) {
              return const Column(
                children: [
                  _TopBar(title: 'Observations'),
                  Expanded(
                    child: Center(child: Text('Category not found.')),
                  ),
                ],
              );
            }
            return Column(
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: [
                _TopBar(title: category.title),
                Expanded(child: _Body(category, eventId: auditId)),
              ],
            );
          },
        ),
      ),
    );
  }

  AuditCategory? _find(AuditDetail detail) {
    for (final c in detail.auditCategories) {
      if (c.auditCategoryId == categoryId) return c;
    }
    return null;
  }
}

/// Light top bar: back button + centered title.
class _TopBar extends StatelessWidget {
  const _TopBar({required this.title});
  final String title;

  @override
  Widget build(BuildContext context) {
    final topInset = MediaQuery.of(context).viewPadding.top;
    return Container(
      decoration: BoxDecoration(
        color: AppColors.bgDefault,
        border: Border(bottom: BorderSide(color: AppColors.borderDefault)),
      ),
      padding: EdgeInsets.fromLTRB(
        AppSpacing.s3,
        topInset,
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
                  AppColors.iconSubtlest,
                  BlendMode.srcIn,
                ),
              ),
            ),
          ),
          Expanded(
            child: Center(
              child: Text(
                title,
                maxLines: 1,
                overflow: TextOverflow.ellipsis,
                style: AppText.bodyLMedium.copyWith(color: AppColors.textSubtle),
              ),
            ),
          ),
          const SizedBox(width: 32),
        ],
      ),
    );
  }
}

/// Category summary (title + progress) followed by the observation cards.
class _Body extends StatelessWidget {
  const _Body(this.category, {required this.eventId});
  final AuditCategory category;
  final int eventId;

  @override
  Widget build(BuildContext context) {
    final observations = category.observations;
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: AppSpacing.s4),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const SizedBox(height: AppSpacing.s5),
          Text(category.title, style: AppText.headingM),
          const SizedBox(height: AppSpacing.s1),
          Text(
            '${category.observationsCompleted}/${category.observationsTotal} '
            'Observation completed',
            style: AppText.bodyMRegular.copyWith(color: AppColors.textSubtle),
          ),
          const SizedBox(height: AppSpacing.s3),
          Row(
            children: [
              Expanded(child: _ProgressBar(category.progressPercent)),
              const SizedBox(width: AppSpacing.s3),
              Text(
                '${category.progressPercent}%',
                style:
                    AppText.bodyXsRegular.copyWith(color: AppColors.textDefault),
              ),
            ],
          ),
          const SizedBox(height: AppSpacing.s5),
          Expanded(
            child: observations.isEmpty
                ? Center(
                    child: Text(
                      'No observations in this category.',
                      style: AppText.bodyMRegular
                          .copyWith(color: AppColors.textSubtle),
                    ),
                  )
                : ListView.separated(
                    physics: const AlwaysScrollableScrollPhysics(
                      parent: ClampingScrollPhysics(),
                    ),
                    padding: const EdgeInsets.only(bottom: AppSpacing.s6),
                    itemCount: observations.length,
                    separatorBuilder: (_, _) =>
                        const SizedBox(height: AppSpacing.s4),
                    itemBuilder: (context, i) => _ObservationCard(
                      observations[i],
                      eventId: eventId,
                      categoryTitle: category.title,
                    ),
                  ),
          ),
        ],
      ),
    );
  }
}

/// Blue progress track (this screen's bar is brand-colored per design).
class _ProgressBar extends StatelessWidget {
  const _ProgressBar(this.percent);
  final int percent;

  @override
  Widget build(BuildContext context) {
    return ClipRRect(
      borderRadius: BorderRadius.circular(AppRadius.pill),
      child: Container(
        height: 6,
        color: AppColors.bgPressed,
        child: Align(
          alignment: Alignment.centerLeft,
          child: FractionallySizedBox(
            widthFactor: percent.clamp(0, 100) / 100,
            heightFactor: 1,
            child: const ColoredBox(color: AppColors.brand),
          ),
        ),
      ),
    );
  }
}

/// One observation: name, finding selector, and (when submitted) a records row.
/// Tapping a finding pill or the records row opens the submission sheet.
class _ObservationCard extends StatelessWidget {
  const _ObservationCard(
    this.observation, {
    required this.eventId,
    required this.categoryTitle,
  });
  final AuditObservation observation;
  final int eventId;
  final String categoryTitle;

  bool get _hasRecords =>
      observation.documentsCount > 0 ||
      observation.photosCount > 0 ||
      observation.videosCount > 0 ||
      observation.filesCount > 0 ||
      observation.hasNote;

  void _openSheet(BuildContext context, {Finding? finding}) {
    unawaited(
      showEnterSubmissionSheet(
        context,
        eventId: eventId,
        categoryTitle: categoryTitle,
        observation: observation,
        initialFinding: finding,
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return DecoratedBox(
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(AppRadius.md),
        border: Border.all(color: AppColors.borderDefault),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          Padding(
            padding: const EdgeInsets.all(14),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(observation.name, style: AppText.bodyLRegular),
                const SizedBox(height: AppSpacing.s2),
                FindingSelector(
                  selected: observation.findingValue,
                  onChanged: (f) => _openSheet(context, finding: f),
                ),
              ],
            ),
          ),
          if (_hasRecords) ...[
            Divider(height: 1, thickness: 1, color: AppColors.borderDefault),
            _RecordsRow(observation, onTap: () => _openSheet(context)),
          ],
        ],
      ),
    );
  }
}

/// Records summary (docs / photos / videos / notes) + chevron into the
/// submission sheet.
class _RecordsRow extends StatelessWidget {
  const _RecordsRow(this.observation, {required this.onTap});
  final AuditObservation observation;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    return Material(
      color: AppColors.transparent,
      child: InkWell(
        onTap: onTap,
        child: Padding(
          padding: const EdgeInsets.symmetric(
            horizontal: AppSpacing.s4,
            vertical: AppSpacing.s3,
          ),
          child: Row(
            children: [
              Expanded(
                child: SingleChildScrollView(
                  scrollDirection: Axis.horizontal,
                  child: Row(children: _chips()),
                ),
              ),
              const SizedBox(width: AppSpacing.s2),
              SvgPicture.asset(
                'assets/icons/line/CaretRight.svg',
                width: 18,
                colorFilter: const ColorFilter.mode(
                  AppColors.iconSubtle,
                  BlendMode.srcIn,
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  List<Widget> _chips() {
    final chips = <Widget>[];
    void add(String icon, String label) {
      if (chips.isNotEmpty) chips.add(const SizedBox(width: AppSpacing.s1));
      chips.add(_RecordChip(icon: icon, label: label));
    }

    if (observation.documentsCount > 0) {
      add('FileText', '${observation.documentsCount} docs');
    }
    if (observation.photosCount > 0) {
      add('ImageSquare', '${observation.photosCount} photos');
    }
    if (observation.videosCount > 0) {
      add('VideoCamera', '${observation.videosCount} videos');
    }
    if (observation.hasNote) {
      add('Note', 'Note');
    }
    return chips;
  }
}

class _RecordChip extends StatelessWidget {
  const _RecordChip({required this.icon, required this.label});
  final String icon;
  final String label;

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(
        horizontal: AppSpacing.s2,
        vertical: 3,
      ),
      decoration: BoxDecoration(
        color: AppColors.bgPressed,
        borderRadius: BorderRadius.circular(AppRadius.sm),
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          SvgPicture.asset(
            'assets/icons/line/$icon.svg',
            width: 14,
            colorFilter: const ColorFilter.mode(
              AppColors.iconSubtle,
              BlendMode.srcIn,
            ),
          ),
          const SizedBox(width: AppSpacing.s1),
          Text(
            label,
            style: AppText.bodyXsMedium.copyWith(color: AppColors.textDefault),
          ),
        ],
      ),
    );
  }
}
