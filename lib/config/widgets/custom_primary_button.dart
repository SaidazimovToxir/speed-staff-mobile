import 'package:flutter/material.dart';
import 'package:speed_staff_mobile/config/widgets/custom_image_view.dart';
import 'package:speed_staff_mobile/config/widgets/custom_text.dart';

import '../core/extensions/size_extension.dart';

class CustomPrimaryButton extends StatelessWidget {
  final String? title;
  final double height;
  final Color? buttonColor;
  final Color? titleColor;
  final double fontSize;
  final Function()? onTap;
  final double? borderRadius;
  final bool isLoading;
  final String? icon;
  final FontWeight? fontWeight;
  final double? iconSize;
  final Color? iconColor;
  const CustomPrimaryButton({
    super.key,
    this.title,
    this.height = 44,
    this.icon,
    // this.buttonColor = AppColors.c283891,
    this.buttonColor = Colors.white,
    this.titleColor = Colors.black,
    this.fontSize = 14,
    this.onTap,
    this.borderRadius = 10,
    this.isLoading = false,
    this.fontWeight = FontWeight.w500,
    this.iconSize = 24,
    this.iconColor,
  });

  @override
  Widget build(BuildContext context) {
    return IntrinsicWidth(
      child: SizedBox(
        height: height,
        child: ElevatedButton(
          onPressed: isLoading ? null : onTap,
          style: ElevatedButton.styleFrom(
            backgroundColor: isLoading ? Colors.white : buttonColor,
            padding: const EdgeInsets.symmetric(horizontal: 16),
            shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(borderRadius ?? 10)),
            elevation: 0,
          ),
          child: isLoading
              ? SizedBox(
                  height: 20,
                  width: 20,
                  child: const Center(child: CircularProgressIndicator(color: Colors.white, strokeWidth: 2)),
                )
              : Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    if (icon != null) CustomImageView(imagePath: icon!, height: iconSize, width: iconSize, color: iconColor),
                    6.g,
                    Expanded(
                      flex: 0,
                      child: CustomText(text: title!, color: titleColor, fontSize: fontSize, fontWeight: fontWeight),
                    ),
                  ],
                ),
        ),
      ),
    );
  }
}
