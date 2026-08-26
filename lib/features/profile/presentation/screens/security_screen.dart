import 'dart:async';

import 'package:amanah/core/theme/app_colors.dart';
import 'package:amanah/core/theme/app_spacing.dart';
import 'package:amanah/core/theme/app_system_ui.dart';
import 'package:amanah/core/theme/app_text_styles.dart';
import 'package:amanah/features/auth/presentation/providers/session_providers.dart';
import 'package:amanah/features/auth/presentation/screens/otp_verification_screen.dart';
import 'package:amanah/features/profile/presentation/widgets/delete_account_sheet.dart';
import 'package:amanah/features/profile/presentation/widgets/profile_top_bar.dart';
import 'package:amanah/features/profile/presentation/widgets/update_password_sheet.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';

/// Sign in & Security: a "Change password" section with an outlined action,
/// then a red-outlined "Delete account" danger zone. Each opens its modal.
class SecurityScreen extends ConsumerWidget {
  const SecurityScreen({super.key});

  Future<void> _updatePassword(BuildContext context) async {
    final ok = await showUpdatePasswordSheet(context);
    if (ok && context.mounted) {
      ScaffoldMessenger.of(context)
        ..hideCurrentSnackBar()
        ..showSnackBar(
          const SnackBar(content: Text('Password updated')),
        );
    }
  }

  Future<void> _deleteAccount(BuildContext context, WidgetRef ref) async {
    // Confirm → the sheet emails an OTP → verify the code → delete.
    final sent = await showDeleteAccountSheet(context);
    if (!sent || !context.mounted) return;
    final email = ref.read(currentUserProvider)?.email ?? '';
    unawaited(
      context.push(
        '/verify-otp',
        extra: {'email': email, 'purpose': OtpPurpose.deleteAccount},
      ),
    );
  }

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final topInset = MediaQuery.of(context).viewPadding.top;

    return AnnotatedRegion<SystemUiOverlayStyle>(
      value: AppSystemUi.dark,
      child: Scaffold(
        backgroundColor: AppColors.bgDefault,
        body: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            const SizedBox(height: AppSpacing.s2),
            ProfileTopBar(title: 'Sign in & Security', topInset: topInset),
            Expanded(
              child: SingleChildScrollView(
                padding: const EdgeInsets.all(AppSpacing.s4),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.stretch,
                  children: [
                    const SizedBox(height: AppSpacing.s2),
                    Text(
                      'Change password',
                      style: AppText.headingS
                          .copyWith(color: AppColors.textDefault),
                    ),
                    const SizedBox(height: AppSpacing.s2),
                    Text(
                      'You will need to input your current password to set a new password',
                      style: AppText.bodyMRegular
                          .copyWith(color: AppColors.textSubtle),
                    ),
                    const SizedBox(height: AppSpacing.s4),
                    SizedBox(
                      height: 48,
                      child: OutlinedButton(
                        onPressed: () => _updatePassword(context),
                        style: OutlinedButton.styleFrom(
                          foregroundColor: AppColors.textDefault,
                          side: BorderSide(color: AppColors.borderDefault),
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(AppRadius.md),
                          ),
                        ),
                        child: Text(
                          'Update password',
                          style: AppText.buttonL
                              .copyWith(color: AppColors.textDefault),
                        ),
                      ),
                    ),
                    const SizedBox(height: AppSpacing.s6),
                    Divider(height: 1, color: AppColors.borderDefault),
                    const SizedBox(height: AppSpacing.s6),
                    Text(
                      'Delete account',
                      style: AppText.headingS
                          .copyWith(color: AppColors.textDefault),
                    ),
                    const SizedBox(height: AppSpacing.s2),
                    Text(
                      'We do not recommend this. All your account data will be removed',
                      style: AppText.bodyMRegular
                          .copyWith(color: AppColors.textSubtle),
                    ),
                    const SizedBox(height: AppSpacing.s4),
                    SizedBox(
                      height: 48,
                      child: OutlinedButton(
                        onPressed: () => _deleteAccount(context, ref),
                        style: OutlinedButton.styleFrom(
                          foregroundColor: AppColors.textDanger,
                          side: const BorderSide(color: AppColors.borderDanger),
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(AppRadius.md),
                          ),
                        ),
                        child: Text(
                          'Delete account',
                          style: AppText.buttonL
                              .copyWith(color: AppColors.textDanger),
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
