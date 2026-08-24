import 'package:flutter/material.dart';
import 'package:speed_staff_mobile/config/config.dart';

class CandidateCoreSkills extends StatelessWidget {
  final List<String> skills;

  const CandidateCoreSkills({super.key, required this.skills});

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const CustomText(
          text: "Core Skills",
          fontSize: 18,
          fontWeight: FontWeight.w800,
        ),
        16.g,
        Wrap(
          spacing: 12,
          runSpacing: 12,
          children: skills.map((skill) => _buildSkillTag(skill)).toList(),
        ),
      ],
    );
  }

  Widget _buildSkillTag(String skill) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 10),
      decoration: BoxDecoration(
        color: AppColors.cF9A405.withValues(alpha: 0.1),
        borderRadius: BorderRadius.circular(100),
        border: Border.all(color: AppColors.cF9A405.withValues(alpha: 0.2)),
      ),
      child: CustomText(
        text: skill, 
        fontSize: 12, 
        color: AppColors.cF9A405, 
        fontWeight: FontWeight.w800,
      ),
    );
  }
}
