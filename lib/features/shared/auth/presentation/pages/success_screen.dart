import 'package:flutter/material.dart';
import 'package:speed_staff_mobile/config/config.dart';

class SuccessScreen extends StatelessWidget {
  const SuccessScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.white,
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.all(24.0),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              const Spacer(),
              Center(
                child: Container(
                  padding: const EdgeInsets.all(16),
                  decoration: BoxDecoration(
                    color: AppColors.c6CCF23.withValues(alpha: 0.1), // Greenish background
                    shape: BoxShape.circle,
                  ),
                  child: const Icon(
                    Icons.check_circle_outline,
                    size: 80,
                    color: AppColors.c6CCF23, // Green color indicating success
                  ),
                ),
              ),
              32.g,
              const CustomText(
                text: "You're all set!",
                textAlign: TextAlign.center,
                style: TextStyle(fontSize: 28, fontWeight: FontWeight.w800, color: AppColors.black),
              ),
              16.g,
              const CustomText(
                text: "Your profile is ready. Start browsing jobs\nnow.",
                textAlign: TextAlign.center,
                style: TextStyle(fontSize: 16, color: AppColors.c61677D, height: 1.5),
              ),
              48.g,
              PrimaryButton(
                text: "Go to Dashboard",
                onPressed: () {
                  // Route to main home / dashboard
                },
              ),
              const Spacer(),
              const Center(
                child: CustomText(
                  text: "SPEED STAFF",
                  style: TextStyle(color: AppColors.cE0E5EC, fontSize: 14, fontWeight: FontWeight.bold, letterSpacing: 2.0),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
