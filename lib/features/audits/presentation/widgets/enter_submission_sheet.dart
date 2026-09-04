import 'dart:async';
import 'dart:io';

import 'package:amanah/core/media/media_prep.dart';
import 'package:amanah/core/network/api_exception.dart';
import 'package:amanah/core/theme/app_colors.dart';
import 'package:amanah/core/theme/app_spacing.dart';
import 'package:amanah/core/theme/app_text_styles.dart';
import 'package:amanah/core/widgets/app_button.dart';
import 'package:amanah/core/widgets/finding_selector.dart';
import 'package:amanah/core/widgets/media_viewer.dart';
import 'package:amanah/core/widgets/skeletons/thumb_shimmer.dart';
import 'package:amanah/core/widgets/thumb_error.dart';
import 'package:amanah/core/widgets/video_thumbnail_image.dart';
import 'package:amanah/features/audits/data/models/audit_detail.dart';
import 'package:amanah/features/audits/presentation/providers/audit_providers.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:file_picker/file_picker.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:intl/intl.dart';
import 'package:toastification/toastification.dart';
import 'package:url_launcher/url_launcher.dart';

/// Submission sheet mode: read-only [view] (already submitted) vs editable
/// [edit] (create, or after "Submit again").
enum _Mode { view, edit }

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
  late final _noteController = TextEditingController(
    text: widget.observation.note ?? '',
  );

  late final List<AuditFile> _existing = [...widget.observation.files];
  final List<int> _deleteIds = [];
  final List<_Picked> _newFiles = [];
  bool _saving = false;

  // Already-submitted observations open read-only; "Submit again" → edit.
  late _Mode _mode = widget.observation.isSubmitted ? _Mode.view : _Mode.edit;

  static final _dateFmt = DateFormat('MMM d, yyyy h:mm a');

  Future<void> _open(String url) async {
    final uri = Uri.tryParse(url);
    if (uri == null) return;
    await launchUrl(uri, mode: LaunchMode.externalApplication);
  }

  /// Maps an attachment (existing [AuditFile] or freshly [_Picked]) to a
  /// previewable [MediaItem] for the in-app viewer.
  MediaItem _mediaItem(Object ref) {
    if (ref case final AuditFile f) {
      return f.isVideo
          ? MediaItem.networkVideo(f.url)
          : MediaItem.networkImage(f.url);
    }
    final p = ref as _Picked;
    return p.kind == _Kind.video
        ? MediaItem.fileVideo(p.path)
        : MediaItem.fileImage(p.path);
  }

  void _preview(List<MediaItem> items, int index) =>
      unawaited(showMediaViewer(context, items: items, initialIndex: index));

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
    // iPhone hands us .mov / .heic; convert to mp4 / jpg (with a progress
    // dialog for video) and enforce the 100 MB cap before attaching.
    for (final f in picked.take(room)) {
      if (!mounted) return;
      final processed = await prepareMedia(
        context,
        path: f.path!,
        kind: _prepKind(kind),
      );
      if (processed == null) continue; // failed / over limit — toast shown.
      if (!mounted) return;
      setState(() {
        _newFiles.add(
          _Picked(
            path: processed,
            name: _displayName(f.name, processed),
            kind: kind,
          ),
        );
      });
    }
  }

  static MediaPrepKind _prepKind(_Kind kind) => switch (kind) {
        _Kind.video => MediaPrepKind.video,
        _Kind.photo => MediaPrepKind.image,
        _Kind.document => MediaPrepKind.document,
      };

  /// Keeps the original base name but swaps the extension to match the
  /// (possibly converted) file, so the upload's filename ends in .mp4/.jpg.
  static String _displayName(String original, String path) {
    final ext = path.contains('.') ? path.split('.').last : '';
    final dot = original.lastIndexOf('.');
    final base = dot == -1 ? original : original.substring(0, dot);
    return ext.isEmpty ? base : '$base.$ext';
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
      await ref
          .read(auditRepositoryProvider)
          .submitObservation(
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
    // showModalBottomSheet's useSafeArea only guards the top (SafeArea
    // bottom:false), so pad the CTA past the bottom system inset (Android nav
    // bar). Zero on gesture nav / iOS, keeping the original spacing there.
    final bottomInset = MediaQuery.viewPaddingOf(context).bottom;
    final isView = _mode == _Mode.view;

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
                  children: isView ? _viewChildren() : _editChildren(),
                ),
              ),
            ),
            Padding(
              padding: EdgeInsets.fromLTRB(
                AppSpacing.s4,
                AppSpacing.s2,
                AppSpacing.s4,
                bottomInset + (Platform.isAndroid ? AppSpacing.s4 : 0),
              ),
              child: isView
                  // View mode: "Submit again" activates the editable form.
                  ? AppButton(
                      label: 'Submit Again',
                      outlined: true,
                      onPressed: () => setState(() => _mode = _Mode.edit),
                    )
                  // Edit mode: blue only when something changed.
                  : AppButton(
                      label: 'Save',
                      loading: _saving,
                      onPressed: _dirty ? _save : null,
                    ),
            ),
          ],
        ),
      ),
    );
  }

  /// Editable form: finding selector, add-record tiles, removable attachments,
  /// note field.
  List<Widget> _editChildren() {
    final mediaRefs = <Object>[
      for (final f in _existing)
        if (f.isPhoto || f.isVideo) f,
      for (final f in _newFiles)
        if (f.kind != _Kind.document) f,
    ];
    final mediaItems = [for (final r in mediaRefs) _mediaItem(r)];
    final media = <Widget>[
      for (var i = 0; i < mediaRefs.length; i++)
        if (mediaRefs[i] case final AuditFile f)
          _MediaThumb.existing(
            f,
            onRemove: () => _removeExisting(f),
            onTap: () => _preview(mediaItems, i),
          )
        else if (mediaRefs[i] case final _Picked p)
          _MediaThumb.picked(
            p,
            onRemove: () => _removeNew(p),
            onTap: () => _preview(mediaItems, i),
          ),
    ];
    final docs = <Widget>[
      for (final f in _existing)
        if (f.isDocument)
          _DocRow(name: f.name, onAction: () => _removeExisting(f)),
      for (final f in _newFiles)
        if (f.kind == _Kind.document)
          _DocRow(name: f.name, onAction: () => _removeNew(f)),
    ];

    return [
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
                  'pdf',
                  'doc',
                  'docx',
                  'xls',
                  'xlsx',
                  'csv',
                  'txt',
                  'ppt',
                  'pptx',
                ],
              ),
            ),
          ),
          const SizedBox(width: AppSpacing.s2),
          Expanded(
            child: _AddTile(
              icon: 'ImageSquare',
              label: 'Add photo',
              onTap: () => _pick(FileType.image, _Kind.photo, null),
            ),
          ),
          const SizedBox(width: AppSpacing.s2),
          Expanded(
            child: _AddTile(
              icon: 'VideoCamera',
              label: 'Add video',
              onTap: () => _pick(FileType.video, _Kind.video, null),
            ),
          ),
        ],
      ),
      if (media.isNotEmpty) ...[
        const SizedBox(height: AppSpacing.s4),
        _MediaStrip(media),
      ],
      if (docs.isNotEmpty) ...[
        const SizedBox(height: AppSpacing.s3),
        for (final row in docs) ...[row, const SizedBox(height: AppSpacing.s2)],
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
          hintStyle: AppText.bodyLRegular.copyWith(
            color: AppColors.textSubtlest,
          ),
          filled: true,
          fillColor: AppColors.bgDefault,
          contentPadding: const EdgeInsets.all(AppSpacing.s3),
          border: OutlineInputBorder(
            borderRadius: BorderRadius.circular(AppRadius.sm),
            borderSide: BorderSide(color: AppColors.borderDefault),
          ),
          enabledBorder: OutlineInputBorder(
            borderRadius: BorderRadius.circular(AppRadius.sm),
            borderSide: BorderSide(color: AppColors.borderDefault),
          ),
          focusedBorder: OutlineInputBorder(
            borderRadius: BorderRadius.circular(AppRadius.sm),
            borderSide: const BorderSide(color: AppColors.borderFocus),
          ),
        ),
      ),
    ];
  }

  /// Read-only view of a submitted observation: finding chip, submitted meta,
  /// records (tap to open), and note.
  List<Widget> _viewChildren() {
    final o = widget.observation;
    final mediaFiles = <AuditFile>[
      for (final f in _existing)
        if (f.isPhoto || f.isVideo) f,
    ];
    final mediaItems = [for (final f in mediaFiles) _mediaItem(f)];
    final media = <Widget>[
      for (var i = 0; i < mediaFiles.length; i++)
        _MediaThumb.view(
          mediaFiles[i],
          onTap: () => _preview(mediaItems, i),
        ),
    ];
    final docs = <Widget>[
      for (final f in _existing)
        if (f.isDocument)
          _DocRow(name: f.name, download: true, onAction: () => _open(f.url)),
    ];
    final note = (o.note ?? '').trim();

    return [
      Text(o.name, style: AppText.headingM),
      const SizedBox(height: AppSpacing.s5),
      const _Label('Finding'),
      const SizedBox(height: AppSpacing.s2),
      if (_finding != null)
        Align(alignment: Alignment.centerLeft, child: _FindingChip(_finding!)),
      if (o.submittedAt != null) ...[
        const SizedBox(height: AppSpacing.s5),
        const _Label('Submitted on'),
        const SizedBox(height: AppSpacing.s1),
        Text(
          _dateFmt.format(o.submittedAt!.toLocal()),
          style: AppText.bodyMMedium,
        ),
      ],
      if (o.submittedBy != null) ...[
        const SizedBox(height: AppSpacing.s5),
        const _Label('Submitted by'),
        const SizedBox(height: AppSpacing.s2),
        Row(
          children: [
            // const AppAvatar(url: null, size: 24),
            Image.asset(
              'assets/images/2.0x/avatar.png',
              width: 20, height: 20,
            ),
            const SizedBox(width: AppSpacing.s2),
            Text(o.submittedBy!.name, style: AppText.bodyMMedium),
          ],
        ),
      ],
      if (media.isNotEmpty || docs.isNotEmpty) ...[
        const SizedBox(height: AppSpacing.s5),
        const _Label('Records'),
        if (media.isNotEmpty) ...[
          const SizedBox(height: AppSpacing.s3),
          _MediaStrip(media),
        ],
        if (docs.isNotEmpty) ...[
          const SizedBox(height: AppSpacing.s3),
          for (final row in docs) ...[
            row,
            const SizedBox(height: AppSpacing.s2),
          ],
        ],
      ],
      if (note.isNotEmpty) ...[
        const SizedBox(height: AppSpacing.s5),
        const _Label('Note'),
        const SizedBox(height: AppSpacing.s2),
        Container(
          width: double.infinity,
          padding: const EdgeInsets.all(AppSpacing.s3),
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(AppRadius.sm),
            border: Border.all(color: AppColors.borderDefault),
          ),
          child: Text(note, style: AppText.bodyMRegular),
        ),
      ],
    ];
  }
}

/// Horizontal strip of media thumbnails.
class _MediaStrip extends StatelessWidget {
  const _MediaStrip(this.thumbs);
  final List<Widget> thumbs;

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      height: 70,
      child: ListView.separated(
        scrollDirection: Axis.horizontal,
        itemCount: thumbs.length,
        separatorBuilder: (_, _) => const SizedBox(width: AppSpacing.s2),
        itemBuilder: (_, i) => thumbs[i],
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
          const SizedBox(width: AppSpacing.s4),
          Expanded(
            child: Text(
              title,
              textAlign: TextAlign.center,
              maxLines: 1,
              overflow: TextOverflow.ellipsis,
              style: AppText.bodyLMedium.copyWith(color: AppColors.textDefault),
            ),
          ),
          GestureDetector(
            onTap: () => Navigator.of(context).pop(),
            behavior: HitTestBehavior.opaque,
            child: const Icon(
              Icons.close,
              size: 24,
              color: AppColors.iconDefault,
            ),
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
          borderRadius: BorderRadius.circular(AppRadius.sm),
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
              style: AppText.bodyMRegular.copyWith(
                color: AppColors.textDefault,
              ),
            ),
          ],
        ),
      ),
    );
  }
}

/// Photo/video thumbnail. Videos show a play overlay. [onRemove] adds a delete
/// badge (edit mode); [onTap] makes it tappable to open (view mode).
class _MediaThumb extends StatelessWidget {
  const _MediaThumb._({
    required this.child,
    required this.isVideo,
    this.onRemove,
    this.onTap,
  });

  factory _MediaThumb.existing(
    AuditFile file, {
    required VoidCallback onRemove,
    VoidCallback? onTap,
  }) => _MediaThumb._(
    isVideo: file.isVideo,
    onRemove: onRemove,
    onTap: onTap,
    child: file.isVideo
        ? VideoThumbnailImage(source: file.url)
        : CachedNetworkImage(
            imageUrl: file.url,
            fit: BoxFit.cover,
            placeholder: (_, _) => const ThumbShimmer(),
            errorWidget: (_, _, _) => const ThumbError(),
          ),
  );

  factory _MediaThumb.picked(
    _Picked file, {
    required VoidCallback onRemove,
    VoidCallback? onTap,
  }) => _MediaThumb._(
    isVideo: file.kind == _Kind.video,
    onRemove: onRemove,
    onTap: onTap,
    child: file.kind == _Kind.video
        ? VideoThumbnailImage(source: file.path)
        : Image.file(File(file.path), fit: BoxFit.cover),
  );

  factory _MediaThumb.view(AuditFile file, {required VoidCallback onTap}) =>
      _MediaThumb._(
        isVideo: file.isVideo,
        onTap: onTap,
        child: file.isVideo
            ? VideoThumbnailImage(source: file.url)
            : CachedNetworkImage(
                imageUrl: file.url,
                fit: BoxFit.cover,
                placeholder: (_, _) => const ThumbShimmer(),
                errorWidget: (_, _, _) => const ThumbError(),
              ),
      );

  final Widget child;
  final bool isVideo;
  final VoidCallback? onRemove;
  final VoidCallback? onTap;

  @override
  Widget build(BuildContext context) {
    final thumb = SizedBox(
      width: 110,
      height: 70,
      child: Stack(
        fit: StackFit.expand,
        children: [
          ClipRRect(
            borderRadius: BorderRadius.circular(AppRadius.md),
            child: child,
          ),
          if (isVideo)
            const Center(
              child: Icon(
                Icons.play_circle_fill,
                size: 32,
                color: AppColors.iconInverse,
              ),
            ),
          if (onRemove != null)
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
                  child: const Icon(
                    Icons.close,
                    size: 14,
                    color: AppColors.iconInverse,
                  ),
                ),
              ),
            ),
        ],
      ),
    );
    if (onTap == null) return thumb;
    return GestureDetector(
      onTap: onTap,
      behavior: HitTestBehavior.opaque,
      child: thumb,
    );
  }
}

/// Document row: file icon + name + a trailing delete (edit) or download (view)
/// action. In view mode the whole row is tappable to open.
class _DocRow extends StatelessWidget {
  const _DocRow({
    required this.name,
    required this.onAction,
    this.download = false,
  });
  final String name;
  final VoidCallback onAction;
  final bool download;

  @override
  Widget build(BuildContext context) {
    final trailing = Icon(
      download ? Icons.file_download_outlined : Icons.delete_outline,
      size: 20,
      color: AppColors.iconSubtle,
    );
    final row = Container(
      padding: const EdgeInsets.symmetric(
        horizontal: AppSpacing.s3,
        vertical: AppSpacing.s3,
      ),
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(AppRadius.sm),
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
              style: AppText.bodyMRegular.copyWith(
                color: AppColors.textDefault,
              ),
            ),
          ),
          const SizedBox(width: AppSpacing.s2),
          if (download)
            trailing
          else
            GestureDetector(
              onTap: onAction,
              behavior: HitTestBehavior.opaque,
              child: trailing,
            ),
        ],
      ),
    );
    if (!download) return row;
    return GestureDetector(
      onTap: onAction,
      behavior: HitTestBehavior.opaque,
      child: row,
    );
  }
}

/// Read-only finding pill for the view mode.
class _FindingChip extends StatelessWidget {
  const _FindingChip(this.finding);
  final Finding finding;

  @override
  Widget build(BuildContext context) {
    final (text, bg) = switch (finding) {
      Finding.compliant => (AppColors.textSuccess, AppColors.bgSuccess),
      Finding.nonCompliant => (AppColors.textDanger, AppColors.bgDanger),
      Finding.na => (AppColors.textDefault, AppColors.bgPressed),
    };
    return Container(
      padding: const EdgeInsets.symmetric(
        horizontal: AppSpacing.s3,
        vertical: 3,
      ),
      decoration: BoxDecoration(
        color: bg,
        borderRadius: BorderRadius.circular(AppRadius.sm),
        border: Border.all(color: text),
      ),
      child: Text(
        finding.label,
        style: AppText.buttonM.copyWith(color: text),
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
