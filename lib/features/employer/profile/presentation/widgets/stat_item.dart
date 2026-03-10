import 'package:flutter/material.dart';
import 'package:speed_staff_mobile/config/config.dart';

class StatItem extends StatelessWidget {
  final String value;
  final String label;

  const StatItem({super.key, required this.value, required this.label});

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        CustomText(
          text: value,
          fontSize: 18,
          fontWeight: FontWeight.bold,
          color: AppColors.c1F3C88,
        ),
        4.g,
        CustomText(
          text: label,
          fontSize: 12,
          color: Colors.grey,
          fontWeight: FontWeight.bold,
        ),
      ],
    );
  }
}
