import 'package:amanah/core/theme/app_colors.dart';
import 'package:amanah/core/theme/app_spacing.dart';
import 'package:amanah/core/theme/app_text_styles.dart';
import 'package:amanah/features/profile/presentation/providers/profile_providers.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

/// Opens the Delete account confirmation modal. Resolves `true` when the
/// deletion was accepted, `false`/null when dismissed or failed.
Future<bool> showDeleteAccountSheet(BuildContext context) {
  return showModalBottomSheet<bool>(
    context: context,
    isScrollControlled: true,
    useSafeArea: true,
    backgroundColor: AppColors.bgDefault,
    shape: const RoundedRectangleBorder(
      borderRadius: BorderRadius.vertical(top: Radius.circular(20)),
    ),
    builder: (_) => const _DeleteAccountSheet(),
  ).then((v) => v ?? false);
}

class _DeleteAccountSheet extends ConsumerStatefulWidget {
  const _DeleteAccountSheet();

  @override
  ConsumerState<_DeleteAccountSheet> createState() =>
      _DeleteAccountSheetState();
}

class _DeleteAccountSheetState extends ConsumerState<_DeleteAccountSheet> {
  bool _deleting = false;

  Future<void> _submit() async {
    setState(() => _deleting = true);
    try {
      await ref.read(profileRepositoryProvider).deleteAccount();
      if (!mounted) return;
      Navigator.of(context).pop(true);
    } on Object catch (_) {
      if (!mounted) return;
      ScaffoldMessenger.of(context)
        ..hideCurrentSnackBar()
        ..showSnackBar(
          const SnackBar(
            content: Text("Couldn't delete account. Try again."),
          ),
        );
    } finally {
      if (mounted) setState(() => _deleting = false);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: EdgeInsets.only(
        bottom: MediaQuery.of(context).viewInsets.bottom,
      ),
      child: Padding(
        padding: const EdgeInsets.fromLTRB(
          AppSpacing.s4,
          AppSpacing.s7,
          AppSpacing.s4,
          AppSpacing.s5,
        ),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            const Text('💣', textAlign: TextAlign.center,
                style: TextStyle(fontSize: 64)),
            const SizedBox(height: AppSpacing.s5),
            Text(
              'Delete account?',
              textAlign: TextAlign.center,
              style: AppText.headingL.copyWith(color: AppColors.textDefault),
            ),
            const SizedBox(height: AppSpacing.s3),
            Text(
              'Are you sure you want to delete your account? All your data '
              'will be lost and you will need to be added by admin again.',
              textAlign: TextAlign.center,
              style:
                  AppText.bodyMRegular.copyWith(color: AppColors.textSubtle),
            ),
            const SizedBox(height: AppSpacing.s6),
            _DangerButton(
              label: 'Delete account',
              loading: _deleting,
              onPressed: _deleting ? null : _submit,
            ),
            const SizedBox(height: AppSpacing.s3),
            SizedBox(
              height: 48,
              child: OutlinedButton(
                onPressed: _deleting ? null : () => Navigator.of(context).pop(),
                style: OutlinedButton.styleFrom(
                  foregroundColor: AppColors.textDefault,
                  side: BorderSide(color: AppColors.borderDefault),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(AppRadius.md),
                  ),
                ),
                child: Text(
                  'Cancel',
                  style:
                      AppText.buttonL.copyWith(color: AppColors.textDefault),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}

/// Full-width red filled action (AppButton only does brand-blue/outlined).
class _DangerButton extends StatelessWidget {
  const _DangerButton({
    required this.label,
    required this.onPressed,
    this.loading = false,
  });

  final String label;
  final VoidCallback? onPressed;
  final bool loading;

  @override
  Widget build(BuildContext context) {
    final enabled = onPressed != null && !loading;
    return SizedBox(
      height: 48,
      width: double.infinity,
      child: Material(
        color: AppColors.textDanger,
        borderRadius: BorderRadius.circular(AppRadius.md),
        child: InkWell(
          onTap: enabled ? onPressed : null,
          borderRadius: BorderRadius.circular(AppRadius.md),
          child: Center(
            child: loading
                ? const SizedBox(
                    width: 22,
                    height: 22,
                    child: CircularProgressIndicator(
                      strokeWidth: 2,
                      color: AppColors.brandOnPrimary,
                    ),
                  )
                : Text(
                    label,
                    style: AppText.buttonL
                        .copyWith(color: AppColors.brandOnPrimary),
                  ),
          ),
        ),
      ),
    );
  }
}
