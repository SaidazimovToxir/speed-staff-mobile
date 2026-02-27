import 'package:flutter/material.dart';
import 'package:speed_staff_mobile/config/core/constants/app_colors.dart';
import 'package:speed_staff_mobile/config/core/extensions/size_extension.dart';

class StepProgressBar extends StatelessWidget {
  final int currentStep;
  final int totalSteps;

  const StepProgressBar({super.key, required this.currentStep, this.totalSteps = 3});

  @override
  Widget build(BuildContext context) {
    return Row(
      children: List.generate(totalSteps * 2 - 1, (index) {
        if (index.isOdd) return 8.g;
        final stepIndex = index ~/ 2 + 1;
        return Expanded(
          child: Container(
            height: 4,
            decoration: BoxDecoration(color: stepIndex <= currentStep ? AppColors.cF9A405 : AppColors.cE0E5EC, borderRadius: BorderRadius.circular(2)),
          ),
        );
      }),
    );
  }
}
