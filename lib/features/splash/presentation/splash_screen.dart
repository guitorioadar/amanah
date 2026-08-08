import 'dart:async';

import 'package:amanah/core/theme/app_colors.dart';
import 'package:amanah/features/auth/presentation/providers/session_providers.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_svg/flutter_svg.dart';

/// Splash: brand logo centered, held briefly, then routes based on whether a
/// session token exists — signed-in users land on the dashboard, others on
/// sign-in. Rehydrates the cached user before routing.
class SplashScreen extends ConsumerStatefulWidget {
  const SplashScreen({required this.onSignedIn, required this.onSignedOut, super.key});

  final VoidCallback onSignedIn;
  final VoidCallback onSignedOut;

  @override
  ConsumerState<SplashScreen> createState() => _SplashScreenState();
}

class _SplashScreenState extends ConsumerState<SplashScreen> {
  bool _finished = false;

  @override
  void initState() {
    super.initState();
    unawaited(_decide());
  }

  Future<void> _decide() async {
    final hold = Future<void>.delayed(const Duration(milliseconds: 2000));
    final signedIn = await ref.read(currentUserProvider.notifier).restore();
    await hold; // guarantee the logo shows for the full hold
    if (_finished || !mounted) return;
    _finished = true;
    signedIn ? widget.onSignedIn() : widget.onSignedOut();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.bgDefault,
      body: Center(
        child: SvgPicture.asset('assets/images/logo.svg', width: 96),
      ),
    );
  }
}
