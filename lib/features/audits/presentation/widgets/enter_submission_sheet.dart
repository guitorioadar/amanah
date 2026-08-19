import 'dart:io';

import 'package:amanah/core/network/api_exception.dart';
import 'package:amanah/core/theme/app_colors.dart';
import 'package:amanah/core/theme/app_spacing.dart';
import 'package:amanah/core/theme/app_text_styles.dart';
import 'package:amanah/core/widgets/app_button.dart';
import 'package:amanah/core/widgets/finding_selector.dart';
import 'package:amanah/features/audits/data/models/audit_detail.dart';
import 'package:amanah/features/audits/presentation/providers/audit_providers.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:file_picker/file_picker.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:toastification/toastification.dart';

/// Max files (photos + videos + documents together) per observation.
const _maxFiles = 10;

/// Opens the Enter-submission sheet for [observation]. [initialFinding] pre-
/// selects a finding (set when the user tapped a finding pill). Returns true if
/// a submission was saved.
Future<bool?> showEnterSubmissionSheet(
  BuildContext context, {
  required int eventId,
  required String categoryTitle,
  required AuditObservation observation,
  Finding? initialFinding,
}) {
  return showModalBottomSheet<bool>(
    context: context,
    isScrollControlled: true,
    useSafeArea: true,
    backgroundColor: AppColors.bgDefault,
    shape: const RoundedRectangleBorder(
      borderRadius: BorderRadius.vertical(top: Radius.circular(AppRadius.lg)),
    ),
    builder: (_) => _EnterSubmissionSheet(
      eventId: eventId,
      categoryTitle: categoryTitle,
      observation: observation,
      initialFinding: initialFinding,
    ),
  );
}

class _EnterSubmissionSheet extends ConsumerStatefulWidget {
  const _EnterSubmissionSheet({
    required this.eventId,
    required this.categoryTitle,
    required this.observation,
    required this.initialFinding,
  });

  final int eventId;
  final String categoryTitle;
  final AuditObservation observation;
  final Finding? initialFinding;

  @override
  ConsumerState<_EnterSubmissionSheet> createState() =>
      _EnterSubmissionSheetState();
}

class _EnterSubmissionSheetState extends ConsumerState<_EnterSubmissionSheet> {
  late Finding? _finding =
      widget.initialFinding ?? widget.observation.findingValue;
  late final _noteController =
      TextEditingController(text: widget.observation.note ?? '');

  late final List<AuditFile> _existing = [...widget.observation.files];
  final List<int> _deleteIds = [];
  final List<_Picked> _newFiles = [];
  bool _saving = false;

  int get _totalFiles => _existing.length + _newFiles.length;

  /// True when the sheet differs from the observation's saved submission —
  /// gates the Save / Submit again button (blue when dirty, white when not).
  bool get _dirty {
    final o = widget.observation;
    final findingChanged = _finding != o.findingValue;
    final noteChanged = _noteController.text.trim() != (o.note ?? '').trim();
    return findingChanged ||
        noteChanged ||
        _newFiles.isNotEmpty ||
        _deleteIds.isNotEmpty;
  }

  @override
  void initState() {
    super.initState();
    // Re-evaluate `_dirty` (button state) as the note is typed.
    _noteController.addListener(_onNoteChanged);
  }

  void _onNoteChanged() => setState(() {});

  @override
  void dispose() {
    _noteController
      ..removeListener(_onNoteChanged)
      ..dispose();
    super.dispose();
  }

  Future<void> _pick(FileType type, _Kind kind, List<String>? exts) async {
    final result = await FilePicker.pickFiles(
      type: type,
      allowedExtensions: exts,
    );
    final picked = result.where((f) => f.path != null).toList();
    if (picked.isEmpty) return;
    final room = _maxFiles - _totalFiles;
    if (picked.length > room) {
      _toast('You can attach up to $_maxFiles files.', error: true);
    }
    setState(() {
      for (final f in picked.take(room)) {
        _newFiles.add(_Picked(path: f.path!, name: f.name, kind: kind));
      }
    });
  }

  void _removeExisting(AuditFile file) {
    setState(() {
      _existing.remove(file);
      _deleteIds.add(file.id);
    });
  }

  void _removeNew(_Picked file) => setState(() => _newFiles.remove(file));

  Future<void> _save() async {
    final finding = _finding;
    if (finding == null) {
      _toast('Select a finding first.', error: true);
      return;
    }
    setState(() => _saving = true);
    try {
      await ref.read(auditRepositoryProvider).submitObservation(
            eventId: widget.eventId,
            auditObservationId: widget.observation.auditObservationId,
            finding: finding,
            note: _noteController.text.trim(),
            newFilePaths: [for (final f in _newFiles) f.path],
            deleteFileIds: _deleteIds,
          );
      ref.invalidate(auditDetailProvider(widget.eventId));
      if (!mounted) return;
      _toast('Observation saved.');
      Navigator.of(context).pop(true);
    } on ApiException catch (e) {
      if (!mounted) return;
      setState(() => _saving = false);
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

  @override
  Widget build(BuildContext context) {
    final keyboard = MediaQuery.of(context).viewInsets.bottom;
    final media = <Widget>[
      for (final f in _existing)
        if (f.isPhoto || f.isVideo)
          _MediaThumb.existing(f, onRemove: () => _removeExisting(f)),
      for (final f in _newFiles)
        if (f.kind != _Kind.document)
          _MediaThumb.picked(f, onRemove: () => _removeNew(f)),
    ];
    final docs = <Widget>[
      for (final f in _existing)
        if (f.isDocument)
          _DocRow(name: f.name, onRemove: () => _removeExisting(f)),
      for (final f in _newFiles)
        if (f.kind == _Kind.document)
          _DocRow(name: f.name, onRemove: () => _removeNew(f)),
    ];

    return Padding(
      padding: EdgeInsets.only(bottom: keyboard),
      child: FractionallySizedBox(
        heightFactor: 0.92,
        child: Column(
          children: [
            _SheetHeader(title: widget.categoryTitle),
            Expanded(
              child: SingleChildScrollView(
                padding: const EdgeInsets.fromLTRB(
                  AppSpacing.s4,
                  AppSpacing.s5,
                  AppSpacing.s4,
                  AppSpacing.s5,
                ),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(widget.observation.name, style: AppText.headingM),
                    const SizedBox(height: AppSpacing.s5),
                    const _Label('Finding'),
                    const SizedBox(height: AppSpacing.s2),
                    FindingSelector(
                      selected: _finding,
                      onChanged: (f) => setState(() => _finding = f),
                    ),
                    const SizedBox(height: AppSpacing.s5),
                    const _Label('Add record'),
                    const SizedBox(height: AppSpacing.s3),
                    Row(
                      children: [
                        Expanded(
                          child: _AddTile(
                            icon: 'FileArrowUp',
                            label: 'Add document',
                            onTap: () => _pick(
                              FileType.custom,
                              _Kind.document,
                              const [
                                'pdf', 'doc', 'docx', 'xls', 'xlsx',
                                'csv', 'txt', 'ppt', 'pptx',
                              ],
                            ),
                          ),
                        ),
                        const SizedBox(width: AppSpacing.s2),
                        Expanded(
                          child: _AddTile(
                            icon: 'ImageSquare',
                            label: 'Add photo',
                            onTap: () =>
                                _pick(FileType.image, _Kind.photo, null),
                          ),
                        ),
                        const SizedBox(width: AppSpacing.s2),
                        Expanded(
                          child: _AddTile(
                            icon: 'VideoCamera',
                            label: 'Add video',
                            onTap: () =>
                                _pick(FileType.video, _Kind.video, null),
                          ),
                        ),
                      ],
                    ),
                    if (media.isNotEmpty) ...[
                      const SizedBox(height: AppSpacing.s4),
                      SizedBox(
                        height: 88,
                        child: ListView.separated(
                          scrollDirection: Axis.horizontal,
                          itemCount: media.length,
                          separatorBuilder: (_, _) =>
                              const SizedBox(width: AppSpacing.s2),
                          itemBuilder: (_, i) => media[i],
                        ),
                      ),
                    ],
                    if (docs.isNotEmpty) ...[
                      const SizedBox(height: AppSpacing.s3),
                      for (final row in docs) ...[
                        row,
                        const SizedBox(height: AppSpacing.s2),
                      ],
                    ],
                    const SizedBox(height: AppSpacing.s5),
                    const _Label('Note'),
                    const SizedBox(height: AppSpacing.s2),
                    TextField(
                      controller: _noteController,
                      minLines: 3,
                      maxLines: 6,
                      style: AppText.bodyLRegular,
                      decoration: InputDecoration(
                        hintText: 'Add note here',
                        hintStyle: AppText.bodyLRegular
                            .copyWith(color: AppColors.textSubtlest),
                        filled: true,
                        fillColor: AppColors.bgDefault,
                        contentPadding: const EdgeInsets.all(AppSpacing.s3),
                        border: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(AppRadius.md),
                          borderSide: BorderSide(color: AppColors.borderDefault),
                        ),
                        enabledBorder: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(AppRadius.md),
                          borderSide: BorderSide(color: AppColors.borderDefault),
                        ),
                        focusedBorder: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(AppRadius.md),
                          borderSide:
                              const BorderSide(color: AppColors.borderFocus),
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            ),
            Padding(
              padding: const EdgeInsets.fromLTRB(
                AppSpacing.s4,
                AppSpacing.s2,
                AppSpacing.s4,
                AppSpacing.s6,
              ),
              child: AppButton(
                // "Submit again" when a result already exists, else "Save".
                label: widget.observation.isSubmitted ? 'Submit again' : 'Save',
                loading: _saving,
                // Blue only when something changed; white/disabled otherwise.
                onPressed: _dirty ? _save : null,
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class _SheetHeader extends StatelessWidget {
  const _SheetHeader({required this.title});
  final String title;

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.fromLTRB(
        AppSpacing.s4,
        AppSpacing.s4,
        AppSpacing.s4,
        AppSpacing.s3,
      ),
      decoration: BoxDecoration(
        border: Border(bottom: BorderSide(color: AppColors.borderDefault)),
      ),
      child: Row(
        children: [
          const SizedBox(width: 24),
          Expanded(
            child: Text(
              title,
              textAlign: TextAlign.center,
              maxLines: 1,
              overflow: TextOverflow.ellipsis,
              style: AppText.headingXs.copyWith(color: AppColors.textDefault),
            ),
          ),
          GestureDetector(
            onTap: () => Navigator.of(context).pop(),
            behavior: HitTestBehavior.opaque,
            child: const Icon(Icons.close, size: 24, color: AppColors.iconDefault),
          ),
        ],
      ),
    );
  }
}

class _Label extends StatelessWidget {
  const _Label(this.text);
  final String text;

  @override
  Widget build(BuildContext context) {
    return Text(
      text,
      style: AppText.bodyMRegular.copyWith(color: AppColors.textSubtle),
    );
  }
}

/// Dashed-look add tile (solid subtle border — no dashed-border dependency).
class _AddTile extends StatelessWidget {
  const _AddTile({
    required this.icon,
    required this.label,
    required this.onTap,
  });

  final String icon;
  final String label;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      behavior: HitTestBehavior.opaque,
      child: Container(
        padding: const EdgeInsets.symmetric(vertical: AppSpacing.s4),
        decoration: BoxDecoration(
          color: AppColors.bgHovered,
          borderRadius: BorderRadius.circular(AppRadius.md),
          border: Border.all(color: AppColors.borderBold),
        ),
        child: Column(
          children: [
            SvgPicture.asset(
              'assets/icons/fill/$icon.svg',
              width: 24,
              colorFilter: const ColorFilter.mode(
                AppColors.iconSubtle,
                BlendMode.srcIn,
              ),
            ),
            const SizedBox(height: AppSpacing.s2),
            Text(
              label,
              maxLines: 1,
              overflow: TextOverflow.ellipsis,
              style: AppText.bodyMRegular.copyWith(color: AppColors.textDefault),
            ),
          ],
        ),
      ),
    );
  }
}

/// Photo/video thumbnail with a remove badge. Videos show a play overlay.
class _MediaThumb extends StatelessWidget {
  const _MediaThumb._({
    required this.child,
    required this.isVideo,
    required this.onRemove,
  });

  factory _MediaThumb.existing(AuditFile file, {required VoidCallback onRemove}) {
    return _MediaThumb._(
      isVideo: file.isVideo,
      onRemove: onRemove,
      child: file.isVideo
          ? const ColoredBox(color: AppColors.bgSolid)
          : CachedNetworkImage(imageUrl: file.url, fit: BoxFit.cover),
    );
  }

  factory _MediaThumb.picked(_Picked file, {required VoidCallback onRemove}) {
    return _MediaThumb._(
      isVideo: file.kind == _Kind.video,
      onRemove: onRemove,
      child: file.kind == _Kind.video
          ? const ColoredBox(color: AppColors.bgSolid)
          : Image.file(File(file.path), fit: BoxFit.cover),
    );
  }

  final Widget child;
  final bool isVideo;
  final VoidCallback onRemove;

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      width: 88,
      height: 88,
      child: Stack(
        fit: StackFit.expand,
        children: [
          ClipRRect(
            borderRadius: BorderRadius.circular(AppRadius.md),
            child: child,
          ),
          if (isVideo)
            const Center(
              child: Icon(Icons.play_circle_fill,
                  size: 32, color: AppColors.iconInverse),
            ),
          Positioned(
            top: 4,
            right: 4,
            child: GestureDetector(
              onTap: onRemove,
              child: Container(
                padding: const EdgeInsets.all(2),
                decoration: const BoxDecoration(
                  shape: BoxShape.circle,
                  color: AppColors.bgSolid,
                ),
                child: const Icon(Icons.close,
                    size: 14, color: AppColors.iconInverse),
              ),
            ),
          ),
        ],
      ),
    );
  }
}

/// Document row: file icon + name + delete.
class _DocRow extends StatelessWidget {
  const _DocRow({required this.name, required this.onRemove});
  final String name;
  final VoidCallback onRemove;

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
              style: AppText.bodyMRegular.copyWith(color: AppColors.textDefault),
            ),
          ),
          const SizedBox(width: AppSpacing.s2),
          GestureDetector(
            onTap: onRemove,
            behavior: HitTestBehavior.opaque,
            child: const Icon(Icons.delete_outline,
                size: 20, color: AppColors.iconSubtle),
          ),
        ],
      ),
    );
  }
}

enum _Kind { photo, video, document }

class _Picked {
  const _Picked({required this.path, required this.name, required this.kind});
  final String path;
  final String name;
  final _Kind kind;
}
