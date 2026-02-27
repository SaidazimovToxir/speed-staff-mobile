import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:speed_staff_mobile/config/config.dart';

class SocialLoginButtons extends StatelessWidget {
  const SocialLoginButtons({super.key});

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        PrimaryButton(
          text: "Continue with Phone",
          onPressed: () {
            context.push(RouteNames.phoneInputScreen);
          },
        ),
        16.g,
        PrimaryButton(
          text: "Continue with Google",
          color: AppColors.black,
          textColor: AppColors.white,
          onPressed: () {},
          icon: const Icon(Icons.g_mobiledata, color: AppColors.white, size: 32),
        ),
      ],
    );
  }
}
