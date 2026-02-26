import 'package:go_router/go_router.dart';
import 'package:flutter/material.dart';
import '../../../../config/core/constants/app_colors.dart';
import '../../../../config/core/widgets/primary_button.dart';
import 'package:speed_staff_mobile/config/core/extensions/size_extension.dart';

class OnboardingScreen extends StatelessWidget {
  const OnboardingScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.white,
      body: SafeArea(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            Expanded(
              flex: 3,
              child: Stack(
                children: [
                  Positioned(
                    top: -50,
                    right: -50,
                    child: Container(
                      width: 200,
                      height: 200,
                      decoration: const BoxDecoration(
                        color: AppColors.cF9A405,
                        shape: BoxShape.circle,
                      ),
                    ),
                  ),
                  Positioned(
                    bottom: 50,
                    left: -50,
                    child: Container(
                      width: 150,
                      height: 150,
                      decoration: BoxDecoration(
                        color: AppColors.cF9A405.withOpacity(0.8),
                        shape: BoxShape.circle,
                      ),
                    ),
                  ),
                  Center(
                    child: Container(
                      width: 200,
                      height: 200,
                      decoration: BoxDecoration(
                        color: AppColors.white,
                        borderRadius: BorderRadius.circular(24),
                        boxShadow: [
                          BoxShadow(
                            color: Colors.black.withOpacity(0.05),
                            blurRadius: 20,
                            offset: const Offset(0, 10),
                          ),
                        ],
                      ),
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Container(
                            padding: const EdgeInsets.all(16),
                            decoration: BoxDecoration(
                              shape: BoxShape.circle,
                              border: Border.all(color: AppColors.cF9A405, width: 2),
                            ),
                            child: const Icon(Icons.person_outline, size: 48, color: AppColors.cF9A405),
                          ),
                          16.g,
                          Container(
                            padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
                            decoration: BoxDecoration(
                              color: AppColors.cF9A405.withOpacity(0.1),
                              borderRadius: BorderRadius.circular(20),
                            ),
                            child: const Text(
                              "v/senisımo",
                              style: TextStyle(fontWeight: FontWeight.bold, color: AppColors.cF9A405),
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),
                ],
              ),
            ),
            Expanded(
              flex: 2,
              child: Padding(
                padding: const EdgeInsets.all(24.0),
                child: Column(
                  children: [
                    const Text(
                      "Get hired at top\nrestaurants in minutes",
                      textAlign: TextAlign.center,
                      style: TextStyle(
                        fontSize: 28,
                        fontWeight: FontWeight.w800,
                        height: 1.2,
                      ),
                    ),
                    16.g,
                    const Text(
                      "Create your profile once. Apply to\nmultiple restaurants. Get called the\nsame day.",
                      textAlign: TextAlign.center,
                      style: TextStyle(
                        fontSize: 16,
                        color: AppColors.c61677D,
                        height: 1.5,
                      ),
                    ),
                    const Spacer(),
                    PrimaryButton(
                      text: "Get Started →",
                      onPressed: () {
                        context.push('/phone_input_screen');
                      },
                    ),
                    16.g,
                    Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        const Text(
                          "Already have an account? ",
                          style: TextStyle(color: AppColors.c61677D),
                        ),
                        GestureDetector(
                          onTap: () {
                            Navigator.of(context).pushNamed('/sign_in_screen');
                          },
                          child: const Text(
                            "Sign In",
                            style: TextStyle(
                              color: AppColors.cF9A405,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                        ),
                      ],
                    ),
                    16.g,
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
