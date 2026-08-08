import 'dart:async';

import 'package:amanah/core/theme/app_colors.dart';
import 'package:amanah/core/theme/app_spacing.dart';
import 'package:amanah/core/theme/app_text_styles.dart';
import 'package:amanah/features/auth/presentation/providers/session_providers.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

/// Transitional "Signing out…" screen. Clears the session, then routes to
/// sign-in. Blue gradient per design.
class SigningOutScreen extends ConsumerStatefulWidget {
  const SigningOutScreen({required this.onDone, super.key});

  final VoidCallback onDone;

  @override
  ConsumerState<SigningOutScreen> createState() => _SigningOutScreenState();
}

class _SigningOutScreenState extends ConsumerState<SigningOutScreen> {
  @override
  void initState() {
    super.initState();
    unawaited(_run());
  }

  Future<void> _run() async {
    final minShow = Future<void>.delayed(const Duration(milliseconds: 3000));
    await ref.read(currentUserProvider.notifier).logout();
    await minShow;
    if (!mounted) return;
    widget.onDone();
  }

  @override
  Widget build(BuildContext context) {
    return DecoratedBox(
      decoration: const BoxDecoration(
        gradient: LinearGradient(
          begin: Alignment.topCenter,
          end: Alignment.bottomCenter,
          colors: [Color(0xFF2B57C4), Color(0xFF0A2472)],
        ),
      ),
      child: Scaffold(
        backgroundColor: Colors.transparent,
        body: Center(
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              Text(
                'Signing out…',
                style: AppText.headingL.copyWith(color: AppColors.textInverse),
              ),
              const SizedBox(height: AppSpacing.s7),
              const SizedBox(
                width: 28,
                height: 28,
                child: CircularProgressIndicator(
                  strokeWidth: 3,
                  color: AppColors.textInverse,
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
