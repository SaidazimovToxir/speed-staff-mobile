import 'package:go_router/go_router.dart';


import 'dart:math' as math;
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import '../../../../config/core/constants/app_colors.dart';

class SplashScreen extends StatefulWidget {
  const SplashScreen({super.key});

  @override
  State<SplashScreen> createState() => _SplashScreenState();
}

class _SplashScreenState extends State<SplashScreen> {
  @override
  void initState() {
    super.initState();
    Future.delayed(const Duration(seconds: 2), () {
      if (mounted) {
        // Replace with onboarding routing once go_router is fully setup, 
        // for now just testing UI or pushing named routes.
        // context.go(RouteNames.onboarding); // We'll add this to route names
        context.go('/role_selection_screen');
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.white,
      appBar: AppBar(
        elevation: 0,
        backgroundColor: AppColors.white,
        systemOverlayStyle: const SystemUiOverlayStyle(
          statusBarColor: AppColors.white,
          statusBarIconBrightness: Brightness.dark,
        ),
      ),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            // Using a placeholder icon since we don't have the exact logo asset
            Container(
              padding: const EdgeInsets.all(16),
              decoration: BoxDecoration(
                color: AppColors.cF9A405.withOpacity(0.1),
                borderRadius: BorderRadius.circular(16),
              ),
              child: const Icon(
                Icons.restaurant, // Approximation of the fork/knife icon in logo
                size: 48,
                color: AppColors.cF9A405,
              ),
            ),
            const SizedBox(height: 24),
            const Text(
              "Speed Staff",
              style: TextStyle(
                fontSize: 28,
                fontWeight: FontWeight.w800,
                color: AppColors.black,
              ),
            ),
            const SizedBox(height: 8),
            const Text(
              "Find your shift. Fast.",
              style: TextStyle(
                fontSize: 16,
                fontWeight: FontWeight.w500,
                color: AppColors.c61677D,
              ),
            ),
            const Spacer(),
            const ThreeDotLoading(),
            const SizedBox(height: 64),
          ],
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
                decoration: const BoxDecoration(
                  color: AppColors.cF9A405,
                  shape: BoxShape.circle,
                ),
              ),
            );
          },
        );
      }),
    );
  }
}
