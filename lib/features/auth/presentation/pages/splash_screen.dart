import 'package:flutter/material.dart';
import 'package:speed_staff_mobile/config/config.dart';

class SplashScreen extends StatelessWidget {
  const SplashScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Center(child: CustomText(text: "Hello splash", fontSize: 20)),
    );
  }
}
