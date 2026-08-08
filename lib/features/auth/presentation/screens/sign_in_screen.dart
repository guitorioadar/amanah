import 'package:amanah/core/network/api_exception.dart';
import 'package:amanah/core/theme/app_colors.dart';
import 'package:amanah/core/theme/app_spacing.dart';
import 'package:amanah/core/theme/app_text_styles.dart';
import 'package:amanah/core/utils/validators.dart';
import 'package:amanah/core/widgets/app_text_field.dart';
import 'package:amanah/features/auth/presentation/providers/auth_providers.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:go_router/go_router.dart';

class SignInScreen extends ConsumerStatefulWidget {
  const SignInScreen({super.key});

  @override
  ConsumerState<SignInScreen> createState() => _SignInScreenState();
}

class _SignInScreenState extends ConsumerState<SignInScreen> {
  final _formKey = GlobalKey<FormState>();
  
  final _email = TextEditingController( text: kDebugMode ? 'sadman@example.com' : '', );
  final _password = TextEditingController( text: kDebugMode ? '1234567890' : '', );
  
  var _autovalidate = false;

  @override
  void dispose() {
    _email.dispose();
    _password.dispose();
    super.dispose();
  }

  Future<void> _submit() async {
    FocusScope.of(context).unfocus();
    if (!_formKey.currentState!.validate()) {
      setState(() => _autovalidate = true);
      return;
    }
    final ok = await ref.read(signInControllerProvider.notifier).signIn(
          email: _email.text,
          password: _password.text,
        );
    if (ok && mounted) context.go('/home');
  }

  @override
  Widget build(BuildContext context) {
    final state = ref.watch(signInControllerProvider);
    final loading = state.isLoading;
    final error = state.hasError ? state.error : null;

    return Scaffold(
      body: SafeArea(
        child: SingleChildScrollView(
          padding: const EdgeInsets.symmetric(
            horizontal: AppSpacing.s6,
            vertical: AppSpacing.s6,
          ),
          child: Form(
            key: _formKey,
            autovalidateMode: _autovalidate
                ? AutovalidateMode.onUserInteraction
                : AutovalidateMode.disabled,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const SizedBox(height: AppSpacing.s5),
                _Brand(),
                const SizedBox(height: AppSpacing.s9),
                Text('Welcome Back!', style: AppText.headingXl),
                const SizedBox(height: AppSpacing.s2),
                Text(
                  "Let's sign in and get started with your audits.",
                  style: AppText.bodyLRegular.copyWith(
                    color: AppColors.textSubtle,
                  ),
                ),
                const SizedBox(height: AppSpacing.s7),
                AppTextField(
                  label: 'Email address',
                  hint: 'e.g. johndoe@gmail.com',
                  controller: _email,
                  keyboardType: TextInputType.emailAddress,
                  textInputAction: TextInputAction.next,
                  validator: Validators.email,
                  enabled: !loading,
                ),
                const SizedBox(height: AppSpacing.s5),
                AppTextField(
                  label: 'Password',
                  hint: 'Enter your password',
                  controller: _password,
                  obscurable: true,
                  textInputAction: TextInputAction.done,
                  validator: Validators.password,
                  enabled: !loading,
                  onFieldSubmitted: (_) => _submit(),
                ),
                if (error != null) ...[
                  const SizedBox(height: AppSpacing.s4),
                  _ErrorBanner(_messageFor(error)),
                ],
                const SizedBox(height: AppSpacing.s6),
                SizedBox(
                  height: 52,
                  child: ElevatedButton(
                    onPressed: loading ? null : _submit,
                    child: loading
                        ? const SizedBox(
                            width: 22,
                            height: 22,
                            child: CircularProgressIndicator(
                              strokeWidth: 2.5,
                              color: AppColors.textInverse,
                            ),
                          )
                        : const Text('Sign in'),
                  ),
                ),
                const SizedBox(height: AppSpacing.s3),
                Center(
                  child: TextButton(
                    onPressed: loading
                        ? null
                        : () => context.push('/forgot-password'),
                    child: Text(
                      'Forgot password?',
                      style: AppText.buttonM.copyWith(
                        color: AppColors.textDefault,
                      ),
                    ),
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  String _messageFor(Object error) => error is ApiException
      ? error.message
      : 'Something went wrong. Please try again.';
}

class _Brand extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        SvgPicture.asset('assets/images/logo.svg', width: 32),
        const SizedBox(width: AppSpacing.s2),
        Text('ISNA Halal Amanah', style: AppText.headingS),
      ],
    );
  }
}

class _ErrorBanner extends StatelessWidget {
  const _ErrorBanner(this.message);
  final String message;

  @override
  Widget build(BuildContext context) {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.all(AppSpacing.s3),
      decoration: BoxDecoration(
        color: AppColors.bgDanger,
        borderRadius: BorderRadius.circular(AppRadius.md),
      ),
      child: Text(
        message,
        style: AppText.bodySMedium.copyWith(color: AppColors.textDanger),
      ),
    );
  }
}
