import 'package:go_router/go_router.dart';
import 'package:flutter/material.dart';
import '../../../../config/core/constants/app_colors.dart';
import '../../../../config/core/widgets/primary_button.dart';
import '../../../../config/core/widgets/custom_text_field.dart';
import '../widgets/auth_header.dart';
import 'package:flutter/services.dart';
import 'package:speed_staff_mobile/config/core/extensions/size_extension.dart';
import 'package:mask_text_input_formatter/mask_text_input_formatter.dart';

class PhoneInputScreen extends StatefulWidget {
  const PhoneInputScreen({super.key});

  @override
  State<PhoneInputScreen> createState() => _PhoneInputScreenState();
}

class _PhoneInputScreenState extends State<PhoneInputScreen> {
  late final TextEditingController _phoneController;
  late final MaskTextInputFormatter _phoneFormatter;

  @override
  void initState() {
    super.initState();
    _phoneController = TextEditingController(text: "+998 ");
    _phoneFormatter = MaskTextInputFormatter(
      mask: '+998 ## ### ## ##',
      filter: {"#": RegExp(r'[0-9]')},
      type: MaskAutoCompletionType.lazy,
    );
  }

  @override
  void dispose() {
    _phoneController.dispose();
    super.dispose();
  }

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
          "Speed Staff",
          style: TextStyle(
            color: AppColors.black,
            fontWeight: FontWeight.bold,
            fontSize: 16,
          ),
        ),
        centerTitle: true,
      ),
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.all(24.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Row(
                children: [
                  const Text(
                    "Step 1 of 3",
                    style: TextStyle(
                      fontSize: 12,
                      fontWeight: FontWeight.bold,
                      color: AppColors.c61677D,
                    ),
                  ),
                  16.g,
                  Expanded(
                    child: ClipRRect(
                      borderRadius: BorderRadius.circular(4),
                      child: LinearProgressIndicator(
                        value: 0.33,
                        backgroundColor: AppColors.cF6F6F6,
                        valueColor: const AlwaysStoppedAnimation<Color>(AppColors.cF9A405),
                        minHeight: 8,
                      ),
                    ),
                  ),
                  16.g,
                  const Text(
                    "33%",
                    style: TextStyle(
                      fontSize: 12,
                      fontWeight: FontWeight.bold,
                      color: AppColors.cF9A405,
                    ),
                  ),
                ],
              ),
              32.g,
              const AuthHeader(
                title: "Enter your phone\nnumber",
                subtitle: "We'll send you a 6-digit verification code",
              ),
              32.g,
              CustomTextField(
                controller: _phoneController,
                hintText: "+998 | 90 123 45 67",
                labelText: "Phone number",
                keyboardType: TextInputType.phone,
                prefixIcon: const Padding(
                  padding: EdgeInsets.symmetric(horizontal: 16, vertical: 14),
                  child: Text("🇺🇿", style: TextStyle(fontSize: 20)),
                ),
                inputFormatters: [
                  _phoneFormatter,
                ],
              ),
              24.g,
              Row(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Checkbox(
                    value: true,
                    onChanged: (bool? value) {},
                    activeColor: AppColors.cF9A405,
                    shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(4)),
                  ),
                  const Expanded(
                    child: Text(
                      "Standard SMS fees may apply. By continuing, you agree to our Terms of Service.",
                      style: TextStyle(fontSize: 12, color: AppColors.c61677D, height: 1.5),
                    ),
                  ),
                ],
              ),
              const Spacer(),
              PrimaryButton(
                text: "Send Code →",
                onPressed: () {
                  context.push('/otp_verification_screen');
                },
              ),
            ],
          ),
        ),
      ),
    );
  }
}
