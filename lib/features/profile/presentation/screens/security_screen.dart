import 'package:amanah/core/theme/app_colors.dart';
import 'package:amanah/core/theme/app_spacing.dart';
import 'package:amanah/core/theme/app_system_ui.dart';
import 'package:amanah/core/theme/app_text_styles.dart';
import 'package:amanah/features/profile/presentation/widgets/delete_account_sheet.dart';
import 'package:amanah/features/profile/presentation/widgets/profile_top_bar.dart';
import 'package:amanah/features/profile/presentation/widgets/update_password_sheet.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

/// Sign in & Security: a "Change password" section with an outlined action,
/// then a red-outlined "Delete account" danger zone. Each opens its modal.
class SecurityScreen extends StatelessWidget {
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

  Future<void> _deleteAccount(BuildContext context) async {
    final deleted = await showDeleteAccountSheet(context);
    if (deleted && context.mounted) {
      // Session teardown lands with the real API; for now just confirm.
      ScaffoldMessenger.of(context)
        ..hideCurrentSnackBar()
        ..showSnackBar(
          const SnackBar(content: Text('Account deleted (demo)')),
        );
    }
  }

  @override
  Widget build(BuildContext context) {
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
                        onPressed: () => _deleteAccount(context),
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
