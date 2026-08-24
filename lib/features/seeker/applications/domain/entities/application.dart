import 'package:speed_staff_mobile/features/seeker/vacancies/domain/entities/vacancy.dart';

class Application {
  final String id;
  final String status;
  final String? coverLetter;
  final String? employerNote;
  final DateTime? appliedAt;
  final DateTime? viewedAt;
  final Vacancy? vacancy;

  const Application({
    required this.id,
    required this.status,
    this.coverLetter,
    this.employerNote,
    this.appliedAt,
    this.viewedAt,
    this.vacancy,
  });
}
