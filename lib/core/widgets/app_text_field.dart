import 'package:amanah/core/theme/app_colors.dart';
import 'package:amanah/core/theme/app_spacing.dart';
import 'package:amanah/core/theme/app_text_styles.dart';
import 'package:flutter/material.dart';

/// Labelled text field matching the design (label above, rounded input).
/// Set [obscurable] for a password field with an eye toggle.
class AppTextField extends StatefulWidget {
  const AppTextField({
    this.label,
    this.hint,
    this.controller,
    this.validator,
    this.keyboardType,
    this.textInputAction,
    this.obscurable = false,
    this.onFieldSubmitted,
    this.enabled = true,
    this.labelStyle,
    this.bordered = true,
    super.key,
  });

  /// Label rendered above the input. Omit for an unlabelled field (e.g. the
  /// number half of the phone row).
  final String? label;
  final String? hint;
  final TextEditingController? controller;
  final String? Function(String?)? validator;
  final TextInputType? keyboardType;
  final TextInputAction? textInputAction;
  final bool obscurable;
  final ValueChanged<String>? onFieldSubmitted;
  final bool enabled;

  /// Overrides the label typography. Defaults to Body/M/Medium.
  final TextStyle? labelStyle;

  /// Draws the rounded outline + fill. Set false for a borderless, transparent
  /// input (e.g. embedded inside another bordered container like the phone row).
  final bool bordered;

  @override
  State<AppTextField> createState() => _AppTextFieldState();
}

class _AppTextFieldState extends State<AppTextField> {
  late bool _obscured = widget.obscurable;

  static final _noBorder = OutlineInputBorder(
    borderRadius: BorderRadius.circular(AppRadius.md),
    borderSide: BorderSide.none,
  );

  static final _defaultBorder = OutlineInputBorder(
    borderRadius: BorderRadius.circular(AppRadius.md),
    borderSide: BorderSide(color: AppColors.borderDefault),
  );

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        if (widget.label != null) ...[
          Text(
            widget.label!,
            style: (widget.labelStyle ?? AppText.bodyMMedium)
                .copyWith(color: AppColors.textDefault),
          ),
          const SizedBox(height: AppSpacing.s2),
        ],
        TextFormField(
          controller: widget.controller,
          validator: widget.validator,
          keyboardType: widget.keyboardType,
          textInputAction: widget.textInputAction,
          obscureText: _obscured,
          enabled: widget.enabled,
          onFieldSubmitted: widget.onFieldSubmitted,
          style: AppText.bodyLRegular.copyWith(
            color: widget.enabled ? AppColors.textDefault : AppColors.textSubtlest,
          ),
          // Centres the text within the fixed 36pt box, matching AppSearchField.
          textAlignVertical: TextAlignVertical.center,
          decoration: InputDecoration(
            hintText: widget.hint,
            // Borderless variant is transparent; otherwise disabled fields read
            // as a filled grey chip and enabled ones as white, per design.
            filled: widget.bordered,
            fillColor: widget.enabled ? AppColors.bgDefault : AppColors.bgInput,
            border: widget.bordered ? _defaultBorder : _noBorder,
            enabledBorder: widget.bordered ? _defaultBorder : _noBorder,
            focusedBorder: widget.bordered ? null : _noBorder,
            disabledBorder: widget.bordered ? _defaultBorder : _noBorder,
            contentPadding: !widget.bordered
                ? EdgeInsets.zero
                : const EdgeInsets.symmetric(horizontal: AppSpacing.s3),
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
