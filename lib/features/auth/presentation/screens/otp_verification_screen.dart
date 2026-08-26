import 'dart:async';

import 'package:amanah/core/network/api_exception.dart';
import 'package:amanah/core/theme/app_colors.dart';
import 'package:amanah/core/theme/app_spacing.dart';
import 'package:amanah/core/theme/app_text_styles.dart';
import 'package:amanah/core/utils/email_mask.dart';
import 'package:amanah/features/auth/presentation/providers/auth_providers.dart';
import 'package:amanah/features/auth/presentation/widgets/auth_scaffold.dart';
import 'package:amanah/features/auth/presentation/widgets/otp_input.dart';
import 'package:amanah/features/profile/presentation/providers/profile_providers.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';

/// Why the OTP screen is being shown — decides the resend endpoint and where a
/// verified code goes next.
enum OtpPurpose { passwordReset, deleteAccount }

class OtpVerificationScreen extends ConsumerStatefulWidget {
  const OtpVerificationScreen({
    required this.email,
    this.purpose = OtpPurpose.passwordReset,
    super.key,
  });

  final String email;
  final OtpPurpose purpose;

  @override
  ConsumerState<OtpVerificationScreen> createState() =>
      _OtpVerificationScreenState();
}

class _OtpVerificationScreenState
    extends ConsumerState<OtpVerificationScreen> {
  static const _codeLength = 6;
  String _code = '';
  var _loading = false;
  String? _error;

  void _submit() {
    FocusScope.of(context).unfocus();
    if (_code.length < _codeLength) {
      setState(() => _error = 'Enter the 6-digit code.');
      return;
    }
    // No verify endpoint — the OTP is checked by the call on the next screen
    // (reset-password, or the account deletion). Carry the code forward.
    final next = switch (widget.purpose) {
      OtpPurpose.passwordReset => '/reset-password',
      OtpPurpose.deleteAccount => '/deleting-account',
    };
    unawaited(
      context.push(
        next,
        extra: widget.purpose == OtpPurpose.deleteAccount
            ? _code
            : {'email': widget.email, 'code': _code},
      ),
    );
  }

  Future<void> _resend() async {
    setState(() {
      _loading = true;
      _error = null;
    });
    try {
      if (widget.purpose == OtpPurpose.deleteAccount) {
        await ref.read(profileRepositoryProvider).sendDeleteAccountOtp();
      } else {
        await ref
            .read(authRepositoryProvider)
            .requestPasswordReset(widget.email);
      }
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text('A new code has been sent.')),
        );
      }
    } on ApiException catch (e) {
      if (mounted) setState(() => _error = e.message);
    } finally {
      if (mounted) setState(() => _loading = false);
    }
  }

  @override
  Widget build(BuildContext context) {
    return AuthScaffold(
      showBack: true,
      children: [
        Text('Verify email address', style: AppText.headingXl),
        const SizedBox(height: AppSpacing.s2),
        Text.rich(
          TextSpan(
            style: AppText.bodyLRegular.copyWith(color: AppColors.textSubtle),
            children: [
              const TextSpan(
                text: 'Enter the OTP code that has been sent to your email '
                    'address at ',
              ),
              TextSpan(
                text: maskEmail(widget.email),
                style: AppText.bodyLMedium
                    .copyWith(color: AppColors.textDefault),
              ),
            ],
          ),
        ),
        const SizedBox(height: AppSpacing.s7),
        OtpInput(
          enabled: !_loading,
          onChanged: (v) => setState(() {
            _code = v;
            _error = null;
          }),
        ),
        const SizedBox(height: AppSpacing.s4),
        Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Text(
              "Didn't receive any code? ",
              style: AppText.bodyMRegular
                  .copyWith(color: AppColors.textSubtle),
            ),
            GestureDetector(
              onTap: _loading ? null : _resend,
              child: Text(
                'Resend',
                style: AppText.bodyMSemiBold
                    .copyWith(color: AppColors.textBrand),
              ),
            ),
          ],
        ),
        if (_error != null) ...[
          const SizedBox(height: AppSpacing.s4),
          AuthErrorBanner(_error!),
        ],
        const SizedBox(height: AppSpacing.s6),
        AuthPrimaryButton(
          label: 'Submit',
          loading: _loading,
          onPressed: _submit,
        ),
        const SizedBox(height: AppSpacing.s3),
        if (widget.purpose == OtpPurpose.deleteAccount)
          AuthTextLink(
            label: 'Cancel',
            onPressed: _loading ? null : () => context.pop(),
          )
        else
          AuthTextLink(
            label: 'Back to login',
            onPressed: _loading ? null : () => context.go('/sign-in'),
          ),
      ],
    );
  }
}
