import 'package:go_router/go_router.dart';

import 'dart:math' as math;
import 'package:flutter/material.dart';
import 'package:speed_staff_mobile/config/router/route_names.dart';
import 'package:flutter/services.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:speed_staff_mobile/config/core/constants/app_colors.dart';
import 'package:speed_staff_mobile/config/widgets/custom_text.dart';
import 'package:speed_staff_mobile/features/shared/auth/presentation/bloc/auth_bloc.dart';
import 'package:speed_staff_mobile/features/shared/auth/presentation/bloc/auth_state.dart';

class SplashScreen extends StatefulWidget {
  const SplashScreen({super.key});

  @override
  State<SplashScreen> createState() => _SplashScreenState();
}

class _SplashScreenState extends State<SplashScreen> {
  @override
  void initState() {
    super.initState();
    // Delay is for visual effect only, navigation is handled by BlocListener
  }

  @override
  Widget build(BuildContext context) {
    return BlocListener<AuthBloc, AuthState>(
      listener: (context, state) {
        if (state is AuthSuccess) {
          context.go(RouteNames.main);
        } else if (state is AuthFailure || state is AuthInitial) {
          context.go(RouteNames.onboardingScreen);
        }
      },
      child: Scaffold(
        backgroundColor: AppColors.white,
        appBar: AppBar(
          elevation: 0,
          backgroundColor: AppColors.white,
          systemOverlayStyle: const SystemUiOverlayStyle(statusBarColor: AppColors.white, statusBarIconBrightness: Brightness.dark),
        ),
        body: Center(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              // Using a placeholder icon since we don't have the exact logo asset
              Container(
                padding: const EdgeInsets.all(16),
                decoration: BoxDecoration(color: AppColors.cF9A405.withValues(alpha: 0.1), borderRadius: BorderRadius.circular(16)),
                child: const Icon(
                  Icons.restaurant, // Approximation of the fork/knife icon in logo
                  size: 48,
                  color: AppColors.cF9A405,
                ),
              ),
              const SizedBox(height: 24),
              const CustomText(
                text: "Speed Staff",
                style: TextStyle(fontSize: 28, fontWeight: FontWeight.w800, color: AppColors.black),
              ),
              const SizedBox(height: 8),
              const CustomText(
                text: "Find your shift. Fast.",
                style: TextStyle(fontSize: 16, fontWeight: FontWeight.w500, color: AppColors.c61677D),
              ),
              const Spacer(),
              const ThreeDotLoading(),
              const SizedBox(height: 64),
            ],
          ),
        ),
      ),
    );
  }
}

class ThreeDotLoading extends StatefulWidget {
  const ThreeDotLoading({super.key});

  @override
  State<ThreeDotLoading> createState() => _ThreeDotLoadingState();
}

class _ThreeDotLoadingState extends State<ThreeDotLoading> with SingleTickerProviderStateMixin {
  late final AnimationController _controller;

  @override
  void initState() {
    super.initState();
    _controller = AnimationController(vsync: this, duration: const Duration(seconds: 1))..repeat();
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.center,
      children: List.generate(3, (index) {
        return AnimatedBuilder(
          animation: _controller,
          builder: (context, child) {
            // Calculate a wave effect
            final double t = (_controller.value * 2 * 3.14159) + (index * 1.5);
            final double offset = 5 * (0.5 * (1 + -1 * math.sin(t))); // sine wave between 0 and 1
            return Transform.translate(
              offset: Offset(0, -offset),
              child: Container(
                margin: const EdgeInsets.symmetric(horizontal: 4),
                width: 12,
                height: 12,
                decoration: const BoxDecoration(color: AppColors.cF9A405, shape: BoxShape.circle),
              ),
            );
          },
        );
      }),
    );
  }
}
