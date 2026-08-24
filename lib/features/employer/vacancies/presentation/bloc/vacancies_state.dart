import 'package:speed_staff_mobile/features/employer/vacancies/domain/entities/vacancy_entity.dart';

enum VacanciesStatus { initial, loading, success, failure }

class VacanciesState {
  final VacanciesStatus status;
  final List<Vacancy> vacancies;
  final String? errorMessage;
  // Use a separate flag/message for form submissions like Create/Update to avoid full list reload flashing
  final VacanciesStatus actionStatus;
  final String? actionErrorMessage;

  const VacanciesState({
    this.status = VacanciesStatus.initial,
    this.vacancies = const [],
    this.errorMessage,
    this.actionStatus = VacanciesStatus.initial,
    this.actionErrorMessage,
  });

  VacanciesState copyWith({
    VacanciesStatus? status,
    List<Vacancy>? vacancies,
    String? errorMessage,
    VacanciesStatus? actionStatus,
    String? actionErrorMessage,
  }) {
    return VacanciesState(
      status: status ?? this.status,
      vacancies: vacancies ?? this.vacancies,
      errorMessage: errorMessage ?? this.errorMessage,
      actionStatus: actionStatus ?? this.actionStatus,
      actionErrorMessage: actionErrorMessage ?? this.actionErrorMessage,
    );
  }
}
