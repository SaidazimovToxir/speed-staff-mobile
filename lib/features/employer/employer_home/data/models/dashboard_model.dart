import 'package:speed_staff_mobile/features/employer/employer_home/domain/entities/dashboard_entity.dart';

class DashboardStatsModel extends DashboardStats {
  const DashboardStatsModel({
    required super.activeVacancies,
    required super.pausedVacancies,
    required super.totalApplications,
    required super.newApplicationsToday,
    required super.totalViews,
    required super.profileComplete,
  });

  factory DashboardStatsModel.fromJson(Map<String, dynamic> json) {
    return DashboardStatsModel(
      activeVacancies: json['active_vacancies'] as int? ?? 0,
      pausedVacancies: json['paused_vacancies'] as int? ?? 0,
      totalApplications: json['total_applications'] as int? ?? 0,
      newApplicationsToday: json['new_applications_today'] as int? ?? 0,
      totalViews: json['total_views'] as int? ?? 0,
      profileComplete: json['profile_complete'] as bool? ?? false,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'active_vacancies': activeVacancies,
      'paused_vacancies': pausedVacancies,
      'total_applications': totalApplications,
      'new_applications_today': newApplicationsToday,
      'total_views': totalViews,
      'profile_complete': profileComplete,
    };
  }
}
