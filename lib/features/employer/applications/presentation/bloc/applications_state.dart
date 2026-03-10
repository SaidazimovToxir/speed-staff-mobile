import 'package:speed_staff_mobile/features/employer/applications/domain/entities/application_entity.dart';
import 'package:equatable/equatable.dart';

abstract class ApplicationsState extends Equatable {
  const ApplicationsState();
  @override
  List<Object?> get props => [];
}

class ApplicationsInitial extends ApplicationsState {}

class ApplicationsLoading extends ApplicationsState {}

class ApplicationsLoaded extends ApplicationsState {
  final List<CandidateEntity> candidates;
  const ApplicationsLoaded(this.candidates);
  @override
  List<Object?> get props => [candidates];
}

class CandidateDetailsLoaded extends ApplicationsState {
  final CandidateEntity candidate;
  const CandidateDetailsLoaded(this.candidate);
  @override
  List<Object?> get props => [candidate];
}

class ApplicationStatusUpdated extends ApplicationsState {
  final String newStatus;
  const ApplicationStatusUpdated(this.newStatus);
  @override
  List<Object?> get props => [newStatus];
}

class ApplicationsError extends ApplicationsState {
  final String message;
  const ApplicationsError(this.message);
  @override
  List<Object?> get props => [message];
}
