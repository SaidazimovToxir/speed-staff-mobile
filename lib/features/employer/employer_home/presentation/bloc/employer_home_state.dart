import 'package:speed_staff_mobile/features/employer/employer_home/domain/entities/dashboard_entity.dart';
import 'package:speed_staff_mobile/features/employer/applications/domain/entities/application_entity.dart';
import 'package:equatable/equatable.dart';

abstract class EmployerHomeState extends Equatable {
  const EmployerHomeState();
  @override
  List<Object?> get props => [];
}

class EmployerHomeInitial extends EmployerHomeState {}

class EmployerHomeLoading extends EmployerHomeState {}

class EmployerHomeLoaded extends EmployerHomeState {
  final EmployerStatsEntity stats;
  final List<ApplicationEntity> recentApplications;
  const EmployerHomeLoaded({
    required this.stats,
    required this.recentApplications,
  });
  @override
  List<Object?> get props => [stats, recentApplications];
}

class EmployerHomeError extends EmployerHomeState {
  final String message;
  const EmployerHomeError(this.message);
  @override
  List<Object?> get props => [message];
}
