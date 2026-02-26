import 'package:go_router/go_router.dart';
import 'package:flutter/material.dart';
import '../../../../config/core/constants/app_colors.dart';
import '../../../../config/core/widgets/primary_button.dart';
import '../../../../config/core/widgets/custom_text_field.dart';
import 'package:speed_staff_mobile/config/core/extensions/size_extension.dart';

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
        leading: IconButton(
          icon: const Icon(Icons.arrow_back, color: AppColors.black),
          onPressed: () => context.pop(),
        ),
        title: const Text(
          "Sign In",
          style: TextStyle(
            color: AppColors.black,
            fontWeight: FontWeight.bold,
            fontSize: 16,
          ),
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
                  decoration: BoxDecoration(
                    color: AppColors.cF9A405.withOpacity(0.1),
                    borderRadius: BorderRadius.circular(16),
                  ),
                  child: const Icon(
                    Icons.bolt, // Placeholder for the lightning bolt logo
                    size: 48,
                    color: AppColors.cF9A405,
                  ),
                ),
              ),
              16.g,
              const Center(
                child: Text(
                  "Speed Staff",
                  style: TextStyle(
                    fontSize: 24,
                    fontWeight: FontWeight.w800,
                    color: AppColors.black,
                  ),
                ),
              ),
              8.g,
              const Center(
                child: Text(
                  "Efficiency at your fingertips",
                  style: TextStyle(
                    fontSize: 14,
                    color: AppColors.c61677D,
                  ),
                ),
              ),
              32.g,
              PrimaryButton(
                text: "Continue with Phone",
                onPressed: () {
                  context.push('/phone_input_screen');
                },
              ),
              16.g,
              PrimaryButton(
                text: "Continue with Google",
                color: AppColors.black, // Typical Google button style or white outline
                textColor: AppColors.white,
                onPressed: () {},
                icon: const Icon(Icons.g_mobiledata, color: AppColors.white, size: 32),
              ),
              32.g,
              const Row(
                children: [
                  Expanded(child: Divider(color: AppColors.cE0E5EC)),
                  Padding(
                    padding: EdgeInsets.symmetric(horizontal: 16.0),
                    child: Text(
                      "OR SIGN IN WITH EMAIL",
                      style: TextStyle(
                        fontSize: 12,
                        fontWeight: FontWeight.bold,
                        color: AppColors.c61677D,
                      ),
                    ),
                  ),
                  Expanded(child: Divider(color: AppColors.cE0E5EC)),
                ],
              ),
              32.g,
              const CustomTextField(
                hintText: "user@email.com",
                labelText: "Email Address",
                keyboardType: TextInputType.emailAddress,
              ),
              24.g,
              CustomTextField(
                hintText: "••••••••",
                labelText: "Password",
                obscureText: _obscureText,
                suffixIcon: IconButton(
                  icon: Icon(
                    _obscureText ? Icons.visibility_off : Icons.visibility,
                    color: AppColors.c61677D,
                  ),
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
                    Navigator.of(context).pushNamed('/forgot_password_screen');
                  },
                  child: const Text(
                    "Forgot password?",
                    style: TextStyle(
                      color: AppColors.cF9A405,
                      fontWeight: FontWeight.bold,
                      fontSize: 14,
                    ),
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
                  const Text(
                    "Don't have an account? ",
                    style: TextStyle(color: AppColors.c61677D),
                  ),
                  GestureDetector(
                    onTap: () {
                      context.go('/role_selection_screen');
                    },
                    child: const Text(
                      "Get Started",
                      style: TextStyle(
                        color: AppColors.cF9A405,
                        fontWeight: FontWeight.bold,
                      ),
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
