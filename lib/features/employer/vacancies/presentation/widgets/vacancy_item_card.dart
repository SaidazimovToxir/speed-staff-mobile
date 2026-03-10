import 'package:speed_staff_mobile/features/employer/vacancies/domain/entities/vacancy_entity.dart';
import 'package:flutter/material.dart';
import 'package:speed_staff_mobile/config/config.dart';
import 'package:go_router/go_router.dart';

class VacancyItemCard extends StatelessWidget {
  final VacancyEntity vacancy;
  const VacancyItemCard({super.key, required this.vacancy});
  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(16),
        border: Border.all(color: Colors.grey.withValues(alpha: 0.1)),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withValues(alpha: 0.04),
            blurRadius: 10,
            offset: const Offset(0, 4),
          )
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Container(
                padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
                decoration: BoxDecoration(
                  color: Colors.green.withValues(alpha: 0.08),
                  borderRadius: BorderRadius.circular(100),
                ),
                child: Row(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    Container(
                      width: 6,
                      height: 6,
                      decoration: const BoxDecoration(
                        color: Colors.green,
                        shape: BoxShape.circle,
                      ),
                    ),
                    6.g,
                    CustomText(
                      text: "Active",
                      fontSize: 11,
                      fontWeight: FontWeight.w700,
                      color: Colors.green.shade700,
                    ),
                  ],
                ),
              ),
              const Icon(Icons.more_horiz, color: Colors.grey, size: 20),
            ],
          ),
          14.g,
          CustomText(
            text: vacancy.role,
            fontSize: 18,
            fontWeight: FontWeight.w800,
          ),
          4.g,
          CustomText(
            text: "${vacancy.company} • Posted 2d ago",
            fontSize: 12,
            color: Colors.grey.shade600,
          ),
          20.g,
          Row(
            children: [
              const Icon(Icons.people_outline, size: 18, color: Colors.grey),
              6.g,
              CustomText(
                text: "${vacancy.appliedCount} Total",
                fontSize: 12,
                fontWeight: FontWeight.w600,
                color: Colors.grey.shade600,
              ),
              12.g,
              const Icon(Icons.bolt, size: 18, color: AppColors.cF9A405),
              4.g,
              CustomText(
                text: "${vacancy.newCount} New",
                fontSize: 12,
                color: AppColors.cF9A405,
                fontWeight: FontWeight.w700,
              ),
              const Spacer(),
              InkWell(
                onTap: () => context.push("${RouteNames.vacancyApplications}/${vacancy.id}"),
                child: Row(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    const CustomText(
                      text: "View all",
                      color: AppColors.cF9A405,
                      fontWeight: FontWeight.w700,
                      fontSize: 12,
                    ),
                    4.g,
                    const Icon(Icons.chevron_right, color: AppColors.cF9A405, size: 16),
                  ],
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }
}
