import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:speed_staff_mobile/features/seeker/vacancies/domain/repositories/vacancy_feed_repository.dart';
import 'package:speed_staff_mobile/features/seeker/vacancies/presentation/bloc/vacancy_feed_event.dart';
import 'package:speed_staff_mobile/features/seeker/vacancies/presentation/bloc/vacancy_feed_state.dart';

class VacancyFeedBloc extends Bloc<VacancyFeedEvent, VacancyFeedState> {
  final VacancyFeedRepository _repository;

  String? _lastPosition;
  String? _lastCity;
  String? _lastWorkType;
  String? _lastQuery;
  bool _isSearchMode = false;

  VacancyFeedBloc(this._repository) : super(const VacancyFeedState()) {
    on<LoadVacancyFeed>(_onLoadFeed);
    on<LoadMoreVacancies>(_onLoadMore);
    on<LoadVacancyDetail>(_onLoadDetail);
    on<SearchVacancies>(_onSearch);
    on<LoadSavedVacancies>(_onLoadSaved);
    on<SaveVacancy>(_onSave);
    on<RemoveSavedVacancy>(_onRemoveSaved);
  }

  Future<void> _onLoadFeed(LoadVacancyFeed event, Emitter<VacancyFeedState> emit) async {
    emit(state.copyWith(status: VacancyFeedStatus.loading));
    _isSearchMode = false;
    _lastPosition = event.position;
    _lastCity = event.city;
    _lastWorkType = event.workType;
    final result = await _repository.getVacancyFeed(
      position: event.position, city: event.city, workType: event.workType, page: 1,
    );
    result.fold(
      (failure) => emit(state.copyWith(status: VacancyFeedStatus.failure, errorMessage: failure.message)),
      (paginated) => emit(state.copyWith(
        status: VacancyFeedStatus.success,
        vacancies: paginated.items,
        hasNext: paginated.hasNext,
        currentPage: 1,
      )),
    );
  }

  Future<void> _onLoadMore(LoadMoreVacancies event, Emitter<VacancyFeedState> emit) async {
    if (!state.hasNext || state.status == VacancyFeedStatus.loadingMore) return;
    emit(state.copyWith(status: VacancyFeedStatus.loadingMore));
    final nextPage = state.currentPage + 1;
    final result = _isSearchMode
        ? await _repository.searchVacancies(q: _lastQuery, position: _lastPosition, city: _lastCity, page: nextPage)
        : await _repository.getVacancyFeed(position: _lastPosition, city: _lastCity, workType: _lastWorkType, page: nextPage);
    result.fold(
      (failure) => emit(state.copyWith(status: VacancyFeedStatus.failure, errorMessage: failure.message)),
      (paginated) => emit(state.copyWith(
        status: VacancyFeedStatus.success,
        vacancies: [...state.vacancies, ...paginated.items],
        hasNext: paginated.hasNext,
        currentPage: nextPage,
      )),
    );
  }

  Future<void> _onLoadDetail(LoadVacancyDetail event, Emitter<VacancyFeedState> emit) async {
    emit(state.copyWith(status: VacancyFeedStatus.loading));
    final result = await _repository.getVacancyDetail(event.vacancyId);
    result.fold(
      (failure) => emit(state.copyWith(status: VacancyFeedStatus.failure, errorMessage: failure.message)),
      (vacancy) => emit(state.copyWith(status: VacancyFeedStatus.success, selectedVacancy: vacancy)),
    );
  }

  Future<void> _onSearch(SearchVacancies event, Emitter<VacancyFeedState> emit) async {
    emit(state.copyWith(status: VacancyFeedStatus.loading));
    _isSearchMode = true;
    _lastQuery = event.q;
    _lastPosition = event.position;
    _lastCity = event.city;
    final result = await _repository.searchVacancies(
      q: event.q, position: event.position, city: event.city, workType: event.workType, page: 1,
    );
    result.fold(
      (failure) => emit(state.copyWith(status: VacancyFeedStatus.failure, errorMessage: failure.message)),
      (paginated) => emit(state.copyWith(
        status: VacancyFeedStatus.success,
        vacancies: paginated.items,
        hasNext: paginated.hasNext,
        currentPage: 1,
      )),
    );
  }

  Future<void> _onLoadSaved(LoadSavedVacancies event, Emitter<VacancyFeedState> emit) async {
    emit(state.copyWith(status: VacancyFeedStatus.loading));
    final result = await _repository.getSavedVacancies();
    result.fold(
      (failure) => emit(state.copyWith(status: VacancyFeedStatus.failure, errorMessage: failure.message)),
      (paginated) => emit(state.copyWith(
        status: VacancyFeedStatus.success,
        vacancies: paginated.items,
        savedVacancyIds: paginated.items.map((v) => v.id).toSet(),
      )),
    );
  }

  Future<void> _onSave(SaveVacancy event, Emitter<VacancyFeedState> emit) async {
    final result = await _repository.saveVacancy(event.vacancyId);
    result.fold(
      (failure) => emit(state.copyWith(errorMessage: failure.message)),
      (msg) {
        final updated = Set<String>.from(state.savedVacancyIds)..add(event.vacancyId);
        emit(state.copyWith(savedVacancyIds: updated, saveMessage: msg));
      },
    );
  }

  Future<void> _onRemoveSaved(RemoveSavedVacancy event, Emitter<VacancyFeedState> emit) async {
    final result = await _repository.removeSavedVacancy(event.vacancyId);
    result.fold(
      (failure) => emit(state.copyWith(errorMessage: failure.message)),
      (msg) {
        final updated = Set<String>.from(state.savedVacancyIds)..remove(event.vacancyId);
        // Also remove from vacancies list if we're viewing saved tab
        final updatedVacancies = state.vacancies.where((v) => v.id != event.vacancyId).toList();
        emit(state.copyWith(savedVacancyIds: updated, saveMessage: msg, vacancies: updatedVacancies));
      },
    );
  }
}
