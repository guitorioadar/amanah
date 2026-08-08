import 'package:amanah/core/network/api_exception.dart';
import 'package:amanah/core/theme/app_colors.dart';
import 'package:amanah/core/theme/app_spacing.dart';
import 'package:amanah/core/theme/app_text_styles.dart';
import 'package:amanah/core/utils/validators.dart';
import 'package:amanah/core/widgets/app_text_field.dart';
import 'package:amanah/features/auth/presentation/providers/auth_providers.dart';
import 'package:amanah/features/auth/presentation/providers/session_providers.dart';
import 'package:amanah/features/auth/presentation/widgets/auth_scaffold.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';

class SetNewPasswordScreen extends ConsumerStatefulWidget {
  const SetNewPasswordScreen({
    required this.email,
    required this.code,
    super.key,
  });

  final String email;
  final String code;

  @override
  ConsumerState<SetNewPasswordScreen> createState() =>
      _SetNewPasswordScreenState();
}

class _SetNewPasswordScreenState extends ConsumerState<SetNewPasswordScreen> {
  final _formKey = GlobalKey<FormState>();
  final _password = TextEditingController();
  final _confirm = TextEditingController();
  var _loading = false;
  String? _error;
  var _autovalidate = false;

  @override
  void dispose() {
    _password.dispose();
    _confirm.dispose();
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
      final user = await ref.read(authRepositoryProvider).resetPassword(
            email: widget.email,
            code: widget.code,
            newPassword: _password.text,
          );
      // Reset auto-logs-in — cache the user so we land signed in.
      await ref.read(currentUserProvider.notifier).setUser(user);
      if (mounted) context.go('/password-updated');
    } on ApiException catch (e) {
      setState(() => _error = e.message);
    } finally {
      if (mounted) setState(() => _loading = false);
    }
  }

  @override
  Widget build(BuildContext context) {
    return AuthScaffold(
      formKey: _formKey,
      autovalidate: _autovalidate,
      children: [
        Text('Set new password', style: AppText.headingXl),
        const SizedBox(height: AppSpacing.s2),
        Text(
          'We recommend to set a strong password to keep your account secure.',
          style: AppText.bodyLRegular.copyWith(color: AppColors.textSubtle),
        ),
        const SizedBox(height: AppSpacing.s7),
        AppTextField(
          label: 'New password',
          hint: 'At least 8 characters',
          controller: _password,
          obscurable: true,
          textInputAction: TextInputAction.next,
          validator: Validators.newPassword,
          enabled: !_loading,
        ),
        const SizedBox(height: AppSpacing.s5),
        AppTextField(
          label: 'Retype new password',
          hint: 'Password must match',
          controller: _confirm,
          obscurable: true,
          textInputAction: TextInputAction.done,
          validator: (v) => Validators.confirmPassword(v, _password.text),
          enabled: !_loading,
          onFieldSubmitted: (_) => _submit(),
        ),
        if (_error != null) ...[
          const SizedBox(height: AppSpacing.s4),
          AuthErrorBanner(_error!),
        ],
        const SizedBox(height: AppSpacing.s6),
        AuthPrimaryButton(
          label: 'Set new password',
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
