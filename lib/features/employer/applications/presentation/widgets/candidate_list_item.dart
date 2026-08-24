import 'package:flutter/material.dart';
import 'package:speed_staff_mobile/config/config.dart';
import 'package:speed_staff_mobile/features/employer/applications/domain/entities/application_entity.dart';
import 'package:go_router/go_router.dart';
import 'package:intl/intl.dart';

class CandidateListItem extends StatelessWidget {
  final ApplicationShortEntity application;
  const CandidateListItem({super.key, required this.application});

  @override
  Widget build(BuildContext context) {
    final statusConfig = _getStatusConfig(application.status);
    final seeker = application.seeker;

    return InkWell(
      borderRadius: BorderRadius.circular(20),
      onTap: () => context.push(RouteNames.applicationDetail, extra: application.id),
      child: Container(
        padding: const EdgeInsets.all(16),
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(20),
          boxShadow: [BoxShadow(color: Colors.black.withValues(alpha: 0.04), blurRadius: 12, offset: const Offset(0, 4))],
          border: Border.all(color: Colors.grey.shade100),
        ),
        child: Row(
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            // Avatar
            ClipRRect(
              borderRadius: BorderRadius.circular(26),
              child: SizedBox(
                width: 52,
                height: 52,
                child: seeker.avatarUrl != null
                    ? Image.network(seeker.avatarUrl!, fit: BoxFit.cover, errorBuilder: (_, _, _) => _buildAvatarFallback(seeker.fullName))
                    : _buildAvatarFallback(seeker.fullName),
              ),
            ),
            14.g,
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  CustomText(text: seeker.fullName, fontSize: 15, fontWeight: FontWeight.w800),
                  4.g,
                  Row(
                    children: [
                      CustomText(text: seeker.position ?? seeker.city ?? 'Nomzod', fontSize: 12, color: Colors.grey.shade600, fontWeight: FontWeight.w500),
                      8.g,
                      const Icon(Icons.star, size: 14, color: AppColors.cF9A405),
                      3.g,
                      CustomText(text: seeker.rating.toStringAsFixed(1), fontSize: 12, color: Colors.black, fontWeight: FontWeight.w800),
                    ],
                  ),
                ],
              ),
            ),
            Column(
              crossAxisAlignment: CrossAxisAlignment.end,
              mainAxisSize: MainAxisSize.min,
              children: [
                Container(
                  padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 5),
                  decoration: BoxDecoration(color: statusConfig.backgroundColor, borderRadius: BorderRadius.circular(100)),
                  child: CustomText(text: _statusLabel(application.status), fontSize: 9, fontWeight: FontWeight.w900, color: statusConfig.textColor),
                ),
                6.g,
                CustomText(text: _formatTime(application.appliedAt), fontSize: 10, color: Colors.grey.shade400, fontWeight: FontWeight.w600),
              ],
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildAvatarFallback(String name) {
    return Image.network('https://ui-avatars.com/api/?name=$name&background=1F3C88&color=fff&size=128', fit: BoxFit.cover);
  }

  String _formatTime(DateTime dt) {
    final diff = DateTime.now().difference(dt);
    if (diff.inMinutes < 60) return '${diff.inMinutes}m oldin';
    if (diff.inHours < 24) return '${diff.inHours}h oldin';
    return DateFormat('dd MMM').format(dt);
  }

  String _statusLabel(String status) {
    switch (status) {
      case 'sent':
        return 'YANGI';
      case 'viewed':
        return "KO'RILDI";
      case 'shortlisted':
        return 'TANLANDI';
      case 'hired':
        return 'QABUL';
      case 'rejected':
        return 'RAD';
      default:
        return status.toUpperCase();
    }
  }

  ({Color textColor, Color backgroundColor}) _getStatusConfig(String status) {
    switch (status.toLowerCase()) {
      case 'sent':
        return (textColor: Colors.blue.shade700, backgroundColor: Colors.blue.shade50);
      case 'viewed':
        return (textColor: AppColors.cF9A405, backgroundColor: AppColors.cF9A405.withValues(alpha: 0.1));
      case 'shortlisted':
        return (textColor: Colors.green.shade700, backgroundColor: Colors.green.shade50);
      case 'hired':
        return (textColor: Colors.teal.shade700, backgroundColor: Colors.teal.shade50);
      case 'rejected':
        return (textColor: Colors.red.shade700, backgroundColor: Colors.red.shade50);
      default:
        return (textColor: AppColors.cF9A405, backgroundColor: AppColors.cF9A405.withValues(alpha: 0.1));
    }
  }
}
