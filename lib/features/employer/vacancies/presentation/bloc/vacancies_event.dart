import 'package:speed_staff_mobile/features/employer/vacancies/domain/entities/vacancy_entity.dart';
import 'package:equatable/equatable.dart';

abstract class VacanciesEvent extends Equatable {
  const VacanciesEvent();
  @override
  List<Object?> get props => [];
}

class LoadMyVacancies extends VacanciesEvent {}

class CreateVacancyEvent extends VacanciesEvent {
  final VacancyEntity vacancy;
  const CreateVacancyEvent(this.vacancy);
  @override
  List<Object?> get props => [vacancy];
}
