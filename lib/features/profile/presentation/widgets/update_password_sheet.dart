import 'dart:async';

import 'package:amanah/core/network/api_exception.dart';
import 'package:amanah/core/theme/app_colors.dart';
import 'package:amanah/core/theme/app_spacing.dart';
import 'package:amanah/core/theme/app_text_styles.dart';
import 'package:amanah/core/utils/email_mask.dart';
import 'package:amanah/core/widgets/app_button.dart';
import 'package:amanah/core/widgets/app_text_field.dart';
import 'package:amanah/features/auth/presentation/providers/auth_providers.dart';
import 'package:amanah/features/auth/presentation/providers/session_providers.dart';
import 'package:amanah/features/auth/presentation/widgets/otp_input.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_svg/flutter_svg.dart';

/// Opens the Update password modal. Reuses the password-recovery flow: an OTP
/// is emailed to the signed-in user on open, then the user enters that code
/// plus a new password. Resolves `true` when the password was changed.
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
  late final TextEditingController _newPassword;
  late final TextEditingController _confirm;
  String _otpCode = '';
  bool _otpDirty = false;
  bool _saving = false;
  bool _resending = false;

  /// Inline feedback (SnackBars are hidden behind the sheet, so we render
  /// status/errors inside it). [_error] is red, [_status] is a success note.
  String? _error;
  String? _status;

  String _messageFor(Object e, String fallback) =>
      e is ApiException ? e.message : fallback;

  /// Email of the signed-in user — the recovery code is sent here.
  String get _email => ref.read(currentUserProvider)?.email ?? '';

  @override
  void initState() {
    super.initState();
    _newPassword = TextEditingController();
    _confirm = TextEditingController();
    // Fire the OTP as soon as the sheet opens (user is already authenticated,
    // so we already have their email).
    WidgetsBinding.instance
        .addPostFrameCallback((_) => unawaited(_sendOtp(initial: true)));
  }

  void _handleResend() => unawaited(_sendOtp());

  @override
  void dispose() {
    _newPassword.dispose();
    _confirm.dispose();
    super.dispose();
  }

  Future<void> _sendOtp({bool initial = false}) async {
    if (_email.isEmpty) return;
    if (!initial) setState(() => _resending = true);
    setState(() => _status = null);
    try {
      await ref.read(authRepositoryProvider).requestPasswordReset(_email);
      if (!mounted) return;
      setState(() {
        _error = null;
        if (!initial) _status = 'Code sent to ${maskEmail(_email)}';
      });
    } on Object catch (e) {
      if (!mounted) return;
      setState(() =>
          _error = _messageFor(e, "Couldn't send the code. Try again."));
    } finally {
      if (mounted && !initial) setState(() => _resending = false);
    }
  }

  Future<void> _submit() async {
    final otpOk = _otpCode.length == 6;
    final formOk = _formKey.currentState!.validate();
    if (!otpOk) setState(() => _otpDirty = true);
    if (!otpOk || !formOk) return;
    setState(() {
      _saving = true;
      _error = null;
      _status = null;
    });
    try {
      // Verifies the OTP and sets the new password in one call; the backend
      // re-issues the session token, so refresh the cached user.
      final user = await ref.read(authRepositoryProvider).resetPassword(
            email: _email,
            code: _otpCode,
            newPassword: _newPassword.text,
          );
      if (!mounted) return;
      await ref.read(currentUserProvider.notifier).setUser(user);
      if (!mounted) return;
      Navigator.of(context).pop(true);
    } on Object catch (e) {
      if (!mounted) return;
      setState(() => _error = _messageFor(
            e,
            "Couldn't update password. Check the code and try again.",
          ));
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
                    Text(
                      'We sent a verification code to ${maskEmail(_email)}. '
                      'Enter it below, then set your new password.',
                      style: AppText.bodyMRegular
                          .copyWith(color: AppColors.textSubtle),
                    ),
                    const SizedBox(height: AppSpacing.s5),
                    Text(
                      'Verification code',
                      style: AppText.bodyMMedium
                          .copyWith(color: AppColors.textDefault),
                    ),
                    const SizedBox(height: AppSpacing.s2),
                    OtpInput(
                      enabled: !_saving,
                      onChanged: (code) => setState(() {
                        _otpCode = code;
                        _error = null;
                      }),
                    ),
                    if (_otpDirty && _otpCode.length != 6) ...[
                      const SizedBox(height: AppSpacing.s2),
                      Text(
                        'Enter the 6-digit code',
                        style: AppText.bodySRegular
                            .copyWith(color: AppColors.textDanger),
                      ),
                    ],
                    const SizedBox(height: AppSpacing.s2),
                    Align(
                      alignment: Alignment.centerLeft,
                      child: TextButton(
                        onPressed: _resending ? null : _handleResend,
                        style: TextButton.styleFrom(
                          padding: EdgeInsets.zero,
                          minimumSize: Size.zero,
                          tapTargetSize: MaterialTapTargetSize.shrinkWrap,
                        ),
                        child: Text(
                          _resending ? 'Sending…' : 'Resend code',
                          style: AppText.bodyMMedium
                              .copyWith(color: AppColors.textBrand),
                        ),
                      ),
                    ),
                    if (_status != null) ...[
                      const SizedBox(height: AppSpacing.s1),
                      Text(
                        _status!,
                        style: AppText.bodySRegular
                            .copyWith(color: AppColors.textSuccess),
                      ),
                    ],
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
              child: Column(
                mainAxisSize: MainAxisSize.min,
                crossAxisAlignment: CrossAxisAlignment.stretch,
                children: [
                  if (_error != null) ...[
                    Container(
                      padding: const EdgeInsets.symmetric(
                        horizontal: AppSpacing.s3,
                        vertical: AppSpacing.s2,
                      ),
                      decoration: BoxDecoration(
                        color: AppColors.bgDanger,
                        borderRadius: BorderRadius.circular(AppRadius.md),
                      ),
                      child: Text(
                        _error!,
                        style: AppText.bodyMRegular
                            .copyWith(color: AppColors.textDanger),
                      ),
                    ),
                    const SizedBox(height: AppSpacing.s3),
                  ],
                  AppButton(
                    label: 'Update password',
                    onPressed: _saving ? null : _submit,
                    loading: _saving,
                    height: 48,
                  ),
                ],
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
