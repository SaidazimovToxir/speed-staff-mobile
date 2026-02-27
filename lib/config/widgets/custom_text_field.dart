import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'custom_icon_button.dart';

import 'package:speed_staff_mobile/config/core/constants/constants.dart';

class CustomTextField extends StatefulWidget {
  const CustomTextField({
    super.key,
    this.hintText,
    this.suffixIcon,
    this.prefixIcon,
    this.textInputType = TextInputType.text,
    this.textInputAction = TextInputAction.next,
    this.keyboardType,
    this.obscureText,
    this.controller,
    this.onChanged,
    this.labelText,
    this.maxLines,
    this.inputFormatters,
    this.textAlign,
    this.style,
    this.enabled = true,
    this.focusNode,
    this.onEditingComplete,
    this.validator,
    this.onTap,
    this.borderColor,
    this.title,
    this.fillColor,
    this.hintTextColor,
    this.fontSize,
    this.fontWeight,
    this.maxLength,
    this.contentPadding,
    this.suffix,
  });

  final Widget? prefixIcon;
  final Widget? suffixIcon;
  final String? hintText;
  final String? labelText;
  final String? title;
  final TextInputType textInputType;
  final TextInputType? keyboardType;
  final TextInputAction textInputAction;
  final bool? obscureText;
  final TextEditingController? controller;
  final ValueChanged<String>? onChanged;
  final int? maxLines;
  final List<TextInputFormatter>? inputFormatters;
  final TextAlign? textAlign;
  final TextStyle? style;
  final bool? enabled;
  final FocusNode? focusNode;
  final VoidCallback? onEditingComplete;
  final String? Function(String?)? validator;
  final VoidCallback? onTap;
  final Color? borderColor;
  final Color? fillColor;
  final Color? hintTextColor;
  final double? fontSize;
  final FontWeight? fontWeight;
  final int? maxLength;
  final EdgeInsets? contentPadding;
  final Widget? suffix;

  @override
  State<CustomTextField> createState() => _CustomTextFieldState();
}

class _CustomTextFieldState extends State<CustomTextField> {
  bool _isPasswordVisible = false;
  late bool _shouldObscure;

  @override
  void initState() {
    super.initState();
    _shouldObscure = widget.obscureText ?? (widget.textInputType == TextInputType.visiblePassword || widget.keyboardType == TextInputType.visiblePassword);
  }

  @override
  Widget build(BuildContext context) {
    return TextFormField(
      onTap: widget.onTap,
      focusNode: widget.focusNode,
      validator:
          widget.validator ??
          (value) {
            if (value == null || value.isEmpty) {
              return 'error_empty_field';
            }
            return null;
          },
      onTapOutside: (event) {
        FocusManager.instance.primaryFocus?.unfocus();
      },
      maxLength: widget.maxLength,
      onEditingComplete: widget.onEditingComplete,
      enabled: widget.enabled,
      textAlign: widget.textAlign ?? TextAlign.start,
      inputFormatters: widget.inputFormatters,
      maxLines: widget.maxLines ?? 1,
      onChanged: widget.onChanged,
      controller: widget.controller,
      keyboardType: widget.keyboardType ?? widget.textInputType,
      textInputAction: widget.textInputAction,
      obscureText: _shouldObscure && !_isPasswordVisible,
      style: widget.style ?? const TextStyle(color: AppColors.black, fontSize: 14, fontWeight: FontWeight.w500),
      decoration: InputDecoration(
        filled: true,
        fillColor: widget.fillColor ?? AppColors.white,
        suffixIcon: widget.textInputType == TextInputType.visiblePassword || widget.keyboardType == TextInputType.visiblePassword || widget.obscureText == true
            ? CustomIconButton(
                padding: EdgeInsets.zero,
                icon: Icon(_isPasswordVisible ? Icons.visibility : Icons.visibility_off, color: AppColors.c1F3C88),
                onPressed: () {
                  setState(() {
                    _isPasswordVisible = !_isPasswordVisible;
                  });
                },
              )
            : widget.suffixIcon,
        alignLabelWithHint: true,
        prefixIcon: widget.prefixIcon,
        suffix: widget.suffix,
        hintText: widget.hintText,
        hintStyle: TextStyle(color: widget.hintTextColor ?? AppColors.black, fontSize: widget.fontSize ?? 12, fontWeight: widget.fontWeight ?? FontWeight.w400),
        labelText: widget.labelText,
        labelStyle: TextStyle(color: AppColors.black, fontSize: widget.fontSize ?? 12, fontWeight: widget.fontWeight ?? FontWeight.w400),
        contentPadding: widget.contentPadding ?? EdgeInsets.only(left: 10, right: 6, top: 10, bottom: 10),
        border: _buildBorder(),
        enabledBorder: _buildBorder(),
        focusedBorder: _buildBorder(color: widget.borderColor ?? AppColors.c1F3C88),
        errorBorder: _buildBorder(color: Colors.red),
        focusedErrorBorder: _buildBorder(color: Colors.red),
      ),
    );
  }

  OutlineInputBorder _buildBorder({Color? color}) {
    return OutlineInputBorder(
      borderRadius: BorderRadius.circular(12),
      borderSide: BorderSide(width: 1, color: color ?? widget.borderColor ?? AppColors.black),
    );
  }
}
