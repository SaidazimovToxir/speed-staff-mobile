import 'dart:async';
import 'package:easy_localization/easy_localization.dart';
import 'package:go_router/go_router.dart';
import 'package:flutter/material.dart';
import 'package:toastification/toastification.dart';
import 'package:pinput/pinput.dart';
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
  final TextEditingController _pinController = TextEditingController();
  final FocusNode _focusNode = FocusNode();
  
  Timer? _timer;
  int _secondsRemaining = 120;
  bool _canResend = false;

  @override
  void initState() {
    super.initState();
    _startTimer();
  }

  void _startTimer() {
    setState(() {
      _secondsRemaining = 120;
      _canResend = false;
    });
    _timer?.cancel();
    _timer = Timer.periodic(const Duration(seconds: 1), (timer) {
      if (_secondsRemaining > 0) {
        setState(() {
          _secondsRemaining--;
        });
      } else {
        setState(() {
          _canResend = true;
        });
        timer.cancel();
      }
    });
  }

  void _resendCode() {
    if (_canResend) {
      context.read<AuthBloc>().add(SendOtpEvent(widget.phoneNumber));
      _startTimer();
    }
  }

  @override
  void dispose() {
    _pinController.dispose();
    _focusNode.dispose();
    _timer?.cancel();
    super.dispose();
  }

  String get _formattedTime {
    final minutes = (_secondsRemaining / 60).floor().toString().padLeft(2, '0');
    final seconds = (_secondsRemaining % 60).toString().padLeft(2, '0');
    return "$minutes:$seconds";
  }

  @override
  Widget build(BuildContext context) {
    context.locale; // Force rebuild on language change
    return Scaffold(
      backgroundColor: AppColors.white,
      appBar: AppBar(
        elevation: 0,
        backgroundColor: AppColors.white,
        leading: context.canPop()
            ? CustomIconButton(
                icon: const Icon(Icons.arrow_back, color: AppColors.black),
                onPressed: () => context.pop(),
              )
            : null,
      ),
      body: BlocConsumer<AuthBloc, AuthState>(
        listener: (context, state) {
          if (state is AuthNeedsProfileUpdate) {
            final args = {'phone': widget.phoneNumber, 'code': _pinController.text};
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
                  AuthHeader(title: "otp_title", subtitle: "otp_subtitle".tr(args: [widget.phoneNumber])),
                  32.g,
                  Center(
                    child: Pinput(
                      length: 6,
                      controller: _pinController,
                      focusNode: _focusNode,
                      defaultPinTheme: PinTheme(
                        width: 48,
                        height: 56,
                        textStyle: const TextStyle(fontSize: 24, fontWeight: FontWeight.bold, color: AppColors.black),
                        decoration: BoxDecoration(
                          border: Border.all(color: AppColors.cE0E5EC),
                          borderRadius: BorderRadius.circular(8),
                          color: AppColors.white,
                        ),
                      ),
                      focusedPinTheme: PinTheme(
                        width: 48,
                        height: 56,
                        textStyle: const TextStyle(fontSize: 24, fontWeight: FontWeight.bold, color: AppColors.black),
                        decoration: BoxDecoration(
                          border: Border.all(color: AppColors.cF9A405, width: 2),
                          borderRadius: BorderRadius.circular(8),
                          color: AppColors.white,
                        ),
                      ),
                      onCompleted: (pin) {
                        context.read<AuthBloc>().add(VerifyOtpEvent(telephoneNumber: widget.phoneNumber, confirmCode: pin));
                      },
                      onChanged: (value) {
                        setState(() {});
                      },
                    ),
                  ),
                  32.g,
                  Center(
                    child: RichText(
                      text: TextSpan(
                        text: "resend_in".tr(),
                        style: const TextStyle(color: AppColors.c61677D, fontSize: 14),
                        children: <TextSpan>[
                          TextSpan(
                            text: _formattedTime,
                            style: const TextStyle(color: AppColors.cF9A405, fontWeight: FontWeight.bold),
                          ),
                        ],
                      ),
                    ),
                  ),
                  8.g,
                  Center(
                    child: GestureDetector(
                      onTap: _canResend ? _resendCode : null,
                      child: CustomText(
                        text: "didnt_receive_code",
                        style: TextStyle(
                          color: _canResend ? AppColors.cF9A405 : AppColors.c61677D,
                          fontSize: 14,
                          decoration: TextDecoration.underline,
                        ),
                      ),
                    ),
                  ),
                  const Spacer(),
                  PrimaryButton(
                    text: state is AuthLoading ? "verifying" : "verify_code",
                    onPressed: _pinController.text.length == 6 && state is! AuthLoading
                        ? () {
                            context.read<AuthBloc>().add(VerifyOtpEvent(telephoneNumber: widget.phoneNumber, confirmCode: _pinController.text));
                          }
                        : () {},
                    color: _pinController.text.length == 6 && state is! AuthLoading ? AppColors.cF9A405 : AppColors.cE0E5EC,
                    textColor: _pinController.text.length == 6 && state is! AuthLoading ? AppColors.white : AppColors.c61677D,
                  ),
                  16.g,
                  const CustomText(
                    text: "tos_privacy_agreement",
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
