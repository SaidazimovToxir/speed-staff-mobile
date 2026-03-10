import 'package:speed_staff_mobile/features/employer/applications/domain/entities/application_entity.dart';
import 'package:flutter/material.dart';
import 'package:speed_staff_mobile/config/config.dart';

class RecentApplicationItem extends StatelessWidget {
  final ApplicationEntity application;
  const RecentApplicationItem({super.key, required this.application});
  @override
  Widget build(BuildContext context) {
    final statusConfig = _getStatusConfig(application.status);
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 16),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          CircleAvatar(
            radius: 20,
            backgroundColor: AppColors.c1F3C88.withValues(alpha: 0.1),
            backgroundImage: NetworkImage(
               'https://ui-avatars.com/api/?name=${application.candidateName}&background=random',
            ),
            onBackgroundImageError: (_, __) {},
            child: Text(
              application.candidateName.isNotEmpty ? application.candidateName[0].toUpperCase() : '?',
              style: const TextStyle(color: AppColors.c1F3C88, fontWeight: FontWeight.bold),
            ),
          ),
          12.g,
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                CustomText(
                  text: application.candidateName,
                  fontSize: 14,
                  fontWeight: FontWeight.bold,
                ),
                2.g,
                CustomText(
                  text: application.role,
                  fontSize: 12,
                  color: Colors.grey.shade600,
                ),
              ],
            ),
          ),
          Column(
            crossAxisAlignment: CrossAxisAlignment.end,
            children: [
              Container(
                padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
                decoration: BoxDecoration(
                  color: statusConfig.backgroundColor,
                  borderRadius: BorderRadius.circular(100),
                ),
                child: CustomText(
                  text: application.status.toUpperCase(),
                  fontSize: 10,
                  fontWeight: FontWeight.w700,
                  color: statusConfig.textColor,
                ),
              ),
              8.g,
              CustomText(
                text: application.time,
                fontSize: 10,
                color: Colors.grey.shade500,
              ),
            ],
          ),
        ],
      ),
    );
  }

  ({Color textColor, Color backgroundColor}) _getStatusConfig(String status) {
    final lower = status.toLowerCase();
    if (lower.contains('review')) {
      return (textColor: AppColors.cF9A405, backgroundColor: AppColors.cF9A405.withValues(alpha: 0.1));
    } else if (lower.contains('interview')) {
      return (textColor: Colors.indigo, backgroundColor: Colors.indigo.withValues(alpha: 0.1));
    } else if (lower.contains('applied') || lower.contains('new')) {
      return (textColor: Colors.blue, backgroundColor: Colors.blue.withValues(alpha: 0.1));
    } else if (lower.contains('hired') || lower.contains('recruited')) {
      return (textColor: Colors.green.shade700, backgroundColor: Colors.green.withValues(alpha: 0.1));
    } else if (lower.contains('rejected')) {
      return (textColor: Colors.red.shade700, backgroundColor: Colors.red.withValues(alpha: 0.1));
    } else if (lower.contains('shortlisted')) {
      return (textColor: Colors.teal, backgroundColor: Colors.teal.withValues(alpha: 0.1));
    }
    return (textColor: Colors.grey.shade700, backgroundColor: Colors.grey.shade200);
  }
}
