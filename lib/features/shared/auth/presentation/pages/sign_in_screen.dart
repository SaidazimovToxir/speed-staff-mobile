import 'package:go_router/go_router.dart';
import 'package:flutter/material.dart';
import 'package:speed_staff_mobile/features/shared/auth/presentation/widgets/social_login_buttons.dart';
import 'package:speed_staff_mobile/config/config.dart';

class SignInScreen extends StatefulWidget {
  const SignInScreen({super.key});

  @override
  State<SignInScreen> createState() => _SignInScreenState();
}

class _SignInScreenState extends State<SignInScreen> {
  bool _obscureText = true;

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
          text: "Sign In",
          style: TextStyle(color: AppColors.black, fontWeight: FontWeight.bold, fontSize: 16),
        ),
        centerTitle: true,
      ),
      body: SafeArea(
        child: SingleChildScrollView(
          padding: const EdgeInsets.all(24.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              16.g,
              Center(
                child: Container(
                  padding: const EdgeInsets.all(16),
                  decoration: BoxDecoration(color: AppColors.cF9A405.withValues(alpha: 0.1), borderRadius: BorderRadius.circular(16)),
                  child: const Icon(
                    Icons.bolt, // Placeholder for the lightning bolt logo
                    size: 48,
                    color: AppColors.cF9A405,
                  ),
                ),
              ),
              16.g,
              const Center(
                child: CustomText(
                  text: "Speed Staff",
                  style: TextStyle(fontSize: 24, fontWeight: FontWeight.w800, color: AppColors.black),
                ),
              ),
              8.g,
              const Center(
                child: CustomText(
                  text: "Efficiency at your fingertips",
                  style: TextStyle(fontSize: 14, color: AppColors.c61677D),
                ),
              ),
              32.g,
              const SocialLoginButtons(),
              32.g,
              const Row(
                children: [
                  Expanded(child: Divider(color: AppColors.cE0E5EC)),
                  Padding(
                    padding: EdgeInsets.symmetric(horizontal: 16.0),
                    child: CustomText(
                      text: "OR SIGN IN WITH EMAIL",
                      style: TextStyle(fontSize: 12, fontWeight: FontWeight.bold, color: AppColors.c61677D),
                    ),
                  ),
                  Expanded(child: Divider(color: AppColors.cE0E5EC)),
                ],
              ),
              32.g,
              const CustomTextField(hintText: "user@email.com", labelText: "Email Address", keyboardType: TextInputType.emailAddress),
              24.g,
              CustomTextField(
                hintText: "••••••••",
                labelText: "Password",
                obscureText: _obscureText,
                suffixIcon: CustomIconButton(
                  icon: Icon(_obscureText ? Icons.visibility_off : Icons.visibility, color: AppColors.c61677D),
                  onPressed: () {
                    setState(() {
                      _obscureText = !_obscureText;
                    });
                  },
                ),
              ),
              8.g,
              Align(
                alignment: Alignment.centerRight,
                child: GestureDetector(
                  onTap: () {
                    context.push(RouteNames.forgotPasswordScreen);
                  },
                  child: const CustomText(
                    text: "Forgot password?",
                    style: TextStyle(color: AppColors.cF9A405, fontWeight: FontWeight.bold, fontSize: 14),
                  ),
                ),
              ),
              32.g,
              PrimaryButton(
                text: "Sign In",
                onPressed: () {
                  // handle sign in
                },
              ),
              24.g,
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  const CustomText(
                    text: "Don't have an account? ",
                    style: TextStyle(color: AppColors.c61677D),
                  ),
                  GestureDetector(
                    onTap: () {
                      context.go(RouteNames.roleSelectionScreen);
                    },
                    child: const CustomText(
                      text: "Get Started",
                      style: TextStyle(color: AppColors.cF9A405, fontWeight: FontWeight.bold),
                    ),
                  ),
                ],
              ),
              24.g,
            ],
          ),
        ),
      ),
    );
  }
}
