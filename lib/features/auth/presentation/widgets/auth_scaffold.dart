import 'package:amanah/core/theme/app_colors.dart';
import 'package:amanah/core/theme/app_spacing.dart';
import 'package:amanah/core/theme/app_text_styles.dart';
import 'package:amanah/core/widgets/app_back_button.dart';
import 'package:flutter/material.dart';

/// Shared layout for the onboarding/auth screens: safe area, scroll, 24px
/// padding, optional back button, and an optional form wrapper.
class AuthScaffold extends StatelessWidget {
  const AuthScaffold({
    required this.children,
    this.showBack = false,
    this.formKey,
    this.autovalidate = false,
    super.key,
  });

  final List<Widget> children;
  final bool showBack;
  final GlobalKey<FormState>? formKey;
  final bool autovalidate;

  @override
  Widget build(BuildContext context) {
    final column = Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        if (showBack) ...[
          const AppBackButton(),
          const SizedBox(height: AppSpacing.s7),
        ] else
          const SizedBox(height: AppSpacing.s5),
        ...children,
      ],
    );

    return Scaffold(
      body: SafeArea(
        child: SingleChildScrollView(
          padding: const EdgeInsets.symmetric(
            horizontal: AppSpacing.s6,
            vertical: AppSpacing.s6,
          ),
          child: formKey == null
              ? column
              : Form(
                  key: formKey,
                  autovalidateMode: autovalidate
                      ? AutovalidateMode.onUserInteraction
                      : AutovalidateMode.disabled,
                  child: column,
                ),
        ),
      ),
    );
  }
}

/// Full-width primary button with an inline loading spinner.
class AuthPrimaryButton extends StatelessWidget {
  const AuthPrimaryButton({
    required this.label,
    required this.onPressed,
    this.loading = false,
    super.key,
  });

  final String label;
  final VoidCallback onPressed;
  final bool loading;

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      height: 52,
      child: ElevatedButton(
        onPressed: loading ? () {} : onPressed,
        child: loading
            ? const SizedBox(
                width: 22,
                height: 22,
                child: CircularProgressIndicator(
                  strokeWidth: 2.5,
                  color: AppColors.textInverse,
                ),
              )
            : Text(label),
      ),
    );
  }
}

/// Centered navy text link (e.g. "Back to login").
class AuthTextLink extends StatelessWidget {
  const AuthTextLink({required this.label, this.onPressed, super.key});

  final String label;
  final VoidCallback? onPressed;

  @override
  Widget build(BuildContext context) {
    return Center(
      child: TextButton(
        onPressed: onPressed,
        child: Text(
          label,
          style: AppText.buttonM.copyWith(color: AppColors.textDefault),
        ),
      ),
    );
  }
}

/// Inline red error banner.
class AuthErrorBanner extends StatelessWidget {
  const AuthErrorBanner(this.message, {super.key});

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
