import 'package:speed_staff_mobile/features/employer/applications/domain/entities/application_entity.dart';
import 'package:flutter/material.dart';
import 'package:speed_staff_mobile/config/config.dart';

class ExperienceItem extends StatelessWidget {
  final ExperienceEntity experience;
  const ExperienceItem({super.key, required this.experience});
  @override
  Widget build(BuildContext context) {
    return Row(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Container(
          width: 48,
          height: 48,
          decoration: BoxDecoration(
            color: Colors.grey.shade100,
            borderRadius: BorderRadius.circular(12),
            border: Border.all(color: Colors.grey.shade200),
          ),
          child: const Icon(Icons.business_rounded, color: AppColors.c1F3C88, size: 24),
        ),
        16.g,
        Expanded(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Expanded(
                    child: CustomText(
                      text: experience.company,
                      fontSize: 15,
                      fontWeight: FontWeight.w800,
                    ),
                  ),
                  if (experience.isPresent)
                    Container(
                      padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 3),
                      decoration: BoxDecoration(
                        color: Colors.green.shade50,
                        borderRadius: BorderRadius.circular(4),
                      ),
                      child: const CustomText(
                        text: "Present",
                        fontSize: 9,
                        color: Colors.green,
                        fontWeight: FontWeight.w900,
                      ),
                    ),
                ],
              ),
              4.g,
              CustomText(
                text: experience.role,
                fontSize: 13,
                color: Colors.grey.shade700,
                fontWeight: FontWeight.w600,
              ),
              6.g,
              CustomText(
                text: experience.period,
                fontSize: 12,
                color: Colors.grey.shade400,
                fontWeight: FontWeight.w600,
              ),
              12.g,
              CustomText(
                text: experience.description,
                fontSize: 12,
                color: Colors.grey.shade600,
                height: 1.6,
              ),
            ],
          ),
        ),
      ],
    );
  }
}
