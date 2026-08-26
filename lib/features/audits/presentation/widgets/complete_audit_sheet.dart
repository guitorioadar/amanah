import 'package:amanah/core/network/api_exception.dart';
import 'package:amanah/core/theme/app_colors.dart';
import 'package:amanah/core/theme/app_spacing.dart';
import 'package:amanah/core/theme/app_text_styles.dart';
import 'package:amanah/core/widgets/app_button.dart';
import 'package:amanah/features/audits/presentation/providers/audit_providers.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:toastification/toastification.dart';

/// Opens the "Complete audit" sheet: an optional note + a pinned confirm
/// button that finalizes the audit. Resolves `true` once completion succeeds,
/// `false`/null when dismissed.
Future<bool> showCompleteAuditSheet(
  BuildContext context, {
  required int eventId,
}) {
  return showModalBottomSheet<bool>(
    context: context,
    isScrollControlled: true,
    useSafeArea: true,
    backgroundColor: AppColors.bgDefault,
    shape: const RoundedRectangleBorder(
      borderRadius: BorderRadius.vertical(top: Radius.circular(AppRadius.xl)),
    ),
    builder: (_) => _CompleteAuditSheet(eventId: eventId),
  ).then((v) => v ?? false);
}

class _CompleteAuditSheet extends ConsumerStatefulWidget {
  const _CompleteAuditSheet({required this.eventId});

  final int eventId;

  @override
  ConsumerState<_CompleteAuditSheet> createState() =>
      _CompleteAuditSheetState();
}

class _CompleteAuditSheetState extends ConsumerState<_CompleteAuditSheet> {
  final _controller = TextEditingController();
  bool _submitting = false;

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  Future<void> _submit() async {
    setState(() => _submitting = true);
    try {
      await ref
          .read(auditRepositoryProvider)
          .completeAudit(widget.eventId, note: _controller.text);
      if (!mounted) return;
      Navigator.of(context).pop(true);
    } on ApiException catch (e) {
      if (!mounted) return;
      setState(() => _submitting = false);
      toastification.show(
        context: context,
        type: ToastificationType.error,
        style: ToastificationStyle.flat,
        title: Text(e.message),
        alignment: Alignment.bottomCenter,
        autoCloseDuration: const Duration(seconds: 3),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    final keyboardInset = MediaQuery.of(context).viewInsets.bottom;
    // Tall sheet so the confirm button pins near the bottom, per design.
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
                    Text(
                      'Add a note before completing',
                      style: AppText.headingM
                          .copyWith(color: AppColors.textDefault),
                    ),
                    const SizedBox(height: AppSpacing.s2),
                    Text(
                      'Once you complete & submit this report will be sent to '
                      "admin and you won't be able to change anymore",
                      style: AppText.bodyMRegular
                          .copyWith(color: AppColors.textSubtle),
                    ),
                    const SizedBox(height: AppSpacing.s4),
                    _NoteField(controller: _controller, enabled: !_submitting),
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
                label: 'Complete audit',
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

/// Centered title + close button + hairline, matching the design header.
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
                'Complete audit',
                style: AppText.bodyLMedium
                    .copyWith(color: AppColors.textSubtle),
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

/// Bordered multi-line note box with an optional-hint placeholder.
class _NoteField extends StatelessWidget {
  const _NoteField({required this.controller, required this.enabled});

  final TextEditingController controller;
  final bool enabled;

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(
        horizontal: AppSpacing.s1,
        vertical: AppSpacing.s1,
      ),
      decoration: BoxDecoration(
        color: AppColors.bgDefault,
        borderRadius: BorderRadius.circular(AppRadius.md),
        border: Border.all(color: AppColors.borderDefault),
      ),
      child: TextField(
        controller: controller,
        enabled: enabled,
        // Starts ~5 lines tall (per design) and grows before scrolling.
        minLines: 5,
        maxLines: 8,
        style: AppText.bodyMRegular.copyWith(color: AppColors.textDefault),
        decoration: InputDecoration(
          isCollapsed: true,
          filled: false,
          // The visible box is the parent Container; null every field border
          // so the theme's input outline doesn't draw a second rectangle.
          border: InputBorder.none,
          enabledBorder: InputBorder.none,
          focusedBorder: InputBorder.none,
          disabledBorder: InputBorder.none,
          hintText: 'Add note here (optional)',
          hintStyle:
              AppText.bodyMRegular.copyWith(color: AppColors.textSubtlest),
        ),
      ),
    );
  }
}
