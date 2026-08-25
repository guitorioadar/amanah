import 'dart:async';

import 'package:amanah/core/theme/app_colors.dart';
import 'package:amanah/core/theme/app_spacing.dart';
import 'package:amanah/core/theme/app_system_ui.dart';
import 'package:amanah/core/theme/app_text_styles.dart';
import 'package:amanah/features/profile/data/profile_repository.dart';
import 'package:amanah/features/profile/presentation/providers/profile_providers.dart';
import 'package:amanah/features/profile/presentation/widgets/profile_top_bar.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

/// Notification preferences: Email + In-app toggles. The settings are warmed
/// into [notificationSettingsProvider] at login / cold-start, so this screen
/// reads them from cache and renders instantly. A missing cache (rare) is
/// refetched here as a fallback.
class NotificationSettingsScreen extends ConsumerStatefulWidget {
  const NotificationSettingsScreen({super.key});

  @override
  ConsumerState<NotificationSettingsScreen> createState() =>
      _NotificationSettingsScreenState();
}

class _NotificationSettingsScreenState
    extends ConsumerState<NotificationSettingsScreen> {
  @override
  void initState() {
    super.initState();
    // Fallback: fetch if the preload never ran (e.g. deep-link cold path).
    if (ref.read(notificationSettingsProvider) == null) {
      unawaited(ref.read(notificationSettingsProvider.notifier).load());
    }
  }

  Future<void> _onChanged(NotificationSettings next) async {
    try {
      await ref.read(notificationSettingsProvider.notifier).update(next);
    } on Object catch (_) {
      if (!mounted) return;
      // The notifier already reverted its state; just surface the failure.
      ScaffoldMessenger.of(context)
        ..hideCurrentSnackBar()
        ..showSnackBar(
          const SnackBar(content: Text("Couldn't save preference")),
        );
    }
  }

  @override
  Widget build(BuildContext context) {
    final topInset = MediaQuery.of(context).viewPadding.top;
    final settings = ref.watch(notificationSettingsProvider);

    return AnnotatedRegion<SystemUiOverlayStyle>(
      value: AppSystemUi.dark,
      child: Scaffold(
        backgroundColor: AppColors.bgDefault,
        body: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            const SizedBox(height: AppSpacing.s2),
            ProfileTopBar(title: 'Notification', topInset: topInset),
            Expanded(
              child: settings == null
                  ? const Center(
                      child: CircularProgressIndicator(color: AppColors.brand),
                    )
                  : Column(
                      children: [
                        _ToggleRow(
                          label: 'Email notification',
                          subtext:
                              'Receive email notification to your registered email address',
                          value: settings.emailNotification,
                          onChanged: (v) => _onChanged(
                            settings.copyWith(emailNotification: v),
                          ),
                        ),
                        Divider(
                          height: 1,
                          color: AppColors.borderDefault,
                        ),
                        _ToggleRow(
                          label: 'In-app notification',
                          subtext:
                              'Receive a notification on screen regardless of which page you are on',
                          value: settings.pushNotification,
                          onChanged: (v) => _onChanged(
                            settings.copyWith(pushNotification: v),
                          ),
                        ),
                      ],
                    ),
            ),
          ],
        ),
      ),
    );
  }
}

class _ToggleRow extends StatelessWidget {
  const _ToggleRow({
    required this.label,
    required this.subtext,
    required this.value,
    required this.onChanged,
  });

  final String label;
  final String subtext;
  final bool value;
  final ValueChanged<bool> onChanged;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(
        horizontal: AppSpacing.s4,
        vertical: AppSpacing.s4,
      ),
      child: Row(
        children: [
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  label,
                  style:
                      AppText.headingS.copyWith(color: AppColors.textDefault),
                ),
                const SizedBox(height: AppSpacing.s1),
                Text(
                  subtext,
                  style: AppText.bodyMRegular
                      .copyWith(color: AppColors.textSubtle),
                ),
              ],
            ),
          ),
          const SizedBox(width: AppSpacing.s4),
          Switch(
            value: value,
            onChanged: onChanged,
            // Design uses a green "on" track (not brand blue).
            activeTrackColor: AppColors.iconSuccess,
            activeThumbColor: AppColors.bgDefault,
          ),
        ],
      ),
    );
  }
}
