import 'package:flutter/material.dart';
import 'package:speed_staff_mobile/config/core/constants/app_colors.dart';
import 'package:speed_staff_mobile/config/core/extensions/size_extension.dart';
import 'package:speed_staff_mobile/config/widgets/custom_text.dart';

class RoleCard extends StatelessWidget {
  final IconData icon;
  final String title;
  final String subtitle;
  final bool isSelected;
  final VoidCallback onTap;

  const RoleCard({super.key, required this.icon, required this.title, required this.subtitle, required this.isSelected, required this.onTap});

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        padding: const EdgeInsets.all(20),
        decoration: BoxDecoration(
          color: isSelected ? AppColors.cF9A405.withValues(alpha: 0.05) : AppColors.white,
          border: Border.all(color: isSelected ? AppColors.cF9A405 : AppColors.cE0E5EC, width: 2),
          borderRadius: BorderRadius.circular(16),
        ),
        child: Row(
          children: [
            Container(
              padding: const EdgeInsets.all(12),
              decoration: BoxDecoration(
                color: isSelected ? AppColors.cF9A405.withValues(alpha: 0.2) : AppColors.cF6F6F6,
                borderRadius: BorderRadius.circular(12),
              ),
              child: Icon(icon, color: isSelected ? AppColors.cF9A405 : AppColors.c61677D),
            ),
            16.g,
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  CustomText(text: title, fontSize: 16, fontWeight: FontWeight.bold, color: AppColors.black),
                  4.g,
                  CustomText(text: subtitle, fontSize: 14, color: AppColors.c61677D),
                ],
              ),
            ),
            Icon(isSelected ? Icons.check_circle : Icons.radio_button_unchecked, color: isSelected ? AppColors.cF9A405 : AppColors.cE0E5EC),
          ],
        ),
      ),
    );
  }
}
