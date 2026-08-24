import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:speed_staff_mobile/features/employer/vacancies/domain/entities/vacancy_entity.dart';
import 'package:speed_staff_mobile/features/employer/vacancies/domain/repositories/vacancy_repository.dart';
import 'package:speed_staff_mobile/features/employer/vacancies/presentation/bloc/vacancies_event.dart';
import 'package:speed_staff_mobile/features/employer/vacancies/presentation/bloc/vacancies_state.dart';

class VacanciesBloc extends Bloc<VacanciesEvent, VacanciesState> {
  final VacanciesRepository repository;

  VacanciesBloc(this.repository) : super(const VacanciesState()) {
    on<LoadMyVacancies>(_onLoadMyVacancies);
    on<CreateVacancy>(_onCreateVacancy);
    on<UpdateVacancy>(_onUpdateVacancy);
    on<ChangeVacancyStatus>(_onChangeVacancyStatus);
    on<DeleteVacancy>(_onDeleteVacancy);
  }

  Future<void> _onLoadMyVacancies(LoadMyVacancies event, Emitter<VacanciesState> emit) async {
    emit(state.copyWith(status: VacanciesStatus.loading));
    final result = await repository.getMyVacancies(page: event.page, limit: event.limit);
    result.fold(
      (failure) {
        emit(state.copyWith(status: VacanciesStatus.failure, errorMessage: failure.message));
      },
      (vacancies) {
        emit(state.copyWith(status: VacanciesStatus.success, vacancies: vacancies));
      },
    );
  }

  Future<void> _onCreateVacancy(CreateVacancy event, Emitter<VacanciesState> emit) async {
    emit(state.copyWith(actionStatus: VacanciesStatus.loading));
    final result = await repository.createVacancy(event.data);
    result.fold(
      (failure) {
        emit(state.copyWith(actionStatus: VacanciesStatus.failure, actionErrorMessage: failure.message));
      },
      (vacancy) {
        final updatedVacancies = List.of(state.vacancies)..insert(0, vacancy);
        emit(state.copyWith(actionStatus: VacanciesStatus.success, vacancies: updatedVacancies));
      },
    );
  }

  Future<void> _onUpdateVacancy(UpdateVacancy event, Emitter<VacanciesState> emit) async {
    emit(state.copyWith(actionStatus: VacanciesStatus.loading));
    final result = await repository.updateVacancy(event.id, event.data);
    result.fold(
      (failure) {
        emit(state.copyWith(actionStatus: VacanciesStatus.failure, actionErrorMessage: failure.message));
      },
      (vacancy) {
        final updatedVacancies = state.vacancies.map((v) => v.id == vacancy.id ? vacancy : v).toList();
        emit(state.copyWith(actionStatus: VacanciesStatus.success, vacancies: updatedVacancies));
      },
    );
  }

  Future<void> _onChangeVacancyStatus(ChangeVacancyStatus event, Emitter<VacanciesState> emit) async {
    emit(state.copyWith(actionStatus: VacanciesStatus.loading));
    final result = await repository.changeVacancyStatus(event.id, event.status);
    result.fold(
      (failure) {
        emit(state.copyWith(actionStatus: VacanciesStatus.failure, actionErrorMessage: failure.message));
      },
      (_) {
        final updatedVacancies = state.vacancies.map((v) {
          if (v.id == event.id) {
            return Vacancy(
              id: v.id,
              title: v.title,
              position: v.position,
              description: v.description,
              workType: v.workType,
              salaryType: v.salaryType,
              salaryMin: v.salaryMin,
              salaryMax: v.salaryMax,
              experienceMin: v.experienceMin,
              experienceMax: v.experienceMax,
              requirements: v.requirements,
              schedule: v.schedule,
              status: event.status,
              viewsCount: v.viewsCount,
              applicationsCount: v.applicationsCount,
              employer: v.employer,
            );
          }
          return v;
        }).toList();
        emit(state.copyWith(actionStatus: VacanciesStatus.success, vacancies: updatedVacancies));
      },
    );
  }

  Future<void> _onDeleteVacancy(DeleteVacancy event, Emitter<VacanciesState> emit) async {
    emit(state.copyWith(actionStatus: VacanciesStatus.loading));
    final result = await repository.deleteVacancy(event.id);
    result.fold(
      (failure) {
        emit(state.copyWith(actionStatus: VacanciesStatus.failure, actionErrorMessage: failure.message));
      },
      (_) {
        final updatedVacancies = state.vacancies.where((v) => v.id != event.id).toList();
        emit(state.copyWith(actionStatus: VacanciesStatus.success, vacancies: updatedVacancies));
      },
    );
  }
}
