import 'dart:async';

import 'package:amanah/core/network/api_exception.dart';
import 'package:amanah/core/theme/app_colors.dart';
import 'package:amanah/core/theme/app_spacing.dart';
import 'package:amanah/core/theme/app_text_styles.dart';
import 'package:amanah/core/utils/validators.dart';
import 'package:amanah/core/widgets/app_text_field.dart';
import 'package:amanah/features/auth/presentation/providers/auth_providers.dart';
import 'package:amanah/features/auth/presentation/widgets/auth_scaffold.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';

class ForgotPasswordScreen extends ConsumerStatefulWidget {
  const ForgotPasswordScreen({super.key});

  @override
  ConsumerState<ForgotPasswordScreen> createState() =>
      _ForgotPasswordScreenState();
}

class _ForgotPasswordScreenState extends ConsumerState<ForgotPasswordScreen> {
  final _formKey = GlobalKey<FormState>();
  final _email = TextEditingController();
  var _loading = false;
  String? _error;
  var _autovalidate = false;

  @override
  void dispose() {
    _email.dispose();
    super.dispose();
  }

  Future<void> _submit() async {
    FocusScope.of(context).unfocus();
    if (!_formKey.currentState!.validate()) {
      setState(() => _autovalidate = true);
      return;
    }
    setState(() {
      _loading = true;
      _error = null;
    });
    try {
      final email = _email.text.trim();
      await ref.read(authRepositoryProvider).requestPasswordReset(email);
      if (mounted) unawaited(context.push('/verify-otp', extra: email));
    } on ApiException catch (e) {
      setState(() => _error = e.message);
    } finally {
      if (mounted) setState(() => _loading = false);
    }
  }

  @override
  Widget build(BuildContext context) {
    return AuthScaffold(
      showBack: true,
      formKey: _formKey,
      autovalidate: _autovalidate,
      children: [
        Text('Forgot password?', style: AppText.headingXl),
        const SizedBox(height: AppSpacing.s2),
        Text(
          'Submit & verify the email address registered to your account to '
          'reset your password.',
          style: AppText.bodyLRegular.copyWith(color: AppColors.textSubtle),
        ),
        const SizedBox(height: AppSpacing.s7),
        AppTextField(
          label: 'Email address',
          hint: 'e.g. johndoe@gmail.com',
          controller: _email,
          keyboardType: TextInputType.emailAddress,
          textInputAction: TextInputAction.done,
          validator: Validators.email,
          enabled: !_loading,
          onFieldSubmitted: (_) => _submit(),
        ),
        if (_error != null) ...[
          const SizedBox(height: AppSpacing.s4),
          AuthErrorBanner(_error!),
        ],
        const SizedBox(height: AppSpacing.s6),
        AuthPrimaryButton(
          label: 'Verify email',
          loading: _loading,
          onPressed: _submit,
        ),
        const SizedBox(height: AppSpacing.s3),
        AuthTextLink(
          label: 'Back to login',
          onPressed: _loading ? null : () => context.go('/sign-in'),
        ),
      ],
    );
  }
}
