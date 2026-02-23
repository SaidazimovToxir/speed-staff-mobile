import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

import 'custom_text.dart';

class CustomButton extends StatelessWidget {
  const CustomButton({
    super.key,
    this.onTap,
    required this.color,
    required this.textColor,
    required this.title,
    this.radius = 100,
    this.borderColor,
    this.padding,
    this.isLoading = false,
    this.fontSize,
    this.fontWeight,
  });

  final VoidCallback? onTap;
  final Color color;
  final Color textColor;
  final String title;
  final double? fontSize;
  final FontWeight? fontWeight;
  final bool isLoading;
  final double radius;
  final Color? borderColor;

  final EdgeInsets? padding;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: padding == null ? EdgeInsets.zero : padding!,
      child: ElevatedButton(
        onPressed: onTap,
        style: ElevatedButton.styleFrom(
          backgroundColor: color,
          visualDensity: VisualDensity.compact,
          padding: EdgeInsets.symmetric(vertical: isLoading ? 10 : 20, horizontal: 28),
          maximumSize: Size.infinite,
          minimumSize: Size.fromHeight(MediaQuery.of(context).size.height * 0.07),
          shape: RoundedRectangleBorder(
            side: BorderSide(color: borderColor ?? Colors.transparent),
            borderRadius: BorderRadius.circular(radius),
          ),
        ),
        child: isLoading
            ? const CircularProgressIndicator.adaptive(valueColor: AlwaysStoppedAnimation<Color>(CupertinoColors.white), strokeAlign: -2)
            : CustomText(
                text: title,
                fontSize: fontSize ?? 16,
                fontWeight: fontWeight ?? FontWeight.w600,
                color: textColor,
                textAlign: TextAlign.center,
                overflow: TextOverflow.ellipsis,
                maxLines: 1,
              ),
      ),
    );
  }
}
