import 'package:flutter/material.dart';
import 'package:speed_staff_mobile/config/config.dart';
import 'package:speed_staff_mobile/features/employer/applications/domain/entities/application_entity.dart';
import 'package:speed_staff_mobile/features/employer/applications/presentation/widgets/candidate_list_item.dart';

class ApplicationsListView extends StatelessWidget {
  final List<ApplicationShortEntity> applications;
  const ApplicationsListView({super.key, required this.applications});

  @override
  Widget build(BuildContext context) {
    if (applications.isEmpty) {
      return const Center(
        child: CustomText(
          text: 'Arizalar mavjud emas',
          color: Colors.grey,
          fontSize: 14,
        ),
      );
    }
    return ListView.separated(
      padding: const EdgeInsets.all(16),
      itemCount: applications.length,
      separatorBuilder: (context, index) => 12.g,
      itemBuilder: (context, index) => CandidateListItem(application: applications[index]),
    );
  }
}
