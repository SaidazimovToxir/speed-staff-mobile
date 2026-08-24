import 'package:flutter/material.dart';
import 'package:speed_staff_mobile/config/config.dart';
import 'package:speed_staff_mobile/features/employer/applications/domain/entities/application_entity.dart';

class CandidateProfileHeader extends StatelessWidget {
  final SeekerShortEntity seeker;
  const CandidateProfileHeader({super.key, required this.seeker});

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 20),
      child: Column(
        children: [
          Container(
            padding: const EdgeInsets.all(3),
            decoration: BoxDecoration(
              shape: BoxShape.circle,
              border: Border.all(color: AppColors.cF9A405.withValues(alpha: 0.3), width: 2),
            ),
            child: CircleAvatar(
              radius: 52,
              backgroundColor: AppColors.c1F3C88.withValues(alpha: 0.1),
              backgroundImage: seeker.avatarUrl != null
                  ? NetworkImage(seeker.avatarUrl!)
                  : NetworkImage('https://ui-avatars.com/api/?name=${seeker.fullName}&background=1F3C88&color=fff&size=256'),
              onBackgroundImageError: (_, _) {},
            ),
          ),
          20.g,
          CustomText(text: seeker.fullName, fontSize: 24, fontWeight: FontWeight.w800),
          6.g,
          if (seeker.position != null) CustomText(text: seeker.position!, fontSize: 15, fontWeight: FontWeight.w600, color: Colors.grey.shade600),
          if (seeker.city != null) ...[
            8.g,
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Icon(Icons.location_on_rounded, color: Colors.grey.shade400, size: 15),
                3.g,
                CustomText(text: seeker.city!, fontSize: 13, color: Colors.grey.shade500, fontWeight: FontWeight.w600),
              ],
            ),
          ],
          16.g,
          // Availability badge
          Container(
            padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 6),
            decoration: BoxDecoration(color: seeker.isAvailable ? Colors.green.shade50 : Colors.grey.shade100, borderRadius: BorderRadius.circular(100)),
            child: Row(
              mainAxisSize: MainAxisSize.min,
              children: [
                Container(
                  width: 8,
                  height: 8,
                  decoration: BoxDecoration(color: seeker.isAvailable ? Colors.green : Colors.grey, shape: BoxShape.circle),
                ),
                6.g,
                CustomText(
                  text: seeker.isAvailable ? "Mavjud" : "Band",
                  fontSize: 12,
                  fontWeight: FontWeight.w700,
                  color: seeker.isAvailable ? Colors.green.shade700 : Colors.grey.shade600,
                ),
              ],
            ),
          ),
          24.g,
          Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [_buildStatCard(icon: Icons.star_rounded, color: AppColors.cF9A405, label: "Reyting", value: '${seeker.rating.toStringAsFixed(1)}/5.0')],
          ),
        ],
      ),
    );
  }

  Widget _buildStatCard({required IconData icon, required Color color, required String label, required String value}) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 14),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(16),
        border: Border.all(color: Colors.grey.shade100),
        boxShadow: [BoxShadow(color: Colors.black.withValues(alpha: 0.03), blurRadius: 10, offset: const Offset(0, 4))],
      ),
      child: Row(
        children: [
          Icon(icon, color: color, size: 22),
          10.g,
          Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              CustomText(text: label, fontSize: 11, color: Colors.grey.shade500, fontWeight: FontWeight.w600),
              3.g,
              CustomText(text: value, fontSize: 14, fontWeight: FontWeight.w800),
            ],
          ),
        ],
      ),
    );
  }
}
