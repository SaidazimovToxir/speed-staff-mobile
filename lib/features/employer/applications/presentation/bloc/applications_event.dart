import 'package:equatable/equatable.dart';

abstract class ApplicationsEvent extends Equatable {
  const ApplicationsEvent();

  @override
  List<Object?> get props => [];
}

class LoadVacancyApplications extends ApplicationsEvent {
  final String vacancyId;
  const LoadVacancyApplications(this.vacancyId);

  @override
  List<Object?> get props => [vacancyId];
}

class LoadCandidateDetails extends ApplicationsEvent {
  final String candidateId;
  const LoadCandidateDetails(this.candidateId);

  @override
  List<Object?> get props => [candidateId];
}

class UpdateApplicationStatusEvent extends ApplicationsEvent {
  final String candidateId;
  final String newStatus;
  const UpdateApplicationStatusEvent({
    required this.candidateId,
    required this.newStatus,
  });

  @override
  List<Object?> get props => [candidateId, newStatus];
}
