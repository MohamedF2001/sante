// ============================================================
// lib/core/widgets/custom_text_field.dart
// ============================================================

import 'package:flutter/material.dart';

import '../constants/app_colors.dart';

class CustomTextField extends StatefulWidget {
  final String label;
  final String? hint;
  final IconData? prefixIcon;
  final bool obscureText;
  final TextInputType keyboardType;
  final TextEditingController controller;
  final String? Function(String?)? validator;
  final int maxLines;

  const CustomTextField({
    super.key,
    required this.label,
    required this.controller,
    this.hint,
    this.prefixIcon,
    this.obscureText = false,
    this.keyboardType = TextInputType.text,
    this.validator,
    this.maxLines = 1,
  });

  @override
  State<CustomTextField> createState() => _CustomTextFieldState();
}

class _CustomTextFieldState extends State<CustomTextField> {
  bool _hidden = true;

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          widget.label.toUpperCase(),
          style: const TextStyle(
              fontSize: 11,
              fontWeight: FontWeight.w600,
              letterSpacing: 0.5,
              color: AppColors.textSecondary),
        ),
        const SizedBox(height: 6),
        TextFormField(
          controller: widget.controller,
          obscureText: widget.obscureText && _hidden,
          keyboardType: widget.keyboardType,
          validator: widget.validator,
          maxLines: widget.obscureText ? 1 : widget.maxLines,
          decoration: InputDecoration(
            hintText: widget.hint,
            prefixIcon: widget.prefixIcon != null
                ? Icon(widget.prefixIcon,
                size: 20, color: AppColors.textLight)
                : null,
            suffixIcon: widget.obscureText
                ? IconButton(
              icon: Icon(
                  _hidden
                      ? Icons.visibility_off
                      : Icons.visibility,
                  size: 20,
                  color: AppColors.textLight),
              onPressed: () => setState(() => _hidden = !_hidden),
            )
                : null,
          ),
        ),
      ],
    );
  }
}