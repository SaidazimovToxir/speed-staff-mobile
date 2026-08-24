import 'package:equatable/equatable.dart';

abstract class ApplicationsEvent extends Equatable {
  const ApplicationsEvent();

  @override
  List<Object?> get props => [];
}

class LoadVacancyApplications extends ApplicationsEvent {
  final String vacancyId;
  final String? status;
  final int page;
  final int limit;

  const LoadVacancyApplications(
    this.vacancyId, {
    this.status,
    this.page = 1,
    this.limit = 50,
  });

  @override
  List<Object?> get props => [vacancyId, status, page, limit];
}

class LoadApplicationDetail extends ApplicationsEvent {
  final String applicationId;
  const LoadApplicationDetail(this.applicationId);

  @override
  List<Object?> get props => [applicationId];
}

class UpdateApplicationStatusEvent extends ApplicationsEvent {
  final String applicationId;
  final String newStatus;
  final String? employerNote;

  const UpdateApplicationStatusEvent({
    required this.applicationId,
    required this.newStatus,
    this.employerNote,
  });

  @override
  List<Object?> get props => [applicationId, newStatus, employerNote];
}
