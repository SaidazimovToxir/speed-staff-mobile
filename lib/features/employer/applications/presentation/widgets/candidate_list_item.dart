import 'package:speed_staff_mobile/features/employer/applications/domain/entities/application_entity.dart';
import 'package:flutter/material.dart';
import 'package:speed_staff_mobile/config/config.dart';
import 'package:go_router/go_router.dart';

class CandidateListItem extends StatelessWidget {
  final CandidateEntity candidate;
  const CandidateListItem({super.key, required this.candidate});
  @override
  Widget build(BuildContext context) {
    final statusConfig = _getStatusConfig(candidate.role ?? "New");
    return InkWell(
      onTap: () =>
          context.push("${RouteNames.candidateProfile}/${candidate.id}"),
      child: Container(
        padding: const EdgeInsets.all(16),
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(20),
          boxShadow: [
            BoxShadow(
              color: Colors.black.withValues(alpha: 0.04),
              blurRadius: 12,
              offset: const Offset(0, 4),
            )
          ],
          border: Border.all(color: Colors.grey.shade100),
        ),
        child: Row(
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            Container(
              width: 52,
              height: 52,
              decoration: BoxDecoration(
                shape: BoxShape.circle,
                color: AppColors.c1F3C88.withValues(alpha: 0.05),
                image: DecorationImage(
                  image: NetworkImage(
                    'https://ui-avatars.com/api/?name=${candidate.name}&background=random&size=128',
                  ),
                  fit: BoxFit.cover,
                ),
              ),
              child: candidate.name.isEmpty 
                ? const Icon(Icons.person, color: Colors.grey)
                : null,
            ),
            14.g,
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                   CustomText(
                    text: candidate.name,
                    fontSize: 15,
                    fontWeight: FontWeight.w800,
                  ),
                  4.g,
                  Row(
                    children: [
                      CustomText(
                        text: candidate.role ?? "Candidate",
                        fontSize: 12,
                        color: Colors.grey.shade600,
                        fontWeight: FontWeight.w500,
                      ),
                      8.g,
                      const Icon(Icons.star, size: 14, color: AppColors.cF9A405),
                      4.g,
                      CustomText(
                        text: candidate.rating,
                        fontSize: 12,
                        color: Colors.black,
                        fontWeight: FontWeight.w800,
                      ),
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
                  decoration: BoxDecoration(
                    color: statusConfig.backgroundColor,
                    borderRadius: BorderRadius.circular(100),
                  ),
                  child: CustomText(
                    text: (candidate.role ?? "NEW").toUpperCase(),
                    fontSize: 9,
                    fontWeight: FontWeight.w900,
                    color: statusConfig.textColor,
                  ),
                ),
                8.g,
                CustomText(
                  text: "2h ago",
                  fontSize: 10,
                  color: Colors.grey.shade400,
                  fontWeight: FontWeight.w600,
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }

  ({Color textColor, Color backgroundColor}) _getStatusConfig(String status) {
    final lower = status.toLowerCase();
    if (lower.contains('interviewing')) {
      return (textColor: Colors.blue.shade700, backgroundColor: Colors.blue.shade50);
    } else if (lower.contains('shortlisted')) {
       return (textColor: Colors.green.shade700, backgroundColor: Colors.green.shade50);
    } else if (lower.contains('recruited') || lower.contains('hired')) {
       return (textColor: Colors.teal.shade700, backgroundColor: Colors.teal.shade50);
    } else if (lower.contains('rejected')) {
       return (textColor: Colors.red.shade700, backgroundColor: Colors.red.shade50);
    }
    // Default or "New"
    return (textColor: AppColors.cF9A405, backgroundColor: AppColors.cF9A405.withValues(alpha: 0.1));
  }
}
