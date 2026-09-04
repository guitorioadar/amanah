import 'dart:async';

import 'package:amanah/core/media/media_prep.dart';
import 'package:amanah/core/network/api_exception.dart';
import 'package:amanah/core/theme/app_colors.dart';
import 'package:amanah/core/theme/app_spacing.dart';
import 'package:amanah/core/theme/app_text_styles.dart';
import 'package:amanah/core/widgets/app_button.dart';
import 'package:amanah/core/widgets/media_viewer.dart';
import 'package:amanah/features/expenses/data/models/expense_options.dart';
import 'package:amanah/features/expenses/presentation/providers/expense_providers.dart';
import 'package:amanah/features/expenses/presentation/widgets/expense_media.dart';
import 'package:amanah/features/expenses/presentation/widgets/select_sheets.dart';
import 'package:file_picker/file_picker.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:toastification/toastification.dart';

/// Opens the "New expense entry" sheet for [date]. Resolves `true` once an
/// expense is created so the caller can refresh, `false`/null when dismissed.
Future<bool> showNewExpenseSheet(
  BuildContext context, {
  required DateTime date,
}) {
  return showModalBottomSheet<bool>(
    context: context,
    isScrollControlled: true,
    useSafeArea: true,
    backgroundColor: AppColors.bgDefault,
    shape: const RoundedRectangleBorder(
      borderRadius: BorderRadius.vertical(top: Radius.circular(AppRadius.xl)),
    ),
    builder: (_) => _NewExpenseSheet(date: date),
  ).then((v) => v ?? false);
}

class _NewExpenseSheet extends ConsumerStatefulWidget {
  const _NewExpenseSheet({required this.date});
  final DateTime date;

  @override
  ConsumerState<_NewExpenseSheet> createState() => _NewExpenseSheetState();
}

class _NewExpenseSheetState extends ConsumerState<_NewExpenseSheet> {
  final _before = TextEditingController();
  final _after = TextEditingController();

  List<ClientOption> _clients = const [];
  ExpenseCategoryOption? _category;
  final List<({String path, String name})> _receipts = [];
  bool _submitting = false;

  @override
  void dispose() {
    _before.dispose();
    _after.dispose();
    super.dispose();
  }

  Future<void> _pickClients() async {
    final result = await showSelectClientsSheet(context, initial: _clients);
    if (result != null) setState(() => _clients = result);
  }

  Future<void> _pickCategory() async {
    final result = await showSelectCategorySheet(context, initial: _category);
    if (result != null) setState(() => _category = result);
  }

  /// "Add file" — documents only (no images/videos in the file browser).
  Future<void> _pickDocuments() => _pick(
        FilePicker.pickFiles(
          type: FileType.custom,
          allowedExtensions: const [
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
        MediaPrepKind.document,
      );

  /// "Add photo" — images only.
  Future<void> _pickPhotos() => _pick(
        FilePicker.pickFiles(type: FileType.image),
        MediaPrepKind.image,
      );

  Future<void> _pick(
    Future<List<PlatformFile>> picker,
    MediaPrepKind kind,
  ) async {
    final result = await picker;
    final picked = result.where((f) => f.path != null).toList();
    if (picked.isEmpty) return;
    // Convert heic/mov receipts to jpg/mp4 and enforce the 100 MB cap.
    for (final f in picked) {
      if (!mounted) return;
      final processed = await prepareMedia(context, path: f.path!, kind: kind);
      if (processed == null) continue;
      if (!mounted) return;
      setState(() {
        _receipts.add((path: processed, name: _displayName(f.name, processed)));
      });
    }
  }

  /// Keeps the base name, swaps the extension to match the converted file.
  static String _displayName(String original, String path) {
    final ext = path.contains('.') ? path.split('.').last : '';
    final dot = original.lastIndexOf('.');
    final base = dot == -1 ? original : original.substring(0, dot);
    return ext.isEmpty ? base : '$base.$ext';
  }

  void _removeReceipt(({String path, String name}) r) =>
      setState(() => _receipts.remove(r));

  /// Picked receipts split into an image/video strip + document rows, mirroring
  /// the observation submission preview.
  List<Widget> _receiptPreviews() {
    if (_receipts.isEmpty) return const [];
    final media = <({String path, String name})>[];
    final docs = <({String path, String name})>[];
    for (final r in _receipts) {
      if (receiptKindFromName(r.name) == ReceiptKind.document) {
        docs.add(r);
      } else {
        media.add(r);
      }
    }

    return [
      const SizedBox(height: AppSpacing.s3),
      if (media.isNotEmpty)
        ExpenseMediaStrip([
          for (var i = 0; i < media.length; i++)
            if (receiptKindFromName(media[i].name) == ReceiptKind.video)
              ExpenseMediaThumb.video(
                media[i].path,
                onRemove: _submitting ? null : () => _removeReceipt(media[i]),
                onTap: () => _previewMedia(media, i),
              )
            else
              ExpenseMediaThumb.fileImage(
                media[i].path,
                onRemove: _submitting ? null : () => _removeReceipt(media[i]),
                onTap: () => _previewMedia(media, i),
              ),
        ]),
      for (final d in docs) ...[
        const SizedBox(height: AppSpacing.s2),
        _ReceiptRow(
          name: d.name,
          onRemove: _submitting ? null : () => _removeReceipt(d),
        ),
      ],
    ];
  }

  void _previewMedia(List<({String path, String name})> media, int index) {
    final items = [
      for (final r in media)
        if (receiptKindFromName(r.name) == ReceiptKind.video)
          MediaItem.fileVideo(r.path)
        else
          MediaItem.fileImage(r.path),
    ];
    unawaited(showMediaViewer(context, items: items, initialIndex: index));
  }

  void _toast(String message, {bool error = true}) {
    toastification.show(
      context: context,
      type: error ? ToastificationType.error : ToastificationType.success,
      style: ToastificationStyle.flat,
      title: Text(message),
      alignment: Alignment.bottomCenter,
      autoCloseDuration: const Duration(seconds: 3),
    );
  }

  String? _validate() {
    if (_clients.isEmpty) return 'Select at least one client.';
    if (_category == null) return 'Select an expense category.';
    if (num.tryParse(_before.text.trim()) == null) {
      return 'Enter a valid amount (before tax).';
    }
    if (num.tryParse(_after.text.trim()) == null) {
      return 'Enter a valid amount (after tax).';
    }
    if (_receipts.isEmpty) return 'Add at least one receipt.';
    return null;
  }

  Future<void> _submit() async {
    final error = _validate();
    if (error != null) {
      _toast(error);
      return;
    }
    setState(() => _submitting = true);
    try {
      await ref.read(expenseRepositoryProvider).createExpense(
            categoryId: _category!.id,
            clientIds: _clients.map((c) => c.id).toList(),
            amountBeforeTax: num.parse(_before.text.trim()),
            amountAfterTax: num.parse(_after.text.trim()),
            date: widget.date,
            receiptPaths: _receipts.map((r) => r.path).toList(),
          );
      if (!mounted) return;
      Navigator.of(context).pop(true);
    } on ApiException catch (e) {
      if (!mounted) return;
      setState(() => _submitting = false);
      _toast(e.message);
    }
  }

  @override
  Widget build(BuildContext context) {
    final keyboardInset = MediaQuery.of(context).viewInsets.bottom;
    final height = MediaQuery.sizeOf(context).height * 0.9;

    return Padding(
      padding: EdgeInsets.only(bottom: keyboardInset),
      child: SizedBox(
        height: height,
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            _TopBar(onClose: () => Navigator.of(context).pop(false)),
            Expanded(
              child: SingleChildScrollView(
                padding: const EdgeInsets.fromLTRB(
                  AppSpacing.s4,
                  AppSpacing.s5,
                  AppSpacing.s4,
                  AppSpacing.s4,
                ),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    const _FieldLabel('Clients', required: true),
                    _SelectField(
                      onTap: _submitting ? null : _pickClients,
                      child: _clients.isEmpty
                          ? const _Placeholder('Type or select')
                          : Wrap(
                              spacing: AppSpacing.s2,
                              runSpacing: AppSpacing.s2,
                              children: [
                                for (final c in _clients)
                                  _ValueChip(c.businessName ?? c.name),
                              ],
                            ),
                    ),
                    const SizedBox(height: AppSpacing.s5),
                    const _FieldLabel('Expense category', required: true),
                    _SelectField(
                      onTap: _submitting ? null : _pickCategory,
                      child: _category == null
                          ? const _Placeholder('Type or select')
                          : Text(
                              _category!.title,
                              maxLines: 1,
                              overflow: TextOverflow.ellipsis,
                              style: AppText.bodyLRegular
                                  .copyWith(color: AppColors.textDefault),
                            ),
                    ),
                    const SizedBox(height: AppSpacing.s5),
                    const _FieldLabel('Amount (Before tax)', required: true),
                    _AmountField(controller: _before, enabled: !_submitting),
                    const SizedBox(height: AppSpacing.s5),
                    const _FieldLabel('Amount (After tax)', required: true),
                    _AmountField(controller: _after, enabled: !_submitting),
                    const SizedBox(height: AppSpacing.s5),
                    Text(
                      'Add receipt',
                      style: AppText.bodyLMedium
                          .copyWith(color: AppColors.textSubtle),
                    ),
                    const SizedBox(height: AppSpacing.s3),
                    Row(
                      children: [
                        Expanded(
                          child: _UploadTile(
                            icon: 'assets/icons/fill/FileArrowUp.svg',
                            label: 'Add file',
                            onTap: _submitting ? null : _pickDocuments,
                          ),
                        ),
                        const SizedBox(width: AppSpacing.s3),
                        Expanded(
                          child: _UploadTile(
                            icon: 'assets/icons/fill/ImageSquare.svg',
                            label: 'Add photo',
                            onTap: _submitting ? null : _pickPhotos,
                          ),
                        ),
                      ],
                    ),
                    ..._receiptPreviews(),
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
                label: 'Add expense',
                height: 48,
                loading: _submitting,
                onPressed: _submitting ? null : _submit,
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class _TopBar extends StatelessWidget {
  const _TopBar({required this.onClose});
  final VoidCallback onClose;

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        border: Border(bottom: BorderSide(color: AppColors.borderDefault)),
      ),
      padding: const EdgeInsets.fromLTRB(
        AppSpacing.s4,
        AppSpacing.s4,
        AppSpacing.s3,
        AppSpacing.s3,
      ),
      child: Row(
        children: [
          const SizedBox(width: 44),
          Expanded(
            child: Center(
              child: Text(
                'New expense entry',
                style:
                    AppText.bodyLMedium.copyWith(color: AppColors.textSubtle),
              ),
            ),
          ),
          GestureDetector(
            onTap: onClose,
            behavior: HitTestBehavior.opaque,
            child: Padding(
              padding: const EdgeInsets.all(AppSpacing.s1),
              child: SvgPicture.asset(
                'assets/icons/line/X.svg',
                width: 24,
                colorFilter: const ColorFilter.mode(
                  AppColors.iconSubtle,
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

class _FieldLabel extends StatelessWidget {
  const _FieldLabel(this.text, {this.required = false});
  final String text;
  final bool required;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(bottom: AppSpacing.s2),
      child: Text.rich(
        TextSpan(
          text: text,
          style: AppText.bodyLMedium.copyWith(color: AppColors.textDefault),
          children: [
            if (required)
              TextSpan(
                text: ' *',
                style: AppText.bodyLMedium.copyWith(color: AppColors.textDanger),
              ),
          ],
        ),
      ),
    );
  }
}

/// Tappable bordered field with a trailing caret (opens a picker sheet).
class _SelectField extends StatelessWidget {
  const _SelectField({required this.child, required this.onTap});
  final Widget child;
  final VoidCallback? onTap;

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: onTap,
      borderRadius: BorderRadius.circular(AppRadius.md),
      child: Container(
        constraints: const BoxConstraints(minHeight: 46),
        padding: const EdgeInsets.symmetric(
          horizontal: AppSpacing.s3,
          vertical: AppSpacing.s2,
        ),
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(AppRadius.md),
          border: Border.all(color: AppColors.borderDefault),
        ),
        child: Row(
          children: [
            Expanded(child: child),
            const SizedBox(width: AppSpacing.s2),
            SvgPicture.asset(
              'assets/icons/fill/CaretDown.svg',
              width: 18,
              colorFilter: const ColorFilter.mode(
                AppColors.iconSubtle,
                BlendMode.srcIn,
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class _Placeholder extends StatelessWidget {
  const _Placeholder(this.text);
  final String text;

  @override
  Widget build(BuildContext context) {
    return Text(
      text,
      style: AppText.bodyLRegular.copyWith(color: AppColors.textSubtlest),
    );
  }
}

class _ValueChip extends StatelessWidget {
  const _ValueChip(this.label);
  final String label;

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(
        horizontal: AppSpacing.s3,
        vertical: AppSpacing.s1,
      ),
      decoration: BoxDecoration(
        color: AppColors.bgPressed,
        borderRadius: BorderRadius.circular(AppRadius.sm),
        border: Border.all(color: AppColors.borderDefault),
      ),
      child: Text(
        label,
        style: AppText.bodyMRegular.copyWith(color: AppColors.textDefault),
      ),
    );
  }
}

class _AmountField extends StatelessWidget {
  const _AmountField({required this.controller, required this.enabled});
  final TextEditingController controller;
  final bool enabled;

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: AppSpacing.s3),
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(AppRadius.md),
        border: Border.all(color: AppColors.borderDefault),
      ),
      child: TextField(
        controller: controller,
        enabled: enabled,
        keyboardType: const TextInputType.numberWithOptions(decimal: true),
        inputFormatters: [
          FilteringTextInputFormatter.allow(RegExp(r'^\d*\.?\d{0,2}')),
        ],
        style: AppText.bodyLRegular.copyWith(color: AppColors.textDefault),
        decoration: InputDecoration(
          isCollapsed: true,
          filled: false,
          border: InputBorder.none,
          enabledBorder: InputBorder.none,
          focusedBorder: InputBorder.none,
          disabledBorder: InputBorder.none,
          prefixText: r'$ ',
          prefixStyle:
              AppText.bodyLRegular.copyWith(color: AppColors.textDefault),
          hintText: '0.00',
          hintStyle:
              AppText.bodyLRegular.copyWith(color: AppColors.textSubtlest),
          contentPadding: const EdgeInsets.symmetric(vertical: 11),
        ),
      ),
    );
  }
}

/// Dashed-border upload tile (Add file / Add photo).
class _UploadTile extends StatelessWidget {
  const _UploadTile({
    required this.icon,
    required this.label,
    required this.onTap,
  });
  final String icon;
  final String label;
  final VoidCallback? onTap;

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: onTap,
      borderRadius: BorderRadius.circular(AppRadius.md),
      child: CustomPaint(
        painter: _DashedBorderPainter(
          color: AppColors.borderBold,
          radius: AppRadius.md,
        ),
        child: Container(
          height: 96,
          alignment: Alignment.center,
          decoration: BoxDecoration(
            color: AppColors.bgHovered,
            borderRadius: BorderRadius.circular(AppRadius.md),
          ),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              SvgPicture.asset(
                icon,
                width: 26,
                colorFilter: const ColorFilter.mode(
                  AppColors.iconSubtle,
                  BlendMode.srcIn,
                ),
              ),
              const SizedBox(height: AppSpacing.s2),
              Text(
                label,
                style:
                    AppText.bodyMMedium.copyWith(color: AppColors.textDefault),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

/// Paints a dashed rounded-rectangle stroke around the upload tile.
class _DashedBorderPainter extends CustomPainter {
  _DashedBorderPainter({required this.color, required this.radius});

  final Color color;
  final double radius;
  static const double dash = 5;
  static const double gap = 4;

  @override
  void paint(Canvas canvas, Size size) {
    final paint = Paint()
      ..color = color
      ..strokeWidth = 1.2
      ..style = PaintingStyle.stroke;
    final rrect = RRect.fromRectAndRadius(
      Offset.zero & size,
      Radius.circular(radius),
    );
    final path = Path()..addRRect(rrect);
    for (final metric in path.computeMetrics()) {
      var distance = 0.0;
      while (distance < metric.length) {
        canvas.drawPath(
          metric.extractPath(distance, distance + dash),
          paint,
        );
        distance += dash + gap;
      }
    }
  }

  @override
  bool shouldRepaint(_DashedBorderPainter old) =>
      old.color != color || old.radius != radius;
}

class _ReceiptRow extends StatelessWidget {
  const _ReceiptRow({required this.name, required this.onRemove});
  final String name;
  final VoidCallback? onRemove;

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: const EdgeInsets.only(top: AppSpacing.s2),
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
          if (onRemove != null)
            GestureDetector(
              onTap: onRemove,
              behavior: HitTestBehavior.opaque,
              child: Padding(
                padding: const EdgeInsets.all(AppSpacing.s1),
                child: SvgPicture.asset(
                  'assets/icons/line/Trash.svg',
                  width: 20,
                  colorFilter: const ColorFilter.mode(
                    AppColors.iconDanger,
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
