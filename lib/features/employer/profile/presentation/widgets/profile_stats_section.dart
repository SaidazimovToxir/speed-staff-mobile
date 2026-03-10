import 'package:flutter/material.dart';
import 'package:speed_staff_mobile/config/core/extensions/size_extension.dart';
import 'package:speed_staff_mobile/config/widgets/custom_text.dart';
import 'package:speed_staff_mobile/features/employer/profile/presentation/widgets/stat_item.dart';

class ProfileStatsSection extends StatelessWidget {
  final Map<String, dynamic> data;

  const ProfileStatsSection({super.key, required this.data});

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceAround,
      children: [
        _buildInfoItem(Icons.location_on, "Downtown Area"),
        _buildInfoItem(Icons.people_alt_outlined, "400 employees"),
        _buildInfoItem(Icons.calendar_today_outlined, "Est. 2015"),
      ],
    );
  }

  Widget _buildInfoItem(IconData icon, String text) {
    return Column(
      children: [
        Container(
           padding: const EdgeInsets.all(12),
           decoration: BoxDecoration(
              color: Colors.grey.shade100,
              shape: BoxShape.circle,
           ),
           child: Icon(icon, color: Colors.grey.shade700, size: 24),
        ),
        8.g,
        CustomText(text: text, fontSize: 12, color: Colors.grey.shade700, fontWeight: FontWeight.bold),
      ],
    );
  }
}
