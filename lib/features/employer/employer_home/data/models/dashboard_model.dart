import 'package:speed_staff_mobile/features/employer/employer_home/domain/entities/dashboard_entity.dart';

class EmployerStatsModel extends EmployerStatsEntity {
  const EmployerStatsModel({
    required super.activeVacancies,
    required super.totalApplications,
    required super.newToday,
  });
  factory EmployerStatsModel.fromJson(Map<String, dynamic> json) {
    return EmployerStatsModel(
      activeVacancies: json['active_vacancies'] as String,
      totalApplications: json['total_applications'] as String,
      newToday: json['new_today'] as String,
    );
  }
  Map<String, dynamic> toJson() {
    return {
      'active_vacancies': activeVacancies,
      'total_applications': totalApplications,
      'new_today': newToday,
    };
  }
}
