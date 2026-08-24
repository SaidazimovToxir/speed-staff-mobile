import 'package:equatable/equatable.dart';
import 'package:speed_staff_mobile/features/seeker/applications/domain/entities/application.dart';

enum ApplicationStatus { initial, loading, success, failure }

class ApplicationState extends Equatable {
  final ApplicationStatus status;
  final List<Application> applications;
  final String? errorMessage;
  final String? successMessage;

  const ApplicationState({
    this.status = ApplicationStatus.initial,
    this.applications = const [],
    this.errorMessage,
    this.successMessage,
  });

  ApplicationState copyWith({
    ApplicationStatus? status,
    List<Application>? applications,
    String? errorMessage,
    String? successMessage,
  }) {
    return ApplicationState(
      status: status ?? this.status,
      applications: applications ?? this.applications,
      errorMessage: errorMessage,
      successMessage: successMessage,
    );
  }

  @override
  List<Object?> get props => [status, applications, errorMessage, successMessage];
}

abstract class ApplicationEvent extends Equatable {
  const ApplicationEvent();
  @override
  List<Object?> get props => [];
}

class ApplyForVacancy extends ApplicationEvent {
  final String vacancyId;
  final String? coverLetter;
  const ApplyForVacancy(this.vacancyId, {this.coverLetter});
  @override
  List<Object?> get props => [vacancyId, coverLetter];
}

class LoadMyApplications extends ApplicationEvent {
  const LoadMyApplications();
}

class WithdrawApplication extends ApplicationEvent {
  final String applicationId;
  const WithdrawApplication(this.applicationId);
  @override
  List<Object?> get props => [applicationId];
}
