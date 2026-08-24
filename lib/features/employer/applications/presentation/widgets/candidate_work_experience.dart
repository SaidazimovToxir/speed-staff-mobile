import 'package:flutter/material.dart';
import 'package:speed_staff_mobile/config/config.dart';
import 'package:speed_staff_mobile/features/employer/applications/presentation/widgets/experience_item.dart';

class CandidateWorkExperience extends StatelessWidget {
  final List<WorkExperienceData> experiences;
  const CandidateWorkExperience({super.key, required this.experiences});

  @override
  Widget build(BuildContext context) {
    if (experiences.isEmpty) return const SizedBox.shrink();
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const CustomText(
          text: "Work Experience",
          fontSize: 16,
          fontWeight: FontWeight.bold,
        ),
        16.g,
        ...experiences.map(
          (exp) => Padding(
            padding: const EdgeInsets.only(bottom: 20),
            child: ExperienceItem(experience: exp),
          ),
        ),
      ],
    );
  }
}
