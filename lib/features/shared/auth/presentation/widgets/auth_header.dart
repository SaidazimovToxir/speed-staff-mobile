import 'package:flutter/material.dart';
import 'package:speed_staff_mobile/config/core/constants/app_colors.dart';
import 'package:speed_staff_mobile/config/core/extensions/size_extension.dart';
import 'package:speed_staff_mobile/config/widgets/custom_text.dart';


class AuthHeader extends StatelessWidget {
  final String title;
  final String subtitle;
  final Widget? topWidget;

  const AuthHeader({
    super.key,
    required this.title,
    required this.subtitle,
    this.topWidget,
  });

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        if (topWidget != null) ...[
          topWidget!,
          24.g,
        ],
        CustomText(text: title,
          style: const TextStyle(
            fontSize: 24,
            fontWeight: FontWeight.w800,
            color: AppColors.black,
          ),
        ),
        8.g,
        CustomText(text: subtitle,
          style: const TextStyle(
            fontSize: 16,
            fontWeight: FontWeight.w400,
            color: AppColors.c61677D,
          ),
        ),
      ],
    );
  }
}
