import 'package:speed_staff_mobile/features/employer/employer_home/domain/entities/dashboard_entity.dart';

enum DashboardStatus { initial, loading, success, failure }

class EmployerHomeState {
  final DashboardStatus status;
  final DashboardStats? stats;
  final String? errorMessage;

  const EmployerHomeState({
    this.status = DashboardStatus.initial,
    this.stats,
    this.errorMessage,
  });

  EmployerHomeState copyWith({
    DashboardStatus? status,
    DashboardStats? stats,
    String? errorMessage,
  }) {
    return EmployerHomeState(
      status: status ?? this.status,
      stats: stats ?? this.stats,
      errorMessage: errorMessage ?? this.errorMessage,
    );
  }
}
