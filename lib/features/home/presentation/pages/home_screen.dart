import 'package:flutter/material.dart';
import 'package:speed_staff_mobile/config/config.dart';

class HomeScreen extends StatelessWidget {
  const HomeScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Center(child: CustomText(text: "Home screen", fontSize: 20)),
    );
  }
}
