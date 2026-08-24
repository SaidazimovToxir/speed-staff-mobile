import 'package:speed_staff_mobile/features/employer/profile/domain/entities/employer_profile.dart';

class Vacancy {
  final String? id;
  final String title;
  final String position;
  final String description;
  final String workType;
  final String salaryType;
  final int? salaryMin;
  final int? salaryMax;
  final int experienceMin;
  final int? experienceMax;
  final String? requirements;
  final String? schedule;
  final String? status;
  final int? viewsCount;
  final int? applicationsCount;
  final EmployerProfile? employer;

  const Vacancy({
    this.id,
    required this.title,
    required this.position,
    required this.description,
    required this.workType,
    this.salaryType = 'negotiable',
    this.salaryMin,
    this.salaryMax,
    this.experienceMin = 0,
    this.experienceMax,
    this.requirements,
    this.schedule,
    this.status,
    this.viewsCount,
    this.applicationsCount,
    this.employer,
  });
}
