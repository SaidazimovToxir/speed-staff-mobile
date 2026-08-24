class DashboardStats {
  final int activeVacancies;
  final int pausedVacancies;
  final int totalApplications;
  final int newApplicationsToday;
  final int totalViews;
  final bool profileComplete;

  const DashboardStats({
    required this.activeVacancies,
    required this.pausedVacancies,
    required this.totalApplications,
    required this.newApplicationsToday,
    required this.totalViews,
    required this.profileComplete,
  });
}
