import 'package:amanah/core/theme/app_colors.dart';
import 'package:amanah/core/theme/app_spacing.dart';
import 'package:amanah/core/theme/app_text_styles.dart';
import 'package:amanah/core/widgets/app_button.dart';
import 'package:amanah/core/widgets/app_text_field.dart';
import 'package:amanah/features/profile/presentation/providers/profile_providers.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_svg/flutter_svg.dart';

/// Opens the Update password modal. Resolves `true` when the password was
/// changed, `false`/null when dismissed or failed.
Future<bool> showUpdatePasswordSheet(BuildContext context) {
  return showModalBottomSheet<bool>(
    context: context,
    isScrollControlled: true,
    useSafeArea: true,
    backgroundColor: AppColors.bgDefault,
    shape: const RoundedRectangleBorder(
      borderRadius: BorderRadius.vertical(top: Radius.circular(20)),
    ),
    builder: (_) => const _UpdatePasswordSheet(),
  ).then((v) => v ?? false);
}

class _UpdatePasswordSheet extends ConsumerStatefulWidget {
  const _UpdatePasswordSheet();

  @override
  ConsumerState<_UpdatePasswordSheet> createState() =>
      _UpdatePasswordSheetState();
}

class _UpdatePasswordSheetState extends ConsumerState<_UpdatePasswordSheet> {
  final _formKey = GlobalKey<FormState>();
  late final TextEditingController _current;
  late final TextEditingController _newPassword;
  late final TextEditingController _confirm;
  bool _saving = false;

  @override
  void initState() {
    super.initState();
    _current = TextEditingController();
    _newPassword = TextEditingController();
    _confirm = TextEditingController();
  }

  @override
  void dispose() {
    _current.dispose();
    _newPassword.dispose();
    _confirm.dispose();
    super.dispose();
  }

  Future<void> _submit() async {
    if (!_formKey.currentState!.validate()) return;
    setState(() => _saving = true);
    try {
      await ref.read(profileRepositoryProvider).changePassword(
            currentPassword: _current.text,
            newPassword: _newPassword.text,
          );
      if (!mounted) return;
      Navigator.of(context).pop(true);
    } on Object catch (_) {
      if (!mounted) return;
      ScaffoldMessenger.of(context)
        ..hideCurrentSnackBar()
        ..showSnackBar(
          const SnackBar(
            content: Text("Couldn't update password. Check your current password."),
          ),
        );
    } finally {
      if (mounted) setState(() => _saving = false);
    }
  }

  @override
  Widget build(BuildContext context) {
    // useSafeArea gives SafeArea(bottom:false), so add the bottom inset here;
    // add the keyboard inset too so the pinned button rides above it.
    final safeBottom = MediaQuery.viewPaddingOf(context).bottom;
    final keyboard = MediaQuery.viewInsetsOf(context).bottom;

    return SizedBox(
      height: MediaQuery.sizeOf(context).height * 0.9,
      child: Form(
        key: _formKey,
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            _SheetHeader(
              title: 'Update password',
              onClose: () => Navigator.of(context).pop(false),
            ),
            Expanded(
              child: SingleChildScrollView(
                padding: const EdgeInsets.fromLTRB(
                  AppSpacing.s4,
                  AppSpacing.s5,
                  AppSpacing.s4,
                  AppSpacing.s5,
                ),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.stretch,
                  children: [
                    AppTextField(
                      label: 'Current password',
                      labelStyle: AppText.bodyMMedium,
                      hint: '********',
                      controller: _current,
                      obscurable: true,
                      textInputAction: TextInputAction.next,
                      validator: (v) => (v == null || v.isEmpty)
                          ? 'Enter your current password'
                          : null,
                    ),
                    const SizedBox(height: AppSpacing.s4),
                    AppTextField(
                      label: 'New password',
                      labelStyle: AppText.bodyMMedium,
                      hint: 'At least 8 characters',
                      controller: _newPassword,
                      obscurable: true,
                      textInputAction: TextInputAction.next,
                      validator: (v) {
                        if (v == null || v.isEmpty) return 'Enter a new password';
                        if (v.length < 8) return 'At least 8 characters';
                        return null;
                      },
                    ),
                    const SizedBox(height: AppSpacing.s4),
                    AppTextField(
                      label: 'Retype new password',
                      labelStyle: AppText.bodyMMedium,
                      hint: 'Password must match',
                      controller: _confirm,
                      obscurable: true,
                      textInputAction: TextInputAction.done,
                      validator: (v) => (v != _newPassword.text)
                          ? 'Passwords do not match'
                          : null,
                    ),
                  ],
                ),
              ),
            ),
            // Pinned action bar.
            Padding(
              padding: EdgeInsets.fromLTRB(
                AppSpacing.s4,
                AppSpacing.s3,
                AppSpacing.s4,
                AppSpacing.s4 + safeBottom + keyboard,
              ),
              child: AppButton(
                label: 'Update password',
                onPressed: _saving ? null : _submit,
                loading: _saving,
                height: 48,
              ),
            ),
          ],
        ),
      ),
    );
  }
}

/// Sheet title bar: centered title with a trailing close (X), hairline below.
class _SheetHeader extends StatelessWidget {
  const _SheetHeader({required this.title, required this.onClose});

  final String title;
  final VoidCallback onClose;

  @override
  Widget build(BuildContext context) {
    return DecoratedBox(
      decoration: BoxDecoration(
        border: Border(bottom: BorderSide(color: AppColors.borderDefault)),
      ),
      child: Padding(
        padding: const EdgeInsets.fromLTRB(
          AppSpacing.s4,
          AppSpacing.s4,
          AppSpacing.s3,
          AppSpacing.s4,
        ),
        child: Row(
          children: [
            const SizedBox(width: 44),
            Expanded(
              child: Text(
                title,
                textAlign: TextAlign.center,
                style: AppText.bodyLMedium.copyWith(color: AppColors.textSubtle),
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
      ),
    );
  }
}
