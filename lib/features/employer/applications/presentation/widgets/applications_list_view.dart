import 'package:speed_staff_mobile/config/core/extensions/size_extension.dart';
import 'package:speed_staff_mobile/features/employer/applications/domain/entities/application_entity.dart';
import 'package:flutter/material.dart';
import 'package:speed_staff_mobile/features/employer/applications/presentation/widgets/candidate_list_item.dart';

class ApplicationsListView extends StatelessWidget {
  final List<CandidateEntity> candidates;
  const ApplicationsListView({super.key, required this.candidates});
  @override
  Widget build(BuildContext context) {
    return ListView.separated(
      padding: const EdgeInsets.all(20),
      itemCount: candidates.length,
      separatorBuilder: (context, index) => 12.g,
      itemBuilder: (context, index) =>
          CandidateListItem(candidate: candidates[index]),
    );
  }
}
