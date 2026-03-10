import 'package:flutter/material.dart';
import 'package:speed_staff_mobile/config/config.dart';

class EmployerHomeHeader extends StatelessWidget {
  const EmployerHomeHeader({super.key});

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 12),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Row(
            children: [
              Container(
                width: 44,
                height: 44,
                decoration: BoxDecoration(
                  color: AppColors.cF9A405.withValues(alpha: 0.1),
                  borderRadius: BorderRadius.circular(12),
                ),
                child: const Icon(Icons.business_center_rounded, color: AppColors.cF9A405, size: 24),
              ),
              12.g,
              Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const CustomText(
                    text: "Speed Staff", // Matching design logic but keeping name correct
                    fontSize: 18,
                    fontWeight: FontWeight.w700,
                  ),
                  CustomText(
                    text: "Welcome back, Recruiter",
                    fontSize: 12,
                    color: Colors.grey[600],
                  ),
                ],
              ),
            ],
          ),
          Container(
             padding: const EdgeInsets.all(8),
             decoration: BoxDecoration(
               shape: BoxShape.circle,
               border: Border.all(color: Colors.grey.shade300),
             ),
            child: const Icon(
              Icons.notifications_none_rounded,
              color: Colors.black,
              size: 22,
            ),
          ),
        ],
      ),
    );
  }
}
