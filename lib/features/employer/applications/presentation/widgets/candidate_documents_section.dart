import 'package:speed_staff_mobile/features/employer/applications/domain/entities/application_entity.dart';
import 'package:flutter/material.dart';
import 'package:speed_staff_mobile/config/config.dart';
import 'package:speed_staff_mobile/features/employer/applications/presentation/widgets/document_item.dart';

class CandidateDocumentsSection extends StatelessWidget {
  final List<DocumentEntity> documents;
  const CandidateDocumentsSection({super.key, required this.documents});
  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const CustomText(
          text: "Certifications",
          fontSize: 16,
          fontWeight: FontWeight.bold,
        ),
        16.g,
        ...documents.map(
          (doc) => Padding(
            padding: const EdgeInsets.only(bottom: 12),
            child: DocumentItem(document: doc),
          ),
        ),
      ],
    );
  }
}
