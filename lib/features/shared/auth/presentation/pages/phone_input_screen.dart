import 'package:easy_localization/easy_localization.dart';
import 'package:go_router/go_router.dart';
import 'package:flutter/material.dart';
import 'package:toastification/toastification.dart';
import 'package:mask_text_input_formatter/mask_text_input_formatter.dart';
import 'package:speed_staff_mobile/features/shared/auth/presentation/widgets/auth_header.dart';
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

class _PhoneInputScreenState extends State<PhoneInputScreen> with SingleTickerProviderStateMixin {
  late final TextEditingController _phoneController;
  late final AnimationController _shakeController;
  late final Animation<double> _shakeAnimation;
  bool _isTosAccepted = false;
  bool _showTosError = false;
  late final MaskTextInputFormatter _phoneFormatter;

  @override
  void initState() {
    super.initState();
    _phoneFormatter = MaskTextInputFormatter(mask: '## ### ## ##', filter: {"#": RegExp(r'[0-9]')}, type: MaskAutoCompletionType.lazy);
    _phoneController = TextEditingController();
    _shakeController = AnimationController(vsync: this, duration: const Duration(milliseconds: 400));
    _shakeAnimation = TweenSequence([
      TweenSequenceItem(tween: Tween(begin: 0.0, end: -10.0), weight: 1),
      TweenSequenceItem(tween: Tween(begin: -10.0, end: 10.0), weight: 2),
      TweenSequenceItem(tween: Tween(begin: 10.0, end: -10.0), weight: 2),
      TweenSequenceItem(tween: Tween(begin: -10.0, end: 10.0), weight: 2),
      TweenSequenceItem(tween: Tween(begin: 10.0, end: 0.0), weight: 1),
    ]).animate(CurvedAnimation(parent: _shakeController, curve: Curves.easeInOut));
  }

  @override
  void dispose() {
    _phoneController.dispose();
    _shakeController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    context.locale; // Force rebuild on language change for RichText
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
                  const AuthHeader(title: "phone_input_title", subtitle: "phone_input_subtitle"),
                  32.g,
                  CustomTextField(
                    controller: _phoneController,
                    hintText: "90 123 45 67",
                    keyboardType: TextInputType.phone,

                    prefixIcon: const Padding(
                      padding: EdgeInsets.only(left: 16, right: 8, top: 14, bottom: 14),
                      child: Text(
                        "+998",
                        style: TextStyle(fontSize: 14, color: AppColors.black, fontWeight: FontWeight.w500),
                      ),
                    ),
                    inputFormatters: [_phoneFormatter],
                  ),
                  24.g,
                  AnimatedBuilder(
                    animation: _shakeAnimation,
                    builder: (context, child) {
                      return Transform.translate(offset: Offset(_shakeAnimation.value, 0), child: child);
                    },
                    child: Row(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Checkbox(
                          value: _isTosAccepted,
                          onChanged: (bool? value) {
                            setState(() {
                              _isTosAccepted = value ?? false;
                              if (_isTosAccepted) _showTosError = false;
                            });
                          },
                          activeColor: AppColors.cF9A405,
                          side: BorderSide(color: _showTosError ? AppColors.cFF0000 : AppColors.c61677D, width: 2),
                          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(4)),
                        ),
                        Expanded(
                          child: GestureDetector(
                            onTap: () {
                              // TODO: Navigate to Terms of Service
                            },
                            child: Padding(
                              padding: const EdgeInsets.only(top: 12.0),
                              child: RichText(
                                text: TextSpan(
                                  text: "tos_prefix".tr(),
                                  style: TextStyle(fontSize: 12, color: _showTosError ? AppColors.cFF0000 : AppColors.c61677D, height: 1.5),
                                  children: [
                                    TextSpan(
                                      text: "tos_link".tr(),
                                      style: TextStyle(
                                        decoration: TextDecoration.underline,
                                        color: _showTosError ? AppColors.cFF0000 : AppColors.cF9A405,
                                        fontWeight: FontWeight.bold,
                                      ),
                                    ),
                                    const TextSpan(text: "."),
                                  ],
                                ),
                              ),
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),
                  const Spacer(),
                  PrimaryButton(
                    text: state is AuthLoading ? "sending" : "send_code",
                    onPressed: state is AuthLoading
                        ? () {}
                        : () {
                            if (!_isTosAccepted) {
                              setState(() => _showTosError = true);
                              _shakeController.forward(from: 0.0);
                              return;
                            }
                            final phone = '+998${_phoneController.text.replaceAll(' ', '')}';
                            if (phone.length < 13) {
                              toastification.show(
                                context: context,
                                title: Text('invalid_phone'.tr()),
                                type: ToastificationType.error,
                                style: ToastificationStyle.fillColored,
                                autoCloseDuration: const Duration(seconds: 3),
                              );
                              return;
                            }
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
