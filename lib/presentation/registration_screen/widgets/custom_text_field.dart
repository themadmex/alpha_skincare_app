import 'package:flutter/material.dart';
import 'package:sizer/sizer.dart';
import 'package:google_fonts/google_fonts.dart';

import '../../../core/app_export.dart';

class CustomTextField extends StatefulWidget {
  final String label;
  final String hint;
  final TextEditingController controller;
  final TextInputType keyboardType;
  final bool isPassword;
  final bool isConfirmPassword;
  final String? Function(String?)? validator;
  final ValueChanged<String>? onChanged;
  final String? confirmPasswordValue;
  final bool showValidationIcon;

  const CustomTextField({
    super.key,
    required this.label,
    required this.hint,
    required this.controller,
    this.keyboardType = TextInputType.text,
    this.isPassword = false,
    this.isConfirmPassword = false,
    this.validator,
    this.onChanged,
    this.confirmPasswordValue,
    this.showValidationIcon = false,
  });

  @override
  State<CustomTextField> createState() => _CustomTextFieldState();
}

class _CustomTextFieldState extends State<CustomTextField> {
  bool _obscureText = true;
  bool _isValid = false;

  @override
  void initState() {
    super.initState();
    widget.controller.addListener(_validateField);
  }

  @override
  void dispose() {
    widget.controller.removeListener(_validateField);
    super.dispose();
  }

  void _validateField() {
    if (widget.showValidationIcon) {
      final isValid = _checkFieldValidity();
      if (isValid != _isValid) {
        setState(() {
          _isValid = isValid;
        });
      }
    }
  }

  bool _checkFieldValidity() {
    final value = widget.controller.text;

    if (widget.keyboardType == TextInputType.emailAddress) {
      return RegExp(r'^[\w-\.]+@([\w-]+\.)+[\w-]{2,4}$').hasMatch(value);
    }

    if (widget.isPassword) {
      return value.length >= 8 &&
          value.contains(RegExp(r'[A-Z]')) &&
          value.contains(RegExp(r'[a-z]')) &&
          value.contains(RegExp(r'[0-9]'));
    }

    if (widget.isConfirmPassword && widget.confirmPasswordValue != null) {
      return value == widget.confirmPasswordValue && value.isNotEmpty;
    }

    return value.isNotEmpty;
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          widget.label,
          style: GoogleFonts.inter(
            fontSize: 14.sp,
            fontWeight: FontWeight.w500,
            color: AppTheme.onSurfaceLight,
          ),
        ),
        SizedBox(height: 1.h),
        TextFormField(
          controller: widget.controller,
          keyboardType: widget.keyboardType,
          obscureText: widget.isPassword ? _obscureText : false,
          onChanged: widget.onChanged,
          validator: widget.validator,
          style: GoogleFonts.inter(
            fontSize: 16.sp,
            fontWeight: FontWeight.w400,
            color: AppTheme.onSurfaceLight,
          ),
          decoration: InputDecoration(
            hintText: widget.hint,
            hintStyle: GoogleFonts.inter(
              fontSize: 16.sp,
              fontWeight: FontWeight.w400,
              color: AppTheme.neutralLight.withValues(alpha: 0.7),
            ),
            fillColor: AppTheme.backgroundLight,
            filled: true,
            contentPadding:
                EdgeInsets.symmetric(horizontal: 4.w, vertical: 2.h),
            border: OutlineInputBorder(
              borderRadius: BorderRadius.circular(AppTheme.mediumRadius),
              borderSide: BorderSide(color: AppTheme.borderLight, width: 1),
            ),
            enabledBorder: OutlineInputBorder(
              borderRadius: BorderRadius.circular(AppTheme.mediumRadius),
              borderSide: BorderSide(color: AppTheme.borderLight, width: 1),
            ),
            focusedBorder: OutlineInputBorder(
              borderRadius: BorderRadius.circular(AppTheme.mediumRadius),
              borderSide: BorderSide(color: AppTheme.primaryLight, width: 2),
            ),
            errorBorder: OutlineInputBorder(
              borderRadius: BorderRadius.circular(AppTheme.mediumRadius),
              borderSide: BorderSide(color: AppTheme.errorLight, width: 1),
            ),
            focusedErrorBorder: OutlineInputBorder(
              borderRadius: BorderRadius.circular(AppTheme.mediumRadius),
              borderSide: BorderSide(color: AppTheme.errorLight, width: 2),
            ),
            suffixIcon: widget.isPassword
                ? IconButton(
                    icon: CustomIconWidget(
                      iconName: _obscureText ? 'visibility' : 'visibility_off',
                      color: AppTheme.neutralLight,
                      size: 5.w,
                    ),
                    onPressed: () {
                      setState(() {
                        _obscureText = !_obscureText;
                      });
                    },
                  )
                : widget.showValidationIcon && widget.controller.text.isNotEmpty
                    ? CustomIconWidget(
                        iconName: _isValid ? 'check_circle' : 'error',
                        color: _isValid
                            ? AppTheme.successColor
                            : AppTheme.errorLight,
                        size: 5.w,
                      )
                    : null,
          ),
        ),
      ],
    );
  }
}