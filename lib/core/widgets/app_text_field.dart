import 'package:amanah/core/theme/app_colors.dart';
import 'package:amanah/core/theme/app_spacing.dart';
import 'package:amanah/core/theme/app_text_styles.dart';
import 'package:flutter/material.dart';

/// Labelled text field matching the design (label above, rounded input).
/// Set [obscurable] for a password field with an eye toggle.
class AppTextField extends StatefulWidget {
  const AppTextField({
    required this.label,
    this.hint,
    this.controller,
    this.validator,
    this.keyboardType,
    this.textInputAction,
    this.obscurable = false,
    this.onFieldSubmitted,
    this.enabled = true,
    super.key,
  });

  final String label;
  final String? hint;
  final TextEditingController? controller;
  final String? Function(String?)? validator;
  final TextInputType? keyboardType;
  final TextInputAction? textInputAction;
  final bool obscurable;
  final ValueChanged<String>? onFieldSubmitted;
  final bool enabled;

  @override
  State<AppTextField> createState() => _AppTextFieldState();
}

class _AppTextFieldState extends State<AppTextField> {
  late bool _obscured = widget.obscurable;

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          widget.label,
          style: AppText.bodyMMedium.copyWith(color: AppColors.textDefault),
        ),
        const SizedBox(height: AppSpacing.s2),
        TextFormField(
          controller: widget.controller,
          validator: widget.validator,
          keyboardType: widget.keyboardType,
          textInputAction: widget.textInputAction,
          obscureText: _obscured,
          enabled: widget.enabled,
          onFieldSubmitted: widget.onFieldSubmitted,
          style: AppText.bodyLRegular,
          decoration: InputDecoration(
            hintText: widget.hint,
            // Design ships only an eye-slash asset (no plain eye), so the
            // toggle uses the Material visibility pair for a clear two-state.
            suffixIcon: widget.obscurable
                ? IconButton(
                    onPressed: () => setState(() => _obscured = !_obscured),
                    icon: Icon(
                      _obscured
                          ? Icons.visibility_off_outlined
                          : Icons.visibility_outlined,
                      color: AppColors.iconSubtle,
                      size: 22,
                    ),
                  )
                : null,
          ),
        ),
      ],
    );
  }
}
