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

/// Notification preferences: Email + In-app toggles. Loaded through the
/// profile repository (SharedPreferences while mocked) and saved on flip.
class NotificationSettingsScreen extends ConsumerStatefulWidget {
  const NotificationSettingsScreen({super.key});

  @override
  ConsumerState<NotificationSettingsScreen> createState() =>
      _NotificationSettingsScreenState();
}

class _NotificationSettingsScreenState
    extends ConsumerState<NotificationSettingsScreen> {
  NotificationSettings? _settings;
  bool _loading = true;

  @override
  void initState() {
    super.initState();
    unawaited(_load());
  }

  Future<void> _load() async {
    try {
      final settings =
          await ref.read(profileRepositoryProvider).notificationSettings();
      if (!mounted) return;
      setState(() {
        _settings = settings;
        _loading = false;
      });
    } on Object catch (_) {
      if (!mounted) return;
      setState(() => _loading = false);
    }
  }

  Future<void> _onChanged(NotificationSettings next) async {
    setState(() => _settings = next);
    try {
      await ref
          .read(profileRepositoryProvider)
          .updateNotificationSettings(next);
    } on Object catch (_) {
      if (!mounted) return;
      // Revert on failure so the UI never lies about persisted state.
      setState(() => _settings = next.copyWith(
            emailEnabled: !next.emailEnabled,
            inAppEnabled: !next.inAppEnabled,
          ));
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
    final settings = _settings;

    return AnnotatedRegion<SystemUiOverlayStyle>(
      value: AppSystemUi.dark,
      child: Scaffold(
        backgroundColor: AppColors.bgDefault,
        body: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            ProfileTopBar(title: 'Notification', topInset: topInset),
            Expanded(
              child: _loading
                  ? const Center(
                      child: CircularProgressIndicator(
                        color: AppColors.brand,
                      ),
                    )
                  : Column(
                      children: [
                        _ToggleRow(
                          label: 'Email notification',
                          subtext:
                              'Receive email notification to your registered email address',
                          value: settings!.emailEnabled,
                          onChanged: (v) => _onChanged(
                            settings.copyWith(emailEnabled: v),
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
                          value: settings.inAppEnabled,
                          onChanged: (v) => _onChanged(
                            settings.copyWith(inAppEnabled: v),
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
