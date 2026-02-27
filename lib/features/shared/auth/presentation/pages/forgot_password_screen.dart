import 'package:go_router/go_router.dart';
import 'package:flutter/material.dart';
import 'package:toastification/toastification.dart';
import 'package:speed_staff_mobile/config/config.dart';
import 'package:speed_staff_mobile/features/shared/auth/presentation/widgets/auth_header.dart';

class ForgotPasswordScreen extends StatelessWidget {
  const ForgotPasswordScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.white,
      appBar: AppBar(
        elevation: 0,
        backgroundColor: AppColors.white,
        leading: CustomIconButton(
          icon: const Icon(Icons.arrow_back, color: AppColors.black),
          onPressed: () => context.pop(),
        ),
        title: const CustomText(
          text: "Reset Password",
          style: TextStyle(color: AppColors.black, fontWeight: FontWeight.bold, fontSize: 16),
        ),
        centerTitle: true,
      ),
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.all(24.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              16.g,
              Center(
                child: Container(
                  padding: const EdgeInsets.all(16),
                  decoration: BoxDecoration(color: AppColors.cF9A405.withValues(alpha: 0.1), shape: BoxShape.circle),
                  child: const Icon(
                    Icons.history, // Placeholder for reset icon
                    size: 48,
                    color: AppColors.cF9A405,
                  ),
                ),
              ),
              32.g,
              const AuthHeader(title: "Forgot your password?", subtitle: "Enter your phone number and we'll send\nyou a reset code."),
              32.g,
              const CustomTextField(
                hintText: "+1 (555) 000-0000", // example placeholder
                labelText: "Phone Number",
                keyboardType: TextInputType.phone,
              ),
              32.g,
              PrimaryButton(
                text: "Send Reset Code →",
                onPressed: () {
                  toastification.show(
                    context: context,
                    title: const Text("Reset code sent"),
                    type: ToastificationType.success,
                    style: ToastificationStyle.fillColored,
                    autoCloseDuration: const Duration(seconds: 3),
                  );
                },
              ),
              const Spacer(),
              GestureDetector(
                onTap: () {
                  context.pop();
                },
                child: const CustomText(
                  text: "← Back to Sign In",
                  textAlign: TextAlign.center,
                  style: TextStyle(color: AppColors.cF9A405, fontWeight: FontWeight.bold, fontSize: 14),
                ),
              ),
              24.g,
            ],
          ),
        ),
      ),
    );
  }
}
