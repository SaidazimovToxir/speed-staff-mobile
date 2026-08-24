import 'package:equatable/equatable.dart';
import 'package:speed_staff_mobile/features/seeker/vacancies/domain/entities/vacancy.dart';

enum VacancyFeedStatus { initial, loading, success, failure, loadingMore }

class VacancyFeedState extends Equatable {
  final VacancyFeedStatus status;
  final List<Vacancy> vacancies;
  final Vacancy? selectedVacancy;
  final String? errorMessage;
  final bool hasNext;
  final int currentPage;
  final Set<String> savedVacancyIds; // track which are saved locally
  final String? saveMessage;

  const VacancyFeedState({
    this.status = VacancyFeedStatus.initial,
    this.vacancies = const [],
    this.selectedVacancy,
    this.errorMessage,
    this.hasNext = false,
    this.currentPage = 1,
    this.savedVacancyIds = const {},
    this.saveMessage,
  });

  VacancyFeedState copyWith({
    VacancyFeedStatus? status,
    List<Vacancy>? vacancies,
    Vacancy? selectedVacancy,
    String? errorMessage,
    bool? hasNext,
    int? currentPage,
    Set<String>? savedVacancyIds,
    String? saveMessage,
  }) {
    return VacancyFeedState(
      status: status ?? this.status,
      vacancies: vacancies ?? this.vacancies,
      selectedVacancy: selectedVacancy ?? this.selectedVacancy,
      errorMessage: errorMessage,
      hasNext: hasNext ?? this.hasNext,
      currentPage: currentPage ?? this.currentPage,
      savedVacancyIds: savedVacancyIds ?? this.savedVacancyIds,
      saveMessage: saveMessage,
    );
  }

  @override
  List<Object?> get props => [status, vacancies, selectedVacancy, errorMessage, hasNext, currentPage, savedVacancyIds, saveMessage];
}
