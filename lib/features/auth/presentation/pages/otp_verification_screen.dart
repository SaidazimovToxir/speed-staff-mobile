import 'package:go_router/go_router.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import '../../../../config/core/constants/app_colors.dart';
import '../../../../config/core/widgets/primary_button.dart';
import '../widgets/auth_header.dart';
import 'package:speed_staff_mobile/config/core/extensions/size_extension.dart';

class OtpVerificationScreen extends StatefulWidget {
  const OtpVerificationScreen({super.key});

  @override
  State<OtpVerificationScreen> createState() => _OtpVerificationScreenState();
}

class _OtpVerificationScreenState extends State<OtpVerificationScreen> {
  final List<TextEditingController> _controllers = List.generate(6, (_) => TextEditingController());
  final List<FocusNode> _focusNodes = List.generate(6, (_) => FocusNode());

  @override
  void dispose() {
    for (var controller in _controllers) {
      controller.dispose();
    }
    for (var node in _focusNodes) {
      node.dispose();
    }
    super.dispose();
  }

  void _onChanged(String value, int index) {
    if (value.isNotEmpty && index < 5) {
      _focusNodes[index + 1].requestFocus();
    } else if (value.isEmpty && index > 0) {
      _focusNodes[index - 1].requestFocus();
    }
    setState(() {}); // Trigger rebuild to update button color
  }

  bool get _isCodeComplete => _controllers.every((c) => c.text.isNotEmpty);

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
          "STEP 2 OF 3",
          style: TextStyle(
            color: AppColors.c61677D,
            fontWeight: FontWeight.bold,
            fontSize: 12,
            letterSpacing: 1.5,
          ),
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
              const AuthHeader(
                title: "Enter verification code",
                subtitle: "We sent a 6-digit code to +998 90 123 45 67",
              ),
              32.g,
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: List.generate(
                  6,
                  (index) => SizedBox(
                    width: 48,
                    height: 56,
                    child: TextFormField(
                      controller: _controllers[index],
                      focusNode: _focusNodes[index],
                      onChanged: (value) => _onChanged(value, index),
                      keyboardType: TextInputType.number,
                      textAlign: TextAlign.center,
                      style: const TextStyle(fontSize: 24, fontWeight: FontWeight.bold),
                      inputFormatters: [
                        LengthLimitingTextInputFormatter(1),
                        FilteringTextInputFormatter.digitsOnly,
                      ],
                      decoration: InputDecoration(
                        filled: true,
                        fillColor: AppColors.cF6F6F6,
                        contentPadding: EdgeInsets.zero,
                        border: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(12),
                          borderSide: BorderSide.none,
                        ),
                        focusedBorder: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(12),
                          borderSide: const BorderSide(color: AppColors.cF9A405, width: 2),
                        ),
                      ),
                    ),
                  ),
                ),
              ),
              32.g,
              Center(
                child: RichText(
                  text: const TextSpan(
                    text: 'Resend code in ',
                    style: TextStyle(color: AppColors.c61677D, fontSize: 14),
                    children: <TextSpan>[
                      TextSpan(
                        text: '01:42',
                        style: TextStyle(color: AppColors.cF9A405, fontWeight: FontWeight.bold),
                      ),
                    ],
                  ),
                ),
              ),
              8.g,
              const Center(
                child: Text(
                  "Didn't receive the code? Resend",
                  style: TextStyle(
                    color: AppColors.c61677D,
                    fontSize: 14,
                    decoration: TextDecoration.underline,
                  ),
                ),
              ),
              const Spacer(),
              PrimaryButton(
                text: "Verify Code",
                onPressed: _isCodeComplete ? () {
                  // Navigate depending on registration vs login flow
                  context.push('/register_restaurant_screen');
                } : () {},
                color: _isCodeComplete ? AppColors.cF9A405 : AppColors.cE0E5EC,
                textColor: _isCodeComplete ? AppColors.white : AppColors.c61677D,
              ),
              16.g,
              const Text(
                "By clicking Verify, you agree to our\nTerms of Service and Privacy Policy.",
                textAlign: TextAlign.center,
                style: TextStyle(fontSize: 12, color: AppColors.c61677D, height: 1.5),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
