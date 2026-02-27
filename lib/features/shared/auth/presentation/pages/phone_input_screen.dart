import 'package:go_router/go_router.dart';
import 'package:flutter/material.dart';
import 'package:toastification/toastification.dart';
import 'package:speed_staff_mobile/features/shared/auth/presentation/widgets/step_progress_bar.dart';
import 'package:speed_staff_mobile/features/shared/auth/presentation/widgets/auth_header.dart';
import 'package:mask_text_input_formatter/mask_text_input_formatter.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:speed_staff_mobile/features/shared/auth/presentation/bloc/auth_bloc.dart';
import 'package:speed_staff_mobile/features/shared/auth/presentation/bloc/auth_event.dart';
import 'package:speed_staff_mobile/features/shared/auth/presentation/bloc/auth_state.dart';
import 'package:speed_staff_mobile/config/config.dart';

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
    _phoneFormatter = MaskTextInputFormatter(mask: '+998 ## ### ## ##', filter: {"#": RegExp(r'[0-9]')}, type: MaskAutoCompletionType.lazy);
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
        leading: CustomIconButton(
          icon: const Icon(Icons.arrow_back, color: AppColors.black),
          onPressed: () => context.pop(),
        ),
        title: const CustomText(
          text: "Speed Staff",
          style: TextStyle(color: AppColors.black, fontWeight: FontWeight.bold, fontSize: 16),
        ),
        centerTitle: true,
      ),
      body: BlocConsumer<AuthBloc, AuthState>(
        listener: (context, state) {
          if (state is AuthOtpSent) {
            context.push(RouteNames.otpVerificationScreen, extra: {'phone': state.phoneNumber});
          } else if (state is AuthFailure) {
            toastification.show(
              context: context,
              title: Text(state.errorMessage),
              type: ToastificationType.error,
              style: ToastificationStyle.fillColored,
              autoCloseDuration: const Duration(seconds: 3),
            );
          }
        },
        builder: (context, state) {
          return SafeArea(
            child: Padding(
              padding: const EdgeInsets.all(24.0),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const StepProgressBar(currentStep: 1, totalSteps: 3),
                  32.g,
                  const AuthHeader(title: "Enter your phone\nnumber", subtitle: "We'll send you a 6-digit verification code"),
                  32.g,
                  CustomTextField(
                    controller: _phoneController,
                    hintText: "+998 | 90 123 45 67",
                    labelText: "Phone number",
                    keyboardType: TextInputType.phone,
                    prefixIcon: const Padding(
                      padding: EdgeInsets.symmetric(horizontal: 16, vertical: 14),
                      child: CustomText(text: "🇺🇿", style: TextStyle(fontSize: 20)),
                    ),
                    inputFormatters: [_phoneFormatter],
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
                        child: CustomText(
                          text: "Standard SMS fees may apply. By continuing, you agree to our Terms of Service.",
                          style: TextStyle(fontSize: 12, color: AppColors.c61677D, height: 1.5),
                        ),
                      ),
                    ],
                  ),
                  const Spacer(),
                  PrimaryButton(
                    text: state is AuthLoading ? "Sending..." : "Send Code →",
                    onPressed: state is AuthLoading
                        ? () {}
                        : () {
                            final phone = _phoneController.text.replaceAll(' ', '');
                            context.read<AuthBloc>().add(SendOtpEvent(phone));
                          },
                    color: state is AuthLoading ? AppColors.cE0E5EC : AppColors.cF9A405,
                    textColor: state is AuthLoading ? AppColors.c61677D : AppColors.white,
                  ),
                ],
              ),
            ),
          );
        },
      ),
    );
  }
}
