import 'package:equatable/equatable.dart';
import 'package:speed_staff_mobile/features/employer/applications/domain/entities/application_entity.dart';

abstract class ApplicationsState extends Equatable {
  const ApplicationsState();
  @override
  List<Object?> get props => [];
}

class ApplicationsInitial extends ApplicationsState {}

class ApplicationsLoading extends ApplicationsState {}

class ApplicationsLoaded extends ApplicationsState {
  final PaginatedApplications paginated;
  final String vacancyId;
  final String? activeStatus;

  const ApplicationsLoaded(this.paginated, {required this.vacancyId, this.activeStatus});

  @override
  List<Object?> get props => [paginated, vacancyId, activeStatus];
}

class ApplicationDetailLoaded extends ApplicationsState {
  final ApplicationDetailEntity application;
  const ApplicationDetailLoaded(this.application);

  @override
  List<Object?> get props => [application];
}

class ApplicationStatusUpdating extends ApplicationsState {
  final ApplicationDetailEntity application;
  const ApplicationStatusUpdating(this.application);

  @override
  List<Object?> get props => [application];
}

class ApplicationStatusUpdated extends ApplicationsState {
  final ApplicationDetailEntity application;
  const ApplicationStatusUpdated(this.application);

  @override
  List<Object?> get props => [application];
}

class ApplicationsError extends ApplicationsState {
  final String message;
  const ApplicationsError(this.message);
  @override
  List<Object?> get props => [message];
}
