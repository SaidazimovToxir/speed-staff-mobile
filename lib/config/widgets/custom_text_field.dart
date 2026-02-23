import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

import '../core/constants/constants.dart';

class GlobalTextField extends StatefulWidget {
  const GlobalTextField({
    super.key,
    this.hintText,
    this.suffixIcon,
    this.prefixIcon,
    required this.textInputType,
    required this.textInputAction,
    this.controller,
    this.onChanged,
    this.labelText,
    this.maxLine,
    this.formatter,
    this.textAlign,
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
  final TextInputAction textInputAction;
  final TextEditingController? controller;
  final ValueChanged<String>? onChanged;
  final int? maxLine;
  final List<TextInputFormatter>? formatter;
  final TextAlign? textAlign;
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
  State<GlobalTextField> createState() => _GlobalTextFieldState();
}

class _GlobalTextFieldState extends State<GlobalTextField> {
  bool _isPasswordVisible = false;

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
      inputFormatters: widget.formatter,
      maxLines: widget.maxLine ?? 1,
      onChanged: widget.onChanged,
      controller: widget.controller,
      keyboardType: widget.textInputType,
      textInputAction: widget.textInputAction,
      obscureText: widget.textInputType == TextInputType.visiblePassword && !_isPasswordVisible,
      style: TextStyle(color: AppColors.white, fontSize: 14, fontWeight: FontWeight.w500),
      decoration: InputDecoration(
        filled: true,
        fillColor: widget.fillColor ?? AppColors.white,
        suffixIcon: widget.textInputType == TextInputType.visiblePassword
            ? IconButton(
                splashRadius: 1,
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
