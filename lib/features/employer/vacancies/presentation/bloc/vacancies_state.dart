import 'package:speed_staff_mobile/features/employer/vacancies/domain/entities/vacancy_entity.dart';
import 'package:equatable/equatable.dart';

abstract class VacanciesState extends Equatable {
  const VacanciesState();
  @override
  List<Object?> get props => [];
}

class VacanciesInitial extends VacanciesState {}

class VacanciesLoading extends VacanciesState {}

class VacanciesLoaded extends VacanciesState {
  final List<VacancyEntity> vacancies;
  const VacanciesLoaded(this.vacancies);
  @override
  List<Object?> get props => [vacancies];
}

class VacancyCreated extends VacanciesState {}

class VacanciesError extends VacanciesState {
  final String message;
  const VacanciesError(this.message);
  @override
  List<Object?> get props => [message];
}
