import 'dart:async';

import 'package:amanah/core/network/api_exception.dart';
import 'package:amanah/core/theme/app_colors.dart';
import 'package:amanah/core/theme/app_spacing.dart';
import 'package:amanah/core/theme/app_system_ui.dart';
import 'package:amanah/core/theme/app_text_styles.dart';
import 'package:amanah/features/auth/presentation/providers/session_providers.dart';
import 'package:amanah/features/profile/presentation/providers/profile_providers.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_svg/flutter_svg.dart';

/// Transitional "Deleting account…" screen. Verifies the [otpCode] against
/// `POST /auth/delete-account`; on success it tears down the session and routes
/// to sign-in, on failure (e.g. a wrong code) it shows the error with a way
/// back to re-enter the code. Red gradient per design.
class DeletingAccountScreen extends ConsumerStatefulWidget {
  const DeletingAccountScreen({
    required this.otpCode,
    required this.onDone,
    super.key,
  });

  final String otpCode;
  final VoidCallback onDone;

  @override
  ConsumerState<DeletingAccountScreen> createState() =>
      _DeletingAccountScreenState();
}

class _DeletingAccountScreenState extends ConsumerState<DeletingAccountScreen> {
  String? _error;

  @override
  void initState() {
    super.initState();
    unawaited(_run());
  }

  Future<void> _run() async {
    final minShow = Future<void>.delayed(const Duration(milliseconds: 2500));
    try {
      await ref.read(profileRepositoryProvider).deleteAccount(widget.otpCode);
      await ref.read(currentUserProvider.notifier).logout();
      await minShow;
      if (!mounted) return;
      widget.onDone();
    } on ApiException catch (e) {
      if (!mounted) return;
      setState(() => _error = e.message);
    }
  }

  @override
  Widget build(BuildContext context) {
    return AnnotatedRegion<SystemUiOverlayStyle>(
      value: AppSystemUi.light,
      child: DecoratedBox(
        decoration: const BoxDecoration(
          gradient: LinearGradient(
            begin: Alignment.topCenter,
            end: Alignment.bottomCenter,
            colors: [Color(0xFF8A2418), Color(0xFF180A07)],
          ),
        ),
        child: Scaffold(
          backgroundColor: AppColors.transparent,
          body: Center(
            child: Padding(
              padding: const EdgeInsets.symmetric(horizontal: AppSpacing.s6),
              child: Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  SvgPicture.asset(
                    'assets/vectors/Vectors-5.svg',
                    width: 140,
                  ),
                  const SizedBox(height: AppSpacing.s7),
                  Text(
                    _error == null ? 'Deleting account…' : "Couldn't delete",
                    textAlign: TextAlign.center,
                    style: AppText.headingL.copyWith(
                      color: AppColors.textInverse,
                    ),
                  ),
                  if (_error == null) ...[
                    const SizedBox(height: AppSpacing.s7),
                    const SizedBox(
                      width: 28,
                      height: 28,
                      child: CircularProgressIndicator(
                        strokeWidth: 3,
                        color: AppColors.textInverse,
                      ),
                    ),
                  ] else ...[
                    const SizedBox(height: AppSpacing.s3),
                    Text(
                      _error!,
                      textAlign: TextAlign.center,
                      style: AppText.bodyMRegular.copyWith(
                        color: AppColors.textInverse,
                      ),
                    ),
                    const SizedBox(height: AppSpacing.s6),
                    SizedBox(
                      height: 48,
                      child: OutlinedButton(
                        onPressed: () => Navigator.of(context).pop(),
                        style: OutlinedButton.styleFrom(
                          foregroundColor: AppColors.textInverse,
                          side: const BorderSide(color: AppColors.textInverse),
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(AppRadius.md),
                          ),
                        ),
                        child: Text(
                          'Go back',
                          style: AppText.buttonL
                              .copyWith(color: AppColors.textInverse),
                        ),
                      ),
                    ),
                  ],
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}
