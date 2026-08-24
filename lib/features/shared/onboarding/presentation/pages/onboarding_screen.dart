import 'package:go_router/go_router.dart';
import 'package:flutter/material.dart';
import 'package:speed_staff_mobile/config/config.dart';
import 'package:speed_staff_mobile/features/shared/onboarding/presentation/widgets/language_selector.dart';

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
                      decoration: const BoxDecoration(color: AppColors.cF9A405, shape: BoxShape.circle),
                    ),
                  ),
                  const Positioned(
                    top: 16,
                    left: 24,
                    child: LanguageSelector(),
                  ),
                  Positioned(
                    bottom: 50,
                    left: -50,
                    child: Container(
                      width: 150,
                      height: 150,
                      decoration: BoxDecoration(color: AppColors.cF9A405.withValues(alpha: 0.8), shape: BoxShape.circle),
                    ),
                  ),
                  Center(
                    child: Container(
                      width: 200,
                      height: 200,
                      decoration: BoxDecoration(
                        color: AppColors.white,
                        borderRadius: BorderRadius.circular(24),
                        boxShadow: [BoxShadow(color: Colors.black.withValues(alpha: 0.05), blurRadius: 20, offset: const Offset(0, 10))],
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
                            decoration: BoxDecoration(color: AppColors.cF9A405.withValues(alpha: 0.1), borderRadius: BorderRadius.circular(20)),
                            child: const CustomText(
                              text: "v/senisımo",
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
                    const CustomText(
                      text: "onboarding_title",
                      textAlign: TextAlign.center,
                      style: TextStyle(fontSize: 28, fontWeight: FontWeight.w800, height: 1.2),
                    ),
                    16.g,
                    const CustomText(
                      text: "onboarding_subtitle",
                      textAlign: TextAlign.center,
                      style: TextStyle(fontSize: 16, color: AppColors.c61677D, height: 1.5),
                    ),
                    const Spacer(),
                    PrimaryButton(
                      text: "get_started",
                      onPressed: () {
                        context.push(RouteNames.phoneInputScreen);
                      },
                    ),
                    36.g,
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
