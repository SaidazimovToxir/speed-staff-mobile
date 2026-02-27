import 'package:flutter/services.dart';
import 'package:go_router/go_router.dart';
import 'package:flutter/material.dart';
import 'package:toastification/toastification.dart';
import 'package:speed_staff_mobile/features/shared/auth/presentation/widgets/auth_header.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:speed_staff_mobile/features/shared/auth/presentation/bloc/auth_bloc.dart';
import 'package:speed_staff_mobile/features/shared/auth/presentation/bloc/auth_event.dart';
import 'package:speed_staff_mobile/features/shared/auth/presentation/bloc/auth_state.dart';
import 'package:speed_staff_mobile/config/config.dart';

class OtpVerificationScreen extends StatefulWidget {
  final String phoneNumber;

  const OtpVerificationScreen({super.key, required this.phoneNumber});

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
        leading: CustomIconButton(
          icon: const Icon(Icons.arrow_back, color: AppColors.black),
          onPressed: () => context.pop(),
        ),
        title: const CustomText(
          text: "STEP 2 OF 3",
          style: TextStyle(color: AppColors.c61677D, fontWeight: FontWeight.bold, fontSize: 12, letterSpacing: 1.5),
        ),
        centerTitle: true,
      ),
      body: BlocConsumer<AuthBloc, AuthState>(
        listener: (context, state) {
          if (state is AuthNeedsProfileUpdate) {
            final code = _controllers.map((c) => c.text).join();
            final args = {'phone': widget.phoneNumber, 'code': code};
            context.push(RouteNames.roleSelectionScreen, extra: args);
          } else if (state is AuthSuccess) {
            context.go(RouteNames.main);
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
                crossAxisAlignment: CrossAxisAlignment.stretch,
                children: [
                  16.g,
                  AuthHeader(title: "Enter verification code", subtitle: "We sent a 6-digit code to ${widget.phoneNumber}"),
                  32.g,
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: List.generate(
                      6,
                      (index) => SizedBox(
                        width: 48,
                        height: 56,
                        child: CustomTextField(
                          controller: _controllers[index],
                          focusNode: _focusNodes[index],
                          onChanged: (value) => _onChanged(value, index),
                          keyboardType: TextInputType.number,
                          textAlign: TextAlign.center,
                          style: const TextStyle(fontSize: 24, fontWeight: FontWeight.bold),
                          inputFormatters: [LengthLimitingTextInputFormatter(1), FilteringTextInputFormatter.digitsOnly],
                          hintText: "",
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
                    child: CustomText(
                      text: "Didn't receive the code? Resend",
                      style: TextStyle(color: AppColors.c61677D, fontSize: 14, decoration: TextDecoration.underline),
                    ),
                  ),
                  const Spacer(),
                  PrimaryButton(
                    text: state is AuthLoading ? "Verifying..." : "Verify Code",
                    onPressed: _isCodeComplete && state is! AuthLoading
                        ? () {
                            final code = _controllers.map((c) => c.text).join();
                            context.read<AuthBloc>().add(VerifyOtpEvent(telephoneNumber: widget.phoneNumber, confirmCode: code));
                          }
                        : () {},
                    color: _isCodeComplete && state is! AuthLoading ? AppColors.cF9A405 : AppColors.cE0E5EC,
                    textColor: _isCodeComplete && state is! AuthLoading ? AppColors.white : AppColors.c61677D,
                  ),
                  16.g,
                  const CustomText(
                    text: "By clicking Verify, you agree to our\nTerms of Service and Privacy Policy.",
                    textAlign: TextAlign.center,
                    style: TextStyle(fontSize: 12, color: AppColors.c61677D, height: 1.5),
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
