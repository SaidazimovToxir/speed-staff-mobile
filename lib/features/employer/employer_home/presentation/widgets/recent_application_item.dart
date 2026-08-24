import 'package:speed_staff_mobile/features/employer/applications/domain/entities/application_entity.dart';
import 'package:flutter/material.dart';
import 'package:speed_staff_mobile/config/config.dart';
import 'package:intl/intl.dart';

class RecentApplicationItem extends StatelessWidget {
  final ApplicationShortEntity application;
  const RecentApplicationItem({super.key, required this.application});

  @override
  Widget build(BuildContext context) {
    final statusConfig = _getStatusConfig(application.status);
    final seeker = application.seeker;
    final timeAgo = _formatTime(application.appliedAt);

    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 14),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          CircleAvatar(
            radius: 20,
            backgroundColor: AppColors.c1F3C88.withValues(alpha: 0.1),
            backgroundImage: seeker.avatarUrl != null
                ? NetworkImage(seeker.avatarUrl!)
                : NetworkImage('https://ui-avatars.com/api/?name=${seeker.fullName}&background=1F3C88&color=fff'),
            onBackgroundImageError: (_, _) {},
          ),
          12.g,
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                CustomText(text: seeker.fullName, fontSize: 14, fontWeight: FontWeight.bold),
                3.g,
                CustomText(text: seeker.position ?? seeker.city ?? '', fontSize: 12, color: Colors.grey.shade600),
              ],
            ),
          ),
          Column(
            crossAxisAlignment: CrossAxisAlignment.end,
            children: [
              Container(
                padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
                decoration: BoxDecoration(color: statusConfig.backgroundColor, borderRadius: BorderRadius.circular(100)),
                child: CustomText(text: application.status.toUpperCase(), fontSize: 10, fontWeight: FontWeight.w700, color: statusConfig.textColor),
              ),
              6.g,
              CustomText(text: timeAgo, fontSize: 10, color: Colors.grey.shade500),
            ],
          ),
        ],
      ),
    );
  }

  String _formatTime(DateTime dt) {
    final diff = DateTime.now().difference(dt);
    if (diff.inMinutes < 60) return '${diff.inMinutes}m ago';
    if (diff.inHours < 24) return '${diff.inHours}h ago';
    return DateFormat('dd MMM').format(dt);
  }

  ({Color textColor, Color backgroundColor}) _getStatusConfig(String status) {
    switch (status.toLowerCase()) {
      case 'sent':
        return (textColor: Colors.blue, backgroundColor: Colors.blue.withValues(alpha: 0.1));
      case 'viewed':
        return (textColor: AppColors.cF9A405, backgroundColor: AppColors.cF9A405.withValues(alpha: 0.1));
      case 'shortlisted':
        return (textColor: Colors.teal, backgroundColor: Colors.teal.withValues(alpha: 0.1));
      case 'hired':
        return (textColor: Colors.green.shade700, backgroundColor: Colors.green.withValues(alpha: 0.1));
      case 'rejected':
        return (textColor: Colors.red.shade700, backgroundColor: Colors.red.withValues(alpha: 0.1));
      default:
        return (textColor: Colors.grey.shade700, backgroundColor: Colors.grey.shade200);
    }
  }
}
