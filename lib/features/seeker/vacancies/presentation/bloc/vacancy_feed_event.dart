import 'package:equatable/equatable.dart';

abstract class VacancyFeedEvent extends Equatable {
  const VacancyFeedEvent();
  @override
  List<Object?> get props => [];
}

class LoadVacancyFeed extends VacancyFeedEvent {
  final String? position;
  final String? city;
  final String? workType;
  const LoadVacancyFeed({this.position, this.city, this.workType});
  @override
  List<Object?> get props => [position, city, workType];
}

class LoadMoreVacancies extends VacancyFeedEvent {
  const LoadMoreVacancies();
}

class LoadVacancyDetail extends VacancyFeedEvent {
  final String vacancyId;
  const LoadVacancyDetail(this.vacancyId);
  @override
  List<Object?> get props => [vacancyId];
}

class SearchVacancies extends VacancyFeedEvent {
  final String? q;
  final String? position;
  final String? city;
  final String? workType;
  const SearchVacancies({this.q, this.position, this.city, this.workType});
  @override
  List<Object?> get props => [q, position, city, workType];
}

class LoadSavedVacancies extends VacancyFeedEvent {
  const LoadSavedVacancies();
}

class SaveVacancy extends VacancyFeedEvent {
  final String vacancyId;
  const SaveVacancy(this.vacancyId);
  @override
  List<Object?> get props => [vacancyId];
}

class RemoveSavedVacancy extends VacancyFeedEvent {
  final String vacancyId;
  const RemoveSavedVacancy(this.vacancyId);
  @override
  List<Object?> get props => [vacancyId];
}
