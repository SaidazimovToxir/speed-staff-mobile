import 'package:equatable/equatable.dart';

abstract class VacanciesEvent extends Equatable {
  const VacanciesEvent();

  @override
  List<Object?> get props => [];
}

class LoadMyVacancies extends VacanciesEvent {
  final int page;
  final int limit;

  const LoadMyVacancies({this.page = 1, this.limit = 50});

  @override
  List<Object?> get props => [page, limit];
}

class CreateVacancy extends VacanciesEvent {
  final Map<String, dynamic> data;

  const CreateVacancy(this.data);

  @override
  List<Object?> get props => [data];
}

class UpdateVacancy extends VacanciesEvent {
  final String id;
  final Map<String, dynamic> data;

  const UpdateVacancy(this.id, this.data);

  @override
  List<Object?> get props => [id, data];
}

class ChangeVacancyStatus extends VacanciesEvent {
  final String id;
  final String status;

  const ChangeVacancyStatus(this.id, this.status);

  @override
  List<Object?> get props => [id, status];
}

class DeleteVacancy extends VacanciesEvent {
  final String id;

  const DeleteVacancy(this.id);

  @override
  List<Object?> get props => [id];
}
