import 'package:amanah/core/theme/app_colors.dart';
import 'package:amanah/core/theme/app_spacing.dart';
import 'package:amanah/core/theme/app_text_styles.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

/// A row of single-digit boxes for OTP entry. Auto-advances on input,
/// steps back on backspace, and reports the joined code via [onChanged].
class OtpInput extends StatefulWidget {
  const OtpInput({
    required this.onChanged,
    this.length = 6,
    this.onCompleted,
    this.enabled = true,
    super.key,
  });

  final int length;
  final ValueChanged<String> onChanged;
  final ValueChanged<String>? onCompleted;
  final bool enabled;

  @override
  State<OtpInput> createState() => _OtpInputState();
}

class _OtpInputState extends State<OtpInput> {
  late final List<TextEditingController> _controllers;
  late final List<FocusNode> _nodes;

  @override
  void initState() {
    super.initState();
    _controllers = List.generate(widget.length, (_) => TextEditingController());
    _nodes = List.generate(widget.length, (_) => FocusNode());
  }

  @override
  void dispose() {
    for (final c in _controllers) {
      c.dispose();
    }
    for (final n in _nodes) {
      n.dispose();
    }
    super.dispose();
  }

  String get _code => _controllers.map((c) => c.text).join();

  void _onChanged(int i, String value) {
    if (value.length > 1) {
      // Handle paste of the full code.
      final digits = value.replaceAll(RegExp('[^0-9]'), '');
      for (var j = 0; j < widget.length; j++) {
        _controllers[j].text = j < digits.length ? digits[j] : '';
      }
      final next = digits.length.clamp(0, widget.length - 1);
      _nodes[next].requestFocus();
    } else if (value.isNotEmpty && i < widget.length - 1) {
      _nodes[i + 1].requestFocus();
    }
    _emit();
  }

  void _emit() {
    final code = _code;
    widget.onChanged(code);
    if (code.length == widget.length && !code.contains(' ')) {
      widget.onCompleted?.call(code);
    }
  }

  void _onKey(int i, KeyEvent event) {
    if (event is KeyDownEvent &&
        event.logicalKey == LogicalKeyboardKey.backspace &&
        _controllers[i].text.isEmpty &&
        i > 0) {
      _controllers[i - 1].clear();
      _nodes[i - 1].requestFocus();
      _emit();
    }
  }

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        for (var i = 0; i < widget.length; i++) ...[
          if (i > 0) const SizedBox(width: AppSpacing.s3),
          Expanded(child: _box(i)),
        ],
      ],
    );
  }

  Widget _box(int i) {
    return AspectRatio(
      aspectRatio: 0.85,
      child: KeyboardListener(
        focusNode: FocusNode(skipTraversal: true),
        onKeyEvent: (e) => _onKey(i, e),
        child: TextField(
          controller: _controllers[i],
          focusNode: _nodes[i],
          enabled: widget.enabled,
          textAlign: TextAlign.center,
          keyboardType: TextInputType.number,
          style: AppText.headingM,
          maxLength: 1,
          buildCounter: (_, {required currentLength, required isFocused, maxLength}) => null,
          inputFormatters: [FilteringTextInputFormatter.digitsOnly],
          onChanged: (v) => _onChanged(i, v),
          decoration: InputDecoration(
            contentPadding: EdgeInsets.zero,
            enabledBorder: _border(AppColors.borderDefault),
            focusedBorder: _border(AppColors.borderFocus, width: 1.5),
          ),
        ),
      ),
    );
  }

  OutlineInputBorder _border(Color color, {double width = 1}) {
    return OutlineInputBorder(
      borderRadius: BorderRadius.circular(AppRadius.md),
      borderSide: BorderSide(color: color, width: width),
    );
  }
}
