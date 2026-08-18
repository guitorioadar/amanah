import 'package:amanah/core/theme/app_colors.dart';
import 'package:amanah/core/theme/app_spacing.dart';
import 'package:amanah/core/theme/app_text_styles.dart';
import 'package:flutter/material.dart';

/// Rounded search box used by the Home upcoming list and the Audits tabs.
/// Backs a server-side keyword search; the parent debounces [onChanged].
class AppSearchField extends StatelessWidget {
  const AppSearchField({
    required this.controller,
    required this.onChanged,
    this.hintText = 'Search audits',
    super.key,
  });

  final TextEditingController controller;
  final ValueChanged<String> onChanged;
  final String hintText;

  void _clear() {
    controller.clear();
    onChanged('');
  }

  @override
  Widget build(BuildContext context) {
    return ValueListenableBuilder<TextEditingValue>(
      valueListenable: controller,
      builder: (context, value, _) {
        final hasText = value.text.isNotEmpty;
        return TextField(
          controller: controller,
          onChanged: onChanged,
          style: AppText.bodyLRegular,
          decoration: InputDecoration(
            hintText: hintText,
            hintStyle:
                AppText.bodyLRegular.copyWith(color: AppColors.textSubtlest),
            prefixIcon: const Icon(
              Icons.search,
              size: 20,
              color: AppColors.iconSubtle,
            ),
            prefixIconConstraints:
                const BoxConstraints(minWidth: 40, minHeight: 36),
            suffixIcon: hasText
                ? GestureDetector(
                    onTap: _clear,
                    behavior: HitTestBehavior.opaque,
                    child: const Icon(
                      Icons.close,
                      size: 20,
                      color: AppColors.iconSubtle,
                    ),
                  )
                : null,
            suffixIconConstraints:
                const BoxConstraints(minWidth: 40, minHeight: 36),
            filled: true,
            fillColor: AppColors.bgDefault,
            isDense: true,
            // Fixed 36pt field height per design.
            constraints: const BoxConstraints.tightFor(height: 36),
            contentPadding:
                const EdgeInsets.symmetric(horizontal: AppSpacing.s3),
            border: OutlineInputBorder(
              borderRadius: BorderRadius.circular(AppRadius.md),
              borderSide: BorderSide(color: AppColors.borderDefault),
            ),
            enabledBorder: OutlineInputBorder(
              borderRadius: BorderRadius.circular(AppRadius.md),
              borderSide: BorderSide(color: AppColors.borderDefault),
            ),
            focusedBorder: OutlineInputBorder(
              borderRadius: BorderRadius.circular(AppRadius.md),
              borderSide: const BorderSide(color: AppColors.borderFocus),
            ),
          ),
        );
      },
    );
  }
}
