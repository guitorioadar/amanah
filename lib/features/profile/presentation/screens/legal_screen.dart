import 'package:amanah/core/theme/app_colors.dart';
import 'package:amanah/core/theme/app_spacing.dart';
import 'package:amanah/core/theme/app_system_ui.dart';
import 'package:amanah/core/theme/app_text_styles.dart';
import 'package:amanah/features/profile/presentation/widgets/profile_top_bar.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_svg/flutter_svg.dart';

/// One heading + body block within a legal document.
typedef _Section = ({String heading, String body});

/// Static legal content page. Used for Privacy policy and Terms & conditions:
/// a tinted hero (title + "Last updated" chip) over structured sections. The
/// copy arrives with the real documents — placeholders below.
class LegalScreen extends StatelessWidget {
  const LegalScreen.privacy({super.key})
      : title = 'Privacy policy',
        heroTitle = 'Privacy Policy',
        heroColor = AppColors.bgSuccess,
        updated = 'Last updated on 12 Apr 2025',
        _sections = _privacySections;

  const LegalScreen.terms({super.key})
      : title = 'Terms & conditions',
        heroTitle = 'Terms & conditions',
        heroColor = AppColors.bgDanger,
        updated = 'Last updated on 12 Apr 2025',
        _sections = _termsSections;

  final String title;
  final String heroTitle;
  final Color heroColor;
  final String updated;
  final List<_Section> _sections;

  static const _privacySections = <_Section>[
    (
      heading: 'Information We Collect',
      body:
          'We collect the account information you provide — your name, email '
          'address, phone number, and role — so we can authenticate you and '
          'manage your auditor profile.\n\n'
          'We also store the audit data you capture in the app: submissions, '
          'observations, photos, and videos. Device information such as the app '
          'version and crash diagnostics is collected to keep the app reliable.',
    ),
    (
      heading: 'Location Data',
      body:
          'When you attach a location to an audit, we store the coordinates and '
          'address you select so the record reflects where the audit took '
          'place. Location is captured only when you add it to a submission; '
          'the app does not track your location in the background.',
    ),
    (
      heading: 'How We Use Information',
      body:
          'Your information is used to authenticate you, to sync audit '
          "submissions with your organization's workspace, and to send the "
          'service notifications you have enabled in Settings. We do not sell '
          "your data. Audit data is shared only with your organization's "
          'administrators as needed for certification workflows.',
    ),
    (
      heading: 'Data Retention',
      body:
          'Account data is retained while your account is active. Deleting your '
          'account removes your personal data; audit records may be retained '
          'where required by certification rules. Questions about this policy '
          'can be sent to your organization administrator.',
    ),
  ];

  static const _termsSections = <_Section>[
    (
      heading: 'Eligibility',
      body:
          'The ISNA Halal Amanah app is provided to authorized auditors for '
          'halal certification audit work. You may use the app only under an '
          'account issued by your organization, and you are responsible for '
          'keeping your credentials confidential and for all activity under '
          'your account.',
    ),
    (
      heading: 'Use of the App',
      body:
          'You agree to submit accurate audit information and media. Photos, '
          'videos, and observations you submit become part of the audit record '
          'and may be reviewed by your organization. Misuse of the app or '
          'submission of false information may result in your access being '
          'revoked.',
    ),
    (
      heading: 'Availability',
      body:
          'We aim for reliable availability but do not guarantee uninterrupted '
          'service. Scheduled maintenance may cause brief outages, and features '
          'may change as the app evolves.',
    ),
    (
      heading: 'Changes',
      body:
          'These terms may be updated; material changes will be announced in '
          'the app. Continued use after an update means you accept the revised '
          'terms.',
    ),
  ];

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
            ProfileTopBar(title: title, topInset: topInset),
            Expanded(
              child: SingleChildScrollView(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.stretch,
                  children: [
                    _Hero(
                      title: heroTitle,
                      color: heroColor,
                      updated: updated,
                    ),
                    Padding(
                      padding: const EdgeInsets.all(AppSpacing.s4),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.stretch,
                        children: [
                          for (var i = 0; i < _sections.length; i++) ...[
                            _SectionBlock(section: _sections[i]),
                            if (i != _sections.length - 1) ...[
                              const SizedBox(height: AppSpacing.s5),
                              Divider(height: 1, color: AppColors.borderDefault),
                              const SizedBox(height: AppSpacing.s5),
                            ],
                          ],
                          SizedBox(
                            height: AppSpacing.s6 +
                                MediaQuery.of(context).viewPadding.bottom,
                          ),
                        ],
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

/// Tinted banner: large document title + a white "Last updated" chip.
class _Hero extends StatelessWidget {
  const _Hero({
    required this.title,
    required this.color,
    required this.updated,
  });

  final String title;
  final Color color;
  final String updated;

  @override
  Widget build(BuildContext context) {
    return Container(
      width: double.infinity,
      color: color,
      padding: const EdgeInsets.all(AppSpacing.s4),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            title,
            style: AppText.headingL.copyWith(color: AppColors.textDefault),
          ),
          const SizedBox(height: AppSpacing.s3),
          Container(
            padding: const EdgeInsets.symmetric(
              horizontal: AppSpacing.s3,
              vertical: AppSpacing.s2,
            ),
            decoration: BoxDecoration(
              color: AppColors.bgDefault,
              borderRadius: BorderRadius.circular(AppRadius.md),
            ),
            child: Row(
              mainAxisSize: MainAxisSize.min,
              children: [
                SvgPicture.asset(
                  'assets/icons/fill/CalendarCheck.svg',
                  width: 18,
                  colorFilter: const ColorFilter.mode(
                    AppColors.iconDefault,
                    BlendMode.srcIn,
                  ),
                ),
                const SizedBox(width: AppSpacing.s2),
                Text(
                  updated,
                  style: AppText.bodyMMedium
                      .copyWith(color: AppColors.textDefault),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}

/// One section: bold heading over its body copy.
class _SectionBlock extends StatelessWidget {
  const _SectionBlock({required this.section});

  final _Section section;

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          section.heading,
          style: AppText.headingS.copyWith(color: AppColors.textDefault),
        ),
        const SizedBox(height: AppSpacing.s3),
        Text(
          section.body,
          style: AppText.bodyMRegular.copyWith(color: AppColors.textSubtle),
        ),
      ],
    );
  }
}
