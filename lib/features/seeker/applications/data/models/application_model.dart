import 'package:speed_staff_mobile/features/seeker/applications/domain/entities/application.dart';
import 'package:speed_staff_mobile/features/seeker/vacancies/data/models/vacancy_model.dart';

class ApplicationModel extends Application {
  const ApplicationModel({
    required super.id,
    required super.status,
    super.coverLetter,
    super.employerNote,
    super.appliedAt,
    super.viewedAt,
    super.vacancy,
  });

  factory ApplicationModel.fromJson(Map<String, dynamic> json) {
    final vacancyJson = json['vacancy'] as Map<String, dynamic>?;
    return ApplicationModel(
      id: json['id']?.toString() ?? '',
      status: json['status']?.toString() ?? 'sent',
      coverLetter: json['cover_letter']?.toString(),
      employerNote: json['employer_note']?.toString(),
      appliedAt: json['applied_at'] != null ? DateTime.tryParse(json['applied_at']) : null,
      viewedAt: json['viewed_at'] != null ? DateTime.tryParse(json['viewed_at']) : null,
      vacancy: vacancyJson != null ? VacancyModel.fromJson(vacancyJson) : null,
    );
  }
}
