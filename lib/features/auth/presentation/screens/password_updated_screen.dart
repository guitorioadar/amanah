import 'package:amanah/core/theme/app_colors.dart';
import 'package:amanah/core/theme/app_spacing.dart';
import 'package:amanah/core/theme/app_text_styles.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:go_router/go_router.dart';

/// Success screen after a password reset. Shows the rocket illustration and
/// auto-redirects to the dashboard.
class PasswordUpdatedScreen extends StatefulWidget {
  const PasswordUpdatedScreen({super.key});

  @override
  State<PasswordUpdatedScreen> createState() => _PasswordUpdatedScreenState();
}

class _PasswordUpdatedScreenState extends State<PasswordUpdatedScreen> {
  bool _done = false;

  @override
  void initState() {
    super.initState();
    Future.delayed(const Duration(milliseconds: 2500), () {
      if (_done || !mounted) return;
      _done = true;
      context.go('/home');
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: DecoratedBox(
        decoration: const BoxDecoration(
          gradient: LinearGradient(
            begin: Alignment.topCenter,
            end: Alignment.bottomCenter,
            colors: [Color(0xFF2D50E0), Color(0xFF122A66)],
          ),
        ),
        child: SafeArea(
          child: Padding(
            padding: const EdgeInsets.symmetric(horizontal: AppSpacing.s6),
            child: Center(
              child: Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  SvgPicture.asset('assets/vectors/Vectors.svg', width: 120),
                  const SizedBox(height: AppSpacing.s6),
                  Text(
                    'Password updated!',
                    style: AppText.headingXl
                        .copyWith(color: AppColors.textInverse),
                  ),
                  const SizedBox(height: AppSpacing.s3),
                  Text(
                    'Successfully updated your password.\n'
                    'Redirecting to your dashboard.',
                    textAlign: TextAlign.center,
                    style: AppText.bodyLRegular.copyWith(
                      color: AppColors.textInverse.withValues(alpha: 0.8),
                    ),
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
        ),
      ),
    );
  }
}
