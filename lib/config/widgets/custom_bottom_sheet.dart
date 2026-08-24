import 'dart:ui';

import 'package:flutter/material.dart';
import 'package:speed_staff_mobile/config/core/constants/app_colors.dart';
import 'package:speed_staff_mobile/config/widgets/custom_text.dart';


class CustomBottomSheet extends StatelessWidget {
  final Widget child;
  final String? title;
  final TextStyle? titleStyle;
  final double? height;
  final EdgeInsetsGeometry? padding;
  final bool showIndicator;
  final Color? backgroundColor;
  final List<Widget>? actions;

  const CustomBottomSheet({
    super.key,
    required this.child,
    this.title,
    this.titleStyle,
    this.height,
    this.padding,
    this.backgroundColor,
    this.showIndicator = true,
    this.actions,
  });

  static Future<T?> show<T>({
    required BuildContext context,
    required Widget child,
    String? title,
    TextStyle? titleStyle,
    double? height,
    EdgeInsetsGeometry? padding,
    bool showIndicator = true,
    Color? backgroundColor,
    bool isDismissible = true,
    bool enableDrag = true,
    bool isScrollControlled = false,
    List<Widget>? actions,
    BoxConstraints? contraints,
  }) {
    return showModalBottomSheet<T>(
      context: context,
      backgroundColor: Colors.transparent,
      isScrollControlled: isScrollControlled,
      isDismissible: isDismissible,
      enableDrag: enableDrag,
      constraints: contraints,
      builder: (context) => CustomBottomSheet(
        title: title,
        titleStyle: titleStyle,
        height: height,
        padding: padding,
        showIndicator: showIndicator,
        backgroundColor: backgroundColor,
        actions: actions,
        child: child,
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return BackdropFilter(
      filter: ImageFilter.blur(sigmaX: 10, sigmaY: 10),
      child: Container(
        height: height,
        margin: EdgeInsets.only(top: 60),
        decoration: BoxDecoration(
          color: backgroundColor ?? AppColors.c262626,
          borderRadius: BorderRadius.vertical(top: Radius.circular(22)),
        ),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            if (showIndicator) ...[
              SizedBox(height: 8),
              SizedBox(
                width: 38,
                height: 6,
                // decoration: BoxDecoration(color: AppTheme.modalIndicatorColor, borderRadius: BorderRadius.circular(2.r)),
              ),
            ],
            if (title != null || actions != null) SizedBox(height: 24),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                SizedBox(),
                if (title != null)
                  Padding(
                    padding: EdgeInsets.symmetric(horizontal: 16),
                    child: CustomText(text: title!,
                      style: titleStyle ?? Theme.of(context).textTheme.titleMedium?.copyWith(color: Colors.white, fontWeight: FontWeight.w700),
                    ),
                  )
                else
                  SizedBox(),
                if (actions != null) Row(children: [...?actions]) else SizedBox(),
              ],
            ),
            if (title != null || actions != null) SizedBox(height: 8),
            Flexible(
              child: Padding(padding: padding ?? EdgeInsets.all(16), child: child),
            ),
          ],
        ),
      ),
    );
  }
}
