import 'package:speed_staff_mobile/features/employer/profile/data/models/employer_profile_model.dart';
import 'package:speed_staff_mobile/features/employer/vacancies/domain/entities/vacancy_entity.dart';

class VacancyModel extends Vacancy {
  const VacancyModel({
    super.id,
    required super.title,
    required super.position,
    required super.description,
    required super.workType,
    super.salaryType = 'negotiable',
    super.salaryMin,
    super.salaryMax,
    super.experienceMin = 0,
    super.experienceMax,
    super.requirements,
    super.schedule,
    super.status,
    super.viewsCount,
    super.applicationsCount,
    super.employer,
  });

  factory VacancyModel.fromJson(Map<String, dynamic> json) {
    return VacancyModel(
      id: json['id'] as String?,
      title: json['title'] as String? ?? '',
      position: json['position'] as String? ?? '',
      description: json['description'] as String? ?? '',
      workType: json['work_type'] as String? ?? '',
      salaryType: json['salary_type'] as String? ?? 'negotiable',
      salaryMin: json['salary_min'] as int?,
      salaryMax: json['salary_max'] as int?,
      experienceMin: json['experience_min'] as int? ?? 0,
      experienceMax: json['experience_max'] as int?,
      requirements: json['requirements'] as String?,
      schedule: json['schedule'] as String?,
      status: json['status'] as String?,
      viewsCount: json['views_count'] as int?,
      applicationsCount: json['applications_count'] as int?,
      employer: json['employer'] != null ? EmployerProfileModel.fromJson(json['employer'] as Map<String, dynamic>) : null,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'title': title,
      'position': position,
      'description': description,
      'work_type': workType,
      'salary_type': salaryType,
      'salary_min': salaryMin,
      'salary_max': salaryMax,
      'experience_min': experienceMin,
      'experience_max': experienceMax,
      'requirements': requirements,
      'schedule': schedule,
      'status': status,
      'views_count': viewsCount,
      'applications_count': applicationsCount,
      if (employer != null) 'employer': (employer as EmployerProfileModel).toJson(),
    };
  }
}
